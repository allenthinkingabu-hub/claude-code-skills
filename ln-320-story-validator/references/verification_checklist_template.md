# Story Verification Checklist (Template)

General structure and category overview for ln-320-story-validator verification process.

**CRITICAL PRINCIPLE:** This skill ALWAYS auto-fixes all issues detected. Never leave Story in Backlog with feedback - fix and approve.

---

## Verification Categories (20 Criteria)

| Category | Criteria | Priority | Details |
|----------|----------|----------|---------|
| **Structural** | #1-#4 | HIGH | Story/Tasks structure, Statement, AC → [structural_validation.md](structural_validation.md) |
| **Solution & Standards** | #5-#8 | HIGH | Solution optimization, Library versions, Test Strategy, Docs → [solution_validation.md](solution_validation.md) |
| **Workflow & Principles** | #9-#12 | MEDIUM | Story size, Test cleanup, YAGNI, KISS → [workflow_validation.md](workflow_validation.md) |
| **Quality & Documentation** | #13-#20 | MEDIUM | Doc links, Foundation-first, Code quality, Standards, API Technical Aspects → [quality_validation.md](quality_validation.md) |

---

## Execution Order (Sequential)

1. **Structural (#1-#4)** - MUST complete first
   - Story structure → Tasks structure → Story Statement → Acceptance Criteria
   - **Why first:** Can't validate solution until structure exists

2. **Solution & Standards (#5-#8)** - AFTER Structural
   - Solution optimization → Library versions → Test Strategy → Documentation
   - **Why second:** Depends on structured Technical Notes

3. **Workflow & Principles (#9-#12)** - AFTER Solution
   - Story size → Test cleanup → YAGNI → KISS
   - **Why third:** Depends on finalized solution approach

4. **Quality & Documentation (#13-#20)** - LAST
   - Documentation links → Foundation-first → Code quality → Standards → API Technical Aspects
   - **Why last:** Depends on all previous fixes

---

## Quick Reference Matrix

| # | Criterion | Pass | Evidence Required |
|---|-----------|------|-------------------|
| 1 | Story follows template? | ☐ | Section list |
| 2 | All Tasks follow template? | ☐ | Task validation count |
| 3 | Clear Story statement? | ☐ | Quote statement |
| 4 | Testable AC? | ☐ | AC count |
| 5 | Solution optimized? | ☐ | MCP Ref query + result |
| 6 | Library versions latest? | ☐ | Context7 query + versions |
| 7 | Test Strategy present? | ☐ | Section exists (empty) |
| 8 | Docs integrated? | ☐ | Integration proof |
| 9 | Size 3-8 Tasks? | ☐ | Task count |
| 10 | No premature test tasks? | ☐ | Search result |
| 11 | YAGNI? | ☐ | Scope review |
| 12 | KISS? | ☐ | Simplicity reason |
| 13 | Guides referenced? | ☐ | Guide paths |
| 14 | Foundation-first? | ☐ | Task order |
| 15 | No hardcoded values? | ☐ | TODO placeholders |
| 16 | Standards compliant? | ☐ | Doc path OR worker call |
| 17 | Rate Limiting? (API) | ☐ | Guide created OR skip reason |
| 18 | Auth pattern? (Auth) | ☐ | Manual/ADR created OR skip reason |
| 19 | Error Handling? | ☐ | Evidence path |
| 20 | Logging? | ☐ | Evidence path |

---

## Auto-Fix Hierarchy

**Industry Standards (#16) checked BEFORE KISS/YAGNI (#11-#12)**

```
Priority Levels:
  Level 1: Industry Standards (RFC, OWASP, REST) - CANNOT compromise
  Level 2: Security Standards (Auth, encryption) - CANNOT compromise
  Level 3: KISS/YAGNI/DRY - UNLESS conflicts with Level 1-2
```

**Example:**
- ❌ "Use custom auth for simplicity" (KISS conflicts with OAuth RFC 6749)
- ✅ "Use OAuth 2.0 RFC 6749 compliant flow" (Standard overrides simplicity)

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
4. **Quality (#13-#20)** → See [quality_validation.md](quality_validation.md)

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
