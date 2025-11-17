---
name: ln-115-presentation-creator
description: Builds interactive HTML presentation with 6 tabs (Overview, Requirements, Architecture/C4, Tech Spec, Roadmap, Guides). Creates presentation/README.md hub. Worker under ln-110-documents-pipeline.
---

# HTML Presentation Builder

This skill creates an interactive, self-contained HTML presentation from existing project documentation. It transforms Markdown documents into a professional, navigable web presentation with diagrams, collapsible sections, and modern UI.

## When to Use This Skill

**This skill is a WORKER** invoked by **ln-110-documents-pipeline** orchestrator OR used standalone.

Use this skill when:
- Building HTML presentation from existing documentation
- Rebuilding presentation after documentation updates
- Creating standalone presentation for sharing (no full documentation setup needed)
- Validating that source documentation is ready for presentation generation

**Part of workflow**: ln-110-documents-pipeline → ln-111-root-docs-creator → ln-112-reference-docs-creator → ln-113-tasks-docs-creator → ln-114-project-docs-creator → **ln-115-presentation-creator**

**Prerequisites**: Existing documentation in `docs/` directory with **required files**:
- `docs/project/requirements.md` (REQUIRED)
- `docs/project/architecture.md` (REQUIRED)
- `docs/project/tech_stack.md` (REQUIRED)

**Optional files** (enhance presentation but not blocking):
- `docs/project/api_spec.md`, `database_schema.md`, `design_guidelines.md`, `runbook.md`
- `docs/reference/adrs/*.md` (ADRs with Category: Strategic|Technical)
- `docs/reference/guides/*.md` (How-to guides)
- `docs/tasks/kanban_board.md` (Epic Story Counters for Roadmap)

## How It Works

The skill follows a **7-phase workflow**: READ DOCS → VALIDATE SOURCE EXISTS → VALIDATE SOURCE QUALITY → CREATE DIR → COPY TEMPLATES → INJECT CONTENT → BUILD HTML.

**Phase 1: READ DOCS** - Load all project documentation from docs/
**Phase 2: VALIDATE SOURCE EXISTS** - Check required files exist (requirements.md, architecture.md, tech_stack.md), warn if optional missing
**Phase 3: VALIDATE SOURCE QUALITY** - Check diagrams, placeholders, content length (read-only validation)
**Phase 4: CREATE DIR** - Create presentation/ directory + README.md navigation hub
**Phase 5: COPY TEMPLATES** - Copy HTML/CSS/JS templates to assets/
**Phase 6: INJECT CONTENT** - Parse MD docs → replace placeholders in tab files → delete example blocks
**Phase 7: BUILD HTML** - Assemble modular components into standalone presentation_final.html

---

## Phase 1: Read Documentation

**Objective**: Load all project documentation for transformation.

**When to execute**: Always (first phase)

**Process**:

1. **Use docs/ as source**:
   - Read documentation from `docs/project/`, `docs/reference/`, `docs/tasks/` directories
   - Standard locations created by ln-114, ln-112, ln-113

2. **Read Core MD Documents**:
   - `project/requirements.md` - Functional Requirements
   - `project/architecture.md` - Architecture design, C4 diagrams
   - `project/tech_stack.md` - Technology versions, Docker configuration
   - `project/api_spec.md` - API endpoints, authentication (if exists)
   - `project/database_schema.md` - Database schema, ER diagrams (if exists)
   - `project/design_guidelines.md` - UI/UX design system (if exists)
   - `project/runbook.md` - Operational procedures (if exists)

3. **Read ADRs** (if exist):
   - `reference/adrs/adr-001-*.md` through `adr-NNN-*.md`
   - Parse ADR metadata (status, date, title, Category: Strategic|Technical)

4. **Read Guides** (if exist):
   - `reference/guides/*.md` - How-to guides for Guides tab

5. **Read Kanban Board** (if exists):
   - `tasks/kanban_board.md` - Epic Story Counters table for Roadmap progress

6. **Extract metadata**:
   - Project name, date, version from documents
   - Preserve Mermaid diagram blocks

**Output**: Loaded documentation data ready for validation and HTML generation

---

## Phase 2: Validate Source Documentation Exists

**Objective**: Verify that required source documentation exists before building presentation. Prevent building incomplete presentations.

**When to execute**: After Phase 1 (documentation loaded)

**Process**:

### 2.1 Check required files

**REQUIRED** (must exist - block execution if missing):
- ✅ `docs/project/requirements.md`
- ✅ `docs/project/architecture.md`
- ✅ `docs/project/tech_stack.md`

For each required file:
1. Use Glob tool: `pattern: "docs/project/{filename}"`
2. If NOT found:
   - Add to missing list
3. If found:
   - Check file size > 100 bytes (not empty)

**If ANY required file missing or empty:**
```
❌ ERROR: Cannot build presentation - missing required documentation:
  - docs/project/requirements.md [missing/empty]
  - docs/project/architecture.md [missing/empty]

Suggestion: Run ln-114-project-docs-creator to create missing files.

STOP execution.
```

### 2.2 Check optional files

**OPTIONAL** (enhance presentation - warn if missing but continue):
- ⚠️ `docs/project/api_spec.md` (for backend projects)
- ⚠️ `docs/project/database_schema.md` (for projects with database)
- ⚠️ `docs/project/design_guidelines.md` (for frontend projects)
- ⚠️ `docs/project/runbook.md` (for operational projects)

For each optional file:
1. Use Glob tool: `pattern: "docs/project/{filename}"`
2. If NOT found:
   - Add to optional missing list

**If optional files missing:**
```
⚠ WARN: Optional files missing: [list]
Presentation will have reduced content in some tabs.
Continue execution.
```

### 2.3 Check optional directories

**OPTIONAL directories:**
- `docs/reference/adrs/` - check if any ADR files exist (`adrs/*.md`)
- `docs/reference/guides/` - check if any guide files exist (`guides/*.md`)
- `docs/tasks/kanban_board.md` - check for Roadmap data

For each directory:
1. Use Glob tool to find files
2. If empty/missing:
   - Log: `ℹ Optional directory empty: {directory} - related tab will show placeholder`

### 2.4 Report validation summary

Log summary:
```
✓ Source documentation validation completed:
  Required files:
    - ✅ requirements.md (found, 8.5 KB)
    - ✅ architecture.md (found, 15.2 KB)
    - ✅ tech_stack.md (found, 3.1 KB)
  Optional files:
    - ⚠️ api_spec.md (missing - Technical Spec tab will have reduced content)
    - ✅ database_schema.md (found, 4.7 KB)
    - ⚠️ design_guidelines.md (missing)
  Optional directories:
    - ✅ adrs/ (5 ADR files found)
    - ⚠️ guides/ (empty - Guides tab will show placeholder)
    - ✅ kanban_board.md (found - Roadmap will show progress)
```

**Output**: Validation passed (all required files exist) OR error (stop execution)

---

## Phase 3: Validate Source Content Quality

**Objective**: Verify that source docs contain sufficient content for presentation generation. Warn about incomplete content but don't block execution.

**When to execute**: After Phase 2 (source files exist)

**Process**:

### 3.1 Check for Mermaid diagrams

**Required diagrams:**
- `architecture.md` MUST have at least 1 Mermaid diagram (preferably C4 Context)
- `database_schema.md` (if exists) MUST have ER diagram

For each file:
1. Read file content
2. Search for Mermaid code blocks: ` ```mermaid`
3. Count diagrams

**If diagrams missing:**
```
⚠ WARN: Missing diagrams in architecture.md
  Expected: At least 1 Mermaid diagram (C4 Context, Container, or Component)
  Found: 0 diagrams

  Presentation Architecture tab will have incomplete visualization.
  Suggestion: Add C4 diagrams to architecture.md before building.
```

### 3.2 Check for placeholders

**Placeholder patterns to detect:**
- `{{PLACEHOLDER}}` (template placeholder)
- `[Add your ...]` (instruction placeholder)
- `TODO:` (incomplete content marker)

For each source file:
1. Read file content
2. Search for placeholder patterns (case-insensitive)
3. Collect matches with line numbers

**If placeholders found:**
```
⚠ WARN: Source docs contain placeholders:
  - requirements.md:42 - {{PROJECT_DESCRIPTION}}
  - tech_stack.md:15 - [Add your technology rationale]
  - api_spec.md:8 - TODO: Add authentication endpoints

  Presentation will show incomplete content.
  Suggestion: Complete placeholders before building for professional result.
```

### 3.3 Check content length

**Minimum expected lengths:**
- `requirements.md` > 500 words
- `architecture.md` > 1000 words
- `tech_stack.md` > 200 words

For each file:
1. Read file content
2. Count words (split by whitespace, exclude code blocks)
3. Compare to threshold

**If content too short:**
```
⚠ WARN: Sparse content detected:
  - requirements.md: 320 words (expected >500)
  - tech_stack.md: 150 words (expected >200)

  Presentation may look incomplete with thin content.
  Suggestion: Expand documentation before building.
```

### 3.4 Auto-fix opportunities

**None** - ln-115 is **read-only** for source docs:
- ❌ Does NOT edit markdown documentation
- ✅ Only READS and TRANSFORMS to HTML

**If issues found:**
```
💡 To fix content issues:
  - Run ln-114-project-docs-creator to complete documentation
  - Manually edit source files in docs/project/
  - Re-run ln-115-presentation-creator after fixes
```

### 3.5 Report content quality summary

Log summary:
```
✓ Content quality validation completed:
  Diagrams:
    - ✅ architecture.md: 3 Mermaid diagrams found (C4 Context, Container, Component)
    - ⚠️ database_schema.md: No ER diagram found
  Placeholders:
    - ⚠️ Found 2 placeholders in 2 files (see details above)
  Content length:
    - ✅ requirements.md: 1,250 words
    - ✅ architecture.md: 2,100 words
    - ⚠️ tech_stack.md: 180 words (expected >200)

  Warnings: 3 (non-blocking)
  Recommendation: Address warnings for professional result, or continue with current content.
```

**Output**: Content quality report (warnings only, does not block execution)

---

## Phase 4: Create Presentation Directory & README

**Objective**: Setup presentation directory structure and navigation hub.

**When to execute**: After Phase 3 (source validation complete, warnings logged)

**Process**:

1. **Create presentation directory**:
   ```bash
   mkdir -p docs/presentation/
   ```

2. **Check if presentation/README.md exists**:
   - Use Glob tool: `pattern: "docs/presentation/README.md"`
   - If file exists:
     - Skip creation
     - Log: `✓ docs/presentation/README.md already exists (preserved)`
     - Proceed to Phase 5
   - If NOT exists:
     - Continue to step 3

3. **Create presentation/README.md from template**:
   - Copy template: `references/presentation_readme_template.md` → `docs/presentation/README.md`
   - Replace placeholders:
     - `{{PROJECT_NAME}}` — from requirements.md
     - `{{LAST_UPDATED}}` — current date (YYYY-MM-DD)
   - Content structure:
     - **Purpose**: What is this presentation
     - **Quick Navigation**: Links to presentation_final.html and assets/
     - **Customization Guide**: How to edit source files in assets/
     - **Build Instructions**: How to rebuild after changes
     - **Maintenance**: When to rebuild, verification checklist

4. **Notify user**:
   - If created: `✓ Created docs/presentation/README.md (navigation hub)`
   - If skipped: `✓ docs/presentation/README.md already exists (preserved)`

**Output**: docs/presentation/README.md (created or existing)

---

## Phase 5: Copy Templates to Project

**Objective**: Copy HTML/CSS/JS templates from skill references/ to presentation directory.

**When to execute**: After Phase 4 (presentation directory exists)

**Process**:

1. **Check if assets exist**:
   - Use Glob tool: `pattern: "docs/presentation/assets/"`
   - If `docs/presentation/assets/` exists:
     - Skip copying (user may have customized files)
     - Log: `✓ Presentation assets already exist - preserving user customizations`
     - Proceed to Phase 6
   - If NOT exists:
     - Continue to step 2

2. **Copy template files**:
   ```bash
   cp references/presentation_template.html → docs/presentation/assets/
   cp references/styles.css → docs/presentation/assets/
   cp references/scripts.js → docs/presentation/assets/
   cp references/build-presentation.js → docs/presentation/assets/
   cp -r references/tabs/ → docs/presentation/assets/tabs/
   ```

3. **Verify copied structure**:
   ```
   docs/presentation/assets/
   ├── presentation_template.html   # Base HTML5 + 6 tab navigation
   ├── styles.css                    # ~400-500 lines
   ├── scripts.js                    # Tab switching + Mermaid init
   ├── build-presentation.js         # Node.js build script
   └── tabs/
       ├── tab_overview.html         # Landing page
       ├── tab_requirements.html     # FRs + ADRs
       ├── tab_architecture.html     # C4 diagrams
       ├── tab_technical_spec.html   # API + Data + Deployment
       ├── tab_roadmap.html          # Epic list
       └── tab_guides.html           # How-to guides
   ```

**Output**: Template files copied to docs/presentation/assets/ (or skipped if already exist)

**Note**: Templates contain placeholders (`{{VARIABLE_NAME}}`) that will be replaced in Phase 6.

---

## Phase 6: Content Injection & Example Cleanup

**Objective**: Parse MD documentation, inject into HTML templates, and remove example blocks to create project-specific presentation.

**When to execute**: After Phase 5 (templates exist in assets/)

**Process**:

### 6.1 Read and Parse MD Documents

Read and parse the following documentation files (from Phase 1):

1. **requirements.md**: Project name, tagline, business goal, functional requirements, constraints, success criteria
2. **architecture.md**: Architecture diagrams (C4 Context/Container/Component), solution strategy, quality attributes
3. **tech_stack.md**: Technology Stack table (with versions, rationale, ADR links), Docker configuration
4. **api_spec.md** (if exists): API endpoints, authentication methods, error codes
5. **database_schema.md** (if exists): ER diagrams, data dictionary (tables/columns/types)
6. **design_guidelines.md** (if exists): Typography, colors, component library, accessibility
7. **runbook.md** (if exists): Development setup, deployment procedures, troubleshooting
8. **adrs/*.md**: All ADR files (parse title, status, category, content)
9. **kanban_board.md** (if exists): Epic Story Counters table for Roadmap progress
10. **guides/*.md** (if exist): How-to guides for Guides tab

### 6.2 Inject Content into Templates

Replace placeholders in copied template files with parsed content from project documentation.

**Key Placeholders (in tab templates):**

**Overview Tab** (`tab_overview.html`):
- `{{PROJECT_SUMMARY}}` — Problem/Solution/Business Value structure (3 sections)
- `{{TECH_STACK}}` — Technology badges (brief list only)
- `{{STAKEHOLDERS}}` — Stakeholder cards with names and roles
- `{{QUICK_FACTS}}` — Project Status, Total Epics, Deployment Model, Target Platforms
- `{{NAVIGATION_GUIDE}}` — Documentation guide with tab descriptions

**Requirements Tab** (`tab_requirements.html`):
- `{{FUNCTIONAL_REQUIREMENTS}}` — FRs table (ID, Priority, Requirement, Acceptance Criteria)
- `{{ADR_STRATEGIC}}` — Strategic ADRs grouped section with accordion
- `{{ADR_TECHNICAL}}` — Technical ADRs grouped section with accordion
- `{{SUCCESS_CRITERIA}}` — Project success metrics

**Architecture Tab** (`tab_architecture.html`):
- `{{C4_CONTEXT}}` — System Context diagram (C4 Level 1)
- `{{C4_CONTAINER}}` — Container diagram (C4 Level 2)
- `{{C4_COMPONENT}}` — Component diagram (C4 Level 3)
- `{{DEPLOYMENT_DIAGRAM}}` — Infrastructure deployment diagram
- `{{ARCHITECTURE_NOTES}}` — Key architecture highlights table

**Technical Spec Tab** (`tab_technical_spec.html`):
- `{{TECH_STACK_TABLE}}` — Full technology stack table with versions and purposes
- `{{API_ENDPOINTS}}` — API endpoints tables (Authentication, Products, Cart, etc.)
- `{{DATA_MODELS}}` — ER diagram + Data dictionary table
- `{{TESTING_STRATEGY}}` — Risk-Based Testing approach and test pyramid

**Roadmap Tab** (`tab_roadmap.html`):
- `{{EPIC_CARDS}}` — All Epic cards with In/Out Scope, Dependencies, Success Criteria, Progress
- `{{OUT_OF_SCOPE_ITEMS}}` — Project-level out-of-scope items with reasons
- `{{ROADMAP_LEGEND}}` — Status badges explanation

**Guides Tab** (`tab_guides.html`):
- `{{GETTING_STARTED}}` — Prerequisites, Installation, Verification
- `{{HOW_TO_GUIDES}}` — Step-by-step how-to guides (from guides/*.md)
- `{{BEST_PRACTICES}}` — Code style, Testing approach, Design patterns
- `{{TROUBLESHOOTING}}` — Common problems and solutions
- `{{CONTRIBUTING}}` — Contributing guidelines
- `{{EXTERNAL_RESOURCES}}` — Links to external documentation

**Placeholder Replacement Logic:**
- Use **Edit** tool to replace `{{PLACEHOLDER}}` → actual content from project docs
- For lists/arrays: generate HTML dynamically (e.g., loop through ADRs, create `<details>` elements)
- For Kanban: parse kanban_board.md → calculate progress % → generate Epic card HTML
- Preserve SCOPE tags in tab files (HTML comments at top)
- Escape special characters to prevent XSS
- Generate valid Mermaid syntax

### 6.3 Delete Example Blocks

**CRITICAL**: Remove all example content blocks to create project-specific presentation.

**Process**:
1. **Search for example markers** in all 6 tab files:
   - Look for `<!-- EXAMPLE START: Remove this block after replacing placeholder -->`
   - Look for `<!-- EXAMPLE END -->`

2. **Delete example blocks** using Edit tool:
   - Remove everything between `<!-- EXAMPLE START -->` and `<!-- EXAMPLE END -->` (inclusive)
   - Do this for ALL occurrences across all 6 tab files
   - Leave only the actual project content that replaced `{{PLACEHOLDER}}` comments

3. **Validate cleanup**:
   - ✅ NO `<!-- EXAMPLE START -->` markers should remain
   - ✅ NO `<!-- EXAMPLE END -->` markers should remain
   - ✅ NO hardcoded e-commerce examples (John Smith, React 18 badges, Stripe, etc.)
   - ✅ Only actual project data should be visible in tab files

**Example transformation:**

**Before (dual-content template):**
```html
<!-- PLACEHOLDER: {{PROJECT_SUMMARY}} -->
<!-- EXAMPLE START: Remove this block after replacing placeholder -->
<div class="project-summary">
    <h3>The Problem</h3>
    <p>Traditional e-commerce platforms struggle...</p>
</div>
<!-- EXAMPLE END -->
```

**After Step 6.2 (placeholder replaced):**
```html
<div class="project-summary">
    <h3>The Problem</h3>
    <p>Our healthcare system needs unified patient records...</p>
</div>
<!-- EXAMPLE START: Remove this block after replacing placeholder -->
<div class="project-summary">
    <h3>The Problem</h3>
    <p>Traditional e-commerce platforms struggle...</p>
</div>
<!-- EXAMPLE END -->
```

**After Step 6.3 (examples deleted):**
```html
<div class="project-summary">
    <h3>The Problem</h3>
    <p>Our healthcare system needs unified patient records...</p>
</div>
```

**Output**: Clean, project-specific tab files with NO example content, ready for build

---

## Phase 7: Build Final Presentation

**Objective**: Assemble modular components into standalone HTML file.

**When to execute**: After Phase 6 (content injected, examples deleted)

**Process**:

1. **Check if presentation_final.html exists (Auto-rebuild for automation)**:
   - Use Glob tool: `pattern: "docs/presentation/presentation_final.html"`
   - If file exists:
     - **✓ Auto-rebuild** (generated file, safe operation)
     - Log: `ℹ Rebuilding presentation_final.html (generated file, safe to rebuild)`
     - Continue to step 2
   - If NOT exists:
     - Log: `Creating presentation_final.html`
     - Continue to step 2

   **Why auto-rebuild:**
   - presentation_final.html is a **generated file** (source of truth: assets/ directory)
   - Rebuilding is safe - no data loss (source files preserved in assets/)
   - Maintains fully automatic workflow when invoked by ln-110-documents-pipeline
   - User customizations in assets/ are preserved (only final HTML is regenerated)

2. **Navigate to presentation assets directory**:
   ```bash
   cd docs/presentation/assets/
   ```

3. **Run build script**:
   ```bash
   node build-presentation.js
   ```

4. **Build Script Process**:
   - **Step 1**: Read presentation_template.html
   - **Step 2**: Read and inline styles.css → `<style>` tag
   - **Step 3**: Read and inline scripts.js → `<script>` tag
   - **Step 4**: Read all 6 tab files → inject into empty `<div>` containers
   - **Step 5**: Replace {{PLACEHOLDERS}} with actual values
   - **Step 6**: Write `../presentation_final.html`

5. **Validate Output** (only if file was built):
   - Check file size (~120-150 KB expected)
   - Verify Mermaid diagrams syntax is valid
   - Log: `✓ Build completed successfully`

6. **Notify user**:
   - If rebuilt (file existed): `✓ Rebuilt docs/presentation/presentation_final.html (~120-150 KB)`
   - If created (file NOT existed): `✓ Created docs/presentation/presentation_final.html (~120-150 KB)`
   - Remind: `Test in browser: Double-click to open, or use http-server`

**Output**: docs/presentation/presentation_final.html (self-contained, ~120-150 KB, no external dependencies except Mermaid.js CDN)

**⚠️ Important Note:**

`presentation_final.html` is a **generated file** built from modular source files in `assets/`.

- ❌ **DO NOT edit `presentation_final.html` directly** — changes will be lost on next rebuild
- ✅ **DO edit source files** in `assets/` directory (template, tabs, styles, scripts)
- 🔄 **Rebuild after changes**: `cd assets/ && node build-presentation.js`

---

## Complete Output Structure

```
docs/
├── project/                      # Source documentation (input)
│   ├── requirements.md
│   ├── architecture.md
│   ├── tech_stack.md
│   ├── api_spec.md (conditional)
│   ├── database_schema.md (conditional)
│   ├── design_guidelines.md (conditional)
│   └── runbook.md (conditional)
├── reference/                    # Source documentation (input)
│   ├── adrs/
│   │   └── *.md (Category: Strategic | Technical)
│   └── guides/
│       └── *.md (optional)
├── tasks/                        # Source documentation (input)
│   └── kanban_board.md (Epic Story Counters)
└── presentation/                 # Output directory
    ├── README.md                 # Navigation hub
    ├── presentation_final.html   # Final standalone HTML (~120-150 KB)
    └── assets/                   # Modular HTML structure
        ├── presentation_template.html  # Base HTML5 + 6 tabs
        ├── styles.css                  # ~400-500 lines
        ├── scripts.js                  # Tab switching + Mermaid
        ├── build-presentation.js       # Node.js build script
        └── tabs/
            ├── tab_overview.html       # Landing page
            ├── tab_requirements.html   # FRs + ADRs
            ├── tab_architecture.html   # C4 diagrams
            ├── tab_technical_spec.html # API + Data + Deployment
            ├── tab_roadmap.html        # Epic list
            └── tab_guides.html         # How-to guides
```

**Note**: Presentation READS from docs/project/, docs/reference/, docs/tasks/ but OUTPUTS to docs/presentation/.

---

## HTML Features

- **Single Source of Truth**: No information duplication - each piece lives in exactly ONE tab
- **Landing Page (Overview)**: Problem/Solution/Business Value, Stakeholders, Documentation Guide, Quick Facts, Tech Stack badges
- **Interactive Navigation**: 6 tabs with SCOPE tags, state persistence (localStorage), smooth transitions
- **Table-Based Layout**: FRs table, NFRs table, Architecture highlights table
- **Roadmap Simplified**: Vertical Epic list with In/Out Scope sections, status badges, Dependencies/Success Criteria
- **ADR Organization**: Grouped by category (Strategic/Technical) with accordion, full content inline
- **Diagram Visualization**: Mermaid.js with tab-switch rerender (C4, ER, Sequence, Deployment)
- **Responsive Design**: Mobile-first (320px/768px/1024px+ breakpoints)
- **Collapsible Sections**: Auto-collapse with scroll preservation
- **Modern UI**: Clean professional design, WCAG 2.1 Level AA compliant
- **English Language**: All presentation content in English

---

## Best Practices

### Idempotent Operation
- ✅ Checks file existence before creation (presentation/README.md)
- ✅ Auto-rebuild: Always rebuilds presentation_final.html (generated file)
- ✅ Assets preservation: Skips copying templates if assets/ exists (preserves customizations)
- ✅ Safe re-runs: Can invoke multiple times without data loss

### During Documentation Reading (Phase 1)
- Validate paths: Check docs/ exists before reading
- Graceful degradation: Continue if some files missing (warn user)
- Extract metadata: Pull project name, date, version
- Parse Mermaid blocks: Preserve diagram syntax

### During Source Validation (Phase 2/3)
- **Phase 2**: STOP execution if required files missing (requirements.md, architecture.md, tech_stack.md)
- **Phase 3**: WARN about quality issues but don't block (missing diagrams, placeholders, sparse content)
- Provide actionable suggestions: "Run ln-114 to complete docs"
- Read-only: Never edit source docs

### During Template Copying (Phase 5)
- Check existing assets: Don't overwrite user-customized templates
- Verify directory structure: Ensure tabs/ subdirectory created
- Preserve permissions: Maintain executable permissions for build script

### During Content Injection & Cleanup (Phase 6)
- Preserve Markdown formatting: Convert MD → HTML correctly
- Generate valid Mermaid syntax: Test all diagram syntax
- Escape special characters: Prevent XSS vulnerabilities
- Use semantic HTML: Proper heading hierarchy, ARIA labels
- Preserve SCOPE tags: Keep HTML comments in tab files
- **Complete example cleanup**: Ensure ALL example blocks deleted
- **Verify project-specific content**: NO hardcoded e-commerce examples in final tabs

### During Build (Phase 7)
- Validate Node.js availability: Check `node --version` before running
- Handle errors gracefully: Provide clear error messages
- Test output: Open presentation_final.html to verify rendering
- Size check: Warn if file >200 KB (may indicate issues)

---

## Customization Options

Edit `assets/styles.css` (CSS variables for theming), `assets/presentation_template.html` (layout/tabs), or `assets/tabs/*.html` (tab content).

**⚠️ After any customization:** Always rebuild the presentation:
```bash
cd assets/
node build-presentation.js
```

**Important:** Never edit `presentation_final.html` directly — it's a generated file that gets overwritten on each build.

---

## Prerequisites

**Orchestrator**: ln-110-documents-pipeline (invokes this worker in final step)

**Standalone usage**: Can also be invoked directly for:
- Rebuilding HTML presentation after documentation updates
- Creating standalone presentation for existing docs
- Validating source documentation readiness

**Source Documentation Requirements**:
- **Required files** (must exist):
  - docs/project/requirements.md
  - docs/project/architecture.md
  - docs/project/tech_stack.md
- **Optional files** (enhance presentation):
  - docs/project/api_spec.md, database_schema.md, design_guidelines.md, runbook.md
  - docs/reference/adrs/*.md (with Category field)
  - docs/reference/guides/*.md
  - docs/tasks/kanban_board.md

**Quality Recommendations** (warnings only, not blocking):
- architecture.md should have Mermaid diagrams (C4 Context/Container/Component)
- database_schema.md should have ER diagram
- Source docs should NOT contain placeholders (`{{PLACEHOLDER}}`, `[Add your...]`)
- Minimum content length: requirements.md >500 words, architecture.md >1000 words, tech_stack.md >200 words

**Dependencies**:
- Node.js v18+ (for build-presentation.js)
- Modern browser (Chrome/Firefox/Safari/Edge last 2 versions)
- Internet connection (Mermaid.js CDN, optional)

**Idempotent**: Yes - can be invoked multiple times without side effects:
- Preserves existing README.md
- Preserves existing assets/ (user customizations)
- Always rebuilds presentation_final.html (generated file)

---

## Definition of Done

Before completing work, verify ALL checkpoints:

### Phase 1: READ DOCS

**✅ Documentation Loaded:**
- [ ] docs/project/ documentation read (requirements.md, architecture.md, tech_stack.md + optional)
- [ ] docs/reference/ documentation read (adrs/, guides/ if exist)
- [ ] docs/tasks/ documentation read (kanban_board.md if exists)
- [ ] Metadata extracted (project name, date, version)
- [ ] Mermaid blocks identified and preserved

### Phase 2: VALIDATE SOURCE EXISTS

**✅ Required Files Validated:**
- [ ] requirements.md exists and NOT empty (>100 bytes)
- [ ] architecture.md exists and NOT empty
- [ ] tech_stack.md exists and NOT empty
- [ ] If ANY required missing: ERROR logged, execution stopped

**✅ Optional Files Checked:**
- [ ] Optional files existence checked (api_spec.md, database_schema.md, design_guidelines.md, runbook.md)
- [ ] Optional directories checked (adrs/, guides/, kanban_board.md)
- [ ] Warnings logged for missing optional files
- [ ] Execution continues even if optional missing

### Phase 3: VALIDATE SOURCE QUALITY

**✅ Diagrams Validated:**
- [ ] architecture.md checked for Mermaid diagrams (warn if 0 found)
- [ ] database_schema.md checked for ER diagram (if file exists, warn if no diagram)
- [ ] Warnings logged but execution continues

**✅ Placeholders Detected:**
- [ ] All source files scanned for `{{PLACEHOLDER}}`, `[Add your...]`, `TODO:`
- [ ] Placeholder locations logged with line numbers
- [ ] Warnings logged but execution continues

**✅ Content Length Checked:**
- [ ] requirements.md word count checked (warn if <500 words)
- [ ] architecture.md word count checked (warn if <1000 words)
- [ ] tech_stack.md word count checked (warn if <200 words)
- [ ] Warnings logged but execution continues

**✅ Quality Report:**
- [ ] Summary logged: diagrams status, placeholders count, content length status
- [ ] Suggestions provided: "Run ln-114 to complete docs" or "Fix manually"

### Phase 4: CREATE DIR

**✅ Presentation Directory & README:**
- [ ] docs/presentation/ directory created
- [ ] docs/presentation/README.md created (if didn't exist) OR preserved (if existed)
- [ ] README contains: Purpose, Quick Navigation, Customization Guide, Build Instructions, Maintenance
- [ ] Placeholders replaced: `{{PROJECT_NAME}}`, `{{LAST_UPDATED}}`
- [ ] User notified: created OR preserved

### Phase 5: COPY TEMPLATES

**✅ Modular HTML Structure Created:**
- [ ] Assets directory created: docs/presentation/assets/
- [ ] All template files copied from references/ to assets/ (if assets/ didn't exist):
  - presentation_template.html
  - styles.css (~400-500 lines)
  - scripts.js (tab switching, Mermaid init)
  - build-presentation.js (Node.js build script)
  - All 6 tab templates in tabs/ subdirectory
- [ ] OR assets/ already existed: preserved user customizations

### Phase 6: INJECT CONTENT

**✅ Content Generated from MD Docs (Project-Specific):**
- [ ] All 6 tabs populated with content from docs/project/, docs/reference/, docs/tasks/
- [ ] All Mermaid diagrams preserved with valid syntax
- [ ] All placeholders replaced (no `{{PLACEHOLDER}}` remaining in tab files)
- [ ] **CRITICAL**: All example blocks deleted (no `<!-- EXAMPLE START -->` or `<!-- EXAMPLE END -->` markers)
- [ ] **CRITICAL**: NO hardcoded e-commerce examples (John Smith, React 18 badges, Stripe, etc.)
- [ ] Only actual project data visible in presentation tabs
- [ ] SCOPE tags present in each tab (HTML comments at top)
- [ ] Special characters escaped (XSS prevention)
- [ ] Semantic HTML used (proper hierarchy, ARIA labels)

### Phase 7: BUILD HTML

**✅ Build Process Completed:**
- [ ] Navigate to docs/presentation/assets/
- [ ] Build script executed: `node build-presentation.js`
- [ ] presentation_final.html created successfully (~120-150 KB)
- [ ] Standalone file (no external dependencies except Mermaid.js CDN)
- [ ] File size validated (<200 KB threshold)
- [ ] User notified: rebuilt OR created + file size

**✅ Validation Passed:**
- [ ] All 6 tabs functional (navigation works, content displays correctly)
- [ ] Mermaid diagrams syntax valid (no build errors)
- [ ] Collapsible sections work (details/summary, accordion)
- [ ] Responsive design works (mobile/tablet/desktop)
- [ ] Tested in browser: Opens without errors

**✅ User Guidance Provided:**
- [ ] Success message with file size
- [ ] File location: docs/presentation/presentation_final.html
- [ ] Next steps: "Test in browser: Double-click to open"
- [ ] Customization reminder: "Edit assets/, then rebuild with node build-presentation.js"

**Output:** Standalone HTML presentation in docs/presentation/presentation_final.html + modular source in assets/ directory + navigation README

---

## Example Usage

User: "Build HTML presentation"

Process:
1. **READ DOCS** - Load documentation from docs/project/, docs/reference/, docs/tasks/
2. **VALIDATE SOURCE EXISTS** - Check requirements.md, architecture.md, tech_stack.md exist (ERROR if missing)
3. **VALIDATE SOURCE QUALITY** - Check diagrams, placeholders, content length (WARN if issues, but continue)
4. **CREATE DIR** - Create docs/presentation/ + README.md navigation hub
5. **COPY TEMPLATES** - Copy HTML/CSS/JS templates to assets/ (or preserve existing)
6. **INJECT CONTENT** - Parse MD docs → replace placeholders in tabs → delete example blocks
7. **BUILD HTML** - Assemble modular components → standalone presentation_final.html (~120-150 KB)

Output: docs/presentation/presentation_final.html (6 tabs: Overview, Requirements, Architecture, Technical Spec, Roadmap, Guides) + docs/presentation/README.md (navigation hub) + docs/presentation/assets/ (modular source files)

---

## Troubleshooting

- **ERROR: Missing required files**: Run ln-114-project-docs-creator to create requirements.md, architecture.md, tech_stack.md
- **WARN: Missing diagrams**: Add Mermaid diagrams to architecture.md (C4 Context/Container/Component) and database_schema.md (ER diagram)
- **WARN: Placeholders found**: Complete documentation in source MD files before building
- **WARN: Sparse content**: Expand documentation (requirements.md >500 words, architecture.md >1000 words, tech_stack.md >200 words)
- **Build script fails**: Check Node.js v18+, navigate to assets/, verify all files exist
- **Mermaid diagrams not rendering**: Check syntax with Mermaid Live Editor, verify CDN loaded
- **Tabs not switching**: Check JavaScript loaded, open browser console for errors
- **File too large (>200 KB)**: Reduce diagrams, minify CSS/JS, remove unused rules

---

## Technical Details

**Standards**: HTML5, CSS3 (Flexbox/Grid/Variables), ES6+, WCAG 2.1 Level AA, Mobile-first responsive design, Progressive enhancement, Mermaid.js v11

**Dependencies**:
- Node.js v18+ (build script)
- Modern browser (Chrome/Firefox/Safari/Edge last 2 versions)
- Internet connection (Mermaid.js CDN, optional)

**Language**: English only (all presentation content)

---

**Version:** 7.0.0 (MAJOR: Added Phase 2/3 validation (source docs existence + content quality). Removed ln-120-docs-validator references. Renumbered phases (2-5 → 4-7). Unified READ+VALIDATE+CREATE workflow. Read-only source validation.)
**Last Updated:** 2025-11-18
