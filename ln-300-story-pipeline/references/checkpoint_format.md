# Execution Checkpoint Format

<!-- SCOPE: Pipeline execution tracking template for ln-300-story-pipeline. Tracks all 14 skills, decision points, and AC checkpoints. NOT for manual editing - auto-generated and auto-deleted by pipeline. -->

Checkpoint file tracks pipeline execution progress. All checkboxes start unchecked `- [ ]` and are marked `- [x]` as work progresses.

**Location:** `docs/tasks/checkpoints/[story_id].md`

---

# Checkpoint: [Story ID]

**Pipeline:** ln-300-story-pipeline
**Started:** YYYY-MM-DD HH:MM
**Last Updated:** YYYY-MM-DD HH:MM

---

## Ownership Log

> [!NOTE]
> **Baton Passing Pattern:** Each skill records ownership before/after work. Orchestrators record before delegating, Workers record after completing.

| Timestamp | Skill | Action | Next |
|-----------|-------|--------|------|
| ____ | ____ | Acquired/Released | ____ |

**Current Owner:** ____
**Next Expected:** ____

---

## Phase 0: Checkpoint Setup (ln-300-story-pipeline)
- [ ] Checkpoint file created/loaded
- [ ] Resume point identified (if existed)

## Phase 1: Discovery (ln-300-story-pipeline)
- [ ] Team ID auto-discovered from kanban_board.md
- [ ] Story ID parsed from request
- [ ] Story metadata loaded (ID, title, status, labels)
- [ ] Current status: ____

---

## Phase 2: Task Planning (ln-310-story-decomposer)

### Discovery & Analysis
- [ ] Story loaded from Linear (AC, Technical Notes, Context)
- [ ] NFRs stripped (not converted to tasks)
- [ ] Complexity analyzed (simple/medium/complex): ____
- [ ] Optimal task count determined (1-6): ____
- [ ] Foundation-First execution order applied
- [ ] Guide links extracted from Technical Notes

### Mode Detection
- [ ] Existing tasks queried from Linear
- [ ] Task count: ____
- **Decision Point:**
  - `count = 0` → CREATE MODE
  - `count ≥ 1 AND ADD keywords ("add", "append", "more")` → ADD MODE
  - `count ≥ 1 AND REPLAN keywords ("update plan", "replan")` → REPLAN MODE
  - `count ≥ 1 AND ambiguous` → ASK USER
- [ ] Mode selected: ____
- [ ] Reason: ____

### Delegation (one of):

#### If CREATE MODE → ln-311-task-creator
- [ ] Context research completed (codebase, schema, dependencies, docs)
- [ ] Story Correction Proposal generated (if reality differs)
- [ ] Task documents generated (7 sections each)
- [ ] NO test creation validated (scan for "write tests")
- [ ] Preview shown to user
- [ ] User confirmed (or autoApprove=true)
- [ ] Tasks created in Linear: ____ count
- [ ] kanban_board.md updated (Backlog section)

#### If ADD MODE → ln-311-task-creator (appendMode)
- [ ] Research for NEW task(s) only
- [ ] Task document(s) generated
- [ ] Preview shown
- [ ] Task(s) created in Linear: ____ count
- [ ] kanban_board.md updated

#### If REPLAN MODE → ln-312-task-replanner
- [ ] Existing tasks loaded with full descriptions
- [ ] IDEAL vs Existing comparison done
- [ ] Operations categorized:
  - KEEP: ____
  - UPDATE: ____
  - OBSOLETE: ____
  - CREATE: ____
- [ ] Status constraints checked (Todo/Backlog only for UPDATE/OBSOLETE)
- [ ] Preview shown
- [ ] User confirmed (or autoApprove=true)
- [ ] Operations executed in Linear
- [ ] kanban_board.md updated

---

## Phase 3: Verification & Execution Loop

### Iteration ____

#### Step 1: Story Verification (ln-320-story-validator)
- [ ] Story fetched from Linear (FULL description, 8 sections)
- [ ] Child Tasks metadata loaded (3-8 expected)
- [ ] Industry standards identified and researched
- [ ] Codebase verified (implementations, schema, UI, logic)
- **Decision Point:** If KISS/YAGNI conflicts with standard → Standard wins
- [ ] Story auto-corrected if reality differs

**Documentation Auto-Creation (Phase 2, Step 2c):**

| Document Type | Worker | Created | Path |
|---------------|--------|---------|------|
| Guide | - [ ] ln-321-guide-creator | Yes/No | ____ |
| ADR | - [ ] ln-322-adr-creator | Yes/No | ____ |
| Manual | - [ ] ln-323-manual-creator | Yes/No | ____ |

**Auto-Fix Checklist (16 criteria):**

*A. Structural Fixes:*
- [ ] #1: Story structure validated (8 sections)
- [ ] #2: Tasks structure validated (7 sections each)
- [ ] #3: Story statement clarified (As a/I want/So that)
- [ ] #4: AC standardized (Given/When/Then, 3-5 AC)

*B. Solution Optimization:*
- [ ] #5: Solution optimized per 2025 best practices
- [ ] #6: Libraries updated to current stable
- [ ] #13: Guide links inserted in Technical Notes
- [ ] #16: Industry standards compliance verified

*C. Workflow Optimization:*
- [ ] #7: Test Strategy added (Risk-Based Testing)
- [ ] #10: Premature test tasks removed
- [ ] #8: Documentation integrated into implementation
- [ ] #14: Foundation-First execution order applied

*D. Scope & Quality:*
- [ ] #9: Story size validated (3-8 tasks)
- **Decision Point:** If < 3 tasks → invoke ln-310-story-decomposer
  - [ ] ln-310 invoked: ____
  - [ ] Missing tasks created: ____
- [ ] #11: YAGNI violations removed
- [ ] #12: KISS violations simplified
- [ ] #15: Code quality requirements added

**Completion:**
- [ ] Story status: Backlog → Todo
- [ ] All Tasks status: Backlog → Todo
- [ ] kanban_board.md updated
- [ ] Approval comment added to Linear
- [ ] Auto-fixes applied: ____ count

---

#### Step 2: Story Execution (ln-330-story-executor)

**Task Loading:**
- [ ] Story metadata fetched (NO description)
- [ ] Child Tasks loaded via list_issues (metadata only)
- [ ] ZERO get_issue() calls for Tasks

**Orchestration Loop:**

*Priority 0: To Review Tasks*
| Task ID | ln-332-task-reviewer | Verdict |
|---------|---------------------|---------|
| ____ | - [ ] Reviewed | Accept / Minor / Rework |

*Priority 1: To Rework Tasks*
| Task ID | ln-333-task-rework | Completed |
|---------|-------------------|-----------|
| ____ | - [ ] Reworked | - [ ] To Review |

*Priority 2: Todo Tasks*
| Task ID | Worker | Completed |
|---------|--------|-----------|
| ____ | - [ ] ln-331/334 | - [ ] To Review |

> [!NOTE]
> **Matrix format:** Rows = criteria, Columns = tasks. Add columns as tasks appear. Mark `[x]` when criterion verified for that task.

**Task Execution Matrix (ln-331/ln-334):**

| Criterion | Task 1 | Task 2 | Task 3 |
|-----------|--------|--------|--------|
| Guide links read | [ ] | [ ] | [ ] |
| Implementation completed | [ ] | [ ] | [ ] |
| KISS/YAGNI applied | [ ] | [ ] | [ ] |
| Existing Code Impact | [ ] | [ ] | [ ] |
| Quality gates passed | [ ] | [ ] | [ ] |
| Status → To Review | [ ] | [ ] | [ ] |
| kanban_board.md updated | [ ] | [ ] | [ ] |

**Review Matrix (ln-332-task-reviewer):**

| Criterion | Task 1 | Task 2 | Task 3 |
|-----------|--------|--------|--------|
| Task read COMPLETELY | [ ] | [ ] | [ ] |
| Story read COMPLETELY | [ ] | [ ] | [ ] |
| Duplication searched | [ ] | [ ] | [ ] |
| Universal checks (Arch/DRY/KISS/YAGNI/Docs/Security) | [ ] | [ ] | [ ] |
| **Verdict** | ____ | ____ | ____ |
| **Reason** | ____ | ____ | ____ |

**Decision Point (per task):** Accept ✅ → Done | Minor Fixes 🔧 → Fix → Done | Needs Rework ❌ → To Rework

**Rework Matrix (ln-333-task-rework):**

| Criterion | Task 1 | Task 2 | Task 3 |
|-----------|--------|--------|--------|
| Feedback loaded | [ ] | [ ] | [ ] |
| Must-fix items addressed | [ ] | [ ] | [ ] |
| Quality gates passed | [ ] | [ ] | [ ] |
| Status → To Review | [ ] | [ ] | [ ] |

**Loop Status:**
- [ ] All Priority 0 processed
- [ ] All Priority 1 processed
- [ ] All Priority 2 processed
- [ ] Stop condition met (no more tasks to process)

**Story Transitions:**
- [ ] Story: Todo → In Progress (first task started)
- [ ] All implementation tasks Done: ____/____

---

#### Step 3: Story Review Pass 1 (ln-340-story-quality-gate)

**Preparation:**
- [ ] Story and Tasks metadata loaded
- [ ] Modified files identified

**Phase 3: Code Quality (ln-341-code-quality-checker)**
- [ ] Done implementation tasks queried
- [ ] Code analyzed (git diff, AST)
- [ ] DRY violations checked
- [ ] KISS violations checked
- [ ] YAGNI violations checked
- [ ] Architecture violations checked
- [ ] Guide compliance checked
- [ ] Issues categorized (HIGH/MEDIUM/LOW)
- **Decision Point:** No HIGH/MEDIUM → PASS, else → FAIL
- [ ] Verdict: ____
- [ ] If FAIL: Refactoring task created → STOP, go to Step 1

**Phase 4: Regression (ln-342-regression-checker)**
- [ ] Test framework detected: ____
- [ ] Tests executed (5-min timeout)
- [ ] Results parsed (total/passed/failed)
- **Decision Point:** failed=0 → PASS, else → FAIL
- [ ] Verdict: ____
- [ ] Failed tests: ____
- [ ] If FAIL: Fix task created → STOP, go to Step 1

**Phase 5: Manual Testing (ln-343-manual-tester)**
- [ ] Story type detected (API/UI): ____
- [ ] Application verified running
- [ ] AC parsed into structured list

*AC Testing:*
| AC ID | Given/When/Then | Result |
|-------|-----------------|--------|
| AC1 | ____ | - [ ] PASS / FAIL |
| AC2 | ____ | - [ ] PASS / FAIL |
| AC3 | ____ | - [ ] PASS / FAIL |

*Edge Cases (3-5):*
| Case | Result |
|------|--------|
| ____ | - [ ] PASS / FAIL |

*Error Handling:*
| Scenario | Result |
|----------|--------|
| ____ | - [ ] PASS / FAIL |

*Integration Points (2-3):*
| Integration | Result |
|-------------|--------|
| ____ | - [ ] PASS / FAIL |

- **Decision Point:** All AC PASS + no critical failures → PASS, else → FAIL
- [ ] Verdict: ____
- [ ] Temp script created: scripts/tmp_[story_id].sh
- [ ] If FAIL: Bug fix task created → STOP, go to Step 1

**Phase 6: Test Task Creation (ln-350-story-test-planner)**
- [ ] Manual test results parsed (Format v1.0)
- [ ] Risk Priority calculated (Impact × Probability)
- [ ] E2E tests selected (2-5, Priority ≥15): ____
- [ ] Integration tests selected (0-8, Priority ≥15): ____
- [ ] Unit tests selected (0-15, Priority ≥15): ____
- [ ] Total tests (10-28 limit, goal 2-7): ____
- [ ] 11-section task generated
- [ ] Existing test task checked
- **Decision Point:** count=0 → CREATE, count≥1 → REPLAN
- [ ] Mode: ____
- [ ] Worker delegated (ln-311 or ln-312)
- [ ] Test task created/updated in Linear

**Pass 1 Completion:**
- [ ] All quality gates passed (Code → Regression → Manual)
- [ ] Test task created
- [ ] Test task auto-verified: Backlog → Todo
- [ ] Comment added to Story

---

#### Step 2 (continued): Test Task Execution

- [ ] Test task selected (label "tests")
- [ ] 11 sections verified present

**ln-334-test-executor:**

*Step 1: Fix Existing Tests*
- [ ] Section 8 loaded
- [ ] Affected tests identified
- [ ] All tests updated and passing

*Step 2: New Tests (E2E → Integration → Unit)*
- [ ] E2E tests implemented (2-5): ____
- [ ] E2E tests passing
- [ ] Integration tests implemented (0-8): ____
- [ ] Integration tests passing
- [ ] Unit tests implemented (0-15): ____
- [ ] Unit tests passing
- [ ] Total within 10-28 limit: ____
- [ ] Priority ≥15 scenarios covered

*Step 3: Update Project Files*
- [ ] Section 9: Infrastructure updated (package.json, Dockerfile, compose)
- [ ] Section 10: Documentation updated (tests/README, README, CHANGELOG)
- [ ] Section 11: Legacy cleanup completed
- [ ] All tests still pass after cleanup

*Step 4: Final Verification*
- [ ] All quality gates passed
- [ ] Task moved: In Progress → To Review

**Test Task Review (ln-332-task-reviewer):**
- [ ] docker-compose.test.yml run verified
- [ ] Test limits verified (2-5/3-8/5-15, 10-28 total)
- [ ] Priority ≥15 scenarios verified
- [ ] Verdict: ____

---

#### Step 3: Story Review Pass 2 (ln-340-story-quality-gate)

**Prerequisites:**
- [ ] Test task exists
- [ ] Test task status = Done

**Verification:**
- [ ] All tests pass (0 failures)
- [ ] Total tests within 10-28 limit: ____
- [ ] All Priority ≥15 scenarios tested
- [ ] E2E tests cover all Story AC
- [ ] Tests focus on business logic (no framework tests)
- [ ] Infrastructure updated

**Decision Point:** All checks pass → Story Done, else → create fix tasks
- [ ] Verdict: ____

**If PASS:**
- [ ] Story status: To Review → Done
- [ ] kanban_board.md minimal cleanup
- [ ] Linear comment added

**If FAIL:**
- [ ] Fix tasks created: ____
- [ ] Go back to Step 1

---

## Phase 4: Completion (ln-300-story-pipeline)
- [ ] Story status = Done
- [ ] All tasks Done: ____/____
- [ ] Pipeline complete: Todo → In Progress → To Review → Done
- [ ] Completion report generated
- [ ] Checkpoint file DELETED

---

## Lifecycle

| Event | Action |
|-------|--------|
| Pipeline start | Create checkpoint, Phase 0-1 |
| After each skill | Update checkboxes, add details |
| Decision made | Record choice + reason |
| Loop iteration | Add new Iteration section |
| Pipeline end | Mark Phase 4, DELETE file |
| Context loss | Read checkpoint, resume from last `- [x]` |

---

**Version:** 2.0.0
**Last Updated:** 2025-11-22
