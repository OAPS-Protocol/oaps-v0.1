# Open Audit Proof Standard - Version 0.1

## 1. Preamble: A Protocol for Truth

This document defines the Open Audit Proof Standard (OAPS) v0.1. Its purpose is to establish a canonical, cryptographically-verifiable record of an audit's existence and content, independent of any judgment of quality.

An OAPS Proof is a **proof of fact, not a promise of safety**. It answers three questions:

1.  **Existence**: Did this audit exist at a specific time?
2.  **Integrity**: Has the audit record been altered?
3.  **Source**: Which auditor cryptographically attested to it?

## 2. Core Tenet: The Validity-Quality Distinction

**Validity ≠ Quality**

A **valid** OAPS proof guarantees the data's integrity and origin. It does **not** guarantee the audit's correctness, thoroughness, or the security of the audited system. This distinction is fundamental to the protocol's neutrality and defensibility.

## 3. The Proof Schema: A Deterministic Blueprint

### 3.1 Required Data Structure
The proof is a JSON object. The following schema is the single source of truth for canonicalization.

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
      "description": "The immutable OAPS specification version used."
    },
    "auditId": {
      "type": "string",
      "pattern": "^[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}$",
      "description": "A unique, version 4 UUID for this audit engagement."
    },
    "project": {
      "type": "object",
      "required": ["name", "address", "blockchain"],
      "properties": {
        "name": {
          "type": "string",
          "description": "The canonical name of the project."
        },
        "address": {
          "type": "string",
          "description": "The primary contract address (0x...) or project identifier."
        },
        "blockchain": {
          "type": "string",
          "pattern": "^[a-z][a-z0-9-]*$",
          "example": "ethereum",
          "description": "Lowercase blockchain identifier (e.g., 'ethereum', 'arbitrum-one')."
        }
      }
    },
    "auditor": {
      "type": "object",
      "required": ["id"],
      "properties": {
        "id": {
          "type": "string",
          "description": "The auditor's cryptographic identity (e.g., 0x... Ethereum address). This is the signing key. It is the only identity that matters on-chain."
        },
        "name": {
          "type": "string",
          "description": "Optional human-readable label. Not used in hashing or signature verification."
        }
      }
    },
    "auditScope": {
      "type": "object",
      "required": ["commitHash"],
      "properties": {
        "commitHash": {
          "type": "string",
          "pattern": "^[a-f0-9]{40}$",
          "description": "The full SHA-1 Git commit hash of the audited codebase."
        },
        "files": {
          "type": "array",
          "items": {
            "type": "object",
            "required": ["path", "hash"],
            "properties": {
              "path": { "type": "string" },
              "hash": { "type": "string", "pattern": "^[a-f0-9]{64}$" }
            }
          },
          "description": "Optional array of specific file paths and their SHA-256 hashes for granular verification."
        }
      }
    },
    "reportHash": {
      "type": "string",
      "pattern": "^[a-f0-9]{64}$",
      "description": "The SHA-256 hash of the final, publicly accessible audit report (e.g., PDF). This immutably links the proof to the human-readable document."
    },
    "timestamp": {
      "type": "string",
      "format": "date-time",
      "description": "ISO 8601 UTC timestamp (e.g., '2025-01-01T12:00:00Z') of proof generation."
    },
    "findingsSummary": {
      "type": "object",
      "properties": {
        "critical": { "type": "integer", "minimum": 0, "default": 0 },
        "high": { "type": "integer", "minimum": 0, "default": 0 },
        "medium": { "type": "integer", "minimum": 0, "default": 0 },
        "low": { "type": "integer", "minimum": 0, "default": 0 },
        "informational": { "type": "integer", "minimum": 0, "default": 0 }
      },
      "description": "OPTIONAL. Summary counts. Included for indexing only. Does NOT imply completeness or accuracy and is NOT a trust signal."
    }
  }
}

4. The Canon: Rules for Deterministic Hashing

To ensure global consensus on a proof's cryptographic fingerprint, the JSON object MUST be serialized into an identical string by all parties. The rules are absolute:

1. Encoding: UTF-8.
2. Key Ordering: All object members (including nested objects) are ordered lexicographically by their Unicode code points.
3. Whitespace: No spaces, line breaks, or indentation outside of string values.
4. Numerals: Integers are serialized without leading zeros, decimal points, or exponent notation. Floating-point numbers are prohibited in required fields.
5. Strings: Escaped according to JSON standards (e.g., \", \\, \n).

Example Pseudocode:

```javascript
function canonicalize(proofObject) {
    return JSON.stringify(proofObject, Object.keys(proofObject).sort(), '');
}
```

5. Cryptographic Identity & On-Chain Record

5.1 The Proof Hash

The unique identifier of an audit proof is defined as:

```
proofHash = keccak256(utf8.encode(canonicalizedProofJsonString))
```

5.2 The On-Chain Tuple

The OAPS Registry stores the minimum data required for verification:

```
struct ProofRecord {
    bytes32 proofHash;
    address auditor; // The `auditor.id` as an Ethereum address
    address submitter;
    uint256 timestamp; // Block timestamp of registration
}
```

5.3 Workflow

1. Generate: The auditor creates the JSON object, canonicalizes it, and computes the proofHash.
2. Sign: The auditor signs the proofHash with the private key corresponding to auditor.id.
3. Register: The proofHash and signature are submitted to the OAPS Registry. The registry verifies the signature matches auditor.id and records the hash.

6. Independent Verification Protocol

Any third party can verify a claim without trusting the OAPS organization:

1. Acquire Data: Obtain the original audit report and public metadata (project name, commit hash, etc.).
2. Reconstruct: Build the proof JSON from primary sources.
3. Recompute: Canonicalize and hash the JSON to produce calculatedHash.
4. Query: Call getProof(calculatedHash) on the OAPS Registry.
5. Verify: Confirm the registry returns a valid ProofRecord where record.auditor matches the claimed public key.
6. (Optional) Validate: Check that the reportHash matches the downloaded report, and the commitHash exists in the project's public repository.

7. Security Considerations & Attack Mitigations

· Replay Attacks: The auditId (UUID) ensures the same proof cannot be registered twice. The registry's mapping from proofHash to record is unique.
· Misrepresentation: Auditors are responsible for the accuracy of the data in the JSON. The findingsSummary is optional and informational only to prevent it from being used as a trust metric.
· Signature Malleability: The registry must use a signature verification method that is not susceptible to malleability (e.g., ECDSA with proper recovery).
· Data Availability: The audit report (reportHash source) and code (commitHash) must remain publicly accessible for verification. OAPS does not guarantee data availability.

8. Versioning & Governance

This is specification v0.1.0.

· Patch Versions (0.1.x): Backward-compatible clarifications or bug fixes.
· Minor Versions (0.x.0): Backward-compatible additions (e.g., new optional fields).
· Major Versions (x.0.0): Breaking changes that require a new registry and migration.

Amendments to this specification will follow the OAPS Improvement Proposal (OIP) process, governed by the protocol's Charter to ensure neutrality and anti-capture.

---

Footnotes:

1. All hashes are represented as lowercase hexadecimal strings without the 0x prefix in the JSON schema. The keccak256 function expects a raw byte array.
2. The blockchain identifier should follow the Chainlist naming convention where applicable.
3. This document is the protocol. Implementations must adhere to it exactly to achieve interoperability.
