---
name: ln-200-scope-decomposer
description: Orchestrates full decomposition (scope → Epics → Stories) by delegating ln-210 → ln-220. Automates Epic+Story creation in one workflow.
---

# Scope Decomposer (Top Orchestrator)

This skill orchestrates the complete decomposition workflow from scope/initiative to User Stories by delegating Epic creation (ln-210) and Story creation (ln-220).

## When to Use This Skill

This skill should be used when:
- Start new initiative and need complete decomposition automation (scope → Epics → Stories)
- Prefer single workflow over manual Epic→Story invocation
- Create entire Epic+Story structure in one go
- Time-efficient approach for new projects

**Alternative**: If you prefer granular control, invoke coordinators manually:
1. [ln-210-epic-coordinator](../ln-210-epic-coordinator/SKILL.md) - CREATE/REPLAN Epics
2. [ln-220-story-coordinator](../ln-220-story-coordinator/SKILL.md) - CREATE/REPLAN Stories (loop per Epic)

## How It Works

The skill follows a 4-phase orchestration workflow: User Confirmation → Epic Decomposition → Story Decomposition (loop) → Summary.

### Phase 1: User Confirmation

**Objective**: Explain workflow and get user approval.

**Process**:
1. Show user what will be created:
   - Epics (3-7 Linear Projects via ln-210-epic-coordinator)
   - Stories (5-10 per Epic via ln-220-story-coordinator)
   - Estimated time: 30-45 minutes with interactive dialog
2. Ask: "Proceed with full decomposition (scope → Epics → Stories)? (yes/no)"

**Output**: User approval

---

### Phase 2: Epic Decomposition

**Objective**: Create Epics for initiative.

**Process** (AUTOMATIC invocation with Skill tool):

1. **Invocation**: `Skill(skill: "ln-210-epic-coordinator")` → AUTOMATIC
2. **Output**: 3-7 Epics created in Linear (Epic numbers, URLs)
3. **Verify**: All Epics exist in kanban_board.md before continuing

**Tools used**: Skill tool (delegation to ln-210-epic-coordinator)

---

### Phase 3: Story Decomposition (Loop per Epic)

**Objective**: Create Stories for EACH Epic sequentially.

**Process** (AUTOMATIC invocations with Skill tool):

**FOR EACH Epic** created in Phase 2:
1. **Invocation**: `Skill(skill: "ln-220-story-coordinator", epic_number="[Epic N]")` → AUTOMATIC
2. **Output**: 5-10 Stories created for this Epic (Story URLs)
3. **Verify**: All Stories exist in kanban_board.md before moving to next Epic

**Loop logic:**
- Process Epics sequentially (NOT parallel)
- Wait for ln-220 to complete before invoking for next Epic
- Automatic loop - no manual invocation needed

**Tools used**: Skill tool (delegation to ln-220-story-coordinator for each Epic)

---

### Phase 4: Summary and Next Steps

**Objective**: Provide complete overview of created decomposition.

**Process**:
1. Count total objects created:
   - Epics: N Projects
   - Stories: M Issues (breakdown per Epic)
2. Show kanban_board.md location
3. Show next steps:
   - Run ln-320-story-validator to validate all Stories
   - Use ln-310-story-decomposer to create tasks for each Story

**Output**: Summary message with counts + next steps

---

## Definition of Done

Before completing work, verify ALL checkpoints:

**✅ Epic Decomposition Complete (Phase 2):**
- [ ] ln-210-epic-coordinator invoked successfully
- [ ] 3-7 Epics created in Linear
- [ ] Epic URLs returned
- [ ] Epics visible in kanban_board.md (Epic Story Counters table)

**✅ Story Decomposition Complete (Phase 3):**
- [ ] ln-220-story-coordinator invoked for EACH Epic
- [ ] 5-10 Stories created per Epic
- [ ] Story URLs returned for each Epic
- [ ] All Stories visible in kanban_board.md (Backlog section under Epic headers)

**✅ Summary Provided (Phase 4):**
- [ ] Total counts displayed (Epics, Stories)
- [ ] kanban_board.md location shown
- [ ] Next steps provided (validation, task creation)

**Output**: Summary message with full decomposition results (Epics + Stories per Epic)

---

## Example Usage

**Full Decomposition (First Time):**
```
"Decompose initiative: OAuth 2.0 Authentication System"
```

**Process:**
1. User Confirmation → Explain workflow (scope → ln-210 → (loop) ln-220), user confirms
2. Epic Decomposition → ln-210-epic-coordinator creates 3 Epics:
   - Epic 7: OAuth Client Management
   - Epic 8: Token Operations
   - Epic 9: Security & Compliance
3. Story Decomposition (Loop):
   - Epic 7 → ln-220 → 5 Stories (US004-US008)
   - Epic 8 → ln-220 → 6 Stories (US009-US014)
   - Epic 9 → ln-220 → 4 Stories (US015-US018)
4. Summary → 3 Epics, 15 Stories total, next steps (validation, task creation)

---

## Integration with Ecosystem

**Calls:**
- **ln-210-epic-coordinator** (Phase 2) - CREATE/REPLAN Epics
- **ln-220-story-coordinator** (Phase 3, loop) - CREATE/REPLAN Stories per Epic

**Called by:**
- **Manual** - user invokes directly for full decomposition automation

**Downstream:**
- **ln-320-story-validator** - validates all created Stories
- **ln-310-story-decomposer** - creates tasks for each Story

---

## Best Practices

- **Automation:** Prefer ln-200-scope-decomposer for new initiatives to save time (single workflow vs manual Epic→Story)
- **Manual control:** If Epic/Story requirements complex, invoke ln-210 and ln-220 manually for granular control
- **Validation:** ALWAYS run ln-320-story-validator after full decomposition (validate all Stories before task creation)
- **Sequential processing:** Epics created first (Phase 2), then Stories per Epic (Phase 3 loop) - ensures Epic IDs available

---

**Version:** 1.1.0 (Renamed from ln-200-decomposition-pipeline for naming consistency with -decomposer suffix pattern. Previous: v1.0.0)
**Last Updated:** 2025-11-17
