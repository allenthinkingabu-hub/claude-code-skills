---
name: ln-220-story-coordinator
description: CREATE/REPLAN Stories for Epic (5-10 Stories). Delegates ln-221 for library research. Decompose-First Pattern. Auto-discovers team/Epic.
---

# Story Coordinator

Universal Story management coordinator that handles both creation and replanning through Epic decomposition, with automated library research delegation.

## When to Use This Skill

This skill should be used when:
- Decompose Epic into User Stories (5-10 Stories covering Epic scope)
- Update existing Stories when Epic requirements change
- Rebalance Story scopes within an Epic
- Add new Stories to existing Epic structure

## Core Pattern: Decompose-First

**Key principle:** ALWAYS analyze Epic and build IDEAL Story plan FIRST, THEN check existing Stories to determine mode:
- **No existing Stories** → CREATE MODE (generate and create all Stories)
- **Has existing Stories** → REPLAN MODE (compare, determine operations: KEEP/UPDATE/OBSOLETE/CREATE)

**Rationale:** Ensures consistent Story decomposition based on current Epic requirements, independent of existing Story structure (which may be outdated or suboptimal).

## How It Works

### Phase 1: Context Assembly

**Objective:** Gather all context needed for Story planning (Epic details, planning questions, user input)

**Process:**

**Step 1: Discovery (Automated)**

Auto-discovers configuration from `docs/tasks/kanban_board.md`:

1. **Team ID:** Reads Linear Configuration table
2. **Epic:** Parses Epic number from user request → Validates exists in Linear → Loads Epic description (Goal, Scope In/Out, Success Criteria, Technical Notes)
3. **Next Story Number:** Reads Epic Story Counters table → Gets next sequential number (US001, US002, etc.)

**Details:** See CLAUDE.md "Configuration Auto-Discovery".

**Step 2: Extract Planning Information (Automated)**

Parses Epic structure to extract answers to Story planning questions:

1. **Q1 - Who is the user/persona?**
   - Extract from Epic Goal ("Enable [persona] to...")
   - Extract from Epic Scope In (user roles mentioned)

2. **Q2 - What do they want to do?**
   - Extract from Epic Scope In (capabilities listed)
   - Parse functional requirements

3. **Q3 - Why does it matter?**
   - Extract from Epic Success Criteria (business metrics)
   - Extract from Epic Goal (business value statement)

4. **Q4 - Which Epic?**
   - Already have Epic ID from Step 1

5. **Q5 - Main acceptance criteria?**
   - Derive from Epic Scope In features
   - Identify testable scenarios for each capability

6. **Q6 - Application type?**
   - Extract from Epic Technical Notes (UI/API mentioned)
   - Infer from project context
   - Default: API (backend only)

**Step 3: Gather Missing Information (Interactive)**

**Only ask user for questions where Epic did not provide information.**

For each question with no answer from Step 2:
1. Show what was extracted: "From Epic, I found: [extracted info]"
2. Ask user to confirm or provide missing details
3. Build complete Story planning context

**If all questions answered from Epic:** Skip this step entirely and proceed to Phase 2.

**Output:** Complete context for Story planning (Epic details, next Story number, Q1-Q6 answers)

---

### Phase 2: Library Research (Delegated)

**Objective:** Research libraries, API specifications, and industry standards BEFORE Story generation to ensure implementation tasks contain concrete technical details.

**Why this phase:** Prevents situations where tasks lack specific API methods, library versions, or best practices (e.g., slowapi implementation using outdated patterns).

**Process:**

1. **Parse Epic for libraries:**
   - Extract libraries from Epic Technical Notes
   - Extract technology keywords from Epic Scope In (authentication, rate limiting, payments, etc.)
   - Identify Story domain from Epic goal statement

2. **Delegate research to ln-221-library-researcher:**
   - Call `Skill(skill: "ln-221-library-researcher", epic_description="[Epic full description]", story_domain="[domain]")`
   - Wait for Research Summary (Markdown string)

3. **Store Research Summary:**
   - Cache for use in Phase 7a/7b (Story generation - Library Research subsection in Technical Notes)

**Output:** Research Summary stored for ALL Stories in Epic

**Skip conditions:**
- Epic has NO libraries mentioned in Technical Notes → Skip delegation, use empty Research Summary
- Story domain is trivial CRUD operation with well-known libraries (FastAPI, SQLAlchemy) → Skip delegation
- Epic explicitly states "research not needed" → Skip delegation

**Time-box:** 15-20 minutes maximum (handled by ln-221-library-researcher)

**Important notes:**
- Research is done ONCE per Epic, results reused for all Stories (5-10 Stories benefit from single research)
- ln-221-library-researcher focuses on KEY APIs only (2-5 methods), not exhaustive documentation
- If ln-221 returns empty Research Summary → Proceed without library research section

---

### Phase 3: Planning

**Objective:** Build IDEAL Story plan and determine execution mode (CREATE/REPLAN)

**Process:**

**Step 1: Build IDEAL Story Plan (Automated)**

**This step ALWAYS runs, regardless of whether Stories exist.**

1. **Analyze Epic Scope:**
   - Review all features in Epic Scope In
   - Identify distinct user capabilities
   - Group related functionality

2. **Determine Optimal Story Count:**
   - **Simple Epic** (1-3 features, single module): 3-5 Stories
   - **Medium Epic** (4-7 features, 2-3 modules): 6-8 Stories
   - **Complex Epic** (8+ features, multiple modules): 8-10 Stories
   - **Max 10 Stories per Epic** (enforced)

3. **Build IDEAL Plan** "in mind":
   - Each Story focuses on one user capability
   - Each Story has clear persona + capability + business value
   - Each Story has 3-5 testable AC (Given-When-Then)
   - Stories ordered by dependency (foundational capabilities first)
   - Each Story includes Test Strategy (Risk-Based Testing: 2-5 E2E, 3-8 Integration, 5-15 Unit, 10-28 total)
   - Each Story includes Technical Notes (architecture, integrations, **Library Research from Phase 2**, guide links)

> [!NOTE]

> This plan exists "in mind" before checking existing Stories.

**Step 2: Check Existing Stories (Automated)**

Query Linear for existing Stories in Epic:

```
list_issues(project=Epic.id, label="user-story")
```

**Decision Point:**
- **Count = 0** → No existing Stories → **Phase 4a: CREATE MODE**
- **Count ≥ 1** → Existing Stories found → **Phase 4b: REPLAN MODE**

**Output:** IDEAL Story plan (5-10 Stories) with titles, statements, core AC, ordering + Execution mode determined

---

### Phase 4: Execution

**Objective:** Create or replan Stories based on IDEAL plan from Phase 3

**Phase 4a: CREATE Mode (No Existing Stories)**

**Trigger:** Epic has no Stories yet (first time decomposition)

**Process:**

1. **Generate Story Documents:**
   - For each Story in IDEAL plan (Phase 3 Step 1)
   - Use story_template_universal.md structure
   - Generate complete 8 sections:
     - Story Statement (As a/I want/So that)
     - Context
     - Acceptance Criteria (Given-When-Then, 3-5 AC)
     - Test Strategy (Risk-Based Testing: 2-5 E2E, 3-8 Integration, 5-15 Unit, 10-28 total)
     - Implementation Tasks (placeholder: "Tasks will be created via ln-310-story-decomposer after Story verification")
     - Technical Notes (architecture, integrations, **Library Research from Phase 2**, guide links)
     - Definition of Done
     - Revision History

2. **Show Preview:**
   - Display all Stories to be created
   - Show numbering (e.g., US004, US005, US006...)
   - Show Story ordering (dependency-aware)
   - Total count (e.g., "5 Stories to create")

3. **User Confirmation:**
   - Wait for user to type "confirm"
   - If user provides feedback → Adjust Stories and show updated preview

4. **Create All Stories in Linear:**
   - Sequential creation using `create_issue()`:
     - Title: "USXXX: [Title]"
     - Description: Complete Story markdown
     - Team: Team ID from Phase 1
     - Project: Epic ID from Phase 1
     - Labels: ["user-story"]
     - parentId: null (Stories are top-level)
   - Collect all Linear Issue URLs

5. **Update kanban_board.md:**
   - Add ALL Stories to "### Backlog" section under Epic header:
     ```markdown
     **Epic N: Epic Title**

       📖 [LINEAR_ID: USXXX Story Title](link)
         _(tasks not created yet)_
       📖 [LINEAR_ID: USYYY Story Title](link)
         _(tasks not created yet)_
     ```
   - Update Epic Story Counters table (Last Story → last created, Next Story → next number)

6. **Display Summary:**
   ```
   ✅ Created 5 Stories for Epic 7: OAuth Authentication

   Stories created:
   - US004: Register OAuth client (link)
   - US005: Request access token (link)
   - US006: Validate token (link)
   - US007: Refresh expired token (link)
   - US008: Revoke token (link)

   Library Research:
   - OAuth 2.0 (RFC 6749) v2.1 - authlib library research included in Technical Notes

   Next Steps:
   1. Run ln-320-story-validator to validate Stories before approval
   2. Use ln-310-story-decomposer to create tasks for each Story
   ```

**Output:** Created Story URLs + summary + Library Research note + next steps

---

**Phase 4b: REPLAN Mode (Existing Stories Found)**

**Trigger:** Epic already has Stories (requirements changed, need to replan)

**Process:**

1. **Load Existing Stories:**
   - Fetch all Stories from Linear: `get_issue(id)` for each
   - Load FULL description (all 8 sections) for each Story ONE BY ONE (progressive loading)
   - Note Story status (Backlog/Todo/In Progress/To Review/Done)
   - **Total:** N existing Stories

2. **Compare IDEAL Plan vs Existing:**
   - **Algorithm:** See `references/replan_algorithm.md` for detailed matching logic
   - **Match by goal:** Fuzzy match Story titles + persona + capability
   - **Identify operations needed:**
     - **KEEP:** Story in IDEAL + existing, AC unchanged → No action
     - **UPDATE:** Story in IDEAL + existing, AC/approach changed → Update description
     - **OBSOLETE:** Story in existing, NOT in IDEAL → Cancel (state="Canceled")
     - **CREATE:** Story in IDEAL, NOT in existing → Create new

3. **Categorize Operations:**
   ```
   ✅ KEEP (N stories): No changes needed
   - US004: OAuth client registration
   - US005: Token validation

   🔧 UPDATE (M stories): AC or approach changed
   - US006: Token refresh (AC modified: add expiry validation)
   - US007: Token revocation (Technical Notes: add audit logging, update Library Research)

   ❌ OBSOLETE (K stories): No longer in Epic scope
   - US008: Custom token formats (feature removed from Epic)

   ➕ CREATE (L stories): New capabilities added
   - US009: Token scope management (new Epic requirement with Library Research from Phase 3)
   ```

4. **Show Replan Summary:**
   - Display operations for all Stories
   - Show diffs for UPDATE operations (before/after AC, before/after Library Research if changed)
   - Show warnings for edge cases:
     - ⚠️ "US006 is In Progress - cannot auto-update, manual review needed"
     - ⚠️ "US008 is Done - cannot cancel, will remain in Epic"
   - Total operation count

5. **User Confirmation:**
   - Wait for user to type "confirm"
   - If user provides feedback → Adjust operations and show updated summary

6. **Execute Operations:**
   - **KEEP:** Skip (no Linear API calls)
   - **UPDATE:** Call `update_issue(id, description=new_description)` (Backlog/Todo only)
     - Insert updated Library Research from Phase 2 if Epic libraries changed
   - **OBSOLETE:** Call `update_issue(id, state="Canceled")` (Backlog/Todo only)
   - **CREATE:** Call `create_issue()` (same as Phase 4a) with Library Research from Phase 2

7. **Update kanban_board.md:**
   - Remove OBSOLETE Stories (Canceled) from all sections
   - Update modified Stories (UPDATE operations) - keep in current section
   - Add new Stories (CREATE operations) to "### Backlog"
   - Update Epic Story Counters table

8. **Display Summary:**
   ```
   ✅ Replanned Epic 7: OAuth Authentication

   Operations executed:
   - ✅ KEEP: 3 stories unchanged
   - 🔧 UPDATE: 2 stories modified (link) - Library Research updated with latest OAuth 2.0 specs
   - ❌ OBSOLETE: 1 story canceled (link)
   - ➕ CREATE: 2 new stories created (link) with Library Research

   ⚠️ Manual Review Needed:
   - US006 (In Progress): AC changed but cannot auto-update - review manually

   Next Steps:
   1. Review warnings for Stories in progress
   2. Run ln-320-story-validator on updated/created Stories
   3. Use ln-310-story-decomposer to create/replan tasks
   ```

**Output:** Operation results + warnings + affected Story URLs + Library Research updates + next steps

**Important Constraints (applies to both CREATE and REPLAN modes):**
- **Never auto-update Stories with status:** In Progress, To Review, Done (show warnings only in REPLAN mode)
- **Never delete Stories:** Use state="Canceled" to preserve history
- **Always require user confirmation** before executing operations

---

## Integration with Ecosystem

**Calls:**
- **ln-221-library-researcher** (Phase 3) - research libraries/standards for Epic (reusable worker)

**Called by:**
- **ln-200-decomposition-pipeline** (Phase 3) - automated full decomposition (scope → Epics → Stories)
- **Manual** - user invokes directly for Epic Story creation/replanning

**Upstream:**
- **ln-210-epic-coordinator** - creates Epics (prerequisite for Story creation)

**Downstream:**
- **ln-310-story-decomposer** - creates implementation tasks for each Story
- **ln-320-story-validator** - validates Story structure and content
- **ln-330-story-executor** - orchestrates task execution for Story

---

## Definition of Done

Before completing work, verify ALL checkpoints:

**✅ Phase 1: Context Assembly Complete:**
- [ ] Team ID loaded from kanban_board.md (Step 1)
- [ ] Epic number parsed from request and description loaded (Step 1)
- [ ] Next Story number determined from Epic Story Counters (Step 1)
- [ ] Attempted to extract all 6 question answers from Epic (Step 2)
- [ ] Missing information requested from user (Step 3, if needed)
- [ ] Complete Story planning context assembled

**✅ Phase 2: Library Research Complete:**
- [ ] Epic parsed for libraries and technology keywords
- [ ] ln-221-library-researcher invoked with Epic description + Story domain
- [ ] Research Summary received and cached for ALL Stories
- [ ] OR Phase 2 skipped (trivial CRUD, no libraries mentioned, or explicit skip)

**✅ Phase 3: Planning Complete:**
- [ ] Epic Scope analyzed (Step 1)
- [ ] Optimal Story count determined (5-10 Stories, Step 1)
- [ ] IDEAL Story plan created with titles, statements, core AC (Step 1)
- [ ] Stories ordered by dependency (Step 1)
- [ ] Checked for existing Stories in Epic (Step 2)
- [ ] Execution mode determined (CREATE or REPLAN, Step 2)

**✅ Phase 4: Execution Complete:**

**Phase 4a: CREATE MODE (if Count = 0):**
- [ ] Story documents generated (8 sections each, Library Research from Phase 2 inserted in Technical Notes)
- [ ] Preview shown to user
- [ ] User typed "confirm"
- [ ] All Stories created in Linear (label "user-story", parentId=null)
- [ ] kanban_board.md updated (Stories added to Backlog, counters updated)
- [ ] Summary displayed with Story URLs and next steps

**Phase 4b: REPLAN MODE (if Count ≥ 1):**
- [ ] Existing Stories loaded (full descriptions, ONE BY ONE for token efficiency)
- [ ] IDEAL plan compared with existing
- [ ] Operations categorized (KEEP/UPDATE/OBSOLETE/CREATE)
- [ ] Replan summary with diffs shown to user (including Library Research changes if Epic libraries updated)
- [ ] User typed "confirm"
- [ ] Operations executed in Linear (respecting status constraints, updating Library Research for UPDATE/CREATE)
- [ ] kanban_board.md updated (remove Canceled, add new, update modified)
- [ ] Summary displayed with operation results, warnings, and next steps

**Constraints Respected:**
- [ ] Never auto-updated Stories with status In Progress/To Review/Done
- [ ] Never deleted Stories (used state="Canceled" for obsolete)
- [ ] Showed warnings for edge cases (In Progress Stories with changes)
- [ ] Required user confirmation before all operations

**Output:**
- Phase 4a: Created Story URLs + summary + Library Research note + next steps
- Phase 4b: Operation results + warnings + affected Story URLs + Library Research updates + next steps

---

## Example Usage

**CREATE MODE (First Time):**
```
"Create stories for Epic 7: OAuth Authentication"
```

**Process:**
1. Phase 1: Context Assembly → Discovery (Team "API", Epic 7, US004), Extract (Persona: API client, Value: secure API access), Gather Missing (AC specifics from user)
2. Phase 2: Library Research → Epic mentions "OAuth 2.0", delegate ln-221 → Research Summary with RFC 6749, authlib library v1.3.0, key APIs, constraints
3. Phase 3: Planning → Build IDEAL (5 Stories: "Register client", "Request token", "Validate token", "Refresh token", "Revoke token"), Check Existing (Count = 0 → CREATE MODE)
4. Phase 4a: CREATE Mode → Generate 5 Stories (with Library Research in Technical Notes), show preview, user confirms, create in Linear, display summary → US004-US008 created with Library Research

**REPLAN MODE (Requirements Changed):**
```
"Replan stories for Epic 7 - we removed custom token formats and added scope management"
```

**Process:**
1. Phase 1: Context Assembly → Discovery (Team "API", Epic 7, already has US004-US008), Extract (New requirements: removed custom formats, added scopes), Gather Missing (Epic had all info)
2. Phase 2: Library Research → Epic mentions "OAuth 2.0 scopes", delegate ln-221 → Updated Research Summary with RFC 6749 Section 3.3 (scope parameter)
3. Phase 3: Planning → Build IDEAL (5 Stories: "Register client", "Request token", "Validate token", "Refresh token", "Manage scopes"), Check Existing (Count = 5 → REPLAN MODE)
4. Phase 4b: REPLAN Mode → Compare (KEEP 4 Stories but UPDATE Technical Notes with scope research, OBSOLETE "Custom formats" US008, CREATE "Manage scopes" US009), user confirms, execute operations, display summary → US008 canceled, US009 created, US004-US007 Technical Notes updated

## Reference Files

- **story_template_universal.md:** User Story template structure (8 sections)
- **replan_algorithm.md:** Detailed Story comparison and operation determination logic
- **../ln-210-epic-coordinator/references/linear_integration.md:** Shared discovery patterns and Linear API
- **../ln-221-library-researcher/references/research_guidelines.md:** Library research quality guidelines

## Best Practices

- **Research-First:** Always perform Phase 2 library research delegation (libraries, APIs, standards) before Story generation - prevents implementation rework due to missing technical details
- **Decompose-First:** Always build IDEAL plan before checking existing (Phase 3) - prevents anchoring to suboptimal structure
- **Epic extraction:** Try to extract all planning info from Epic in Phase 1 Step 2 before asking user - reduces user input burden
- **One capability per Story:** Each Story should have clear, focused persona + capability + value
- **Testable AC:** Use Given-When-Then format, 3-5 AC per Story, specific criteria ("<200ms" not "fast")
- **Test Strategy:** Include Risk-Based Testing section - guides final test task creation via ln-350-story-test-planner
- **Library Research:** Include Library Research from Phase 2 in ALL Story Technical Notes - tasks will reference these specs
- **Status respect:** Never auto-update Stories In Progress/Done - show warnings instead (Phase 4b)
- **Preserve history:** Use state="Canceled" for obsolete Stories, never delete (Phase 4b)
- **User confirmation:** Always show preview/summary and require "confirm" before operations (Phase 4a/4b)
- **Progressive Loading:** Load existing Stories ONE BY ONE in Phase 4b REPLAN mode for token efficiency

---

**Version:** 1.1.0 (Refactored workflow structure: consolidated 8 phases → 4 major phases for improved readability. No functional changes. Previous: v1.0.0 extracted from ln-211-story-manager v8.0.0)
**Last Updated:** 2025-11-17
