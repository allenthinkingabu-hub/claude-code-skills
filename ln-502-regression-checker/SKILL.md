---
name: ln-502-regression-checker
description: Worker that runs existing tests to catch regressions. Auto-detects framework, reports pass/fail. No status changes or task creation.
---

# Regression Checker

Runs the existing test suite to ensure no regressions after implementation changes.

## Purpose & Scope
- Detect test framework (pytest/jest/vitest/go test/etc.) and test dirs.
- Execute full suite; capture results for Story quality gate.
- Return PASS/FAIL with counts/log excerpts; never modifies Linear or kanban.

## Workflow (concise)
1) Auto-discover framework and test locations from repo config/files.
2) Build appropriate test command; run with timeout (~5m); capture stdout/stderr.
3) Parse results: passed/failed counts; key failing tests.
4) Output verdict JSON (PASS or FAIL + failures list) and add Linear comment.

## Critical Rules
- No selective test runs; run full suite.
- Do not fix tests or change status; only report.
- Language preservation in comment (EN/RU).

## Definition of Done
- Framework detected; command executed.
- Results parsed; verdict produced with failing tests (if any).
- Linear comment posted with summary.

## Reference Files
- Risk-based limits used downstream: `../ln-510-test-planner/references/risk_based_testing_guide.md`

---
**Version:** 3.0.0 (Condensed regression worker)
**Last Updated:** 2025-12-23
