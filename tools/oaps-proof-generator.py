#!/usr/bin/env python3
"""
OAPS v0.1 Proof Hash Generator
This script canonicalizes a JSON proof according to the OAPS spec and outputs its keccak256 hash.
"""

import json
import hashlib
import sys

def canonicalize(json_dict: dict) -> str:
    """Canonicalizes a JSON object: sorts keys and removes whitespace."""
    return json.dumps(json_dict, sort_keys=True, separators=(",", ":"))

def generate_proof_hash(proof_file_path: str) -> str:
    """Loads a proof JSON file, canonicalizes it, and returns the keccak256 hash."""
    with open(proof_file_path, 'r') as f:
        proof_data = json.load(f)

    canonical_string = canonicalize(proof_data)
    # Calculate keccak256 hash (using web3 if available, otherwise pure Python)
    try:
        from web3 import Web3
        proof_hash = Web3.keccak(text=canonical_string).hex()
    except ImportError:
        # Fallback: pure Python keccak256
        import sha3
        k = sha3.keccak_256()
        k.update(canonical_string.encode('utf-8'))
        proof_hash = '0x' + k.hexdigest()

    return proof_hash, canonical_string

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python oaps-proof-generator.py <path_to_proof.json>")
        sys.exit(1)

    input_file = sys.argv[1]
    try:
        hash_hex, canonical_json = generate_proof_hash(input_file)
        print("\n✅ OAPS Proof Hash Generated:")
        print(f"📄 Input File: {input_file}")
        print(f"🔢 Keccak256 Hash: {hash_hex}")
        print(f"📝 Canonical JSON (first 200 chars): {canonical_json[:200]}...")
    except Exception as e:
        print(f"\n❌ Error: {e}")
        sys.exit(1)
