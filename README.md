
# 🔐 Open Audit Proof Standard (OAPS) v0.1

**On-chain verifiable audit proofs for crypto security. Immutable, timestamped, cryptographically signed.**

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Status: v0.1 Live](https://img.shields.io/badge/Status-v0.1%20Live-brightgreen)](https://sepolia.etherscan.io/address/0x83e7593D3c8343437d92094d9485D6eDBfF89131)
[![Network: Sepolia](https://img.shields.io/badge/Network-Sepolia-purple)](https://sepolia.etherscan.io)

## 🚀 Quick Start

| For Auditors | For Projects | For Developers |
|--------------|--------------|----------------|
| [📖 Getting Started Guide](GETTING_STARTED.md) | [🔍 Verify Proofs](#verification) | [📚 Technical Spec](SPECIFICATION.md) |
| [🛠️ Use Proof Builder](tools/oaps-signer-dapp.html) | [📋 Check Registry](#deployments) | [📦 Contract ABI](#contract-interface) |
| [🧪 Test on Sepolia](#deployments) | [🎯 Understand Proofs](#core-principle) | [🔧 Contribute](#-resources) |

## 📋 Overview

OAPS solves a critical problem in crypto security: **most audit reports are unverifiable PDFs**. We provide a protocol-level standard that makes audit proofs:

- ✅ **Verifiable** - Anyone can independently verify
- ✅ **Timestamped** - Proof of existence at specific time
- ✅ **Immutable** - Cannot be altered or faked
- ✅ **Attributable** - Cryptographically linked to auditor

### What OAPS Is NOT
- ❌ NOT an audit firm
- ❌ NOT a safety certification
- ❌ NOT a guarantee of correctness
- ❌ NOT investment advice

**OAPS verifies proofs — not promises.**

## 🎯 Core Principle: Validity ≠ Quality

| Validity (What OAPS Verifies) | Quality (What OAPS Does NOT Verify) |
|-------------------------------|-------------------------------------|
| ✅ Proof existence at specific time | ❌ Audit correctness |
| ✅ Data integrity (unaltered) | ❌ Auditor skill/competence |
| ✅ Cryptographic signature | ❌ System security |
| ✅ On-chain timestamp | ❌ Finding accuracy |

## 🏗️ Architecture

### Layer A: Protocol (Current - v0.1)
- **Proof Registry** - Immutable on-chain record
- **Canonical Standard** - Deterministic JSON schema
- **Verification Protocol** - Independent validation

### Layer B: Accreditation (Future)
- Auditor reputation system
- Decentralized trust layer
- Quality signaling mechanism

### Layer C: Shadow Operator (Future)
- Sustainable funding model
- Protocol development
- Ecosystem services

## 📦 Complete Implementation

### ✅ All Components Live & Operational

| Component | Status | Details |
|-----------|--------|---------|
| **Protocol Specification** | ✅ Complete | [SPECIFICATION.md](SPECIFICATION.md) |
| **Registry Smart Contract** | ✅ Verified | [Sepolia Etherscan](https://sepolia.etherscan.io/address/0x83e7593D3c8343437d92094d9485D6eDBfF89131) |
| **Proof Builder dApp** | ✅ Fully Functional | [tools/oaps-signer-dapp.html](tools/oaps-signer-dapp.html) |
| **Documentation Suite** | ✅ Complete | Spec + Guides + Milestones |
| **First Proof** | ✅ Registered | [View Transaction](https://sepolia.etherscan.io/tx/0x87045637eea366f13dd2e2df9dc29032f74583999ceb8d38fd129b6f6b05d6c4) |

## 🧪 Deployments

### Sepolia Testnet (v0.1)
**Official test registry for pilot audits and development.**

```solidity
Contract: OAPSRegistryV0
Address: 0x83e7593D3c8343437d92094d9485D6eDBfF89131
Network: Sepolia Testnet
Status: VERIFIED & ACTIVE
```

🔗 Links:

· View on Etherscan
· Read Contract
· Write Contract

📚 Documentation

Document Purpose Audience
SPECIFICATION.md Technical standard definition Developers, Auditors
GETTING_STARTED.md Step-by-step guides Auditors, Projects
MILESTONES.md Progress tracking Community, Contributors

🔧 Usage

For Auditors

1. Prepare your audit report and metadata
2. Navigate to Proof Builder dApp
3. Fill the form with audit details
4. Generate proof hash (auto-canonicalized)
5. Connect MetaMask (Sepolia network)
6. Sign the proof hash
7. Register on-chain (requires Sepolia ETH)
8. Verify registration status

For Projects

1. Request OAPS-compliant audit from auditor
2. Receive proof hash and metadata
3. Verify on-chain:
   ```javascript
   // Using Etherscan interface
   registrationTime(proofHash) → returns timestamp (or 0 if not found)
   ```
4. Validate auditor signature matches claimed identity

For Developers

```javascript
// Contract ABI
const contractABI = [
  "function registerProof(bytes32 _proofHash, bytes memory _signature) external returns (bool)",
  "function registrationTime(bytes32 _proofHash) external view returns (uint256)",
  "function verifyProof(bytes32 _proofHash) external view returns (uint256)"
];

// Contract Address
const registryAddress = "0x83e7593D3c8343437d92094d9485D6eDBfF89131";
```

🎯 Milestone Achievements

🚀 v0.1 Launch (January 2026)

· First Proof Registered: 0x87045637...6f6b05d6c4
· Proof Hash: 0x28d823138f5aa3a59b2a3c84155f4d0a8720a76dac090801a20339bc0effbae5
· Block: 10032252
· Timestamp: January 2026

📊 Progress Summary

Milestone Status Date
Specification v0.1 ✅ Complete Jan 2026
Registry Contract ✅ Deployed & Verified Jan 2026
Proof Builder dApp ✅ Fully Functional Jan 2026
Documentation ✅ Complete Jan 2026
First Proof ✅ On-Chain Verified Jan 2026

🔍 Verification Protocol

Independent Verification Steps

Any third party can verify without trusting OAPS:

1. Obtain Data - Get audit report and metadata from auditor
2. Reconstruct Proof - Build JSON object per OAPS schema
3. Canonicalize - Sort keys, remove whitespace
4. Compute Hash - keccak256(canonicalJSON)
5. Query Registry - Check registrationTime(proofHash)
6. Validate - Confirm auditor address matches signature

What Verification Confirms

· ✅ Existence - Proof registered at specific time
· ✅ Integrity - Data unaltered since registration
· ✅ Source - Specific auditor signed it

🏛️ Governance

This protocol follows a Funding & Independence Charter (forthcoming) ensuring:

· Neutrality - No single entity controls the protocol
· Anti-capture - Structural safeguards against control
· Transparency - All decisions and funding public
· Sustainability - Revenue funds protocol development

❓ Troubleshooting

Issue Solution
MetaMask not detected Install/Enable MetaMask extension
Wrong network Switch to Sepolia Testnet
Invalid hash format Ensure 66 chars (0x + 64 hex)
Transaction failed Check Sepolia ETH balance
Proof not found Verify hash computation matches spec

Getting Test ETH

1. Visit Sepolia Faucet
2. Enter wallet address
3. Receive 0.1-0.5 Sepolia ETH (enough for 10-50 registrations)

🚀 What's Next

Immediate (Pilot Program)

· Onboard 3-5 pilot auditors
· Register 10+ test proofs
· Gather user feedback
· Refine tooling based on real usage

Short-term (Q1 2026)

· Accreditation Layer (Layer B) design
· Shadow Operator formation
· GitHub Pages deployment
· Community governance setup

Long-term (2026+)

· Ethereum mainnet deployment
· Multi-chain support
· Enterprise API development
· Industry standard adoption

🔗 Resources

· Repository: github.com/OAPS-Protocol/oaps-v0.1
· Contract: Etherscan
· First Proof: Transaction
· Test ETH: Sepolia Faucet

📄 License

MIT License - see LICENSE file for details.

---

⚠️ Disclaimer: OAPS provides proof verification only. It does not guarantee audit quality, system security, or investment safety. Always conduct independent due diligence.

Core Principle Maintained: Validity ≠ Quality


