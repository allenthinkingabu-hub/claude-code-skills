# Project Documentation Questions

**Purpose:** Define what each section of project documentation should answer.

**Format:** Question → Expected Answer → Validation Heuristics → Auto-Discovery → MCP Ref Hints

---

## Table of Contents

| Document | Questions | Auto-Discovery | Priority | Line |
|----------|-----------|----------------|----------|------|
| [requirements.md](#docsprojectrequirementsmd) | 1 | Low | Critical | L30 |
| [architecture.md](#docsprojectarchitecturemd) | 11 | High | Critical | L92 |
| [tech_stack.md](#docsprojecttechstackmd) | 4 | High | High | L394 |
| [api_spec.md](#docsprojectapispecmd) | 2 | Medium | High | L495 |
| [database_schema.md](#docsprojectdatabaseschemamd) | 2 | High | High | L560 |
| [design_guidelines.md](#docsprojectdesignguidelinesmd) | 3 | Low | Medium | L625 |
| [runbook.md](#docsprojectrunbookmd) | 3 | High | Critical | L715 |

**Priority Legend:**
- **Critical:** Must answer all questions (requirements, architecture, runbook)
- **High:** Strongly recommended (tech_stack, api_spec, database_schema)
- **Medium:** Optional for some project types (design_guidelines - frontend only)

**Auto-Discovery Legend:**
- **None:** No auto-discovery needed (use template as-is)
- **Low:** 1-2 questions need auto-discovery
- **Medium:** 50% questions need auto-discovery
- **High:** Most/all questions need auto-discovery

---

<!-- DOCUMENT_START: docs/project/requirements.md -->
## docs/project/requirements.md

**File:** docs/project/requirements.md (functional requirements ONLY)
**Target Sections:** Functional Requirements

**Rules for this document:**
- ISO/IEC/IEEE 29148:2018 compliant
- FR-XXX-NNN identifiers for all requirements
- MoSCoW prioritization (MUST/SHOULD/COULD/WON'T)
- User stories or acceptance criteria format

---

<!-- QUESTION_START: 1 -->
### Question 1: What functionality must the system provide?

**Expected Answer:** Numbered list of functional requirements with FR-XXX-NNN identifiers, MoSCoW priorities, user stories/acceptance criteria
**Target Section:** ## Functional Requirements

**Validation Heuristics:**
- ✅ Has FR-XXX identifiers (e.g., FR-001, FR-USR-001)
- ✅ Has MoSCoW labels (MUST/SHOULD/COULD/WON'T)
- ✅ Length > 100 words
- ✅ Has numbered list or table

**Auto-Discovery:**
- Check: package.json → "description" for feature clues
- Check: README.md for feature mentions
- Check: existing docs for use case descriptions

**MCP Ref Hints:**
- Research: "functional requirements best practices"
- Research: "MoSCoW prioritization method"
<!-- QUESTION_END: 1 -->

<!-- DOCUMENT_END: docs/project/requirements.md -->

---

<!-- DOCUMENT_START: docs/project/architecture.md -->
## docs/project/architecture.md

**File:** docs/project/architecture.md (arc42 framework with C4 Model)
**Target Sections:** 11 sections (Introduction and Goals → Glossary)

**Rules for this document:**
- ISO/IEC/IEEE 42010:2022 compliant
- arc42 framework structure (11 sections)
- C4 Model diagrams (Context, Container, Component)
- Mermaid syntax for all diagrams

---

<!-- QUESTION_START: 3 -->
### Question 3: What are the key quality goals and stakeholders?

**Expected Answer:** Requirements overview summary, 5 quality goals with metrics (Performance, Security, Scalability, Reliability, Maintainability), stakeholders table with roles
**Target Section:** ## 1. Introduction and Goals

**Validation Heuristics:**
- ✅ Has subsections 1.1, 1.2, 1.3
- ✅ Quality goals have measurable metrics
- ✅ Stakeholders table has roles and expectations
- ✅ References requirements.md

**Auto-Discovery:**
- Check: architecture.md → Section 1.2 Quality Goals (derived from risks R1)
- Check: package.json → "author" for stakeholder hints

**MCP Ref Hints:**
- Research: "arc42 quality goals"
- Research: "ISO 25010 quality attributes"
<!-- QUESTION_END: 3 -->

---

<!-- QUESTION_START: 4 -->
### Question 4: What technical and organizational constraints exist?

**Expected Answer:** Technical constraints (languages, databases, cloud providers), organizational constraints (team size, compliance), conventions (code style, testing standards)
**Target Section:** ## 2. Constraints

**Validation Heuristics:**
- ✅ Has subsections 2.1 (Technical), 2.2 (Organizational), 2.3 (Conventions)
- ✅ Mentions specific technologies
- ✅ Lists compliance requirements (GDPR, HIPAA, etc.)

**Auto-Discovery:**
- Check: package.json → "dependencies" for tech stack
- Check: .eslintrc, .prettierrc for code style conventions
- Check: tsconfig.json, jest.config.js for conventions

**MCP Ref Hints:**
- Research: "architecture constraints examples"
<!-- QUESTION_END: 4 -->

---

<!-- QUESTION_START: 5 -->
### Question 5: What are the system boundaries and external interfaces?

**Expected Answer:** Business context (actors, external systems), technical context (protocols, data formats), C4 Context diagram (Mermaid)
**Target Section:** ## 3. Context and Scope

**Validation Heuristics:**
- ✅ Has subsections 3.1 (Business Context), 3.2 (Technical Context)
- ✅ Has Mermaid code block with C4 Context diagram
- ✅ Lists external systems and protocols

**Auto-Discovery:**
- Check: package.json → "dependencies" for external service clients (stripe, twilio, aws-sdk)
- Check: .env.example for API_URL, DATABASE_URL (external systems)

**MCP Ref Hints:**
- Research: "C4 model context diagram examples"
- Research: "system context best practices"
<!-- QUESTION_END: 5 -->

---

<!-- QUESTION_START: 6 -->
### Question 6: What are the top-level architectural decisions?

**Expected Answer:** Technology decisions table (Frontend, Backend, Database with rationale and ADR links), top-level decomposition approach (Layered/Microservices/Modular), approach to quality goals
**Target Section:** ## 4. Solution Strategy

**Validation Heuristics:**
- ✅ Has subsections 4.1 (Technology Decisions), 4.2 (Top-level Decomposition), 4.3 (Quality Goals Approach)
- ✅ Technology table references ADRs
- ✅ Explains architecture pattern choice

**Auto-Discovery:**
- Check: package.json → "dependencies" for frontend/backend frameworks
- Check: src/ directory structure:
  - controllers/, services/, repositories/ → Layered architecture
  - modules/, features/ → Modular architecture
  - pages/, components/ → Frontend structure

**MCP Ref Hints:**
- Research: "layered architecture vs microservices"
- Research: "architecture patterns comparison 2024"
<!-- QUESTION_END: 6 -->

---

<!-- QUESTION_START: 7 -->
### Question 7: How is the system decomposed into components?

**Expected Answer:** C4 diagrams (Level 1 System Context, Level 2 Container, Level 3 Component), key components table, infrastructure layer components
**Target Section:** ## 5. Building Block View

**Validation Heuristics:**
- ✅ Has subsections 5.1 (Level 1), 5.2 (Level 2), 5.3 (Level 3)
- ✅ Has 3 Mermaid C4 diagrams
- ✅ Has components table with responsibilities

**Auto-Discovery:**
- Scan: src/ directory for folders (controllers, services, repositories, components)
- Check: package.json → "main" for entry point
- Count: number of controllers, services, components

**MCP Ref Hints:**
- Research: "C4 model component diagram"
- Research: "software architecture decomposition patterns"
<!-- QUESTION_END: 7 -->

---

<!-- QUESTION_START: 8 -->
### Question 8: What are the critical runtime scenarios?

**Expected Answer:** 3-5 key scenarios with sequence diagrams (User Registration, Product Purchase, API Request Flow, etc.)
**Target Section:** ## 6. Runtime View

**Validation Heuristics:**
- ✅ Has subsections 6.1, 6.2, 6.3 (at least 3 scenarios)
- ✅ Each subsection has Mermaid sequence diagram
- ✅ Scenarios align with functional requirements

**Auto-Discovery:**
- Check: requirements.md for use cases/user stories
- Check: api_spec.md for endpoint flows

**MCP Ref Hints:**
- Research: "sequence diagram best practices"
- Research: "runtime view arc42 examples"
<!-- QUESTION_END: 8 -->

---

<!-- QUESTION_START: 9 -->
### Question 9: What concepts apply across the system?

**Expected Answer:** Crosscutting concepts for Security (Auth, Authorization, Encryption), Error Handling, Configuration Management, Data Access Pattern
**Target Section:** ## 7. Crosscutting Concepts

**Validation Heuristics:**
- ✅ Has subsections 7.1 (Security), 7.2 (Error Handling), 7.3 (Configuration), 7.4 (Data Access)
- ✅ Each subsection > 50 words
- ✅ References specific libraries/patterns

**Auto-Discovery:**
- Check: package.json → "dependencies" for auth libraries (passport, jsonwebtoken, bcrypt)
- Check: .env.example for configuration patterns
- Check: src/models or src/repositories for data access pattern

**MCP Ref Hints:**
- Research: "security architecture best practices"
- Research: "repository pattern vs active record"
- Research: "error handling patterns Node.js/Python/Go"
<!-- QUESTION_END: 9 -->

---

<!-- QUESTION_START: 10 -->
### Question 10: What are the key architecture decisions and their rationale?

**Expected Answer:** List of ADRs with links to docs/reference/adrs/, critical ADRs summary (top 3-5 decisions)
**Target Section:** ## 8. Architecture Decisions (ADRs)

**Validation Heuristics:**
- ✅ Has placeholder {{ADR_LIST}} or actual ADR links
- ✅ Has "Critical ADRs Summary" subsection
- ✅ Links to docs/reference/adrs/ directory

**Auto-Discovery:**
- Scan: docs/reference/adrs/ for *.md files
- Read: ADR titles from filenames or file headers

**MCP Ref Hints:**
- N/A (ADRs are project-specific)
<!-- QUESTION_END: 10 -->

---

<!-- QUESTION_START: 11 -->
### Question 11: What are the quality scenarios and metrics?

**Expected Answer:** Quality tree (ISO 25010 hierarchy), quality scenarios table with testable criteria (QS-1, QS-2, ...)
**Target Section:** ## 9. Quality Requirements

**Validation Heuristics:**
- ✅ Has subsections 9.1 (Quality Tree), 9.2 (Quality Scenarios)
- ✅ Quality scenarios have testable criteria
- ✅ References ISO 25010 quality model

**Auto-Discovery:**
- Check: architecture.md → Section 1.2 Quality Goals

**MCP Ref Hints:**
- Research: "ISO 25010 quality scenarios"
- Research: "quality attribute workshop methods"
<!-- QUESTION_END: 11 -->

---

<!-- QUESTION_START: 12 -->
### Question 12: What are the known risks and technical debt?

**Expected Answer:** Technical risks list with likelihood/impact, technical debt table (item, impact, plan, timeline), mitigation strategies
**Target Section:** ## 10. Risks and Technical Debt

**Validation Heuristics:**
- ✅ Has subsections 10.1 (Risks), 10.2 (Technical Debt), 10.3 (Mitigation)
- ✅ Technical debt table has timeline
- ✅ Risks have likelihood and impact ratings

**Auto-Discovery:**
- Check: package.json → "dependencies" for outdated/EOL versions (npm outdated)
- Scan: codebase for TODO/FIXME comments
- Check: .github/dependabot.yml for security alerts

**MCP Ref Hints:**
- Research: "technical debt management best practices"
- Research: "architecture risk assessment methods"
<!-- QUESTION_END: 12 -->

---

<!-- QUESTION_START: 13 -->
### Question 13: What domain terms need definition?

**Expected Answer:** Table of terms and definitions, standard C4/architecture terms (Container, Component, SSR, RBAC, JWT)
**Target Section:** ## 11. Glossary

**Validation Heuristics:**
- ✅ Has table with Term | Definition columns
- ✅ Contains standard C4/architecture terms
- ✅ Includes project-specific domain terms

**Auto-Discovery:**
- Scan: all docs for domain-specific terms (business terminology)
- Extract: technical acronyms from code (API, SSR, RBAC, JWT)

**MCP Ref Hints:**
- Research: "C4 model glossary standard terms"
<!-- QUESTION_END: 13 -->

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

<!-- QUESTION_START: 14 -->
### Question 14: What frontend technologies are used and why?

**Expected Answer:** Framework name (React, Vue, Angular), version, rationale (team expertise, performance, ecosystem), key libraries
**Target Section:** ## Frontend Technologies

**Validation Heuristics:**
- ✅ Mentions framework name (React, Vue, Angular, Svelte)
- ✅ Has version number
- ✅ Has "Rationale" or "Why" explanation
- ✅ Lists key libraries (state management, routing, UI)

**Auto-Discovery:**
- Check: package.json → "dependencies" for frontend frameworks (react, vue, @angular/core, svelte)
- Extract: version numbers from package.json
- Check: package.json → react-router-dom, redux, vuex, pinia, @ngrx/store

**MCP Ref Hints:**
- Research: "[framework] latest version features 2024"
- Research: "[framework] best practices"
<!-- QUESTION_END: 14 -->

---

<!-- QUESTION_START: 15 -->
### Question 15: What backend technologies are used and why?

**Expected Answer:** Runtime (Node.js, Python, Go, Java), framework (Express, FastAPI, Gin, Spring Boot), version, rationale
**Target Section:** ## Backend Technologies

**Validation Heuristics:**
- ✅ Mentions runtime + framework
- ✅ Has version numbers
- ✅ Has rationale explanation

**Auto-Discovery:**
- Check: package.json → "dependencies" (express, fastify, koa, nestjs)
- Check: requirements.txt, pyproject.toml (fastapi, django, flask)
- Check: go.mod (gin, echo, fiber)
- Check: pom.xml, build.gradle (spring-boot)

**MCP Ref Hints:**
- Research: "[runtime] [framework] performance comparison 2024"
<!-- QUESTION_END: 15 -->

---

<!-- QUESTION_START: 16 -->
### Question 16: What database technologies are used and why?

**Expected Answer:** Database type (PostgreSQL, MongoDB, MySQL), version, rationale (ACID, JSON support, scalability)
**Target Section:** ## Database

**Validation Heuristics:**
- ✅ Mentions database name
- ✅ Has version number
- ✅ Has rationale (ACID, performance, features)

**Auto-Discovery:**
- Check: package.json → "dependencies" (pg, mongoose, mysql2, sqlite3)
- Check: docker-compose.yml for database services (postgres, mongo, mysql, redis)
- Check: requirements.txt (psycopg2, pymongo, mysql-connector)

**MCP Ref Hints:**
- Research: "[database] version features"
- Research: "PostgreSQL vs MongoDB comparison"
<!-- QUESTION_END: 16 -->

---

<!-- QUESTION_START: 17 -->
### Question 17: What other key technologies are used?

**Expected Answer:** Caching (Redis, Memcached), message queue (RabbitMQ, Kafka), search (Elasticsearch, Algolia), file storage (S3, local)
**Target Section:** ## Additional Technologies

**Validation Heuristics:**
- ✅ Lists categories with technologies
- ✅ Each technology has version and rationale

**Auto-Discovery:**
- Check: package.json → "dependencies" for all libraries (redis, ioredis, amqplib, kafkajs, @elastic/elasticsearch)
- Check: docker-compose.yml for additional services (redis, rabbitmq, elasticsearch)

**MCP Ref Hints:**
- Research: "redis vs memcached comparison"
- Research: "rabbitmq vs kafka use cases"
<!-- QUESTION_END: 17 -->

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

<!-- QUESTION_START: 18 -->
### Question 18: What is the API architecture and authentication?

**Expected Answer:** API type (RESTful, GraphQL, gRPC), base URL, versioning strategy (URL/header), authentication (JWT, OAuth2, API keys)
**Target Section:** ## API Overview

**Validation Heuristics:**
- ✅ Mentions API type (REST, GraphQL, gRPC)
- ✅ Has base URL or pattern
- ✅ Describes auth method (JWT, OAuth2, API keys)
- ✅ Explains versioning strategy

**Auto-Discovery:**
- Check: package.json → "dependencies" (express, @apollo/server, @grpc/grpc-js)
- Scan: src/routes/ or src/controllers/ for endpoint patterns
- Check: .env.example for API_BASE_URL, JWT_SECRET

**MCP Ref Hints:**
- Research: "REST API design best practices"
- Research: "API authentication methods comparison"
<!-- QUESTION_END: 18 -->

---

<!-- QUESTION_START: 19 -->
### Question 19: What are the available API endpoints?

**Expected Answer:** Table of endpoints (Method, Path, Description), request/response examples, error codes
**Target Section:** ## Endpoints

**Validation Heuristics:**
- ✅ Has endpoint table with Method | Path | Description
- ✅ Has request/response examples
- ✅ Documents error codes (400, 401, 403, 404, 500)

**Auto-Discovery:**
- Scan: src/routes/*.js, src/routes/*.ts for route definitions
- Check: OpenAPI/Swagger spec file if exists (openapi.yaml, swagger.json)
- Extract: HTTP methods (GET, POST, PUT, DELETE, PATCH)

**MCP Ref Hints:**
- Research: "OpenAPI specification examples"
- Research: "REST API endpoint documentation"
<!-- QUESTION_END: 19 -->

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

<!-- QUESTION_START: 20 -->
### Question 20: What is the database structure?

**Expected Answer:** Database type (SQL/NoSQL), schema diagram (Mermaid ERD), table/collection list
**Target Section:** ## Schema Overview

**Validation Heuristics:**
- ✅ Has Mermaid ERD diagram
- ✅ Lists all tables/collections
- ✅ Shows relationships between tables

**Auto-Discovery:**
- Check: migrations/ or schema/ directory for table definitions
- Check: src/models/ for entity definitions (Sequelize, TypeORM, Prisma, Mongoose)
- Scan: migration files for CREATE TABLE statements

**MCP Ref Hints:**
- Research: "database ERD diagram examples"
- Research: "database schema best practices"
<!-- QUESTION_END: 20 -->

---

<!-- QUESTION_START: 21 -->
### Question 21: What are the table structures and relationships?

**Expected Answer:** For each table: columns, types, constraints, relationships (foreign keys, references)
**Target Section:** ## Tables/Collections

**Validation Heuristics:**
- ✅ Has table definitions with columns and types
- ✅ Describes relationships (1:1, 1:N, N:M)
- ✅ Documents constraints (PRIMARY KEY, FOREIGN KEY, UNIQUE, NOT NULL)

**Auto-Discovery:**
- Read: migration files for detailed column definitions
- Read: model files (models/*.js, models/*.ts) for schema definitions
- Extract: foreign key relationships

**MCP Ref Hints:**
- Research: "database normalization best practices"
- Research: "SQL foreign key relationships"
<!-- QUESTION_END: 21 -->

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

<!-- QUESTION_START: 22 -->
### Question 22: What is the design system or component library?

**Expected Answer:** Design system name (Material-UI, Ant Design, custom), key components, customization approach
**Target Section:** ## Design System

**Validation Heuristics:**
- ✅ Mentions design system name or "custom design system"
- ✅ Lists key components (Button, Input, Card, Modal, etc.)
- ✅ Explains customization/theming approach

**Auto-Discovery:**
- Check: package.json → "dependencies" (@mui/material, antd, chakra-ui, @headlessui/react)
- Scan: src/components/ for component library usage

**MCP Ref Hints:**
- Research: "[design system] customization guide"
- Research: "design system best practices 2024"
<!-- QUESTION_END: 22 -->

---

<!-- QUESTION_START: 23 -->
### Question 23: What fonts and text styles are used?

**Expected Answer:** Font families (primary, secondary), font sizes (headings, body, small), font weights
**Target Section:** ## Typography

**Validation Heuristics:**
- ✅ Lists font families
- ✅ Has size/weight specifications
- ✅ Shows typography scale (h1-h6, body, small)

**Auto-Discovery:**
- Check: src/styles/ or CSS files for font definitions
- Check: package.json → "dependencies" for font libraries (@fontsource/*, next/font)
- Check: tailwind.config.js for fontFamily settings

**MCP Ref Hints:**
- Research: "typography scale best practices"
- Research: "web font pairing guide"
<!-- QUESTION_END: 23 -->

---

<!-- QUESTION_START: 24 -->
### Question 24: What is the color palette?

**Expected Answer:** Primary, secondary, accent colors (hex codes), neutral colors (grays), semantic colors (success, error, warning, info)
**Target Section:** ## Colors

**Validation Heuristics:**
- ✅ Lists colors with hex codes
- ✅ Has semantic color categories
- ✅ Shows accessibility contrast ratios

**Auto-Discovery:**
- Check: CSS variables or theme files (theme.js, theme.ts)
- Check: tailwind.config.js for color palette
- Scan: src/styles/ for color definitions

**MCP Ref Hints:**
- Research: "accessible color palette design"
- Research: "WCAG color contrast requirements"
<!-- QUESTION_END: 24 -->

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

<!-- QUESTION_START: 25 -->
### Question 25: How do I set up the project locally?

**Expected Answer:** Prerequisites (Node.js version, Docker, etc.), installation steps (npm install, env setup), run commands (npm start, docker-compose up)
**Target Section:** ## Local Development Setup

**Validation Heuristics:**
- ✅ Lists prerequisites with versions
- ✅ Has numbered installation steps
- ✅ Has run commands for development

**Auto-Discovery:**
- Check: package.json → "engines" for version requirements (node, npm)
- Check: package.json → "scripts" for run commands (dev, start, build)
- Check: README.md for setup instructions
- Check: Dockerfile for runtime requirements

**MCP Ref Hints:**
- N/A (project-specific setup)
<!-- QUESTION_END: 25 -->

---

<!-- QUESTION_START: 26 -->
### Question 26: How is the application deployed?

**Expected Answer:** Deployment target (AWS, Vercel, Heroku, Docker), build commands, environment variables, deployment steps
**Target Section:** ## Deployment

**Validation Heuristics:**
- ✅ Mentions deployment platform
- ✅ Has build commands
- ✅ Lists required env vars
- ✅ Shows deployment steps or CI/CD pipeline

**Auto-Discovery:**
- Check: package.json → "scripts" → "build"
- Check: .env.example for required env vars
- Check: Dockerfile, vercel.json, .platform.app.yaml for deployment config
- Check: .github/workflows/ for CI/CD

**MCP Ref Hints:**
- Research: "[platform] deployment best practices"
- Research: "CI/CD pipeline setup for [platform]"
<!-- QUESTION_END: 26 -->

---

<!-- QUESTION_START: 27 -->
### Question 27: How do I troubleshoot common issues?

**Expected Answer:** Common errors with solutions, debugging techniques, log locations
**Target Section:** ## Troubleshooting

**Validation Heuristics:**
- ✅ Lists common errors and solutions
- ✅ Mentions debugging techniques
- ✅ Shows log locations or commands

**Auto-Discovery:**
- Check: package.json → "dependencies" for logging libraries (winston, pino, bunyan)
- Scan: README.md for troubleshooting section
- Check: .gitignore for log file patterns (*.log, logs/)

**MCP Ref Hints:**
- Research: "[framework] common issues troubleshooting"
- Research: "debugging best practices for [runtime]"
<!-- QUESTION_END: 27 -->

<!-- DOCUMENT_END: docs/project/runbook.md -->

---

**Overall Validation Rules:**
- ✅ All 7 documents exist (3 always required + 4 conditional)
- ✅ Each document has SCOPE tags
- ✅ Each document has Maintenance section
- ✅ Total questions answered: 27/27 for full-stack projects, 22/27 for backend-only, 24/27 for frontend-only

---

**Version:** 1.0.0
**Last Updated:** 2025-11-18