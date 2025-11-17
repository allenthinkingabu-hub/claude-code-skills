# Root Documentation Questions

**Purpose:** Define what each root documentation file should answer. Each section maps explicitly to document sections for validation.

**Format:** Document → Rules → Questions (with target sections) → Validation Heuristics → Auto-Discovery

---

## Table of Contents

| Document | Questions | Auto-Discovery | Priority | Line |
|----------|-----------|----------------|----------|------|
| [CLAUDE.md](#claudemd) | 6 | Medium | Critical | L30 |
| [docs/README.md](#docsreadmemd) | 7 | Low | High | L170 |
| [docs/documentation_standards.md](#docsdocumentation_standardsmd) | 3 | None | Medium | L318 |
| [docs/principles.md](#docsprinciplesmd) | 6 | None | High | L381 |

**Priority Legend:**
- **Critical:** Must answer all questions
- **High:** Strongly recommended
- **Medium:** Optional (can use template defaults)

**Auto-Discovery Legend:**
- **None:** No auto-discovery needed (use template as-is)
- **Low:** 1-2 questions need auto-discovery
- **Medium:** 3+ questions need auto-discovery

---

<!-- DOCUMENT_START: CLAUDE.md -->
## CLAUDE.md

**File:** CLAUDE.md (project root)
**Target Sections:** ⚠️ Critical Rules for AI Agents, Documentation Navigation Rules, Documentation, Development Commands, Documentation Maintenance Rules, Maintenance

**Rules for this document:**
- Recommended length: ≤100 lines (guideline from Claude Code docs)
- Must have SCOPE tag in first 10 lines
- Must link to docs/README.md
- Entry point for all documentation (DAG root)

---

<!-- QUESTION_START: 1 -->
### Question 1: Where is project documentation located?

**Expected Answer:** Links to docs/README.md, documentation_standards.md, principles.md
**Target Section:** ## Documentation

**Validation Heuristics:**
- ✅ Has section "## Documentation" with links to docs/README.md, documentation_standards.md, principles.md

**Auto-Discovery:**
- None needed (standard structure)
<!-- QUESTION_END: 1 -->

---

<!-- QUESTION_START: 2 -->
### Question 2: What are critical rules for AI agents?

**Expected Answer:** Table of critical rules organized by category (Standards Hierarchy, Documentation, Testing, Research, Task Management, Skills, Language) with When to Apply and Rationale columns
**Target Section:** ## ⚠️ Critical Rules for AI Agents

**Validation Heuristics:**
- ✅ Has section "## ⚠️ Critical Rules for AI Agents" with table (Category, Rule, When to Apply, Rationale), 7+ rows, "Key Principles" subsection, mentions Standards First, Token Efficiency, Quality, No Legacy Code

**Auto-Discovery:**
- None needed (universal rules)
<!-- QUESTION_END: 2 -->

---

<!-- QUESTION_START: 3 -->
### Question 3: How to navigate documentation (DAG structure)?

**Expected Answer:** SCOPE tags explanation + reading order + graph structure with examples
**Target Section:** ## Documentation Navigation Rules

**Validation Heuristics:**
- ✅ Has section "## Documentation Navigation Rules" with SCOPE tag explanation, reading order (numbered list), example navigation, >40 words

**Auto-Discovery:**
- None needed (universal best practice)
<!-- QUESTION_END: 3 -->

---

<!-- QUESTION_START: 4 -->
### Question 4: What are documentation maintenance rules?

**Expected Answer:** DRY principles, Single Source of Truth, update triggers, English-only policy
**Target Section:** ## Documentation Maintenance Rules

**Validation Heuristics:**
- ✅ Has section "## Documentation Maintenance Rules" with "Single Source of Truth"/"DRY", "English Only" rule, "Principles"/"Avoiding Duplication" subsections, >60 words

**Auto-Discovery:**
- None needed (universal standards)
<!-- QUESTION_END: 4 -->

---

<!-- QUESTION_START: 5 -->
### Question 5: When should CLAUDE.md be updated?

**Expected Answer:** Update triggers + verification checklist
**Target Section:** ## Maintenance

**Validation Heuristics:**
- ✅ Has section "## Maintenance" with "Update Triggers" and "Verification" subsections, "Last Updated" field

**Auto-Discovery:**
- None needed (standard maintenance section)
<!-- QUESTION_END: 5 -->

---

<!-- QUESTION_START: 6 -->
### Question 6: What are the project development commands?

**Expected Answer:** Table with development commands organized by task (Install Dependencies, Run Tests, Start Dev Server, Build, Lint/Format) for both Windows and Bash
**Target Section:** ## Development Commands

**Validation Heuristics:**
- ✅ Has section "## Development Commands" with table (Task, Windows, Bash), 5+ rows, note about updating commands, placeholder/actual commands

**Auto-Discovery:**
- Scan package.json → "scripts" field (for Node.js projects)
- Scan pyproject.toml → [tool.poetry.scripts] or [project.scripts] (for Python projects)
- Scan Makefile → targets (for Make-based projects)
- Scan composer.json → "scripts" field (for PHP projects)

**Notes:**
- If no commands found, use placeholder: `[Add your command]`
- Auto-discovery hints can suggest common commands based on detected project type
<!-- QUESTION_END: 6 -->

---

**Overall File Validation:**
- ✅ Has SCOPE tag in first 10 lines
- ✅ Total length > 80 words (meaningful content)

**Auto-Discovery Hints:**
- Scan package.json → "name", "description" fields (for project name/description)
- Check existing CLAUDE.md for project name

<!-- DOCUMENT_END: CLAUDE.md -->

---

<!-- DOCUMENT_START: docs/README.md -->
## docs/README.md

**File:** docs/README.md (documentation hub)
**Target Sections:** Overview, General Documentation Standards, Writing Guidelines, Standards Compliance, Contributing to Documentation, Quick Navigation, Maintenance

**Rules for this document:**
- Must have SCOPE tag in first 10 lines (HTML comment)
- Hub file - navigation to subdirectories (project/, reference/, tasks/)
- General standards only - NO project-specific content

---

<!-- QUESTION_START: 1 -->
### Question 1: What is the documentation structure?

**Expected Answer:** Overview of documentation areas (Project, Reference, Task Management)
**Target Section:** ## Overview

**Validation Heuristics:**
- ✅ Has section "## Overview" mentioning Project Documentation (project/), Reference Documentation (reference/), Task Management (tasks/), >30 words

**Auto-Discovery:**
- Scan docs/ directory for subdirectories (project/, reference/, tasks/)
<!-- QUESTION_END: 1 -->

---

<!-- QUESTION_START: 2 -->
### Question 2: What are general documentation standards?

**Expected Answer:** SCOPE Tags, Maintenance Sections, Sequential Numbering, Placeholder Conventions
**Target Section:** ## General Documentation Standards

**Validation Heuristics:**
- ✅ Has section "## General Documentation Standards" with subsections (SCOPE Tags, Maintenance Sections, Sequential Numbering, Placeholder Conventions), >100 words

**Auto-Discovery:**
- None needed (universal standards)
<!-- QUESTION_END: 2 -->

---

<!-- QUESTION_START: 3 -->
### Question 3: What are writing guidelines?

**Expected Answer:** Progressive Disclosure Pattern, token efficiency, table-first format
**Target Section:** ## Writing Guidelines

**Validation Heuristics:**
- ✅ Has section "## Writing Guidelines" mentioning Progressive Disclosure/token efficiency, table/list with format guidelines, >50 words

**Auto-Discovery:**
- None needed (universal best practice)
<!-- QUESTION_END: 3 -->

---

<!-- QUESTION_START: 4 -->
### Question 4: When should docs/README.md be updated?

**Expected Answer:** Update triggers + verification checklist
**Target Section:** ## Maintenance

**Validation Heuristics:**
- ✅ Has section "## Maintenance" with "Update Triggers" and "Verification" subsections

**Auto-Discovery:**
- None needed (standard maintenance section)
<!-- QUESTION_END: 4 -->

---

<!-- QUESTION_START: 5 -->
### Question 5: What are the standards this documentation complies with?

**Expected Answer:** Standards Compliance table with Standard, Application, and Reference columns
**Target Section:** ## Standards Compliance

**Validation Heuristics:**
- ✅ Has section "## Standards Compliance" with table (Standard, Application, Reference), 5+ standards (ISO/IEC/IEEE 29148:2018, ISO/IEC/IEEE 42010:2022, arc42, C4 Model, ADR Format, MoSCoW), document path links

**Auto-Discovery:**
- None needed (universal standards)
<!-- QUESTION_END: 5 -->

---

<!-- QUESTION_START: 6 -->
### Question 6: How to contribute to documentation?

**Expected Answer:** Numbered list of contribution steps (Check SCOPE tags, Update Last Updated date, Update registry, Follow sequential numbering, Add placeholders, Verify links)
**Target Section:** ## Contributing to Documentation

**Validation Heuristics:**
- ✅ Has section "## Contributing to Documentation" with 6+ steps mentioning SCOPE tags, Last Updated, registry, sequential numbering, link verification, >40 words

**Auto-Discovery:**
- None needed (universal contribution guidelines)
<!-- QUESTION_END: 6 -->

---

<!-- QUESTION_START: 7 -->
### Question 7: How to quickly navigate to key documentation areas?

**Expected Answer:** Quick Navigation table with Area, Key Documents, and Skills columns
**Target Section:** ## Quick Navigation

**Validation Heuristics:**
- ✅ Has section "## Quick Navigation" with table (Area, Key Documents, Skills), 4 rows (Standards, Project, Reference, Tasks), document/skill name links

**Auto-Discovery:**
- Scan docs/ directory structure (project/, reference/, tasks/)
- Detect skill references from kanban_board.md (if exists)
<!-- QUESTION_END: 7 -->

---

**Overall File Validation:**
- ✅ Has SCOPE tag (HTML comment) in first 10 lines
- ✅ Total length > 100 words

<!-- DOCUMENT_END: docs/README.md -->

---

<!-- DOCUMENT_START: docs/documentation_standards.md -->
## docs/documentation_standards.md

**File:** docs/documentation_standards.md (60 universal requirements)
**Target Sections:** Quick Reference, 12 main sections (Claude Code Integration through References), Maintenance

**Rules for this document:**
- 60+ universal documentation requirements
- 12 main sections covering industry standards
- References to ISO/IEC/IEEE, DIATAXIS, arc42

---

<!-- QUESTION_START: 1 -->
### Question 1: What are the comprehensive documentation requirements?

**Expected Answer:** Quick Reference table with 60+ requirements in 12 categories
**Target Section:** ## Quick Reference

**Validation Heuristics:**
- ✅ Has section "## Quick Reference" with table (Requirement, Description, Priority, Reference), 60+ rows across categories (Claude Code Integration, AI-Friendly Writing, Markdown, Code Examples, DIATAXIS)

**Auto-Discovery:**
- None needed (universal standards, use template as-is)
<!-- QUESTION_END: 1 -->

---

<!-- QUESTION_START: 2 -->
### Question 2: What are the detailed requirements for each category?

**Expected Answer:** 12 main sections with detailed explanations
**Target Sections:** 12 sections (## Claude Code Integration, ## AI-Friendly Writing Style, etc.)

**Validation Heuristics:**
- ✅ Has 12+ main sections with subsections, mentions ISO/IEC/IEEE/DIATAXIS/arc42 standards, >300 lines

**Auto-Discovery:**
- None needed (universal standards)
<!-- QUESTION_END: 2 -->

---

<!-- QUESTION_START: 3 -->
### Question 3: When should documentation standards be updated?

**Expected Answer:** Update triggers + verification checklist
**Target Section:** ## Maintenance

**Validation Heuristics:**
- ✅ Has section "## Maintenance" with "Update Triggers" and "Verification" subsections

**Auto-Discovery:**
- None needed (standard maintenance section)
<!-- QUESTION_END: 3 -->

---

**Overall File Validation:**
- ✅ File size > 300 lines
- ✅ Mentions ISO/IEC/IEEE 29148:2018
- ✅ Mentions DIATAXIS framework
- ✅ Mentions arc42

**MCP Ref Hints:**
- Research: "DIATAXIS framework documentation" (if user wants customization)
- Research: "ISO/IEC/IEEE 29148:2018" (if user wants compliance details)

<!-- DOCUMENT_END: docs/documentation_standards.md -->

---

<!-- DOCUMENT_START: docs/principles.md -->
## docs/principles.md

**File:** docs/principles.md (8 development principles + Decision Framework)
**Target Sections:** Core Principles table, Decision-Making Framework, Trade-offs (subsection), Anti-Patterns, Verification Checklist, Maintenance

**Rules for this document:**
- Must have SCOPE tag in first 10 lines
- 8 core principles (Standards First, YAGNI, KISS, DRY, Consumer-First, No Legacy Code, Documentation-as-Code, Security by Design)
- Decision-Making Framework (7 steps)
- Verification Checklist (8 items)

---

<!-- QUESTION_START: 1 -->
### Question 1: What are the core development principles?

**Expected Answer:** 8 principles in table format (4 columns: Name, Type, Principle, Approach/Rules)
**Target Section:** ## Core Principles

**Validation Heuristics:**
- ✅ Has section "## Core Principles" with 8-row table (Name, Type, Principle, Approach/Rules): Standards First, YAGNI, KISS, DRY, Consumer-First, No Legacy Code, Documentation-as-Code, Security by Design, no subsections

**Auto-Discovery:**
- None needed (universal principles)

**Notes:**
- Task Granularity → Moved to ln-113-tasks-docs-creator (task management specific)
- Value-Based Testing → Moved to ln-116-test-docs-creator (testing specific)
- Token Efficiency → Referenced in documentation_standards.md (already detailed in #80-85)
<!-- QUESTION_END: 1 -->

---

<!-- QUESTION_START: 2 -->
### Question 2: How to make decisions when principles conflict?

**Expected Answer:** Decision-Making Framework with priority order (Security → Standards → Correctness → ...)
**Target Section:** ## Decision-Making Framework

**Validation Heuristics:**
- ✅ Has section "## Decision-Making Framework" with 7 steps (Security, Standards, Correctness, Simplicity, Necessity, Maintainability, Performance), >30 words

**Auto-Discovery:**
- None needed (universal framework)
<!-- QUESTION_END: 2 -->

---

<!-- QUESTION_START: 3 -->
### Question 3: How to resolve conflicts when principles contradict?

**Expected Answer:** Trade-offs table with Conflict, Lower Priority, Higher Priority, and Resolution columns
**Target Section:** ### Trade-offs (subsection under Decision-Making Framework)

**Validation Heuristics:**
- ✅ Has subsection "### Trade-offs" under Decision-Making Framework with table (Conflict, Lower Priority, Higher Priority, Resolution), 3+ conflicts using framework hierarchy

**Auto-Discovery:**
- None needed (universal trade-offs)
<!-- QUESTION_END: 3 -->

---

<!-- QUESTION_START: 4 -->
### Question 4: What are common anti-patterns to avoid?

**Expected Answer:** List of anti-patterns across principles
**Target Section:** ## Anti-Patterns to Avoid

**Validation Heuristics:**
- ✅ Has section "## Anti-Patterns to Avoid" with 5+ anti-patterns, >20 words

**Auto-Discovery:**
- None needed (universal anti-patterns)
<!-- QUESTION_END: 4 -->

---

<!-- QUESTION_START: 5 -->
### Question 5: How to verify principles compliance?

**Expected Answer:** Verification checklist with 8 items
**Target Section:** ## Verification Checklist

**Validation Heuristics:**
- ✅ Has section "## Verification Checklist" with 8-item checklist (- [ ] format) covering all 8 core principles

**Auto-Discovery:**
- None needed (universal checklist)
<!-- QUESTION_END: 5 -->

---

<!-- QUESTION_START: 6 -->
### Question 6: When should principles be updated?

**Expected Answer:** Update triggers + verification
**Target Section:** ## Maintenance

**Validation Heuristics:**
- ✅ Has section "## Maintenance" with "Update Triggers" and "Verification" subsections

**Auto-Discovery:**
- None needed (standard maintenance section)
<!-- QUESTION_END: 6 -->

---

**Overall File Validation:**
- ✅ Has SCOPE tag in first 10 lines
- ✅ File size > 100 lines (reduced from 300+ due to table format + removed domain-specific principles)
- ✅ All 8 core principles present (Standards First, YAGNI, KISS, DRY, Consumer-First, No Legacy Code, Documentation-as-Code, Security by Design)

**MCP Ref Hints:**
- Research: "YAGNI principle examples" (if user wants deeper explanation)
- Research: "DRY principle best practices" (if user wants industry context)

<!-- DOCUMENT_END: docs/principles.md -->

---

**Version:** 4.0.0 (MAJOR: Added Table of Contents and programmatic markers for context management)
**Last Updated:** 2025-11-18
