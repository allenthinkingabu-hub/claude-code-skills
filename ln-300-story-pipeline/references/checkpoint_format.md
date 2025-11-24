# Execution Checkpoint Format

<!-- SCOPE: Pipeline execution tracking template for ln-300-story-pipeline. Compact History Pattern: full Ownership Log + collapsed completed phases + detailed current phase only. Auto-generated and auto-deleted by pipeline. -->

Checkpoint file tracks pipeline execution with minimal token usage. Completed phases are collapsed to one-line summaries. Only current phase has detailed checkboxes.

**Location:** `docs/tasks/checkpoints/[story_id].md`

---

# Checkpoint: [Story ID]

**Pipeline:** ln-300-story-pipeline
**Started:** YYYY-MM-DD HH:MM
**Current:** Phase X, Step Y (skill-name)

---

## Ownership Log

> [!NOTE]
> **Baton Passing Pattern:** Each skill records ownership before/after work. This log is NEVER collapsed - full history preserved.

| Timestamp | Skill | Action | Next |
|-----------|-------|--------|------|
| ____ | ____ | Acquired/Released | ____ |

**Current Owner:** ____

---

## Completed Phases

> [!NOTE]
> **Collapse Rule:** When phase/step completes, replace detailed checkboxes with one-line summary. Format: `### Phase X ✅ (key results)`

<!-- Example collapsed phases:
### Phase 0-1 ✅
Setup complete, Story US001 loaded (status: Backlog)

### Phase 2 ✅ (ln-310 → ln-311)
CREATE MODE, 4 impl tasks created, kanban updated

### Phase 3, Iteration 1 ✅
- Step 1: 16 auto-fixes, Backlog → Todo
- Step 2: 4/4 impl tasks Done
- Step 3 Pass 1: Code ✅, Linter ✅, Regression ✅, Manual ✅, Test task API-55 created
-->

---

## Current Phase

> [!NOTE]
> **Expand Rule:** Only current phase/step has detailed checkboxes. Copy from Phase Templates below when starting new phase.

<!-- Current phase details go here. Example:

### Phase 3, Iteration 2

#### Step 2: Story Execution (ln-330-story-executor)
- [x] Test task selected (API-55)
- [x] 11 sections verified
- [ ] ln-334-test-executor delegated  <-- CURRENT POSITION

**Decision Points:**
- Test task type: Story Finalizer (11 sections)
-->

---

## Phase Templates

> [!NOTE]
> **Usage:** Copy relevant template to "Current Phase" when starting that phase. Delete template content after copying.

<details>
<summary>Phase 0-1: Setup & Discovery (ln-300)</summary>

### Phase 0: Checkpoint Setup
- [ ] Checkpoint file created/loaded
- [ ] Resume point identified (if existed)

### Phase 1: Discovery
- [ ] Team ID auto-discovered from kanban_board.md
- [ ] Story ID parsed from request
- [ ] Story metadata loaded (ID, title, status, labels)
- [ ] Current status: ____

</details>

<details>
<summary>Phase 2: Task Planning (ln-310)</summary>

### Phase 2: Task Planning (ln-310-story-decomposer)

**Discovery & Analysis:**
- [ ] Story loaded from Linear (AC, Technical Notes, Context)
- [ ] Complexity analyzed: ____
- [ ] Optimal task count (1-6): ____

**Mode Detection:**
- [ ] Existing tasks count: ____
- [ ] Mode selected: CREATE / ADD / REPLAN
- [ ] Reason: ____

**Delegation:**
- [ ] Worker invoked: ln-311 / ln-312
- [ ] Tasks created/updated: ____ count
- [ ] kanban_board.md updated

</details>

<details>
<summary>Phase 3, Step 1: Story Verification (ln-320)</summary>

### Step 1: Story Verification (ln-320-story-validator)
- [ ] Story fetched (8 sections)
- [ ] Tasks metadata loaded (3-8 expected): ____
- [ ] Industry standards researched
- [ ] Codebase verified

**Documentation Created:**
| Type | Worker | Path |
|------|--------|------|
| Guide | ln-321 | ____ |
| ADR | ln-322 | ____ |
| Manual | ln-323 | ____ |

**Auto-Fixes Applied:** ____/16

**Status Transitions:**
- [ ] Story: Backlog → Todo
- [ ] Tasks: Backlog → Todo

</details>

<details>
<summary>Phase 3, Step 2: Story Execution (ln-330)</summary>

### Step 2: Story Execution (ln-330-story-executor)

**Task Loading:**
- [ ] Child Tasks loaded (metadata only)

**Orchestration Loop:**

| Task ID | Status | Worker | Verdict |
|---------|--------|--------|---------|
| ____ | ____ | ln-331/332/333/334 | ____ |

**Loop Status:**
- [ ] All To Review → processed
- [ ] All To Rework → processed
- [ ] All Todo → processed
- [ ] Stop condition met

**Story Transitions:**
- [ ] Story: Todo → In Progress
- [ ] Impl tasks Done: ____/____

</details>

<details>
<summary>Phase 3, Step 3 Pass 1: Story Quality Gate (ln-340)</summary>

### Step 3: Story Review Pass 1 (ln-340-story-quality-gate)

**Phase 3: Code Quality (ln-341)**
- [ ] Verdict: PASS / FAIL
- [ ] If FAIL: Refactoring task created → STOP

**Phase 3.5: Linter Check**
- [ ] Errors: ____
- [ ] Verdict: PASS / FAIL
- [ ] If FAIL: Lint fix task created → STOP

**Phase 4: Regression (ln-342)**
- [ ] Framework: ____
- [ ] Results: ____/____
- [ ] Verdict: PASS / FAIL
- [ ] If FAIL: Fix task created → STOP

**Phase 5: Manual Testing (ln-343)**
- [ ] Story type: API / UI
- [ ] AC results: ____/____
- [ ] Verdict: PASS / FAIL
- [ ] Temp script: scripts/tmp_[story_id].sh
- [ ] If FAIL: Bug fix task created → STOP

**Phase 6: Test Task Creation (ln-350)**
- [ ] E2E tests (2-5): ____
- [ ] Integration tests (0-8): ____
- [ ] Unit tests (0-15): ____
- [ ] Total (10-28): ____
- [ ] Mode: CREATE / REPLAN
- [ ] Test task created: ____

</details>

<details>
<summary>Phase 3, Step 2 (continued): Test Task Execution (ln-334)</summary>

### Step 2 (continued): Test Task Execution

- [ ] Test task selected (label "tests")
- [ ] 11 sections verified

**ln-334-test-executor:**
- [ ] Step 1: Existing tests fixed
- [ ] Step 2: New tests (E2E ____, Int ____, Unit ____)
- [ ] Step 3: Infrastructure + Docs + Cleanup
- [ ] Step 4: Quality gates passed
- [ ] Status: In Progress → To Review

**Test Task Review (ln-332):**
- [ ] docker-compose.test.yml passed
- [ ] Test limits verified
- [ ] Verdict: ____

</details>

<details>
<summary>Phase 3, Step 3 Pass 2: Final Quality Gate (ln-340)</summary>

### Step 3: Story Review Pass 2 (ln-340-story-quality-gate)

**Prerequisites:**
- [ ] Test task exists
- [ ] Test task status = Done

**Verification:**
- [ ] All tests pass (0 failures)
- [ ] Total tests within 10-28: ____
- [ ] Priority ≥15 scenarios tested
- [ ] E2E covers all Story AC

**Decision:** PASS → Story Done / FAIL → create fix tasks
- [ ] Verdict: ____

**If PASS:**
- [ ] Story: To Review → Done
- [ ] kanban_board.md cleanup
- [ ] Linear comment added

</details>

<details>
<summary>Phase 4: Completion (ln-300)</summary>

### Phase 4: Completion
- [ ] Story status = Done
- [ ] All tasks Done: ____/____
- [ ] Completion report generated
- [ ] Checkpoint file DELETED

</details>

---

## Lifecycle

| Event | Action |
|-------|--------|
| Pipeline start | Create checkpoint with Phase 0-1 in "Current Phase" |
| Phase/Step complete | Collapse to summary in "Completed Phases", clear "Current Phase" |
| New phase/step start | Copy template to "Current Phase", fill details |
| Ownership change | Add row to Ownership Log, update Current Owner |
| Decision made | Record in current phase section |
| Pipeline end | Delete checkpoint file |
| Context loss | Read checkpoint, resume from "Current Phase" position |

**Collapse Format:**
```markdown
### Phase X ✅ (key-skill)
Summary: result1, result2, decision made
```

**Token Savings:** ~70-80% vs full checkboxes (60-80 lines vs 400+)

---

**Version:** 3.0.0 (Compact History Pattern: collapsed completed phases, detailed current phase only)
**Last Updated:** 2025-11-23
