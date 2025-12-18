# Project Documentation Questions

**Purpose:** Define what each documentation file should answer. Each section maps to document sections for validation.

**Format:** Document -> Rules -> Questions (with target sections) -> Validation Heuristics -> Auto-Discovery

---

## Table of Contents

### Part 1: Root Documentation (4 documents, 22 questions)

| Document | Questions | Auto-Discovery | Priority | Line |
|----------|-----------|----------------|----------|------|
| [CLAUDE.md](#claudemd) | 6 | Medium | Critical | L45 |
| [docs/README.md](#docsreadmemd) | 7 | Low | High | L165 |
| [docs/documentation_standards.md](#docsdocumentation_standardsmd) | 3 | None | Medium | L295 |
| [docs/principles.md](#docsprinciplesmd) | 6 | None | High | L355 |

### Part 2: Project Documentation (7 documents, 27 questions)

| Document | Questions | Auto-Discovery | Priority | Line |
|----------|-----------|----------------|----------|------|
| [docs/project/requirements.md](#docsprojectrequirementsmd) | 1 | Low | Critical | L470 |
| [docs/project/architecture.md](#docsprojectarchitecturemd) | 11 | High | Critical | L530 |
| [docs/project/tech_stack.md](#docsprojecttechstackmd) | 4 | High | High | L785 |
| [docs/project/api_spec.md](#docsprojectapispecmd) | 2 | Medium | High | L885 |
| [docs/project/database_schema.md](#docsprojectdatabaseschemamd) | 2 | High | High | L950 |
| [docs/project/design_guidelines.md](#docsprojectdesignguidelinesmd) | 3 | Low | Medium | L1015 |
| [docs/project/runbook.md](#docsprojectrunbookmd) | 3 | High | Critical | L1100 |

**Priority Legend:**
- **Critical:** Must answer all questions
- **High:** Strongly recommended
- **Medium:** Optional (can use template defaults)

**Auto-Discovery Legend:**
- **None:** No auto-discovery needed (use template as-is)
- **Low:** 1-2 questions need auto-discovery
- **Medium:** 3+ questions need auto-discovery
- **High:** Most/all questions need auto-discovery

---

# Part 1: Root Documentation

---

<!-- DOCUMENT_START: CLAUDE.md -->
## CLAUDE.md

**File:** CLAUDE.md (project root)
**Target Sections:** Critical Rules for AI Agents, Documentation Navigation Rules, Documentation, Development Commands, Documentation Maintenance Rules, Maintenance

**Rules for this document:**
- Recommended length: <=100 lines (guideline from Claude Code docs)
- Must have SCOPE tag in first 10 lines
- Must link to docs/README.md
- Entry point for all documentation (DAG root)

---

<!-- QUESTION_START: 1 -->
### Question 1: Where is project documentation located?

**Expected Answer:** Links to docs/README.md, documentation_standards.md, principles.md
**Target Section:** ## Documentation

**Validation Heuristics:**
- Has section "## Documentation" with links to docs/README.md, documentation_standards.md, principles.md

**Auto-Discovery:**
- None needed (standard structure)
<!-- QUESTION_END: 1 -->

---

<!-- QUESTION_START: 2 -->
### Question 2: What are critical rules for AI agents?

**Expected Answer:** Table of critical rules organized by category (Standards Hierarchy, Documentation, Testing, Research, Task Management, Skills, Language) with When to Apply and Rationale columns
**Target Section:** ## Critical Rules for AI Agents

**Validation Heuristics:**
- Has section "## Critical Rules for AI Agents" with table (Category, Rule, When to Apply, Rationale), 7+ rows, "Key Principles" subsection

**Auto-Discovery:**
- None needed (universal rules)
<!-- QUESTION_END: 2 -->

---

<!-- QUESTION_START: 3 -->
### Question 3: How to navigate documentation (DAG structure)?

**Expected Answer:** SCOPE tags explanation + reading order + graph structure with examples
**Target Section:** ## Documentation Navigation Rules

**Validation Heuristics:**
- Has section "## Documentation Navigation Rules" with SCOPE tag explanation, reading order (numbered list), example navigation, >40 words

**Auto-Discovery:**
- None needed (universal best practice)
<!-- QUESTION_END: 3 -->

---

<!-- QUESTION_START: 4 -->
### Question 4: What are documentation maintenance rules?

**Expected Answer:** DRY principles, Single Source of Truth, update triggers, English-only policy
**Target Section:** ## Documentation Maintenance Rules

**Validation Heuristics:**
- Has section "## Documentation Maintenance Rules" with "Single Source of Truth"/"DRY", "English Only" rule, >60 words

**Auto-Discovery:**
- None needed (universal standards)
<!-- QUESTION_END: 4 -->

---

<!-- QUESTION_START: 5 -->
### Question 5: When should CLAUDE.md be updated?

**Expected Answer:** Update triggers + verification checklist
**Target Section:** ## Maintenance

**Validation Heuristics:**
- Has section "## Maintenance" with "Update Triggers" and "Verification" subsections, "Last Updated" field

**Auto-Discovery:**
- None needed (standard maintenance section)
<!-- QUESTION_END: 5 -->

---

<!-- QUESTION_START: 6 -->
### Question 6: What are the project development commands?

**Expected Answer:** Table with development commands organized by task (Install Dependencies, Run Tests, Start Dev Server, Build, Lint/Format) for both Windows and Bash
**Target Section:** ## Development Commands

**Validation Heuristics:**
- Has section "## Development Commands" with table (Task, Windows, Bash), 5+ rows

**Auto-Discovery:**
- Scan package.json -> "scripts" field (for Node.js projects)
- Scan pyproject.toml -> [tool.poetry.scripts] or [project.scripts] (for Python projects)
- Scan Makefile -> targets (for Make-based projects)
<!-- QUESTION_END: 6 -->

---

**Overall File Validation:**
- Has SCOPE tag in first 10 lines
- Total length > 80 words (meaningful content)

<!-- DOCUMENT_END: CLAUDE.md -->

---

<!-- DOCUMENT_START: docs/README.md -->
## docs/README.md

**File:** docs/README.md (documentation hub)
**Target Sections:** Overview, General Documentation Standards, Writing Guidelines, Standards Compliance, Contributing to Documentation, Quick Navigation, Maintenance

**Rules for this document:**
- Must have SCOPE tag in first 10 lines (HTML comment)
- Hub file - navigation to subdirectories (project/, reference/, tasks/)
- General standards only - NO project-specific content

---

<!-- QUESTION_START: 7 -->
### Question 7: What is the documentation structure?

**Expected Answer:** Overview of documentation areas (Project, Reference, Task Management)
**Target Section:** ## Overview

**Validation Heuristics:**
- Has section "## Overview" mentioning Project Documentation (project/), Reference Documentation (reference/), Task Management (tasks/), >30 words

**Auto-Discovery:**
- Scan docs/ directory for subdirectories (project/, reference/, tasks/)
<!-- QUESTION_END: 7 -->

---

<!-- QUESTION_START: 8 -->
### Question 8: What are general documentation standards?

**Expected Answer:** SCOPE Tags, Maintenance Sections, Sequential Numbering, Placeholder Conventions
**Target Section:** ## General Documentation Standards

**Validation Heuristics:**
- Has section "## General Documentation Standards" with subsections (SCOPE Tags, Maintenance Sections, Sequential Numbering, Placeholder Conventions), >100 words

**Auto-Discovery:**
- None needed (universal standards)
<!-- QUESTION_END: 8 -->

---

<!-- QUESTION_START: 9 -->
### Question 9: What are writing guidelines?

**Expected Answer:** Progressive Disclosure Pattern, token efficiency, table-first format
**Target Section:** ## Writing Guidelines

**Validation Heuristics:**
- Has section "## Writing Guidelines" mentioning Progressive Disclosure/token efficiency, table/list with format guidelines, >50 words

**Auto-Discovery:**
- None needed (universal best practice)
<!-- QUESTION_END: 9 -->

---

<!-- QUESTION_START: 10 -->
### Question 10: When should docs/README.md be updated?

**Expected Answer:** Update triggers + verification checklist
**Target Section:** ## Maintenance

**Validation Heuristics:**
- Has section "## Maintenance" with "Update Triggers" and "Verification" subsections

**Auto-Discovery:**
- None needed (standard maintenance section)
<!-- QUESTION_END: 10 -->

---

<!-- QUESTION_START: 11 -->
### Question 11: What are the standards this documentation complies with?

**Expected Answer:** Standards Compliance table with Standard, Application, and Reference columns
**Target Section:** ## Standards Compliance

**Validation Heuristics:**
- Has section "## Standards Compliance" with table (Standard, Application, Reference), 5+ standards (ISO/IEC/IEEE 29148:2018, ISO/IEC/IEEE 42010:2022, arc42, C4 Model, ADR Format, MoSCoW)

**Auto-Discovery:**
- None needed (universal standards)
<!-- QUESTION_END: 11 -->

---

<!-- QUESTION_START: 12 -->
### Question 12: How to contribute to documentation?

**Expected Answer:** Numbered list of contribution steps (Check SCOPE tags, Update Last Updated date, Update registry, Follow sequential numbering, Add placeholders, Verify links)
**Target Section:** ## Contributing to Documentation

**Validation Heuristics:**
- Has section "## Contributing to Documentation" with 6+ steps mentioning SCOPE tags, Last Updated, registry, sequential numbering, link verification, >40 words

**Auto-Discovery:**
- None needed (universal contribution guidelines)
<!-- QUESTION_END: 12 -->

---

<!-- QUESTION_START: 13 -->
### Question 13: How to quickly navigate to key documentation areas?

**Expected Answer:** Quick Navigation table with Area, Key Documents, and Skills columns
**Target Section:** ## Quick Navigation

**Validation Heuristics:**
- Has section "## Quick Navigation" with table (Area, Key Documents, Skills), 4 rows (Standards, Project, Reference, Tasks)

**Auto-Discovery:**
- Scan docs/ directory structure (project/, reference/, tasks/)
<!-- QUESTION_END: 13 -->

---

**Overall File Validation:**
- Has SCOPE tag (HTML comment) in first 10 lines
- Total length > 100 words

<!-- DOCUMENT_END: docs/README.md -->

---

<!-- DOCUMENT_START: docs/documentation_standards.md -->
## docs/documentation_standards.md

**File:** docs/documentation_standards.md (60 universal requirements)
**Target Sections:** Quick Reference, 12 main sections (Claude Code Integration through References), Maintenance

**Rules for this document:**
- 60+ universal documentation requirements
- 12 main sections covering industry standards
- References to ISO/IEC/IEEE, DIATAXIS, arc42

---

<!-- QUESTION_START: 14 -->
### Question 14: What are the comprehensive documentation requirements?

**Expected Answer:** Quick Reference table with 60+ requirements in 12 categories
**Target Section:** ## Quick Reference

**Validation Heuristics:**
- Has section "## Quick Reference" with table (Requirement, Description, Priority, Reference), 60+ rows across categories

**Auto-Discovery:**
- None needed (universal standards, use template as-is)
<!-- QUESTION_END: 14 -->

---

<!-- QUESTION_START: 15 -->
### Question 15: What are the detailed requirements for each category?

**Expected Answer:** 12 main sections with detailed explanations
**Target Sections:** 12 sections (## Claude Code Integration, ## AI-Friendly Writing Style, etc.)

**Validation Heuristics:**
- Has 12+ main sections with subsections, mentions ISO/IEC/IEEE/DIATAXIS/arc42 standards, >300 lines

**Auto-Discovery:**
- None needed (universal standards)
<!-- QUESTION_END: 15 -->

---

<!-- QUESTION_START: 16 -->
### Question 16: When should documentation standards be updated?

**Expected Answer:** Update triggers + verification checklist
**Target Section:** ## Maintenance

**Validation Heuristics:**
- Has section "## Maintenance" with "Update Triggers" and "Verification" subsections

**Auto-Discovery:**
- None needed (standard maintenance section)
<!-- QUESTION_END: 16 -->

---

**Overall File Validation:**
- File size > 300 lines
- Mentions ISO/IEC/IEEE 29148:2018
- Mentions DIATAXIS framework
- Mentions arc42

<!-- DOCUMENT_END: docs/documentation_standards.md -->

---

<!-- DOCUMENT_START: docs/principles.md -->
## docs/principles.md

**File:** docs/principles.md (8 development principles + Decision Framework)
**Target Sections:** Core Principles table, Decision-Making Framework, Trade-offs (subsection), Anti-Patterns, Verification Checklist, Maintenance

**Rules for this document:**
- Must have SCOPE tag in first 10 lines
- 8 core principles (Standards First, YAGNI, KISS, DRY, Consumer-First Design, No Legacy Code, Documentation-as-Code, Security by Design)
- Decision-Making Framework (7 steps)
- Verification Checklist (8 items)

---

<!-- QUESTION_START: 17 -->
### Question 17: What are the core development principles?

**Expected Answer:** 8 principles in table format (4 columns: Name, Type, Principle, Approach/Rules)
**Target Section:** ## Core Principles

**Validation Heuristics:**
- Has section "## Core Principles" with 8-row table (Name, Type, Principle, Approach/Rules): Standards First, YAGNI, KISS, DRY, Consumer-First Design, No Legacy Code, Documentation-as-Code, Security by Design

**Auto-Discovery:**
- None needed (universal principles)
<!-- QUESTION_END: 17 -->

---

<!-- QUESTION_START: 18 -->
### Question 18: How to make decisions when principles conflict?

**Expected Answer:** Decision-Making Framework with priority order (Security -> Standards -> Correctness -> ...)
**Target Section:** ## Decision-Making Framework

**Validation Heuristics:**
- Has section "## Decision-Making Framework" with 7 steps (Security, Standards, Correctness, Simplicity, Necessity, Maintainability, Performance), >30 words

**Auto-Discovery:**
- None needed (universal framework)
<!-- QUESTION_END: 18 -->

---

<!-- QUESTION_START: 19 -->
### Question 19: How to resolve conflicts when principles contradict?

**Expected Answer:** Trade-offs table with Conflict, Lower Priority, Higher Priority, and Resolution columns
**Target Section:** ### Trade-offs (subsection under Decision-Making Framework)

**Validation Heuristics:**
- Has subsection "### Trade-offs" under Decision-Making Framework with table (Conflict, Lower Priority, Higher Priority, Resolution), 3+ conflicts

**Auto-Discovery:**
- None needed (universal trade-offs)
<!-- QUESTION_END: 19 -->

---

<!-- QUESTION_START: 20 -->
### Question 20: What are common anti-patterns to avoid?

**Expected Answer:** List of anti-patterns across principles
**Target Section:** ## Anti-Patterns to Avoid

**Validation Heuristics:**
- Has section "## Anti-Patterns to Avoid" with 5+ anti-patterns, >20 words

**Auto-Discovery:**
- None needed (universal anti-patterns)
<!-- QUESTION_END: 20 -->

---

<!-- QUESTION_START: 21 -->
### Question 21: How to verify principles compliance?

**Expected Answer:** Verification checklist with 8 items
**Target Section:** ## Verification Checklist

**Validation Heuristics:**
- Has section "## Verification Checklist" with 8-item checklist (- [ ] format) covering all 8 core principles

**Auto-Discovery:**
- None needed (universal checklist)
<!-- QUESTION_END: 21 -->

---

<!-- QUESTION_START: 22 -->
### Question 22: When should principles be updated?

**Expected Answer:** Update triggers + verification
**Target Section:** ## Maintenance

**Validation Heuristics:**
- Has section "## Maintenance" with "Update Triggers" and "Verification" subsections

**Auto-Discovery:**
- None needed (standard maintenance section)
<!-- QUESTION_END: 22 -->

---

**Overall File Validation:**
- Has SCOPE tag in first 10 lines
- File size > 100 lines
- All 8 core principles present

<!-- DOCUMENT_END: docs/principles.md -->

---

# Part 2: Project Documentation

---

<!-- DOCUMENT_START: docs/project/requirements.md -->
## docs/project/requirements.md

**File:** docs/project/requirements.md (functional requirements ONLY)
**Target Sections:** Functional Requirements

**Rules for this document:**
- ISO/IEC/IEEE 29148:2018 compliant
- FR-XXX-NNN identifiers for all requirements
- MoSCoW prioritization (MUST/SHOULD/COULD/WONT)
- User stories or acceptance criteria format

---

<!-- QUESTION_START: 23 -->
### Question 23: What functionality must the system provide?

**Expected Answer:** Numbered list of functional requirements with FR-XXX-NNN identifiers, MoSCoW priorities, user stories/acceptance criteria
**Target Section:** ## Functional Requirements

**Validation Heuristics:**
- Has FR-XXX identifiers (e.g., FR-001, FR-USR-001)
- Has MoSCoW labels (MUST/SHOULD/COULD/WONT)
- Length > 100 words
- Has numbered list or table

**Auto-Discovery:**
- Check: package.json -> "description" for feature clues
- Check: README.md for feature mentions
- Check: existing docs for use case descriptions

**MCP Ref Hints:**
- Research: "functional requirements best practices"
- Research: "MoSCoW prioritization method"
<!-- QUESTION_END: 23 -->

<!-- DOCUMENT_END: docs/project/requirements.md -->

---

<!-- DOCUMENT_START: docs/project/architecture.md -->
## docs/project/architecture.md

**File:** docs/project/architecture.md (arc42 framework with C4 Model)
**Target Sections:** 11 sections (Introduction and Goals -> Glossary)

**Rules for this document:**
- ISO/IEC/IEEE 42010:2022 compliant
- arc42 framework structure (11 sections)
- C4 Model diagrams (Context, Container, Component)
- Mermaid syntax for all diagrams

---

<!-- QUESTION_START: 24 -->
### Question 24: What are the key quality goals and stakeholders?

**Expected Answer:** Requirements overview summary, 5 quality goals with metrics (Performance, Security, Scalability, Reliability, Maintainability), stakeholders table with roles
**Target Section:** ## 1. Introduction and Goals

**Validation Heuristics:**
- Has subsections 1.1, 1.2, 1.3
- Quality goals have measurable metrics
- Stakeholders table has roles and expectations
- References requirements.md

**Auto-Discovery:**
- Check: package.json -> "author" for stakeholder hints

**MCP Ref Hints:**
- Research: "arc42 quality goals"
- Research: "ISO 25010 quality attributes"
<!-- QUESTION_END: 24 -->

---

<!-- QUESTION_START: 25 -->
### Question 25: What technical and organizational constraints exist?

**Expected Answer:** Technical constraints (languages, databases, cloud providers), organizational constraints (team size, compliance), conventions (code style, testing standards)
**Target Section:** ## 2. Constraints

**Validation Heuristics:**
- Has subsections 2.1 (Technical), 2.2 (Organizational), 2.3 (Conventions)
- Mentions specific technologies
- Lists compliance requirements (GDPR, HIPAA, etc.)

**Auto-Discovery:**
- Check: package.json -> "dependencies" for tech stack
- Check: .eslintrc, .prettierrc for code style conventions
- Check: tsconfig.json, jest.config.js for conventions
<!-- QUESTION_END: 25 -->

---

<!-- QUESTION_START: 26 -->
### Question 26: What are the system boundaries and external interfaces?

**Expected Answer:** Business context (actors, external systems), technical context (protocols, data formats), C4 Context diagram (Mermaid)
**Target Section:** ## 3. Context and Scope

**Validation Heuristics:**
- Has subsections 3.1 (Business Context), 3.2 (Technical Context)
- Has Mermaid code block with C4 Context diagram
- Lists external systems and protocols

**Auto-Discovery:**
- Check: package.json -> "dependencies" for external service clients (stripe, twilio, aws-sdk)
- Check: .env.example for API_URL, DATABASE_URL (external systems)

**MCP Ref Hints:**
- Research: "C4 model context diagram examples"
<!-- QUESTION_END: 26 -->

---

<!-- QUESTION_START: 27 -->
### Question 27: What are the top-level architectural decisions?

**Expected Answer:** Technology decisions table (Frontend, Backend, Database with rationale and ADR links), top-level decomposition approach (Layered/Microservices/Modular)
**Target Section:** ## 4. Solution Strategy

**Validation Heuristics:**
- Has subsections 4.1 (Technology Decisions), 4.2 (Top-level Decomposition), 4.3 (Quality Goals Approach)
- Technology table references ADRs
- Explains architecture pattern choice

**Auto-Discovery:**
- Check: package.json -> "dependencies" for frontend/backend frameworks
- Check: src/ directory structure for architecture pattern
<!-- QUESTION_END: 27 -->

---

<!-- QUESTION_START: 28 -->
### Question 28: How is the system decomposed into components?

**Expected Answer:** C4 diagrams (Level 1 System Context, Level 2 Container, Level 3 Component), key components table
**Target Section:** ## 5. Building Block View

**Validation Heuristics:**
- Has subsections 5.1 (Level 1), 5.2 (Level 2), 5.3 (Level 3)
- Has 3 Mermaid C4 diagrams
- Has components table with responsibilities

**Auto-Discovery:**
- Scan: src/ directory for folders (controllers, services, repositories, components)
- Check: package.json -> "main" for entry point
<!-- QUESTION_END: 28 -->

---

<!-- QUESTION_START: 29 -->
### Question 29: What are the critical runtime scenarios?

**Expected Answer:** 3-5 key scenarios with sequence diagrams (User Registration, Product Purchase, API Request Flow, etc.)
**Target Section:** ## 6. Runtime View

**Validation Heuristics:**
- Has subsections 6.1, 6.2, 6.3 (at least 3 scenarios)
- Each subsection has Mermaid sequence diagram
- Scenarios align with functional requirements

**Auto-Discovery:**
- Check: requirements.md for use cases/user stories
- Check: api_spec.md for endpoint flows
<!-- QUESTION_END: 29 -->

---

<!-- QUESTION_START: 30 -->
### Question 30: What concepts apply across the system?

**Expected Answer:** Crosscutting concepts for Security (Auth, Authorization, Encryption), Error Handling, Configuration Management, Data Access Pattern
**Target Section:** ## 7. Crosscutting Concepts

**Validation Heuristics:**
- Has subsections 7.1 (Security), 7.2 (Error Handling), 7.3 (Configuration), 7.4 (Data Access)
- Each subsection > 50 words
- References specific libraries/patterns

**Auto-Discovery:**
- Check: package.json -> "dependencies" for auth libraries (passport, jsonwebtoken, bcrypt)
- Check: .env.example for configuration patterns
- Check: src/models or src/repositories for data access pattern
<!-- QUESTION_END: 30 -->

---

<!-- QUESTION_START: 31 -->
### Question 31: What are the key architecture decisions and their rationale?

**Expected Answer:** List of ADRs with links to docs/reference/adrs/, critical ADRs summary (top 3-5 decisions)
**Target Section:** ## 8. Architecture Decisions (ADRs)

**Validation Heuristics:**
- Has placeholder {{ADR_LIST}} or actual ADR links
- Has "Critical ADRs Summary" subsection
- Links to docs/reference/adrs/ directory

**Auto-Discovery:**
- Scan: docs/reference/adrs/ for *.md files
- Read: ADR titles from filenames or file headers
<!-- QUESTION_END: 31 -->

---

<!-- QUESTION_START: 32 -->
### Question 32: What are the quality scenarios and metrics?

**Expected Answer:** Quality tree (ISO 25010 hierarchy), quality scenarios table with testable criteria (QS-1, QS-2, ...)
**Target Section:** ## 9. Quality Requirements

**Validation Heuristics:**
- Has subsections 9.1 (Quality Tree), 9.2 (Quality Scenarios)
- Quality scenarios have testable criteria
- References ISO 25010 quality model

**Auto-Discovery:**
- Check: architecture.md -> Section 1.2 Quality Goals

**MCP Ref Hints:**
- Research: "ISO 25010 quality scenarios"
<!-- QUESTION_END: 32 -->

---

<!-- QUESTION_START: 33 -->
### Question 33: What are the known risks and technical debt?

**Expected Answer:** Technical risks list with likelihood/impact, technical debt table (item, impact, plan, timeline), mitigation strategies
**Target Section:** ## 10. Risks and Technical Debt

**Validation Heuristics:**
- Has subsections 10.1 (Risks), 10.2 (Technical Debt), 10.3 (Mitigation)
- Technical debt table has timeline
- Risks have likelihood and impact ratings

**Auto-Discovery:**
- Check: package.json -> "dependencies" for outdated/EOL versions
- Scan: codebase for TODO/FIXME comments
<!-- QUESTION_END: 33 -->

---

<!-- QUESTION_START: 34 -->
### Question 34: What domain terms need definition?

**Expected Answer:** Table of terms and definitions, standard C4/architecture terms (Container, Component, SSR, RBAC, JWT)
**Target Section:** ## 11. Glossary

**Validation Heuristics:**
- Has table with Term | Definition columns
- Contains standard C4/architecture terms
- Includes project-specific domain terms

**Auto-Discovery:**
- Scan: all docs for domain-specific terms (business terminology)
- Extract: technical acronyms from code (API, SSR, RBAC, JWT)
<!-- QUESTION_END: 34 -->

<!-- DOCUMENT_END: docs/project/architecture.md -->

---

<!-- DOCUMENT_START: docs/project/tech_stack.md -->
## docs/project/tech_stack.md

**File:** docs/project/tech_stack.md (technology stack with versions and rationale)
**Target Sections:** Frontend Technologies, Backend Technologies, Database, Additional Technologies

**Rules for this document:**
- Technology table with Name, Version, Rationale, ADR Link
- Docker configuration (Dockerfile + docker-compose.yml)
- Version pinning and upgrade strategy

---

<!-- QUESTION_START: 35 -->
### Question 35: What frontend technologies are used and why?

**Expected Answer:** Framework name (React, Vue, Angular), version, rationale (team expertise, performance, ecosystem), key libraries
**Target Section:** ## Frontend Technologies

**Validation Heuristics:**
- Mentions framework name (React, Vue, Angular, Svelte)
- Has version number
- Has "Rationale" or "Why" explanation
- Lists key libraries (state management, routing, UI)

**Auto-Discovery:**
- Check: package.json -> "dependencies" for frontend frameworks (react, vue, @angular/core, svelte)
- Extract: version numbers from package.json
<!-- QUESTION_END: 35 -->

---

<!-- QUESTION_START: 36 -->
### Question 36: What backend technologies are used and why?

**Expected Answer:** Runtime (Node.js, Python, Go, Java), framework (Express, FastAPI, Gin, Spring Boot), version, rationale
**Target Section:** ## Backend Technologies

**Validation Heuristics:**
- Mentions runtime + framework
- Has version numbers
- Has rationale explanation

**Auto-Discovery:**
- Check: package.json -> "dependencies" (express, fastify, koa, nestjs)
- Check: requirements.txt, pyproject.toml (fastapi, django, flask)
- Check: go.mod (gin, echo, fiber)
<!-- QUESTION_END: 36 -->

---

<!-- QUESTION_START: 37 -->
### Question 37: What database technologies are used and why?

**Expected Answer:** Database type (PostgreSQL, MongoDB, MySQL), version, rationale (ACID, JSON support, scalability)
**Target Section:** ## Database

**Validation Heuristics:**
- Mentions database name
- Has version number
- Has rationale (ACID, performance, features)

**Auto-Discovery:**
- Check: package.json -> "dependencies" (pg, mongoose, mysql2, sqlite3)
- Check: docker-compose.yml for database services (postgres, mongo, mysql, redis)
<!-- QUESTION_END: 37 -->

---

<!-- QUESTION_START: 38 -->
### Question 38: What other key technologies are used?

**Expected Answer:** Caching (Redis, Memcached), message queue (RabbitMQ, Kafka), search (Elasticsearch, Algolia), file storage (S3, local)
**Target Section:** ## Additional Technologies

**Validation Heuristics:**
- Lists categories with technologies
- Each technology has version and rationale

**Auto-Discovery:**
- Check: package.json -> "dependencies" for all libraries (redis, ioredis, amqplib, kafkajs)
- Check: docker-compose.yml for additional services
<!-- QUESTION_END: 38 -->

<!-- DOCUMENT_END: docs/project/tech_stack.md -->

---

<!-- DOCUMENT_START: docs/project/api_spec.md -->
## docs/project/api_spec.md

**File:** docs/project/api_spec.md (API specification - Backend/Full-stack only)
**Target Sections:** API Overview, Endpoints

**Rules for this document:**
- OpenAPI 3.0 compatible format
- RESTful/GraphQL/gRPC patterns
- Authentication and error codes documented

**Note:** This document is conditional - only validate for Backend/Full-stack projects

---

<!-- QUESTION_START: 39 -->
### Question 39: What is the API architecture and authentication?

**Expected Answer:** API type (RESTful, GraphQL, gRPC), base URL, versioning strategy (URL/header), authentication (JWT, OAuth2, API keys)
**Target Section:** ## API Overview

**Validation Heuristics:**
- Mentions API type (REST, GraphQL, gRPC)
- Has base URL or pattern
- Describes auth method (JWT, OAuth2, API keys)
- Explains versioning strategy

**Auto-Discovery:**
- Check: package.json -> "dependencies" (express, @apollo/server, @grpc/grpc-js)
- Scan: src/routes/ or src/controllers/ for endpoint patterns
- Check: .env.example for API_BASE_URL, JWT_SECRET

**MCP Ref Hints:**
- Research: "REST API design best practices"
<!-- QUESTION_END: 39 -->

---

<!-- QUESTION_START: 40 -->
### Question 40: What are the available API endpoints?

**Expected Answer:** Table of endpoints (Method, Path, Description), request/response examples, error codes
**Target Section:** ## Endpoints

**Validation Heuristics:**
- Has endpoint table with Method | Path | Description
- Has request/response examples
- Documents error codes (400, 401, 403, 404, 500)

**Auto-Discovery:**
- Scan: src/routes/*.js, src/routes/*.ts for route definitions
- Check: OpenAPI/Swagger spec file if exists (openapi.yaml, swagger.json)
<!-- QUESTION_END: 40 -->

<!-- DOCUMENT_END: docs/project/api_spec.md -->

---

<!-- DOCUMENT_START: docs/project/database_schema.md -->
## docs/project/database_schema.md

**File:** docs/project/database_schema.md (database schema - conditional)
**Target Sections:** Schema Overview, Tables/Collections

**Rules for this document:**
- ER diagrams in Mermaid syntax
- Data dictionary with all tables/collections
- Relationships and constraints documented

**Note:** This document is conditional - only validate if database detected in dependencies

---

<!-- QUESTION_START: 41 -->
### Question 41: What is the database structure?

**Expected Answer:** Database type (SQL/NoSQL), schema diagram (Mermaid ERD), table/collection list
**Target Section:** ## Schema Overview

**Validation Heuristics:**
- Has Mermaid ERD diagram
- Lists all tables/collections
- Shows relationships between tables

**Auto-Discovery:**
- Check: migrations/ or schema/ directory for table definitions
- Check: src/models/ for entity definitions (Sequelize, TypeORM, Prisma, Mongoose)
- Scan: migration files for CREATE TABLE statements
<!-- QUESTION_END: 41 -->

---

<!-- QUESTION_START: 42 -->
### Question 42: What are the table structures and relationships?

**Expected Answer:** For each table: columns, types, constraints, relationships (foreign keys, references)
**Target Section:** ## Tables/Collections

**Validation Heuristics:**
- Has table definitions with columns and types
- Describes relationships (1:1, 1:N, N:M)
- Documents constraints (PRIMARY KEY, FOREIGN KEY, UNIQUE, NOT NULL)

**Auto-Discovery:**
- Read: migration files for detailed column definitions
- Read: model files (models/*.js, models/*.ts) for schema definitions
<!-- QUESTION_END: 42 -->

<!-- DOCUMENT_END: docs/project/database_schema.md -->

---

<!-- DOCUMENT_START: docs/project/design_guidelines.md -->
## docs/project/design_guidelines.md

**File:** docs/project/design_guidelines.md (UI/UX design system - Frontend only)
**Target Sections:** Design System, Typography, Colors

**Rules for this document:**
- WCAG 2.1 Level AA compliant
- Design system or component library documented
- Accessibility guidelines included

**Note:** This document is conditional - only validate for Frontend/Full-stack projects

---

<!-- QUESTION_START: 43 -->
### Question 43: What is the design system or component library?

**Expected Answer:** Design system name (Material-UI, Ant Design, custom), key components, customization approach
**Target Section:** ## Design System

**Validation Heuristics:**
- Mentions design system name or "custom design system"
- Lists key components (Button, Input, Card, Modal, etc.)
- Explains customization/theming approach

**Auto-Discovery:**
- Check: package.json -> "dependencies" (@mui/material, antd, chakra-ui, @headlessui/react)
- Scan: src/components/ for component library usage
<!-- QUESTION_END: 43 -->

---

<!-- QUESTION_START: 44 -->
### Question 44: What fonts and text styles are used?

**Expected Answer:** Font families (primary, secondary), font sizes (headings, body, small), font weights
**Target Section:** ## Typography

**Validation Heuristics:**
- Lists font families
- Has size/weight specifications
- Shows typography scale (h1-h6, body, small)

**Auto-Discovery:**
- Check: src/styles/ or CSS files for font definitions
- Check: package.json -> "dependencies" for font libraries (@fontsource/*, next/font)
- Check: tailwind.config.js for fontFamily settings
<!-- QUESTION_END: 44 -->

---

<!-- QUESTION_START: 45 -->
### Question 45: What is the color palette?

**Expected Answer:** Primary, secondary, accent colors (hex codes), neutral colors (grays), semantic colors (success, error, warning, info)
**Target Section:** ## Colors

**Validation Heuristics:**
- Lists colors with hex codes
- Has semantic color categories
- Shows accessibility contrast ratios

**Auto-Discovery:**
- Check: CSS variables or theme files (theme.js, theme.ts)
- Check: tailwind.config.js for color palette
- Scan: src/styles/ for color definitions
<!-- QUESTION_END: 45 -->

<!-- DOCUMENT_END: docs/project/design_guidelines.md -->

---

<!-- DOCUMENT_START: docs/project/runbook.md -->
## docs/project/runbook.md

**File:** docs/project/runbook.md (operations guide)
**Target Sections:** Local Development Setup, Deployment, Troubleshooting

**Rules for this document:**
- Step-by-step setup instructions
- Environment variables documented
- Common issues and solutions

---

<!-- QUESTION_START: 46 -->
### Question 46: How do I set up the project locally?

**Expected Answer:** Prerequisites (Node.js version, Docker, etc.), installation steps (npm install, env setup), run commands (npm start, docker-compose up)
**Target Section:** ## Local Development Setup

**Validation Heuristics:**
- Lists prerequisites with versions
- Has numbered installation steps
- Has run commands for development

**Auto-Discovery:**
- Check: package.json -> "engines" for version requirements (node, npm)
- Check: package.json -> "scripts" for run commands (dev, start, build)
- Check: README.md for setup instructions
- Check: Dockerfile for runtime requirements
<!-- QUESTION_END: 46 -->

---

<!-- QUESTION_START: 47 -->
### Question 47: How is the application deployed?

**Expected Answer:** Deployment target (AWS, Vercel, Heroku, Docker), build commands, environment variables, deployment steps
**Target Section:** ## Deployment

**Validation Heuristics:**
- Mentions deployment platform
- Has build commands
- Lists required env vars
- Shows deployment steps or CI/CD pipeline

**Auto-Discovery:**
- Check: package.json -> "scripts" -> "build"
- Check: .env.example for required env vars
- Check: Dockerfile, vercel.json, .platform.app.yaml for deployment config
- Check: .github/workflows/ for CI/CD
<!-- QUESTION_END: 47 -->

---

<!-- QUESTION_START: 48 -->
### Question 48: How do I troubleshoot common issues?

**Expected Answer:** Common errors with solutions, debugging techniques, log locations
**Target Section:** ## Troubleshooting

**Validation Heuristics:**
- Lists common errors and solutions
- Mentions debugging techniques
- Shows log locations or commands

**Auto-Discovery:**
- Check: package.json -> "dependencies" for logging libraries (winston, pino, bunyan)
- Scan: README.md for troubleshooting section
<!-- QUESTION_END: 48 -->

<!-- DOCUMENT_END: docs/project/runbook.md -->

---

**Overall Validation Rules:**
- All 11 documents exist (4 root + 3 always required project + 4 conditional project)
- Each document has SCOPE tags
- Each document has Maintenance section
- Total questions: 48 (22 root + 26 project, question numbers renumbered for unified document)

---

**Version:** 1.0.0
**Last Updated:** 2025-12-18
