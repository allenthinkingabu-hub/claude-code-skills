---
name: ln-330-story-executor
description: Orchestrates Story tasks. Prioritizes To Review -> To Rework -> Todo, delegates to ln-331/ln-333/ln-334, hands Story quality to ln-340. Metadata-only loading up front.
---

# Story Execution Orchestrator

Executes a Story end-to-end by looping through its tasks in priority order and delegating quality gates to ln-340-story-quality-gate.

## Purpose & Scope
- Load Story + task metadata (no descriptions) and drive execution.
- Process tasks in order: To Review -> To Rework -> Todo (foundation-first order preserved from ln-310).
- Delegate per task type: ln-332-task-reviewer, ln-333-task-rework, ln-331-task-executor, ln-334-test-executor.
- Delegate Story quality to ln-340-story-quality-gate (Pass 1/Pass 2) and loop if new tasks are created.

## When to Use
- Story is Todo or In Progress and has implementation/refactor/test tasks to finish.
- Need automated orchestration through To Review and quality gates.

## Workflow (concise)
- **Phase 1 Discovery:** Auto-discover Team ID/config from kanban_board.md + CLAUDE.md.
- **Phase 2 Load:** Fetch Story metadata and all child task metadata via `list_issues(parentId=Story.id)` (ID/title/status/labels only). Summarize counts (e.g., "2 To Review, 1 To Rework, 3 Todo"). **NO analysis** — proceed immediately to Phase 3.
- **Phase 3 Loop (immediate delegation, one task at a time):**
  1) To Review -> ln-332-task-reviewer (one task). Reload metadata after worker.
  2) To Rework -> ln-333-task-rework (one task). After worker, verify status = To Review, then immediately call ln-332-task-reviewer on that same task. Reload metadata.
  3) Todo -> pick first Todo; if label "tests" use ln-334-test-executor else ln-331-task-executor. After worker, verify status = To Review (not Done/In Progress), then immediately call ln-332-task-reviewer on that same task. Reload metadata. Repeat loop; never queue multiple tasks in To Review—review right after each execution/rework.
- **Phase 4 Quality Delegation:** Ensure all implementation tasks Done, then call ln-340-story-quality-gate Pass 1. If it creates tasks (test/refactor/fix), auto-validate (ln-320) and return to Phase 3. When test task is Done, set Story In Progress -> To Review and call ln-340 Pass 2. If Pass 2 fails and creates tasks, loop to Phase 3; if Pass 2 passes, Story goes To Review -> Done via ln-340.

## Critical Rules
- Metadata first: never load task descriptions in Phase 2; only workers load full text.
- No pre-analysis: after Phase 2 counts, pick ONE task by priority (To Review > To Rework > Todo) and delegate immediately. Do not plan, analyze, or reason about other tasks until they become next in queue.
- Single-task operations: each worker handles only the passed task ID; ln-330 never bulk-updates tasks.
- Status discipline: after ln-331/ln-333/ln-334, task must be To Review; immediately invoke ln-332 on that task. Only ln-332 may set Done. Stop and report if any worker leaves task Done or In Progress.
- Source of truth: trust Linear metadata, not kanban_board.md, for orchestration decisions.
- Story status ownership: ln-330 moves Todo -> In Progress (first execution) and In Progress -> To Review (all tasks Done); ln-340 handles To Review -> Done.

## Definition of Done
- Story metadata and task metadata loaded via list_issues (no get_issue in Phase 2); counts shown.
- Loop executed: all To Review via ln-332; all To Rework via ln-333 then immediate ln-332 on the same task; all Todo via ln-331/ln-334 then immediate ln-332 on the same task (validated To Review after each worker).
- If tasks were created by ln-340: validated via ln-320 and executed through the loop.
- ln-340 Pass 1 invoked when impl tasks Done; Pass 2 invoked when test task Done or not needed. Result handled (pass/fail -> loop).
- Story status transitions applied (Todo -> In Progress -> To Review) and kanban updated by workers/ln-340.
- Final report with task counts and next step (if any).

## Reference Files
- Quality orchestration: `../ln-340-story-quality-gate/SKILL.md`
- Executors: `../ln-331-task-executor/SKILL.md`, `../ln-333-task-rework/SKILL.md`, `../ln-334-test-executor/SKILL.md`, `../ln-332-task-reviewer/SKILL.md`
- Auto-discovery: `CLAUDE.md`, `docs/tasks/kanban_board.md`

---
Version: 8.1.0 (Condensed orchestration, kept priority loop and quality delegation rules)
Last Updated: 2025-11-26
