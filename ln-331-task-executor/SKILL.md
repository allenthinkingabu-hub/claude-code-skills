---
name: ln-331-task-executor
description: Executes implementation tasks (Todo -> In Progress -> To Review). Follows KISS/YAGNI, guides, quality checks. Not for test tasks.
---

# Implementation Task Executor

Executes a single implementation (or refactor) task from Todo to To Review using the task description and linked guides.

## Purpose & Scope
- Handle one selected task only; never touch other tasks.
- Follow task Technical Approach/plan/AC; apply KISS/YAGNI and guide patterns.
- Update Linear/kanban for this task: Todo -> In Progress -> To Review.
- Run typecheck/lint; update docs/tests/config per task instructions.
- Not for test tasks (label "tests" goes to ln-334-test-executor).

## Workflow (concise)
1) **Load context:** Fetch full task description; read linked guides/manuals/ADRs; auto-discover team/config if needed.
2) **Pick task:** If ID provided, use it; otherwise list Todo tasks and select one.
3) **Start work:** Update this task to In Progress in Linear; move it in kanban (keep Epic/Story indent).
4) **Implement:** Follow checkboxes/plan; keep it simple; avoid hardcoded values; reuse existing components; add Task ID comment (`// See PROJ-123`) to new code blocks; update docs noted in Affected Components; update existing tests if impacted (no new tests here).
5) **Quality:** Run typecheck and lint (or project equivalents); ensure instructions in Existing Code Impact are addressed.
6) **Finish:** Mark task To Review in Linear; update kanban to To Review; add summary comment (what changed, tests run, docs touched).

## Critical Rules
- Single-task updates only; no bulk status changes.
- Keep language of the task (EN/RU) in edits/comments.
- No code snippets in the description; code lives in repo, not in Linear.
- No new test creation; only update existing tests if required.
- Preserve Foundation-First ordering from orchestrator; do not reorder tasks.
- Add Task ID comments to new code blocks for traceability (`// See PROJ-123` or `# See PROJ-123`).

## Definition of Done
- Task selected and set to In Progress; kanban updated accordingly.
- Guides/manuals/ADRs read; approach aligned with task Technical Approach.
- Implementation completed per plan/AC; docs and impacted tests updated.
- Typecheck and lint passed (or project quality commands) with evidence in comment.
- Task set to To Review; kanban moved to To Review; summary comment added.

## Reference Files
- Task template: `../ln-311-task-creator/references/task_template_implementation.md`
- Guides/manuals/ADRs: `docs/guides/`, `docs/manuals/`, `docs/adrs/`
- Kanban format: `docs/tasks/kanban_board.md`

---
Version: 5.1.0 (Condensed executor flow and single-task safety)
Last Updated: 2025-11-26
