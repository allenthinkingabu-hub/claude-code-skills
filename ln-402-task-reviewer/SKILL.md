---
name: ln-402-task-reviewer
description: Reviews completed tasks (To Review) and moves them to Done or To Rework. Zero tolerance: all issues fixed now.
---

# Task Reviewer

Reviews a single task in To Review and decides Done vs To Rework with immediate fixes or clear rework notes.

## Purpose & Scope
- Load full task and parent Story; understand AC, context, and Technical Approach.
- Check architecture, correctness, configuration hygiene, docs, and tests.
- For test tasks, verify risk-based limits and priority (≤15) per planner template.
- Update only this task: accept (Done) or send back (To Rework) with explicit reasons and fix suggestions tied to best practices.

## Workflow (concise)
1) **Receive task:** Get task ID from orchestrator (ln-400); detect type (label "tests" -> test task, else implementation/refactor).
2) **Read context:** Full task + parent Story; load affected components/docs; review diffs if available.
3) **Review checks:**
   - Approach matches Technical Approach or better (documented rationale).
   - No hardcoded creds/URLs/magic numbers; config in env/config.
   - Error handling sane; layering respected; reuse existing components.
   - Logging: critical paths logged (errors, business events); correct log levels (DEBUG/INFO/WARNING/ERROR).
   - Comments: explain WHY not WHAT; no commented-out code; docstrings on public methods; Task ID present in new code blocks (`// See PROJ-123`).
   - Naming: consistent conventions; descriptive names; no single-letter variables (except loops).
   - Docs updated where required.
   - Tests updated/run: for impl/refactor ensure affected tests adjusted; for test tasks verify risk-based limits and priority (≤15) per planner template.
4) **Decision:**  
   - If only nits: apply minor fixes and set Done.  
   - If issues remain: set To Rework with comment explaining why (best-practice ref) and how to fix.
5) **Update:** Set task status (Done or To Rework) in Linear; move task in kanban accordingly; add review comment with findings/actions.

## Critical Rules
- One task at a time; do not touch others.
- Zero tolerance: no deferring issues; either fix now or send back with guidance.
- Keep language of the task (EN/RU) in comments/edits.
- If test-task limits/priority violated -> To Rework with guidance.
- Never leave task Done if any unresolved issue exists.

## Definition of Done
- Task and parent Story fully read; type identified.
- Review checklist completed; docs/tests/config verified.
- Decision applied: Done (minor fixes applied) or To Rework (issues + fix guidance).
- Linear status and kanban updated for this task; review comment posted with reasons and suggested fixes.

## Reference Files
- Kanban format: `docs/tasks/kanban_board.md`

---
**Version:** 3.0.0
**Last Updated:** 2025-12-23
