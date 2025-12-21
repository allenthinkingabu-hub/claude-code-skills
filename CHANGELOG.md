# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

**CRITICAL RULE: Each release = ONE concise paragraph (3-5 sentences max). NO detailed subsections (Added/Changed/Removed). Summarize BREAKING CHANGES + key features only. One version entry per date.**

---

## 2025-12-21

ln-320-story-validator v15.0.0 - Critical Path Validation First refactor with 5-phase architecture (was 4). Phase 2: Domain extraction from ln321_auto_trigger_matrix.md (universal pattern detection for ANY Story: OAuth, REST, ML, Blockchain, Email, etc.), TRIVIAL CRUD detection (2min vs 10min timebox), research delegation to ln-321 (ONE invocation per pattern), findings analysis (standards/library versions/patterns extraction), improvement score calculation (library diff + RFC violations + rejected alternatives). Phase 3: Decision Point (REPLAN if improvement ≥50% with Linear comment + recommend ln-310, OR CONTINUE to auto-fix). Phase 4: 20→17 criteria (consolidated #17-#20 into universal #17 "Technical Documentation"), removed direct MCP Ref/Context7 calls from #5/#6/#16 (read Phase 2 findings instead), ln-310 invocation for >8 Tasks (#9). Orchestrator-Worker Pattern enforced: ln-320 coordinates, ln-321 researches (10x token reduction, no duplicate research). Universal skill: works for ANY domain via pattern registry, not hardcoded patterns.

---

## 2025-11-17

Centralized validation refactor + file naming standardization. ln-110-documents-pipeline v5.0.0 added Phase 3: Validate All Documentation - centralized validation for all created documents (SCOPE tags, Maintenance sections, POSIX compliance), auto-fixes violations, checks documentation_standards.md in target project or applies industry best practices. 5 workers refactored to pure CREATE (removed duplicate validation logic, -93 lines code duplication): ln-112-reference-docs-creator v6.0.0 (removed Phase 3), ln-113-tasks-docs-creator v6.0.0 (removed Phase 3), ln-114-project-docs-creator v11.0.0 (removed Phase 3), ln-115-presentation-creator v6.0.0 (removed Phase 6), ln-116-test-docs-creator v6.0.0 (removed Phase 2). File naming standardized to lowercase: ln-111-root-docs-creator v9.0.0 now creates documentation_standards.md + principles.md (lowercase, not DOCUMENTATION_STANDARDS.md/Principles.md), updated templates (claude_md_template.md, docs_root_readme_template.md) with lowercase references. ln-115 renamed TEMPLATE_ARCHITECTURE.md → template_architecture.md for consistency. ln-121-structure-validator v3.0.1 fixed Principles.md → principles.md references (14 replacements across 4 files via automated script). Orchestrator-Worker Pattern implemented: workers do pure CREATE, orchestrator validates (separation of concerns, token efficiency).

---

## 2025-11-16

**[11.0.0]** BREAKING: File existence checks across all documentation workers - Idempotent mode implemented. 7 skills updated with file preservation logic (24 total checks): ln-110-documents-pipeline v4.0.0 (Pre-flight check scans 24 potential files, shows "Found X / Missing Y" summary), ln-111-root-docs-creator v7.0.0 (checks 3 files), ln-112-reference-docs-creator v4.0.0 (checks 5 items), ln-113-tasks-docs-creator v4.0.0 (critical kanban_board.md protection to prevent task loss), ln-114-project-docs-creator v9.0.0 (checks 7 docs + state management: tracks "created file list", Phase 2 edits ONLY newly created files), ln-115-presentation-creator v4.0.0 (checks presentation/README.md + user confirmation before rebuilding presentation_final.html), ln-116-test-docs-creator v4.0.0 (checks 4 items). All skills now create ONLY missing files, preserve existing documentation, prevent accidental data loss on repeated invocations.

---

## 2025-11-15

**[4.0.0]** BREAKING: Epic Grouping Pattern in kanban board. Three critical skills updated with Epic split/merge algorithms: ln-311-task-creator v4.0.0 (5-step find/create logic), ln-312-task-replanner v4.0.0 (cleanup logic), ln-330-story-executor v7.0.0 (Story movement with Epic context preservation). Templates updated for hierarchical Epic → Story → Task format (Epic no indent, Story 2-space, Task 4-space). Four-level README hierarchy: docs/ → project/ → reference/ → tasks/. Moved ADRs/Guides/Manuals to docs/reference/ with automatic registry updates. Token efficiency: Epic context always visible without scrolling.

---

## 2025-11-14

**[3.0.0]** BREAKING: L2→L2 Delegation Rules, Story Status Responsibility Matrix (4 transitions), autoApprove mechanism for full automation. ln-300-story-pipeline v2.0.0 always invokes ln-310-story-decomposer. ln-330-story-executor v6.0.0 removed Priority 0 (3 priorities now). Progressive Disclosure Pattern applied to 5+ skills (24-40% documentation reduction). Renamed 5 skills with semantic suffixes (x-story-executor → ln-330-story-executor) for L2 Domain Orchestrator distinction. 3-Level Hierarchy Architecture (Microsoft Scheduler Agent Supervisor Pattern) with Progressive Loading (15,000+ tokens saved).

---

## 2025-11-13

**[1.7.0]** Added 5 new skills: ln-311-task-creator/ln-312-task-replanner v1.0.0 (Universal Factory Pattern for 3 task types: implementation/refactoring/test), ln-341/342/343 v1.0.0 (atomic quality/regression/manual testing workers). Added SKILL_ARCHITECTURE_GUIDE.md v1.0.0 (industry best practices 2024-2025), expanded refactoring_task_template.md (83→513 lines), Test Result Format v1.0. BREAKING: x-test-task-planner v6.0.0 renamed from x-story-finalizer, x-task-planner v6.0.0 refactored to Orchestrator Pattern. Architecture unified: Orchestrator-Worker Pattern across all skills, 90.2% performance improvement (token efficiency via lazy loading).

---

## 2025-11-12

**[1.1.0]** Added Phase 0: Library & Standards Research in ln-211-story-manager v8.0.0 (automated research via MCP Context7 + Ref BEFORE Story generation, 15-20 min time-boxed). story_template_universal.md v7.0.0 with Library Research + Related Guides subsections, task_template_universal.md v6.0.0 with expanded Technical Approach (~50→200-300 words with library versions, key APIs, pseudocode). Temporary Manual Testing Scripts workflow (scripts/tmp_[story_id].sh). Updated x-story-executor v3.0.0 (critical task loading rules, automatic loop restart), x-story-reviewer v4.0.0 (two-pass structure), x-story-verifier v10.0.0 (validates Library Research table), ln-334-test-executor v4.0.0 (cleanup temp scripts).

---

## 2025-11-10

**[1.0.0]** Initial plugin release with 17 production-ready skills in 5 categories: Pre-Planning (5 skills), Planning (4), Execution (5), Validation (2), Documentation (1). Features: Complete Agile workflow automation for Linear (MCP integration), Risk-Based Testing (E2E-first, Priority ≥15), Decompose-First Pattern (Epic → Stories → Tasks with KEEP/UPDATE/OBSOLETE/CREATE), Template Ownership, Consumer-First Principle, DAG Documentation Support, Auto-Guide Creation. Plugin manifest + marketplace support, Mermaid diagrams for all skills, comprehensive documentation (CLAUDE.md, README.md), MIT License, 3 installation methods.

---

## 2025-11-21

Decomposed ln-220-story-coordinator v3.0.0 → v4.0.0 (BREAKING: Orchestrator-Worker pattern, 831→409 lines, -51%). Extracted CREATE/REPLAN logic to NEW workers: ln-222-story-creator v1.0.0 (generates 8-section Story documents with Standards Research insertion, validates INVEST criteria, creates in Linear with Epic Grouping Algorithm) and ln-223-story-replanner v1.0.0 (Progressive Loading ONE BY ONE for token efficiency, compares IDEAL vs existing, categorizes KEEP/UPDATE/OBSOLETE/CREATE operations with Story Split/Merge detection, shows diffs for AC/Standards Research/Technical Notes). Coordinator now handles: Context Assembly (Phase 1: Epic extraction + frontend HTML research + fallback search chain), Standards Research delegation to ln-221 (Phase 2), IDEAL planning with vertical slicing + INVEST validation (Phase 3), mode determination via existing Story count (Phase 4), worker delegation to ln-222 or ln-223 (Phase 5a/5b). Token efficiency: 100x reduction in coordinator memory (metadata-only loading: ID/title/status ~50 tokens per Story vs full descriptions ~5,000 tokens loaded by workers when needed, example: 10 Stories = 500 tokens coordinator vs 50,000 tokens workers). story_template_universal.md moved: ln-220/references/ → ln-222/references/ (Template Ownership Principle - Single Source of Truth). ln-200-scope-decomposer v2.0.0 updated references to ln-220 v4.0.0 workflow (Phase 3 sequential Story loop now delegates to ln-220 which routes to ln-222 CREATE or ln-223 REPLAN). Applied same Orchestrator-Worker pattern as ln-310/ln-311/ln-312 (L2 coordinator + L3 CREATE worker + L3 REPLAN worker). Renamed ln-221-library-researcher v1.0.0 → ln-221-standards-researcher v2.0.0 (terminology alignment: focus on RFCs, industry standards, architectural patterns - libraries researched at Task level by ln-310).

---

## Future Releases

### Planned

- Additional workflow optimizations
- Extended integration capabilities
- Community-contributed templates

---

**Links:**
- [Repository](https://github.com/levnikolaevich/claude-code-skills)
- [Issues](https://github.com/levnikolaevich/claude-code-skills/issues)
- [Contributing Guidelines](https://github.com/levnikolaevich/claude-code-skills#contributing)
