---
name: ln-320-story-validator
description: Reviews Stories/Tasks against 2025 standards - CRITICAL PATH FIRST. Research via ln-321, decision point (CONTINUE/REPLAN), auto-fix if path correct. Tabular output. Auto-discovers team/config.
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

### Phase 2: CRITICAL PATH VALIDATION (NEW - PRIORITY #1)

**Purpose:** Validate solution path BEFORE structural details. Researched approach quality > structural correctness.

**Steps:**

1. **Domain Extraction:** Extract technical domains from Story title + Technical Notes + Implementation Tasks
   - Load pattern registry from `ln321_auto_trigger_matrix.md` (contains ALL patterns with trigger keywords)
   - Scan Story content for pattern matches via keyword detection
   - Build list of detected domains requiring research
   - Universal approach: works for ANY Story (OAuth, REST API, ML pipelines, Video processing, Email, File Upload, Blockchain, etc.)

2. **TRIVIAL CRUD Detection:** Determine execution path (SKIP Phase 2-3 OR MANDATORY research)
   - Check if Story matches TRIVIAL CRUD pattern (keywords: "CRUD", "basic API", "simple REST")
   - Check for anti-keywords (auth, oauth, security, integration, external, payment)

   - **IF TRIVIAL CRUD detected:**
     - ⚠️ **SKIP Phase 2-3 entirely** - proceed directly to Phase 4 (fast path)
     - Set `phase2_executed = false` flag in memory
     - Criteria #5, #6, #16, #17 will use FALLBACK (direct MCP Ref/Context7)
     - Total time: ~2 min (no research overhead)
     - **EXIT this phase** - continue to Phase 4

   - **ELSE (NON-TRIVIAL Story):**
     - ⚠️ **Phase 2-3 MANDATORY** - MUST execute research delegation
     - Set `phase2_executed = true` flag in memory
     - Timebox: 10 min (deep research, full standards verification)
     - **CONTINUE to Steps 3-5 below** (do NOT skip)

3. **Research Delegation (NON-TRIVIAL ONLY):** ⚠️ **REQUIRED** - Invoke ln-321 for EACH detected pattern
   - Check if documentation already exists (from previous validations or ln-220)
   - IF doc missing: **MUST** invoke `Skill(skill="ln-321-best-practices-researcher", args="doc_type=[guide|manual|adr] topic='...'")` per ln321_auto_trigger_matrix.md
   - **MUST NOT skip** this step for NON-TRIVIAL Stories - research is REQUIRED
   - Receive file paths to created documentation (docs/guides/, docs/manuals/, docs/adrs/)
   - ONE ln-321 invocation per pattern in Phase 2 (no duplicates later)

4. **Findings Analysis (NON-TRIVIAL ONLY):** ⚠️ **MANDATORY** - Read ALL created documentation before proceeding
   - **REQUIRED:** Read each created doc (Guide/Manual/ADR) - do NOT skip
   - Extract: standards (RFC numbers, OWASP rules), library versions, patterns (do/don't/when), architecture decisions
   - **MUST** save findings to memory for use in Phase 4 criteria
   - Verify findings are complete (standards + versions + patterns all extracted)

5. **Improvement Score Calculation (NON-TRIVIAL ONLY):** ⚠️ **REQUIRED** - Calculate score for EACH finding
   - **MANDATORY:** For EACH finding, compare current Story approach vs recommended approach
   - Calculate improvement score: library version diff + standards violations + rejected alternatives
   - Compute improvement percentage: (score / max_score * 100)
   - Generate issues list with severity (CRITICAL, HIGH, MEDIUM)
   - **MUST** complete calculation before Phase 3 decision

### Phase 3: DECISION POINT (NEW)

⚠️ **SKIP THIS PHASE if `phase2_executed = false` (TRIVIAL CRUD)** - auto-CONTINUE to Phase 4

**Purpose:** Decide CONTINUE (auto-fix) or REPLAN (better approach found).

**Logic (NON-TRIVIAL ONLY):**
- **IF improvement_score ≥ 50%:**
  - **REPLAN PATH:**
    - Add Linear comment with research findings, issues table, improvement score
    - Recommend: "Invoke ln-310-story-decomposer with mode=REPLAN"
    - List created documentation paths (for ln-310 to use)
    - Display tabular report with REPLAN recommendation
    - EXIT (do NOT proceed to auto-fix)
- **ELSE (improvement_score < 50%):**
  - **CONTINUE PATH:**
    - Proceed to Phase 4 (auto-fix using findings from Phase 2)
    - Findings from Phase 2 available to all criteria (no additional research needed)

### Phase 4: Structural + Solution Auto-Fix (ONLY IF CONTINUE)

**CRITICAL:** This phase executes ONLY if Phase 3 decided CONTINUE (improvement < 50%).

- Execution order: Structural (#1-#4) → Solution (#5-#8) → Workflow (#9-#12) → Quality & Documentation (#13-#17)
- Use Auto-Fix Actions table below as authoritative checklist
- **Criteria #5, #6, #16, #17 use CONDITIONAL RESEARCH:**
  - IF `phase2_executed = true` (NON-TRIVIAL) → READ findings from Phase 2 (no MCP calls)
  - IF `phase2_executed = false` (TRIVIAL skip) → FALLBACK to direct MCP Ref/Context7 calls
- Test Strategy section must exist but remain empty (testing handled by ln-350 later)

### Phase 5: Approve & Notify

- Set Story + all Tasks to Todo (Linear); update kanban_board.md with APPROVED marker
- **Add Linear comment** with full validation summary:
  - Validation Summary table (criteria checked, status, evidence)
  - Auto-Fixes Applied table (fix number, category, description)
  - Documentation Created table (docs created via ln-321 in Phase 2)
  - **Standards Compliance Evidence table** (standard, applies?, status, evidence)
  - **Improvement Score** (from Phase 3 calculation)
  - TODO Warnings (if any remain)
- **Display tabular output** (Unicode box-drawing) to terminal:
  - STORY VALIDATION REPORT header with Story ID + ln-320 version
  - VALIDATION SUMMARY table (Criterion, Status, Evidence)
  - AUTO-FIXES APPLIED table (Fix #, Category, Description)
  - DOCUMENTATION CREATED table (docs created via ln-321)
  - STANDARDS COMPLIANCE table (Standard, Status, Evidence)
  - IMPROVEMENT SCORE (percentage)
  - APPROVED → Todo footer with Story + Task count
- Any principle violations in reports must include rationale, best-practice reference, and recommended remediation steps

## Auto-Fix Actions Reference

| # | What it checks | Auto-fix actions | Notes/Evidence |
|---|----------------|------------------|----------------|
|1 Story Structure|8 sections per story_template_universal.md in order|Add/reorder sections and subsections with TODO placeholders; update Linear; preserve language|Skip if Done/Canceled or older than 30 days|
|2 Tasks Structure|Each Task has 7 sections in order|Load each Task full description sequentially; add/reorder sections with placeholders; update Linear and comment; preserve language|Sequential per task; skip if Done/Canceled or older than 30 days|
|3 Story Statement|As a/I want/So that clarity|Rewrite using persona (Context), capability (Technical Notes), value (Success Metrics); update Linear and comment|-|
|4 Acceptance Criteria|Given/When/Then, 3-5 items, edge/error coverage|Normalize AC to G/W/T; add missing edge/error cases; update Linear and comment|-|
|5 Solution Optimization|Compare Story approach with best practices|**IF phase2_executed = true:** Read findings from Phase 2 research_results; extract standards/patterns from guides; **ELSE (TRIVIAL fallback):** Query MCP Ref for industry standards (topic: Story domain); extract RFC/OWASP rules; Compare with Story Technical Notes; IF violates → Update with compliant approach; Add reference; update Linear comment|Evidence: Guide paths (Phase 2) OR MCP query result (TRIVIAL)|
|6 Library & Version|Check library versions are latest|**IF phase2_executed = true:** Extract library versions from manuals created in Phase 2; **ELSE (TRIVIAL fallback):** Query Context7 for library versions (`mcp__context7__resolve-library-id` + `get-library-docs`); Compare with Story Technical Notes; IF outdated → Update to recommended version; Add reference; update Linear comment|Evidence: Manual paths (Phase 2) OR Context7 query result (TRIVIAL)|
|7 Test Strategy|Section exists but remains empty now|Ensure Test Strategy section present; leave empty with note that testing is planned later by ln-350; do not add coverage details|Mention "testing handled later; not evaluated in this phase"|
|8 Documentation Integration|No standalone doc tasks|Remove doc-only tasks; fold doc updates into implementation tasks and DoD; update Linear and comment|-|
|9 Story Size & Granularity|3-8 tasks; 3-5h each|If <3 tasks invoke ln-310-story-decomposer; if >8 add TODO to split; flag tasks <3h or >8h with TODO; reload metadata and update kanban_board.md|Comment creation source|
|10 Test Task Cleanup|No premature test tasks|Cancel/remove tasks labeled as tests or named test/comprehensive/final; remove from Story/kanban; comment that testing tasks appear later|Testing not executed now|
|11 YAGNI|No premature features|Move speculative items to Out of Scope/Future; update Technical Notes/Tasks; comment rationale|-|
|12 KISS|Simplest solution within standards|Replace over-engineered parts with simpler options unless standards require otherwise; update Linear with reasoning|Standard overrides simplicity|
|13 Documentation Links|Technical Notes reference docs|Add "Related Documentation" subsection; link guides/manuals/ADRs by path; update Linear|Use created/existing paths|
|14 Foundation-First Order|Task order DB -> Repo -> Service -> API -> Frontend|Reorder Implementation Tasks and note execution order; update Linear and comment|-|
|15 Code Quality Basics|No magic values; config approach defined|Add TODOs for constants/config/env creds; describe config management in Technical Notes; update Linear|Warn in summary if TODOs remain|
|16 Industry Standards|Verify compliance with standards|**IF phase2_executed = true:** Read standards from guides created in Phase 2; check Story compliance; **ELSE (TRIVIAL fallback):** Query MCP Ref for standards compliance (RFC, OWASP); IF non-compliant → Update Story with compliant approach; Add reference; update Linear comment|Evidence: Standards list + Guide paths (Phase 2) OR MCP query result (TRIVIAL)|
|17 Technical Documentation|Check pattern-specific docs exist|**IF phase2_executed = true:** For EACH pattern detected in Phase 2, check if docs exist (guides/manuals/ADRs); add references to Technical Notes; **ELSE (TRIVIAL fallback):** Query MCP Ref for pattern-specific docs (e.g., "REST API best practices"); create inline references from search results; no separate doc creation; Works for ANY pattern from ln321_auto_trigger_matrix.md (OAuth, REST API, Rate Limiting, Caching, WebSocket, Email, File Upload, ML, Blockchain, etc.)|Universal criterion; Evidence: Doc paths (Phase 2) OR MCP query results (TRIVIAL)|

## Self-Audit Protocol (Mandatory)

- Before marking any criterion as ✅, answer its Self-Audit question and provide concrete evidence (doc path, MCP tool result, Linear update confirmation)
- **All evidence documented in Linear comment** (not separate file) with Validation Summary table
- No evidence -> cannot mark ✅ -> must perform required action first

| # | Self-Audit Question | Required Evidence |
|---|---------------------|-------------------|
|0|Determined Story complexity (TRIVIAL/NON-TRIVIAL)?|TRIVIAL keywords detected OR NON-TRIVIAL triggers found|
|0a|If NON-TRIVIAL: Phase 2 executed with ln-321 calls?|List of created docs (guides/manuals/ADRs) OR TRIVIAL skip reason (`phase2_executed = false`)|
|1|Validated all 8 Story sections in order?|Section list|
|2|Loaded full description for each Task?|Task validation count|
|3|Statement in As a/I want/So that?|Quoted statement|
|4|AC are G/W/T and testable?|AC count and format|
|5|Compared Story approach with Phase 2 findings?|Guide paths from Phase 2 research|
|6|Read library versions from Phase 2 manuals?|Manual paths from Phase 2 research|
|7|Test Strategy kept empty for now?|Note that testing is deferred|
|8|Docs integrated, no standalone tasks?|Integration evidence|
|9|Task count 3-8 and 3-5h?|Task count/sizes|
|10|No premature test tasks?|Search result|
|11|Only current-scope features?|Scope review|
|12|Simplest approach within standards?|Simplicity justification|
|13|All relevant guides linked?|Guide paths|
|14|Tasks ordered DB->Repo->Service->API?|Task order list|
|15|Hardcoded values handled?|TODO/config evidence|
|16|Verified compliance with Phase 2 guides?|Standards list + Guide paths from Phase 2|
|17|Pattern-specific docs referenced in Story?|All doc paths from Phase 2 (guides/manuals/ADRs for detected patterns)|

## Definition of Done

- **Phase 1:** Upstream validation (ln-220) checked if applicable; auto-discovery done; Story + Tasks metadata loaded; task count checked
- **Phase 2:** TRIVIAL CRUD detection completed; **IF NON-TRIVIAL:** domain extraction, research delegation to ln-321 for ALL detected patterns, findings analysis (standards/library versions/patterns extracted), improvement score calculation; **IF TRIVIAL:** Phase 2-3 skipped, set `phase2_executed = false` flag, proceed to Phase 4 with MCP fallback
- **Phase 3:** Decision made: REPLAN (≥50% improvement) with Linear comment + tabular report, OR CONTINUE to Phase 4
- **Phase 4 (ONLY IF CONTINUE):** Criteria 1-17 auto-fixed in execution order (Structural → Solution → Workflow → Quality); findings from Phase 2 used (no additional MCP/ln-321 calls); Test Strategy section present but empty; test tasks removed; pattern-specific docs referenced
- **Phase 5:** Story/Tasks set to Todo; kanban_board.md updated with APPROVED marker; **Linear comment added** with Validation Summary, Auto-Fixes, Documentation Created, Standards Compliance, Improvement Score, TODO warnings; **Tabular output displayed** (Unicode box-drawing) to terminal

## Example Workflows

- **TRIVIAL CRUD fast path:** Story "Create basic CRUD for User entity" detected as TRIVIAL; Phase 2-3 SKIPPED (`phase2_executed = false`); Phase 4 executes with MCP Ref fallback: Criterion #5 queries "CRUD REST API standards" (finds RFC 7807 error format), Criterion #6 queries Context7 for Express.js v4.19 (latest), Criterion #16 verifies OWASP compliance via MCP Ref; total time 2 min; approve immediately; no deep research overhead.
- **NON-TRIVIAL OAuth Story (REPLAN path):** Story "Implement OAuth 2.0 authentication" detected as NON-TRIVIAL (security keyword); Phase 2 MANDATORY (`phase2_executed = true`); ln-321 creates Manual (oauth2-proxy v7.6) + ADR (Auth Strategy: OAuth vs JWT) + Guide-03 (OAuth Patterns RFC 6749); improvement score 58% (CRITICAL: Story uses session-based auth, violates RFC 6749 - missing refresh token + PKCE); Phase 3 recommends REPLAN; Linear comment with findings table; EXIT without auto-fix; recommend ln-310-story-decomposer mode=REPLAN.
- **NON-TRIVIAL REST API (CONTINUE path):** Story "Build REST API for User management" detected as NON-TRIVIAL; Phase 2 executes (`phase2_executed = true`); ln-321 creates Guide-05 (REST patterns), Manual (Express v4.19); findings show minor version update needed (v4.17 → v4.19); improvement score 15% (LOW: only version diff); Phase 3 continues to Phase 4; Criterion #6 reads manual from Phase 2, updates library version; Criterion #17 adds Guide-05 reference to Technical Notes; approve.
- **Universal pattern detection:** Story about ML pipeline triggers ln-321 to create Guide for Data Validation + Manual for TensorFlow v2.15; Phase 4 Criterion #17 adds both doc references to Technical Notes; works for ANY domain from ln321_auto_trigger_matrix.md (ML, Blockchain, Video, Email, etc.).

## Reference Files

- **Templates:** `../ln-220-story-coordinator/references/story_template_universal.md`, `../ln-311-task-creator/references/task_template_implementation.md`
- **Validation Checklists (Progressive Disclosure):**
  - `references/verification_checklist_template.md` (overview of 4 categories, 17 criteria total)
  - `references/structural_validation.md` (criteria #1-#4: Story/Tasks structure)
  - `references/solution_validation.md` (criteria #5-#8: Solution optimization, library versions)
  - `references/workflow_validation.md` (criteria #9-#12: YAGNI, KISS, story size)
  - `references/quality_validation.md` (criteria #13-#17: Standards, pattern-specific documentation)
  - `references/ln321_auto_trigger_matrix.md` (Pattern registry: ALL technical domains with trigger keywords)
- **Testing methodology** (for later phases): `../ln-350-story-test-planner/references/risk_based_testing_guide.md`
- **Linear integration:** `../ln-210-epic-coordinator/references/linear_integration.md`

---
**Version:** 15.1.0 (Hybrid Approach: TRIVIAL skip Phase 2-3 with MCP Ref/Context7 fallback in Phase 4, NON-TRIVIAL mandatory Phase 2 research via ln-321 with Decision Point, conditional research in criteria #5-#6-#16-#17, imperative keywords REQUIRED/MANDATORY/MUST, phase2_executed flag)
**Last Updated:** 2025-12-21
