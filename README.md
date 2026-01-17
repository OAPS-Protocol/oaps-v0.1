# 🔐 OAPS Protocol (Open Audit Proof Standard) v0.1

**The neutral, verifiable proof registry for professional work on-chain** (audits, attestations, task execution, documentation).  
Immutable • Timestamped • Cryptographically Signed • Proof of Fact, Not Promise

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Status: v0.1 Live](https://img.shields.io/badge/Status-v0.1%20Live-brightgreen)](https://oaps-signer-dapp.vercel.app)
[![Network: Sepolia](https://img.shields.io/badge/Network-Sepolia-purple)](https://sepolia.etherscan.io/address/0x83e7593D3c8343437d92094d9485D6eDBfF89131)

## 🚀 Live dApp – Build Your First Proof

**[OAPS Proof Builder & Registry](https://oaps-signer-dapp.vercel.app)**  
Build, sign, and register immutable proofs of professional work on the Sepolia testnet.

## 📋 Quick Start

| **Role** | **Action** | **Link / Guide** |
| :--- | :--- | :--- |
| **Professionals** (Auditors, Analysts, Agents) | Build & Register a Proof | [Use Proof Builder](https://oaps-signer-dapp.vercel.app) |
| **Projects & Investors** | Verify a Registered Proof | [Registry on Etherscan](https://sepolia.etherscan.io/address/0x83e7593D3c8343437d92094d9485D6eDBfF89131) |
| **Developers & Integrators** | Read Technical Specification | [View Rendered Specification](https://github.com/OAPS-Protocol/oaps-v0.1/blob/main/SPECIFICATION.md) |
| **Everyone** | Step-by-Step Guides | [GETTING_STARTED.md](GETTING_STARTED.md) |
| **Progress** | Milestone Tracking | [MILESTONES.md](MILESTONES.md) |

## 🎯 Core Principle: Validity ≠ Quality

OAPS is a **neutral registry**. It verifies the **existence, integrity, and source** of a proof—not the quality or outcome of the work it represents. The protocol does not curate, approve, reject, or rate any proofs; it only enforces cryptographic and schema validity.

| **Validity (What OAPS Verifies)** | **Quality (What OAPS Does NOT Verify)** |
| :--- | :--- |
| ✅ Proof existence at a specific time | ❌ Correctness of findings or decisions |
| ✅ Data integrity (hash is unaltered) | ❌ Skill or competence of the attester |
| ✅ Cryptographic signature of the source | ❌ Safety or security of a system |
| ✅ Immutable, on-chain timestamp | ❌ Future performance or results |

## 🎪 Core Use Cases

OAPS provides foundational infrastructure for verifying professional work across the on-chain economy, starting with audits and extending to new verticals.

1.  **🔐 Audit & Security Proofs**: The foundational use case. Create immutable, timestamped records for code audits, penetration tests, and security reviews.
2.  **📚 Educational & Reference Proofs**: Document the verification of canonical design patterns, reference implementations, or best practice examples.
3.  **🏢 RWA & Compliance Attestations**: Tokenization projects can register immutable proofs for off-chain legal reviews, valuation reports, and regulatory compliance checks.
4.  **🤖 AI Agent Accountability**: Autonomous agents can register verifiable proofs of claimed task execution (existence and source only — not decision correctness), creating an immutable decision and action trail for accountability.

## 🏗️ Current Implementation – Live & Operational

| **Component** | **Status** | **Details / Link** |
| :--- | :--- | :--- |
| **Protocol Specification** | ✅ Complete | [View Rendered on GitHub](https://github.com/OAPS-Protocol/oaps-v0.1/blob/main/SPECIFICATION.md) |
| **Registry Smart Contract** | ✅ Verified | [Sepolia Etherscan](https://sepolia.etherscan.io/address/0x83e7593D3c8343437d92094d9485D6eDBfF89131) |
| **Proof Builder dApp** | ✅ Fully Functional | [Live dApp](https://oaps-signer-dapp.vercel.app) (source: `tools/`) |
| **Documentation Suite** | ✅ Complete | Guides, Milestones, and Full Specification |
| **Pilot Proofs** | ✅ Registered | [Guard Check Proof](https://sepolia.etherscan.io/tx/0x87045637eea366f13dd2e2df9dc29032f74583999ceb8d38fd129b6f6b05d6c4) • [State Machine Proof](https://sepolia.etherscan.io/tx/0xee9e28b54ceeb871e1279a5dcccf99ca540af0b3b16571ecc17c619c28b01f07) |

## 🧪 Deployment

**Sepolia Testnet (v0.1)** — Official pilot registry.

**Contract:** `OAPSRegistryV0`  
**Address:** `0x83e7593D3c8343437d92094d9485D6eDBfF89131`  
**Network:** Sepolia Testnet  
**Status:** VERIFIED & ACTIVE

🔗 [View on Etherscan](https://sepolia.etherscan.io/address/0x83e7593D3c8343437d92094d9485D6eDBfF89131) • [Read Contract](https://sepolia.etherscan.io/address/0x83e7593D3c8343437d92094d9485D6eDBfF89131#readContract) • [Write Contract](https://sepolia.etherscan.io/address/0x83e7593D3c8343437d92094d9485D6eDBfF89131#writeContract)

## 🗺️ Protocol Roadmap & Architecture

OAPS is being developed as a sustainable, three-layer public good.

**Layer A: Universal Proof Registry (The Protocol)**
*   The free, open-source, and neutral base layer.
*   Provides an immutable record of proof hashes, signatures, and timestamps.
*   **Status:** ✅ v0.1 Live on Sepolia.

**Layer B: Credibility Oracle (Derived Reputation)**
*   An opt-in, transparent layer that reads from Layer A to compute track records and attestation histories.
*   Provides data-driven insights, not qualitative ratings or guarantees.
*   **Status:** 🔄 Research & Design (Q1 2026)

**Layer C: Shadow Operator & Services (Sustainable Engine)**
*   Premium services built atop the protocol: dashboards, enterprise APIs, monitoring, and compliance tooling.
*   Funds ongoing protocol development and growth.
*   **Status:** 🔄 Formation & Pilot (Q1 2026)

## 🔍 Specification Preview

The full technical specification is available in **rendered format** (recommended):

- **[Open Rendered Preview on GitHub](https://github.com/OAPS-Protocol/oaps-v0.1/blob/main/SPECIFICATION.md)**  
  (GitHub's native rendering with full formatting)

- **Best Interactive Experience**: [Open in Live dApp](https://oaps-signer-dapp.vercel.app)  
  (In the footer, click **"View Preview"** for a formatted modal view)

- **Plain Text Alternative**: [Raw Specification](https://raw.githubusercontent.com/OAPS-Protocol/oaps-v0.1/main/SPECIFICATION.md)

## ❓ Troubleshooting

| **Issue** | **Solution** |
| :--- | :--- |
| MetaMask not detected | Install/Enable the MetaMask browser extension |
| Wrong network | Switch your wallet to the **Sepolia Testnet** |
| Invalid hash format | Ensure the hash is 66 characters (e.g., `0x` + 64 hex chars) |
| Transaction failed | Check your Sepolia ETH balance for gas fees |
| Proof not found | Verify the hash computation matches the OAPS specification |

**Get Test ETH** → [Sepolia Faucet](https://sepoliafaucet.com/)

## 🤝 Contribute

Feedback, contributions, or pilot interest? Open an [issue](https://github.com/OAPS-Protocol/oaps-v0.1/issues) or PR. Early auditors/professionals: DM [@ultimateshield4](https://x.com/ultimateshield4) on X for onboarding support.

## 📄 License

MIT License — see [LICENSE](LICENSE) for details.

⚠️ **Disclaimer:** OAPS provides proof *verification* only. It records facts about the existence, integrity, and authorship of professional work. It does **not** judge, guarantee, or endorse the quality, safety, correctness, compliance, or outcome of that work. Always conduct independent due diligence.

**Core Principle Maintained: Validity ≠ Quality. Proof of Fact, Not Promise.**