---
name: ln-114-project-docs-creator
description: Creates and validates 7 project docs (requirements, architecture, tech_stack, api_spec, database_schema, design_guidelines, runbook). Fourth worker in ln-110-documents-pipeline.
---

# Project Documentation Creator

This skill creates and validates technical project documentation following industry best practices (ISO/IEC/IEEE standards, arc42, C4 Model, ADR format).

## When to Use This Skill

**This skill is a WORKER** invoked by **ln-110-documents-pipeline** orchestrator.

This skill should be used directly when:
- Creating only project documentation (7 docs: requirements, architecture, tech_stack, api_spec, database_schema, design_guidelines, runbook)
- Validating existing project documentation
- NOT creating full documentation structure (use ln-110-documents-pipeline for complete setup)

**Part of workflow**: ln-110-documents-pipeline (orchestrator) → ln-111-root-docs-creator → ln-112-reference-docs-creator → ln-113-tasks-docs-creator → **ln-114-project-docs-creator** → ln-115-presentation-creator → ln-116-test-docs-creator

## How It Works

The skill follows a 4-phase workflow: **CREATE** → **VALIDATE STRUCTURE** → **VALIDATE CONTENT** → **FINALIZE**. Each phase builds on the previous, ensuring complete structure and semantic validation.

---

### Phase 1: Create Structure

**Objective**: Establish project documentation files (3-7 files based on project type).

**Process**:

**1.1 Check existing files**:
- Use Glob to scan `docs/project/*.md`
- Check which of 7 project docs already exist:
  - requirements.md (ALWAYS needed)
  - architecture.md (ALWAYS needed)
  - tech_stack.md (ALWAYS needed)
  - api_spec.md (Backend/Full-stack only)
  - database_schema.md (if database detected)
  - design_guidelines.md (Frontend/Full-stack only)
  - runbook.md (Docker-based projects)
- Build list of MISSING files

**1.2 Determine conditional templates**:
- **api_spec.md**: Create if Backend/Full-stack project
  - Detect: Check package.json for backend frameworks (express, fastify, nestjs) OR python/go/java runtime
  - Skip for Frontend-only projects
- **database_schema.md**: Create if database detected
  - Detect: Check package.json for database libraries (pg, mongoose, mysql2, sqlite3, prisma)
  - Skip if no database found
- **design_guidelines.md**: Create if Frontend framework detected
  - Detect: Check package.json for frontend frameworks (react, vue, angular, svelte, next)
  - Skip for Backend-only projects

**1.3 Create missing templates**:
- For each missing file, use Write tool to create from `references/templates/`:
  - `requirements_template.md` → `docs/project/requirements.md` (if missing)
  - `architecture_template.md` → `docs/project/architecture.md` (if missing)
  - `tech_stack_template.md` → `docs/project/tech_stack.md` (if missing)
  - `api_spec_template.md` → `docs/project/api_spec.md` (if missing and needed)
  - `database_schema_template.md` → `docs/project/database_schema.md` (if missing and needed)
  - `design_guidelines_template.md` → `docs/project/design_guidelines.md` (if missing and needed)
  - `runbook_template.md` → `docs/project/runbook.md` (if missing)
- Track created file list (for Phase 2-3 validation)

**1.4 Log summary**:
```
✓ Project documentation structure:
  - Created: X new files
  - Preserved: Y existing files
  - Skipped: Z conditional files (not needed for this project type)
```

**Output**:
```
docs/project/
├── requirements.md         (created or existing)
├── architecture.md         (created or existing)
├── tech_stack.md          (created or existing)
├── api_spec.md            (created or existing, conditional)
├── database_schema.md     (created or existing, conditional)
├── design_guidelines.md   (created or existing, conditional)
└── runbook.md             (created or existing, conditional)
```

---

### Phase 2: Validate Structure

**Objective**: Ensure project documentation complies with structural requirements and auto-fix violations.

**Process**:

**2.1 Check SCOPE tags** (all created files):
- Read first 5 lines of each file created in Phase 1
- Check for `<!-- SCOPE: ... -->` tag
- Expected patterns:
  - requirements.md: `<!-- SCOPE: Functional requirements ONLY (FR-XXX-NNN) -->`
  - architecture.md: `<!-- SCOPE: arc42 architecture documentation with C4 Model -->`
  - tech_stack.md: `<!-- SCOPE: Technology stack with versions and Docker configuration -->`
  - api_spec.md: `<!-- SCOPE: API specification (OpenAPI 3.0 compatible) -->`
  - database_schema.md: `<!-- SCOPE: Database schema with ER diagrams -->`
  - design_guidelines.md: `<!-- SCOPE: UI/UX design system and guidelines -->`
  - runbook.md: `<!-- SCOPE: Operations guide (local/testing/production) -->`
- If missing:
  - Use Edit tool to add SCOPE tag at line 1 (after first heading)
  - Track violation count
- Log: "✓ SCOPE tags: [added N/all present]"

**2.2 Check required sections** (from questions.md):
- Load `references/questions.md` using Read tool
- For each document created in Phase 1:
  - Extract expected sections from questions.md
  - Check if section headers exist in document
  - If missing:
    - Use Edit tool to add section with placeholder
    - Track violation count
- Examples:
  - requirements.md: ## Functional Requirements
  - architecture.md: ## 1. Introduction and Goals, ## 2. Constraints, ..., ## 11. Glossary
  - tech_stack.md: ## Frontend Technologies, ## Backend Technologies, ## Database, ## Additional Technologies
- Log: "✓ Required sections: [added N sections across M files/all present]"

**2.3 Check Maintenance section** (all created files):
- Search for `## Maintenance` header in each file
- If missing:
  - Use Edit tool to add at end of file:
    ```markdown
    ## Maintenance

    **Last Updated:** [current date]

    **Update Triggers:**
    - [Document-specific triggers]

    **Verification:**
    - [ ] All sections have content (no placeholders)
    - [ ] Diagrams render correctly
    - [ ] Links to other docs are valid
    ```
  - Track violation count
- Log: "✓ Maintenance sections: [added N/all present]"

**2.4 Check POSIX file endings** (all created files):
- Check if each file ends with single blank line
- If missing:
  - Use Edit tool to add final newline
  - Track fix count
- Log: "✓ POSIX compliance: [fixed N files/all compliant]"

**2.5 Conditional checks**:
- **api_spec.md**: Only validate if Backend/Full-stack project detected
  - Skip validation if Frontend-only project
  - Log: "ℹ api_spec.md skipped (Frontend-only project)"
- **database_schema.md**: Only validate if database detected in dependencies
  - Check package.json for database libraries (pg, mongoose, mysql2, sqlite3)
  - Skip if no database found
  - Log: "ℹ database_schema.md skipped (no database detected)"
- **design_guidelines.md**: Only validate if Frontend framework detected
  - Check package.json for frontend frameworks (react, vue, angular, svelte)
  - Skip if Backend-only project
  - Log: "ℹ design_guidelines.md skipped (Backend-only project)"

**2.6 Report validation**:
- Log summary:
  ```
  ✅ Structure validation complete:
    - SCOPE tags: [added N/all present]
    - Missing sections: [added N sections across M files/all present]
    - Maintenance sections: [added N/all present]
    - POSIX endings: [fixed N files/all compliant]
    - Conditional checks: [skipped K files based on project type]
  ```
- If violations found: "⚠️ Auto-fixed [total] structural violations"

---

### Phase 3: Validate Content

**Objective**: Ensure each section answers its questions with meaningful content using semantic validation.

**Process**:

**3.1 Load validation spec**:
- Read `references/questions.md` using Read tool
- Parse all 27 questions with validation heuristics, auto-discovery hints, and MCP Ref hints
- Build validation map: {document → [{question, section, heuristics, auto_discovery, mcp_ref}]}

**3.2 Validate sections** (parametric loop for ~27 questions):

For each question in questions.md:

1. **Extract section content**:
   - Read target document (requirements.md, architecture.md, etc.)
   - Extract section content between headers
   - If section missing → error (should have been added in Phase 2.2)

2. **Check if content answers question**:
   - Apply validation heuristics from questions.md
   - Examples:
     - "Has FR-XXX identifiers" → scan for pattern `FR-\w+-\d+`
     - "Length > 100 words" → count words in section
     - "Has Mermaid diagram" → check for ```mermaid code blocks
   - If ANY heuristic passes → content valid, skip to next question
   - If ALL fail → content invalid, continue

3. **Auto-discovery** (if content invalid or has placeholders):
   - Execute auto-discovery hints from questions.md
   - Examples:
     - **package.json scanning**:
       - Read package.json
       - Extract dependencies, devDependencies, scripts, engines, version
       - Identify frameworks (react → Frontend, express → Backend)
     - **src/ directory structure**:
       - Scan src/ using Glob tool
       - Detect architecture patterns:
         - `src/controllers/`, `src/services/`, `src/repositories/` → Layered architecture
         - `src/modules/`, `src/features/` → Modular architecture
         - `src/pages/`, `src/components/` → Frontend component structure
     - **docker-compose.yml**:
       - Read docker-compose.yml if exists
       - Extract services (postgres, mongo, redis, rabbitmq)
       - Populate tech_stack.md and database_schema.md sections
     - **.env.example**:
       - Read .env.example if exists
       - Extract configuration variables
       - Populate runbook.md environment variables section
     - **migrations/ directory**:
       - Scan migrations/ or db/migrations/
       - Extract table names from CREATE TABLE statements
       - Populate database_schema.md tables section
   - If auto-discovery successful:
     - Use Edit tool to populate section with discovered data
     - Track change: `sections_populated += 1`
     - Skip MCP Ref and user questions
   - If auto-discovery fails → continue to MCP Ref

4. **MCP Ref research** (if auto-discovery fails):
   - Execute MCP Ref hints from questions.md
   - Examples:
     - Framework features: `mcp__context7__resolve-library-id("React")` → `mcp__context7__get-library-docs("/facebook/react", topic="React 18 features")`
     - Architecture patterns: `mcp__Ref__ref_search_documentation("Layered architecture vs microservices")`
     - Library standards: `mcp__Ref__ref_search_documentation("Repository pattern best practices")`
     - Technology comparison: `mcp__Ref__ref_search_documentation("PostgreSQL vs MongoDB comparison")`
   - If research yields useful information:
     - Use Edit tool to populate section with research summary
     - Track change: `sections_researched += 1`
     - Skip user questions
   - If research fails → continue to user fallback

5. **User question fallback** (if auto-discovery AND MCP Ref fail):
   - Ask user the question from questions.md
   - Examples:
     - "What are the main functional requirements?" (if no hints found)
     - "What are the system quality goals?" (if no constraints discovered)
     - "What is the primary architecture pattern?" (if src/ structure ambiguous)
   - Wait for user response
   - Use Edit tool to populate section with user's answer
   - Track change: `sections_user_input += 1`

6. **Track validation result**:
   - Log per question: "[Document] Section X: [valid/populated via auto-discovery/populated via MCP Ref/populated via user input]"

**3.3 Priority-based validation** (optimize token usage):
- **Critical priority** (requirements.md, architecture.md, runbook.md):
  - Validate all sections
  - Ask user questions if auto-discovery/MCP Ref fail
- **High priority** (tech_stack.md, api_spec.md, database_schema.md):
  - Validate all sections
  - Prefer auto-discovery and MCP Ref
  - Only ask critical user questions
- **Medium priority** (design_guidelines.md):
  - Validate required sections only
  - Skip if Frontend-only and user confirms can use template defaults

**3.4 Report content validation**:
- Log summary:
  ```
  ✅ Content validation complete:
    - Questions checked: 27 (or 22 for backend-only, 24 for frontend-only)
    - Already valid: [count] sections
    - Populated via auto-discovery: [count] sections
    - Populated via MCP Ref: [count] sections
    - Populated via user input: [count] sections
    - Placeholders kept: [count] sections (optional content)
  ```

**Auto-discovery success rate example**:
```
Full-stack Node.js project with package.json + docker-compose.yml:
- Auto-discovery: ~18/27 questions (67%)
- MCP Ref: ~5/27 questions (18%)
- User input: ~4/27 questions (15%)
```

---

### Phase 4: Finalization

**Objective**: Provide complete overview and next steps.

**Process**:
1. List all project files with status (3-7 files depending on project type):
   - `docs/project/requirements.md` (ALWAYS) - created or preserved
   - `docs/project/architecture.md` (ALWAYS) - created or preserved
   - `docs/project/tech_stack.md` (ALWAYS) - created or preserved
   - `docs/project/api_spec.md` (if API/Backend/Full-stack) - created or preserved
   - `docs/project/database_schema.md` (if uses database) - created or preserved
   - `docs/project/design_guidelines.md` (if Frontend/Full-stack) - created or preserved
   - `docs/project/runbook.md` (if Docker-based) - created or preserved

2. Report summary:
   - "✓ Project documentation complete: Created X new files, preserved Y existing"
   - "Validation: Structure [N fixes], Content [M updates]"

**Output**: Summary message with project files status (created vs preserved)

---

## Complete Output Structure

```
docs/
└── project/
    ├── requirements.md         # Functional Requirements (FR-XXX-NNN) ONLY
    ├── architecture.md         # arc42-based architecture with C4 Model
    ├── tech_stack.md          # Technology stack, versions, Docker setup
    ├── api_spec.md            # API endpoints, auth, error codes (conditional)
    ├── database_schema.md     # ER diagrams, tables, migrations (conditional)
    ├── design_guidelines.md   # UI/UX design system (conditional - frontend only)
    └── runbook.md             # Operations: local/testing/production (conditional)
```

**Conditional files:**
- `api_spec.md` - Created for API/Backend/Full-stack projects
- `database_schema.md` - Created if project uses database (PostgreSQL, MySQL, MongoDB, etc.)
- `design_guidelines.md` - Created for Frontend/Full-stack projects (skipped for backend-only)
- `runbook.md` - Created for Docker-based projects

---

## Reference Files Used

### Document Templates

**Project Document Templates** (used in Phase 1 from `references/templates/`):
- `requirements_template.md` - Functional Requirements ONLY (ISO/IEC/IEEE 29148:2018)
- `architecture_template.md` - arc42-based architecture with C4 Model (ISO/IEC/IEEE 42010:2022)
- `tech_stack_template.md` - Technology stack, versions, Docker configuration
- `api_spec_template.md` - API specification (OpenAPI 3.0 compatible)
- `database_schema_template.md` - ER diagrams, data dictionary, migrations
- `design_guidelines_template.md` - UI/UX design system (WCAG 2.1 Level AA)
- `runbook_template.md` - Operations guide (local/testing/production)

**Validation Specification**:
- `references/questions.md` (v1.0) - 27 questions with validation heuristics:
  - Questions each section must answer
  - Validation heuristics (checkable criteria)
  - Auto-discovery hints (package.json, src/, docker-compose.yml, migrations/)
  - MCP Ref hints (external research topics)

---

## Best Practices

- **Idempotent Operations**: ✅ Checks file existence before creation (Phase 1), creates only missing files, preserves existing project docs
- **Conditional Templates**: Only create templates relevant to project type (skip design_guidelines.md for backend-only, skip api_spec.md for frontend-only)
- **Parametric Validation**: Phase 3 uses loop for 27 questions (no code duplication)
- **Auto-discovery First**: Scan actual files before external API calls or user questions
- **Separation of Concerns**: CREATE → VALIDATE STRUCTURE → VALIDATE CONTENT → FINALIZE
- **Document Generation**: English only, explicit IDs (FR-XXX-001), MoSCoW prioritization, meaningful Mermaid diagrams with actual data
- **Token Efficiency**: Reuse discovered data across multiple documents, avoid asking same questions twice

---

## Prerequisites

**Invoked by**: ln-110-documents-pipeline orchestrator

**Requires**:
- `docs/` directory (created by ln-111-root-docs-creator)

**Creates**:
- `docs/project/` directory structure (3-7 files)
- Validated project documentation with structure and content checks

**Idempotent**: ✅ Can be invoked multiple times safely
- Checks file existence before creation
- Skips existing files
- Re-validates on subsequent runs

---

## Definition of Done

Before completing work, verify ALL checkpoints:

**✅ Documents Generated:**
- [ ] All required project documents created successfully (3-7 files depending on project type):
  - `docs/project/requirements.md` (ALWAYS)
  - `docs/project/architecture.md` (ALWAYS)
  - `docs/project/tech_stack.md` (ALWAYS)
  - `docs/project/api_spec.md` (if API/Backend/Full-stack)
  - `docs/project/database_schema.md` (if uses database)
  - `docs/project/design_guidelines.md` (if Frontend/Full-stack)
  - `docs/project/runbook.md` (if Docker-based)
- [ ] SCOPE tags included in first 3-5 lines of each document
- [ ] Maintenance sections present in all docs
- [ ] All placeholders replaced with actual content (no `{{PLACEHOLDER}}` remaining)

**✅ Content Quality:**
- [ ] Mermaid diagrams valid syntax (Business Context, Technical Context, C4 diagrams, ER diagrams)
- [ ] Requirement IDs sequential and unique (FR-XXX-001 only)
- [ ] MoSCoW prioritization applied correctly (MUST/SHOULD/COULD/WON'T)
- [ ] Language: English only (per project standards)
- [ ] Docker configuration present in tech_stack.md

**✅ Phase Completion:**
- [ ] Phase 1: Create Structure completed
  - [ ] Conditional templates determined (api_spec, database_schema, design_guidelines)
  - [ ] Missing files created (3-7 based on project type)
  - [ ] Created file list tracked
- [ ] Phase 2: Validate Structure completed
  - [ ] SCOPE tags verified/added (all created files)
  - [ ] Required sections verified/added (from questions.md)
  - [ ] Maintenance sections verified/added (all created files)
  - [ ] POSIX file endings verified/fixed
  - [ ] Conditional checks performed (api_spec, database_schema, design_guidelines)
- [ ] Phase 3: Validate Content completed
  - [ ] questions.md loaded for semantic validation
  - [ ] All 27 questions validated (or 22/24 for specific project types)
  - [ ] Auto-discovery executed where applicable
  - [ ] MCP Ref research executed where needed
  - [ ] User fallback questions asked for critical content
  - [ ] Content validation report generated
- [ ] Phase 4: Finalization completed
  - [ ] Summary displayed with file paths and status

**✅ User Guidance:**
- [ ] Summary message displayed with all file paths
- [ ] User informed: "✓ Project documentation complete (X files created)"

**Output:** Complete project documentation set in `docs/project/` (3-7 MD docs depending on project type)

---

## Technical Details

**Standards**: ISO/IEC/IEEE 29148:2018 (Requirements), ISO/IEC/IEEE 42010:2022 (Architecture), arc42, C4 Model, MoSCoW Prioritization, OWASP Security, WCAG 2.1 Level AA

**Language**: English only

---

**Version:** 12.0.0 (MAJOR: Merged validation into worker. Added Phase 2 structure validation + Phase 3 semantic content validation with extensive auto-discovery (package.json, src/, docker-compose.yml, migrations/) and MCP Ref research. Idempotent - can be invoked multiple times.)
**Last Updated:** 2025-11-18
