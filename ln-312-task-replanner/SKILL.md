---
name: ln-312-task-replanner
description: Updates ALL task types (implementation/refactoring/test). Compares IDEAL plan vs existing tasks, categorizes KEEP/UPDATE/OBSOLETE/CREATE, applies changes in Linear and kanban.
---

# Universal Task Replanner

Worker that re-syncs existing tasks to the latest requirements for any task type.

## Purpose & Scope
- Load full existing task descriptions from Linear
- Compare them with orchestrator-provided IDEAL plan (implementation/refactoring/test)
- Decide operations (KEEP/UPDATE/OBSOLETE/CREATE) and execute
- Drop NFR items; only functional scope remains
- Update Linear issues and kanban_board.md accordingly

## Invocation (who/when)
- ln-310-story-decomposer: REPLAN mode when implementation tasks already exist.
- ln-340-story-quality-gate: Refactoring task needs updates after new findings.
- ln-350-story-test-planner: Test task needs updates after manual testing changes.
- Not user-invoked directly.

## Inputs
- Common: `taskType`, teamId, Story data (id/title/description with AC, Technical Notes, Context), existingTaskIds.
- Implementation: idealPlan (1-6 tasks), guideLinks.
- Refactoring: codeQualityIssues, refactoringPlan, affectedComponents.
- Test: manualTestResults, testPlan (E2E 2-5, Integration 0-8, Unit 0-15, Priority ≤15), infra/doc/cleanup items.

## Workflow (concise)
1) Load templates per taskType from ln-311-task-creator/references and fetch full existing task descriptions.
2) Normalize both sides (IDEAL vs existing sections) and run replan algorithm to classify KEEP/UPDATE/OBSOLETE/CREATE.
3) Present summary (counts, titles, key diffs). Confirmation required if running interactively.
4) Execute operations in Linear: update descriptions, cancel obsolete, create missing, preserve parentId/state team.
5) Update kanban_board.md: remove canceled, add new tasks under Story in Backlog.
6) Return operations summary with URLs and warnings.

## Type Rules (must hold after update)
| taskType | Hard rule | What to enforce |
|----------|-----------|-----------------|
| implementation | No new test creation | Updated/created tasks must not introduce test creation text |
| refactoring | Regression strategy required | Issues + severity, 3-phase plan, regression strategy, preserve functionality |
| test | Risk-based limits | Priority ≤15 scenarios; E2E 2-5, Integration 0-8, Unit 0-15, Total 10-28; no framework/library/DB tests |

## Critical Notes
- Foundation-First ordering from IDEAL plan is preserved; do not reorder.
- Language preservation: keep existing task language (EN/RU).
- No code snippets; keep to approach/steps/AC/components.
- If Story reality differs (component exists, column exists), propose Story correction to orchestrator.

## Definition of Done
- Existing tasks loaded and parsed with correct template.
- IDEAL plan vs existing compared; operations classified.
- Type validation passed for all updated/created tasks.
- Operations executed in Linear (updates, cancels, creations) with parentId intact.
- kanban_board.md updated (Backlog) with correct Epic/Story/indentation.
- Summary returned (KEEP/UPDATE/OBSOLETE/CREATE counts, URLs, warnings).

## Reference Files
- Templates: `../ln-311-task-creator/references/task_template_implementation.md`, `../ln-311-task-creator/references/refactoring_task_template.md`, `../ln-311-task-creator/references/test_task_template.md`
- Replan algorithm: `references/replan_algorithm.md`
- Kanban format: `docs/tasks/kanban_board.md`

---
**Version:** 6.0.0
**Last Updated:** 2025-11-26
