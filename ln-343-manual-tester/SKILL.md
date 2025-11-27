---
name: ln-343-manual-tester
description: Performs manual testing of Story AC (API/UI) with curl/puppeteer, documents results in Linear (structured comment) and provides reusable scripts. Worker only.
---

# Manual Tester

Manually verifies Story AC on running code and reports structured results for the quality gate.

## Purpose & Scope
- Rebuild/run app, detect API/UI, and execute AC-driven checks via curl/puppeteer.
- Document results in Linear (Format v1.0) with pass/fail per AC, edge/error handling, and temp script path.
- No status changes or task creation.

## Workflow (concise)
1) **Env setup:** Rebuild containers (no cache), start, ensure healthy. Detect API vs UI; confirm app reachable.
2) **Load AC:** Fetch Story, parse AC into Given/When/Then list (3-5 expected).
3) **Execute:** For each AC + edge/error cases, run curl (API) or puppeteer (UI); capture responses/screens; note deviations.
4) **Report:** Produce verdict PASS/FAIL; add Linear comment (Format v1.0) with AC matrix, issues found, evidence, and temp script path; return JSON result.

## Critical Rules
- Rebuild Docker before testing; fail if rebuild/run unhealthy.
- Keep language of Story (EN/RU) in comment.
- No fixes or status changes; only evidence and verdict.

## Definition of Done
- App rebuilt and running; AC parsed.
- Tests executed across main + edge/error cases.
- Verdict and structured Linear comment posted with evidence and script path.

## Reference Files
- AC format and scripts: `../ln-350-story-test-planner/references/test_task_template.md` (for alignment)
- Risk-based context: `../ln-350-story-test-planner/references/risk_based_testing_guide.md`

---
Version: 3.0.0 (Condensed manual testing flow)
Last Updated: 2025-11-26
