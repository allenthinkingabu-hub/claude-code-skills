---
name: ln-000-sprint0-masterplan-generator
description: Generate Sprint 0 Master Plan aligned with DELIVERY_METHODOLOGY.md. Covers 7-phase project lifecycle with quality audit.
---

# Sprint 0 Master Plan Generator

> **Worker Skill** | Generates comprehensive Sprint 0 Master Plan documents aligned with Hybrid Agile (EVD) methodology.

## Purpose

This skill automates the generation of Sprint 0 Master Plan documents that comply with the `DELIVERY_METHODOLOGY.md` standard. It ensures all required deliverables, sign-off requirements, and phase structures are properly documented.

**Key Value:**
- ✅ 100% methodology compliance (7-phase structure)
- ✅ Automatic sign-off requirement mapping
- ✅ Built-in quality audit mechanism
- ✅ Consistent terminology usage

---

## How It Works

The skill follows a 6-phase workflow:

```
Input Gathering → Context Loading → Phase Generation → Timeline Calculation → Quality Audit → Output
```

### Phase 1: Input Gathering

**Objective**: Collect project-specific parameters from user.

**Required Inputs:**

| Parameter | Type | Description | Example |
|-----------|------|-------------|---------|
| `project_name` | string | Project name | "E-Commerce Platform v2.0" |
| `project_description` | string | Business background (max 2000 chars) | "B2C e-commerce platform..." |
| `business_domain` | enum | Domain category | e_commerce, finance, healthcare, etc. |
| `tech_stack` | object | Technology stack configuration | frontend, backend, database, cloud |
| `estimated_sprints` | integer | Number of development sprints (1-20) | 6 |
| `start_date` | date | Project kickoff date (YYYY-MM-DD) | "2026-02-01" |

**Optional Inputs:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `team_structure` | object | Team composition (roles, headcount) |
| `constraints` | array | Special constraints |
| `third_party_integrations` | array | External integrations (API, SDK, service) |
| `deployment_targets` | array | AppStore, WeChat, Android markets, etc. |

**Process:**
1. Prompt user for required inputs if not provided
2. Validate input formats and ranges
3. Set defaults for optional parameters

---

### Phase 2: Context Loading

**Objective**: Load methodology context and validate against standards.

**Process:**
1. **Load Methodology Reference**:
   - Reference: `DELIVERY_METHODOLOGY.md`
   - Extract 7-phase structure definitions
   - Extract Sprint 0 sub-phase requirements (Plan + Analyze)

2. **Load Skill Context**:
   - Reference: `Sprint0_Skill_Context.md`
   - Load quality audit rules
   - Load deliverable checklists
   - Load sign-off requirements matrix

3. **Validate Inputs Against Methodology**:
   - Verify tech_stack aligns with supported platforms
   - Verify estimated_sprints is reasonable (2-week cycles per Line 172)

**Output**: Validated context object ready for generation

---

### Phase 3: Phase Generation

**Objective**: Generate all 7 phases of the Master Plan.

**Process:**

#### 3.1 Generate Sprint 0 (Phase 1/7)

**Sub-Phase: Plan**
```yaml
Duration: "Week 1-2"
Activities:
  - Develop Master Plan (high-level roadmap)
  - Develop Work Plan (detailed WBS)
  - Develop Sprint Plans (iterative planning)
  - Create Project Org Chart
  - Create Contact List
Deliverables:
  - [ ] Master Plan
  - [ ] Work Plan  
  - [ ] Sprint Plans
  - [ ] Project Org Chart
  - [ ] Contact List
```

**Sub-Phase: Analyze**
```yaml
Duration: "Week 3-4"
Activities:
  - Interview stakeholders
  - Develop BRD and PRD
  - Create Wireframes
  - Design Technical Architecture
  - Setup Code Scaffolds
Deliverables:
  - [ ] BRD (🔏 Sign-off Required)
  - [ ] PRD (🔏 Sign-off Required)
  - [ ] Wireframe (🔏 Sign-off Required)
  - [ ] Service Model Diagram
  - [ ] Technical Architecture Diagram (🔏 Sign-off Required)
  - [ ] Integration Architecture Diagram
  - [ ] Frontend Code Scaffold
  - [ ] Backend Code Scaffold
  - [ ] DevOps Account List
  - [ ] Database Design Scripts
  - [ ] Master Data Scripts
  - [ ] IaaS/PaaS Request List
  - [ ] 3rd Party Account Request List
  - [ ] UI/UX Hi-Fi Pages
```

#### 3.2 Generate Sprint 1...N (Phase 2/7)

```yaml
Duration: "{estimated_sprints} × 2 weeks"
Activities:
  - Iterative development (frontend + backend)
  - Unit testing per feature
  - Integration design
  - DevOps configuration (CI/CD)
Sprint_Cycle: "2 weeks per sprint (Line 172)"
Deliverables_Per_Sprint:
  - [ ] Frontend/Backend Code Updates
  - [ ] Integration Interfaces (🔏 Sign-off Required)
  - [ ] Database Design Updates
  - [ ] Project Plan Updates
```

#### 3.3 Generate SIT (Phase 3/7)

```yaml
Duration: "2 weeks"
Activities:
  - SIT Deployment
  - Integration Testing
  - Functionality Testing
  - Defect Management
Deliverables:
  - [ ] SIT Test Cases
  - [ ] SIT Test Results
  - [ ] SIT Report (🔏 Sign-off Required)
  - [ ] SIT Sign-Off
```

#### 3.4 Generate UAT (Phase 4/7)

```yaml
Duration: "2 weeks"
Activities:
  - UAT Deployment
  - Performance Testing
  - Security Testing (Mandatory - Line 294)
  - Client UAT Execution
Deliverables:
  - [ ] Performance Testing Report
  - [ ] Penetration Testing Report
  - [ ] UAT Test Cases
  - [ ] UAT Report (🔏 Client Signature Mandatory)
```

#### 3.5 Generate Data Migration (Phase 5/7)

```yaml
Execution: "Parallel Waterfall Thread (Line 11)"
Sub_Phases:
  - DESIGN: Data scope, mapping, consistency validation
  - BUILD: WBS, API development, exception handlers
  - REHEARSAL & CUTOVER: Runbook, rehearsals, dry run
Deliverables:
  - [ ] Data Migration Design Document
  - [ ] Data Migration Runbook (🔏 Sign-off Required)
  - [ ] Cutover Report (🔏 Sign-off Required)
  - [ ] Rollback Plan
```

#### 3.6 Generate Go-Live (Phase 6/7)

```yaml
Duration: "3-5 days"
Activities:
  - Backend/Frontend Deployment
  - Third-party Touchpoints (AppStore, WeChat, Android)
  - Smoke Testing
  - Go/No-Go Decision
Deployment_Strategies:
  - Recreate | Ramped | Blue/Green | Canary | A/B Testing | Shadow
Deliverables:
  - [ ] Smoke Testing Report (🔏 Sign-off Required)
  - [ ] Go-Live Communication Plan
  - [ ] Production Announcement
```

#### 3.7 Generate Operate (Phase 7/7)

```yaml
Duration: "Ongoing"
Steps:
  - ENGAGEMENT: Define scope, SLA, service catalog
  - TRANSITION: KT, training, AUDs
  - STABILIZE: Monitor SLA, operations manual
  - OPTIMIZATION: Continuous improvement, AMS automation
Support_Model: "ITIL L0-L4 (Line 552-560)"
Deliverables:
  - [ ] Service Catalog (🔏 Sign-off Required)
  - [ ] SLA Agreement (🔏 Sign-off Required)
  - [ ] Operations Manual
  - [ ] Training Guide
```

---

### Phase 4: Timeline Calculation

**Objective**: Calculate project timeline and milestones.

**Formula:**
```
Total Duration = Sprint 0 (4 weeks) 
               + Sprint 1...N (N × 2 weeks)
               + SIT (2 weeks)
               + UAT (2 weeks)
               + Go-Live (1 week)
               
Data Migration runs in parallel from Sprint 0 to Go-Live
```

**Output**: Gantt chart in Mermaid format

```mermaid
gantt
    title Project Timeline
    dateFormat  YYYY-MM-DD
    
    section Sprint 0
    Plan           :a1, {start_date}, 2w
    Analyze        :a2, after a1, 2w
    
    section Development
    Sprint 1       :b1, after a2, 2w
    Sprint 2       :b2, after b1, 2w
    Sprint N       :b3, after b2, {remaining_weeks}w
    
    section Testing
    SIT            :c1, after b3, 2w
    UAT            :c2, after c1, 2w
    
    section Deployment
    Go-Live        :d1, after c2, 1w
    
    section Parallel
    Data Migration :e1, {start_date}, {total_duration}w
```

---

### Phase 5: Quality Audit

**Objective**: Validate Master Plan against methodology standards.

**Audit Rules:**

| Rule ID | Check | Severity | Action on Fail |
|---------|-------|----------|----------------|
| PHASE_COMPLETENESS_001 | All 7 phases present | CRITICAL | Reject + Regenerate |
| DELIVERABLE_COMPLETENESS_001 | All DoD items included | HIGH | Warn + Flag missing |
| SIGNOFF_COMPLIANCE_001 | Sign-off markers present | CRITICAL | Reject |
| TERMINOLOGY_CONSISTENCY_001 | Standard terms used | MEDIUM | Suggest corrections |
| TIMELINE_REASONABILITY_001 | 2-week sprints, valid sequence | MEDIUM | Warn |

**Audit Process:**
```
Run PHASE_COMPLETENESS_001
  → Pass: Continue
  → Fail: REJECT, regenerate

Run DELIVERABLE_COMPLETENESS_001
  → Pass: Continue
  → Fail: WARN, flag missing items

Run SIGNOFF_COMPLIANCE_001
  → Pass: Continue
  → Fail: REJECT, add sign-off markers

Run TERMINOLOGY_CONSISTENCY_001
  → Pass: Continue
  → Fail: WARN, suggest corrections

Run TIMELINE_REASONABILITY_001
  → Pass: APPROVE
  → Fail: WARN, proceed with caution
```

**Audit Result Levels:**

| Level | Description | Action |
|-------|-------------|--------|
| ✅ PASS | Fully compliant | Output document |
| ⚠️ WARN | Minor deviations | Output with warnings |
| ❌ REJECT | Critical failures | Return to Phase 3 |

---

### Phase 6: Output Generation

**Objective**: Generate final Master Plan document.

**Output Structure:**

```markdown
# {project_name} - Sprint 0 Master Plan

## Document Info
| Field | Value |
|-------|-------|
| Version | 1.0 |
| Created | {current_date} |
| Methodology | Hybrid Agile (EVD Compliant) |

## Executive Summary
{project_description_summary}

## Project Overview
### Objectives
### Success Criteria
### Key Constraints

## 7-Phase Breakdown

### Phase 1/7: Sprint 0 (Analysis & Foundation)
#### Plan Sub-Phase
#### Analyze Sub-Phase

### Phase 2/7: Sprint 1...N (Iterative Development)
### Phase 3/7: SIT (System Integration Test)
### Phase 4/7: UAT (User Acceptance Test)
### Phase 5/7: Data Migration (Waterfall Thread)
### Phase 6/7: Go-Live (Deployment)
### Phase 7/7: Operate (Post-Live Support)

## Timeline
{gantt_chart}

## Team Structure
{org_chart}

## Deliverable Checklist (All Phases)

## Sign-off Matrix
| Phase | Deliverable | Approver | Date |
|-------|-------------|----------|------|
| Sprint 0 | BRD | Client PM | |
| Sprint 0 | PRD | Client PM | |
| ... | ... | ... | |

## Appendix
### A. Terminology Glossary
### B. Role Definitions
### C. Risk Register
```

**Output Artifacts:**
1. `{project_name}_MasterPlan.md` - Main document
2. `{project_name}_WorkPlan.md` - Detailed WBS (optional)
3. `{project_name}_SprintPlan_Template.md` - Sprint template (optional)

---

## Sign-off Requirements Matrix

**Source**: DELIVERY_METHODOLOGY.md Lines 607-621

| Phase | Required Sign-offs | Approver |
|-------|-------------------|----------|
| **Sprint 0** | BRD, PRD, Wireframe, Architecture Diagrams | Client PM |
| **Sprint 1...N** | Updated Requirements, Integration Interfaces | Client PM / Tech Lead |
| **SIT** | SIT Report, SIT Test Results | QA Lead |
| **UAT** | UAT Report (**Client signature mandatory**) | Client Executive |
| **Data Migration** | Migration Runbook, Cutover Report | Client IT |
| **Go-Live** | Smoke Testing Report, Go/No-Go Decision | Project Steering Committee |
| **Operate** | Service Catalog, SLA Agreement | Client Operations |

---

## Integration

**Called By:**
- Project Manager (manual invocation)
- `ln-100-project-coordinator` (if exists) - project initialization orchestrator

**Dependencies:**
- `DELIVERY_METHODOLOGY.md` - Methodology reference
- `Sprint0_Skill_Context.md` - Quality audit rules and context

**Output Consumers:**
- `ln-200-scope-decomposer` - Receives Master Plan for Epic decomposition
- `ln-110-project-docs-coordinator` - Receives plan for documentation generation

---

## Quality Assurance

**Methodology Compliance Guarantees:**

1. **7-Phase Structure** - Every plan includes all 7 phases (Line 38-510)
2. **Sprint 0 Sub-Phases** - Plan and Analyze sub-phases (Line 40)
3. **2-Week Sprint Cycle** - Development sprints use 2-week cycles (Line 172)
4. **Sign-off Requirements** - All mandatory sign-offs marked (Line 609)
5. **Waterfall Thread** - Data Migration marked as parallel (Line 11)
6. **EVD Compliance** - Methodology declaration included (Line 5)

**Terminology Enforcement:**

| Standard Term | Must Use | Source |
|---------------|----------|--------|
| Hybrid Agile | Overall methodology | Line 3 |
| EVD (Enterprise Value Delivery) | Compliance framework | Line 5 |
| Sprint 0 | Phase 1/7 | Line 8, 38 |
| Waterfall Thread | Data Migration | Line 11 |
| DoD (Definition of Done) | Deliverable checklist | Line 115 |
| MIC (Manager in Charge) | Project manager role | Line 26 |
| 2-week Sprint | Sprint duration | Line 172 |

---

## Resources

**Templates:**
- [master_plan_template.md](templates/master_plan_template.md) - Base template
- [work_plan_template.md](templates/work_plan_template.md) - WBS template
- [sprint_plan_template.md](templates/sprint_plan_template.md) - Sprint template

**References:**
- [DELIVERY_METHODOLOGY.md](../docs/DELIVERY_METHODOLOGY.md) - Source methodology
- [Sprint0_Skill_Context.md](context/Sprint0_Skill_Context.md) - Audit rules

**Allowed Tools:**
- `Read` - Read methodology files
- `Write` - Create output documents
- `Glob` - Scan existing project files
- `Bash` - Directory operations

---

**Version:** 1.0.0
**Last Updated:** 2026-01-24
**Author:** AI Agent Skill System
