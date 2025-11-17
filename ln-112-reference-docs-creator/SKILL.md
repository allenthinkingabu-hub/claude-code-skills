---
name: ln-112-reference-docs-creator
description: Creates reference documentation structure (docs/reference/ with README, adrs/, guides/, manuals/ directories). Second worker in ln-110-documents-pipeline.
---

# Reference Documentation Creator

This skill creates the reference documentation structure: docs/reference/README.md (hub with registries for ADRs/Guides/Manuals) and empty subdirectories for storing reference materials.

## When to Use This Skill

**This skill is a WORKER** invoked by **ln-110-documents-pipeline** orchestrator.

This skill should be used directly when:
- Creating only reference documentation structure (docs/reference/)
- Setting up directories for ADRs, guides, and manuals
- NOT creating full documentation structure (use ln-110-documents-pipeline for complete setup)

## How It Works

The skill follows a 3-phase workflow: **CREATE** → **VALIDATE STRUCTURE** → **VALIDATE CONTENT**. Each phase builds on the previous, ensuring complete structure and semantic validation.

---

### Phase 1: Create Structure

**Objective**: Establish reference documentation directories and README hub.

**Process**:

**1.1 Check & create directories**:
- Check if `docs/reference/adrs/` exists → create if missing
- Check if `docs/reference/guides/` exists → create if missing
- Check if `docs/reference/manuals/` exists → create if missing
- Log for each: "✓ Created docs/reference/[name]/" or "✓ docs/reference/[name]/ already exists"

**1.2 Check & create README**:
- Check if `docs/reference/README.md` exists
- If exists:
  - Skip creation
  - Log: "✓ docs/reference/README.md already exists, proceeding to validation"
- If NOT exists:
  - Copy template: `ln-112-reference-docs-creator/references/reference_readme_template.md` → `docs/reference/README.md`
  - Replace placeholders:
    - `{{VERSION}}` — "1.0.0"
    - `{{DATE}}` — current date (YYYY-MM-DD)
    - `{{ADR_LIST}}` — kept as placeholder (filled in Phase 3)
    - `{{GUIDE_LIST}}` — kept as placeholder (filled in Phase 3)
    - `{{MANUAL_LIST}}` — kept as placeholder (filled in Phase 3)
  - Log: "✓ Created docs/reference/README.md from template"

**1.3 Output**:
```
docs/reference/
├── README.md         # Created or existing
├── adrs/            # Empty, ready for ADRs
├── guides/          # Empty, ready for guides
└── manuals/         # Empty, ready for manuals
```

---

### Phase 2: Validate Structure

**Objective**: Ensure reference/README.md complies with structural requirements and auto-fix violations.

**Process**:

**2.1 Check SCOPE tag**:
- Read `docs/reference/README.md` (first 5 lines)
- Check for `<!-- SCOPE: ... -->` tag
- Expected: `<!-- SCOPE: Reference documentation hub (ADRs, Guides, Manuals) with links to subdirectories -->`
- If missing:
  - Use Edit tool to add SCOPE tag at line 1 (after first heading)
  - Track violation: `scope_tag_added = True`

**2.2 Check required sections**:
- Load expected sections from `references/questions.md`
- Required sections:
  - "Architecture Decision Records (ADRs)"
  - "Project Guides"
  - "Package Manuals"
- For each section:
  - Check if `## [Section Name]` header exists
  - If missing:
    - Use Edit tool to add section with placeholder:
      ```markdown
      ## [Section Name]

      {{PLACEHOLDER}}
      ```
    - Track violation: `missing_sections += 1`

**2.3 Check Maintenance section**:
- Search for `## Maintenance` header
- If missing:
  - Use Edit tool to add at end of file:
    ```markdown
    ## Maintenance

    **Last Updated:** [current date]

    **Update Triggers:**
    - New ADRs added to adrs/ directory
    - New guides added to guides/ directory
    - New manuals added to manuals/ directory

    **Verification:**
    - [ ] All ADR links in registry are valid
    - [ ] All guide links in registry are valid
    - [ ] All manual links in registry are valid
    - [ ] Placeholders {{ADR_LIST}}, {{GUIDE_LIST}}, {{MANUAL_LIST}} synced with files
    ```
  - Track violation: `maintenance_added = True`

**2.4 Check POSIX file endings**:
- Check if file ends with single blank line
- If missing:
  - Use Edit tool to add final newline
  - Track fix: `posix_fixed = True`

**2.5 Report validation**:
- Log summary:
  ```
  ✅ Structure validation complete:
    - SCOPE tag: [added/present]
    - Missing sections: [count] sections added
    - Maintenance section: [added/present]
    - POSIX endings: [fixed/compliant]
  ```
- If violations found: "⚠️ Auto-fixed [total] structural violations"

---

### Phase 3: Validate Content

**Objective**: Ensure each section answers its questions with meaningful content and populate registries from auto-discovery.

**Process**:

**3.1 Load validation spec**:
- Read `references/questions.md`
- Parse questions and validation heuristics for all 3 sections

**3.2 Validate sections (parametric loop)**:

Define section parameters:
```
sections = [
  {
    "name": "Architecture Decision Records (ADRs)",
    "question": "Where are architecture decisions documented?",
    "directory": "docs/reference/adrs/",
    "placeholder": "{{ADR_LIST}}",
    "glob_pattern": "docs/reference/adrs/*.md",
    "heuristics": [
      "Contains link: [ADRs](adrs/) or [adrs](adrs/)",
      "Mentions 'Architecture Decision Record' or 'ADR'",
      "Has placeholder {{ADR_LIST}} or actual list",
      "Length > 30 words"
    ]
  },
  {
    "name": "Project Guides",
    "question": "Where are reusable project patterns documented?",
    "directory": "docs/reference/guides/",
    "placeholder": "{{GUIDE_LIST}}",
    "glob_pattern": "docs/reference/guides/*.md",
    "heuristics": [
      "Contains link: [Guides](guides/) or [guides](guides/)",
      "Has placeholder {{GUIDE_LIST}} or actual list",
      "Length > 20 words"
    ]
  },
  {
    "name": "Package Manuals",
    "question": "Where are third-party package references documented?",
    "directory": "docs/reference/manuals/",
    "placeholder": "{{MANUAL_LIST}}",
    "glob_pattern": "docs/reference/manuals/*.md",
    "heuristics": [
      "Contains link: [Manuals](manuals/) or [manuals](manuals/)",
      "Has placeholder {{MANUAL_LIST}} or actual list",
      "Length > 20 words"
    ]
  }
]
```

For each section in sections:

1. **Read section content**:
   - Extract section from reference/README.md

2. **Check if content answers question**:
   - Apply validation heuristics
   - If ANY heuristic passes → content valid, skip to next section
   - If ALL fail → content invalid, continue

3. **Auto-discovery** (if content invalid or placeholder present):
   - Scan directory using Glob tool (section.glob_pattern)
   - If files found:
     - Extract filenames
     - Generate dynamic list:
       ```markdown
       - [ADR-001: Frontend Framework](adrs/adr-001-frontend-framework.md)
       - [02-Repository Pattern](guides/02-repository-pattern.md)
       - [Axios 1.6](manuals/axios-1.6.md)
       ```
     - Use Edit tool to replace placeholder with generated list
     - Track change: `sections_populated += 1`
   - If NO files:
     - Keep placeholder as-is
     - Track: `placeholders_kept += 1`

4. **Skip external API calls**:
   - Do NOT use MCP Ref search (template already has format examples)

**3.3 Report content validation**:
- Log summary:
  ```
  ✅ Content validation complete:
    - Sections checked: 3
    - Populated from auto-discovery: [count]
    - Placeholders kept (no files): [count]
    - Already valid: [count]
  ```

---

## Complete Output Structure

```
docs/
└── reference/
    ├── README.md                     # Reference hub with registries
    ├── adrs/                         # Empty or with ADR files
    ├── guides/                       # Empty or with guide files
    └── manuals/                      # Empty or with manual files
```

---

## Reference Files Used

### Templates

**Reference README Template**:
- `references/reference_readme_template.md` (v2.0.0) - Reference hub with:
  - SCOPE tags (reference documentation ONLY)
  - Three registry sections with placeholders
  - Maintenance section

**Validation Specification**:
- `references/questions.md` (v1.0) - Question-driven validation:
  - Questions each section must answer
  - Validation heuristics
  - Auto-discovery hints

---

## Best Practices

- **No premature validation**: Phase 1 creates structure, Phase 2 validates it (no duplicate checks)
- **Parametric validation**: Phase 3 uses loop for 3 sections (no code duplication)
- **Auto-discovery first**: Scan actual files before external API calls
- **Idempotent**: ✅ Can run multiple times safely (checks existence before creation)
- **Separation of concerns**: CREATE → VALIDATE STRUCTURE → VALIDATE CONTENT

---

## Prerequisites

**Invoked by**: ln-110-documents-pipeline orchestrator

**Requires**:
- `docs/` directory (created by ln-111-root-docs-creator)

**Creates**:
- `docs/reference/` directory structure with README hub
- Validated structure and content (auto-discovery from existing files)

---

## Definition of Done

Before completing work, verify ALL checkpoints:

**✅ Structure Created:**
- [ ] `docs/reference/` directory exists
- [ ] `docs/reference/adrs/` directory exists
- [ ] `docs/reference/guides/` directory exists
- [ ] `docs/reference/manuals/` directory exists
- [ ] `docs/reference/README.md` exists (created or existing)

**✅ Structure Validated:**
- [ ] SCOPE tag present in first 5 lines
- [ ] Three registry sections present (ADRs, Guides, Manuals)
- [ ] Maintenance section present at end
- [ ] POSIX file endings compliant

**✅ Content Validated:**
- [ ] All sections checked against questions.md
- [ ] Placeholders populated from auto-discovery OR kept if no files
- [ ] No validation heuristic failures

**✅ Reporting:**
- [ ] Phase 1 logged: creation summary
- [ ] Phase 2 logged: structural fixes (if any)
- [ ] Phase 3 logged: content updates (if any)

---

## Technical Details

**Standards**:
- Michael Nygard's ADR Format (7 sections)
- ISO/IEC/IEEE 29148:2018 (Documentation standards)

**Language**: English only

---

**Version:** 7.1.0 (MINOR: Workflow optimization - merged Phase 1+2 CREATE, removed redundant Phase 2 Step 3 verification, removed Phase 3.4 project-specific standards check, parametrized Phase 4 content validation. No functionality change, pure refactoring for clarity and efficiency.)
**Last Updated:** 2025-11-18
