---
name: ln-311-task-creator
description: Creates ALL task types (implementation, refactoring, test). Generates task documents from templates, validates type rules, creates in Linear, updates kanban. Invoked by orchestrators.
---

# Universal Task Creator

Worker that generates task documents and creates Linear issues for implementation, refactoring, or test tasks as instructed by orchestrators.

## Purpose & Scope
- Owns all task templates and creation logic (Linear + kanban updates)
- Generates full task documents per type (implementation/refactoring/test)
- Enforces type-specific hard rules (no new tests in impl, regression strategy for refactoring, risk matrix and limits for test)
- Drops NFR bullets if supplied; only functional scope becomes tasks
- Never decides scope itself; uses orchestrator input (plans/results)

## Invocation (who/when)
- **ln-310-story-decomposer:** CREATE (no tasks) or ADD (appendMode) for implementation tasks.
- **ln-340-story-quality-gate:** Create refactoring task when issues found.
- **ln-350-story-test-planner:** Create final test task after manual testing.
- Never called directly by users.

## Inputs
- Common: `taskType`, teamId, Story data (id/title/description with AC, Technical Notes, Context).
- Implementation CREATE: idealPlan (1-6 tasks), guideLinks.
- Implementation ADD: appendMode=true, newTaskDescription, guideLinks.
- Refactoring: codeQualityIssues, refactoringPlan, affectedComponents.
- Test: manualTestResults, testPlan (E2E 2-5, Integration 0-8, Unit 0-15, Priority ≤15), infra/doc/cleanup items.

## Workflow (concise)
1) **Context check:** For implementation (or ADD) review existing code/db/deps/docs to avoid duplicating components or columns; reuse instead of recreate.
2) **Template select:** Read template from `references/` based on taskType.
3) **Generate docs:** Fill sections for each task in plan/request using provided data and guide links.
4) **Validate type rules:** Stop with error if violation (see table below).
5) **Preview:** Show titles/goals/estimates/AC/components and totals.
6) **Confirmation required:** Proceed only after explicit confirm.
7) **Create issues:** Call Linear create_issue with parentId=Story, state=Backlog; capture URLs.
8) **Update kanban:** Add under Story in Backlog with correct Epic/indent.
9) **Return summary:** URLs, counts, hours, guide link count; next steps (validator/executor).

## Type Rules (must pass)
| taskType | Hard rule | What to verify |
|----------|-----------|----------------|
| implementation | No new test creation | Scan text for "write/create/add tests" etc.; allow only updating existing tests |
| refactoring | Regression strategy required | Issues listed with severity; plan in 3 phases; regression strategy (Baseline/Verify/Failure); preserve functionality |
| test | Risk-based plan required | Priority ≤15 scenarios; E2E 2-5, Integration 0-8, Unit 0-15, Total 10-28; no framework/library/DB tests |

## Critical Notes
- Foundation-First order for implementation is preserved from orchestrator; do not reorder.
- No code snippets; keep to approach, APIs, and pseudocode only.
- Documentation updates must be included in Affected Components/Docs sections.
- Language preservation: keep Story language (EN/RU) in generated tasks.

## Definition of Done
- Context check complete (existing components/schema/deps/docs reviewed; conflicts flagged).
- Documents generated with correct template and full sections.
- Type validation passed (no test creation for impl; regression strategy for refactor; risk matrix/limits for test).
- Preview shown and user confirmed.
- Linear issues created with parentId and URLs captured; state=Backlog.
- kanban_board.md updated under correct Epic/Story with indentation.
- Summary returned with URLs, totals, and next steps.

## Reference Files
- Templates (owned here): `references/task_template_implementation.md`, `references/refactoring_task_template.md`, `references/test_task_template.md`
- Kanban format: `docs/tasks/kanban_board.md`

---
**Version:** 5.0.0
**Last Updated:** 2025-11-26
