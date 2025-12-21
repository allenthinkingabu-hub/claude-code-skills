---
name: ln-370-test-auditor
description: Test suite audit coordinator (L2). Delegates to 5 workers (Business Logic, E2E, Value, Coverage, Isolation). Aggregates results, creates Linear task in Epic 0.
allowed-tools: Read, Grep, Glob, Bash, mcp__Ref, mcp__context7, mcp__linear-server, Skill
---

# Test Suite Auditor (L2 Coordinator)

Coordinates comprehensive test suite audit across 6 quality categories using 5 specialized workers.

## Purpose & Scope

- **L2 Coordinator** that delegates to L3 specialized audit workers
- Audits all tests against 6 quality categories (via 5 workers)
- Calculates **Usefulness Score** for each test (Keep/Remove/Refactor)
- Identifies missing tests for critical business logic
- Detects anti-patterns and isolation issues
- Aggregates results into unified report
- Creates single Linear task in Epic 0
- Manual invocation by user; not part of Story pipeline

## Core Philosophy

> "Write tests. Not too many. Mostly integration." — Kent Beck
> "Test based on risk, not coverage." — ISO 29119

**Key Principles:**
1. **Test business logic, not frameworks** — bcrypt/Prisma/Express already tested
2. **Risk-based prioritization** — Priority ≥15 or remove
3. **E2E for critical paths only** — Money/Security/Data (Priority ≥20)
4. **Usefulness over quantity** — One useful test > 10 useless tests
5. **Every test must justify existence** — Impact × Probability ≥15

## Workflow

### Phase 1: Discovery (Automated)

**Inputs:** Codebase root directory

**Actions:**
1. Find all test files using Glob:
   - `**/*.test.*` (Jest, Vitest)
   - `**/*.spec.*` (Mocha, Jasmine)
   - `**/__tests__/**/*` (Jest convention)
2. Parse test file structure (test names, assertions count)
3. Auto-discover Team ID from [docs/tasks/kanban_board.md](../docs/tasks/kanban_board.md)

**Output:** `testFilesMetadata` — list of test files with basic stats

### Phase 2: Research Best Practices (ONCE)

**Goal:** Gather testing best practices context ONCE, share with all workers

**Actions:**
1. Use MCP Ref/Context7 to research testing best practices for detected tech stack
2. Load [../ln-350-story-test-planner/references/risk_based_testing_guide.md](../ln-350-story-test-planner/references/risk_based_testing_guide.md)
3. Build `contextStore` with:
   - Testing philosophy (E2E primary, Unit supplementary)
   - Usefulness Score formulas (Impact × Probability)
   - Anti-patterns catalog
   - Framework detection patterns

**Output:** `contextStore` — shared context for all workers

**Key Benefit:** Context gathered ONCE → passed to all workers → token-efficient

### Phase 3: Delegate to Workers (PARALLEL)

**Invoke ALL 5 workers in PARALLEL** using single message with 5 Skill tool calls:

| # | Worker | Category | What It Audits |
|---|--------|----------|----------------|
| 1 | [ln-371-test-business-logic-auditor](../ln-371-test-business-logic-auditor/) | Business Logic Focus | Framework/Library tests (Prisma, Express, bcrypt, JWT, axios, React hooks) → REMOVE |
| 2 | [ln-372-test-e2e-priority-auditor](../ln-372-test-e2e-priority-auditor/) | E2E Priority | E2E baseline (2/endpoint), Pyramid validation, Missing E2E tests |
| 3 | [ln-373-test-value-auditor](../ln-373-test-value-auditor/) | Risk-Based Value | Usefulness Score = Impact × Probability<br>Decisions: ≥15 KEEP, 10-14 REVIEW, <10 REMOVE |
| 4 | [ln-374-test-coverage-auditor](../ln-374-test-coverage-auditor/) | Coverage Gaps | Missing tests for critical paths (Money 20+, Security 20+, Data 15+, Core Flows 15+) |
| 5 | [ln-375-test-isolation-auditor](../ln-375-test-isolation-auditor/) | Isolation + Anti-Patterns | Isolation (6 categories), Determinism, Anti-Patterns (6 types) |

**Invocation Pattern:**
```javascript
// Pseudocode for parallel delegation
const workers = [
  { skill: "ln-371-test-business-logic-auditor", contextStore, testFiles },
  { skill: "ln-372-test-e2e-priority-auditor", contextStore, testFiles },
  { skill: "ln-373-test-value-auditor", contextStore, testFiles },
  { skill: "ln-374-test-coverage-auditor", contextStore, testFiles },
  { skill: "ln-375-test-isolation-auditor", contextStore, testFiles }
];

// ALL 5 workers run in PARALLEL (single message, 5 tool calls)
const results = await Promise.all(workers.map(w => Skill(w)));
```

**Each worker returns structured JSON:**
```json
{
  "category": "Business Logic Focus",
  "score": 7,
  "total_issues": 12,
  "findings": [
    {
      "severity": "MEDIUM",
      "test_file": "auth.test.ts",
      "test_name": "bcrypt hashes password",
      "decision": "REMOVE",
      "usefulness_score": 3,
      "reason": "Tests library behavior, not OUR code",
      "effort": "S"
    }
  ]
}
```

### Phase 4: Aggregate Results

**Goal:** Merge all worker results into unified Test Suite Audit Report

**Actions:**
1. **Collect results** from all 5 workers
2. **Merge findings** into decision categories:
   - **Tests to REMOVE** (Usefulness Score <10)
   - **Tests to REVIEW** (Usefulness Score 10-14)
   - **Tests to KEEP** (Usefulness Score ≥15)
   - **Missing Tests** (Priority/Justification)
   - **Anti-Patterns Found** (counts + examples)
3. **Calculate compliance scores** (6 categories, each /10)
4. **Build decision summary** (KEEP/REVIEW/REMOVE counts)
5. **Generate Executive Summary** (2-3 sentences)
6. **Create Linear task** in Epic 0 with full report (see Output Format below)
7. **Return summary** to user

## Output Format

```markdown
## Test Suite Audit Report - [DATE]

### Executive Summary
[2-3 sentences: test suite health, major issues, key recommendations]

### Test Count by Decision

| Decision | Count | % |
|----------|-------|---|
| KEEP | X | X% |
| REVIEW | X | X% |
| REMOVE | X | X% |
| **Total** | **X** | |

### Compliance Score

| Category | Score | Notes |
|----------|-------|-------|
| Business Logic Focus | X/10 | X framework tests found |
| E2E Priority | X/10 | X E2E, X Integration, X Unit |
| Risk-Based Value | X/10 | X tests with Priority <10 |
| Coverage Gaps | X/10 | X critical paths untested |
| Test Isolation | X/10 | X isolation issues |
| Anti-Patterns | X/10 | X anti-patterns found |
| **Overall** | **X/10** | |

### Audit Findings

| Severity | Location | Issue | Violated Principle | Recommendation | Effort |
|----------|----------|-------|-------------------|----------------|--------|
| **CRITICAL** | - | Missing E2E for payment with discount | #3: E2E for critical paths only (Money Priority 25) | Add E2E test: successful payment + discount edge cases | M |
| **HIGH** | auth.test.ts:45 | Test "bcrypt hashes password" (Score 3) | #1: Test business logic, not frameworks | Delete — bcrypt already tested by maintainers | S |
| **HIGH** | db.test.ts:78 | Test "Prisma findMany returns array" (Score 4) | #1: Test business logic, not frameworks | Delete — Prisma ORM already tested | S |
| **HIGH** | - | Missing Unit test for tax calculation edge cases | #5: Every test must justify existence (Impact 5 × Probability 4 = 20) | Add Unit tests for country-specific tax rules | M |
| **MEDIUM** | utils.test.ts:23 | Test "validateEmail returns true" (Score 12) | #4: Usefulness over quantity | Review: if E2E login covers → DELETE; else KEEP | S |
| **MEDIUM** | order.test.ts:200-350 | Giant test (>100 lines) | Anti-pattern: The Giant | Split into focused tests (one scenario per test) | M |
| **MEDIUM** | test.ts:45 | No assertions in test | Anti-pattern: The Liar | Add specific assertions or delete test | S |
| **LOW** | auth.test.ts | Only positive login scenarios | Anti-pattern: Happy Path Only | Add negative tests (invalid credentials, expired tokens) | M |
```

## Worker Architecture

Each worker:
- Receives `contextStore` with testing best practices
- Receives `testFilesMetadata` with test file list
- Loads full test file contents when analyzing
- Returns structured JSON with category findings
- Operates independently (failure in one doesn't block others)

**Token Efficiency:**
- Coordinator: metadata only (~1000 tokens)
- Workers: full test file contents when needed (~5000-10000 tokens each)
- Context gathered ONCE, shared with all workers

## Critical Rules

- **Delete > Archive:** Remove useless tests, don't comment out
- **E2E baseline:** Every endpoint needs 2 E2E (positive + negative)
- **Justify each test:** If can't explain Priority ≥15, remove it
- **Trust frameworks:** Don't test Express/Prisma/bcrypt behavior
- **Code is truth:** If test contradicts code behavior, update test
- **Language preservation:** Report in project's language (EN/RU)

## Definition of Done

- All test files discovered via Glob
- Context gathered from testing best practices (MCP Ref/Context7)
- All 5 workers invoked in PARALLEL
- Results aggregated into unified report
- Compliance scores calculated (6 categories)
- Keep/Remove/Refactor decisions for each test
- Missing tests identified with Priority
- Anti-patterns catalogued
- Linear task created in Epic 0 with full report
- Summary returned to user

## Related Skills

- **Workers:**
  - [ln-371-test-business-logic-auditor](../ln-371-test-business-logic-auditor/) — Framework tests detection
  - [ln-372-test-e2e-priority-auditor](../ln-372-test-e2e-priority-auditor/) — E2E baseline validation
  - [ln-373-test-value-auditor](../ln-373-test-value-auditor/) — Usefulness Score calculation
  - [ln-374-test-coverage-auditor](../ln-374-test-coverage-auditor/) — Coverage gaps identification
  - [ln-375-test-isolation-auditor](../ln-375-test-isolation-auditor/) — Isolation + Anti-Patterns

- **Reference:**
  - [../ln-350-story-test-planner](../ln-350-story-test-planner/) — Risk-Based Testing Guide
  - [../ln-360-codebase-auditor](../ln-360-codebase-auditor/) — Codebase audit coordinator (similar pattern)

---
**Version:** 2.0.0
**Last Updated:** 2025-12-21
