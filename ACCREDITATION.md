# RFC 001: OAPS Layer B – Credibility Oracle (Accreditation & Derived Reputation)

**Status**: Draft – Open for public feedback  
**Author**: Nwuko Akachukwu David (@ultimateshield4)  
**Date**: January 23, 2026  
**Target**: Q1 2026 design finalization & MVP start

## 1. Purpose

Layer B is the **opt-in, transparent, data-derived reputation layer** built directly on top of Layer A (the Universal Proof Registry).  

Its sole purpose is to provide **objective, verifiable, and fully auditable track records** for signers (auditors, professionals, projects, DAOs, AI agents) — using only immutable on-chain data from the `OAPSRegistryV0` contract.

**Core OAPS philosophy is preserved:**  
- Proof of fact, not promise  
- Validity ≠ Quality  
- The protocol never judges correctness, competence, safety, or outcome

Layer B computes metrics **exclusively** from `ProofRegistered` events — no subjective inputs, no off-chain data, no curation or blacklists.

## 2. Goals

- Allow anyone (projects, DAOs, investors, researchers) to quickly understand a signer’s historical activity and breadth of work  
- Remain 100% neutral — no scores, ratings, badges, trust scores, or qualitative labels  
- Be completely open, permissionless, and auditable by anyone  
- Enable future premium tools (Layer C) while protecting the neutrality of Layer A

## 3. Proposed Core Metrics (All Derived On-Chain Only)

All values are computed from `ProofRegistered(bytes32 indexed proofHash, address indexed auditor, uint256 timestamp)` events.

| Metric                        | Description                                                                 | Calculation Example                                      | Example Interpretation                        |
|-------------------------------|-----------------------------------------------------------------------------|----------------------------------------------------------|-----------------------------------------------|
| Total Proofs Registered       | Number of proofs signed by this address                                     | COUNT(DISTINCT proofHash) WHERE auditor = address       | "This signer has registered 47 proofs"        |
| Activity Span                 | Duration between first and most recent proof                                | MAX(timestamp) - MIN(timestamp)                          | "Active over 9 months"                        |
| Unique Projects               | Number of distinct project addresses referenced                             | COUNT(DISTINCT project.address)                          | "Has audited 18 different protocols"          |
| Average Proof Frequency       | Mean time interval between consecutive proofs                               | AVG(time diff between sorted timestamps)                 | "Registers ≈1 proof every 12 days"            |
| Proof Types Diversity (future)| Number of distinct categories (if added to schema later)                   | COUNT(DISTINCT proof.category)                           | "Covers audits, compliance, AI accountability"|

## 4. High-Level Design Options (MVP Focus)

**Option A – Off-chain Indexer + Public API** (recommended for v0.1 MVP)  
- Index all `ProofRegistered` events via The Graph subgraph or custom event listener  
- Compute metrics per `auditor` address on demand or periodically  
- Expose read-only public API (REST or GraphQL) – no authentication required

**Option B – Fully On-chain Oracle** (longer-term)  
- Chainlink Functions, custom oracle contract, or zero-knowledge proof  
- Pull and compute metrics directly on-chain (more trustless but gas-intensive)

**Option C – Hybrid**  
- Off-chain computation + periodic on-chain attestation of aggregated results

## 5. Open Questions for Community Feedback

1. Which of the proposed metrics are most valuable to you (auditors, projects, investors, DAOs)?  
2. Should we extend the canonical JSON schema now to include an optional `category` or `type` field for better future diversity metrics?  
3. Preferred MVP implementation path: The Graph subgraph, custom indexer, or something else?  
4. Are there important privacy or pseudonymity considerations we should address (all data is already public on-chain)?  
5. Should queries have rate limits, or should premium access (Layer C) offer higher throughput / dashboards?

## 6. RFC Process & Timeline

- Open for comments, suggestions, and PRs on this file  
- Feedback period: now until **end of February 2026** (or longer if needed)  
- After feedback incorporation → finalize as official Layer B specification  
- Implementation MVP targeted for Q1 2026

All feedback is welcome — from auditors, security researchers, developers, DAOs, investors, and anyone interested in neutral on-chain reputation infrastructure.

Let’s build this together.

**Repository**: https://github.com/OAPS-Protocol/oaps-v0.1  
**Discussion**: Open issues/PRs or DM @ultimateshield4 on X
