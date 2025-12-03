---
description: Restore project context after memory loss or compression
allowed-tools: Read, Edit
---

# Context Refresh (claude-code-skills)

## 🔧 Project Profile Constants
| Variable | Description | Value |
|-----------|--------------|--------|
| `<DOCS_ROOT>` | Documentation folder | `docs` |
| `<ENTRY_FILE>` | Repository entry point | `CLAUDE.md` |
| `<SKILLS_ROOT>` | Skills collection root | `.` |

---

## 1️⃣ Preparation
> Use this procedure when context was cleared, compressed, or lost (e.g., after `/clear` or session reset).
> Goal: fully reload repository structure, skill architecture patterns, and development workflows.

> [!WARNING]
> Before any work with skills, **ALWAYS read** `docs/SKILL_ARCHITECTURE_GUIDE.md` for best practices 2024-2025: Orchestrator-Worker Pattern, Single Responsibility Principle, Token Efficiency, Task Decomposition guidelines, Red Flags.

---

## 2️⃣ Refresh Core Knowledge

### Minimal Anchor (ALWAYS loaded)

**Essential context for orientation (~433 lines, ~15% context):**

- [ ] Read `<ENTRY_FILE>` – repository rules, key concepts (Configuration Auto-Discovery, Task Hierarchy, Development Principles), versioning workflow
- [ ] Read `README.md` (sections: Features tables, Key Concepts) – overview of 29 skills in 3 categories, decomposition workflow, task hierarchy
- [ ] Read `docs/SKILL_ARCHITECTURE_GUIDE.md` (sections: TOC, Core Principles, Orchestrator-Worker Pattern) – industry best practices 2024-2025, SRP, Token Efficiency
- [ ] Read `docs/DOCUMENTATION_STANDARDS`– industry best practices 2024-2025

**After loading the base set:** Proceed to section 3️⃣ Output. Based on current work type, load additional documents from "Deep Dive" below.

---

### Deep Dive (ON DEMAND)

**When working with skill architecture:**
- [ ] Read `docs/SKILL_ARCHITECTURE_GUIDE.md` (full, 835 lines) – complete best practices, checklists, examples
- [ ] Read `docs/DOCUMENTATION_STANDARDS.md` (159 lines) – 82 universal documentation requirements
- [ ] Read `shared/concise_terms.md` (116 lines) – dictionary of 57 term pairs for token optimization

**When creating/editing a skill:**
- [ ] Read specific `{skill}/SKILL.md` (150-400 lines) – skill workflow, phases, metadata
- [ ] Read `{skill}/references/` – templates (Epic/Story/Task), guides, checklists
- [ ] Read `docs/SKILL_ARCHITECTURE_GUIDE.md` (full) – for patterns and anti-patterns

**When working with repository documentation:**
- [ ] Read `CONTRIBUTING.md` (207 lines) – contribution process
- [ ] Read `docs/github_readme_best_practices.md` (432 lines) – GitHub README standards
- [ ] Read `docs/DOCUMENTATION_STANDARDS.md` (159 lines) – documentation requirements

**When working with plugin/marketplace:**
- [ ] Read `docs/PLUGIN_MARKETPLACE_GUIDE.md` (427 lines) – plugin marketplace guide
- [ ] Read `README.md` (section: Installation, lines 160-216) – installation instructions

**When working with Documentation Pipeline (ln-110-115):**
- [ ] Read `ln-110-documents-pipeline/SKILL.md` – L1 orchestrator (11 documents via 5 workers)
- [ ] Read `ln-111-project-docs-creator/SKILL.md` + `references/questions.md` – root + project docs (CLAUDE.md, docs/README.md, standards, principles, requirements, architecture, tech_stack, etc.)
- [ ] Read `ln-112-reference-docs-creator/SKILL.md` – reference structure (adrs/, guides/, manuals/)
- [ ] Read `ln-113-tasks-docs-creator/SKILL.md` – task management (kanban_board.md, Linear integration)
- [ ] Read `ln-114-test-docs-creator/SKILL.md` – testing strategy, Story-Level Test Task Pattern
- [ ] Read `ln-115-presentation-creator/SKILL.md` – interactive HTML presentation

**When working with Planning (ln-200-220):**
- [ ] Read `ln-200-scope-decomposer/SKILL.md` – L1 orchestrator (Scope → Epics → Stories)
- [ ] Read `ln-210-epic-coordinator/SKILL.md` + `references/epic_template_universal.md` – CREATE/REPLAN Epics (3-7 per scope)
- [ ] Read `ln-220-story-coordinator/SKILL.md` + `references/story_template_universal.md` – CREATE/REPLAN Stories (5-10 per Epic)
- [ ] Read `ln-221-library-researcher/SKILL.md` + `references/research_guidelines.md` – library research via MCP Context7/Ref

**When working with Execution (ln-300-350):**
- [ ] Read `ln-300-story-pipeline/SKILL.md` – L1 orchestrator (planning → validation → execution → quality gate)
- [ ] Read `ln-310-story-decomposer/SKILL.md` – L2 coordinator (Story → Tasks, 1-6 tasks)
- [ ] Read `ln-311-task-creator/SKILL.md` + `references/` – CREATE tasks (implementation/refactoring/test templates)
- [ ] Read `ln-312-task-replanner/SKILL.md` – REPLAN tasks (KEEP/UPDATE/OBSOLETE/CREATE)
- [ ] Read `ln-320-story-validator/SKILL.md` + `references/verification_checklist.md` – auto-fix Stories/Tasks (Backlog → Todo)
- [ ] Read `ln-321-best-practices-researcher/SKILL.md` + `references/` – research best practices and create guides/manuals/ADRs (doc_type parameter)
- [ ] Read `ln-330-story-executor/SKILL.md` – L2 coordinator (orchestrate child tasks Todo → Done)
- [ ] Read `ln-331-task-executor/SKILL.md` – L3 worker (execute implementation tasks)
- [ ] Read `ln-332-task-reviewer/SKILL.md` – L3 worker (review tasks To Review → Done/Rework)
- [ ] Read `ln-333-refactoring-executor/SKILL.md` – L3 worker (execute refactoring tasks)
- [ ] Read `ln-334-test-executor/SKILL.md` – L3 worker (execute test tasks)
- [ ] Read `ln-340-story-quality-gate/SKILL.md` + `references/` – L2 coordinator (validate before Done)
- [ ] Read `ln-341-code-review-worker/SKILL.md` – L3 worker (code quality checks)
- [ ] Read `ln-342-security-review-worker/SKILL.md` – L3 worker (security checks)
- [ ] Read `ln-343-performance-review-worker/SKILL.md` – L3 worker (performance checks)
- [ ] Read `ln-350-story-test-planner/SKILL.md` + `references/risk_based_testing_guide.md` – L2 coordinator (create test tasks)

**When working with versioning/release:**
- [ ] Read `CHANGELOG.md` (67 lines) – release history
- [ ] Read `CLAUDE.md` (section: Versioning + Maintenance After Changes, lines 140-183) – version update workflow

---

## 3️⃣ Output After Refresh
After completing the refresh, respond with:

1. **Status:** "✅ Context refreshed (Light mode - ~433 lines)."
2. **Project Summary:** "claude-code-skills — Collection of 29 skills for Claude Code, integrated with Linear for Agile-style task management (Documentation/Planning/Execution)."
3. **Current Work Type:** Identify current work type:
   - **Creating new skill** → need Orchestrator-Worker Pattern, SRP, Token Efficiency
   - **Editing existing skill** → need specific SKILL.md + SKILL_ARCHITECTURE_GUIDE.md
   - **Bug fixing** → need affected skill's SKILL.md + references/
   - **Documentation work** → need DOCUMENTATION_STANDARDS.md + github_readme_best_practices.md
   - **Release/versioning** → need CHANGELOG.md + CLAUDE.md versioning section
4. **Next Steps:** what to work on next based on current development state.
5. **Load Recommendation:** Based on current work type, suggest which additional documents to load from "Deep Dive" sections above.

**Example Output:**
```
✅ Context refreshed (Light mode - ~433 lines).

**Project:** claude-code-skills — Collection of 29 skills for Claude Code, integrated with Linear for Agile-style task management.

**Current Work:** Editing ln-330-story-executor skill (L2 coordinator).

**Next Steps:** Review ln-330-story-executor/SKILL.md, check orchestration logic for child tasks.

**Load Recommendation:**
- Load `ln-330-story-executor/SKILL.md` + `references/`
- Load `docs/SKILL_ARCHITECTURE_GUIDE.md` (full) for Orchestrator-Worker Pattern
- Load `ln-331-task-executor/SKILL.md` + `ln-334-test-executor/SKILL.md` (L3 workers)
```

---

## ⚙️ Maintenance

**File Updates:**
- Update this file if folder structure or document paths change
- Always keep `<ENTRY_FILE>`, `<DOCS_ROOT>`, and `<SKILLS_ROOT>` links valid — these are the minimal anchors needed to restore context
- When adding new skills, add them to corresponding "Deep Dive" section (Documentation/Planning/Execution)

**Content Rules:**
- Keep "Minimal Anchor" under 500 lines total (currently: CLAUDE.md ~183 + README.md ~100 + SKILL_ARCHITECTURE_GUIDE.md ~150 = ~433 lines)
- Add to "Deep Dive" if document grows beyond single-use need
- When repository grows, add new skills to "Deep Dive" sections, NOT to "Minimal Anchor"
- Prefer specific guidance in "Deep Dive" over generic "load all" instructions
- Organize skills by workflow category (Documentation/Planning/Execution), not alphabetically

**Optimization Targets:**
- Light mode refresh: <15% context (~433 lines)
- Medium mode refresh: 15-50% context (433-1500 lines)
- Full mode refresh: 50-75% context (1500-3000 lines)
- Time to refresh: <5 seconds for light mode

**Architecture Reminders:**
- **Orchestrator-Worker Pattern:** L1 (Top Orchestrators) → L2 (Domain Coordinators) → L3 (Workers)
- **Token Efficiency:** Metadata-Only Loading for orchestrators, Full descriptions only for workers
- **Progressive Disclosure:** Load only what's needed for current task
- **Concise Terms Dictionary:** Use shared/concise_terms.md for -30 to -40% token reduction

**Last Updated:** 2025-11-20
