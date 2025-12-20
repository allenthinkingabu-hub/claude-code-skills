# Documentation Audit Checklist

Detailed checks per category.

## 1. Hierarchy & Links

### Must Pass
- [ ] CLAUDE.md exists at project root
- [ ] CLAUDE.md links to all primary docs (README, docs/*)
- [ ] All docs in docs/ reachable from CLAUDE.md (max 2 hops)
- [ ] No broken internal links (404)
- [ ] No orphaned .md files (unreachable from CLAUDE.md)

### Should Pass
- [ ] Consistent link format (relative paths)
- [ ] Links use descriptive text (not "click here")
- [ ] Bidirectional links for related docs
- [ ] TOC in files >100 lines

### Scoring
- 10/10: All checks pass
- -1 per broken link
- -2 per orphaned file
- -3 if CLAUDE.md missing or doesn't link to docs/

---

## 2. Single Source of Truth (SSOT)

### Must Pass
- [ ] No identical paragraphs across files
- [ ] No copy-pasted sections
- [ ] Shared concepts defined in one place with links elsewhere
- [ ] Clear ownership: each concept has one authoritative source

### Should Pass
- [ ] Cross-references use links, not inline copies
- [ ] Definitions not repeated (link to glossary/source)
- [ ] Version numbers in one place only
- [ ] Config examples not duplicated

### Detection Patterns
- Same paragraph in multiple files
- Similar tables with same data
- Repeated code examples
- Same list items in different docs

### Scoring
- 10/10: No duplication
- -1 per minor duplication (<50 words)
- -2 per major duplication (>50 words)
- -3 per full section copy

---

## 3. Context Compactness

### Must Pass
- [ ] Files within size limits (see size_limits.md)
- [ ] No filler words (simply, easily, basically, actually)
- [ ] Active voice used (not passive)
- [ ] Short sentences (<25 words)

### Should Pass
- [ ] Tables preferred over prose for comparisons
- [ ] Lists preferred over paragraphs for sequences
- [ ] Code examples focused (one concept each)
- [ ] No redundant explanations

### Detection Patterns
- Verbose phrases (in order to → to)
- Long paragraphs (>5 sentences)
- Repeated information within same doc
- Over-explained obvious concepts

### Scoring
- 10/10: Concise throughout
- -1 per verbose section
- -2 per file exceeding limits
- -3 per bloated document (>50% over limit)

---

## 4. Requirements Compliance

### Must Pass
- [ ] CLAUDE.md has: Repository section, Key Concepts, Important Details
- [ ] README.md has: About, Features, Installation, Usage
- [ ] SKILL.md has: YAML frontmatter (name, description), workflow, critical notes
- [ ] All docs end with single blank line (POSIX)

### Should Pass
- [ ] Consistent heading hierarchy (h1 → h2 → h3)
- [ ] Code blocks have language tags
- [ ] Tables properly formatted
- [ ] Callouts/admonitions for warnings

### Document-Specific Checks

| Document | Required Sections |
|----------|-------------------|
| CLAUDE.md | Repository, Key Concepts, Important Details |
| README.md | About, Features, Installation, Usage, License |
| SKILL.md | Frontmatter, Purpose, Workflow, Critical Notes, Version |
| Guide | Purpose, Steps, Examples, Troubleshooting |
| ADR | Context, Decision, Consequences |

### Scoring
- 10/10: All required sections present
- -1 per missing optional section
- -2 per missing required section
- -3 per malformed document structure

---

## 5. Actuality

### Must Pass
- [ ] File paths in docs match actual file structure
- [ ] Command examples are runnable
- [ ] API endpoints exist and match docs
- [ ] Config examples match current schema

### Should Pass
- [ ] Version numbers current
- [ ] Screenshots match current UI (if any)
- [ ] Links to external resources valid
- [ ] Dependency versions accurate

### Code vs Docs Priority
When mismatch found:
1. **Code is truth** - flag doc for update
2. Report: "Doc says X, code does Y"
3. Action: "Update doc to reflect code"

### Scoring
- 10/10: Docs match code exactly
- -1 per minor mismatch (formatting, names)
- -2 per functional mismatch (wrong behavior described)
- -3 per critical mismatch (security, breaking changes)

---

## 6. Legacy Cleanup

### Must Pass
- [ ] No "History" or "Changelog" sections in docs (use CHANGELOG.md)
- [ ] No "was previously", "used to be" language
- [ ] No commented-out documentation
- [ ] No deprecated feature documentation without removal date

### Should Pass
- [ ] No TODO comments in docs older than 30 days
- [ ] No references to removed features
- [ ] No migration guides for completed migrations
- [ ] No "temporary" notes that are permanent

### Detection Patterns
- "In version X.Y, we changed..."
- "Previously, this was..."
- "TODO: update this section"
- "Legacy: kept for backward compatibility"
- Dates more than 6 months old in inline notes

### Scoring
- 10/10: Current state only
- -1 per legacy note
- -2 per deprecated section kept
- -3 per major outdated documentation

---

## Quick Audit Commands

```bash
# Find orphaned files (files not linked from any other)
grep -rL "filename.md" docs/

# Find broken links
grep -roh '\[.*\](.*\.md)' docs/ | grep -v http

# Find TODO comments
grep -rn "TODO\|FIXME\|XXX" docs/

# Find verbose phrases
grep -rni "in order to\|at this point\|has the ability" docs/

# Check file sizes
wc -l docs/**/*.md | sort -n
```
