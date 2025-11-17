# Reference Documentation Questions

**Purpose:** Define what each section of reference documentation should answer.

**Format:** Question → Expected Content → Validation Heuristics → Auto-Discovery Hints → MCP Ref Hints

---

## Table of Contents

| Document | Questions | Auto-Discovery | Priority | Line |
|----------|-----------|----------------|----------|------|
| [docs/reference/README.md](#docsreferencereadmemd) | 3 | High | High | L23 |

**Priority Legend:**
- **Critical:** Must answer all questions
- **High:** Strongly recommended
- **Medium:** Optional (can use template defaults)

**Auto-Discovery Legend:**
- **None:** No auto-discovery needed (use template as-is)
- **Low:** 1-2 questions need auto-discovery
- **High:** All questions need auto-discovery

---

<!-- DOCUMENT_START: docs/reference/README.md -->
## docs/reference/README.md

**File:** docs/reference/README.md (reference documentation hub)
**Target Sections:** Architecture Decision Records (ADRs), Project Guides, Package Manuals

**Rules for this document:**
- Hub file for reference documentation subdirectories
- Must link to adrs/, guides/, manuals/ directories
- Auto-discovery of existing files in each directory

---

<!-- QUESTION_START: 1 -->
### Question 1: Where are architecture decisions documented?

**Expected Answer:** Link to adrs/ directory, ADR format description (Nygard template), list of existing ADRs or placeholder
**Target Section:** ## Architecture Decision Records (ADRs)

**Validation Heuristics:**
- ✅ Contains link: `[ADRs](adrs/)` or `[adrs](adrs/)`
- ✅ Mentions "Architecture Decision Record" or "ADR"
- ✅ Has placeholder `{{ADR_LIST}}` or actual ADR list
- ✅ Length > 30 words

**Auto-Discovery:**
- Scan `docs/reference/adrs/` for *.md files
- Generate list dynamically from filenames
- Example: `adr-001-frontend-framework.md` → "ADR-001: Use React+Next.js"

**MCP Ref Hints:**
- Research: "Michael Nygard ADR format" (if no ADRs exist and need to explain format)
- Extract: ADR template structure (Context, Decision, Status, Consequences)
<!-- QUESTION_END: 1 -->

---

<!-- QUESTION_START: 2 -->
### Question 2: Where are reusable project patterns documented?

**Expected Answer:** Link to guides/ directory, description of guide purpose (reusable patterns, how-tos), list of existing guides or placeholder
**Target Section:** ## Project Guides

**Validation Heuristics:**
- ✅ Contains link: `[Guides](guides/)` or `[guides](guides/)`
- ✅ Mentions "patterns" or "guides" or "how-to"
- ✅ Has placeholder `{{GUIDE_LIST}}` or actual guide list
- ✅ Length > 20 words

**Auto-Discovery:**
- Scan `docs/reference/guides/` for *.md files
- Generate list dynamically from filenames
- Example: `authentication-flow.md` → "Authentication Flow Guide"

**MCP Ref Hints:**
- N/A (guides are project-specific)
<!-- QUESTION_END: 2 -->

---

<!-- QUESTION_START: 3 -->
### Question 3: Where are third-party package references documented?

**Expected Answer:** Link to manuals/ directory, description of manual purpose (package API references, version-specific), list of existing manuals or placeholder
**Target Section:** ## Package Manuals

**Validation Heuristics:**
- ✅ Contains link: `[Manuals](manuals/)` or `[manuals](manuals/)`
- ✅ Mentions "packages" or "API reference" or "manuals"
- ✅ Has placeholder `{{MANUAL_LIST}}` or actual manual list
- ✅ Length > 20 words

**Auto-Discovery:**
- Scan `docs/reference/manuals/` for *.md files
- Generate list dynamically from filenames
- Example: `axios-1.6.md` → "Axios 1.6 API Manual"

**MCP Ref Hints:**
- N/A (manuals are package-specific, created by ln-323-manual-creator)
<!-- QUESTION_END: 3 -->

---

**Overall File Validation:**
- ✅ Has links to all 3 subdirectories (adrs/, guides/, manuals/)
- ✅ Total length > 60 words

<!-- DOCUMENT_END: docs/reference/README.md -->

---

**Version:** 2.0.0 (MAJOR: Added Table of Contents and programmatic markers for context management)
**Last Updated:** 2025-11-18
