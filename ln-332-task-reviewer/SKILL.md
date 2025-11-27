---
name: ln-332-task-reviewer
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
1) **Select task:** Use provided ID or pick from To Review list. Detect type (label "tests" -> test task, else implementation/refactor).
2) **Read context:** Full task + parent Story; load affected components/docs; review diffs if available.
3) **Review checks:**  
   - Approach matches Technical Approach or better (documented rationale).  
   - No hardcoded creds/URLs/magic numbers; config in env/config.  
   - Error handling/logging sane; layering respected; reuse existing components.  
   - Docs updated where required.  
   - Tests updated/run: for impl/refactor ensure affected tests adjusted; for test tasks check counts (E2E 2-5, Integration 0-8, Unit 0-15, total 10-28) and Priority ≤15, no framework/DB tests.
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
- Test tasks: `../ln-350-story-test-planner/references/test_task_template.md`, `../ln-350-story-test-planner/references/risk_based_testing_guide.md`
- Kanban format: `docs/tasks/kanban_board.md`

---
Version: 4.0.0 (Condensed review flow and zero-tolerance guidance)
Last Updated: 2025-11-26
