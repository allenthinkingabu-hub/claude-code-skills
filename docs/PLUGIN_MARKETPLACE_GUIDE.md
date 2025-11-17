# Plugin Marketplace Guide

**How to create, version, and publish 4 plugins from this repository to Claude Code marketplace.**

This guide describes the architecture of 4 plugins with different granularity levels, allowing users to install only the skills they need. All plugins use the Orchestrator-Worker Pattern and share common resources (MCP servers, templates, shared CSS).

---

## Quick Reference

| Plugin Name | Skills Count | Use Case | Linear MCP | Context7 + Ref MCP | Installation |
|-------------|-------------|----------|------------|-------------------|--------------|
| **agile-linear-workflow-complete** | 32 | Full workflow automation (docs + planning + execution) | Required | Required | Recommended |
| **agile-linear-workflow-docs** | 10 | Documentation automation only | Not required | Not required | Standalone |
| **agile-linear-workflow-planning** | 4 | Epic/Story decomposition with AUTO-RESEARCH | Required | Required | Requires Linear setup |
| **agile-linear-workflow-execution** | 18 | Story execution pipeline (tasks + quality gates) | Required | Required | Requires Linear setup + Stories |

**Installation command:**
```bash
/plugin install <plugin-name>@agile-linear-workflow-marketplace
```

---

## Plugin Details

### 1. agile-linear-workflow-complete (Recommended)

**Description:** Complete Agile workflow automation covering all 32 skills from documentation creation to story execution.

**Includes:**
- **Series 100 (Documentation):** 10 skills - ln-110-documents-pipeline, ln-120-docs-validator + 8 workers
- **Series 200 (Planning):** 4 skills - ln-200-scope-decomposer, ln-210-epic-coordinator, ln-220-story-coordinator, ln-221-library-researcher
- **Series 300 (Execution):** 18 skills - ln-300-story-pipeline, 4 coordinators (ln-310/320/330/340), 14 workers

**Use Case:**
- Teams needing end-to-end automation from project documentation to task execution
- Complete Agile workflow: scope → Epics → Stories → Tasks → Execution → Review → Done

**Dependencies:**
- **Required:** Linear MCP server (for task management)
- **Required:** Context7 MCP server (for library documentation via ln-221/321/323)
- **Required:** Ref MCP server (for best practices research via ln-221/321)

**Orchestrators:**
- ln-110-documents-pipeline (CREATE docs path)
- ln-120-docs-validator (VALIDATE docs path)
- ln-200-scope-decomposer (scope → Epics → Stories)
- ln-300-story-pipeline (Story planning → validation → execution → Done)

**Version:** 1.0.0

---

### 2. agile-linear-workflow-docs

**Description:** Documentation automation system for generating project documentation, validation, and maintenance.

**Includes:**
- **ln-110-documents-pipeline** (TOP orchestrator) → 6 workers:
  - ln-111-root-docs-creator (CLAUDE.md + docs/README.md + DOCUMENTATION_STANDARDS.md)
  - ln-112-reference-docs-creator (docs/reference/ structure + ADR template)
  - ln-113-tasks-docs-creator (docs/tasks/ + kanban_board.md)
  - ln-114-project-docs-creator (7 project docs: requirements, architecture, tech_stack + 4 optional)
  - ln-115-presentation-creator (HTML presentation with 6 tabs)
  - ln-116-test-docs-creator (testing-strategy.md + tests/README.md)
- **ln-120-docs-validator** (TOP orchestrator) → 2 workers:
  - ln-121-structure-validator (SCOPE tags, Maintenance sections, compliance)
  - ln-122-content-updater (git diff → updates, cleanup temp files, consolidate duplicates)

**Use Case:**
- Teams needing documentation automation without Linear integration
- Startups at initial project setup phase
- Projects requiring DOCUMENTATION_STANDARDS.md compliance

**Dependencies:**
- **None** - Works completely standalone without Linear MCP

**Limitations:**
- ✅ Auto-creates complete documentation structure (DAG with SCOPE tags + README hubs)
- ✅ Validates and auto-fixes documentation (structure + metadata)
- ❌ Does NOT integrate with Planning/Execution workflows (no Linear tasks)

**Version:** 1.0.0

---

### 3. agile-linear-workflow-planning

**Description:** Planning automation for decomposing scope into Epics and Stories with AUTO-RESEARCH capabilities.

**Includes:**
- **ln-200-scope-decomposer** (TOP orchestrator) - Full decomposition workflow
- **ln-210-epic-coordinator** - CREATE/REPLAN 3-7 Epics (Decompose-First Pattern)
- **ln-220-story-coordinator** - CREATE/REPLAN 5-10 Stories per Epic
- **ln-221-library-researcher** - Research libraries/standards via MCP Context7 + Ref

**Use Case:**
- Product managers and tech leads decomposing scope
- Teams needing structured Epic/Story planning with library research
- Projects requiring Research Summary in Story Technical Notes

**Dependencies:**
- **Required:** Linear MCP server (creates Epics as Linear Projects, Stories as Linear Issues)
- **Required:** Context7 MCP server (library documentation research)
- **Required:** Ref MCP server (best practices research)

**Workflow:**
1. User provides scope/initiative description
2. ln-200-scope-decomposer → ln-210-epic-coordinator (creates 3-7 Epics)
3. For each Epic → ln-220-story-coordinator (creates 5-10 Stories)
4. For each Story → ln-221-library-researcher (Phase 3: AUTO-RESEARCH)
5. Stories created in Linear with Technical Notes populated

**Limitations:**
- ⚠️ ln-220-story-coordinator can invoke ln-321/322/323 (from series 300) for AUTO-DOCUMENTATION
  - **Fallback mode:** If execution plugin not installed, skips guide/ADR/manual creation
  - **Recommendation:** Install `agile-linear-workflow-complete` or `agile-linear-workflow-execution` for full AUTO-DOCUMENTATION

**Version:** 1.0.0

---

### 4. agile-linear-workflow-execution

**Description:** Story execution pipeline with task planning, validation, execution, and quality gates.

**Includes:**
- **ln-300-story-pipeline** (TOP orchestrator) - Full Story workflow
- **ln-310-story-decomposer** (coordinator) + 2 workers:
  - ln-311-task-creator (CREATE 3 task types: impl/refactor/test)
  - ln-312-task-replanner (REPLAN tasks: KEEP/UPDATE/OBSOLETE/CREATE)
- **ln-320-story-validator** (coordinator) + 3 workers:
  - ln-321-guide-creator (minimal guides, 300-500 words, AUTO-RESEARCH)
  - ln-322-adr-creator (minimal ADRs, Nygard format, 5-question dialog)
  - ln-323-manual-creator (Package API reference manuals, AUTO-RESEARCH)
- **ln-330-story-executor** (coordinator) + 4 workers:
  - ln-331-task-executor (implementation tasks: Todo → In Progress → To Review)
  - ln-332-task-reviewer (review tasks: To Review → Done/Rework)
  - ln-333-task-rework (fix tasks: To Rework → To Review)
  - ln-334-test-executor (Story Finalizer test tasks, Risk-Based Testing)
- **ln-340-story-quality-gate** (coordinator) + 4 workers:
  - ln-341-code-quality-checker (DRY/KISS/YAGNI/Architecture violations)
  - ln-342-regression-checker (run existing test suite, auto-detect framework)
  - ln-343-manual-tester (functional testing via curl/puppeteer, temp script)
  - ln-350-story-test-planner (plan test task after manual testing)
- **Note:** ln-221-library-researcher NOT included (used only in planning phase)

**Use Case:**
- Development teams with existing Stories in Linear
- Teams needing automated Story execution workflow
- Projects requiring Risk-Based Testing (2-5 E2E, 3-8 Integration, 5-15 Unit per Story)

**Dependencies:**
- **Required:** Linear MCP server (task management, Story/Task updates)
- **Required:** Context7 MCP server (library research via ln-323)
- **Required:** Ref MCP server (best practices via ln-321)

**Workflow:**
1. ln-310-story-decomposer → Creates 1-6 implementation tasks (IDEAL Plan → CREATE/REPLAN)
2. ln-320-story-validator → Auto-fixes 16 criteria, creates guides/ADRs/manuals, adds ✅ APPROVED marker
3. ln-330-story-executor → Priority loop:
   - Priority 1: To Review → ln-332-task-reviewer
   - Priority 2: To Rework → ln-333-task-rework
   - Priority 3: Todo → ln-331-task-executor
4. ln-340-story-quality-gate → Two-pass review:
   - Pass 1: Code quality → Regression → Manual testing (FAIL-FAST, creates tmp script)
   - Pass 2: Verify tests → Done

**Limitations:**
- **Note:** Library research handled by planning phase (ln-220 → ln-221) before execution starts
- ⚠️ Requires existing Stories in Linear (does NOT create Stories)
  - **Recommendation:** Install `agile-linear-workflow-planning` or `agile-linear-workflow-complete` for Story creation

**Version:** 1.0.0

---

## Dependency Matrix

### MCP Server Requirements

| Plugin | Linear MCP | Context7 MCP | Ref MCP | Notes |
|--------|------------|--------------|---------|-------|
| **complete** | ✅ Required | ✅ Required | ✅ Required | Full automation, all features enabled |
| **docs** | ❌ Not required | ❌ Not required | ❌ Not required | Standalone documentation automation |
| **planning** | ✅ Required | ✅ Required | ✅ Required | Creates Epics/Stories in Linear with AUTO-RESEARCH |
| **execution** | ✅ Required | ✅ Required | ✅ Required | Manages tasks in Linear with AUTO-RESEARCH |

### Inter-Series Dependencies

**Reusable Workers (included in multiple plugins):**

| Worker Skill | Included In Plugins | Called From | Purpose |
|-------------|---------------------|-------------|---------|
| **ln-221-library-researcher** | planning, complete | ln-220 | Library/standards research via MCP Context7 + Ref |

**Cross-Series Invocations (optional fallback):**

| From Series | To Series | Skills | Condition | Fallback |
|-------------|-----------|--------|-----------|----------|
| Planning (200) → Execution (300) | ln-220 → ln-321/322/323 | AUTO-DOCUMENTATION | If execution plugin installed | Skip guide/ADR/manual creation |
| Execution (300) → Documentation (100) | ln-320 → ln-321/322/323 | AUTO-DOCUMENTATION | Always | No fallback (workers included) |

---

## Versioning Strategy

### Version Levels

| Level | Version Format | Example | When to Bump |
|-------|---------------|---------|--------------|
| **Individual Skill** | Semver (X.Y.Z) | ln-311-task-creator v4.0.0 | When skill SKILL.md changes |
| **Plugin** | Semver (X.Y.Z) | agile-linear-workflow-docs v1.2.0 | When skills added/removed OR BREAKING dependency change |
| **Repository** | Semver (X.Y.Z) | claude-code-skills v10.3.0 | GitHub release (tags all 4 plugins) |

### Plugin Version Bump Rules

| Change Type | Version Bump | Example |
|-------------|-------------|---------|
| **MAJOR (X+1.0.0)** | BREAKING change | Skill removed, MCP server requirement changed (optional → required) |
| **MINOR (X.Y+1.0)** | Feature addition | New skill added, skill updated to new major version |
| **PATCH (X.Y.Z+1)** | Bug fix or docs | Bug fix in skill, documentation update, minor skill version bump |

### Version Synchronization Example

```
Repository Release: claude-code-skills v10.3.0 (2025-11-17)
├─ Plugin: agile-linear-workflow-complete v1.3.0
│  └─ Includes: 32 skills (individual versions: v1.0.0 to v11.0.0)
├─ Plugin: agile-linear-workflow-docs v1.2.0
│  └─ Includes: 10 skills (series 100)
├─ Plugin: agile-linear-workflow-planning v1.1.0
│  └─ Includes: 4 skills (series 200 + ln-221)
└─ Plugin: agile-linear-workflow-execution v1.1.0
   └─ Includes: 18 skills (series 300 only)
```

**Note:** Plugin versions are **independent** from individual skill versions. Plugin version reflects the "snapshot" of skills included at release time.

---

## Publishing Checklist

### Pre-Publishing Validation

- [ ] **Verify skill counts:** 32 total (10 docs, 4 planning, 18 execution)
- [ ] **Check inter-dependencies:** ln-221 included only in planning plugin
- [ ] **Validate plugin.json schemas:** All 4 plugin.json files pass Claude Code validation
- [ ] **Test marketplace.json:** `plugins` array contains all 4 plugins with correct `source` paths
- [ ] **MCP server requirements:** Documented in each plugin description
- [ ] **Version synchronization:** All 4 plugins have matching v1.0.0 initial version

### File Structure Verification

```
.claude-plugin/
├── plugin.json                    [agile-linear-workflow-complete]
├── marketplace.json               [lists all 4 plugins]
└── variants/
    ├── docs.plugin.json           [agile-linear-workflow-docs]
    ├── planning.plugin.json       [agile-linear-workflow-planning]
    └── execution.plugin.json      [agile-linear-workflow-execution]
```

### Testing Steps

1. **Validate schemas:**
   ```bash
   claude plugin validate .
   claude plugin validate .claude-plugin/variants/docs.plugin.json
   claude plugin validate .claude-plugin/variants/planning.plugin.json
   claude plugin validate .claude-plugin/variants/execution.plugin.json
   ```

2. **Add local marketplace:**
   ```bash
   /plugin marketplace add c:\Users\levni\.claude\skills
   /plugin marketplace list
   ```

3. **Install each plugin in isolated environment:**
   ```bash
   /plugin install agile-linear-workflow-complete@agile-linear-workflow-marketplace
   /plugin install agile-linear-workflow-docs@agile-linear-workflow-marketplace
   /plugin install agile-linear-workflow-planning@agile-linear-workflow-marketplace
   /plugin install agile-linear-workflow-execution@agile-linear-workflow-marketplace
   ```

4. **Verify skill loading:**
   ```bash
   /skills list  # Check all skills loaded correctly
   ```

5. **Test orchestrators:**
   - **docs:** `/skill ln-110-documents-pipeline` (should create documentation structure)
   - **planning:** `/skill ln-200-scope-decomposer` (requires Linear MCP setup)
   - **execution:** `/skill ln-300-story-pipeline` (requires Linear MCP + existing Story)

### Publishing to GitHub

1. **Tag repository:**
   ```bash
   git tag -a v10.3.0 -m "Release v10.3.0: 4 plugins (complete/docs/planning/execution)"
   git push origin v10.3.0
   ```

2. **Create GitHub Release:**
   - Title: `v10.3.0 - Multi-Plugin Architecture`
   - Body: Link to CHANGELOG.md + PLUGIN_MARKETPLACE_GUIDE.md
   - Assets: Attach `.claude-plugin/` directory as ZIP

3. **Update marketplace repository:**
   - If using external marketplace, submit PR with updated `marketplace.json`
   - Include link to GitHub release v10.3.0

---

## Maintenance

### Update Triggers

**When to update plugins:**

| Trigger | Action | Affected Plugins |
|---------|--------|------------------|
| **New skill added** | Update `includes` in plugin.json, bump MINOR version | Plugin that includes the series (100/200/300) |
| **Skill removed** | Remove from `includes`, bump MAJOR version | All plugins including the skill |
| **BREAKING dependency change** | Update `dependencies` section, bump MAJOR version | All plugins affected by dependency |
| **Skill version updated (minor/patch)** | No plugin version bump needed | None (plugin version independent from skill versions) |
| **Skill version updated (major)** | Review breaking changes, bump plugin MINOR version | Plugins including the skill |
| **MCP server requirement changed** | Update description + dependencies, bump MAJOR version | All plugins using the MCP server |

### Verification Steps

**After any update:**

1. **Re-validate all plugin.json files:**
   ```bash
   claude plugin validate .
   claude plugin validate .claude-plugin/variants/*.json
   ```

2. **Update CLAUDE.md:**
   - Update "Available Skills" section if skill added/removed
   - Update "Plugin Installation" table if requirements changed

3. **Update README.md:**
   - Update installation table
   - Update feature comparison table

4. **Update CHANGELOG.md:**
   - Add entry following [Keep a Changelog](https://keepachangelog.com/) format
   - Specify which plugins affected

5. **Test dependency chains:**
   - Verify Orchestrator → Worker invocations work
   - Test inter-series dependencies (ln-221 used only in planning phase)
   - Test fallback modes (ln-220 AUTO-DOC when execution plugin missing)

### Monitoring Health

**Key metrics to track:**

- **Installation failures** - Check for plugin.json schema errors
- **Skill loading errors** - Verify all skills in `includes` array exist
- **Dependency resolution** - Ensure MCP servers available
- **Version drift** - Keep plugin versions synchronized across marketplace.json

---

## Troubleshooting

### Common Issues

**Issue 1: "Skill not found" error after plugin installation**

**Cause:** Skill name in `includes` array doesn't match actual skill directory name.

**Solution:**
```bash
# List all skill directories
ls -1 | grep "^ln-"

# Verify skill name in plugin.json matches directory name
cat .claude-plugin/variants/docs.plugin.json | grep "ln-111"
```

**Issue 2: "Invalid plugin schema" error**

**Cause:** Using unsupported keys in plugin.json (e.g., `categories` instead of `category`).

**Solution:** See [marketplace.json fix](../CLAUDE.md#important-details) - use singular `category`, not plural `categories`.

**Issue 3: MCP server not available**

**Cause:** Plugin requires Linear/Context7/Ref MCP but server not configured.

**Solution:**
```bash
# Check MCP servers status
/mcp list

# Install missing MCP server (example for Linear)
/mcp add linear-server
```

**Issue 4: Inter-series dependency fails**

**Cause:** planning plugin tries to invoke ln-321/322/323 but execution plugin not installed.

**Solution:** Fallback mode activates automatically. To enable AUTO-DOCUMENTATION, install `agile-linear-workflow-execution` or `agile-linear-workflow-complete`.

---

## Reference Links

- **Claude Code Plugin Documentation:** https://docs.claude.com/en/docs/claude-code/plugins-reference
- **Claude Code Marketplace Schema:** https://docs.claude.com/en/docs/claude-code/plugin-marketplaces
- **SKILL_ARCHITECTURE_GUIDE.md:** Industry best practices (Orchestrator-Worker Pattern, Token Efficiency)
- **DOCUMENTATION_STANDARDS.md:** 60 universal documentation requirements
- **CHANGELOG.md:** Version history and breaking changes

---

**Version:** 1.0.0
**Last Updated:** 2025-11-17
