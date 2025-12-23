---
name: ln-410-story-executor
description: Orchestrates Story tasks. Prioritizes To Review -> To Rework -> Todo, delegates to ln-411/ln-413/ln-414, hands Story quality to ln-500. Metadata-only loading up front.
---

# Story Execution Orchestrator

Executes a Story end-to-end by looping through its tasks in priority order and delegating quality gates to ln-500-story-quality-gate.

## Purpose & Scope
- Load Story + task metadata (no descriptions) and drive execution.
- Process tasks in order: To Review -> To Rework -> Todo (foundation-first order preserved from ln-310).
- Delegate per task type: ln-412-task-reviewer, ln-413-task-rework, ln-411-task-executor, ln-414-test-executor.
- Delegate Story quality to ln-500-story-quality-gate (Pass 1/Pass 2) and loop if new tasks are created.

## When to Use
- Story is Todo or In Progress and has implementation/refactor/test tasks to finish.
- Need automated orchestration through To Review and quality gates.

## Workflow (concise)
- **Phase 1 Discovery:** Auto-discover Team ID/config from kanban_board.md + CLAUDE.md.
- **Phase 2 Load:** Fetch Story metadata and all child task metadata via `list_issues(parentId=Story.id)` (ID/title/status/labels only). Summarize counts (e.g., "2 To Review, 1 To Rework, 3 Todo"). **NO analysis** — proceed immediately to Phase 3.
- **Phase 3 Loop (immediate delegation via Skill tool, one task at a time):**
  1) To Review → **Use Skill tool to invoke `ln-412-task-reviewer`**. Reload metadata after worker.
  2) To Rework → **Use Skill tool to invoke `ln-413-task-rework`**. After worker, verify status = To Review, then **immediately use Skill tool to invoke `ln-412-task-reviewer`** on that same task. Reload metadata.
  3) Todo → pick first Todo; if label "tests" **use Skill tool to invoke `ln-414-test-executor`** else **use Skill tool to invoke `ln-411-task-executor`**. After worker, verify status = To Review (not Done/In Progress), then **immediately use Skill tool to invoke `ln-412-task-reviewer`** on that same task. Reload metadata. Repeat loop; never queue multiple tasks in To Review—review right after each execution/rework.

**TodoWrite format (mandatory):**
For each task, add BOTH steps to todos before starting execution:
1. `Execute [Task-ID]: [Title]` — mark in_progress when starting executor
2. `Review [Task-ID]: [Title]` — mark in_progress after executor completes, completed after ln-412

**Kanban board sync (mandatory):**
Update `docs/tasks/kanban_board.md` after EVERY status change:
- After executor: move task from Todo to To Review
- After reviewer (Done): move task from To Review to Done
- After reviewer (To Rework): move task from To Review to To Rework
- After rework: move task from To Rework to To Review

- **Phase 4 Quality Delegation:** Ensure all implementation tasks Done, then **use Skill tool to invoke `ln-500-story-quality-gate`** Pass 1. If it creates tasks (test/refactor/fix), **use Skill tool to invoke `ln-310-story-validator`** and return to Phase 3. When test task is Done, set Story In Progress -> To Review and **use Skill tool to invoke `ln-500-story-quality-gate`** Pass 2. If Pass 2 fails and creates tasks, loop to Phase 3; if Pass 2 passes, Story goes To Review -> Done via ln-500.

## Critical Rules
- Metadata first: never load task descriptions in Phase 2; only workers load full text.
- No pre-analysis: after Phase 2 counts, pick ONE task by priority (To Review > To Rework > Todo) and delegate immediately. Do not plan, analyze, or reason about other tasks until they become next in queue.
- Single-task operations: each worker handles only the passed task ID; ln-410 never bulk-updates tasks.
- Status discipline: after ln-411/ln-413/ln-414, task must be To Review; immediately invoke ln-412 on that task. Only ln-412 may set Done. Stop and report if any worker leaves task Done or In Progress.
- Source of truth: trust Linear metadata, not kanban_board.md, for orchestration decisions.
- Story status ownership: ln-410 moves Todo -> In Progress (first execution) and In Progress -> To Review (all tasks Done); ln-500 handles To Review -> Done.

## Worker Invocation (MANDATORY)

> **CRITICAL:** All worker delegations MUST use Skill tool. DO NOT execute tasks directly or do manual reviews.

| Status | Worker to Invoke | How |
|--------|-----------------|-----|
| To Review | ln-412-task-reviewer | `Use Skill tool: ln-412-task-reviewer` |
| To Rework | ln-413-task-rework | `Use Skill tool: ln-413-task-rework` |
| Todo (tests) | ln-414-test-executor | `Use Skill tool: ln-414-test-executor` |
| Todo (impl) | ln-411-task-executor | `Use Skill tool: ln-411-task-executor` |
| Quality Gate | ln-500-story-quality-gate | `Use Skill tool: ln-500-story-quality-gate` |
| Validation | ln-310-story-validator | `Use Skill tool: ln-310-story-validator` |

**❌ NEVER:** Execute task implementation directly, do "Quick Review" manually, skip Skill tool.
**✅ ALWAYS:** Use Skill tool to delegate, wait for worker completion, reload metadata after each worker.

## Definition of Done
- Story metadata and task metadata loaded via list_issues (no get_issue in Phase 2); counts shown.
- Loop executed: all To Review via ln-412; all To Rework via ln-413 then immediate ln-412 on the same task; all Todo via ln-411/ln-414 then immediate ln-412 on the same task (validated To Review after each worker).
- If tasks were created by ln-500: validated via ln-310 and executed through the loop.
- ln-500 Pass 1 invoked when impl tasks Done; Pass 2 invoked when test task Done or not needed. Result handled (pass/fail -> loop).
- Story status transitions applied (Todo -> In Progress -> To Review) and kanban updated by workers/ln-500.
- Final report with task counts and next step (if any).

## Reference Files
- Quality orchestration: `../ln-500-story-quality-gate/SKILL.md`
- Executors: `../ln-411-task-executor/SKILL.md`, `../ln-413-task-rework/SKILL.md`, `../ln-414-test-executor/SKILL.md`, `../ln-412-task-reviewer/SKILL.md`
- Auto-discovery: `CLAUDE.md`, `docs/tasks/kanban_board.md`

---
**Version:** 3.0.0 (Explicit Skill tool invocation instructions, Worker Invocation section)
**Last Updated:** 2025-12-23
