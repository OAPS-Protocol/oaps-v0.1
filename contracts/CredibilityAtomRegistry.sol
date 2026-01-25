// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title CredibilityAtomRegistryV1
 * @author OAPS Protocol
 *
 * @notice
 * Layer A Settlement Contract for the OAPS Protocol.
 *
 * This contract enforces the lifecycle of a Credibility Atom:
 *
 *   PENDING → CHALLENGED → FINALIZED | ECONOMICALLY_REJECTED
 *
 * ⚠️ This contract does NOT determine truth.
 * It deterministically settles economic incentives.
 *
 * Implements CAS-001 (V1).
 */

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract CredibilityAtomRegistryV1 is Ownable, ReentrancyGuard {
    /*//////////////////////////////////////////////////////////////
                                TYPES
    //////////////////////////////////////////////////////////////*/

    enum AtomState {
        PENDING,
        CHALLENGED,
        FINALIZED,
        ECONOMICALLY_REJECTED
    }

    struct AtomRecord {
        bytes32 atomHash;               // Commitment hash (off-chain metadata)
        address agent;                  // Submitting agent
        uint256 submissionBond;         // Agent stake
        uint256 challengeBond;          // Challenger stake
        uint256 challengeWindowEnds;    // Timestamp
        AtomState state;                // Current lifecycle state
        address challenger;             // Challenger address (if any)
        address disputeResolver;        // Resolver contract
    }

    /*//////////////////////////////////////////////////////////////
                             CONSTANTS
    //////////////////////////////////////////////////////////////*/

    uint256 public constant MIN_SUBMISSION_BOND = 1 ether;
    uint256 public constant MIN_CHALLENGE_WINDOW = 24 hours;
    uint256 public constant MAX_CHALLENGE_WINDOW = 7 days;

    /*//////////////////////////////////////////////////////////////
                              STORAGE
    //////////////////////////////////////////////////////////////*/

    mapping(bytes32 => AtomRecord) private _atoms;
    mapping(address => uint256) public lockedBonds;

    /*//////////////////////////////////////////////////////////////
                                EVENTS
    //////////////////////////////////////////////////////////////*/

    event AtomSubmitted(
        bytes32 indexed atomHash,
        address indexed agent,
        uint256 bond,
        uint256 challengeWindowEnds,
        address indexed disputeResolver
    );

    event AtomChallenged(
        bytes32 indexed atomHash,
        address indexed challenger,
        uint256 bond
    );

    event AtomFinalized(bytes32 indexed atomHash);
    event AtomRejected(bytes32 indexed atomHash);

    event DisputeResolved(
        bytes32 indexed atomHash,
        address indexed resolver,
        bool submitterWins
    );

    /*//////////////////////////////////////////////////////////////
                              MODIFIERS
    //////////////////////////////////////////////////////////////*/

    modifier atomExists(bytes32 atomHash) {
        require(_atoms[atomHash].agent != address(0), "ATOM_NOT_FOUND");
        _;
    }

    modifier inState(bytes32 atomHash, AtomState expected) {
        require(_atoms[atomHash].state == expected, "INVALID_STATE");
        _;
    }

    /*//////////////////////////////////////////////////////////////
                        CORE — SUBMISSION
    //////////////////////////////////////////////////////////////*/

    function submitAtom(
        bytes32 atomHash,
        bytes calldata signature,
        uint256 challengeWindowSeconds,
        address disputeResolver
    ) external payable nonReentrant {
        require(_atoms[atomHash].agent == address(0), "ATOM_ALREADY_EXISTS");
        require(msg.value >= MIN_SUBMISSION_BOND, "INSUFFICIENT_BOND");
        require(
            challengeWindowSeconds >= MIN_CHALLENGE_WINDOW &&
            challengeWindowSeconds <= MAX_CHALLENGE_WINDOW,
            "INVALID_WINDOW"
        );
        require(disputeResolver != address(0), "INVALID_RESOLVER");

        address signer = _recoverSigner(
            _toEthSignedMessage(atomHash),
            signature
        );

        require(signer == msg.sender, "BAD_SIGNATURE");

        uint256 windowEnds = block.timestamp + challengeWindowSeconds;

        _atoms[atomHash] = AtomRecord({
            atomHash: atomHash,
            agent: msg.sender,
            submissionBond: msg.value,
            challengeBond: 0,
            challengeWindowEnds: windowEnds,
            state: AtomState.PENDING,
            challenger: address(0),
            disputeResolver: disputeResolver
        });

        lockedBonds[msg.sender] += msg.value;

        emit AtomSubmitted(
            atomHash,
            msg.sender,
            msg.value,
            windowEnds,
            disputeResolver
        );
    }

    /*//////////////////////////////////////////////////////////////
                        CORE — CHALLENGE
    //////////////////////////////////////////////////////////////*/

    function challengeAtom(bytes32 atomHash)
        external
        payable
        nonReentrant
        atomExists(atomHash)
        inState(atomHash, AtomState.PENDING)
    {
        AtomRecord storage atom = _atoms[atomHash];

        require(block.timestamp < atom.challengeWindowEnds, "WINDOW_CLOSED");
        require(msg.value == atom.submissionBond, "BOND_MISMATCH");

        atom.state = AtomState.CHALLENGED;
        atom.challenger = msg.sender;
        atom.challengeBond = msg.value;

        lockedBonds[msg.sender] += msg.value;

        emit AtomChallenged(atomHash, msg.sender, msg.value);
    }

    /*//////////////////////////////////////////////////////////////
                    CORE — RESOLUTION & FINALITY
    //////////////////////////////////////////////////////////////*/

    function resolveAtom(bytes32 atomHash, bool submitterWins)
        external
        nonReentrant
        atomExists(atomHash)
    {
        AtomRecord storage atom = _atoms[atomHash];

        require(
            msg.sender == atom.disputeResolver ||
            (
                msg.sender == address(this) &&
                atom.state == AtomState.PENDING &&
                block.timestamp >= atom.challengeWindowEnds
            ),
            "UNAUTHORIZED"
        );

        require(
            atom.state == AtomState.PENDING ||
            atom.state == AtomState.CHALLENGED,
            "ALREADY_RESOLVED"
        );

        if (atom.state == AtomState.PENDING) {
            _finalizeUnchallenged(atomHash);
            return;
        }

        emit DisputeResolved(atomHash, msg.sender, submitterWins);

        uint256 totalBond = atom.submissionBond + atom.challengeBond;
        address recipient;

        if (submitterWins) {
            atom.state = AtomState.FINALIZED;
            recipient = atom.agent;

            lockedBonds[atom.challenger] -= atom.challengeBond;
            lockedBonds[atom.agent] -= atom.submissionBond;

            emit AtomFinalized(atomHash);
        } else {
            atom.state = AtomState.ECONOMICALLY_REJECTED;
            recipient = atom.challenger;

            lockedBonds[atom.agent] -= atom.submissionBond;
            lockedBonds[atom.challenger] -= atom.challengeBond;

            emit AtomRejected(atomHash);
        }

        _safeTransferETH(recipient, totalBond);
    }

    function finalizeIfUnchallenged(bytes32 atomHash)
        external
        atomExists(atomHash)
        inState(atomHash, AtomState.PENDING)
    {
        require(block.timestamp >= _atoms[atomHash].challengeWindowEnds, "WINDOW_ACTIVE");
        this.resolveAtom(atomHash, true);
    }

    /*//////////////////////////////////////////////////////////////
                            VIEW FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    function getAtom(bytes32 atomHash)
        external
        view
        returns (AtomRecord memory)
    {
        return _atoms[atomHash];
    }

    function isChallengeable(bytes32 atomHash)
        external
        view
        returns (bool)
    {
        AtomRecord storage atom = _atoms[atomHash];
        return
            atom.state == AtomState.PENDING &&
            block.timestamp < atom.challengeWindowEnds;
    }

    /*//////////////////////////////////////////////////////////////
                        INTERNAL UTILITIES
    //////////////////////////////////////////////////////////////*/

    function _finalizeUnchallenged(bytes32 atomHash) internal {
        AtomRecord storage atom = _atoms[atomHash];

        atom.state = AtomState.FINALIZED;
        lockedBonds[atom.agent] -= atom.submissionBond;

        emit AtomFinalized(atomHash);

        _safeTransferETH(atom.agent, atom.submissionBond);
    }

    function _safeTransferETH(address to, uint256 amount) internal {
        (bool success, ) = to.call{value: amount}("");
        require(success, "ETH_TRANSFER_FAILED");
    }

    function _toEthSignedMessage(bytes32 hash)
        internal
        pure
        returns (bytes32)
    {
        return keccak256(
            abi.encodePacked(
                "\x19Ethereum Signed Message:\n32",
                hash
            )
        );
    }

    function _recoverSigner(bytes32 hash, bytes memory sig)
        internal
        pure
        returns (address)
    {
        require(sig.length == 65, "BAD_SIGNATURE_LENGTH");

        bytes32 r;
        bytes32 s;
        uint8 v;

        assembly {
            r := mload(add(sig, 32))
            s := mload(add(sig, 64))
            v := byte(0, mload(add(sig, 96)))
        }

        if (v < 27) v += 27;
        require(v == 27 || v == 28, "BAD_V");

        return ecrecover(hash, v, r, s);
    }
}