# 🔐 Open Audit Proof Standard (OAPS) v0.1

**On-chain verifiable audit proofs for crypto security.**  
Immutable • Timestamped • Cryptographically Signed

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Status: v0.1 Live](https://img.shields.io/badge/Status-v0.1%20Live-brightgreen)](https://oaps-signer-dapp.vercel.app)
[![Network: Sepolia](https://img.shields.io/badge/Network-Sepolia-purple)](https://sepolia.etherscan.io/address/0x83e7593D3c8343437d92094d9485D6eDBfF89131)

## 🚀 Live dApp – Try it Now!

**[Proof Builder & Signer](https://oaps-signer-dapp.vercel.app)**  
Build, sign, and register immutable audit proofs on Sepolia testnet.

## 📋 Quick Start

| Role          | Action                              | Link / Guide                                      |
|---------------|-------------------------------------|---------------------------------------------------|
| Auditors      | Build & Register Proof              | [Use Proof Builder](https://oaps-signer-dapp.vercel.app) |
| Projects      | Verify Registered Proof             | [Registry on Etherscan](https://sepolia.etherscan.io/address/0x83e7593D3c8343437d92094d9485D6eDBfF89131) |
| Developers    | Read Technical Specification        | [View Rendered Specification](https://github.com/OAPS-Protocol/oaps-v0.1/blob/main/SPECIFICATION.md) |
| Everyone      | Step-by-Step Guides                 | [GETTING_STARTED.md](GETTING_STARTED.md)          |
| Progress      | Milestone Tracking                  | [MILESTONES.md](MILESTONES.md)                    |

## 🎯 Core Principle: Validity ≠ Quality

OAPS proves **existence, integrity, and source** — not correctness or safety.

| Validity (What OAPS Verifies)          | Quality (What OAPS Does NOT Verify)   |
|----------------------------------------|----------------------------------------|
| ✅ Proof existence at specific time     | ❌ Audit correctness                    |
| ✅ Data integrity (unaltered)           | ❌ Auditor skill/competence             |
| ✅ Cryptographic signature              | ❌ System security                      |
| ✅ On-chain timestamp                   | ❌ Finding accuracy                     |

## 🏗️ Current Implementation – All Live & Operational

| Component                  | Status              | Details / Link                                                                 |
|----------------------------|---------------------|--------------------------------------------------------------------------------|
| Protocol Specification     | ✅ Complete         | [View Rendered on GitHub](https://github.com/OAPS-Protocol/oaps-v0.1/blob/main/SPECIFICATION.md) |
| Registry Smart Contract    | ✅ Verified         | [Sepolia Etherscan](https://sepolia.etherscan.io/address/0x83e7593D3c8343437d92094d9485D6eDBfF89131) |
| Proof Builder dApp         | ✅ Fully Functional | [Live](https://oaps-signer-dapp.vercel.app) (source: `tools/index.html`)       |
| Documentation Suite        | ✅ Complete         | Guides + Milestones + Specification                                            |
| First Proof                | ✅ Registered       | [View Transaction](https://sepolia.etherscan.io/tx/0x87045637eea366f13dd2e2df9dc29032f74583999ceb8d38fd129b6f6b05d6c4) |

## 🧪 Deployments

**Sepolia Testnet (v0.1)** — Official pilot registry

**Contract:** OAPSRegistryV0  
**Address:** `0x83e7593D3c8343437d92094d9485D6eDBfF89131`  
**Network:** Sepolia Testnet  
**Status:** VERIFIED & ACTIVE  

🔗  
• [View on Etherscan](https://sepolia.etherscan.io/address/0x83e7593D3c8343437d92094d9485D6eDBfF89131)  
• [Read Contract](https://sepolia.etherscan.io/address/0x83e7593D3c8343437d92094d9485D6eDBfF89131#readContract)  
• [Write Contract](https://sepolia.etherscan.io/address/0x83e7593D3c8343437d92094d9485D6eDBfF89131#writeContract)

## 🔍 Specification Preview

The full technical specification is available in **rendered format** (recommended):

- **[Open Rendered Preview on GitHub](https://github.com/OAPS-Protocol/oaps-v0.1/blob/main/SPECIFICATION.md)**  
  (Beautiful headings, tables, code blocks – GitHub's native rendering)

- **Best Interactive Experience**: [Open in Live dApp](https://oaps-signer-dapp.vercel.app)  
  (In the footer, click **"View Preview"** for formatted modal view)

- **Plain Text Alternative**: [Raw Specification](https://raw.githubusercontent.com/OAPS-Protocol/oaps-v0.1/main/SPECIFICATION.md)

## 🎯 What's Next (Pilot & Roadmap)

**Immediate (Pilot Program)**  
- Onboard 3-5 pilot auditors  
- Register 10+ test proofs  
- Gather user feedback & refine tooling

**Short-term (Q1 2026)**  
- Accreditation Layer (Layer B) design  
- Shadow Operator formation  
- Community governance setup

**Long-term (2026+)**  
- Ethereum mainnet deployment  
- Multi-chain support  
- Enterprise API development  
- Industry standard adoption

## ❓ Troubleshooting

| Issue                          | Solution                                                                 |
|--------------------------------|--------------------------------------------------------------------------|
| MetaMask not detected          | Install/Enable MetaMask extension                                        |
| Wrong network                  | Switch to Sepolia Testnet                                                |
| Invalid hash                   | Ensure 66 chars (0x + 64 hex)                                            |
| Transaction failed             | Check Sepolia ETH balance                                                |
| Proof not found                | Verify hash computation matches spec                                     |

**Get Test ETH** → [Sepolia Faucet](https://sepoliafaucet.com/)

## 📄 License

MIT License — see [LICENSE](LICENSE) for details.

⚠️ **Disclaimer:** OAPS provides proof verification only. It does not guarantee audit quality, system security, or investment safety. Always conduct independent due diligence.

**Core Principle Maintained: Validity ≠ Quality**