# 👋 Welcome to Claude Code Skills Repository

> A comprehensive collection of skills for Claude Code, providing end-to-end Agile workflow automation integrated with Linear for modern software development teams.

![Version](https://img.shields.io/badge/version-3.0.0-blue) ![Skills](https://img.shields.io/badge/skills-51-green) ![Updated](https://img.shields.io/badge/updated-Dec%202025-orange) ![License](https://img.shields.io/badge/license-MIT-green) [![GitHub stars](https://img.shields.io/github/stars/levnikolaevich/claude-code-skills?style=social)](https://github.com/levnikolaevich/claude-code-skills)

---

## 📖 About

This repository contains **51 production-ready skills** for [Claude Code](https://claude.ai/code) that automate and streamline your entire software development lifecycle. From initial documentation to story execution and quality assurance, these skills work together to create a complete Agile development workflow.

**What You Get:**
- 🎯 **Complete Agile Workflow** - From Epic decomposition to task execution and review
- 📋 **Linear Integration** - Seamless task management and tracking
- 🔄 **Automated Workflows** - Intelligent orchestration of development tasks
- 📊 **Visual Documentation** - Mermaid diagrams for every skill workflow
- 🏗️ **Best Practices Built-In** - KISS/YAGNI/DRY principles, Risk-Based Testing, Industry Standards compliance

**Perfect For:**
- Software development teams using Agile methodologies
- Projects integrated with Linear for task management
- Teams seeking to automate repetitive development workflows
- Organizations wanting to standardize their development practices

---

## 🚀 Features

### 0. Shared & Research Workers (0XX)

Universal research workers for standards, best practices, and architectural patterns. Used across Planning, Task Management, and Quality workflows.

| Skill | Purpose | Version | Diagrams |
|:------|:--------|:-------:|:--------:|
| **[ln-001-standards-researcher](ln-001-standards-researcher/)** | Research industry standards, RFCs, and architectural patterns via MCP Context7 + MCP Ref. Generates Standards Research (Markdown format) for insertion in Story Technical Notes → Library Research subsection. Reusable worker (called by ln-220 Phase 2). Libraries researched at Task level by ln-300. Time-boxed: 15-20 minutes. | 3.0.0 | ✅ |
| **[ln-002-best-practices-researcher](ln-002-best-practices-researcher/)** | Research best practices via MCP Ref/Context7 and create documentation (guide/manual/ADR). Single research, multiple output types. Reusable worker (called by ln-310, ln-620). | 3.0.0 | ✅ |

---

### 1. Documentation System (1XX)

**ln-100-documents-pipeline** (L1 Top Orchestrator) manages complete documentation lifecycle with 3-tier architecture and global cleanup (Phase 4).

**L1 Top Orchestrator:**

| Skill | Purpose | Version | Diagrams |
|:------|:--------|:-------:|:--------:|
| **[ln-100-documents-pipeline](ln-100-documents-pipeline/)** | **L1 Top Orchestrator** that creates complete documentation system in one command. Invokes L2 coordinator (ln-110) + 4 L2 workers (ln-120-150). **Phase 4**: Global cleanup (deduplication, orphaned files, consolidation, cross-links). **Idempotent**: Pre-flight check shows existing/missing files. | 3.0.0 | ✅ |

**L2 Coordinator (Project Documentation):**

| Skill | Purpose | Version | Diagrams |
|:------|:--------|:-------:|:--------:|
| **[ln-110-project-docs-coordinator](ln-110-project-docs-coordinator/)** | **L2 Coordinator** that gathers context ONCE, detects project type (hasBackend, hasFrontend, hasDatabase, hasDocker), delegates to 5 L3 workers. Solves "context loss" problem by passing Context Store explicitly. | 3.0.0 | ✅ |

**L3 Workers (Project Documentation - under ln-110):**

| Skill | Purpose | Version | Diagrams |
|:------|:--------|:-------:|:--------:|
| **[ln-111-root-docs-creator](ln-111-root-docs-creator/)** | Create 4 root docs: CLAUDE.md, docs/README.md, documentation_standards.md, principles.md. ALWAYS invoked. | 3.0.0 | ✅ |
| **[ln-112-project-core-creator](ln-112-project-core-creator/)** | Create 3 core project docs: requirements.md, architecture.md, tech_stack.md. ALWAYS invoked. High auto-discovery. | 3.0.0 | ✅ |
| **[ln-113-backend-docs-creator](ln-113-backend-docs-creator/)** | Create 2 conditional docs: api_spec.md (if hasBackend), database_schema.md (if hasDatabase). | 3.0.0 | ✅ |
| **[ln-114-frontend-docs-creator](ln-114-frontend-docs-creator/)** | Create 1 conditional doc: design_guidelines.md (if hasFrontend). WCAG 2.1 compliant. | 3.0.0 | ✅ |
| **[ln-115-devops-docs-creator](ln-115-devops-docs-creator/)** | Create 1 conditional doc: runbook.md (if hasDocker). Operations guide. | 3.0.0 | ✅ |

**L2 Workers (Other Documentation):**

| Skill | Purpose | Version | Diagrams |
|:------|:--------|:-------:|:--------:|
| **[ln-120-reference-docs-creator](ln-120-reference-docs-creator/)** | Create reference documentation structure: docs/reference/README.md + adrs/, guides/, manuals/ directories. **Idempotent**: Checks 4 items. | 3.0.0 | ✅ |
| **[ln-130-tasks-docs-creator](ln-130-tasks-docs-creator/)** | Create task management documentation: docs/tasks/README.md (task system rules) + kanban_board.md (Linear integration). **Idempotent**: Critical kanban_board.md protection. | 3.0.0 | ✅ |
| **[ln-140-test-docs-creator](ln-140-test-docs-creator/)** | Create test documentation: testing-strategy.md (universal testing philosophy) + tests/README.md (organization with Story-Level Pattern). Optional. **Idempotent**: Checks 4 items. | 3.0.0 | ✅ |
| **[ln-150-presentation-creator](ln-150-presentation-creator/)** | Build interactive HTML presentation from project documentation with 6 tabs (Overview, Requirements+ADRs, Architecture, Technical Spec, Roadmap, Guides). **Idempotent**: User confirmation for rebuild. | 3.0.0 | ✅ |

---

### 2. Planning (2XX)

Orchestrator-Worker Pattern applied to decomposition workflow. **ln-200-scope-decomposer** (TOP orchestrator) automates full decomposition (scope → Epics → Stories) by delegating to **ln-210-epic-coordinator** (CREATE/REPLAN Epics) → **ln-220-story-coordinator** (CREATE/REPLAN Stories with Phase 2 standards research via **ln-001-standards-researcher**) → **ln-230-story-prioritizer** (RICE prioritization per Story with market research).

**Orchestrator:**

| Skill | Purpose | Version | Diagrams |
|:------|:--------|:-------:|:--------:|
| **[ln-200-scope-decomposer](ln-200-scope-decomposer/)** | **TOP Orchestrator** for full decomposition automation (scope → Epics → Stories). Sequentially delegates: ln-210-epic-coordinator (Phase 2) → ln-220-story-coordinator loop per Epic (Phase 3). User confirmation required (Phase 1). Provides summary + next steps (Phase 4). | 3.0.0 | ✅ |

**Coordinators:**

| Skill | Purpose | Version | Diagrams |
|:------|:--------|:-------:|:--------:|
| **[ln-210-epic-coordinator](ln-210-epic-coordinator/)** | **Domain Coordinator** that decomposes scope into 3-7 Linear Projects (Epics) with business goals, success criteria, and phased strategy. Decompose-First Pattern: builds IDEAL plan → checks existing → CREATE/REPLAN mode (KEEP/UPDATE/OBSOLETE/CREATE). Auto-discovers team ID. | 3.0.0 | ✅ |
| **[ln-220-story-coordinator](ln-220-story-coordinator/)** | **Coordinator** for Story operations. Context Assembly (Phase 1: Epic extraction, frontend research, fallback search) → Standards Research (Phase 2: delegates **ln-001-standards-researcher**) → IDEAL Planning (Phase 3: 5-10 Stories, INVEST validation) → Mode Determination (Phase 4: count existing) → Delegates CREATE (**ln-221-story-creator**) or REPLAN (**ln-222-story-replanner**). Token efficiency: metadata-only loading (ID/title/status ~50 tokens/Story), workers load full descriptions (~5,000 tokens) when needed. | 3.0.0 | ✅ |

**Workers (CREATE/REPLAN path - ln-220):**

| Skill | Purpose | Version | Diagrams |
|:------|:--------|:-------:|:--------:|
| **[ln-221-story-creator](ln-221-story-creator/)** | Creates Stories from IDEAL plan (ln-220 Phase 5a). Generates 8-section documents with Standards Research insertion (Technical Notes), validates INVEST criteria, shows preview, creates in Linear (project=Epic, labels=user-story, state=Backlog), updates kanban_board.md via Epic Grouping Algorithm. First-time Epic decomposition. Owns story_template_universal.md. | 3.0.0 | ✅ |
| **[ln-222-story-replanner](ln-222-story-replanner/)** | Replans Stories when Epic requirements change (ln-220 Phase 5b). Progressive Loading (ONE BY ONE for token efficiency: ~5,000 tokens/Story), compares IDEAL vs existing, categorizes operations (KEEP/UPDATE/OBSOLETE/CREATE), shows diffs (AC, Standards Research, Technical Notes), user confirmation, executes updates (respects status constraints: Backlog/Todo only), updates kanban_board.md. Story Split/Merge detection. | 3.0.0 | ✅ |

**Story Prioritization (after ln-220):**

| Skill | Purpose | Version | Diagrams |
|:------|:--------|:-------:|:--------:|
| **[ln-230-story-prioritizer](ln-230-story-prioritizer/)** | **L2 Worker** for Story-level RICE prioritization after ln-220. Loads Stories from Epic, researches market size and competition per Story via WebSearch/Ref, calculates RICE score (Reach × Impact × Confidence / Effort), assigns Priority (P0-P3) with Competition Index (Blue 1-2 / Red 4-5). Generates consolidated table in docs/market/[epic-slug]/prioritization.md. Time-boxed: 40-60 minutes. | 3.0.0 | ✅ |

---

### 3. Task Management (3XX)

Task planning and Story validation workflows. **ln-300-task-coordinator** decomposes Stories into 1-6 implementation tasks. **ln-310-story-validator** validates Stories/Tasks against 2025 standards (CRITICAL PATH FIRST) with auto-fixes and research via **ln-002-best-practices-researcher**.

**Coordinators:**

| Skill | Purpose | Version | Diagrams |
|:------|:--------|:-------:|:--------:|
| **[ln-300-task-coordinator](ln-300-task-coordinator/)** | **Coordinator** for task operations. Analyzes Story, builds optimal task plan (1-6 tasks, Foundation-First execution order), delegates to ln-301-task-creator (CREATE) or ln-302-task-replanner (REPLAN) with `taskType: "implementation"`. Auto-discovers team ID. For implementation tasks only. | 3.0.0 | ✅ |
| **[ln-310-story-validator](ln-310-story-validator/)** | **Coordinator** that validates Stories/Tasks against 2025 standards - CRITICAL PATH FIRST. Phase 2: Research via ln-002 (domain extraction, TRIVIAL CRUD detection). Phase 3: Decision Point (REPLAN ≥50% improvement OR CONTINUE). Phase 4: Auto-fixes 17 criteria (Progressive Disclosure: 5 validation files). No direct MCP calls. Tabular output (Unicode box-drawing). Upstream validation (ln-220). No "Needs Work" path exists. | 3.0.0 | ✅ |

**Workers (CREATE/REPLAN path - ln-300):**

| Skill | Purpose | Version | Diagrams |
|:------|:--------|:-------:|:--------:|
| **[ln-301-task-creator](ln-301-task-creator/)** | **Universal factory** for creating ALL 3 task types (implementation, refactoring, test). Generates task documents from templates, validates type-specific rules, creates in Linear. **DRY Check:** Scans codebase (Grep) for similar functionality, adds warnings to Task descriptions with reuse/extend/justify recommendations (≥70% similarity). Invoked by orchestrators (ln-300-task-coordinator, ln-500-story-quality-gate, ln-510-test-planner). Owns all 3 templates. | 3.0.0 | ✅ |
| **[ln-302-task-replanner](ln-302-task-replanner/)** | **Universal replanner** for updating ALL 3 task types (implementation, refactoring, test). Compares IDEAL plan vs existing, categorizes operations (KEEP/UPDATE/OBSOLETE/CREATE), applies type-specific validation, executes changes in Linear. Reads templates from ln-301-task-creator/references/. | 3.0.0 | ✅ |

---

### 4. Execution (4XX)

**ln-400-story-executor** (Orchestrator) automates complete Story workflow with priority-based task execution (To Review → To Rework → Todo) and automatic quality gates delegation.

**Orchestrator:**

| Skill | Purpose | Version | Diagrams |
|:------|:--------|:-------:|:--------:|
| **[ln-400-story-executor](ln-400-story-executor/)** | **Orchestrator** that orchestrates Story execution (Todo → In Progress → To Review → Done). **Priority 0: Backlog** (auto-verify new tasks before execution) → **Priority 1: To Review** → **Priority 2: To Rework** → **Priority 3: Todo**. Auto-invokes ln-500-story-quality-gate Pass 1 + Pass 2 (full automation). Phase 4 delegates Story quality to ln-500-story-quality-gate (Orchestrator-Worker Pattern). | 3.0.0 | ✅ |

**Workers (Task Execution):**

| Skill | Purpose | Version | Diagrams |
|:------|:--------|:-------:|:--------:|
| **[ln-401-task-executor](ln-401-task-executor/)** | Execute implementation tasks ONLY (Todo → In Progress → To Review). Uses KISS/YAGNI principles, reads guide links, runs type checking and linting. Story status management removed (now ln-400-story-executor's responsibility). NOT for test tasks. | 3.0.0 | ✅ |
| **[ln-402-task-reviewer](ln-402-task-reviewer/)** | Review completed tasks for To Review → Done/Rework transition. Distinguishes test/implementation tasks. Checks architecture, docs, security, quality, and test coverage. | 3.0.0 | ✅ |
| **[ln-403-task-rework](ln-403-task-rework/)** | Fix tasks marked To Rework. Analyzes feedback, applies fixes following KISS/YAGNI/DRY principles, runs quality gates (type checking, linting), and submits back To Review. | 3.0.0 | ✅ |
| **[ln-404-test-executor](ln-404-test-executor/)** | Execute Story Finalizer test tasks (Todo → In Progress → To Review). E2E-first Risk-Based Testing (2-5 E2E, 3-8 Integration, 5-15 Unit). Includes test fixes, infrastructure, docs, and legacy cleanup. | 3.0.0 | ✅ |

---

### 5. Quality (5XX)

**ln-500-story-quality-gate** (Coordinator) validates Story quality with Pass 1 (code quality, regression, manual AC) and Pass 2 (automated tests). **ln-510-test-planner** creates comprehensive test tasks after manual testing passes.

**Quality Gate (Coordinator):**

| Skill | Purpose | Version | Diagrams |
|:------|:--------|:-------:|:--------:|
| **[ln-500-story-quality-gate](ln-500-story-quality-gate/)** | **Coordinator** for Story quality. Pass 1 delegates code analysis to `ln-501-code-quality-checker`, regression to `ln-502-regression-checker`, manual AC verification to `ln-503-manual-tester` (Format v1.0) with FAIL-FAST exit at each gate; auto-creates refactor/bug tasks when any gate fails. When all gates pass, automatically runs `ln-510-test-planner` (`autoApprove: true`) to create Story Finalizer test task. Pass 2 verifies automated tests (Priority >=15, limits 10-28) and moves Story to Done. | 3.0.0 | ✅ |

**Workers (Pass 1 Validation):**

| Skill | Purpose | Version | Diagrams |
|:------|:--------|:-------:|:--------:|
| **[ln-501-code-quality-checker](ln-501-code-quality-checker/)** | Analyze code quality for DRY/KISS/YAGNI/Architecture violations and guide compliance. Checks git diffs of Done implementation tasks. Reports structured issues by severity (HIGH/MEDIUM/LOW). Fail Fast principle - runs FIRST in Phase 4. | 3.0.0 | ✅ |
| **[ln-502-regression-checker](ln-502-regression-checker/)** | Run existing test suite to verify no regressions. Auto-detects framework (pytest/jest/vitest/go test). Returns JSON verdict + Linear comment. Atomic worker - does NOT create tasks or change statuses. | 3.0.0 | ✅ |
| **[ln-503-manual-tester](ln-503-manual-tester/)** | Perform manual functional testing of Story AC using curl (API) or puppeteer (UI). Tests main scenarios + edge cases + error handling + integration. Creates reusable temp script `scripts/tmp_[story_id].sh`. Documents results in Linear (Format v1.0). | 3.0.0 | ✅ |

**Test Planning:**

| Skill | Purpose | Version | Diagrams |
|:------|:--------|:-------:|:--------:|
| **[ln-510-test-planner](ln-510-test-planner/)** | **Coordinator** that creates test task for Story after manual testing passes. Analyzes Story, generates comprehensive test task with 11 sections. **Delegates to ln-301-task-creator (CREATE) or ln-302-task-replanner (REPLAN)** with `taskType: "test"`. Supports existing test task updates. Uses 3XX workers for task creation/replanning. | 3.0.0 | ✅ |

---

### 6. Audit (6XX)

Comprehensive audit system for documentation, code comments, codebase quality, and test suites. All coordinators research best practices ONCE and delegate to specialized workers IN PARALLEL.

**Documentation & Comments Audit:**

| Skill | Purpose | Version | Diagrams |
|:------|:--------|:-------:|:--------:|
| **[ln-600-docs-auditor](ln-600-docs-auditor/)** | Audit documentation quality across 6 categories (Hierarchy, SSOT, Compactness, Requirements, Actuality, Legacy). Outputs Compliance Score X/10 + Findings. User-invocable or part of ln-100 pipeline. | 3.0.0 | ✅ |
| **[ln-610-code-comments-auditor](ln-610-code-comments-auditor/)** | Audit code comments and docstrings across 6 categories (WHY-not-WHAT, Density, Forbidden, Docstrings, Actuality, Legacy). Universal for any tech stack. | 3.0.0 | ✅ |

**Codebase Quality Audit:**

| Skill | Purpose | Version | Diagrams |
|:------|:--------|:-------:|:--------:|
| **[ln-620-codebase-auditor](ln-620-codebase-auditor/)** | **L2 Coordinator** that orchestrates complete codebase quality audit. Researches best practices ONCE, delegates to 9 specialized workers IN PARALLEL, aggregates results into single consolidated report. Creates refactoring task in Linear Epic 0. Manual invocation for technical debt assessment. | 3.0.0 | ✅ |

**Workers (L3 Codebase Audit Specialists):**

| # | Skill | Priority | What It Audits | Version |
|:---:|:------|:--------:|:---------------|:-------:|
| 1 | **[ln-621-security-auditor](ln-621-security-auditor/)** | CRITICAL | Hardcoded secrets, SQL injection, XSS, insecure dependencies, missing input validation | 3.0.0 |
| 2 | **[ln-622-build-auditor](ln-622-build-auditor/)** | CRITICAL | Compiler/linter errors, deprecation warnings, type errors, failed tests, build config | 3.0.0 |
| 3 | **[ln-623-architecture-auditor](ln-623-architecture-auditor/)** | HIGH | DRY/KISS/YAGNI violations, layer breaks, TODO/FIXME, workarounds, error handling | 3.0.0 |
| 4 | **[ln-624-code-quality-auditor](ln-624-code-quality-auditor/)** | MEDIUM | Cyclomatic complexity, O(n²), N+1 queries, **magic numbers**, **duplicate constants** | 3.0.0 |
| 5 | **[ln-625-dependencies-auditor](ln-625-dependencies-auditor/)** | MEDIUM | Outdated packages, unused dependencies, reinvented wheels, custom implementations | 3.0.0 |
| 6 | **[ln-626-dead-code-auditor](ln-626-dead-code-auditor/)** | LOW | Unreachable code, unused imports/variables/functions, commented-out code | 3.0.0 |
| 7 | **[ln-627-observability-auditor](ln-627-observability-auditor/)** | MEDIUM | Structured logging, health checks, metrics, request tracing, log levels | 3.0.0 |
| 8 | **[ln-628-concurrency-auditor](ln-628-concurrency-auditor/)** | HIGH | Race conditions, async/await, resource contention, thread safety, deadlocks | 3.0.0 |
| 9 | **[ln-629-lifecycle-auditor](ln-629-lifecycle-auditor/)** | MEDIUM | Bootstrap, graceful shutdown, resource cleanup, signal handling, probes | 3.0.0 |

**Test Suite Audit:**

| Skill | Purpose | Version | Diagrams |
|:------|:--------|:-------:|:--------:|
| **[ln-630-test-auditor](ln-630-test-auditor/)** | **L2 Coordinator** that orchestrates comprehensive test suite audit. Researches testing best practices ONCE, delegates to 5 specialized workers IN PARALLEL, aggregates results into unified audit report with KEEP/REMOVE/REVIEW decisions. Calculates **Usefulness Score** per test (Impact × Probability). Creates refactoring task in Linear Epic 0. Manual invocation for test suite quality assessment. | 3.0.0 | ✅ |

**Workers (L3 Test Audit Specialists):**

| # | Skill | Category | What It Audits | Version |
|:---:|:------|:--------:|:---------------|:-------:|
| 1 | **[ln-631-test-business-logic-auditor](ln-631-test-business-logic-auditor/)** | Business Logic Focus | Framework/library tests (Prisma, Express, bcrypt, JWT, axios, React hooks) → REMOVE | 3.0.0 |
| 2 | **[ln-632-test-e2e-priority-auditor](ln-632-test-e2e-priority-auditor/)** | E2E Priority | E2E baseline (2/endpoint: positive + negative), pyramid validation, missing E2E tests | 3.0.0 |
| 3 | **[ln-633-test-value-auditor](ln-633-test-value-auditor/)** | Risk-Based Value | Usefulness Score = Impact (1-5) × Probability (1-5). Thresholds: ≥15 KEEP, 10-14 REVIEW, <10 REMOVE | 3.0.0 |
| 4 | **[ln-634-test-coverage-auditor](ln-634-test-coverage-auditor/)** | Coverage Gaps | Missing tests for critical paths (Money 20+, Security 20+, Data 15+, Core Flows 15+) | 3.0.0 |
| 5 | **[ln-635-test-isolation-auditor](ln-635-test-isolation-auditor/)** | Isolation + Anti-Patterns | Isolation (APIs, DB, FS, Time, Random, Network), Anti-Patterns (Liar, Giant, Slow Poke, Conjoined Twins, Happy Path Only, Framework Tester) | 3.0.0 |

---

## 📥 Installation

### Choose Your Plugin

Select the plugin that matches your team's needs:

| Plugin | Skills | Use Case | Dependencies |
|--------|--------|----------|--------------|
| **complete** ⭐ | 33 | Full workflow automation (docs + planning + execution) | Linear + Context7 + Ref |
| **docs** | 10 | Documentation automation only | None (standalone) |
| **planning** | 4 | Epic/Story decomposition | Linear + Context7 + Ref |
| **execution** | 19 | Story execution pipeline | Linear + Context7 + Ref |

---

### Installation Methods

**Prerequisites:** [Claude Code CLI](https://claude.ai/code) installed

Choose your installation method:

**Method 1: Plugin Marketplace (Recommended)**
```bash
/plugin marketplace add levnikolaevich/claude-code-skills

# Install complete plugin (recommended for most teams)
/plugin install agile-linear-workflow-complete@agile-linear-workflow-marketplace

# Or install specific plugin
/plugin install agile-linear-workflow-docs@agile-linear-workflow-marketplace
/plugin install agile-linear-workflow-planning@agile-linear-workflow-marketplace
/plugin install agile-linear-workflow-execution@agile-linear-workflow-marketplace

# Verify installation
/skills
```

**Method 2: Direct Plugin**
```bash
/plugin add levnikolaevich/claude-code-skills
/skills  # Verify installation
```

**Method 3: Git Clone**
```bash
# macOS/Linux
git clone https://github.com/levnikolaevich/claude-code-skills.git ~/.claude/skills

# Windows
git clone https://github.com/levnikolaevich/claude-code-skills.git %USERPROFILE%\.claude\skills

# Verify
/skills
```

> 📖 For detailed setup, updates, and configuration, see [Advanced Setup](#-advanced-setup) section below.

---

## 📊 Visual Documentation

Every skill includes workflow diagrams (`diagram.html`) that visualize execution flow, decision points, and state transitions. Diagrams use Mermaid format and work locally without any server setup.

---

## 💡 Usage

### Quick Start Example

**Creating Project Documentation:**
```bash
# In Claude Code, invoke the skill
ln-100-documents-pipeline
# Follow the interactive prompts to generate comprehensive documentation
```

**Decomposing Epic into Stories:**
```bash
# Invoke story coordinator with Epic number
ln-220-story-coordinator
# Skill will analyze Epic and create/replan Stories automatically
```

**Executing a Story:**
```bash
# Invoke story executor with Story ID
ln-330-story-executor
# Skill will orchestrate task execution, reviews, and rework
```

### Typical Workflow

**Automated Workflow:**
```
1. ln-100-documents-pipeline → Create project documentation
2. ln-210-epic-coordinator   → Decompose scope into Epics
3. ln-220-story-coordinator  → Create Stories for an Epic (with library research)
4. ln-400-story-executor     → Complete automation from task planning to Done
   └─ Orchestrates: task execution → review → rework → quality gates
```

**For manual step-by-step workflow and detailed usage, see [CLAUDE.md](CLAUDE.md).**

---

## 🔧 Advanced Setup

### Prerequisites

Before installation, ensure you have:

- **Claude Code CLI** - Install from [claude.ai/code](https://claude.ai/code)
- **Git** - Required for Method 3 (Git Clone) installation
- **Linear Account** (optional) - For task management integration features
  - Create API key at [linear.app/settings/api](https://linear.app/settings/api)
  - Configure team ID in `docs/tasks/kanban_board.md` (auto-generated by ln-130-tasks-docs-creator)

### Updating

**For Plugin installations (Method 1 or 2):**
```bash
/plugin update agile-linear-workflow
```

**For Git Clone installation (Method 3):**
```bash
# Navigate to skills directory
cd ~/.claude/skills                    # macOS/Linux
cd %USERPROFILE%\.claude\skills       # Windows CMD
cd $env:USERPROFILE\.claude\skills    # Windows PowerShell

# Pull latest changes
git pull origin master
```

### Configuration

**Linear Integration (Optional):** Skills auto-discover configuration from `docs/tasks/kanban_board.md` (Team ID, Epic/Story numbers). Run `ln-130-tasks-docs-creator` to generate config file. No setup required - skills work independently.

---

## 🤝 Contributing

**We warmly welcome contributions!** 🎉

Whether you're fixing bugs, improving documentation, adding features, or creating new skills - your contributions make this project better for everyone.

**How to contribute:**
- Fork → Create feature branch → Submit PR
- Bug fixes, documentation improvements, new skills, translations

**See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed guidelines.**

---

## 📚 Documentation

### Core Documentation

- **[CLAUDE.md](CLAUDE.md)** - Comprehensive guide with:
  - Repository structure and skill organization
  - Task hierarchy (Epic → Story → Task)
  - Development principles (KISS/YAGNI/DRY, Standards First, Risk-Based Testing)
  - Complete workflow documentation for all skills
  - Template references and best practices
  - Linear integration details

### Skill Structure

Each skill follows a unified structure:
```
x-skill-name/
├── SKILL.md              # Metadata and full description
├── diagram.html          # Standalone HTML with embedded Mermaid diagram
└── references/           # Templates and guides
    ├── template.md       # Document templates
    └── guide.md          # Reference guides

shared/
└── css/
    └── diagram.css       # Universal CSS for all diagrams
```

### Template Ownership Principle

- Each skill owns its templates in its own `references/` directory (Single Source of Truth)
- Templates are NOT copied to project during setup
- Skills use templates directly from their `references/` when generating documents
- Example: ln-321-best-practices-researcher uses `ln-321-best-practices-researcher/references/adr_template.md` when creating ADRs

---

## 🌟 Key Concepts

### Task Hierarchy
```
Epic (Linear Project)
  └── User Story (Linear Issue with label "user-story")
      └── Task (Linear Issue with parentId=Story ID)
          └── Subtask (implementation steps)
```

### Development Principles

**Hierarchy of Principles (when conflicts arise):**
1. **Industry Standards & RFCs** (OAuth 2.0, REST API design, OpenAPI, protocol standards)
2. **Security Standards** (OWASP Top 10, NIST guidelines)
3. **Development Principles** (KISS/YAGNI/DRY apply WITHIN standard boundaries)

**Core Principles:**
- **Standards First** - Follow industry standards before applying KISS/YAGNI
- **YAGNI** - Do not add functionality ahead of time
- **KISS** - Simplest solution that works (within standard boundaries)
- **DRY** - Do not duplicate code
- **Consumer-First Design** - Design APIs/interfaces from consumer perspective (what they need first)
- **Foundation-First Execution** - Build from foundation up (Database → Repository → Service → API) for testability
- **Task Granularity** - Optimal task size 3-5 hours (max 6 tasks per Story)
- **Value-Based Testing** - Prioritize by business risk (2-5 E2E, 3-8 Integration, 5-15 Unit per Story)
- **No Legacy Code** - Remove backward compatibility shims and deprecated patterns

---

## 📄 License

This project is licensed under the MIT License - see the repository for details.

Feel free to use, modify, and distribute this software in your projects!

---

## 🙏 Acknowledgments

- **Claude Code Team** - For creating an amazing AI-powered development environment
- **Linear Team** - For excellent task management and API
- **Mermaid.js** - For beautiful, git-friendly diagrams
- **Community Contributors** - Thank you for making this project better!

---

## 👤 Author

**Lev Nikolaevich**
- GitHub: [@levnikolaevich](https://github.com/levnikolaevich)
- Repository: [claude-code-skills](https://github.com/levnikolaevich/claude-code-skills)

---

## 📬 Questions or Feedback?

- 💬 **Discussions** - Share ideas and ask questions in [GitHub Discussions](https://github.com/levnikolaevich/claude-code-skills/discussions)
- 🐛 **Issues** - Report bugs or request features via [GitHub Issues](https://github.com/levnikolaevich/claude-code-skills/issues)
- ⭐ **Star this repo** - If you find it useful!

---

<div align="center">

**Happy Coding! 🚀**

*Built with ❤️ by the community, for the community*

</div>
