---
name: ln-370-test-auditor
description: Audit test suite quality across 6 categories (Business Logic Focus, E2E Priority, Risk-Based Value, Coverage Gaps, Isolation, Anti-Patterns). Calculates Usefulness Score per test. Removes useless tests, identifies missing ones. Creates refactoring task in Linear Epic 0.
allowed-tools: Read, Grep, Glob, Bash, WebFetch, WebSearch, mcp__Ref, mcp__context7, mcp__linear-server
---

# Test Suite Auditor

Full test suite quality audit. Removes useless tests, creates missing ones, ensures proper isolation.

## Purpose & Scope

- Audit all tests against 6 quality categories.
- Calculate **Usefulness Score** for each test (Keep/Remove/Refactor).
- Identify missing tests for critical business logic.
- Detect anti-patterns (Liars, Giants, Framework tests).
- Ensure proper test isolation.
- Create refactoring task in Linear under Epic 0.
- Manual invocation by user; not part of Story pipeline.

## Core Philosophy

> "Write tests. Not too many. Mostly integration." — Kent Beck

**Key Principles:**
1. **Test business logic, not frameworks** — bcrypt, Prisma, Express already tested
2. **E2E tests are primary** — prove feature works end-to-end
3. **Every test must be justified** — Priority ≥15 or remove
4. **Usefulness over coverage** — 60% coverage of critical paths > 90% of trivial code

## Workflow

1. **Discovery:** Find all test files (*.test.*, *.spec.*, __tests__/*)
2. **Analyze:** Parse each test, extract what it validates
3. **Score:** Calculate Usefulness Score per test (Impact × Probability)
4. **Audit:** Run 6 category checks (see below)
5. **Report:** Generate findings with Keep/Remove/Refactor decisions
6. **Create Task:** Linear task in Epic 0 with full report

## Audit Categories

| # | Category | What to Check |
|---|----------|---------------|
| 1 | **Business Logic Focus** | Tests validate OUR code, not frameworks/libraries/DB |
| 2 | **E2E Priority** | E2E tests cover happy path + critical error; unit/integration supplementary |
| 3 | **Risk-Based Value** | Each test has Priority ≥15 (Impact × Probability); remove if <10 |
| 4 | **Coverage Gaps** | Missing tests for critical business logic (money, security, data) |
| 5 | **Test Isolation** | Proper mocking, no external deps, deterministic, fast |
| 6 | **Anti-Patterns** | No Liars, Giants, Slow Pokes, Conjoined Twins, Happy Path Only |

## Usefulness Score

### Calculation

```
Usefulness Score = Business Impact (1-5) × Failure Probability (1-5)
```

### Decision Matrix

| Score | Decision | Action |
|-------|----------|--------|
| **≥15** | **KEEP** | Test is valuable, maintain it |
| **10-14** | **REVIEW** | Consider if E2E already covers this |
| **<10** | **REMOVE** | Delete test, not worth maintenance cost |

### Impact Scoring

| Score | Impact | Examples |
|-------|--------|----------|
| 5 | Critical | Money loss, security breach, data corruption |
| 4 | High | Core flow breaks (checkout, login) |
| 3 | Medium | Feature partially broken |
| 2 | Low | Minor UX issue |
| 1 | Trivial | Cosmetic bug |

### Probability Scoring

| Score | Probability | Indicators |
|-------|-------------|------------|
| 5 | Very High | Complex algorithm, new technology |
| 4 | High | Multiple dependencies, concurrency |
| 3 | Medium | Standard CRUD, framework defaults |
| 2 | Low | Simple logic, established library |
| 1 | Very Low | Trivial assignment, framework-generated |

## Output Format

```markdown
## Test Suite Audit Report - [DATE]

### Executive Summary
[2-3 sentences on test suite health, major issues, recommendations]

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

### Tests to REMOVE (Priority <10)

| Test | File | Score | Reason |
|------|------|-------|--------|
| "bcrypt hashes password" | auth.test.ts:45 | 3 | Tests library, not OUR code |
| "Express middleware works" | app.test.ts:12 | 2 | Tests framework |
| "Prisma findMany returns array" | db.test.ts:78 | 4 | Tests ORM |

### Tests to REVIEW (Priority 10-14)

| Test | File | Score | Question |
|------|------|-------|----------|
| "validateEmail returns true" | utils.test.ts:23 | 12 | Already covered by E2E login test? |

### Missing Tests (Coverage Gaps)

| Missing Test | Priority | Justification |
|--------------|----------|---------------|
| E2E: Payment with discount | 25 | Money calculation, high risk |
| Unit: Tax calculation edge cases | 20 | Complex algorithm, country rules |

### Anti-Patterns Found

| Anti-Pattern | Count | Examples |
|--------------|-------|----------|
| The Liar (always passes) | X | test.ts:45 - no assertions |
| Framework Testing | X | Express, Prisma, bcrypt tests |
| Happy Path Only | X | No error scenarios |
| Giant (>100 lines) | X | order.test.ts:200-350 |

### Recommended Actions

| Priority | Action | Location | Effort |
|----------|--------|----------|--------|
| High | Delete 5 framework tests | auth.test.ts | S |
| High | Add E2E for payment discount | - | M |
| Medium | Split giant test | order.test.ts | S |
```

## Critical Rules

- **Delete > Archive:** Remove useless tests, don't comment out
- **E2E baseline:** Every endpoint needs 2 E2E (positive + negative)
- **Justify each test:** If can't explain Priority ≥15, remove it
- **Trust frameworks:** Don't test Express/Prisma/bcrypt behavior
- **Code is truth:** If test contradicts code behavior, update test
- **Language preservation:** Report in project's language (EN/RU)

## Definition of Done

- All test files discovered and analyzed.
- Usefulness Score calculated for each test.
- All 6 categories audited.
- Keep/Remove/Refactor decision for each test.
- Missing tests identified with Priority.
- Anti-patterns catalogued.
- Report generated in structured format.
- Linear task created in Epic 0 with full report.

## Reference Files

- Audit rules: [references/test_audit_rules.md](references/test_audit_rules.md)
- Risk-Based Testing Guide: [../ln-350-story-test-planner/references/risk_based_testing_guide.md](../ln-350-story-test-planner/references/risk_based_testing_guide.md)
- Related: [../ln-360-codebase-auditor/SKILL.md](../ln-360-codebase-auditor/SKILL.md)

---
**Version:** 1.0.0
**Last Updated:** 2025-12-20
