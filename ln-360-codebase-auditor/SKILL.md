---
name: ln-360-codebase-auditor
description: Codebase-level quality audit across 9 categories. Creates refactoring task in Linear Epic 0.
---

# Codebase Auditor

Full codebase quality audit that identifies technical debt and creates a consolidated refactoring task.

## Purpose & Scope
- Audit entire codebase against 9 quality categories (security, architecture, complexity, etc.).
- Collect issues with severity, location, and recommendations.
- Create single refactoring task in Linear under Epic 0 with all findings.
- Manual invocation by user; not part of Story pipeline.

## Workflow (concise)
1) **Discovery:** Load tech_stack.md, principles.md, package manifests (package.json/requirements.txt/go.mod).
2) **Static Analysis:** Run 9 audit categories in priority order (see below).
3) **Collect Issues:** Record each finding with severity (Critical/High/Medium/Low), file path, line, recommendation.
4) **Generate Report:** Group findings by category; calculate totals per severity.
5) **Create Task:** Create Linear task in Epic 0 titled "Codebase Refactoring: [YYYY-MM-DD]" with findings and priorities.

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

## Output Format

```markdown
## Codebase Audit Report - [DATE]

### Summary
| Severity | Count |
|----------|-------|
| Critical | X |
| High | X |
| Medium | X |
| Low | X |

### Findings by Category

#### 1. Security (Critical)
- [ ] **[CRITICAL]** `src/api/auth.ts:45` - Hardcoded API key. Move to environment variable.
- [ ] **[HIGH]** `src/db/queries.ts:112` - SQL string concatenation. Use parameterized query.

#### 2. Build Health
- [ ] **[CRITICAL]** 3 TypeScript errors in strict mode. Fix type annotations.

... (continue for all categories with findings)

### Priority Actions
1. Fix all Critical issues before next release
2. Address High issues within current sprint
3. Plan Medium issues for technical debt sprint
4. Track Low issues in backlog
```

## Critical Rules
- Read project's principles.md and tech_stack.md before judging.
- Use project's linters/formatters configuration as baseline.
- Do not auto-fix issues; report only. User decides what to address.
- Single task created; do not create multiple tasks per category.
- Language preservation in task description (EN/RU based on project).

## Definition of Done
- All 9 categories audited.
- Findings collected with severity, location, and recommendation.
- Report generated in structured format.
- Linear task created in Epic 0 with full report.
- Summary posted with severity counts.

## Reference Files
- Principles: `docs/principles.md`
- Tech stack: `docs/project/tech_stack.md`
- Related worker: `../ln-341-code-quality-checker/SKILL.md`

---
Version: 1.0.0
Last Updated: 2025-12-09
