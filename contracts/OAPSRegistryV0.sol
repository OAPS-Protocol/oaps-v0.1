// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title OAPS Registry - Version 0
 * @notice A minimalist, initial registry for storing hashes of OAPS v0.1 audit proofs.
 * @dev This contract is immutable once deployed. Upgrades require a new contract and state migration.
 */
contract OAPSRegistryV0 {
    /// @dev Emitted when a new proof is registered.
    event ProofRegistered(bytes32 indexed proofHash, address indexed auditor, uint256 timestamp);

    /// @dev Mapping to store registration timestamp by proofHash. A timestamp >0 indicates existence.
    mapping(bytes32 => uint256) public registrationTime;

    /**
     * @notice Registers an OAPS proof hash.
     * @param _proofHash The keccak256 hash of the canonicalized OAPS proof JSON.
     * @param _signature The auditor's ECDSA signature over the `_proofHash`.
     * @return bool True if registration was successful.
     * @dev The signer of the signature becomes the recorded 'auditor' for this proof.
     */
    function registerProof(bytes32 _proofHash, bytes calldata _signature) external returns (bool) {
        // Prevent duplicate registration
        require(registrationTime[_proofHash] == 0, "OAPS: Proof already registered");

        // Recover the signer address from the hash and signature
        address auditor = _recoverSigner(_proofHash, _signature);

        // Store the registration timestamp (using block.timestamp is sufficient for v0)
        registrationTime[_proofHash] = block.timestamp;

        // Emit the event for off-chain tracking
        emit ProofRegistered(_proofHash, auditor, block.timestamp);

        return true;
    }

    /**
     * @notice Verifies if a proof hash is registered and returns its timestamp.
     * @param _proofHash The proof hash to check.
     * @return uint256 The registration timestamp, or 0 if not found.
     */
    function verifyProof(bytes32 _proofHash) external view returns (uint256) {
        return registrationTime[_proofHash];
    }

    /**
     * @dev Internal helper to recover the signer address from a hash and signature.
     */
    function _recoverSigner(bytes32 _hash, bytes memory _signature) internal pure returns (address) {
        require(_signature.length == 65, "OAPS: Invalid signature length");

        bytes32 r;
        bytes32 s;
        uint8 v;

        // Split the signature into its components (r, s, v)
        assembly {
            r := mload(add(_signature, 32))
            s := mload(add(_signature, 64))
            v := byte(0, mload(add(_signature, 96)))
        }

        // Handle EIP-155 style signatures (v = 27 or 28)
        if (v < 27) {
            v += 27;
        }
        require(v == 27 || v == 28, "OAPS: Invalid signature 'v' value");

        // Return the recovered address
        return ecrecover(_hash, v, r, s);
    }
}
