---
name: ln-111-root-docs-creator
description: Creates root documentation (CLAUDE.md + docs/README.md + documentation_standards.md + principles.md). First worker in ln-110-documents-pipeline. Establishes documentation structure and standards.
---

# Root Documentation Creator

This skill creates the root documentation entry points for a project: CLAUDE.md (project root), docs/README.md (documentation hub with general standards), docs/documentation_standards.md (60 universal documentation requirements), and docs/principles.md (11 development principles).

## When to Use This Skill

**This skill is a WORKER** invoked by **ln-110-documents-pipeline** orchestrator.

This skill should be used directly when:
- Creating only root documentation files (CLAUDE.md + docs/README.md + documentation_standards.md + principles.md)
- Setting up documentation structure for existing project
- NOT creating full documentation structure (use ln-110-documents-pipeline for complete setup)

## How It Works

The skill follows a 3-phase workflow: **CREATE** → **VALIDATE STRUCTURE** → **VALIDATE CONTENT**. Each phase builds on the previous, ensuring complete structure and semantic validation.

---

### Phase 1: Create Structure

**Objective**: Create all 4 root documentation files.

**Process**:

**1.1 Create CLAUDE.md**:
- Check if CLAUDE.md exists in project root
- If exists:
  - Read first 50 lines
  - Check for link to `docs/README.md`
  - If missing:
    - Use Edit tool to add Documentation section:
      ```markdown
      ## Documentation

      Project documentation: [docs/README.md](docs/README.md)
      ```
    - Log: "✓ Added docs link to existing CLAUDE.md"
  - If present:
    - Log: "✓ CLAUDE.md already has docs link"
- If NOT exists:
  - Ask user: "Project name?"
  - Ask user: "Brief project description (1-2 sentences)?"
  - Copy template: `references/claude_md_template.md` → `CLAUDE.md`
  - Replace placeholders:
    - `{{PROJECT_NAME}}` — user input
    - `{{PROJECT_DESCRIPTION}}` — user input
    - `{{DATE}}` — current date (YYYY-MM-DD)
  - Log: "✓ Created CLAUDE.md"

**1.2 Create docs/README.md**:
- Check if docs/README.md exists
- If exists:
  - Skip creation
  - Log: "✓ docs/README.md already exists"
- If NOT exists:
  - Create docs/ directory if missing
  - Copy template: `references/docs_root_readme_template.md` → `docs/README.md`
  - Ask user: "Documentation status? (Draft/Active)"
  - Replace placeholders:
    - `{{VERSION}}` — "1.0.0"
    - `{{DATE}}` — current date (YYYY-MM-DD)
    - `{{STATUS}}` — user input
  - Log: "✓ Created docs/README.md"

**1.3 Create docs/documentation_standards.md**:
- Check if docs/documentation_standards.md exists
- If exists:
  - Skip creation
  - Log: "✓ docs/documentation_standards.md already exists"
- If NOT exists:
  - Copy template: `references/documentation_standards_template.md` → `docs/documentation_standards.md`
  - Replace placeholders:
    - `{{DATE}}` — current date (YYYY-MM-DD)
    - `{{PROJECT_NAME}}` — from 1.1 (if collected)
  - Log: "✓ Created docs/documentation_standards.md"

**1.4 Create docs/principles.md**:
- Check if docs/principles.md exists
- If exists:
  - Skip creation
  - Log: "✓ docs/principles.md already exists"
- If NOT exists:
  - Copy template: `references/principles_template.md` → `docs/principles.md`
  - Replace placeholders:
    - `{{DATE}}` — current date (YYYY-MM-DD)
  - Log: "✓ Created docs/principles.md"

**1.5 Output**:
```
CLAUDE.md           # Created or updated with docs link
docs/
├── README.md                    # Created or existing
├── documentation_standards.md   # Created or existing
└── principles.md                # Created or existing
```

---

### Phase 2: Validate Structure

**Objective**: Ensure all 4 files comply with structural requirements and auto-fix violations.

**Process**:

**2.1 Check SCOPE tags**:
- Read first 10 lines of CLAUDE.md
- Check for `> **SCOPE:**` or `<!-- SCOPE: ... -->` tag
- If missing:
  - Use Edit tool to add SCOPE tag after first heading:
    ```markdown
    > **SCOPE:** Entry point with project overview and navigation ONLY.
    ```
  - Track violation: `scope_tag_added_claude = True`
- Read first 10 lines of docs/README.md
- Check for `<!-- SCOPE: ... -->` tag
- If missing:
  - Use Edit tool to add SCOPE tag after version info:
    ```markdown
    <!-- SCOPE: Root documentation hub with general standards and navigation ONLY. -->
    ```
  - Track violation: `scope_tag_added_docs_readme = True`
- Read first 10 lines of docs/principles.md
- Check for `> **SCOPE:**` or `<!-- SCOPE: ... -->` tag
- If missing:
  - Use Edit tool to add SCOPE tag
  - Track violation: `scope_tag_added_principles = True`

**2.2 Check required sections (parametric loop)**:

Define file parameters:
```
files = [
  {
    "path": "CLAUDE.md",
    "sections": ["Documentation", "Documentation Maintenance Rules", "Maintenance"]
  },
  {
    "path": "docs/README.md",
    "sections": ["General Documentation Standards", "Writing Guidelines", "Maintenance"]
  },
  {
    "path": "docs/documentation_standards.md",
    "sections": ["Quick Reference", "Maintenance"]
  },
  {
    "path": "docs/principles.md",
    "sections": ["Decision-Making Framework", "Verification Checklist", "Maintenance"]
  }
]
```

For each file in files:
1. Read file content
2. For each required section:
   - Check if `## [Section Name]` header exists
   - If missing:
     - Use Edit tool to add section with placeholder:
       ```markdown
       ## [Section Name]

       {{PLACEHOLDER}}
       ```
     - Track violation: `missing_sections[file] += 1`

**2.3 Check Maintenance sections**:
- For each file in [CLAUDE.md, docs/README.md, docs/documentation_standards.md, docs/principles.md]:
  - Search for `## Maintenance` header
  - If missing:
    - Use Edit tool to add at end of file:
      ```markdown
      ## Maintenance

      **Update Triggers:**
      - [To be defined]

      **Verification:**
      - [ ] All links resolve to existing files
      - [ ] All placeholders replaced with content

      **Last Updated:** [current date]
      ```
    - Track violation: `maintenance_added[file] = True`

**2.4 Check POSIX file endings**:
- For each file:
  - Check if file ends with single blank line
  - If missing:
    - Use Edit tool to add final newline
    - Track fix: `posix_fixed[file] = True`

**2.5 Report validation**:
- Log summary:
  ```
  ✅ Structure validation complete:
    - SCOPE tags: [count] files fixed
    - Missing sections: [count] sections added across [count] files
    - Maintenance sections: [count] files fixed
    - POSIX endings: [count] files fixed
  ```
- If violations found: "⚠️ Auto-fixed [total] structural violations"

---

### Phase 3: Validate Content

**Objective**: Ensure each file answers its questions with meaningful content.

**Process**:

**3.1 Load validation spec**:
- Read `references/questions.md`
- Parse questions and validation heuristics for all 4 files

**3.2 Validate files (parametric loop)**:

Define file parameters:
```
files = [
  {
    "path": "CLAUDE.md",
    "question": "Where is project documentation located and how to navigate it?",
    "heuristics": [
      "Contains link: [docs/README.md](docs/README.md)",
      "Has SCOPE tag in first 10 lines",
      "Contains 'Documentation Navigation Rules' section",
      "Length > 80 words"
    ],
    "auto_discovery": ["Check package.json for name/description"]
  },
  {
    "path": "docs/README.md",
    "question": "What is the documentation structure and what are general standards?",
    "heuristics": [
      "Contains SCOPE tag",
      "Has 'General Documentation Standards' section",
      "Has 'Writing Guidelines' section",
      "Mentions SCOPE Tags, Maintenance Sections, Sequential Numbering",
      "Length > 100 words"
    ],
    "auto_discovery": ["Scan docs/ structure for subdirectories"]
  },
  {
    "path": "docs/documentation_standards.md",
    "question": "What are the comprehensive documentation requirements?",
    "heuristics": [
      "Contains 'Quick Reference' section with table",
      "Has 12+ main sections (##)",
      "File size > 300 lines",
      "Mentions ISO/IEC/IEEE, DIATAXIS, arc42"
    ],
    "auto_discovery": []
  },
  {
    "path": "docs/principles.md",
    "question": "What are the development principles and decision framework?",
    "heuristics": [
      "Contains SCOPE tag",
      "Lists 11 principles",
      "Has 'Decision-Making Framework' section",
      "Has 'Verification Checklist' section",
      "File size > 300 lines"
    ],
    "auto_discovery": []
  }
]
```

For each file in files:

1. **Read file content**:
   - Extract full file content

2. **Check if content answers question**:
   - Apply validation heuristics
   - If ANY heuristic passes → content valid, skip to next file
   - If ALL fail → content invalid, continue

3. **Auto-discovery** (if content invalid or placeholder present):
   - **CLAUDE.md**:
     - Check package.json for "name" and "description"
     - If found, suggest to user: "Would you like to use '{name}' and '{description}' from package.json?"
   - **docs/README.md**:
     - Scan docs/ directory for subdirectories (project/, reference/, tasks/)
     - Generate navigation links dynamically
   - **docs/documentation_standards.md**, **docs/principles.md**:
     - Use template as-is (universal standards)
     - No auto-discovery needed

4. **Skip external API calls**:
   - Templates already complete with universal standards
   - No MCP Ref needed

**3.3 Report content validation**:
- Log summary:
  ```
  ✅ Content validation complete:
    - Files checked: 4
    - Already valid: [count]
    - Auto-discovery applied: [count]
    - Template content used: [count]
  ```

---

## Complete Output Structure

```
project_root/
├── CLAUDE.md                         # ← Project entry point with link to docs/
└── docs/
    ├── README.md                     # ← Root documentation hub (general standards)
    ├── documentation_standards.md    # ← Documentation requirements (60 universal requirements)
    └── principles.md                 # ← Development principles (11 principles + Decision Framework + Verification Checklist)
```

**Note**: Other documentation (project/, reference/, tasks/, presentation/) created by other workers in ln-110-documents-pipeline workflow.

---

## Reference Files Used

### Templates

**CLAUDE.md Template**:
- `references/claude_md_template.md` - Minimal CLAUDE.md with documentation link

**Root README Template**:
- `references/docs_root_readme_template.md` (v1.1.0) - Root documentation hub with:
  - Overview (documentation system organization)
  - General Documentation Standards (SCOPE Tags, Maintenance Sections, Sequential Numbering, Placeholder Conventions)
  - Writing Guidelines (Progressive Disclosure Pattern)
  - Maintenance section (Update Triggers, Verification, Last Updated)

**Documentation Standards Template**:
- `references/documentation_standards_template.md` (v1.0.0) - Documentation requirements with:
  - Quick Reference (60 universal requirements in 12 categories)
  - Claude Code Integration (#26-30)
  - AI-Friendly Writing Style (#31-36)
  - Markdown Best Practices (#37-42)
  - Code Examples Quality (#43-47)
  - DIATAXIS Framework (#48-52)
  - Project Files (#53-58)
  - Visual Documentation (#67-71)
  - Conventional Commits & Changelog (#72-75)
  - Security & Compliance (#76-79)
  - Performance & Optimization (#80-82)
  - Project-Specific Customization Guide
  - References (industry sources)
  - Maintenance section

**Development Principles Template**:
- `references/principles_template.md` (v1.0.0) - Development principles with:
  - 11 Core Principles (Standards First, YAGNI, KISS, DRY, Consumer-First Design, Task Granularity, Value-Based Testing, No Legacy Code, Token Efficiency, Documentation-as-Code, Security by Design)
  - Decision-Making Framework (7 steps: Security → Standards → Correctness → Simplicity → Necessity → Maintainability → Performance)
  - Trade-offs (when principles conflict)
  - Anti-Patterns to Avoid
  - Verification Checklist (11 items)
  - Maintenance section

**Validation Specification**:
- `references/questions.md` (v1.0) - Question-driven validation:
  - Questions each file must answer
  - Validation heuristics
  - Auto-discovery hints

---

## Best Practices

- **No premature validation**: Phase 1 creates structure, Phase 2 validates it (no duplicate checks)
- **Parametric validation**: Phases 2-3 use loops for 4 files (no code duplication)
- **Auto-discovery first**: Check package.json and docs/ structure before asking user
- **Idempotent**: ✅ Can run multiple times safely (checks existence before creation)
- **Separation of concerns**: CREATE → VALIDATE STRUCTURE → VALIDATE CONTENT
- **CLAUDE.md**: Keep minimal - only project name, description, and docs link
- **docs/README.md**: General standards only - NO project-specific content
- **SCOPE Tags**: Include in first 3-10 lines of all documentation files

---

## Prerequisites

**Invoked by**: ln-110-documents-pipeline orchestrator

**Requires**: None (first worker in chain)

**Creates**:
- CLAUDE.md (project entry point)
- docs/README.md (documentation hub)
- docs/documentation_standards.md (60 requirements)
- docs/principles.md (11 principles + Decision Framework)
- Validated structure and content

---

## Definition of Done

Before completing work, verify ALL checkpoints:

**✅ Structure Created:**
- [ ] CLAUDE.md exists in project root
- [ ] docs/ directory exists
- [ ] docs/README.md exists
- [ ] docs/documentation_standards.md exists
- [ ] docs/principles.md exists

**✅ Structure Validated:**
- [ ] SCOPE tags present in CLAUDE.md, docs/README.md, docs/principles.md
- [ ] Required sections present in all 4 files
- [ ] Maintenance sections present in all 4 files
- [ ] POSIX file endings compliant

**✅ Content Validated:**
- [ ] All files checked against questions.md
- [ ] CLAUDE.md has docs link
- [ ] docs/README.md has General Standards + Writing Guidelines
- [ ] docs/documentation_standards.md has Quick Reference + 12 sections
- [ ] docs/principles.md has 11 principles + Decision Framework + Verification Checklist

**✅ Reporting:**
- [ ] Phase 1 logged: creation summary
- [ ] Phase 2 logged: structural fixes (if any)
- [ ] Phase 3 logged: content validation (if any)

---

## Technical Details

**Standards**:
- ISO/IEC/IEEE 29148:2018 (Documentation standards)
- Progressive Disclosure Pattern (token efficiency)

**Language**: English only

---

**Version:** 10.0.0 (MAJOR: Applied ln-112 pattern - 4 phases → 3 phases, added questions.md for semantic validation, parametric validation loop, removed workflow coupling. No functionality change, pure architectural refactoring for consistency with ln-112 PoC.)
**Last Updated:** 2025-11-18
