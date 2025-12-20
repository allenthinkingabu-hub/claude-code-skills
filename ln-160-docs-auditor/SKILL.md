---
name: ln-160-docs-auditor
description: Audit project documentation quality across 6 categories (Hierarchy, SSOT, Compactness, Requirements, Actuality, Legacy). Use when documentation needs quality review, after major doc updates, or as part of ln-100-documents-pipeline. Outputs Compliance Score X/10 per category + Findings + Recommended Actions.
---

# Documentation Auditor

Audit project documentation quality. Universal for any tech stack.

## Purpose

- Verify documentation hierarchy with CLAUDE.md as root
- Detect duplication and enforce Single Source of Truth
- Check context compactness and token efficiency
- Validate document structure against requirements
- Ensure docs match current code state
- Identify and flag legacy/outdated content for removal

## Invocation

- **Direct:** User invokes for documentation quality review
- **Pipeline:** Called by ln-100-documents-pipeline (Phase 5, if auditDocs=true)

## Workflow

1. **Scan:** Find all .md files in project (CLAUDE.md, README.md, docs/**)
2. **Build Tree:** Construct hierarchy from CLAUDE.md outward links
3. **Audit:** Run 6 category checks (see Audit Categories below)
4. **Score:** Calculate X/10 per category
5. **Report:** Output findings and recommended actions

## Audit Categories

| # | Category | What to Check |
|---|----------|---------------|
| 1 | **Hierarchy & Links** | CLAUDE.md is root; all docs reachable via links; no orphaned files; no broken links |
| 2 | **Single Source of Truth** | No content duplication; duplicates replaced with links to source; clear ownership |
| 3 | **Context Compactness & Scannability** | Concise writing; prose→tables for comparisons; F-pattern friendly; see [size_limits.md](references/size_limits.md) |
| 4 | **Requirements Compliance** | Correct sections per doc type; within size limits; proper formatting |
| 5 | **Actuality** | Docs match code; code is priority; outdated info flagged; examples runnable |
| 6 | **Legacy Cleanup** | No history sections; no "was changed" notes; no deprecated info; current state only |

## Output Format

```markdown
## Documentation Audit Report - [DATE]

### Compliance Score

| Category | Score | Issues |
|----------|-------|--------|
| Hierarchy & Links | X/10 | N issues found |
| Single Source of Truth | X/10 | N duplications |
| Context Compactness & Scannability | X/10 | N verbose sections |
| Requirements Compliance | X/10 | N violations |
| Actuality | X/10 | N mismatches with code |
| Legacy Cleanup | X/10 | N legacy items |
| **Overall** | **X/10** | |

### Critical Findings

- [ ] **[Category]** `path/file.md:line` - Issue description. **Action:** Fix suggestion.

### Recommended Actions

| Priority | Action | Location | Category |
|----------|--------|----------|----------|
| High | Remove duplicate section | docs/X.md | SSOT |
| Medium | Add link to CLAUDE.md | docs/Y.md | Hierarchy |
```

## Scoring Rules

| Score | Meaning |
|-------|---------|
| 10/10 | No issues |
| 8-9/10 | Minor issues (formatting, small redundancies) |
| 6-7/10 | Moderate issues (some duplication, missing links) |
| 4-5/10 | Significant issues (orphaned docs, outdated content) |
| 1-3/10 | Critical issues (major mismatches, broken hierarchy) |

## Reference Files

- Size limits and targets: [references/size_limits.md](references/size_limits.md)
- Detailed checklist: [references/audit_checklist.md](references/audit_checklist.md)

## Critical Notes

- **Code is priority:** When docs contradict code, flag docs for update (not code)
- **Delete, don't archive:** Legacy content should be removed, not moved to "archive"
- **No history:** Documents describe current state only; git tracks history
- **Universal:** Works with any tech stack; no language-specific checks

---
**Version:** 1.0.0
**Last Updated:** 2025-12-20
