---
name: ln-360-codebase-auditor
description: Codebase-level quality audit across 12 categories with best practices research. Creates refactoring task in Linear Epic 0.
allowed-tools: Read, Grep, Glob, Bash, WebFetch, WebSearch, mcp__Ref, mcp__context7, mcp__linear-server
---

# Codebase Auditor

Full codebase quality audit that identifies technical debt and creates a consolidated refactoring task.

## Purpose & Scope
- Audit entire codebase against 12 quality categories (security, architecture, complexity, observability, etc.).
- Research current best practices for detected tech stack via MCP tools.
- Collect issues with severity, location, effort estimate, and recommendations.
- Calculate compliance score (X/10) per category.
- Create single refactoring task in Linear under Epic 0 with all findings.
- Manual invocation by user; not part of Story pipeline.

## Workflow
1) **Discovery:** Load tech_stack.md, principles.md, package manifests (package.json/requirements.txt/go.mod).
2) **Research:** Query MCP tools for current best practices per major dependency.
3) **Static Analysis:** Run 12 audit categories in priority order (see below).
4) **Collect Issues:** Record each finding with severity, location, effort estimate (S/M/L), recommendation.
5) **Score:** Calculate compliance score per category (X/10).
6) **Generate Report:** Include Executive Summary, Strengths, Findings by category, Recommended Actions.
7) **Create Task:** Create Linear task in Epic 0 titled "Codebase Refactoring: [YYYY-MM-DD]" with full report.

## Phase 2: Research Best Practices

**For each major dependency identified in Phase 1:**

1. Use `mcp__Ref__ref_search_documentation` for current best practices
2. Use `mcp__context7__get-library-docs` for up-to-date library documentation
3. Focus areas by technology type:

| Type | Research Focus |
|------|----------------|
| **Web Framework** | Async patterns, middleware, error handling, request lifecycle |
| **ML/AI Libraries** | Inference optimization, memory management, batching |
| **Database** | Connection pooling, transactions, query optimization |
| **Containerization** | Multi-stage builds, security, layer caching |
| **Language Runtime** | Idioms, performance patterns, memory management |

## Audit Categories (priority order)

### 1. Security (Critical)
- Hardcoded secrets (API keys, passwords, tokens in code)
- SQL injection patterns (string concatenation in queries)
- XSS vulnerabilities (unsanitized user input in output)
- Insecure dependencies (known CVEs)
- Missing input validation at boundaries

### 2. Build Health (Critical)
- Compiler/linter errors
- Deprecation warnings
- Type errors (TypeScript strict, mypy, etc.)
- Failed or skipped tests

### 3. Architecture Principles (High)
- DRY violations (duplicated logic/constants across files)
- KISS violations (over-engineered abstractions)
- YAGNI violations (unused extensibility points, dead feature flags)
- Layer boundary breaks (UI calling DB directly, etc.)

### 4. Design Issues (High)
- TODO/FIXME/HACK/XXX comments indicating unfinished work
- Workarounds with explanatory comments
- Temporary solutions marked for removal
- Missing error handling on critical paths

### 5. Code Complexity (Medium)
- Cyclomatic complexity > 10 per function
- Deep nesting (> 4 levels)
- Long methods (> 50 lines)
- God classes/modules (> 500 lines)
- Too many parameters (> 5)

### 6. Algorithms (Medium)
- O(n^2) or worse in loops over collections
- N+1 query patterns (ORM lazy loading abuse)
- Missing indexes on frequently queried fields
- Inefficient data structures for use case

### 7. Dependencies (Medium)
- Outdated packages (major versions behind)
- Unused dependencies in manifest
- Available features not used (e.g., native fetch vs axios)
- Conflicting or duplicate dependencies

### 8. Wheel Reinvention (Low)
- Custom implementations of standard library features
- Hand-rolled utilities with popular npm/pip alternatives
- Reimplemented algorithms (sorting, parsing, validation)

### 9. Unused Code (Low)
- Dead code (unreachable branches)
- Unused imports/variables/functions
- Backward compatibility shims after migration complete
- Commented-out code blocks

### 10. Observability (Medium)
- Missing structured logging (console.log vs proper logger)
- No health check endpoints (/health, /ready)
- Missing metrics collection (Prometheus, StatsD)
- No request tracing/correlation IDs
- Insufficient log levels (only errors, no debug/info)

### 11. Concurrency (High)
- Race conditions in shared state
- Missing async/await patterns (callback hell)
- Resource contention (file handles, connections)
- Thread safety violations
- Deadlock potential in lock ordering

### 12. Entry Points & Lifecycle (Medium)
- Application bootstrap issues (missing initialization order)
- Missing graceful shutdown (SIGTERM handling)
- Resource cleanup on exit (DB connections, file handles)
- Signal handling (SIGTERM, SIGINT, SIGHUP)
- Missing liveness/readiness probes for containers

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
| Architecture | X/10 | ... |
| Design | X/10 | ... |
| Complexity | X/10 | ... |
| Algorithms | X/10 | ... |
| Dependencies | X/10 | ... |
| Wheel Reinvention | X/10 | ... |
| Unused Code | X/10 | ... |
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

#### 1. Security (Critical)
- [ ] **[CRITICAL]** `src/api/auth.ts:45` - Hardcoded API key. Move to environment variable. **Effort: S**
- [ ] **[HIGH]** `src/db/queries.ts:112` - SQL string concatenation. Use parameterized query. **Effort: M**

#### 2. Build Health
- [ ] **[CRITICAL]** 3 TypeScript errors in strict mode. Fix type annotations. **Effort: S**

... (continue for all 12 categories with findings)

### Recommended Actions

| Priority | Issue | Location | Effort | Category |
|----------|-------|----------|--------|----------|
| Critical | Hardcoded API key | auth.ts:45 | S | Security |
| Critical | TypeScript errors | multiple | S | Build |
| High | SQL injection risk | queries.ts:112 | M | Security |

### Priority Actions
1. Fix all Critical issues before next release
2. Address High issues within current sprint
3. Plan Medium issues for technical debt sprint
4. Track Low issues in backlog

### Sources Consulted
- [Framework] best practices: [URL from MCP Ref]
- [Library] documentation: [URL from Context7]
```

## Critical Rules
- Read project's principles.md and tech_stack.md before judging.
- Use project's linters/formatters configuration as baseline.
- Do not auto-fix issues; report only. User decides what to address.
- Single task created; do not create multiple tasks per category.
- Language preservation in task description (EN/RU based on project).

## Definition of Done
- Best practices researched via MCP tools for major dependencies.
- All 12 categories audited.
- Findings collected with severity, location, effort estimate, and recommendation.
- Compliance score (X/10) calculated per category.
- Executive Summary and Strengths sections included.
- Report generated in structured format.
- Linear task created in Epic 0 with full report.
- Sources consulted listed with URLs.

## Reference Files
- Principles: `docs/principles.md`
- Tech stack: `docs/project/tech_stack.md`
- Related worker: `../ln-341-code-quality-checker/SKILL.md`

---
**Version:** 2.0.0
**Last Updated:** 2025-12-19
