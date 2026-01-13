# Open Audit Proof Standard (OAPS) v0.1
**OAPS is the on-chain proof layer for crypto audits — making audit reports verifiable, timestamped, and impossible to fake.**

## Why OAPS Exists

Most crypto audits are published as static PDFs that cannot be independently verified, timestamped, or cryptographically linked to an auditor.

OAPS introduces a neutral, protocol-level standard that allows anyone to verify:
- that an audit report existed at a specific time,
- that it has not been altered,
- and which auditor cryptographically signed it.

OAPS does not replace auditors.  
It replaces **unverifiable audit claims**.

## What OAPS Does
The Open Audit Proof Standard (OAPS) provides a canonical, machine-readable, and cryptographically verifiable format for publishing the results of a smart contract security audit. It separates **proof of existence** from **judgment of quality**.

## What OAPS Is NOT

- OAPS is NOT an audit firm  
- OAPS does NOT certify project safety  
- OAPS does NOT guarantee correctness or prevent fraud  
- OAPS does NOT provide investment advice  

OAPS verifies proofs — not promises.

## Core Principle: Validity ≠ Quality
An OAPS proof validates that a specific audit report exists and is unchanged. It does **not** guarantee the report's correctness, the auditor's skill, or the system's security. Trust is layered separately via the Accreditation Layer.

## 📄 Specification
The complete technical standard is defined in **[SPECIFICATION.md](./SPECIFICATION.md)**.

## 🏛️ Governance & Funding
This protocol is governed by a strict **Funding & Independence Charter** (to be published) to ensure permanent neutrality and anti-capture. It is maintained by the OAPS-Protocol organization.

## 🚀 Getting Started (For Auditors & Projects)
1.  Review the [specification](./SPECIFICATION.md) for the proof JSON schema.
2.  Use the forthcoming reference tools to canonicalize and hash your proof.
3.  Submit the proof hash and signature to the OAPS Registry (in development).

## 🔗 Related Components
*   **Registry Smart Contract**: (Coming Soon) The on-chain ledger for proof hashes.
*   **Accreditation Framework**: (Layer B - Coming Soon) The decentralized trust layer.
*   **Tools & Implementations**: (Coming Soon) Reference libraries for proof generation.

# OAPS Protocol Deployments

## 🧪 Sepolia Testnet - Official Test Registry (v0.1)
**This is the official testnet registry for all OAPS v0.1 pilot audits and development.**

*   **Contract:** `OAPSRegistryV0`
*   **Address:** [`0x83e7593D3c8343437d92094d9485D6eDBfF89131`](https://sepolia.etherscan.io/address/0x83e7593D3c8343437d92094d9485D6eDBfF89131)
*   **Status:** **VERIFIED & ACTIVE**
*   **Note:** This contract is used for testing and pilot audits. All interactions require Sepolia test ETH.

## 🎯 Current Status (January 2026)

### ✅ OAPS v0.1 is LIVE and OPERATIONAL
- **Protocol Specification:** Complete and stable
- **Registry Contract:** [Verified on Sepolia](https://sepolia.etherscan.io/address/0x83e7593D3c8343437d92094d9485D6eDBfF89131)
- **Tools:** Proof generator and registration dApp working
- **First Proof:** Successfully registered on-chain ([View Transaction](https://sepolia.etherscan.io/tx/0x87045637eea366f13dd2e2df9dc29032f74583999ceb8d38fd129b6f6b05d6c4))

### 📚 Documentation
- [Getting Started Guide](GETTING_STARTED.md) - For auditors and projects
- [Milestones](MILESTONES.md) - Development progress and achievements
- [Specification](SPECIFICATION.md) - Technical standard definition

### 🚀 What's Next
- Pilot audit program with real projects
- Development of Accreditation Layer (Layer B)
- Shadow Operator formation for sustainable funding
