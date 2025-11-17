---
name: ln-210-epic-coordinator
description: CREATE/REPLAN Epics from scope (3-7 Epics). Sequential Loop + Interactive Dialog. Decompose-First Pattern. Auto-discovers team ID.
---

# Epic Coordinator

Universal Epic management coordinator that handles both creation and replanning through scope decomposition.

## When to Use This Skill

This skill should be used when:
- Start new scope/initiative requiring decomposition into multiple logical domains (CREATE mode)
- Break down large architectural requirement into Epics
- Update existing Epics when scope/requirements change (REPLAN mode)
- Rebalance Epic scopes within an initiative
- Add new Epics to existing initiative structure
- First step in project planning (scope → Epics → Stories → Tasks)
- Define clear scope boundaries and success criteria for each domain

**Output:** 3-7 Linear Projects (logical domains/modules)

## Core Pattern: Decompose-First

**Key principle:** ALWAYS analyze scope and build IDEAL Epic plan FIRST, THEN check existing Epics to determine mode:
- **No existing Epics** → CREATE MODE (generate and create all Epics)
- **Has existing Epics** → REPLAN MODE (compare, determine operations: KEEP/UPDATE/OBSOLETE/CREATE)

**Rationale:** Ensures consistent Epic decomposition based on current scope requirements, independent of existing Epic structure (which may be outdated or suboptimal).

## How It Works

### Phase 1: Discovery (Automated)

Auto-discovers Team ID and Next Epic Number from `docs/tasks/kanban_board.md`:
- **Team ID:** Reads Linear Configuration table → Fallback: Ask user directly
- **Next Epic Number:** Reads Next Epic Number field → Fallback: Ask user directly

**Details:** See CLAUDE.md sections "Configuration Auto-Discovery" and "Linear Integration".

### Phase 2: Scope Analysis (Interactive)

Analyzes architectural requirement and identifies logical domains:

1. **Scope understanding:**
   - What is the high-level architectural requirement/scope?
   - What is the main business objective?
   - What are the major functional areas?

2. **Domain identification:**
   - Automatically identifies 3-7 logical domains/modules
   - Each domain becomes separate Epic
   - Examples: "User Management", "Payment Processing", "Reporting"

3. **Confirmation:**
   - Shows identified domains to user
   - User can adjust/refine domain list

### Phase 3: Build IDEAL Epic Plan (Automated)

**This phase ALWAYS runs, regardless of whether Epics exist.**

1. **Analyze Scope:**
   - Review all domains from Phase 2
   - Identify distinct Epic boundaries
   - Group related functionality

2. **Determine Optimal Epic Count:**
   - **Simple Initiative** (1-3 domains): 3-4 Epics
   - **Medium Initiative** (4-6 domains): 5-7 Epics
   - **Complex Initiative** (7+ domains): 7-10 Epics (rare)
   - **Max 10 Epics per Initiative** (enforced)

3. **Build IDEAL Plan** "in mind":
   - Each Epic focuses on one domain/module
   - Each Epic has clear goal + scope boundaries + success criteria
   - Epics ordered by dependency (foundational modules first)

**Output:** IDEAL Epic plan (3-7 Epics) with:
- Epic titles (domain names)
- Epic goals (business objectives)
- Core features for each
- Epic ordering (dependency-aware)

> [!NOTE]

> This plan exists "in mind" before checking existing Epics.

### Phase 4: Check Existing Epics

Query kanban_board.md and Linear for existing Epics:

1. **Read Epic Story Counters** table in kanban_board.md
2. **Count existing Epic rows** (excludes header row)

**Decision Point:**
- **Count = 0** → No existing Epics → **Proceed to Phase 5a (CREATE MODE)**
- **Count ≥ 1** → Existing Epics found → **Proceed to Phase 5b (REPLAN MODE)**

### Phase 5a: Create Mode - Sequential Processing (Loop)

**For EACH domain** (one at a time, sequential loop):

1. **Ask 5 key questions for current domain:**
   - **"What is the business goal?"** - Why this Epic/domain matters
   - **"Key features in scope?"** - 3-5 bullet points of capabilities
   - **"What is OUT of scope?"** - Prevent scope creep
   - **"Success criteria?"** - Measurable outcomes
   - **"Known risks?"** (Optional) - Blockers, dependencies

2. **Generate Epic document:**
   - Goal, Scope (in/out), Success Criteria
   - Dependencies, Risks & Mitigations
   - Show Epic numbering (e.g., Epic 7)

3. **Show Epic preview:**
   - Display generated Epic document for review

4. **User confirmation:**
   - User types "confirm" to create this Epic in Linear
   - OR user can edit/refine the Epic document

5. **Create Linear Project:**
   - Create Linear Project with Epic number
   - Update kanban_board.md:
     * Increment Next Epic Number by 1 in Linear Configuration table
     * Add new row to Epic Story Counters: `Epic N+ | - | US001 | - | EPN_01`
     * Add to "Epics Overview" → Active: `- [Epic N: Title](link) - Backlog`
   - Return Project URL

6. **Move to next domain:**
   - Repeat steps 1-5 for next domain
   - Continue until all domains processed

**Output:** 3-7 Linear Projects created sequentially (one by one)

### Phase 5b: Replan Mode (Existing Epics Found)

**Trigger:** Initiative already has Epics (requirements changed, need to replan)

**Process:**

1. **Load Existing Epics:**
   - Read Epic Story Counters table from kanban_board.md
   - For each Epic row: load Epic from Linear via `get_project(id)`
   - Load FULL description (Goal, Scope In/Out, Success Criteria, Risks, Phases)
   - Note Epic status (active/archived)
   - **Total:** N existing Epics

2. **Compare IDEAL Plan vs Existing:**
   - **Match by goal:** Fuzzy match Epic goals + domain names
   - **Identify operations needed:**
     - **KEEP:** Epic in IDEAL + existing, goals unchanged → No action
     - **UPDATE:** Epic in IDEAL + existing, scope/criteria changed → Update description
     - **OBSOLETE:** Epic in existing, NOT in IDEAL → Archive (state="archived")
     - **CREATE:** Epic in IDEAL, NOT in existing → Create new

3. **Categorize Operations:**
   ```
   ✅ KEEP (N Epics): No changes needed
   - Epic 5: User Management
   - Epic 6: Payment Processing

   🔧 UPDATE (M Epics): Scope or criteria changed
   - Epic 7: Reporting (Scope modified: add real-time dashboards)
   - Epic 8: Notifications (Success Criteria: add email delivery tracking)

   ❌ OBSOLETE (K Epics): No longer in initiative scope
   - Epic 9: Legacy Data Migration (removed from scope)

   ➕ CREATE (L Epics): New domains added
   - Epic 10: Analytics Engine (new initiative requirement)
   ```

4. **Show Replan Summary:**
   - Display operations for all Epics
   - Show diffs for UPDATE operations (before/after Scope, Criteria)
   - Show warnings for edge cases:
     - ⚠️ "Epic 7 has 5 Stories In Progress - cannot auto-archive, manual review needed"
   - Total operation count

5. **User Confirmation:**
   - Wait for user to type "confirm"
   - If user provides feedback → Adjust operations and show updated summary

6. **Execute Operations:**
   - **KEEP:** Skip (no Linear API calls)
   - **UPDATE:** Call `update_project(id, description=new_description)` (if no Stories In Progress)
   - **OBSOLETE:** Call `update_project(id, state="archived")` (if no Stories In Progress)
   - **CREATE:** Call `create_project()` (same as Phase 5a) + update kanban_board.md

7. **Update kanban_board.md:**
   - Remove OBSOLETE Epics from Epic Story Counters table
   - Update modified Epics (UPDATE operations) - preserve Story counters
   - Add new Epics (CREATE operations) to Epic Story Counters
   - Update Epics Overview section (move archived to Archived section)

**Output:** Summary message with operation results + affected Epic URLs

**Important Constraints:**
- **Never auto-update/archive Epics with Stories In Progress** (show warnings only)
- **Never delete Epics:** Use state="archived" to preserve history
- **Always require user confirmation** before executing operations

---

## Definition of Done

Before completing work, verify ALL checkpoints:

**✅ Objects Created in Linear:**
- [ ] Each Epic Linear Project created successfully (3-7 Projects total)
- [ ] All required fields populated (title, description, team)
- [ ] Epic numbers sequential (no gaps in numbering)

**✅ Description Complete:**
- [ ] All template sections filled (Goal, Scope In/Out, Success Criteria, Risks, Phases)
- [ ] No placeholders remaining ({{PLACEHOLDER}} removed)
- [ ] Scope boundaries clear (what IS and IS NOT in Epic)

**✅ Tracking Updated:**
- [ ] kanban_board.md updated after EACH Epic creation:
  - Next Epic Number incremented by 1 in Linear Configuration table
  - New row added to Epic Story Counters: `Epic N+ | - | US001 | - | EPN_01`
  - Epic added to "Epics Overview" → Active: `- [Epic N: Title](link) - Backlog`
- [ ] Each Linear Project URL returned to user immediately after creation

**✅ User Confirmation:**
- [ ] User reviewed EACH Epic before creation
- [ ] User typed "confirm" for EACH Epic to proceed with creation

**Output:** List of Linear Project URLs (one after each Epic creation) + final summary ("Created N Epics: Epic X through Epic Y")

---

## Example Usage

**Request:**
```
"Create epics for e-commerce platform"
```

**Process:**
1. **Discovery** → Team "Product", Last Epic = 10 → Next: Epic 11
2. **Scope Analysis** → Identifies 5 domains: "User Management", "Product Catalog", "Shopping Cart", "Payment Processing", "Order Management"
3. **Sequential Processing (Loop):**
   - **Epic 11 "User Management":**
     - Ask 5 questions → Generate Epic 11 → Show preview → User confirms → Create in Linear → Update kanban (Next = 12) → Return URL
   - **Epic 12 "Product Catalog":**
     - Ask 5 questions → Generate Epic 12 → Show preview → User confirms → Create in Linear → Update kanban (Next = 13) → Return URL
   - **Epic 13 "Shopping Cart":**
     - Ask 5 questions → Generate Epic 13 → Show preview → User confirms → Create in Linear → Update kanban (Next = 14) → Return URL
   - **Epic 14 "Payment Processing":**
     - Ask 5 questions → Generate Epic 14 → Show preview → User confirms → Create in Linear → Update kanban (Next = 15) → Return URL
   - **Epic 15 "Order Management":**
     - Ask 5 questions → Generate Epic 15 → Show preview → User confirms → Create in Linear → Update kanban (Next = 16) → Return URL

**Result:** 5 Epics created sequentially (Epic 11-15)

## Reference Files

- **linear_integration.md:** Discovery patterns + Linear API reference
- **epic_template_universal.md:** Epic template structure

## Best Practices

- Make success criteria measurable: "<200ms" not "fast"
- Define clear OUT of scope to prevent scope creep
- **No code snippets:** Never include actual code in Epic descriptions - only high-level features and goals

---

**Version:** 5.0.0 (BREAKING: Added REPLAN mode with Decompose-First Pattern, renamed to ln-210-epic-coordinator)
**Last Updated:** 2025-11-17