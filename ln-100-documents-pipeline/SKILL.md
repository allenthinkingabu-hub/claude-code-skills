---
name: ln-100-documents-pipeline
description: Top orchestrator for complete doc system. Delegates to ln-110 coordinator (project docs via 5 L3 workers) + ln-120-150 workers. Phase 4: global cleanup. Idempotent.
---

# Documentation Pipeline (Orchestrator)

This skill orchestrates the creation of a complete documentation system by invoking L2 coordinator + 4 L2 workers. The coordinator (ln-110) delegates to 5 L3 workers for project docs; other L2 workers handle reference/tasks/test/presentation domains. Each component validates its own output.

## Architecture

```
ln-100-documents-pipeline (L1 Top Orchestrator - this skill)
├── ln-110-project-docs-coordinator (L2 Coordinator)
│   ├── ln-111-root-docs-creator (L3 Worker) → 4 docs
│   ├── ln-112-project-core-creator (L3 Worker) → 3 docs
│   ├── ln-113-backend-docs-creator (L3 Worker) → 2 conditional
│   ├── ln-114-frontend-docs-creator (L3 Worker) → 1 conditional
│   └── ln-115-devops-docs-creator (L3 Worker) → 1 conditional
├── ln-120-reference-docs-creator (L2 Worker)
├── ln-130-tasks-docs-creator (L2 Worker)
├── ln-140-test-docs-creator (L2 Worker - optional)
└── ln-150-presentation-creator (L2 Worker)
```

## When to Use This Skill

This skill should be used when:
- Start a new IT project and need complete documentation system at once
- Use automated workflow instead of manually invoking multiple workers
- Create entire documentation structure (CLAUDE.md → docs/ → presentation/) in one go
- Prefer orchestrated CREATE path over manual skill chaining
- Need automatic global cleanup (deduplication, orphaned files, consolidation)

**Alternative**: If you prefer granular control, invoke workers manually:
1. [ln-110-project-docs-coordinator](../ln-110-project-docs-coordinator/SKILL.md) - Root + Project docs (coordinates 5 L3 workers)
2. [ln-120-reference-docs-creator](../ln-120-reference-docs-creator/SKILL.md) - reference/ structure
3. [ln-130-tasks-docs-creator](../ln-130-tasks-docs-creator/SKILL.md) - tasks/README.md + kanban
4. [ln-140-test-docs-creator](../ln-140-test-docs-creator/SKILL.md) - tests/README.md (optional)
5. [ln-150-presentation-creator](../ln-150-presentation-creator/SKILL.md) - HTML presentation

**Note**: Each worker now validates its own output in Phase 2/3. Orchestrator handles global operations only.

## How It Works

The skill follows a 5-phase orchestration workflow: User confirmation → Invoke coordinator + 4 workers sequentially → Global cleanup → Summary. Phase 3 (validation) is intentionally skipped - each component validates its own output.

### Phase 1: User Confirmation

**Objective**: Check existing files, explain workflow, and get user approval.

**Process**:

1. **Pre-flight Check** (scan existing documentation):
   - Use Glob tool to check all potential files:
     - **Root docs** (4 files): `CLAUDE.md`, `docs/README.md`, `docs/documentation_standards.md`, `docs/principles.md`
     - **Reference structure** (4 items): `docs/reference/README.md`, `docs/reference/adrs/`, `docs/reference/guides/`, `docs/reference/manuals/`
     - **Tasks docs** (2 files): `docs/tasks/README.md`, `docs/tasks/kanban_board.md`
     - **Project docs** (up to 7 files): `docs/project/requirements.md`, `architecture.md`, `tech_stack.md`, `api_spec.md`, `database_schema.md`, `design_guidelines.md`, `runbook.md`
     - **Presentation** (3 items): `docs/presentation/README.md`, `presentation_final.html`, `assets/` directory
     - **Test docs** (2 files): `docs/reference/guides/testing-strategy.md`, `tests/README.md`
   - Count existing vs missing files
   - Show user summary:
     ```
     📊 Documentation Status:
     ✓ Found: X existing files
     ✗ Missing: Y files

     ⚠️ Pipeline will create ONLY missing files.
     ✅ Existing files will be preserved (no overwrites).
     ```

2. Show user what will be created:
   - Root + Project documentation (CLAUDE.md + docs/README.md + documentation_standards.md + principles.md + docs/project/ via ln-110-project-docs-coordinator)
   - Reference structure (docs/reference/ via ln-120-reference-docs-creator)
   - Task management docs (docs/tasks/ via ln-130-tasks-docs-creator)
   - Test documentation (tests/ via ln-140-test-docs-creator - optional)
   - HTML presentation (docs/presentation/ via ln-150-presentation-creator)
   - Estimated time: 15-20 minutes with interactive dialog

3. Ask: "Proceed with creating missing files? (yes/no)"

4. Ask: "Include test documentation (tests/README.md)? (yes/no)"

**Output**: File scan summary + user approval + test docs preference

---

### Phase 2: Invoke Coordinator + Workers Sequentially

**Objective**: Create complete documentation system by invoking L2 coordinator + 4 L2 workers in order.

**Process** (AUTOMATIC invocations with Skill tool):

**2.1 Create Root + Project Documentation**:
- **Invocation**: `Skill(skill: "ln-110-project-docs-coordinator")` → AUTOMATIC
- **Behavior**: Coordinator gathers context ONCE, then delegates to 5 L3 workers:
  - ln-111-root-docs-creator → 4 root docs
  - ln-112-project-core-creator → 3 core docs
  - ln-113-backend-docs-creator → 2 conditional (if hasBackend/hasDatabase)
  - ln-114-frontend-docs-creator → 1 conditional (if hasFrontend)
  - ln-115-devops-docs-creator → 1 conditional (if hasDocker)
- **Output**: Root docs (`CLAUDE.md` + `docs/README.md` + `docs/documentation_standards.md` + `docs/principles.md`) + Project docs (`docs/project/requirements.md`, `architecture.md`, `tech_stack.md` + conditional: `api_spec.md`, `database_schema.md`, `design_guidelines.md`, `runbook.md`)
- **Validation**: Each L3 worker validates output (SCOPE tags, Maintenance sections)
- **Verify**: All documents exist before continuing

**2.2 Create Reference Structure**:
- **Invocation**: `Skill(skill: "ln-120-reference-docs-creator")` → AUTOMATIC
- **Output**: `docs/reference/README.md` + `adrs/`, `guides/`, `manuals/` directories + ADR template
- **Validation**: ln-120 validates output in Phase 2/3
- **Verify**: Reference hub exists before continuing

**2.3 Create Task Management Docs**:
- **Invocation**: `Skill(skill: "ln-130-tasks-docs-creator")` → AUTOMATIC
- **Output**: `docs/tasks/README.md` + optionally `kanban_board.md` (if user provides Linear config)
- **Validation**: ln-130 validates output in Phase 2/3
- **Verify**: Tasks README exists before continuing

**2.4 Create Test Documentation (Optional)**:
- **Condition**: If user approved test docs in Phase 1
- **Invocation**: `Skill(skill: "ln-140-test-docs-creator")` → AUTOMATIC
- **Output**: `tests/README.md` (test documentation with Story-Level Test Task Pattern)
- **Validation**: ln-140 validates output in Phase 2/3
- **Skip**: If "no" → can run ln-140-test-docs-creator later manually

**2.5 Create HTML Presentation**:
- **Invocation**: `Skill(skill: "ln-150-presentation-creator")` → AUTOMATIC
- **Output**: `docs/presentation/README.md` + `presentation_final.html` + `assets/`
- **Validation**: ln-150 validates output in Phase 2/3
- **Verify**: Presentation files exist before continuing

**Output**: Complete documentation system with coordinator + 4 workers completed and validated

**TodoWrite format (mandatory):**
Add ALL invocations to todos before starting:
```
- Invoke ln-110-project-docs-coordinator (pending)
- Invoke ln-120-reference-docs-creator (pending)
- Invoke ln-130-tasks-docs-creator (pending)
- Invoke ln-140-test-docs-creator (pending)
- Invoke ln-150-presentation-creator (pending)
- Run Global Cleanup (Phase 4) (pending)
```
Mark each as in_progress when starting, completed when worker returns success.

---

### Phase 4: Global Cleanup and Consolidation

**Objective**: Remove duplicates, orphaned files, consolidate knowledge across ALL documentation.

**Trigger**: Only after ALL workers complete Phase 2/3 validation.

**Process**:

**4.1 Scan for duplicate content**

1. **Read all .md files in docs/**
   - Use Glob tool: `pattern: "docs/**/*.md"`
   - Store list of all documentation files

2. **Identify duplicate sections:**
   - For each file:
     - Read file content
     - Extract section headers (##, ###)
     - Extract section content (text between headers)
   - Compare sections across files:
     - If 2+ sections have:
       - Same heading (case-insensitive)
       - >80% content similarity (simple word overlap check)
     - Mark as duplicate

3. **Determine canonical version:**
   - Rules for canonical location:
     - "Development Principles" → principles.md (always canonical)
     - "Testing Strategy" → testing-strategy.md (always canonical)
     - "Linear Configuration" → tasks/kanban_board.md (always canonical)
     - For other duplicates: Keep in FIRST file encountered (alphabetical order)

4. **Remove duplicates:**
   - For each duplicate section:
     - Use Edit tool to delete from non-canonical files
     - Use Edit tool to add link to canonical location:
       ```markdown
       See [Development Principles](../principles.md#development-principles) for details.
       ```
   - Track count of removed duplicates

5. **Log results:**
   - "✓ Removed {count} duplicate sections"
   - List: "{section_name} removed from {file} (canonical: {canonical_file})"

**4.2 Scan for orphaned files**

1. **List all .md files in docs/**
   - Use Glob tool: `pattern: "docs/**/*.md"`

2. **Check against expected structure:**
   - Expected files (created by workers):
     - docs/CLAUDE.md
     - docs/README.md
     - docs/documentation_standards.md
     - docs/principles.md
     - docs/project/requirements.md
     - docs/project/architecture.md
     - docs/project/tech_stack.md
     - docs/project/api_spec.md (conditional)
     - docs/project/database_schema.md (conditional)
     - docs/project/design_guidelines.md (conditional)
     - docs/project/runbook.md (conditional)
     - docs/reference/README.md
     - docs/reference/adrs/*.md (user-created)
     - docs/reference/guides/*.md (user-created)
     - docs/reference/manuals/*.md (user-created)
     - docs/tasks/README.md
     - docs/tasks/kanban_board.md
     - docs/testing-strategy.md
     - tests/README.md
   - Any file NOT in this list = orphaned

3. **Move orphaned files to archive:**
   - Create `.archive/YYYY-MM-DD/` directory (current date)
   - For each orphaned file:
     - Use Bash tool: `mv {file_path} .archive/YYYY-MM-DD/`
     - Log: "Archived {file_name} (not in expected structure)"
   - Track count

4. **Log results:**
   - "✓ Archived {count} orphaned files to .archive/{date}/"
   - List archived files

**4.3 Consolidate knowledge**

1. **Identify scattered information:**
   - Known patterns:
     - Linear config scattered: kanban_board.md + tasks/README.md
     - Development principles scattered: principles.md + architecture.md + CLAUDE.md
     - Testing info scattered: testing-strategy.md + tests/README.md + architecture.md

2. **For each scattered concept:**
   - Determine Single Source of Truth (SSoT):
     - Linear config → kanban_board.md
     - Development principles → principles.md
     - Testing strategy → testing-strategy.md

3. **Update non-SSoT files:**
   - Use Edit tool to replace duplicate content with link:
     ```markdown
     See [Linear Configuration](../tasks/kanban_board.md#linear-configuration) for team ID and settings.
     ```
   - Track consolidation count

4. **Log results:**
   - "✓ Consolidated {count} scattered concepts"
   - List: "{concept} consolidated to {SSoT_file}"

**4.4 Cross-link validation**

1. **Scan all .md files for internal links:**
   - For each file:
     - Read content
     - Extract all markdown links: `[text](path)`
     - Filter internal links (relative paths, not http://)

2. **Verify link targets exist:**
   - For each link:
     - Resolve relative path
     - Check if target file exists (Glob tool)
     - If missing: Mark as broken

3. **Fix broken links:**
   - For each broken link:
     - If target was archived: Update link to archive path
     - If target never existed: Remove link (convert to plain text)
   - Track fix count

4. **Add missing critical links:**
   - **CLAUDE.md → docs/README.md:**
     - Read CLAUDE.md
     - Check for link to docs/README.md
     - If missing: Add in "Documentation Hub" section
   - **docs/README.md → section READMEs:**
     - Check for links to project/, reference/, tasks/, tests/ READMEs
     - If missing: Add
   - Track added links count

5. **Log results:**
   - "✓ Fixed {count} broken links"
   - "✓ Added {count} missing critical links"
   - List changes

**4.5 Final report**

```
✅ Global Cleanup Complete:

Structure:
- Removed {N} duplicate sections (canonical: principles.md)
- Archived {N} orphaned files to .archive/YYYY-MM-DD/
  - list of archived files
- Consolidated {N} scattered concepts

Links:
- Fixed {N} broken links
- Added {N} missing critical links:
  - list of added links
```

**Output**: All documentation cleaned up, duplicates removed, orphaned files archived, knowledge consolidated, cross-links validated

---

### Phase 5: Summary and Next Steps

**Objective**: Provide complete overview of created system.

**Process**:
1. List all created files with sizes:
   - `CLAUDE.md` (project entry point)
   - `docs/README.md` (root documentation hub)
   - `docs/documentation_standards.md` (60 universal requirements)
   - `docs/principles.md` (11 development principles)
   - `docs/project/requirements.md`, `architecture.md`, `tech_stack.md` + conditional documents (3-7 total)
   - `docs/reference/README.md` (reference hub with empty adrs/, guides/, manuals/ directories)
   - `docs/tasks/README.md` + optionally `kanban_board.md`
   - `docs/presentation/README.md` + `presentation_final.html`
   - `tests/README.md` (if created)

2. Show documentation system features:
   - ✅ SCOPE tags (document boundaries defined)
   - ✅ Maintenance sections (update triggers + verification)
   - ✅ README hub (central navigation)
   - ✅ DAG structure (Directed Acyclic Graph navigation)
   - ✅ Living documentation ready
   - ✅ Deduplicated content (canonical sources only)
   - ✅ Validated cross-links (no broken links)

3. Recommend next steps:
   - "Review generated documentation (CLAUDE.md → docs/)"
   - "Open docs/presentation/presentation_final.html in browser"
   - "Run ln-210-epic-coordinator to decompose scope into Epics"
   - "Share documentation with technical stakeholders"

**Output**: Summary message with file list and recommendations

---

## Complete Output Structure

```
project_root/
├── CLAUDE.md                         # ← Project entry point (link to docs/)
├── docs/
│   ├── README.md                     # ← Root documentation hub (general standards)
│   ├── documentation_standards.md    # ← 60 universal requirements (Claude Code + industry standards)
│   ├── principles.md                 # ← 11 development principles (Standards First, YAGNI, KISS, DRY, etc.)
│   ├── project/
│   │   ├── requirements.md           # ← Functional Requirements (NO NFR per project policy)
│   │   ├── architecture.md           # ← arc42-based architecture with C4 Model
│   │   ├── tech_stack.md             # ← Technology versions, Docker config
│   │   ├── api_spec.md               # ← API endpoints (conditional)
│   │   ├── database_schema.md        # ← Database schema (conditional)
│   │   ├── design_guidelines.md      # ← UI/UX system (conditional)
│   │   └── runbook.md                # ← Operations guide (conditional)
│   ├── reference/
│   │   ├── README.md                 # ← Reference documentation hub (registries)
│   │   ├── adrs/                     # ← Empty, ready for ADRs
│   │   ├── guides/                   # ← Empty, ready for guides
│   │   └── manuals/                  # ← Empty, ready for manuals
│   ├── tasks/
│   │   ├── README.md                 # ← Task management system rules
│   │   └── kanban_board.md           # ← Linear integration (optional)
│   └── presentation/
│       ├── README.md                 # ← Navigation hub for presentation
│       ├── presentation_final.html   # ← Final standalone HTML (~130-180 KB)
│       └── assets/                   # ← Modular HTML structure
└── tests/
    └── README.md                     # ← Test documentation (optional)
```

---

## Integration with Project Workflow

**Recommended workflow for new projects:**

1. **ln-100-documents-pipeline** (this skill) - Create complete documentation system
2. **ln-210-epic-coordinator** - Decompose scope into Epics (Linear Projects)
3. **ln-220-story-coordinator** - Create User Stories for each Epic (automatic decomposition + replan)
4. **ln-310-story-decomposer** - Break down Stories into implementation tasks (automatic decomposition + replan)
5. **ln-320-story-validator** - Verify Stories before development
6. **ln-330-story-executor** - Orchestrate Story implementation
7. **ln-340-story-quality-gate** - Review completed Stories

---

## Advantages of Orchestrator Approach

**Benefits:**
- ✅ Single command creates complete system
- ✅ No need to remember skill sequence
- ✅ Automated skill chaining
- ✅ Consistent output every time
- ✅ Time-saving (one invocation vs 2-3 manual invocations)
- ✅ **Idempotent**: Safe to run multiple times - preserves existing files, creates only missing ones
- ✅ **Pre-flight check**: Shows file scan summary before execution
- ✅ **Global cleanup**: Automatic deduplication, orphaned files archival, knowledge consolidation
- ✅ **Validated cross-links**: No broken links in documentation

**Trade-offs:**
- ⚠️ Less granular control (can't skip coordinator phases)
- ⚠️ Longer execution time (15-20 minutes)
- ⚠️ Global cleanup runs even if only one file was created

**When to use manual approach instead:**
- Need only HTML rebuild → use [ln-150-presentation-creator](../ln-150-presentation-creator/SKILL.md)
- Need one specific ADR/guide/manual → use [ln-321-best-practices-researcher](../ln-321-best-practices-researcher/SKILL.md)

---

## Error Handling

If any invoked skill fails:
1. Notify user which skill failed
2. Show error message from failed skill
3. Recommend manual invocation for debugging
4. List already completed steps (partial progress)

---

## Technical Implementation Notes

**Skill Invocation:**
- Uses **Skill tool** with command parameter
- Waits for each skill to complete before proceeding
- Verifies output files exist before moving to next phase

**File Verification:**
- Uses **Glob** tool to check docs/project/ structure
- Lists file sizes for user confirmation
- Warns if expected files missing

**Global Cleanup:**
- Uses **Glob** tool to find all .md files
- Uses **Read** tool to analyze content
- Uses **Edit** tool to remove duplicates and add links
- Uses **Bash** tool to archive orphaned files

**Standards Compliance:**
- All output follows same standards as underlying skills
- ISO/IEC/IEEE 29148:2018 (Requirements)
- ISO/IEC/IEEE 42010:2022 (Architecture)
- arc42 + C4 Model + Michael Nygard's ADR Format

---

## Definition of Done

Before completing work, verify ALL checkpoints:

**✅ User Confirmation (Phase 1):**
- [ ] Workflow explained to user (coordinator + 4 workers: ln-110 → ln-120 → ln-130 → ln-140 → ln-150)
- [ ] User approved: "Proceed with complete documentation system creation? (yes/no)"
- [ ] Test docs preference captured: "Include test documentation? (yes/no)"

**✅ Coordinator + Workers Invoked Sequentially (Phase 2):**
- [ ] ln-110-project-docs-coordinator invoked → Output verified: Root docs (`CLAUDE.md` + `docs/README.md` + `docs/documentation_standards.md` + `docs/principles.md`) + Project docs (`docs/project/requirements.md`, `architecture.md`, `tech_stack.md` + conditional 3-7 files)
- [ ] ln-120-reference-docs-creator invoked → Output verified: `docs/reference/README.md` + directories (adrs/, guides/, manuals/)
- [ ] ln-130-tasks-docs-creator invoked → Output verified: `docs/tasks/README.md` + optionally `kanban_board.md`
- [ ] ln-140-test-docs-creator invoked (if enabled) → Output verified: `tests/README.md`
- [ ] ln-150-presentation-creator invoked → Output verified: `docs/presentation/README.md` + `presentation_final.html` + `assets/`
- [ ] Each component validated its own output (SCOPE tags, Maintenance sections, POSIX compliance)

**✅ File Verification Complete:**
- [ ] All expected files exist (Glob tool used to verify structure)
- [ ] File sizes listed for user confirmation
- [ ] Warning displayed if expected files missing

**✅ Global Cleanup Complete (Phase 4):**
- [ ] 4.1: Duplicate sections identified and removed (>80% similarity)
- [ ] 4.1: Links added to canonical locations (principles.md, testing-strategy.md, kanban_board.md)
- [ ] 4.2: Orphaned files archived to `.archive/YYYY-MM-DD/`
- [ ] 4.3: Scattered concepts consolidated to Single Source of Truth (SSoT)
- [ ] 4.4: Internal links validated (broken links fixed, critical links added)
- [ ] 4.5: Final report generated (counts, lists, actions)

**✅ Summary Displayed (Phase 5):**
- [ ] All created files listed with sizes
- [ ] Documentation system features highlighted (SCOPE tags, Maintenance sections, README hubs, DAG structure, deduplicated content, validated links)
- [ ] Next steps recommended (ln-210-epic-coordinator)

**✅ Error Handling (if applicable):**
- [ ] If any worker failed: User notified which worker failed, error message shown, manual invocation recommended, partial progress listed

**Output:** Complete documentation system (CLAUDE.md + docs/ with README.md, documentation_standards.md, principles.md + presentation/ + optionally tests/) with global cleanup (no duplicates, no orphaned files, consolidated knowledge, validated cross-links)

---

**Version:** 7.0.0 (MAJOR: Renamed ln-110→ln-100. New 3-tier architecture: L1 Orchestrator → L2 Coordinator (ln-110) with 5 L3 workers (ln-111-115) → L2 Workers (ln-120-150). Context Store passed explicitly to solve "context loss" problem.)
**Last Updated:** 2025-12-19
