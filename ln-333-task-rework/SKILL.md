---
name: ln-333-task-rework
description: Fixes tasks in To Rework and returns them to To Review. Applies reviewer feedback only for the selected task.
---

# Task Rework Executor

Executes rework for a single task marked To Rework and hands it back for review.

## Purpose & Scope
- Load full task, reviewer comments, and parent Story; understand requested changes.
- Apply fixes per feedback, keep KISS/YAGNI, and align with guides/Technical Approach.
- Update only this task: To Rework -> In Progress -> To Review; no other tasks touched.

## Workflow (concise)
1) **Select task:** Provided ID or choose from To Rework list. Read task, review notes, parent Story.
2) **Plan fixes:** Map each comment to an action; confirm no new scope added.
3) **Implement:** Follow task plan/checkboxes; address config/hardcoded issues; update docs/tests noted in Affected Components and Existing Code Impact.
4) **Quality:** Run typecheck/lint (or project equivalents); ensure fixes reflect guides/manuals/ADRs.
5) **Handoff:** Set task to To Review in Linear; move it in kanban; add summary comment referencing resolved feedback.

## Critical Rules
- Single-task only; never bulk update.
- Do not mark Done; only To Review (ln-332 decides Done).
- Keep language (EN/RU) consistent with task.
- No new tests/tasks created here; only update existing tests if impacted.
- Preserve Foundation-First ordering from orchestrator; do not reorder tasks.

## Definition of Done
- Task and review feedback fully read; actions mapped.
- Fixes applied; docs/tests updated as required.
- Quality checks passed (typecheck/lint or project standards).
- Status set to To Review; kanban updated; summary comment added referencing fixed items.

## Reference Files
- Task template: `../ln-311-task-creator/references/task_template_implementation.md`
- Kanban format: `docs/tasks/kanban_board.md`

---
Version: 5.0.0 (Condensed rework flow, single-task safety)
Last Updated: 2025-11-26
