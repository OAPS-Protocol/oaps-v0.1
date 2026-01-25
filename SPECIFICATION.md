

# Credibility Atom Specification (CAS-001)
**Status:** DRAFT  
**Protocol:** OAPS – Open Audit Proof System  
**License:** CC BY-SA 4.0  
**Last Updated:** 2026-01-25  

---

## 1. Abstract

This specification defines the **Credibility Atom** — the foundational primitive of the OAPS Protocol.

A Credibility Atom is a cryptographically verifiable claim, submitted with economic stake, exposed to bonded challenge, and resolved through adversarial scrutiny to produce a **non-transferable, history-dependent credibility signal**.

---

## 2. Introduction

### 2.1 Problem Statement

Current verification systems rely on trusted authorities or static proofs. There exists no neutral, economically-secured primitive that transforms assertions into trust through adversarial games, producing signals resistant to Sybil attacks and long-con strategies.

### 2.2 Goals

1. Define an atomic unit of verifiable action that is economically secured  
2. Create a neutral settlement layer resolving challenges without qualitative judgment  
3. Generate non-transferable, history-dependent credibility signals  
4. Enable adversarial truth discovery across AI, security, and governance systems  

### 2.3 Non-Goals

- Determining absolute “truth”
- Replacing legal or regulatory systems
- Guaranteeing safety or performance
- Creating a tradable reputation asset  

---

## 3. Definitions

| Term | Definition |
|---|---|
| Agent | An entity (human or artificial) identified by a cryptographic public key |
| Credibility Atom | The complete atomic unit defined in this specification |
| Base Proof | Structured JSON claim following OAPS v0.1 schema |
| Bond | Economic stake required for submission or challenge |
| Challenge Window | Fixed period during which an Atom may be disputed |
| Credibility Delta | Non-transferable signal derived from Atom history |
| Finalization | Resolution into FINALIZED or ECONOMICALLY_REJECTED |
| Slashing | Economic penalty applied to failed submissions or challenges |

---

## 4. Credibility Atom Structure

A Credibility Atom consists of **Base Proof data** and **Economic Metadata**.

### 4.1 Base Proof Schema Extension

```json
{
  "version": "CAS-001"
}


---

4.2 Economic Metadata Schema

{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "title": "Credibility Atom Economic Metadata",
  "type": "object",
  "required": [
    "baseProofHash",
    "agentAddress",
    "submissionBond",
    "challengeWindowSeconds",
    "disputeResolverId"
  ],
  "properties": {
    "baseProofHash": {
      "type": "string",
      "pattern": "^0x[a-fA-F0-9]{64}$"
    },
    "agentAddress": {
      "type": "string",
      "pattern": "^0x[a-fA-F0-9]{40}$"
    },
    "submissionBond": {
      "type": "string",
      "pattern": "^[0-9]+$"
    },
    "challengeWindowSeconds": {
      "type": "integer",
      "minimum": 3600,
      "maximum": 604800
    },
    "disputeResolverId": {
      "type": "string"
    },
    "contextUri": {
      "type": "string",
      "format": "uri"
    }
  }
}


---

4.3 Atom Commitment Hash

atomHash = keccak256(
  baseProofHash ||
  agentAddress ||
  submissionBond ||
  challengeWindowSeconds ||
  disputeResolverId
)


---

5. Lifecycle & State Machine

5.1 States

State	Description

PENDING	Atom submitted, bond locked
CHALLENGED	Active bonded dispute
FINALIZED	Accepted, bond returned
ECONOMICALLY_REJECTED	Invalidated, bond slashed


5.2 State Diagram

flowchart LR
  P[PENDING] -->|No Challenge| F[FINALIZED]
  P -->|Challenge| C[CHALLENGED]
  C -->|Submitter Wins| F
  C -->|Challenger Wins| R[ECONOMICALLY_REJECTED]


---

6. Bonded Challenge Mechanics

6.1 Submission

1. Agent prepares Base Proof


2. Computes atomHash


3. Signs hash with agent key


4. Submits Atom with bond to Layer A



6.2 Challenge

Any actor may challenge during window

Challenger posts matching bond

Atom enters CHALLENGED state


6.3 Dispute Resolution (Default)

Random bonded jurors

Commit–reveal voting

≥ ⅔ supermajority decides outcome


6.4 Economic Settlement

Outcome	Submitter Bond	Challenger Bond

No Challenge	Returned	—
Challenge Fails	Returned	Slashed
Challenge Succeeds	Slashed	Returned



---

7. Economic Invariants

7.1 Attack Cost Invariant

Attack Cost > Expected Fraud Profit

7.2 Participation Incentive

Expected Honest Challenge Reward > Challenge Cost

7.3 Parameter Bounds

Minimum bond ≥ 1 ETH

Challenge bond ratio = 1:1

Challenge window: 24h – 7d



---

8. Security Model

Threat	Mitigation

Sybil attacks	High bonding, non-transferable deltas
Long con	Time decay on credibility
Spam challenges	Bond slashing
Juror collusion	Random selection + supermajority
Data loss	Decentralized storage



---

9. Credibility Delta Framework

9.1 Oracle Interface

interface ICredibilityOracle {
  function computeDelta(
    address agent,
    bytes32[] calldata finalized,
    bytes32[] calldata rejected
  ) external view returns (int256);
}

9.2 Principles

Non-transferable

History-dependent

Stake-weighted

Time-decaying



---

10. Implementation Guidelines

Smart contract enforces lifecycle & slashing

Proofs stored on IPFS/Arweave

Metadata emitted as events

v0.1 proofs may be wrapped



---

11. Governance & Versioning

Activated at mainnet deployment

Changes via CAIP

Backward compatibility required



---

12. References

1. OAPS v0.1 Specification


2. EIP-712


3. Kleros


4. Augur




