---
name: ln-320-story-validator
description: Reviews Stories/Tasks against 2025 standards before approval (Backlog -> Todo). Auto-fixes issues, validates structure, invokes ln-321 for docs. Tabular output. Auto-discovers team/config.
---

# Story Verification Skill

Critically review and auto-fix Stories and Tasks against 2025 standards and project architecture before execution.

## Purpose & Scope

- Validate Story plus child Tasks against industry standards and project patterns
- Auto-fix detected issues (structure, solution, workflow, quality) before approval
- Invoke ln-321 to create missing documentation (Guides, Manuals, ADRs) instead of TODO placeholders
- Approve Story after fixes (Backlog -> Todo) with tabular output summary
- Strip or re-home Non-Functional Requirements; keep only functional scope in Story/Tasks

## When to Use

- Reviewing Stories before approval (Backlog -> Todo)
- Validating implementation path across Story and Tasks
- Ensuring standards, architecture, and solution fit
- Optimizing or correcting proposed approaches

## Research Tools (Mandatory)

**For standards verification (Phase 2):**
- `mcp__Ref__ref_search_documentation(query="[domain] RFC standard best practices 2025")` - industry standards
- `mcp__Ref__ref_search_documentation(query="[library] security vulnerabilities OWASP")` - security checks
- `WebSearch(query="[library] latest stable version 2025")` - version verification

**For library versions (Auto-Fix #6):**
- `mcp__context7__resolve-library-id(libraryName="[library]")` → get Context7 ID
- `mcp__context7__get-library-docs(context7CompatibleLibraryID="...", topic="version changelog")` - current versions

**Time-box:** 5-10 minutes per Story for research; skip if Story is trivial CRUD

## Workflow Overview

### Phase 1: Discovery & Loading

#### Step 0: Upstream Validation (ln-220)
- **Check if ln-220 completed its work** (if Story created via ln-220-story-coordinator):
  - Story description contains "Created via ln-220-story-coordinator" marker
  - Standards Research section present in Technical Notes (from ln-220 Phase 2)
  - Library Research table populated (from ln-220 Phase 3)
  - Test Strategy section exists but EMPTY (per ln-220 best practices)
  - All 8 sections present and in order
- **IF any missing:**
  - This indicates ln-220 bug → Add Linear comment: "ln-220 incomplete work detected"
  - Report issue instead of auto-fixing (don't redo ln-220's work)
- **IF ln-220 marker NOT found:**
  - Story created manually → Skip upstream validation, proceed normally

#### Step 1: Configuration & Metadata Loading
- Auto-discover configuration: Team ID (docs/tasks/kanban_board.md), project docs (CLAUDE.md), epic from Story.project
- Load metadata only: Story ID/title/status/labels, child Task IDs/titles/status/labels
- Expect 3-8 implementation tasks; record parentId for filtering
- Rationale: keep loading light; full descriptions arrive in Phase 2

### Phase 2: Critical Solution Review
- Load full Story description (all 8 sections) when analysis starts
- Standards first (priority): Industry/RFCs -> Security -> 2025 best practices -> KISS/YAGNI/DRY within standards
- **Research using MCP Ref:** call `ref_search_documentation(query="[story domain] RFC standard 2025")` for each technology in Story
- **Verify versions via Context7:** call `get-library-docs` to check library versions mentioned in Technical Notes
- Challenge approach: prefer proven standards over custom work; cite specific RFC/standard in Linear comment when fixing
- **Auto-Trigger ln-321 Documentation:**
  1. Load `ln321_auto_trigger_matrix.md`
  2. Scan Story title + Technical Notes for trigger keywords (OAuth, REST API, Rate Limiting, etc.)
  3. IF keywords match pattern → Invoke `Skill(skill="ln-321-docs-creator", args="doc_type=[guide|manual|adr] topic='...'")` per matrix
  4. Add created doc links to Story Technical Notes
- Verify against codebase reality before edits; if Story is outdated, auto-correct via Linear update
- Reporting rule: when principles are violated, explain why with best-practice references and propose concrete fixes, not just list names

### Phase 3: Comprehensive Auto-Fix
- Always auto-fix; no "Needs Work" path. Follow execution order: Structural (1-4) -> Solution (5-8) -> Workflow (9-12) -> Quality & Documentation (13-20)
- Use Auto-Fix Actions table below as the authoritative checklist; keep sequential task validation to avoid truncation
- Test mention: ensure Test Strategy section exists but keep it empty here; do not plan coverage or execution at this stage

### Phase 4: Approve & Notify
- Set Story + all Tasks to Todo (Linear); update kanban_board.md with APPROVED marker and move items from Backlog to Todo keeping hierarchy
- **Add Linear comment** with full validation summary:
  - Validation Summary table (criteria checked, status, evidence)
  - Auto-Fixes Applied table (fix number, category, description)
  - Documentation Created table (docs created via ln-321)
  - **Standards Compliance Evidence table** (standard, applies?, status, evidence)
  - TODO Warnings (if any remain)
- **Display tabular output** (Unicode box-drawing) to terminal:
  - STORY VALIDATION REPORT header with Story ID + ln-320 version
  - VALIDATION SUMMARY table (Criterion, Status, Evidence)
  - AUTO-FIXES APPLIED table (Fix #, Category, Description)
  - DOCUMENTATION CREATED table (docs created via ln-321)
  - STANDARDS COMPLIANCE table (Standard, Status, Evidence)
  - APPROVED → Todo footer with Story + Task count
- Any principle violations in reports must include rationale, best-practice reference, and recommended remediation steps

## Auto-Fix Actions Reference

| # | What it checks | Auto-fix actions | Notes/Evidence |
|---|----------------|------------------|----------------|
|1 Story Structure|8 sections per story_template_universal.md in order|Add/reorder sections and subsections with TODO placeholders; update Linear; preserve language|Skip if Done/Canceled or older than 30 days|
|2 Tasks Structure|Each Task has 7 sections in order|Load each Task full description sequentially; add/reorder sections with placeholders; update Linear and comment; preserve language|Sequential per task; skip if Done/Canceled or older than 30 days|
|3 Story Statement|As a/I want/So that clarity|Rewrite using persona (Context), capability (Technical Notes), value (Success Metrics); update Linear and comment|-|
|4 Acceptance Criteria|Given/When/Then, 3-5 items, edge/error coverage|Normalize AC to G/W/T; add missing edge/error cases; update Linear and comment|-|
|5 Solution Optimization|2025-best approach via MCP Ref research|Call `ref_search_documentation(query="[domain] best practices 2025")`; rewrite Technical Notes if better approach found; cite RFC/standard number; add Linear comment with research evidence|Evidence: MCP Ref query + result summary|
|6 Library & Version|Verify via Context7 + WebSearch|Call `mcp__context7__get-library-docs(topic="version")` for each library; if outdated, update to latest stable; log checked versions in Linear comment|Evidence: Context7 query + version comparison|
|7 Test Strategy|Section exists but remains empty now|Ensure Test Strategy section present; leave empty with note that testing is planned later by ln-350; do not add coverage details|Mention "testing handled later; not evaluated in this phase"|
|8 Documentation Integration|No standalone doc tasks|Remove doc-only tasks; fold doc updates into implementation tasks and DoD; update Linear and comment|-|
|9 Story Size & Granularity|3-8 tasks; 3-5h each|If <3 tasks invoke ln-310-story-decomposer; if >8 add TODO to split; flag tasks <3h or >8h with TODO; reload metadata and update kanban_board.md|Comment creation source|
|10 Test Task Cleanup|No premature test tasks|Cancel/remove tasks labeled as tests or named test/comprehensive/final; remove from Story/kanban; comment that testing tasks appear later|Testing not executed now|
|11 YAGNI|No premature features|Move speculative items to Out of Scope/Future; update Technical Notes/Tasks; comment rationale|-|
|12 KISS|Simplest solution within standards|Replace over-engineered parts with simpler options unless standards require otherwise; update Linear with reasoning|Standard overrides simplicity|
|13 Documentation Links|Technical Notes reference docs|Add "Related Documentation" subsection; link guides/manuals/ADRs by path; update Linear|Use created/existing paths|
|14 Foundation-First Order|Task order DB -> Repo -> Service -> API -> Frontend|Reorder Implementation Tasks and note execution order; update Linear and comment|-|
|15 Code Quality Basics|No magic values; config approach defined|Add TODOs for constants/config/env creds; describe config management in Technical Notes; update Linear|Warn in summary if TODOs remain|
|16 Industry Standards|MCP Ref verification mandatory|Call `ref_search_documentation(query="[domain] RFC OWASP standard")` BEFORE checking local docs; if RFC applies, verify Story complies; if local doc missing, invoke creators; add Linear comment with RFC reference or explicit "no standards apply" with reasoning|Evidence: MCP Ref query result or explicit skip reason|
|17 Rate Limiting|API Stories must have Rate Limiting documentation|If API Story (keywords: endpoint, API, REST, GraphQL) AND Rate Limiting subsection missing: invoke `Skill(skill="ln-321-docs-creator", args="doc_type=guide topic='API Rate Limiting Pattern'")` → creates docs/guides/06-api-rate-limiting.md; add reference to Technical Notes; update Linear comment with created doc|Skip if internal service, no external API; Evidence: Guide path or skip reason|
|18 Auth/Security Pattern|Auth Stories must have Security Pattern documentation|If Auth Story (keywords: auth, login, token, JWT, OAuth) AND Security Pattern missing: extract library from Technical Notes → invoke ln-321 twice: (1) `doc_type=manual topic='[library] v[version]'` → creates Manual; (2) `doc_type=adr topic='Authentication Strategy'` → creates ADR; add references to Technical Notes; update Linear with created docs|Skip if non-auth Story; Evidence: Manual + ADR paths or skip reason|
|19 Error Handling Strategy|All Stories must have Error Handling documentation|If Error Handling subsection missing in Technical Notes: invoke `Skill(skill="ln-321-docs-creator", args="doc_type=guide topic='Error Response Patterns (RFC 7807)'")` → creates docs/guides/07-error-handling.md; add reference to Technical Notes; update Linear comment|Mandatory for all Stories; Evidence: Guide path|
|20 Logging & Observability|All Stories must have Logging documentation|If Logging subsection missing in Technical Notes: invoke `Skill(skill="ln-321-docs-creator", args="doc_type=guide topic='Structured Logging Strategy'")` → creates docs/guides/08-logging.md; add reference to Technical Notes; update Linear comment|Mandatory for all Stories; Evidence: Guide path|

## Self-Audit Protocol (Mandatory)

- Before marking any criterion as ✅, answer its Self-Audit question and provide concrete evidence (doc path, MCP tool result, Linear update confirmation)
- **All evidence documented in Linear comment** (not separate file) with Validation Summary table
- No evidence -> cannot mark ✅ -> must perform required action first

| # | Self-Audit Question | Required Evidence |
|---|---------------------|-------------------|
|1|Validated all 8 Story sections in order?|Section list|
|2|Loaded full description for each Task?|Task validation count|
|3|Statement in As a/I want/So that?|Quoted statement|
|4|AC are G/W/T and testable?|AC count and format|
|5|Challenged "best for 2025" via MCP Ref?|MCP Ref query + result summary|
|6|Versions verified via Context7?|Context7 query + version list|
|7|Test Strategy kept empty for now?|Note that testing is deferred|
|8|Docs integrated, no standalone tasks?|Integration evidence|
|9|Task count 3-8 and 3-5h?|Task count/sizes|
|10|No premature test tasks?|Search result|
|11|Only current-scope features?|Scope review|
|12|Simplest approach within standards?|Simplicity justification|
|13|All relevant guides linked?|Guide paths|
|14|Tasks ordered DB->Repo->Service->API?|Task order list|
|15|Hardcoded values handled?|TODO/config evidence|
|16|Standards verified via MCP Ref?|MCP Ref query or explicit skip reason|
|17|Rate Limiting Guide created or exists?|Guide-06 path OR skip reason (non-API Story)|
|18|Auth Manual + ADR created or exist?|Manual path + ADR path OR skip reason (non-Auth Story)|
|19|Error Handling Guide created or exists?|Guide-07 path|
|20|Logging Guide created or exists?|Guide-08 path|

## Definition of Done

- Phase 1 Step 0: Upstream validation (ln-220) checked if applicable; ln-220 bugs reported if detected
- Phase 1 Step 1: Auto-discovery done; Story + Tasks metadata loaded; task count checked
- Phase 2: Full Story parsed; standards researched via MCP Ref; library versions verified via Context7; ln-321 invoked for missing docs (Guides, Manuals, ADRs); codebase reality verified; reports explain violations with best-practice references and fixes
- Phase 3: Criteria 1-20 auto-fixed in execution order (Structural → Solution → Workflow → Quality); Test Strategy section present but empty; test tasks removed; guide links inserted; ln-321 documentation created (#17-#20)
- Phase 4: Story/Tasks set to Todo; kanban_board.md updated with APPROVED marker and hierarchy; **Linear comment added** with Validation Summary table, Auto-Fixes table, Documentation Created table, Standards Compliance Evidence table, TODO warnings; **Tabular output displayed** (Unicode box-drawing) to terminal with validation report

## Example Workflows

- **Outdated library:** Detect old version via Context7, update to current stable in Technical Notes/Tasks, document change in Linear comment, approve.
- **OAuth violation:** Replace custom endpoints with RFC-compliant `/token` flow (verified via MCP Ref), invoke ln-321 to create Manual + ADR, add references to Technical Notes, approve.
- **Missing Rate Limiting (API Story):** Detect API Story pattern, Rate Limiting subsection missing → invoke ln-321 `doc_type=guide topic="API Rate Limiting Pattern"` → creates Guide-06, add reference to Technical Notes, approve.
- **Missing tasks:** If <3 tasks, run ln-310-story-decomposer, reload tasks, reorder Foundation-First, update kanban and comments, approve.

## Reference Files

- **Templates:** `../ln-220-story-coordinator/references/story_template_universal.md`, `../ln-311-task-creator/references/task_template_implementation.md`
- **Validation Checklists (Progressive Disclosure):**
  - `references/verification_checklist_template.md` (overview of 4 categories)
  - `references/structural_validation.md` (criteria #1-#4: Story/Tasks structure)
  - `references/solution_validation.md` (criteria #5-#8: Solution optimization, library versions)
  - `references/workflow_validation.md` (criteria #9-#12: YAGNI, KISS, story size)
  - `references/quality_validation.md` (criteria #13-#20: Standards, ln-321 integration)
  - `references/ln321_auto_trigger_matrix.md` (Auto-Trigger Matrix for ln-321 invocation)
- **Testing methodology** (for later phases): `../ln-350-story-test-planner/references/risk_based_testing_guide.md`
- **Linear integration:** `../ln-210-epic-coordinator/references/linear_integration.md`

---
**Version:** 14.0.0 (Progressive Disclosure Pattern: 5 validation files, ln-321 integration for #17-#20, tabular output, upstream validation, Self-Audit in Linear comment)
**Last Updated:** 2025-12-21
