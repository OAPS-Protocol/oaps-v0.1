# Open Audit Proof Standard (OAPS) v0.1

## Purpose
The Open Audit Proof Standard (OAPS) provides a canonical, machine-readable, and cryptographically verifiable format for publishing the results of a smart contract security audit. It separates **proof of existence** from **judgment of quality**.

## Core Principle: Validity ≠ Quality
An OAPS proof validates that a specific audit report exists and is unchanged. It does **not** guarantee the report's correctness, the auditor's skill, or the system's security. Trust is layered separately via the Accreditation Layer.

## 📄 Specification
The complete technical standard is defined in **[SPECIFICATION.md](./SPECIFICATION.md)**.

## 🏛️ Governance & Funding
This protocol is governed by a strict **Funding & Independence Charter** (to be published) to ensure permanent neutrality and anti-capture. It is maintained by the OAPS-Protocol organization.

## 🚀 Getting Started (For Auditors)
1.  Review the [specification](./SPECIFICATION.md) for the proof JSON schema.
2.  Use the forthcoming reference tools to canonicalize and hash your proof.
3.  Submit the proof hash and signature to the OAPS Registry (in development).

## 🔗 Related Components
*   **Registry Smart Contract**: (Coming Soon) The on-chain ledger for proof hashes.
*   **Accreditation Framework**: (Layer B - Coming Soon) The decentralized trust layer.
*   **Tools & Implementations**: (Coming Soon) Reference libraries for proof generation.
