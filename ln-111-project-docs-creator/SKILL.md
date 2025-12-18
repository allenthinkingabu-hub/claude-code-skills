---
name: ln-111-project-docs-creator
description: Creates complete project documentation (11 docs): root docs (CLAUDE.md, docs/README.md, documentation_standards.md, principles.md) + project docs (requirements, architecture, tech_stack + 4 conditional). First worker in ln-110-documents-pipeline.
---

# Project Documentation Creator

Creates and validates complete project documentation following industry best practices (ISO/IEC/IEEE standards, arc42, C4 Model, ADR format).

**Documents created:**
- **Root (4)**: CLAUDE.md, docs/README.md, documentation_standards.md, principles.md
- **Project (3-7)**: requirements.md, architecture.md, tech_stack.md + conditional (api_spec, database_schema, design_guidelines, runbook)

## When to Use This Skill

**This skill is a WORKER** invoked by **ln-110-documents-pipeline** orchestrator.

Use directly when:
- Creating complete documentation structure (root + project docs)
- Setting up documentation for existing project
- Validating existing documentation

**Part of workflow**: ln-110-documents-pipeline (orchestrator) -> **ln-111-project-docs-creator** -> ln-112-reference-docs-creator -> ln-113-tasks-docs-creator -> ln-114-test-docs-creator -> ln-115-presentation-creator

## How It Works

5-phase workflow: **GATHER CONTEXT** -> **CREATE** -> **VALIDATE STRUCTURE** -> **VALIDATE CONTENT** -> **FINALIZE**

---

### Phase 1: Gather Context & Create Documents

**Objective**: Collect project data first, then create populated documentation files.

#### 1.0 Context Gathering (Context First, Questions Last)

**Principle**: Collect ALL project data BEFORE creating documents. Interactive questions are the LAST RESORT.

**1.0.1 Auto-Discovery** (scan project files):

| Source | Extracted Data | Target Placeholders |
|--------|----------------|---------------------|
| package.json | name, version, dependencies, scripts, engines | `{{PROJECT_NAME}}`, `{{FRONTEND_FRAMEWORK}}`, `{{BACKEND_FRAMEWORK}}`, `{{DATABASE}}`, `{{TEST_FRAMEWORK}}`, `{{RUNTIME_VERSION}}` |
| docker-compose.yml | services, ports, volumes, networks | `{{DOCKER_COMPOSE_DEV}}`, `{{SERVICES_DIAGRAM}}`, `{{DATABASE}}` |
| Dockerfile | base image, runtime version | `{{RUNTIME_VERSION}}`, `{{CONTAINER_CONFIG}}` |
| src/ structure | folders, patterns, layers | `{{TOP_LEVEL_DECOMPOSITION}}`, `{{ARCHITECTURE_PATTERN}}`, `{{LAYER_DIAGRAM}}` |
| migrations/ | table definitions, relationships | `{{SCHEMA_OVERVIEW}}`, `{{ER_DIAGRAM}}` |
| .env.example | environment variables | `{{ENV_VARIABLES}}`, `{{CONFIG_MANAGEMENT}}` |
| README.md (existing) | project description | `{{PROJECT_DESCRIPTION}}` |
| tsconfig.json / jsconfig.json | paths, aliases | `{{MODULE_STRUCTURE}}` |

**1.0.2 User Materials Request**:
- **ALWAYS ASK**: "Do you have existing materials to review? (design docs, specs, requirements, diagrams, Figma links)"
- If YES: Read provided files and extract answers for questions Q1-Q48
- Extract: scope boundaries, feature lists, API contracts, business rules

**1.0.3 MCP Research** (for discovered technologies):
- **Context7/Ref**: Library versions, API patterns, configuration best practices
- **WebSearch**: Architecture patterns for detected stack (e.g., "React + Node.js + PostgreSQL architecture")
- **Target**: Fill `{{BEST_PRACTICES}}`, `{{INTEGRATION_PATTERNS}}`, `{{SECURITY_RECOMMENDATIONS}}`

**1.0.4 Interactive Questions (fallback only)**:
- Show progress: "Gathered answers for X/48 questions from auto-discovery"
- Ask ONLY remaining unanswered questions
- Priority order:
  1. **Critical** (Q1-Q3): Scope, MVP features, quality goals
  2. **High** (Q9, Q12): Architecture decisions, tech constraints
  3. **Medium/Low**: Fill as needed

**1.0.5 Context Store**:
- Store all gathered data in memory as key-value pairs
- Example: `{ "PROJECT_NAME": "MyApp", "FRONTEND_FRAMEWORK": "React 18", "DATABASE": "PostgreSQL 16", ... }`
- This context is used in Phase 1.1-1.2 for placeholder replacement

---

#### 1.1 Create Root Documentation (with populated content)

**Template Processing** (applies to ALL files):
1. Copy template to target location
2. Replace ALL placeholders from Context Store (Phase 1.0.5)
3. Remove conditional sections if data not available (e.g., remove "Backend" section if no backend detected)

**CLAUDE.md**:
- If exists: check for `docs/README.md` link, add if missing
- If NOT exists:
  - Copy template: `references/templates/root/claude_md_template.md` -> `CLAUDE.md`
  - Replace from Context Store: `{{PROJECT_NAME}}`, `{{PROJECT_DESCRIPTION}}`, `{{DATE}}`, `{{TECH_STACK_SUMMARY}}`

**docs/README.md**:
- If exists: skip
- If NOT exists:
  - Create docs/ directory if missing
  - Copy template: `references/templates/root/docs_root_readme_template.md`
  - Replace from Context Store: `{{PROJECT_NAME}}`, `{{STATUS}}`, `{{ARCHITECTURE_OVERVIEW}}`

**docs/documentation_standards.md**:
- If exists: skip
- If NOT exists: Copy template (universal standards, no project-specific placeholders)

**docs/principles.md**:
- If exists: skip
- If NOT exists: Copy template (universal principles, no project-specific placeholders)

#### 1.2 Create Project Documentation (with populated content)

**Check existing files**:
- Use Glob: `docs/project/*.md`
- Build list of MISSING files

**Determine conditional templates** (from Context Store):
| Document | Condition | Context Store Key |
|----------|-----------|-------------------|
| api_spec.md | Backend/Full-stack | `hasBackend: true` |
| database_schema.md | Database used | `hasDatabase: true` |
| design_guidelines.md | Frontend | `hasFrontend: true` |
| runbook.md | Docker-based | `hasDocker: true` |

**Create missing files with populated content**:

| Document | Key Placeholders from Context Store |
|----------|-------------------------------------|
| requirements.md (ALWAYS) | `{{PROJECT_SCOPE}}`, `{{MVP_FEATURES}}`, `{{FR_USER_MANAGEMENT}}`, `{{FR_CORE_FEATURES}}`, `{{NFR_PERFORMANCE}}`, `{{NFR_SECURITY}}` |
| architecture.md (ALWAYS) | `{{ARCHITECTURE_PATTERN}}`, `{{TOP_LEVEL_DECOMPOSITION}}`, `{{LAYER_DIAGRAM}}`, `{{QUALITY_GOALS}}`, `{{TECH_CONSTRAINTS}}` |
| tech_stack.md (ALWAYS) | `{{FRONTEND_FRAMEWORK}}`, `{{BACKEND_FRAMEWORK}}`, `{{DATABASE}}`, `{{RUNTIME_VERSION}}`, `{{TEST_FRAMEWORK}}` |
| api_spec.md (conditional) | `{{API_ENDPOINTS}}`, `{{AUTH_SCHEME}}`, `{{ERROR_RESPONSES}}`, `{{RATE_LIMITS}}` |
| database_schema.md (conditional) | `{{SCHEMA_OVERVIEW}}`, `{{ER_DIAGRAM}}`, `{{TABLE_DEFINITIONS}}`, `{{INDEXES}}` |
| design_guidelines.md (conditional) | `{{COLOR_PALETTE}}`, `{{TYPOGRAPHY}}`, `{{COMPONENT_LIBRARY}}`, `{{RESPONSIVE_BREAKPOINTS}}` |
| runbook.md (conditional) | `{{DOCKER_COMPOSE_DEV}}`, `{{ENV_VARIABLES}}`, `{{STARTUP_SEQUENCE}}`, `{{HEALTH_CHECKS}}` |

**Placeholder Handling**:
- If placeholder value exists in Context Store: replace with actual value
- If placeholder NOT in Context Store: leave as `[TBD: placeholder_name]` for later manual completion
- Log: "Placeholder {{X}} not found in context, marked as TBD"

**Output**:
```
project_root/
├── CLAUDE.md
└── docs/
    ├── README.md
    ├── documentation_standards.md
    ├── principles.md
    └── project/
        ├── requirements.md
        ├── architecture.md
        ├── tech_stack.md
        ├── api_spec.md (conditional)
        ├── database_schema.md (conditional)
        ├── design_guidelines.md (conditional)
        └── runbook.md (conditional)
```

---

### Phase 2: Validate Structure

**Objective**: Ensure all files comply with structural requirements.

**2.1 Check SCOPE tags** (all created files):
- Read first 10 lines
- Add SCOPE tag if missing (per document type)

**2.2 Check required sections** (from questions.md):
- Load `references/questions.md`
- For each document: verify required sections exist
- Add missing sections with placeholders

**2.3 Check Maintenance sections**:
- Verify `## Maintenance` header in each file
- Add if missing with Update Triggers, Verification, Last Updated

**2.4 Check POSIX file endings**:
- Ensure single blank line at end
- Fix if missing

**2.5 Report**:
```
Structure validation complete:
  - SCOPE tags: [added N/all present]
  - Missing sections: [added N/all present]
  - Maintenance sections: [added N/all present]
  - POSIX endings: [fixed N/all compliant]
```

---

### Phase 3: Validate Content (validation-only)

**Objective**: Verify populated content is meaningful. Content population already done in Phase 1.0.

**3.1 Load validation spec**:
- Read `references/questions.md`
- Parse 48 questions (22 root + 26 project) with validation heuristics

**3.2 Validate sections** (parametric loop):

For each question:
1. **Check if content answers question**:
   - Apply validation heuristics from questions.md
   - If ANY heuristic passes -> valid, next question
   - If ALL fail -> mark as WARNING

2. **Check for TBD markers**:
   - Scan for `[TBD: placeholder_name]` patterns
   - If found: log as "Incomplete: section X needs manual input"

3. **Check for empty placeholders**:
   - Scan for remaining `{{PLACEHOLDER}}` patterns
   - If found: ERROR - Phase 1.0 missed this placeholder

**3.3 Validation Report**:
```
Content validation complete:
  - Questions checked: 48
  - Valid: [count]
  - TBD markers (need manual input): [count]
  - Empty placeholders (ERROR): [count]
```

**3.4 TBD Resolution** (if any TBD markers found):
- List all TBD items with their section locations
- Ask user: "Would you like to complete TBD items now? (y/n)"
- If YES: iterate through TBD items, ask user for input, replace
- If NO: leave TBD markers for later manual completion

---

### Phase 4: Finalization

**Objective**: Provide complete overview with context gathering statistics.

**4.1 File Summary**:
- List all files with status: created (populated) / preserved (existing)

**4.2 Context Gathering Summary**:
```
Context gathering complete:
  - Auto-discovery: [X] placeholders filled
  - User materials: [Y] placeholders filled
  - MCP research: [Z] placeholders filled
  - User questions: [W] placeholders filled (fallback)
  - TBD markers: [N] (require manual completion)
```

**4.3 Final Report**:
```
Project documentation complete:
  - Created: X files (with populated content)
  - Preserved: Y files (existing)
  - Validation: Structure [N fixes], Content [M valid]
  - TBD items: [count] (manual completion needed)
```

---

## Complete Output Structure

```
project_root/
├── CLAUDE.md                              # Project entry point
└── docs/
    ├── README.md                          # Documentation hub
    ├── documentation_standards.md         # 60 universal requirements
    ├── principles.md                      # 8 principles + Decision Framework
    └── project/
        ├── requirements.md                # FR-XXX-NNN (ALWAYS)
        ├── architecture.md                # arc42 + C4 Model (ALWAYS)
        ├── tech_stack.md                  # Versions + Docker (ALWAYS)
        ├── api_spec.md                    # OpenAPI 3.0 (conditional)
        ├── database_schema.md             # ER diagrams (conditional)
        ├── design_guidelines.md           # UI/UX system (conditional)
        └── runbook.md                     # Operations guide (conditional)
```

---

## Reference Files Used

### Templates

**Root Templates** (`references/templates/root/`):
- `claude_md_template.md` - Project entry point
- `docs_root_readme_template.md` - Documentation hub
- `documentation_standards_template.md` - 60 universal requirements
- `principles_template.md` - 8 principles + Decision Framework

**Project Templates** (`references/templates/project/`):
- `requirements_template.md` - ISO/IEC/IEEE 29148:2018
- `architecture_template.md` - arc42 + C4 Model
- `tech_stack_template.md` - Technology stack + Docker
- `api_spec_template.md` - OpenAPI 3.0
- `database_schema_template.md` - ER diagrams
- `design_guidelines_template.md` - WCAG 2.1 Level AA
- `runbook_template.md` - Operations guide

**Guides** (`references/guides/`):
- `automatic_analysis_guide.md` - Auto-discovery patterns
- `critical_questions.md` - Priority questions
- `examples.md` - Sample content
- `template_mappings.md` - Template to section mapping
- `troubleshooting.md` - Common issues

**Validation Specification**:
- `references/questions.md` - 48 questions (22 root + 26 project) with validation heuristics

---

## Best Practices

- **Context First, Questions Last**: Gather ALL data (auto-discovery, materials, MCP) BEFORE asking user questions. Interactive questions are the LAST RESORT
- **Populated Templates**: Documents created with actual project content, not empty placeholders. TBD markers only for truly missing data
- **Idempotent**: Can run multiple times safely (checks existence before creation)
- **Conditional Templates**: Only create files relevant to project type
- **Parametric Validation**: Single loop for all questions (no code duplication)
- **Auto-discovery Priority**: package.json > docker-compose.yml > src/ > migrations/ > .env.example
- **Separation of Concerns**: GATHER CONTEXT -> CREATE -> VALIDATE STRUCTURE -> VALIDATE CONTENT -> FINALIZE
- **Token Efficiency**: Reuse Context Store across all documents (single gathering, multiple uses)
- **SCOPE Tags**: Include in first 3-10 lines of all files
- **CLAUDE.md**: Keep minimal - only project name, description, docs link
- **TBD Pattern**: Use `[TBD: placeholder_name]` for missing data, not empty `{{PLACEHOLDER}}`

---

## Prerequisites

**Invoked by**: ln-110-documents-pipeline orchestrator

**Requires**: None (first worker in chain)

**Creates**:
- 4 root documentation files
- 3-7 project documentation files
- Validated structure and content

---

## Definition of Done

**Context Gathered (Phase 1.0):**
- [ ] Auto-discovery completed (package.json, docker-compose.yml, src/, etc.)
- [ ] User materials requested (if any provided, extracted data)
- [ ] MCP research completed for detected technologies
- [ ] Interactive questions asked ONLY for remaining gaps
- [ ] Context Store populated with all gathered data

**Structure Created (Phase 1.1-1.2):**
- [ ] CLAUDE.md exists in project root (populated with project info)
- [ ] docs/ directory exists with README.md, documentation_standards.md, principles.md
- [ ] docs/project/ directory exists with required files (3-7 based on project type)
- [ ] All placeholders replaced from Context Store
- [ ] TBD markers used only for genuinely missing data

**Structure Validated (Phase 2):**
- [ ] SCOPE tags present in all files
- [ ] Required sections present (from questions.md)
- [ ] Maintenance sections present
- [ ] POSIX file endings compliant

**Content Validated (Phase 3):**
- [ ] All 48 questions checked with validation heuristics
- [ ] No empty `{{PLACEHOLDER}}` patterns remaining
- [ ] TBD markers listed for user awareness
- [ ] CLAUDE.md has docs link
- [ ] Project docs have meaningful content (actual values, not templates)

**Reporting (Phase 4):**
- [ ] Context gathering summary displayed (auto-discovery, materials, MCP, questions)
- [ ] All files listed with status (created/preserved)
- [ ] TBD count reported for manual completion

---

## Technical Details

**Standards**:
- ISO/IEC/IEEE 29148:2018 (Requirements)
- ISO/IEC/IEEE 42010:2022 (Architecture)
- arc42, C4 Model, MoSCoW Prioritization
- OWASP Security, WCAG 2.1 Level AA

**Language**: English only

---

**Version:** 2.0.0
**Last Updated:** 2025-12-18
