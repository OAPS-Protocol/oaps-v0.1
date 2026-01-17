# Getting Started with OAPS v0.1

## 🎯 Quick Overview

The Open Audit Proof Standard (OAPS) provides **immutable, verifiable proof** of audit existence, integrity, and source.  
It separates **proof of fact** from **judgment of quality**.

**Core Principle:** Validity ≠ Quality  
- A **valid** OAPS proof guarantees data integrity and origin  
- It does **not** guarantee audit correctness or system security

## 🚀 For Auditors: Register Your First Proof

### 1. Prerequisites
- **MetaMask** wallet with Sepolia testnet ETH
- Your audit report and metadata
- Access to your project's Git repository

### 2. Step-by-Step Workflow

#### Step 1: Open the Proof Builder
Navigate to the live dApp:  
**[https://oaps-signer-dapp.vercel.app](https://oaps-signer-dapp.vercel.app)**  
(Source: `tools/index.html` in the repository)

#### Step 2: Build Your Proof
Fill in the form with your audit details:
- **Audit ID**: Click "Generate UUID" or use your own UUIDv4
- **Project Details**: Name, contract address, blockchain
- **Auditor Address**: Your Ethereum address (auto-fills when you connect wallet)
- **Code Reference**: Git commit hash (40-character SHA-1)
- **Report Hash**: SHA-256 hash of your audit report PDF

#### Step 3: Generate Hash
Click **"Build Proof & Generate Hash"**  
- The system canonicalizes your proof data  
- A unique `proofHash` is generated and auto-filled  
- Example: `0x5f9c4abaf2f2b...`

#### Step 4: Connect Wallet & Sign
1. Click **"Connect MetaMask"** and switch to **Sepolia Testnet**
2. Click **"Sign Proof Hash"** to create a cryptographic signature
3. Your signature appears in the "Signature" field

#### Step 5: Register On-Chain
1. Click **"Register Proof (Send Transaction)"**
2. Approve the transaction in MetaMask (~$0.01 in Sepolia ETH)
3. Wait for confirmation (typically 15-30 seconds)
4. Transaction link to Etherscan appears

#### Step 6: Verify Registration
1. Click **"Check Registration Time"**
2. System confirms your proof is registered on-chain
3. Exact timestamp of registration is displayed

### 3. Example Proof JSON Structure
```json
{
  "oapsVersion": "0.1.0",
  "auditId": "f47ac10b-58cc-4372-a567-0e02b2c3d479",
  "project": {
    "name": "ExampleToken",
    "address": "0x1234567890123456789012345678901234567890",
    "blockchain": "ethereum"
  },
  "auditor": {
    "id": "0xabcdef1234567890abcdef1234567890abcdef12"
  },
  "auditScope": {
    "commitHash": "a1b2c3d4e5f6789012345678901234567890abcd"
  },
  "reportHash": "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855",
  "timestamp": "2024-01-15T12:00:00Z"
}
```

### 4. Generating Hashes Programmatically

If you need to generate proof hashes outside the dApp:

```javascript
// Using ethers.js
const ethers = require('ethers');

function generateProofHash(proofObject) {
  // 1. Canonicalize (sort keys, no whitespace)
  const canonical = JSON.stringify(proofObject, Object.keys(proofObject).sort(), '');
  
  // 2. Hash using keccak256
  return ethers.utils.keccak256(ethers.utils.toUtf8Bytes(canonical));
}
```

## 🔍 For Projects: Verify Audit Proofs

### 1. On-Chain Verification

**Contract Address:** `0x83e7593D3c8343437d92094d9485D6eDBfF89131`

**Methods:**
- Check registration: `registrationTime(proofHash)` → returns timestamp (or 0 if not found)
- Verify proof: `verifyProof(proofHash)` → returns timestamp

**Direct Verification:**
1. Visit [Sepolia Etherscan](https://sepolia.etherscan.io/address/0x83e7593D3c8343437d92094d9485D6eDBfF89131)
2. Enter the proofHash provided by your auditor
3. Call `registrationTime()` to verify registration

### 2. Independent Verification Protocol

Any third party can verify without trusting OAPS:

1. Obtain Data: Get the audit report and metadata from the auditor
2. Reconstruct Proof: Build the JSON object matching OAPS schema
3. Compute Hash: Canonicalize and hash the JSON
4. Check Registry: Query the OAPS registry with the computed hash
5. Validate: Confirm the auditor address matches the signer

### 3. What Verification Confirms

✅ Existence: Proof was registered at a specific time  
✅ Integrity: Data has not been altered since registration  
✅ Source: Specific auditor cryptographically signed it  

❌ NOT Verified: Audit quality, findings accuracy, or system security

## 🛠️ Technical Integration

For Developers: API Access

```javascript
// Interact with OAPS Registry
const contractABI = [
  "function registerProof(bytes32 _proofHash, bytes memory _signature) external returns (bool)",
  "function registrationTime(bytes32 _proofHash) external view returns (uint256)",
  "function verifyProof(bytes32 _proofHash) external view returns (uint256)"
];

const registryAddress = "0x83e7593D3c8343437d92094d9485D6eDBfF89131";
```

## For Security Researchers

- Audit the standard: [SPECIFICATION.md](./SPECIFICATION.md)
- Review the contract: [Etherscan Source](https://sepolia.etherscan.io/address/0x83e7593D3c8343437d92094d9485D6eDBfF89131#code)
- Test the system: Use Sepolia testnet for experimentation

## ❓ Troubleshooting

**Common Issues & Solutions**

| Issue                        | Solution                                                               |
|------------------------------|------------------------------------------------------------------------|
| "MetaMask not detected"      | Install MetaMask extension                                             |
| "Wrong network"              | Switch to Sepolia Testnet in MetaMask                                  |
| "Invalid hash"               | Ensure hash is 66 characters (0x + 64 hex)                             |
| "Transaction failed"         | Ensure you have Sepolia ETH (get from faucet)                          |
| "Proof not found"            | Verify the proofHash is correctly computed                             |

**Getting Test ETH**

1. Visit a Sepolia faucet: [sepoliafaucet.com](https://sepoliafaucet.com) or [faucet.quicknode.com](https://faucet.quicknode.com)
2. Enter your wallet address
3. Receive 0.1-0.5 Sepolia ETH (enough for 10-50 registrations)

## 📚 Resources

- Full Specification: [SPECIFICATION.md](./SPECIFICATION.md)
- Proof Builder dApp: [Live](https://oaps-signer-dapp.vercel.app) (source: `tools/index.html`)
- Live Contract: [Sepolia Etherscan](https://sepolia.etherscan.io/address/0x83e7593D3c8343437d92094d9485D6eDBfF89131)
- Project Roadmap: [MILESTONES.md](./MILESTONES.md)

## 🆘 Support

For technical issues or questions:

1. Check the OAPS GitHub repository
2. Review the specification for protocol details
3. Test with the dApp on Sepolia before mainnet usage

---

Remember: OAPS verifies proofs, not promises. Always conduct your own due diligence.

**Last Updated:** January 2026 | OAPS v0.1

