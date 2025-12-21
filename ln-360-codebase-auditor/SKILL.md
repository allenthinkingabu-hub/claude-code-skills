---
name: ln-360-codebase-auditor
description: Coordinates 9 specialized audit workers (security, build, architecture, code quality, dependencies, dead code, observability, concurrency, lifecycle). Researches best practices, delegates parallel audits, aggregates results into single Linear task in Epic 0.
allowed-tools: Read, Grep, Glob, Bash, WebFetch, WebSearch, mcp__Ref, mcp__context7, mcp__linear-server, Skill
---

# Codebase Auditor (L2 Coordinator)

Coordinates 9 specialized audit workers to perform comprehensive codebase quality analysis.

## Purpose & Scope

- **Coordinates 9 audit workers** (ln-361 through ln-369) running in parallel
- Research current best practices for detected tech stack via MCP tools ONCE
- Pass shared context to all workers (token-efficient)
- Aggregate worker results into single consolidated report
- Create single refactoring task in Linear under Epic 0 with all findings
- Manual invocation by user; not part of Story pipeline

## Workflow

1) **Discovery:** Load tech_stack.md, principles.md, package manifests, auto-discover Team ID
2) **Research:** Query MCP tools for current best practices per major dependency ONCE
3) **Build Context:** Create contextStore with best practices + tech stack metadata
4) **Delegate:** Invoke 9 workers IN PARALLEL (single message, 9 Skill tool calls)
5) **Aggregate:** Collect worker results, merge findings, calculate overall score
6) **Generate Report:** Build consolidated report with Executive Summary, Compliance Score, Findings
7) **Create Task:** Create Linear task in Epic 0 titled "Codebase Refactoring: [YYYY-MM-DD]"

## Phase 1: Discovery

**Load project metadata:**
- `docs/project/tech_stack.md` - detect tech stack for research
- `docs/principles.md` - project-specific quality principles
- Package manifests: `package.json`, `requirements.txt`, `go.mod`, `Cargo.toml`
- Auto-discover Team ID from `docs/tasks/kanban_board.md`

**Extract metadata only** (not full codebase scan):
- Programming language(s)
- Major frameworks/libraries
- Database system(s)
- Build tools
- Test framework(s)

## Phase 2: Research Best Practices (ONCE)

**For each major dependency identified in Phase 1:**

1. Use `mcp__Ref__ref_search_documentation` for current best practices
2. Use `mcp__context7__get-library-docs` for up-to-date library documentation
3. Focus areas by technology type:

| Type | Research Focus |
|------|----------------|
| Web Framework | Async patterns, middleware, error handling, request lifecycle |
| ML/AI Libraries | Inference optimization, memory management, batching |
| Database | Connection pooling, transactions, query optimization |
| Containerization | Multi-stage builds, security, layer caching |
| Language Runtime | Idioms, performance patterns, memory management |

**Build contextStore:**
```json
{
  "tech_stack": {...},
  "best_practices": {...},
  "principles": {...},
  "codebase_root": "..."
}
```

## Phase 3: Delegate to Workers (PARALLEL)

**Invoke ALL 9 workers in PARALLEL** using single message with 9 Skill tool calls:

| # | Worker | Priority | Categories | What It Audits |
|---|--------|----------|------------|----------------|
| 1 | ln-361-security-auditor | CRITICAL | Security | Hardcoded secrets, SQL injection, XSS, insecure deps, input validation |
| 2 | ln-362-build-auditor | CRITICAL | Build Health | Compiler/linter errors, deprecations, type errors, failed tests |
| 3 | ln-363-architecture-auditor | HIGH | Architecture + Design | DRY/KISS/YAGNI violations, layer breaks, TODO/FIXME, workarounds, error handling |
| 4 | ln-364-code-quality-auditor | MEDIUM | Complexity + Algorithms + Constants | Cyclomatic complexity, nesting, O(n²), N+1 queries, magic numbers, decentralized constants |
| 5 | ln-365-dependencies-auditor | MEDIUM | Dependencies + Wheel Reinvention | Outdated packages, unused deps, custom implementations, reimplemented algorithms |
| 6 | ln-366-dead-code-auditor | LOW | Unused Code | Dead code, unused imports/variables, commented-out code |
| 7 | ln-367-observability-auditor | MEDIUM | Observability | Structured logging, health checks, metrics, tracing, log levels |
| 8 | ln-368-concurrency-auditor | HIGH | Concurrency | Race conditions, async/await, resource contention, thread safety, deadlocks |
| 9 | ln-369-lifecycle-auditor | MEDIUM | Entry Points & Lifecycle | Bootstrap, graceful shutdown, resource cleanup, signal handling, probes |

**Worker invocation:**
```javascript
FOR EACH worker IN [ln-361, ln-362, ..., ln-369]:
  Skill(skill=worker, args=JSON.stringify(contextStore))
  // All 9 workers run concurrently
```

## Phase 4: Aggregate Results

**Collect results from each worker:**
Each worker returns:
```json
{
  "category": "Security",
  "score": 7,
  "total_issues": 5,
  "critical": 1,
  "high": 2,
  "medium": 2,
  "low": 0,
  "findings": [
    {
      "severity": "CRITICAL",
      "location": "src/api/auth.ts:45",
      "issue": "Hardcoded API key in source code",
      "principle": "Secrets Management (OWASP A02:2021)",
      "recommendation": "Move to environment variable (.env), use secrets manager",
      "effort": "S"
    }
  ]
}
```

**Aggregate:**
1. Merge all findings arrays → single findings list
2. Calculate overall score → average of 9 category scores
3. Build severity summary → sum critical/high/medium/low across all workers
4. Generate Executive Summary → analyze overall health, major risks, strengths
5. Build Compliance Score table → one row per worker category
6. Build Findings by Category tables → group by category, include Principle Violated column
7. Build Recommended Actions table → sort by priority, include Principle Violated column

## Output Format

```markdown
## Codebase Audit Report - [DATE]

### Executive Summary
[2-3 sentences on overall codebase health, major risks, and key strengths]

### Compliance Score

| Category | Score | Notes |
|----------|-------|-------|
| Security | X/10 | ... |
| Build Health | X/10 | ... |
| Architecture & Design | X/10 | ... |
| Code Quality | X/10 | ... |
| Dependencies & Reuse | X/10 | ... |
| Dead Code | X/10 | ... |
| Observability | X/10 | ... |
| Concurrency | X/10 | ... |
| Lifecycle | X/10 | ... |
| **Overall** | **X/10** | |

### Severity Summary

| Severity | Count |
|----------|-------|
| Critical | X |
| High | X |
| Medium | X |
| Low | X |

### Strengths
- [What's done well in this codebase]
- [Good patterns and practices identified]

### Findings by Category

#### 1. Security

| Severity | Location | Issue | Principle Violated | Recommendation | Effort |
|----------|----------|-------|-------------------|----------------|--------|
| CRITICAL | src/api/auth.ts:45 | Hardcoded API key in source code | Secrets Management (OWASP A02:2021) | Move to environment variable (.env), use secrets manager | S |
| HIGH | src/api/queries.ts:112 | SQL injection vulnerability (string concatenation) | Input Validation (OWASP A03:2021) | Use parameterized queries or ORM | M |

#### 2. Build Health

| Severity | Location | Issue | Principle Violated | Recommendation | Effort |
|----------|----------|-------|-------------------|----------------|--------|
| CRITICAL | Multiple files (3 errors) | TypeScript strict mode errors | Type Safety | Fix type annotations, add proper types | S |
| HIGH | package.json | 5 deprecated dependencies | Dependency Health | Update to non-deprecated versions | M |

#### 3. Architecture & Design

| Severity | Location | Issue | Principle Violated | Recommendation | Effort |
|----------|----------|-------|-------------------|----------------|--------|
| CRITICAL | src/controllers/UserController.ts:12 | Controller directly uses Repository (bypass Service) | Layer Separation (Clean Architecture) | Create UserService, inject into controller | L |
| HIGH | src/middleware/error.ts:5-20 | Error handling not centralized | Single Responsibility Principle | Create ErrorHandler class, delegate from middleware | M |

... (continue for all 9 categories)

### Recommended Actions (Priority-Sorted)

| Priority | Category | Location | Issue | Principle Violated | Recommendation | Effort |
|----------|----------|----------|-------|-------------------|----------------|--------|
| CRITICAL | Security | src/api/auth.ts:45 | Hardcoded API key | Secrets Management | Move to .env, use secrets manager | S |
| CRITICAL | Build | Multiple files | TypeScript strict errors | Type Safety | Fix type annotations | S |
| CRITICAL | Architecture | UserController.ts:12 | Controller→Repository bypass | Layer Separation | Add Service layer | L |
| HIGH | Security | queries.ts:112 | SQL injection risk | Input Validation | Use parameterized queries | M |
| HIGH | Architecture | error.ts:5-20 | Decentralized error handling | Single Responsibility | Create ErrorHandler class | M |

### Priority Actions
1. Fix all Critical issues before next release
2. Address High issues within current sprint
3. Plan Medium issues for technical debt sprint
4. Track Low issues in backlog

### Sources Consulted
- [Framework] best practices: [URL from MCP Ref]
- [Library] documentation: [URL from Context7]
```

## Phase 5: Create Linear Task

Create task in Epic 0:
- Title: `Codebase Refactoring: [YYYY-MM-DD]`
- Description: Full report from Phase 4 (markdown format)
- Team: Auto-discovered from kanban_board.md
- Epic: 0 (technical debt / refactoring epic)
- Labels: `refactoring`, `technical-debt`, `audit`
- Priority: Based on highest severity findings (Critical → Urgent, High → High, etc.)

## Critical Rules

- **Parallel execution:** ALL 9 workers must run in PARALLEL (single message, 9 Skill tool calls)
- **Single context gathering:** Research best practices ONCE, pass contextStore to all workers
- **Metadata-only loading:** Coordinator loads metadata only; workers load full file contents
- **Language preservation:** Task description in project's language (EN/RU from kanban_board.md)
- **Single task:** Create ONE task with all findings; do not create multiple tasks
- **Do not audit:** Coordinator orchestrates only; audit logic lives in workers

## Definition of Done

- Best practices researched via MCP tools for major dependencies
- contextStore built with tech stack + best practices
- All 9 workers invoked in PARALLEL
- All 9 workers completed successfully (or reported errors)
- Results aggregated into single consolidated report
- Compliance score (X/10) calculated per category + overall
- Executive Summary and Strengths sections included
- Linear task created in Epic 0 with full report
- Sources consulted listed with URLs

## Workers

See individual worker SKILL.md files for detailed audit rules:
- [ln-361-security-auditor](../ln-361-security-auditor/SKILL.md)
- [ln-362-build-auditor](../ln-362-build-auditor/SKILL.md)
- [ln-363-architecture-auditor](../ln-363-architecture-auditor/SKILL.md)
- [ln-364-code-quality-auditor](../ln-364-code-quality-auditor/SKILL.md)
- [ln-365-dependencies-auditor](../ln-365-dependencies-auditor/SKILL.md)
- [ln-366-dead-code-auditor](../ln-366-dead-code-auditor/SKILL.md)
- [ln-367-observability-auditor](../ln-367-observability-auditor/SKILL.md)
- [ln-368-concurrency-auditor](../ln-368-concurrency-auditor/SKILL.md)
- [ln-369-lifecycle-auditor](../ln-369-lifecycle-auditor/SKILL.md)

## Reference Files

- Principles: `docs/principles.md`
- Tech stack: `docs/project/tech_stack.md`
- Kanban board: `docs/tasks/kanban_board.md`

---
**Version:** 3.0.0
**Last Updated:** 2025-12-21
