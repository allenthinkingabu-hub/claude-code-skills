---
name: ln-321-guide-creator
description: Creates minimal project guides (6 sections, 300-500 words) documenting reusable patterns. AUTO-RESEARCH via MCP Ref/Context7. Used when new pattern discovered. Returns guide path for linking.
---

# Guide Creator Skill

Create minimal project guides (6 sections, 300-500 words) documenting reusable patterns and best practices.

## When to Use This Skill

This skill should be used when:
- A new pattern is discovered during task implementation
- Pattern is reusable across multiple tasks/stories
- Pattern is not yet documented in `docs/reference/guides/`
- Document architectural decision or best practice
- Task verification identifies missing guide

## How It Works

### Phase 1: Research & Discovery (Automated)

**Objective**: Automatically research pattern best practices and gather sources.

**Input:** Pattern name/description (e.g., "HTTP Client Connection Pooling")

**Steps:**

1. **Search library documentation via MCP Ref:**
   - Query: "[pattern name] best practices [language/framework]"
   - Example: "HTTP client connection pooling Python FastAPI"
   - Extract: Official recommendations, configuration, lifecycle management
   - Collect: Library versions, official docs URLs

2. **Search Context7 for framework patterns:**
   - Query: "[pattern name] [framework]"
   - Example: "connection pooling FastAPI httpx"
   - Extract: Framework-specific implementations, recommended libraries
   - Collect: Code structure patterns, anti-patterns

3. **Analyze findings:**
   - Identify core principle (industry standard)
   - Identify 2-3 do/don't patterns
   - Compile sources with dates/versions

**Output:**
- Principle statement with citations
- 2-3 do/don't patterns
- Sources list with versions/dates (2-3 sources)

**Tools:** MCP Ref (`ref_search_documentation`), Context7 (`mcp__context7__*`)

> [!NOTE]

> WebSearch removed - MCP Ref + Context7 sufficient for quality guides

---

### Phase 2: Pattern Analysis

**Input:** Research data from Phase 1

**Steps:**
1. Identify pattern category (architecture, testing, API design, etc.)
2. **Use researched principle** as industry best practice baseline
3. Define how pattern applies to project context
4. **Use researched do/don't patterns** for guide content

### Phase 3: Guide Generation

**Generate guide with 6 required sections:**

1. **SCOPE tags** - Document boundaries (HTML comments after title)
2. **Principle** - Industry best practice with version/date citation (1-2 sentences)
3. **Our Implementation** - How pattern applies to project context (1 paragraph, NO alternatives/rationale)
4. **Patterns** - Table format with 3 columns (Do ✅ | Don't ❌ | When)
5. **Sources** - 2-3 references with dates/versions
6. **Related + Last Updated** - Navigation (ADRs + Guides) + date

**Validation:**
- SCOPE tags present (first 3-5 lines after title)
- All sources dated (2025 or version specified)
- Principle cites official docs
- NO code snippets (structural descriptions only)
- NO ADR concepts ("Alternatives rejected", "Decision rationale")
- Table format for Patterns (3 columns)
- Target length: 300-500 words

Shows preview for review.

### Phase 4: Update Documentation Hub (Optional)

**Objective**: Update reference/README.md to include link to new guide.

**Process**:
1. Check if `docs/reference/README.md` exists
2. If exists:
   - Use **Read** tool to check if it has `{{GUIDE_LIST}}` placeholder
   - If placeholder exists:
     - Use **Edit** tool to add new guide entry BEFORE placeholder:
       ```
       - [NN: Pattern Name](guides/NN-pattern-name.md)
       {{GUIDE_LIST}}
       ```
   - If no placeholder found:
     - Skip update, notify user: "Skipped README.md update (placeholder not found)"
3. If README.md doesn't exist:
   - Skip this step
   - Notify user: "Skipped README.md update (file not found)"

**Output**: Updated `docs/reference/README.md` with new guide link (if file exists)

---

### Phase 5: Confirmation & Storage

1. User reviews generated guide
2. Type "confirm" to proceed
3. Save to `docs/reference/guides/[NN]-[pattern-name].md`
4. Return file path for linking

---

### Phase 6: Validate Against Documentation Standards

**Objective**: Ensure created guide complies with project documentation requirements.

**Process**:

1. **Check for DOCUMENTATION_STANDARDS.md**:
   - Use Read tool: `docs/DOCUMENTATION_STANDARDS.md` (in target project)
   - If file exists: Read and use as validation source
   - If file does NOT exist: Apply industry best practices (project created before ln-111 v8.0.0)

2. **Verify Requirements**:
   - **SCOPE tags**: Present in first 3-5 lines (HTML comment `<!-- SCOPE: ... -->`)
   - **Maintenance section**: At end with Update Triggers + Verification + Last Updated
   - **Markdown quality**: Header depth ≤ h3, descriptive links, code blocks with language tags
   - **POSIX compliance**: Files end with single blank line

3. **Auto-Fix Violations**:
   - Missing SCOPE tags → Add (Edit tool)
   - Missing Maintenance section → Add (Edit tool)
   - Missing final blank line → Add (Edit tool)

4. **Report Compliance**:
   - "✅ Documents validated (SCOPE tags, Maintenance section, POSIX compliance)"
   - OR: "⚠️ Auto-fixed {count} violations: {list}"

**Reference**: See [DOCUMENTATION_STANDARDS.md](../DOCUMENTATION_STANDARDS.md) for complete requirements (if available in target project).

**Output**: Validated guide compliant with project standards

---

## Example Usage

**Request:**
```
"Create guide for External Client Pattern (HTTP client connection pooling)"
```

**Execution:**
1. **Research** (Phase 1) - MCP Ref (httpx docs), Context7 (FastAPI patterns)
2. **Analysis** (Phase 2) - Pattern: HTTP client lifecycle, Principle: Connection pooling, Alternatives: httpx vs requests vs aiohttp
3. **Generation** (Phase 3) - Complete guide with researched sources, alternatives, anti-patterns
4. **Update README** (Phase 4) - Add link to docs/reference/README.md
5. **Storage** (Phase 5) - `docs/reference/guides/12-external-client-pattern.md` → Return path for linking
6. **Validation** (Phase 6) - Validate against DOCUMENTATION_STANDARDS.md (auto-fix SCOPE tags, Maintenance section, POSIX compliance)

## Reference Files

- **guide_template.md:** Standard guide structure

## Best Practices

1. **Cite sources:** All principles reference official docs with versions
2. **Date everything:** Use current year (2025) or library versions
3. **No code snippets:** Describe structure, not actual code
4. **Be specific:** Link to project files, show concrete decisions
5. **Cover alternatives:** Explain why other approaches rejected
6. **Keep focused:** One pattern per guide
7. **Research thoroughly:** Use MCP Ref + Context7 to find current (2025) best practices
8. **Verify versions:** Always check latest stable versions via MCP Ref
9. **Multiple sources:** Cite 2-3 sources (official docs + framework/community refs)

---

## Definition of Done

Before completing work, verify ALL checkpoints:

**✅ Research Completed (Phase 0):**
- [ ] MCP Ref search executed: "[pattern name] best practices [language/framework]"
  - Official library documentation found
  - Configuration recommendations extracted
  - Library versions identified
- [ ] Context7 search executed: "[pattern name] [framework]"
  - Framework-specific implementations found
  - Recommended libraries identified
  - Code structure patterns extracted
- [ ] Research findings analyzed:
  - Core principle identified (industry standard)
  - 2-3 do/don't patterns identified
  - Sources compiled with dates/versions (2-3 sources)

**✅ Pattern Analysis Complete (Phase 1):**
- [ ] Pattern category identified (architecture, testing, API design, etc.)
- [ ] Researched principle used as baseline (not user assumption)
- [ ] Pattern applied to project context
- [ ] Researched do/don't patterns used for guide content

**✅ Guide Generated (Phase 2):**
- [ ] All 6 sections present:
  - SCOPE tags (HTML comments in first 3-5 lines after title)
  - Principle (industry best practice with version/date citation, 1-2 sentences)
  - Our Implementation (1 paragraph, NO alternatives/rationale)
  - Patterns (table: Do ✅ | Don't ❌ | When)
  - Sources (2-3 references with dates/versions)
  - Related + Last Updated (navigation + date)
- [ ] No placeholders remaining (no {{PLACEHOLDER}} or [FILL])
- [ ] Guide preview generated for user review

**✅ Quality Verification:**
- [ ] SCOPE tags present (HTML comments defining document boundaries)
- [ ] All sources dated (2025 or library version specified)
- [ ] Principle cites official docs (not generic statements)
- [ ] NO code snippets (structural descriptions only)
- [ ] NO ADR concepts in guide ("Alternatives rejected", "Decision rationale" removed)
- [ ] 2-3 sources cited (official docs + framework/community refs)
- [ ] Latest stable versions verified via MCP Ref
- [ ] Table format for Patterns (3 columns: Do ✅ | Don't ❌ | When)
- [ ] Target length: 300-500 words

**✅ README Updated (Phase 4):**
- [ ] Checked if `docs/reference/README.md` exists
- [ ] If exists: Checked for `{{GUIDE_LIST}}` placeholder
- [ ] If placeholder exists: Added new guide link before placeholder
- [ ] If file doesn't exist: Skipped with notification

**✅ User Confirmation:**
- [ ] Guide preview displayed to user
- [ ] User reviewed generated guide
- [ ] User typed "confirm" to proceed with creation
- [ ] User approval received before saving file

**✅ Guide Saved:**
- [ ] File created in `docs/reference/guides/` directory
- [ ] Filename format: `[NN]-[pattern-name].md` (sequential number + kebab-case name)
- [ ] Sequential number determined (find highest existing number + 1)
- [ ] File written successfully

**✅ Documentation Standards Validation:**
- [ ] DOCUMENTATION_STANDARDS.md checked in target project
- [ ] Created guide validated (SCOPE tags, Maintenance section, POSIX compliance)
- [ ] Auto-fixable violations corrected (missing tags/sections/blank lines)
- [ ] Validation report provided to user

**✅ Path Returned:**
- [ ] Guide file path returned to caller: `docs/reference/guides/NN-pattern-name.md`
- [ ] Path format correct for linking in Linear or other documents
- [ ] Success message displayed: "✓ Guide created: docs/reference/guides/NN-pattern-name.md"

**Output:** Guide file path `docs/reference/guides/NN-pattern-name.md` for linking by caller tools (e.g., ln-320-story-validator)

---

## Error Handling

**If `docs/reference/guides/` doesn't exist:**
- Warning: "Guides directory not found. Documentation structure may be incomplete."
- Recommend: "Run ln-114-docs-structure-validator to create missing directories and validate structure"
- Alternative: "Run ln-111-docs-creator or ln-110-docs-system to create initial structure"

---

**Version:** 5.0.0 (MAJOR: Added Phase 6: Validate Against Documentation Standards - validates created guide against docs/DOCUMENTATION_STANDARDS.md in target project (if exists). Auto-fixes: SCOPE tags, Maintenance section, POSIX endings. Fallback to industry best practices if standards file not found.)
**Last Updated:** 2025-11-16
