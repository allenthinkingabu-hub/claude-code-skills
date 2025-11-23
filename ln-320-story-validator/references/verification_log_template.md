# Verification Log Template

**Purpose:** Document evidence for each verification criterion. Agent MUST fill this log before marking any criterion as ✅.

**Usage:** Copy this template to `checkpoints/{STORY_ID}_verification_log.md` when starting verification.

---

## Story: {STORY_ID}

**Verification Date:** {DATE}
**Validator:** ln-320-story-validator

---

## Summary Table

| # | Criterion | Trigger Matched | Evidence | Verdict |
|---|-----------|-----------------|----------|---------|
| 1 | Story Structure | Always | {sections found} | ☐ |
| 2 | Tasks Structure | Always | {tasks validated} | ☐ |
| 3 | Story Statement | Always | {format check} | ☐ |
| 4 | Acceptance Criteria | Always | {AC count, format} | ☐ |
| 5 | Solution Optimization | Always | {approach validated} | ☐ |
| 6 | Library & Version | Has libraries | {versions checked} | ☐ |
| 7 | Test Strategy | Always | {strategy present} | ☐ |
| 8 | Documentation Integration | Has doc tasks | {integrated/removed} | ☐ |
| 9 | Story Size | Always | {task count} | ☐ |
| 10 | Test Task Cleanup | Has test tasks | {removed/none found} | ☐ |
| 11 | YAGNI Violations | Has scope items | {violations found} | ☐ |
| 12 | KISS Violations | Has technical approach | {simplified/ok} | ☐ |
| 13 | Guide Links | Has patterns | {links added} | ☐ |
| 14 | Foundation-First Order | Has multiple tasks | {order correct} | ☐ |
| 15 | Code Quality | Has implementation | {TODOs added} | ☐ |
| 16 | Industry Standards | Has protocols/APIs | {compliance verified} | ☐ |

---

## Detailed Evidence

### Criterion #1: Story Structure
- **Trigger:** Always (every Story)
- **Check performed:** Validated 8 sections exist in correct order
- **Evidence:** {List sections found: Story, Context, AC, Implementation Tasks, Test Strategy, Technical Notes, DoD, Dependencies}
- **Auto-fix applied:** {Yes/No - describe if yes}
- **Self-audit answer:** "I verified all 8 sections are present in order"
- **Verdict:** ☐ PASS / ☐ FAIL

### Criterion #2: Tasks Structure
- **Trigger:** Always (every Task)
- **Check performed:** Validated 7 sections per task sequentially
- **Evidence:** {List tasks validated: Task 01 (7/7), Task 02 (7/7), ...}
- **Auto-fix applied:** {Yes/No - describe if yes}
- **Self-audit answer:** "I loaded FULL description for each task and validated 7 sections"
- **Verdict:** ☐ PASS / ☐ FAIL

### Criterion #3: Story Statement
- **Trigger:** Always
- **Check performed:** Verified As a/I want/So that format
- **Evidence:** {Quote the Story statement}
- **Auto-fix applied:** {Yes/No - describe if yes}
- **Self-audit answer:** "Statement follows format: As a [persona] I want [capability] So that [value]"
- **Verdict:** ☐ PASS / ☐ FAIL

### Criterion #4: Acceptance Criteria
- **Trigger:** Always
- **Check performed:** Validated Given/When/Then format, 3-5 AC
- **Evidence:** {AC count: X, Format: Given/When/Then}
- **Auto-fix applied:** {Yes/No - describe if yes}
- **Self-audit answer:** "AC are testable and in correct format"
- **Verdict:** ☐ PASS / ☐ FAIL

### Criterion #5: Solution Optimization
- **Trigger:** Always
- **Check performed:** Evaluated if approach is best for 2025
- **Evidence:** {Approach description, why it's optimal}
- **Auto-fix applied:** {Yes/No - describe if yes}
- **Self-audit answer:** "I questioned 'Is this the best way in 2025?' and concluded: {reason}"
- **Verdict:** ☐ PASS / ☐ FAIL

### Criterion #6: Library & Version
- **Trigger:** Story mentions libraries/packages
- **Trigger matched:** {Yes/No - if No, skip this criterion}
- **Check performed:** Verified Library Research table, versions current
- **Evidence:** {Libraries: lib1 vX.Y.Z, lib2 vX.Y.Z - all current stable}
- **Auto-fix applied:** {Yes/No - describe if yes}
- **Self-audit answer:** "Library versions are current stable (checked via Context7/Ref)"
- **Verdict:** ☐ PASS / ☐ SKIP (no libraries)

### Criterion #7: Test Strategy
- **Trigger:** Always
- **Check performed:** Verified Test Strategy section exists with Risk-Based Testing
- **Evidence:** {E2E: X, Integration: Y, Unit: Z, Total: N, Priority: ≥15}
- **Auto-fix applied:** {Yes/No - describe if yes}
- **Self-audit answer:** "Test Strategy follows Risk-Based Testing approach"
- **Verdict:** ☐ PASS / ☐ FAIL

### Criterion #8: Documentation Integration
- **Trigger:** Story has standalone doc tasks
- **Trigger matched:** {Yes/No - if No, skip this criterion}
- **Check performed:** Verified no standalone doc tasks, docs integrated
- **Evidence:** {Doc tasks removed/integrated into: Task X, Task Y}
- **Auto-fix applied:** {Yes/No - describe if yes}
- **Self-audit answer:** "Documentation is integrated into implementation tasks, no standalone doc tasks"
- **Verdict:** ☐ PASS / ☐ SKIP (no doc tasks found)

### Criterion #9: Story Size & Task Granularity
- **Trigger:** Always
- **Check performed:** Verified 3-8 tasks, each 3-5h
- **Evidence:** {Task count: X, Granularity: all 3-5h / issues flagged}
- **Worker invoked:** {ln-310-story-decomposer if < 3 tasks / None}
- **Auto-fix applied:** {Yes/No - describe if yes}
- **Self-audit answer:** "Story has {X} tasks in optimal range (3-8)"
- **Verdict:** ☐ PASS / ☐ FAIL

### Criterion #10: Test Task Cleanup
- **Trigger:** Story has premature test tasks
- **Trigger matched:** {Yes/No - if No, skip this criterion}
- **Check performed:** Searched for test tasks by label/title
- **Evidence:** {Test tasks found: none / Task IDs removed}
- **Auto-fix applied:** {Yes/No - describe if yes}
- **Self-audit answer:** "No premature test tasks exist (test task created later by ln-350)"
- **Verdict:** ☐ PASS / ☐ SKIP (no test tasks found)

### Criterion #11: YAGNI Violations
- **Trigger:** Story has scope/features defined
- **Trigger matched:** {Yes/No}
- **Check performed:** Reviewed scope for premature features
- **Evidence:** {Violations found: none / moved to future scope: feature X, Y}
- **Auto-fix applied:** {Yes/No - describe if yes}
- **Self-audit answer:** "Story delivers only what is needed NOW"
- **Verdict:** ☐ PASS / ☐ FAIL

### Criterion #12: KISS Violations
- **Trigger:** Story has technical approach defined
- **Trigger matched:** {Yes/No}
- **Check performed:** Evaluated if solution is over-engineered
- **Evidence:** {Approach is simple / Simplified: removed X, Y}
- **Auto-fix applied:** {Yes/No - describe if yes}
- **Self-audit answer:** "Solution is simplest that delivers Story goal (within standard boundaries)"
- **Verdict:** ☐ PASS / ☐ FAIL

### Criterion #13: Guide Links
- **Trigger:** Story involves implementation patterns
- **Trigger matched:** {Yes/No}
- **Check performed:** Verified guide links in Technical Notes
- **Evidence:** {Guide links found: Guide 01, Guide 02 / Created via ln-321: Guide X}
- **Worker invoked:** {ln-321-guide-creator / None (guides exist)}
- **Auto-fix applied:** {Yes/No - describe if yes}
- **Self-audit answer:** "All relevant guides are linked in Technical Notes"
- **Verdict:** ☐ PASS / ☐ SKIP (no patterns)

### Criterion #14: Foundation-First Execution Order
- **Trigger:** Story has multiple tasks
- **Trigger matched:** {Yes/No}
- **Check performed:** Verified task order: Database → Repository → Service → API
- **Evidence:** {Task order: 1. DB, 2. Repo, 3. Service, 4. API - correct}
- **Auto-fix applied:** {Yes/No - describe if yes}
- **Self-audit answer:** "Tasks are ordered foundation-first for testability"
- **Verdict:** ☐ PASS / ☐ FAIL

### Criterion #15: Code Quality Fundamentals
- **Trigger:** Story has implementation tasks
- **Trigger matched:** {Yes/No}
- **Check performed:** Checked for hardcoded values, magic numbers
- **Evidence:** {No hardcoded values / TODOs added for: X, Y}
- **Auto-fix applied:** {Yes/No - describe if yes}
- **Self-audit answer:** "Configuration management approach is defined, no magic numbers"
- **Verdict:** ☐ PASS / ☐ FAIL

### Criterion #16: Industry Standards Compliance
- **Trigger:** Story involves protocols, APIs, authentication, data formats, external integrations
- **Trigger matched:** {Yes/No - if No, explicitly state why}
- **Check performed:** {Describe what was checked}
- **Applicable standard:** {Standard name + RFC/spec number OR "No applicable standard"}
- **Research evidence:**
  - Worker invoked: {ln-321-guide-creator / ln-322-adr-creator / ln-323-manual-creator / None}
  - Document created/verified: {path to guide/ADR/manual OR "existing doc at path"}
  - Linear comment: {link to comment OR "N/A"}
- **Compliance verification:** {How Story complies with standard OR "Standard not applicable because: reason"}
- **Auto-fix applied:** {Yes/No - describe if yes}
- **Self-audit answer:** "I verified implementation path via {document/worker call}. Evidence: {specific evidence}"
- **Verdict:** ☐ PASS / ☐ SKIP (no applicable standards - reason: ___)

---

## Final Checklist

Before approving Story, agent MUST confirm:

- [ ] All 16 criteria have verdict (PASS, FAIL with fix, or SKIP with reason)
- [ ] All FAIL verdicts have auto-fix applied
- [ ] All SKIP verdicts have explicit reason why criterion doesn't apply
- [ ] No criterion marked PASS without evidence
- [ ] All Self-audit answers are filled (not blank)
- [ ] Verification Log saved to checkpoints/

---

## Approval

**All criteria verified:** ☐ Yes
**Story status:** Backlog → Todo
**Tasks status:** All Backlog → Todo
**Linear comment added:** ☐ Yes (with auto-fix summary)

---

**Version:** 1.0.0
**Last Updated:** 2025-11-23
