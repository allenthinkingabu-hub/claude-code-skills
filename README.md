# 👋 Welcome to Claude Code Skills Repository

> A comprehensive collection of skills for Claude Code, providing end-to-end Agile workflow automation integrated with Linear for modern software development teams.

![Version](https://img.shields.io/badge/version-10.1.0-blue) ![Skills](https://img.shields.io/badge/skills-37-green) ![Updated](https://img.shields.io/badge/updated-Nov%202025-orange) ![License](https://img.shields.io/badge/license-MIT-green) [![GitHub stars](https://img.shields.io/github/stars/levnikolaevich/claude-code-skills?style=social)](https://github.com/levnikolaevich/claude-code-skills)

---

## 📖 About

This repository contains **37 production-ready skills** for [Claude Code](https://claude.ai/code) that automate and streamline your entire software development lifecycle. From initial documentation to story execution and quality assurance, these skills work together to create a complete Agile development workflow.

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

### 1. Documentation System (1XX)

**ln-100-documents-pipeline** (L1 Top Orchestrator) manages complete documentation lifecycle with 3-tier architecture and global cleanup (Phase 4).

**L1 Top Orchestrator:**

| Skill | Purpose | Version | Diagrams |
|:------|:--------|:-------:|:--------:|
| **[ln-100-documents-pipeline](ln-100-documents-pipeline/)** | **L1 Top Orchestrator** that creates complete documentation system in one command. Invokes L2 coordinator (ln-110) + 4 L2 workers (ln-120-150). **Phase 4**: Global cleanup (deduplication, orphaned files, consolidation, cross-links). **Idempotent**: Pre-flight check shows existing/missing files. | 8.0.0 | ✅ |

**L2 Coordinator (Project Documentation):**

| Skill | Purpose | Version | Diagrams |
|:------|:--------|:-------:|:--------:|
| **[ln-110-project-docs-coordinator](ln-110-project-docs-coordinator/)** | **L2 Coordinator** that gathers context ONCE, detects project type (hasBackend, hasFrontend, hasDatabase, hasDocker), delegates to 5 L3 workers. Solves "context loss" problem by passing Context Store explicitly. | 2.0.0 | ✅ |

**L3 Workers (Project Documentation - under ln-110):**

| Skill | Purpose | Version | Diagrams |
|:------|:--------|:-------:|:--------:|
| **[ln-111-root-docs-creator](ln-111-root-docs-creator/)** | Create 4 root docs: CLAUDE.md, docs/README.md, documentation_standards.md, principles.md. ALWAYS invoked. | 2.0.0 | ✅ |
| **[ln-112-project-core-creator](ln-112-project-core-creator/)** | Create 3 core project docs: requirements.md, architecture.md, tech_stack.md. ALWAYS invoked. High auto-discovery. | 2.0.0 | ✅ |
| **[ln-113-backend-docs-creator](ln-113-backend-docs-creator/)** | Create 2 conditional docs: api_spec.md (if hasBackend), database_schema.md (if hasDatabase). | 1.0.0 | ✅ |
| **[ln-114-frontend-docs-creator](ln-114-frontend-docs-creator/)** | Create 1 conditional doc: design_guidelines.md (if hasFrontend). WCAG 2.1 compliant. | 1.0.0 | ✅ |
| **[ln-115-devops-docs-creator](ln-115-devops-docs-creator/)** | Create 1 conditional doc: runbook.md (if hasDocker). Operations guide. | 1.0.0 | ✅ |

**L2 Workers (Other Documentation):**

| Skill | Purpose | Version | Diagrams |
|:------|:--------|:-------:|:--------:|
| **[ln-120-reference-docs-creator](ln-120-reference-docs-creator/)** | Create reference documentation structure: docs/reference/README.md + adrs/, guides/, manuals/ directories. **Idempotent**: Checks 4 items. | 8.0.0 | ✅ |
| **[ln-130-tasks-docs-creator](ln-130-tasks-docs-creator/)** | Create task management documentation: docs/tasks/README.md (task system rules) + kanban_board.md (Linear integration). **Idempotent**: Critical kanban_board.md protection. | 7.0.0 | ✅ |
| **[ln-140-test-docs-creator](ln-140-test-docs-creator/)** | Create test documentation: testing-strategy.md (universal testing philosophy) + tests/README.md (organization with Story-Level Pattern). Optional. **Idempotent**: Checks 4 items. | 7.0.0 | ✅ |
| **[ln-150-presentation-creator](ln-150-presentation-creator/)** | Build interactive HTML presentation from project documentation with 6 tabs (Overview, Requirements+ADRs, Architecture, Technical Spec, Roadmap, Guides). **Idempotent**: User confirmation for rebuild. | 8.0.0 | ✅ |
| **[ln-160-docs-auditor](ln-160-docs-auditor/)** | Audit documentation quality across 6 categories (Hierarchy, SSOT, Compactness, Requirements, Actuality, Legacy). Outputs Compliance Score X/10 + Findings. User-invocable or part of ln-100 pipeline. | 1.0.0 | ✅ |
| **[ln-170-code-comments-auditor](ln-170-code-comments-auditor/)** | Audit code comments and docstrings across 6 categories (WHY-not-WHAT, Density, Forbidden, Docstrings, Actuality, Legacy). Universal for any tech stack. | 1.0.0 | ✅ |

---

### 2. Planning (200-range)

Orchestrator-Worker Pattern applied to decomposition workflow. **ln-200-scope-decomposer** (TOP orchestrator) automates full decomposition (scope → Epics → Stories) by delegating to **ln-210-epic-coordinator** (CREATE/REPLAN Epics) → **ln-220-story-coordinator** (CREATE/REPLAN Stories with Phase 2 standards research via **ln-221-standards-researcher**).

**Orchestrator:**

| Skill | Purpose | Version | Diagrams |
|:------|:--------|:-------:|:--------:|
| **[ln-200-scope-decomposer](ln-200-scope-decomposer/)** | **TOP Orchestrator** for full decomposition automation (scope → Epics → Stories). Sequentially delegates: ln-210-epic-coordinator (Phase 2) → ln-220-story-coordinator loop per Epic (Phase 3). User confirmation required (Phase 1). Provides summary + next steps (Phase 4). | 2.0.0 | ✅ |

**Coordinators:**

| Skill | Purpose | Version | Diagrams |
|:------|:--------|:-------:|:--------:|
| **[ln-210-epic-coordinator](ln-210-epic-coordinator/)** | **Domain Coordinator** that decomposes scope into 3-7 Linear Projects (Epics) with business goals, success criteria, and phased strategy. Decompose-First Pattern: builds IDEAL plan → checks existing → CREATE/REPLAN mode (KEEP/UPDATE/OBSOLETE/CREATE). Auto-discovers team ID. | 7.0.0 | ✅ |
| **[ln-220-story-coordinator](ln-220-story-coordinator/)** | **Coordinator** for Story operations. Context Assembly (Phase 1: Epic extraction, frontend research, fallback search) → Standards Research (Phase 2: delegates **ln-221-standards-researcher**) → IDEAL Planning (Phase 3: 5-10 Stories, INVEST validation) → Mode Determination (Phase 4: count existing) → Delegates CREATE (**ln-222-story-creator**) or REPLAN (**ln-223-story-replanner**). Token efficiency: metadata-only loading (ID/title/status ~50 tokens/Story), workers load full descriptions (~5,000 tokens) when needed. | 4.0.0 | ✅ |

**Worker (Standards Research - ln-220):**

| Skill | Purpose | Version | Diagrams |
|:------|:--------|:-------:|:--------:|
| **[ln-221-standards-researcher](ln-221-standards-researcher/)** | Research industry standards, RFCs, and architectural patterns via MCP Context7 + MCP Ref. Generates Standards Research (Markdown format) for insertion in Story Technical Notes → Library Research subsection. Reusable worker (called by ln-220 Phase 2). Libraries researched at Task level by ln-310. Time-boxed: 15-20 minutes. | 2.0.0 | ✅ |

**Workers (CREATE/REPLAN path - ln-220):**

| Skill | Purpose | Version | Diagrams |
|:------|:--------|:-------:|:--------:|
| **[ln-222-story-creator](ln-222-story-creator/)** | Creates Stories from IDEAL plan (ln-220 Phase 5a). Generates 8-section documents with Standards Research insertion (Technical Notes), validates INVEST criteria, shows preview, creates in Linear (project=Epic, labels=user-story, state=Backlog), updates kanban_board.md via Epic Grouping Algorithm. First-time Epic decomposition. Owns story_template_universal.md. | 1.0.0 | ✅ |
| **[ln-223-story-replanner](ln-223-story-replanner/)** | Replans Stories when Epic requirements change (ln-220 Phase 5b). Progressive Loading (ONE BY ONE for token efficiency: ~5,000 tokens/Story), compares IDEAL vs existing, categorizes operations (KEEP/UPDATE/OBSOLETE/CREATE), shows diffs (AC, Standards Research, Technical Notes), user confirmation, executes updates (respects status constraints: Backlog/Todo only), updates kanban_board.md. Story Split/Merge detection. | 1.0.0 | ✅ |

---

### 3. Story Pipeline (00, 10-50, 1X-5X)

**Top Orchestrator:**

| Skill | Purpose | Version | Diagrams |
|:------|:--------|:-------:|:--------:|
| **[ln-300-story-pipeline](ln-300-story-pipeline/)** | 🔄 **Top orchestrator** for complete Story processing workflow from task planning to Done. Delegates to ln-310-story-decomposer (Phase 2), ln-320-story-validator (Phase 3 Step 1), ln-330-story-executor (Phase 3 Step 2 with To Review → To Rework → Todo priorities) and explicitly drives ln-340-story-quality-gate Pass 1 + Pass 2. Looping workflow until Story status = Done. Full pipeline automation: Todo → In Progress → To Review → Done. | 2.1.0 | ✅ |

#### 3.1 Task Planning (ln-310-story-decomposer)

**Coordinator:**

| Skill | Purpose | Version | Diagrams |
|:------|:--------|:-------:|:--------:|
| **[ln-310-story-decomposer](ln-310-story-decomposer/)** | **Coordinator** for task operations. Analyzes Story, builds optimal task plan (1-6 tasks, Foundation-First execution order), delegates to ln-311-task-creator (CREATE) or ln-312-task-replanner (REPLAN) with `taskType: "implementation"`. Auto-discovers team ID. For implementation tasks only. | 8.0.0 | ✅ |

**Workers:**

| Skill | Purpose | Version | Diagrams |
|:------|:--------|:-------:|:--------:|
| **[ln-311-task-creator](ln-311-task-creator/)** | **Universal factory** for creating ALL 3 task types (implementation, refactoring, test). Generates task documents from templates, validates type-specific rules, creates in Linear. Invoked by orchestrators (ln-310-story-decomposer, ln-340-story-quality-gate, ln-350-story-test-planner). Owns all 3 templates. | 5.0.0 | ✅ |
| **[ln-312-task-replanner](ln-312-task-replanner/)** | **Universal replanner** for updating ALL 3 task types (implementation, refactoring, test). Compares IDEAL plan vs existing, categorizes operations (KEEP/UPDATE/OBSOLETE/CREATE), applies type-specific validation, executes changes in Linear. Reads templates from ln-311-task-creator/references/. | 6.0.0 | ✅ |

#### 3.2 Story Validation (ln-320-story-validator)

**Coordinator:**

| Skill | Purpose | Version | Diagrams |
|:------|:--------|:-------:|:--------:|
| **[ln-320-story-validator](ln-320-story-validator/)** | **Coordinator** that critically reviews Stories and Tasks against 2025 industry standards before approval (Backlog → Todo). ALWAYS auto-fixes all 16 verification criteria. Auto-creates guides/manuals/ADRs via AUTO-RESEARCH. No "Needs Work" path exists. | 13.0.0 | ✅ |

**Workers:**

| Skill | Purpose | Version | Diagrams |
|:------|:--------|:-------:|:--------:|
| **[ln-321-best-practices-researcher](ln-321-best-practices-researcher/)** | Research best practices via MCP Ref/Context7 and create documentation (guide/manual/ADR). Single research, multiple output types. Replaces ln-321/322/323. | 1.0.0 | ❌ |

#### 3.3 Story Execution (ln-330-story-executor)

**Orchestrator:**

| Skill | Purpose | Version | Diagrams |
|:------|:--------|:-------:|:--------:|
| **[ln-330-story-executor](ln-330-story-executor/)** | **Orchestrator** that orchestrates Story execution (Todo → In Progress → To Review → Done). **Priority 0: Backlog** (auto-verify new tasks before execution) → **Priority 1: To Review** → **Priority 2: To Rework** → **Priority 3: Todo**. Auto-invokes ln-340-story-quality-gate Pass 1 + Pass 2 (full automation). Phase 4 delegates Story quality to ln-340-story-quality-gate (Orchestrator-Worker Pattern). | 9.0.0 | ✅ |

**Workers:**

| Skill | Purpose | Version | Diagrams |
|:------|:--------|:-------:|:--------:|
| **[ln-331-task-executor](ln-331-task-executor/)** | ⚙️ Execute implementation tasks ONLY (Todo → In Progress → To Review). Uses KISS/YAGNI principles, reads guide links, runs type checking and linting. Story status management removed (now ln-330-story-executor's responsibility). NOT for test tasks. | 10.1.0 | ✅ |
| **[ln-332-task-reviewer](ln-332-task-reviewer/)** | 🔍 Review completed tasks for To Review → Done/Rework transition. Distinguishes test/implementation tasks. Checks architecture, docs, security, quality, and test coverage. | 7.3.0 | ✅ |
| **[ln-333-task-rework](ln-333-task-rework/)** | Fix tasks marked To Rework. Analyzes feedback, applies fixes following KISS/YAGNI/DRY principles, runs quality gates (type checking, linting), and submits back To Review. | 5.1.0 | ✅ |
| **[ln-334-test-executor](ln-334-test-executor/)** | ⚙️ Execute Story Finalizer test tasks (Todo → In Progress → To Review). E2E-first Risk-Based Testing (2-5 E2E, 3-8 Integration, 5-15 Unit). Includes test fixes, infrastructure, docs, and legacy cleanup. | 4.0.0 | ✅ |

#### 3.4 Story Quality Gate (ln-340-story-quality-gate)

**Coordinator:**

| Skill | Purpose | Version | Diagrams |
|:------|:--------|:-------:|:--------:|
| **[ln-340-story-quality-gate](ln-340-story-quality-gate/)** | **Coordinator** for Story quality. Pass 1 delegates code analysis to `ln-341-code-quality-checker`, regression to `ln-342-regression-checker`, manual AC verification to `ln-343-manual-tester` (Format v1.0) with FAIL-FAST exit at each gate; auto-creates refactor/bug tasks when any gate fails. When all gates pass, automatically runs `ln-350-story-test-planner` (`autoApprove: true`) to create Story Finalizer test task. Pass 2 verifies automated tests (Priority >=15, limits 10-28) and moves Story to Done. | 8.0.0 | ✅ |

**Workers:**

| Skill | Purpose | Version | Diagrams |
|:------|:--------|:-------:|:--------:|
| **[ln-341-code-quality-checker](ln-341-code-quality-checker/)** | 🔎 Analyze code quality for DRY/KISS/YAGNI/Architecture violations and guide compliance. Checks git diffs of Done implementation tasks. Reports structured issues by severity (HIGH/MEDIUM/LOW). Fail Fast principle - runs FIRST in Phase 4. | 4.0.0 | ✅ |
| **[ln-342-regression-checker](ln-342-regression-checker/)** | 🧪 Run existing test suite to verify no regressions. Auto-detects framework (pytest/jest/vitest/go test). Returns JSON verdict + Linear comment. Atomic worker - does NOT create tasks or change statuses. | 3.0.0 | ✅ |
| **[ln-343-manual-tester](ln-343-manual-tester/)** | 🎯 Perform manual functional testing of Story AC using curl (API) or puppeteer (UI). Tests main scenarios + edge cases + error handling + integration. Creates reusable temp script `scripts/tmp_[story_id].sh`. Documents results in Linear (Format v1.0). | 4.0.0 | ✅ |

#### 3.5 Test Planning (ln-350-story-test-planner)

**Coordinator:**

| Skill | Purpose | Version | Diagrams |
|:------|:--------|:-------:|:--------:|
| **[ln-350-story-test-planner](ln-350-story-test-planner/)** | **Coordinator** that creates test task for Story after manual testing passes. Analyzes Story, generates comprehensive test task with 11 sections. **Delegates to ln-311-task-creator (CREATE) or ln-312-task-replanner (REPLAN)** with `taskType: "test"`. Supports existing test task updates. Uses 1X workers for task creation/replanning. | 7.2.0 | ✅ |

#### 3.6 Codebase Audit (ln-360-codebase-auditor)

| Skill | Purpose | Version | Diagrams |
|:------|:--------|:-------:|:--------:|
| **[ln-360-codebase-auditor](ln-360-codebase-auditor/)** | Full codebase quality audit across 9 categories (Security, Build, Architecture, Design, Complexity, Algorithms, Dependencies, Wheel Reinvention, Unused Code). Creates consolidated refactoring task in Linear Epic 0. Manual invocation for technical debt assessment. | 2.0.0 | ✅ |

#### 3.7 Test Suite Audit (ln-370-test-auditor)

| Skill | Purpose | Version | Diagrams |
|:------|:--------|:-------:|:--------:|
| **[ln-370-test-auditor](ln-370-test-auditor/)** | Test suite quality audit across 6 categories (Business Logic Focus, E2E Priority, Risk-Based Value, Coverage Gaps, Isolation, Anti-Patterns). Calculates **Usefulness Score** per test (Keep/Remove/Refactor). Removes useless tests, identifies missing ones. Creates task in Linear Epic 0. | 1.0.0 | ✅ |

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
4. ln-300-story-pipeline     → Complete automation from task planning to Done
   └─ Orchestrates: task decomposition → validation → execution → quality gates
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
