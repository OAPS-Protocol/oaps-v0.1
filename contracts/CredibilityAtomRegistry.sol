// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

/**
 * @title CredibilityAtomRegistry
 * @dev Core Layer A settlement contract for the OAPS Protocol. Implements CAS-001.
 * Enforces the Credibility Atom lifecycle: Pending -> Challenged -> Finalized/Economically Rejected.
 * This contract is intentionally neutral—it settles bonds, not truth.
 */
contract CredibilityAtomRegistry is Ownable, ReentrancyGuard {
    /* ========== STATE & STRUCTS (CAS-001 Sec 4, 5.1) ========== */

    /**
     * @dev Represents the state of a Credibility Atom.
     */
    enum AtomState {
        PENDING,    // Awaiting challenge
        CHALLENGED, // In dispute
        FINALIZED,  // Accepted
        ECONOMICALLY_REJECTED // Invalidated
    }

    /**
     * @dev Core on-chain record of a Credibility Atom.
     * Mirrors the off-chain Economic Metadata commitment.
     */
    struct AtomRecord {
        bytes32 atomHash; // keccak256 commitment (CAS-001 4.3)
        address agent;    // Submitting agent (agentAddress)
        uint256 submissionBond;
        uint256 challengeBond; // Bond posted by challenger, if any
        uint256 challengeWindowEnds; // Timestamp
        AtomState state;
        address challenger; // Address of challenger, if any
        address disputeResolver; // Address of resolver contract
    }

    /* ========== STATE VARIABLES & CONSTANTS (CAS-001 Sec 7.3) ========== */
    
    // Minimum bond size (1 ETH). Defends against Sybil attacks.
    uint256 public constant MIN_SUBMISSION_BOND = 1 ether;
    // Challenge bond must equal submission bond (1:1 ratio).
    uint256 public constant CHALLENGE_BOND_RATIO = 1; 
    // Minimum challenge window (24 hours).
    uint256 public constant MIN_CHALLENGE_WINDOW = 24 hours;
    // Maximum challenge window (7 days).
    uint256 public constant MAX_CHALLENGE_WINDOW = 7 days;

    // Mapping from atomHash to its full record.
    mapping(bytes32 => AtomRecord) public atoms;
    // Tracks agent's locked bonds for safe withdrawals.
    mapping(address => uint256) public lockedBonds;

    /* ========== EVENTS (For Layer B Oracle Consumption) ========== */

    /**
     * @dev Emitted when a new Credibility Atom is submitted.
     */
    event AtomSubmitted(
        bytes32 indexed atomHash,
        address indexed agent,
        uint256 bond,
        uint256 challengeWindowEnds,
        address disputeResolver
    );

    /**
     * @dev Emitted when an Atom is successfully challenged.
     */
    event AtomChallenged(
        bytes32 indexed atomHash,
        address indexed challenger,
        uint256 challengeBond
    );

    /**
     * @dev Emitted when an Atom is finalized (no challenge or submitter wins dispute).
     */
    event AtomFinalized(bytes32 indexed atomHash);

    /**
     * @dev Emitted when an Atom is economically rejected (challenger wins dispute).
     */
    event AtomRejected(bytes32 indexed atomHash);

    /**
     * @dev Emitted when a dispute resolver contract is set for an Atom.
     */
    event DisputeResolved(
        bytes32 indexed atomHash,
        address indexed resolver,
        bool inFavorOfSubmitter // true = submitter wins, false = challenger wins
    );

    /* ========== MODIFIERS ========== */

    /**
     * @dev Ensures the atom exists and is in the expected state.
     */
    modifier atomExists(bytes32 atomHash) {
        require(atoms[atomHash].agent != address(0), "Atom does not exist");
        _;
    }

    modifier inState(bytes32 atomHash, AtomState expectedState) {
        require(atoms[atomHash].state == expectedState, "Invalid atom state");
        _;
    }

    /* ========== CORE FUNCTIONS (CAS-001 Sec 6) ========== */

    /**
     * @notice Submits a Credibility Atom, locking the submission bond.
     * @dev Called by the Agent. Requires a signature over the atomHash.
     * @param atomHash The keccak256 hash of the Atom's Economic Metadata.
     * @param signature The agent's signature over the atomHash.
     * @param challengeWindowSeconds Duration the atom can be challenged.
     * @param disputeResolver Address of the dispute resolution contract.
     */
    function submitAtom(
        bytes32 atomHash,
        bytes calldata signature,
        uint256 challengeWindowSeconds,
        address disputeResolver
    ) external payable nonReentrant {
        // CHECKS
        require(atoms[atomHash].agent == address(0), "Atom already registered");
        require(msg.value >= MIN_SUBMISSION_BOND, "Bond below minimum");
        require(
            challengeWindowSeconds >= MIN_CHALLENGE_WINDOW &&
            challengeWindowSeconds <= MAX_CHALLENGE_WINDOW,
            "Invalid challenge window"
        );
        require(disputeResolver != address(0), "Invalid dispute resolver");

        // Verify the signature (agent is the signer)
        address signer = _recoverSigner(atomHash, signature);
        require(signer == msg.sender, "Invalid signature");

        // EFFECTS
        uint256 challengeWindowEnds = block.timestamp + challengeWindowSeconds;

        atoms[atomHash] = AtomRecord({
            atomHash: atomHash,
            agent: msg.sender,
            submissionBond: msg.value,
            challengeBond: 0,
            challengeWindowEnds: challengeWindowEnds,
            state: AtomState.PENDING,
            challenger: address(0),
            disputeResolver: disputeResolver
        });

        lockedBonds[msg.sender] += msg.value;

        // INTERACTIONS (none beyond ETH locking)

        emit AtomSubmitted(
            atomHash,
            msg.sender,
            msg.value,
            challengeWindowEnds,
            disputeResolver
        );
    }

    /**
     * @notice Challenges a pending Atom by posting an equal bond.
     * @dev Can be called by anyone before the challenge window closes.
     * @param atomHash The hash of the Atom to challenge.
     */
    function challengeAtom(bytes32 atomHash)
        external
        payable
        nonReentrant
        atomExists(atomHash)
        inState(atomHash, AtomState.PENDING)
    {
        AtomRecord storage atom = atoms[atomHash];

        require(block.timestamp < atom.challengeWindowEnds, "Challenge window closed");
        require(msg.value == atom.submissionBond, "Challenge bond mismatch");

        // EFFECTS
        atom.state = AtomState.CHALLENGED;
        atom.challenger = msg.sender;
        atom.challengeBond = msg.value;
        lockedBonds[msg.sender] += msg.value;

        emit AtomChallenged(atomHash, msg.sender, msg.value);
    }

    /**
     * @notice Finalizes an Atom. Called by the dispute resolver contract OR after window closes.
     * @dev Resolves the atom's state and distributes bonds accordingly.
     * @param atomHash The hash of the Atom to finalize.
     * @param inFavorOfSubmitter The outcome of the dispute (true = submitter wins).
     */
    function resolveAtom(bytes32 atomHash, bool inFavorOfSubmitter)
        external
        nonReentrant
        atomExists(atomHash)
    {
        AtomRecord storage atom = atoms[atomHash];
        // Only the designated dispute resolver or the system (after expiry) can call.
        require(
            msg.sender == atom.disputeResolver ||
            (msg.sender == address(this) && atom.state == AtomState.PENDING && block.timestamp >= atom.challengeWindowEnds),
            "Not authorized"
        );

        AtomState oldState = atom.state;
        require(
            oldState == AtomState.PENDING || oldState == AtomState.CHALLENGED,
            "Atom already resolved"
        );

        address bondRecipient;
        uint256 bondAmount;

        // LOGIC for PENDING atoms (no challenge)
        if (oldState == AtomState.PENDING) {
            require(block.timestamp >= atom.challengeWindowEnds, "Window still active");
            // No challenge -> finalize, return bond to submitter
            atom.state = AtomState.FINALIZED;
            bondRecipient = atom.agent;
            bondAmount = atom.submissionBond;
            emit AtomFinalized(atomHash);
        }
        // LOGIC for CHALLENGED atoms (dispute resolution)
        else if (oldState == AtomState.CHALLENGED) {
            emit DisputeResolved(atomHash, msg.sender, inFavorOfSubmitter);

            if (inFavorOfSubmitter) {
                // Submitter wins, challenger loses bond
                atom.state = AtomState.FINALIZED;
                bondRecipient = atom.agent; // Submitter gets their bond + challenger's bond
                bondAmount = atom.submissionBond + atom.challengeBond;
                // Slash challenger's locked bond record
                lockedBonds[atom.challenger] -= atom.challengeBond;
                emit AtomFinalized(atomHash);
            } else {
                // Challenger wins, submitter loses bond
                atom.state = AtomState.ECONOMICALLY_REJECTED;
                bondRecipient = atom.challenger; // Challenger gets their bond + submitter's bond
                bondAmount = atom.submissionBond + atom.challengeBond;
                // Slash submitter's locked bond record
                lockedBonds[atom.agent] -= atom.submissionBond;
                emit AtomRejected(atomHash);
            }
        }

        // EFFECTS: Update locked bonds for the recipient
        if (bondRecipient == atom.agent) {
            lockedBonds[bondRecipient] -= atom.submissionBond;
        }
        // INTERACTIONS: Transfer the total bond amount
        if (bondAmount > 0) {
            (bool success, ) = bondRecipient.call{value: bondAmount}("");
            require(success, "Bond transfer failed");
        }
    }

    /**
     * @notice Public function to finalize an unchallenged Atom after its window expires.
     * @dev Anyone can call this to trigger the resolution.
     * @param atomHash The hash of the Atom to finalize.
     */
    function finalizeIfUnchallenged(bytes32 atomHash)
        external
        atomExists(atomHash)
        inState(atomHash, AtomState.PENDING)
    {
        require(block.timestamp >= atoms[atomHash].challengeWindowEnds, "Window still active");
        // Call the internal resolve logic
        this.resolveAtom(atomHash, true); // inFavorOfSubmitter is true for no challenge
    }

    /* ========== VIEW FUNCTIONS ========== */

    /**
     * @notice Gets the full record for an Atom.
     */
    function getAtom(bytes32 atomHash) external view returns (AtomRecord memory) {
        return atoms[atomHash];
    }

    /**
     * @notice Checks if an Atom is still pending and within its challenge window.
     */
    function isChallengeable(bytes32 atomHash) external view returns (bool) {
        AtomRecord storage atom = atoms[atomHash];
        return atom.state == AtomState.PENDING && block.timestamp < atom.challengeWindowEnds;
    }

    /* ========== INTERNAL FUNCTIONS ========== */

    /**
     * @dev Recovers the signer address from a hash and signature.
     */
    function _recoverSigner(bytes32 hash, bytes memory signature) internal pure returns (address) {
        require(signature.length == 65, "Invalid signature length");

        bytes32 r;
        bytes32 s;
        uint8 v;

        assembly {
            r := mload(add(signature, 32))
            s := mload(add(signature, 64))
            v := byte(0, mload(add(signature, 96)))
        }

        if (v < 27) {
            v += 27;
        }

        require(v == 27 || v == 28, "Invalid signature v value");

        return ecrecover(hash, v, r, s);
    }

    /* ========== ADDITIONAL SAFETY (Optional) ========== */
    // Consider adding emergency pause, bond withdrawal functions, etc.
}
