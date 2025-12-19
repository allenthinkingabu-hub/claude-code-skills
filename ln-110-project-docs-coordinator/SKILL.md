---
name: ln-110-project-docs-coordinator
description: Coordinates project documentation creation. Gathers context once, detects project type, delegates to 5 L3 workers (ln-111-115). L2 Coordinator invoked by ln-100.
---

# Project Documentation Coordinator

L2 Coordinator that gathers project context once and delegates document creation to specialized L3 workers.

## Purpose & Scope
- **Single context gathering** — analyzes project once, builds Context Store
- **Project type detection** — determines hasBackend, hasDatabase, hasFrontend, hasDocker
- **Delegates to 5 workers** — passes Context Store to each worker
- **Aggregates results** — collects status from all workers, returns summary
- Solves the "context loss" problem by gathering data once and passing explicitly

## Invocation (who/when)
- **ln-100-documents-pipeline:** Invoked as first L2 coordinator in documentation pipeline
- Never called directly by users

## Architecture

```
ln-110-project-docs-coordinator (this skill)
├── Phase 1: Context Gathering (ONE TIME)
├── Phase 2: Delegate to Workers
│   ├── ln-111-root-docs-creator → 4 root docs (ALWAYS)
│   ├── ln-112-project-core-creator → 3 core docs (ALWAYS)
│   ├── ln-113-backend-docs-creator → 2 docs (if hasBackend/hasDatabase)
│   ├── ln-114-frontend-docs-creator → 1 doc (if hasFrontend)
│   └── ln-115-devops-docs-creator → 1 doc (if hasDocker)
└── Phase 3: Aggregate Results
```

## Workflow

### Phase 1: Context Gathering (ONE TIME)

**1.1 Auto-Discovery (scan project files):**

| Source | Data Extracted | Context Store Keys |
|--------|----------------|-------------------|
| package.json | name, description, dependencies, scripts, engines | PROJECT_NAME, PROJECT_DESCRIPTION, DEPENDENCIES, DEV_COMMANDS |
| docker-compose.yml | services, ports | DOCKER_SERVICES |
| Dockerfile | runtime version | RUNTIME_VERSION |
| src/ structure | folders, patterns | SRC_STRUCTURE, ARCHITECTURE_PATTERN |
| migrations/ | table definitions | SCHEMA_OVERVIEW |
| .env.example | environment variables | ENV_VARIABLES |
| tsconfig.json, .eslintrc | conventions | CODE_CONVENTIONS |
| README.md | project description | PROJECT_DESCRIPTION (fallback) |

**1.2 Detect Project Type:**

| Flag | Detection Rule |
|------|----------------|
| hasBackend | express/fastify/nestjs/fastapi/django in dependencies |
| hasDatabase | pg/mongoose/prisma/sequelize in dependencies OR postgres/mongo in docker-compose |
| hasFrontend | react/vue/angular/svelte in dependencies |
| hasDocker | Dockerfile exists OR docker-compose.yml exists |

**1.3 User Materials Request:**
- Ask: "Do you have existing materials (requirements, designs, docs)?"
- If provided: Extract answers for Context Store

**1.4 MCP Research (for detected technologies):**
- Use Context7/Ref for best practices
- Store in Context Store for workers

**1.5 Build Context Store:**
```json
{
  "PROJECT_NAME": "my-project",
  "PROJECT_DESCRIPTION": "...",
  "TECH_STACK": { "frontend": "React 18", "backend": "Express 4.18", "database": "PostgreSQL 15" },
  "DEPENDENCIES": [...],
  "SRC_STRUCTURE": { "controllers": [...], "services": [...] },
  "ENV_VARIABLES": ["DATABASE_URL", "JWT_SECRET"],
  "DEV_COMMANDS": { "dev": "npm run dev", "test": "npm test" },
  "flags": { "hasBackend": true, "hasDatabase": true, "hasFrontend": true, "hasDocker": true }
}
```

### Phase 2: Delegate to Workers

**2.1 Always invoke (parallel):**
- `ln-111-root-docs-creator` with Context Store
- `ln-112-project-core-creator` with full Context Store

**2.2 Conditionally invoke:**
- `ln-113-backend-docs-creator` if hasBackend OR hasDatabase
- `ln-114-frontend-docs-creator` if hasFrontend
- `ln-115-devops-docs-creator` if hasDocker

**Delegation Pattern:**
```
For each worker:
  1. Invoke Skill tool with skill name
  2. Pass Context Store and flags
  3. Wait for completion
  4. Collect result (created, skipped, tbd_count, validation)
```

### Phase 3: Aggregate Results

1. Collect status from all workers
2. Sum totals: created files, skipped files, TBD markers
3. Report any validation warnings
4. Return aggregated summary to ln-100

**Output:**
```json
{
  "workers_invoked": 5,
  "total_created": 11,
  "total_skipped": 0,
  "total_tbd": 8,
  "validation_status": "OK",
  "files": [
    "CLAUDE.md",
    "docs/README.md",
    "docs/documentation_standards.md",
    "docs/principles.md",
    "docs/project/requirements.md",
    "docs/project/architecture.md",
    "docs/project/tech_stack.md",
    "docs/project/api_spec.md",
    "docs/project/database_schema.md",
    "docs/project/design_guidelines.md",
    "docs/project/runbook.md"
  ]
}
```

## Critical Notes
- **Context gathered ONCE** — never duplicated in workers
- **Context Store passed explicitly** — no implicit state
- **Workers self-validate** — coordinator only aggregates
- **Idempotent** — workers skip existing files
- **Parallel where possible** — ln-111 and ln-112 can run in parallel

## Definition of Done
- Context Store built with all discovered data
- Project type flags determined
- All applicable workers invoked
- Results aggregated
- Summary returned to ln-100

## Reference Files
- Guides: `references/guides/automatic_analysis_guide.md`, `critical_questions.md`, `troubleshooting.md`

---
**Version:** 1.0.0
**Last Updated:** 2025-12-19
