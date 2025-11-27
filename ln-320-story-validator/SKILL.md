---
name: ln-320-story-validator
description: Reviews Stories/Tasks against 2025 standards before approval (Backlog -> Todo). Auto-fixes issues, validates structure, optimizes via YAGNI/KISS/SOLID. Auto-discovers team/config.
---

# Story Verification Skill

Critically review and auto-fix Stories and Tasks against 2025 standards and project architecture before execution.

## Purpose & Scope

- Validate Story plus child Tasks against industry standards and project patterns
- Auto-fix detected issues (structure, solution, workflow, quality) before approval
- Approve Story after fixes (Backlog -> Todo) and link any missing guides
- Strip or re-home Non-Functional Requirements; keep only functional scope in Story/Tasks

## When to Use

- Reviewing Stories before approval (Backlog -> Todo)
- Validating implementation path across Story and Tasks
- Ensuring standards, architecture, and solution fit
- Optimizing or correcting proposed approaches

## Workflow Overview

### Phase 1: Discovery & Loading
- Auto-discover configuration: Team ID (docs/tasks/kanban_board.md), project docs (CLAUDE.md), epic from Story.project
- Load metadata only: Story ID/title/status/labels, child Task IDs/titles/status/labels
- Expect 3-8 implementation tasks; record parentId for filtering
- Rationale: keep loading light; full descriptions arrive in Phase 2

### Phase 2: Critical Solution Review
- Load full Story description (all 8 sections) when analysis starts
- Standards first (priority): Industry/RFCs -> Security -> 2025 best practices -> KISS/YAGNI/DRY within standards
- Challenge approach: prefer proven standards over custom work; keep language as-is (EN/RU)
- Documentation check and creation triggers (pattern keywords, package versions, technology choices); invoke ln-321-guide-creator / ln-323-manual-creator / ln-322-adr-creator if missing
- Verify against codebase reality before edits; if Story is outdated, auto-correct via Linear update
- Reporting rule: when principles are violated, explain why with best-practice references and propose concrete fixes, not just list names

### Phase 3: Comprehensive Auto-Fix
- Always auto-fix; no "Needs Work" path. Follow execution order: Structural (1-4) -> Solution (5-8) -> Workflow (9-12) -> Scope & Quality (13-16)
- Use Auto-Fix Actions table below as the authoritative checklist; keep sequential task validation to avoid truncation
- Test mention: ensure Test Strategy section exists but keep it empty here; do not plan coverage or execution at this stage

### Phase 4: Approve & Notify
- Set Story + all Tasks to Todo (Linear); update kanban_board.md with APPROVED marker and move items from Backlog to Todo keeping hierarchy
- Add Linear comment summarizing fixes, created docs (paths), ADRs/manuals/guides, and any TODO warnings
- Verification summary display: Story verdict (always Approved -> Todo), changes, linked docs, warnings; Tasks table with changes and guide links
- Any principle violations in reports must include rationale, best-practice reference, and recommended remediation steps

## Auto-Fix Actions Reference

| # | What it checks | Auto-fix actions | Notes/Evidence |
|---|----------------|------------------|----------------|
|1 Story Structure|8 sections per story_template_universal.md in order|Add/reorder sections and subsections with TODO placeholders; update Linear; preserve language|Skip if Done/Canceled or older than 30 days|
|2 Tasks Structure|Each Task has 7 sections in order|Load each Task full description sequentially; add/reorder sections with placeholders; update Linear and comment; preserve language|Sequential per task; skip if Done/Canceled or older than 30 days|
|3 Story Statement|As a/I want/So that clarity|Rewrite using persona (Context), capability (Technical Notes), value (Success Metrics); update Linear and comment|-|
|4 Acceptance Criteria|Given/When/Then, 3-5 items, edge/error coverage|Normalize AC to G/W/T; add missing edge/error cases; update Linear and comment|-|
|5 Solution Optimization|2025-best approach aligned with prior patterns|Rewrite Technical Notes and Tasks if better approach exists; cite modern patterns/libs; reference prior Story context; add TODO for duplicates/conflicts|Log rationale in Linear|
|6 Library & Version|Current stable versions; prefer built-ins|Update versions in Technical Notes/Tasks; replace custom helpers with built-ins; update Linear and comment|List versions checked|
|7 Test Strategy|Section exists but remains empty now|Ensure Test Strategy section present; leave empty with note that testing is planned later by ln-350; do not add coverage details|Mention "testing handled later; not evaluated in this phase"|
|8 Documentation Integration|No standalone doc tasks|Remove doc-only tasks; fold doc updates into implementation tasks and DoD; update Linear and comment|-|
|9 Story Size & Granularity|3-8 tasks; 3-5h each|If <3 tasks invoke ln-310-story-decomposer; if >8 add TODO to split; flag tasks <3h or >8h with TODO; reload metadata and update kanban_board.md|Comment creation source|
|10 Test Task Cleanup|No premature test tasks|Cancel/remove tasks labeled as tests or named test/comprehensive/final; remove from Story/kanban; comment that testing tasks appear later|Testing not executed now|
|11 YAGNI|No premature features|Move speculative items to Out of Scope/Future; update Technical Notes/Tasks; comment rationale|-|
|12 KISS|Simplest solution within standards|Replace over-engineered parts with simpler options unless standards require otherwise; update Linear with reasoning|Standard overrides simplicity|
|13 Documentation Links|Technical Notes reference docs|Add "Related Documentation" subsection; link guides/manuals/ADRs by path; update Linear|Use created/existing paths|
|14 Foundation-First Order|Task order DB -> Repo -> Service -> API -> Frontend|Reorder Implementation Tasks and note execution order; update Linear and comment|-|
|15 Code Quality Basics|No magic values; config approach defined|Add TODOs for constants/config/env creds; describe config management in Technical Notes; update Linear|Warn in summary if TODOs remain|
|16 Industry Standards|Compliance with RFCs/protocols|Check docs in guides/manuals/ADRs; if missing invoke creators; document compliance and links; if none apply, state explicit reason; update Linear|Evidence required: doc path or worker call; log skip reason if applicable|

## Self-Audit Protocol (Mandatory)

- Before marking any criterion, answer its Self-Audit question, provide concrete evidence (doc path, Linear comment link, worker result), and record in `checkpoints/{STORY_ID}_verification_log.md`. No evidence -> no completion.

| # | Self-Audit Question | Required Evidence |
|---|---------------------|-------------------|
|1|Validated all 8 Story sections in order?|Section list|
|2|Loaded full description for each Task?|Task validation count|
|3|Statement in As a/I want/So that?|Quoted statement|
|4|AC are G/W/T and testable?|AC count and format|
|5|Challenged "best for 2025"?|Reasoning logged|
|6|All versions current stable?|Version list checked|
|7|Test Strategy kept empty for now?|Note that testing is deferred|
|8|Docs integrated, no standalone tasks?|Integration evidence|
|9|Task count 3-8 and 3-5h?|Task count/sizes|
|10|No premature test tasks?|Search result|
|11|Only current-scope features?|Scope review|
|12|Simplest approach within standards?|Simplicity justification|
|13|All relevant guides linked?|Guide paths|
|14|Tasks ordered DB->Repo->Service->API?|Task order list|
|15|Hardcoded values handled?|TODO/config evidence|
|16|Standards verified via docs/worker?|Doc path or worker result|

## Definition of Done

- Verification log created from template with answered Self-Audit for all 16 criteria and evidence
- Phase 1: auto-discovery done; Story + Tasks metadata loaded; task count checked
- Phase 2: full Story parsed; standards researched; doc gaps filled via creators; codebase reality verified; reports explain violations with best-practice references and fixes
- Phase 3: criteria 1-16 auto-fixed in order; Test Strategy section present but empty; test tasks removed; guide links inserted
- Phase 4: Story/Tasks set to Todo; kanban_board.md updated with APPROVED marker and hierarchy; Linear comment added with fixes, docs, ADRs/manuals/guides, TODO warnings; summary table shown

## Example Workflows

- **Outdated library:** Detect old version, update to current stable in Technical Notes/Tasks, document change, approve.
- **OAuth violation:** Replace custom endpoints with RFC-compliant `/token` flow, add spec reference, update Tasks/Technical Notes, approve.
- **Missing tasks:** If <3 tasks, run ln-310-story-decomposer, reload tasks, reorder Foundation-First, update kanban and comments, approve.

## Reference Files

- Templates: `../ln-220-story-coordinator/references/story_template_universal.md`, `../ln-311-task-creator/references/task_template_implementation.md`
- Checklists: `references/verification_checklist.md`, `references/verification_log_template.md`
- Testing methodology (for later phases): `../ln-350-story-test-planner/references/risk_based_testing_guide.md`
- Linear integration: `../ln-210-epic-coordinator/references/linear_integration.md`

---

Version: 12.1.0 (Condensed guidance, tabled auto-fix actions, clarified testing deferral and violation reporting)
Last Updated: 2025-11-26
