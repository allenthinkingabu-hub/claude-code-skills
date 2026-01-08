---
name: ln-404-test-executor
description: Executes Story Finalizer test tasks (label "tests") from Todo -> To Review. Enforces risk-based limits and priority.
---

# Test Task Executor

Runs a single Story final test task (label "tests") through implementation/execution to To Review.

## Purpose & Scope
- Handle only tasks labeled "tests"; other tasks go to ln-401.
- Follow the 11-section test task plan (E2E/Integration/Unit, infra/docs/cleanup).
- Enforce risk-based constraints: Priority ≤15; E2E 2-5, Integration 0-8, Unit 0-15, total 10-28; no framework/DB/library/performance tests.
- Update Linear/kanban for this task only: Todo -> In Progress -> To Review.

## Workflow (concise)
1) **Receive task:** Get task ID from orchestrator (ln-400); fetch full test task description; read linked guides/manuals/ADRs; review parent Story and manual test results if provided.
2) **Validate plan:** Check Priority ≤15 and test count limits; ensure focus on business flows (no infra-only tests).
3) **Start work:** Set task In Progress in Linear; move in kanban.
4) **Implement & run:** Author/update tests per plan; reuse existing fixtures/helpers; run tests; fix failing existing tests; update infra/doc sections as required.
5) **Complete:** Ensure counts/priority still within limits; set task To Review; move in kanban; add comment summarizing coverage, commands run, and any deviations.

## Critical Rules
- Single-task only; no bulk updates.
- Do not mark Done; ln-402 approves. Task must end in To Review.
- Keep language (EN/RU) consistent with task.
- No framework/library/DB/performance/load tests; focus on business logic correctness (not infrastructure throughput).
- Respect limits and priority; if violated, stop and return with findings.

## Definition of Done
- Task identified as test task and set to In Progress; kanban updated.
- Plan validated (priority/limits) and guides read.
- Tests implemented/updated and executed; existing failures fixed.
- Docs/infra updates applied per task plan.
- Task set to To Review; kanban moved; summary comment added with commands and coverage.

## Reference Files
- Kanban format: `docs/tasks/kanban_board.md`

---
**Version:** 3.0.0 (Condensed test executor with limits enforcement)
**Last Updated:** 2025-12-23
