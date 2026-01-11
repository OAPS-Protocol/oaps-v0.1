# Open Audit Proof Standard - Version 0.1

## 1. Overview
An OAPS Proof is a JSON document that provides a canonical summary of a security audit, designed to be deterministically hashed and registered on-chain. Its core purpose is to provide **immutable proof of an audit's existence and content**, separate from subjective quality judgments.

## 2. Core Principle: Validity ≠ Quality
An OAPS proof cryptographically verifies that a specific audit report exists and is unchanged. It does **not** guarantee the report's correctness, the auditor's skill, or the system's security. Trust is layered separately via the Accreditation Layer (Layer B).

## 3. Proof JSON Schema
The proof is a JSON object conforming to the following schema.

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "title": "OAPS Proof v0.1",
  "type": "object",
  "required": [
    "oapsVersion",
    "auditId",
    "project",
    "auditor",
    "auditScope",
    "reportHash",
    "timestamp"
  ],
  "properties": {
    "oapsVersion": {
      "type": "string",
      "const": "0.1.0",
      "description": "The OAPS specification version used to generate this proof."
    },
    "auditId": {
      "type": "string",
      "pattern": "^[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}$",
      "description": "A unique UUID v4 for this specific audit engagement."
    },
    "project": {
      "type": "object",
      "required": ["name", "address", "blockchain"],
      "properties": {
        "name": { "type": "string" },
        "address": { 
          "type": "string",
          "description": "The main contract address or project identifier that was audited."
        },
        "blockchain": { 
          "type": "string", 
          "pattern": "^[a-z]+$",
          "example": "ethereum",
          "description": "The blockchain network identifier (lowercase)."
        }
      }
    },
    "auditor": {
      "type": "object",
      "required": ["id"],
      "properties": {
        "id": { 
          "type": "string", 
          "description": "The auditor's cryptographic identifier (e.g., an Ethereum address or DID). This is their signing key."
        },
        "name": { 
          "type": "string",
          "description": "Optional: A human-readable name for display."
        }
      }
    },
    "auditScope": {
      "type": "object",
      "required": ["commitHash"],
      "properties": {
        "commitHash": { 
          "type": "string", 
          "description": "The Git commit hash (SHA-1) of the exact code revision that was audited."
        },
        "fileHashes": {
          "type": "array",
          "items": { "type": "string" },
          "description": "Optional: An array of SHA-256 hashes of individual audited source files, for granular verification."
        }
      }
    },
    "reportHash": {
      "type": "string",
      "description": "The SHA-256 hash of the final, publicly available audit report (e.g., PDF file). This links the proof to the human-readable document."
    },
    "timestamp": {
      "type": "string",
      "format": "date-time",
      "description": "ISO 8601 timestamp (e.g., '2025-01-01T12:00:00Z') of when this proof was generated."
    },
    "findingsSummary": {
      "type": "object",
      "properties": {
        "critical": { "type": "integer", "minimum": 0 },
        "high": { "type": "integer", "minimum": 0 },
        "medium": { "type": "integer", "minimum": 0 },
        "low": { "type": "integer", "minimum": 0 }
      },
      "description": "Optional: A summary count of findings by severity level. Provided for informational indexing only, not for trust."
    }
  }
}

4. Canonicalization & Hashing

To ensure the same data always produces the same hash (determinism), the JSON proof MUST be canonicalized before hashing using the following rules:

1. Key Ordering: All object keys must be sorted lexicographically (alphabetically).
2. Formatting: No unnecessary whitespace, line breaks, or indentation.
3. Encoding: UTF-8 encoding must be used.
4. Number Representation: Numbers must be represented in their most basic form (no leading zeros, etc.).

The Proof Hash is defined as:
proofHash = keccak256(canonicalizedProofJsonString)

5. Proof Generation Workflow

1. Complete Audit: Finalize the security review and the public report.
2. Prepare Data: Populate the JSON proof object according to the schema.
3. Canonicalize: Serialize the JSON object into a string using the canonicalization rules above.
4. Hash: Compute the proofHash using the Keccak-256 algorithm on the canonical string.
5. Sign: The auditor cryptographically signs the proofHash with their private key.
6. Register: Submit the tuple (proofHash, auditorSignature) to the OAPS Registry smart contract.

6. Verification Workflow

Any third party can independently verify a proof:

1. Fetch Public Data: Obtain the original audit report and the audit metadata (project name, commit hash, etc.).
2. Reconstruct Proof: Build the proof JSON object from the public data.
3. Re-canonicalize & Hash: Canonicalize the JSON and compute the hash.
4. Check Registry: Query the OAPS Registry to confirm the computed hash is registered.
5. Verify Signature: Confirm the on-chain signature matches the auditor's public key (auditor.id).

7. Versioning & Amendments

This is OAPS version 0.1.0. Changes to the required fields or the canonicalization process will constitute a major version bump and must be backward-compatible or come with a clear migration path. Amendments will be governed by the protocol's Improvement Proposal (OIP) process.
