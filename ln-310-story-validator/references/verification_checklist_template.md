# Story Verification Checklist (Template)

General structure and category overview for ln-310-story-validator verification process.

**CRITICAL PRINCIPLE:** This skill ALWAYS auto-fixes all issues detected. Never leave Story in Backlog with feedback - fix and approve.

---

## Verification Categories (17 Criteria)

| Category | Criteria | Priority | Details |
|----------|----------|----------|---------|
| **Structural** | #1-#4 | HIGH | Story/Tasks structure, Statement, AC → [structural_validation.md](structural_validation.md) |
| **Solution & Standards** | #5-#8 | HIGH | Solution optimization, Library versions, Test Strategy, Docs → [solution_validation.md](solution_validation.md) |
| **Workflow & Principles** | #9-#12 | MEDIUM | Story size, Test cleanup, YAGNI, KISS → [workflow_validation.md](workflow_validation.md) |
| **Quality & Documentation** | #13-#17 | MEDIUM | Doc links, Foundation-first, Code quality, Standards, Pattern-specific docs → [quality_validation.md](quality_validation.md) |

---

## Execution Order (Research-First, 5 Phases)

**Detailed workflow:** See [SKILL.md Workflow Overview](../SKILL.md#workflow-overview) for complete Phase 1-5 descriptions.

**Quick summary:**
- **Phase 1:** Discovery & Loading (auto-discover config, load metadata, upstream validation)
- **Phase 2:** TRIVIAL CRUD Detection → **IF TRIVIAL:** skip Phase 2-3, MCP fallback in Phase 4 (#5, #6, #16, #17), fast path ~2 min; **IF NON-TRIVIAL:** MANDATORY research (domain extraction, ln-002 delegation, findings analysis, improvement score), deep path ~10 min
- **Phase 3:** DECISION POINT (NON-TRIVIAL ONLY) - REPLAN if ≥50% improvement OR CONTINUE to Phase 4
- **Phase 4:** Structural + Solution Auto-Fix (4 categories: Structural #1-#4 → Solution #5-#8 → Workflow #9-#12 → Quality #13-#17); Criteria #5, #6, #16, #17 use conditional research (Phase 2 findings OR MCP fallback)
- **Phase 5:** Approve & Notify (set Todo status, update kanban_board.md, Linear comment, tabular output)

---

## Quick Reference Matrix

| # | Criterion | Pass | Evidence Required |
|---|-----------|------|-------------------|
| 1 | Story follows template? | ☐ | Section list |
| 2 | All Tasks follow template? | ☐ | Task validation count |
| 3 | Clear Story statement? | ☐ | Quote statement |
| 4 | Testable AC? | ☐ | AC count |
| 5 | Solution optimized? | ☐ | Guide paths from Phase 2 research |
| 6 | Library versions latest? | ☐ | Manual paths from Phase 2 research |
| 7 | Test Strategy present? | ☐ | Section exists (empty) |
| 8 | Docs integrated? | ☐ | Integration proof |
| 9 | Size 3-8 Tasks? | ☐ | Task count |
| 10 | No premature test tasks? | ☐ | Search result |
| 11 | YAGNI? | ☐ | Scope review |
| 12 | KISS? | ☐ | Simplicity reason |
| 13 | Guides referenced? | ☐ | Guide paths |
| 14 | Foundation-first? | ☐ | Task order |
| 15 | No hardcoded values? | ☐ | TODO placeholders |
| 16 | Standards compliant? | ☐ | Standards list + Guide paths from Phase 2 |
| 17 | Technical Documentation? | ☐ | All doc paths from Phase 2 (guides/manuals/ADRs for detected patterns) |

---

## Auto-Fix Hierarchy

**CRITICAL:** Industry Standards (#16) checked BEFORE KISS/YAGNI (#11-#12).

**Detailed workflow:** See [workflow_validation.md Auto-Fix Hierarchy](workflow_validation.md#auto-fix-hierarchy-critical) for complete priority levels, decision flow, and example scenarios.

**Quick rule:** Standards (Level 1-2) override simplicity principles (Level 3).

---

## Evidence-Based Verification Protocol

**MANDATORY:** Before marking ANY criterion as ✅, agent MUST:

1. **Answer Self-Audit Question** for that criterion (not blank)
2. **Provide concrete evidence** (document path, tool result, or explicit reason)
3. **Document in Linear comment** (NOT separate file)

**If evidence missing → CANNOT mark ✅ → MUST perform required action first**

---

## Detailed Validation Rules

For detailed instructions, examples, and auto-fix actions for each category:

1. **Structural (#1-#4)** → See [structural_validation.md](structural_validation.md)
2. **Solution (#5-#8)** → See [solution_validation.md](solution_validation.md)
3. **Workflow (#9-#12)** → See [workflow_validation.md](workflow_validation.md)
4. **Quality (#13-#17)** → See [quality_validation.md](quality_validation.md)

---

## Post-Verification (Always Approve)

**Result:** ALWAYS Approve → Todo (after ALL auto-fixes applied)
- Story: Backlog → Todo
- All child Tasks: Backlog → Todo
- kanban_board.md: Updated with APPROVED marker
- Linear comment: Validation summary with fixes, docs, standards evidence

> [!NOTE]
> No "Keep in Backlog" path exists - all issues auto-fixed before approval

> [!WARNING]
> Marking ✅ without documented evidence = INVALID verification

---

**Version:** 1.0.0
**Last Updated:** 2025-12-21
