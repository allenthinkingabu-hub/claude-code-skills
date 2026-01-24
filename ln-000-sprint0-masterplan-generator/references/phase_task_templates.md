# Phase Task Templates

> 此文件定义了每个阶段的标准任务模板，用于生成 Master Plan 时的任务原子化。

---

## Phase 1: Sprint 0 - Plan Sub-Phase

### Task Template: S0-P-XXX

```yaml
phase: "Sprint 0 - Plan"
task_prefix: "S0-P"

tasks:
  - id: "S0-P-001"
    name: "Develop Master Plan"
    description: |
      Create high-level project roadmap covering all phases from kick-off to go-live.
      Include milestones, key deliverables, and timeline.
    skill: "ln-110-project-docs-coordinator"
    estimated_duration: "2d"
    dependencies: []
    dod_criteria:
      - "Master Plan document created with all phases defined"
      - "Milestones and key deliverables listed"
      - "Timeline with dates established"
      - "Stakeholder approval obtained"
    outputs:
      - path: "docs/plans/master_plan.md"
        type: "document"
    required_inputs:
      - "Project scope definition"
      - "Stakeholder list"
      - "Target go-live date"

  - id: "S0-P-002"
    name: "Develop Work Plan"
    description: |
      Create detailed task breakdown with assignments, dependencies, and timelines.
      This is the WBS (Work Breakdown Structure) for the project.
    skill: "ln-110-project-docs-coordinator"
    estimated_duration: "3d"
    dependencies: ["S0-P-001"]
    dod_criteria:
      - "WBS with all tasks identified"
      - "Task owners assigned"
      - "Dependencies mapped"
      - "Effort estimates provided"
    outputs:
      - path: "docs/plans/work_plan.md"
        type: "document"
      - path: "docs/plans/resource_matrix.xlsx"
        type: "spreadsheet"
    required_inputs:
      - "Master Plan"
      - "Team roster"
      - "Resource availability"

  - id: "S0-P-003"
    name: "Develop Sprint Plans"
    description: |
      Create iterative sprint planning for Development phases (Sprint 1...N).
      Each sprint should be 2 weeks.
    skill: "ln-210-epic-coordinator"
    estimated_duration: "2d"
    dependencies: ["S0-P-002"]
    dod_criteria:
      - "Sprint count determined"
      - "Sprint scope outlined"
      - "Sprint backlog prepared for Sprint 1"
    outputs:
      - path: "docs/plans/sprint_plans.md"
        type: "document"
    required_inputs:
      - "Work Plan"
      - "PRD (or draft)"

  - id: "S0-P-004"
    name: "Create Project Org Chart"
    description: |
      Define project organization structure with roles and responsibilities.
    skill: "manual"
    estimated_duration: "1d"
    dependencies: ["S0-P-001"]
    dod_criteria:
      - "All roles defined"
      - "Reporting structure clear"
      - "Contact information included"
    outputs:
      - path: "docs/project/org_chart.md"
        type: "document"
    required_inputs:
      - "Team members list"
      - "Stakeholder list"

  - id: "S0-P-005"
    name: "Create Contact List"
    description: |
      Compile contact list for all project participants.
    skill: "manual"
    estimated_duration: "0.5d"
    dependencies: ["S0-P-004"]
    dod_criteria:
      - "All participants listed"
      - "Contact methods provided"
      - "Escalation paths defined"
    outputs:
      - path: "docs/project/contact_list.md"
        type: "document"
    required_inputs:
      - "Org Chart"
```

---

## Phase 1: Sprint 0 - Analyze Sub-Phase

### Task Template: S0-A-XXX

```yaml
phase: "Sprint 0 - Analyze"
task_prefix: "S0-A"

tasks:
  - id: "S0-A-001"
    name: "Conduct Stakeholder Interviews"
    description: |
      Interview business stakeholders to gather requirements.
      Document findings in structured interview notes.
    skill: "manual"
    estimated_duration: "5d"
    dependencies: ["S0-P-001"]
    dod_criteria:
      - "All key stakeholders interviewed"
      - "Interview notes documented"
      - "Key requirements extracted"
    outputs:
      - path: "docs/requirements/interview_notes/"
        type: "directory"
    required_inputs:
      - "Stakeholder list"
      - "Interview questions template"

  - id: "S0-A-002"
    name: "Create BRD"
    description: |
      Develop Business Requirement Document based on stakeholder interviews.
      Include business objectives, functional requirements, and constraints.
    skill: "ln-111-root-docs-creator"
    estimated_duration: "5d"
    dependencies: ["S0-A-001"]
    dod_criteria:
      - "Business objectives documented"
      - "Functional requirements listed"
      - "Non-functional requirements defined"
      - "Client sign-off obtained"
    outputs:
      - path: "docs/requirements/brd.md"
        type: "document"
    required_inputs:
      - "Interview notes"
      - "Existing documentation"

  - id: "S0-A-003"
    name: "Create PRD"
    description: |
      Develop Product Requirement Document with user stories and acceptance criteria.
    skill: "ln-112-project-core-creator"
    estimated_duration: "5d"
    dependencies: ["S0-A-002"]
    dod_criteria:
      - "User stories defined with acceptance criteria"
      - "User journeys mapped"
      - "Wireframe references included"
    outputs:
      - path: "docs/requirements/prd.md"
        type: "document"
    required_inputs:
      - "BRD"

  - id: "S0-A-004"
    name: "Design Wireframe"
    description: |
      Create wireframe designs for all screens using Figma or Axure RP.
    skill: "manual"
    estimated_duration: "7d"
    dependencies: ["S0-A-003"]
    dod_criteria:
      - "All screens designed"
      - "User flows connected"
      - "Interactive prototype available"
    outputs:
      - path: "figma_link_or_docs/wireframes/"
        type: "design"
    required_inputs:
      - "PRD"
      - "User journeys"

  - id: "S0-A-005"
    name: "Design Hi-Fi Pages"
    description: |
      Create high-fidelity UI designs based on wireframes.
      Include color, font, icon, button, and layout specifications.
    skill: "manual"
    estimated_duration: "7d"
    dependencies: ["S0-A-004"]
    dod_criteria:
      - "All wireframes converted to Hi-Fi"
      - "Design system documented"
      - "Component library created"
    outputs:
      - path: "figma_link_or_docs/hifi_designs/"
        type: "design"
    required_inputs:
      - "Wireframe"
      - "Brand guidelines"

  - id: "S0-A-006"
    name: "Design Service Model"
    description: |
      Create service model diagram showing system components and their interactions.
    skill: "ln-623-architecture-auditor"
    estimated_duration: "3d"
    dependencies: ["S0-A-003"]
    dod_criteria:
      - "All services identified"
      - "Service boundaries defined"
      - "Communication patterns documented"
    outputs:
      - path: "docs/architecture/service_model.md"
        type: "document"
      - path: "diagrams/service_model.mmd"
        type: "diagram"
    required_inputs:
      - "PRD"
      - "Technology stack"

  - id: "S0-A-007"
    name: "Design Technical Architecture"
    description: |
      Create comprehensive technical architecture documentation.
    skill: "ln-623-architecture-auditor"
    estimated_duration: "5d"
    dependencies: ["S0-A-006"]
    dod_criteria:
      - "Architecture patterns documented"
      - "Technology stack finalized"
      - "Security architecture included"
      - "Scalability plan defined"
    outputs:
      - path: "docs/architecture/technical_architecture.md"
        type: "document"
    required_inputs:
      - "Service Model"
      - "Non-functional requirements"

  - id: "S0-A-008"
    name: "Design Integration Architecture"
    description: |
      Create integration architecture diagram showing connections with surrounding systems.
    skill: "ln-623-architecture-auditor"
    estimated_duration: "3d"
    dependencies: ["S0-A-007"]
    dod_criteria:
      - "All integration points identified"
      - "API contracts defined"
      - "Data flow documented"
    outputs:
      - path: "docs/architecture/integration_architecture.md"
        type: "document"
      - path: "diagrams/integration.mmd"
        type: "diagram"
    required_inputs:
      - "Technical Architecture"
      - "Third-party system list"

  - id: "S0-A-009"
    name: "Design Database Schema"
    description: |
      Create database design with entity relationships and scripts.
    skill: "ln-722-backend-generator"
    estimated_duration: "3d"
    dependencies: ["S0-A-006"]
    dod_criteria:
      - "ERD created"
      - "Tables designed"
      - "Indexes planned"
      - "Migration scripts created"
    outputs:
      - path: "docs/database/schema.md"
        type: "document"
      - path: "scripts/database/"
        type: "scripts"
    required_inputs:
      - "Service Model"
      - "Data requirements"

  - id: "S0-A-010"
    name: "Prepare Master Data"
    description: |
      Prepare initial master data and loading scripts.
    skill: "manual"
    estimated_duration: "2d"
    dependencies: ["S0-A-009"]
    dod_criteria:
      - "Master data identified"
      - "Data scripts created"
      - "Loading verified in dev environment"
    outputs:
      - path: "scripts/master_data/"
        type: "scripts"
    required_inputs:
      - "Database schema"
      - "Business data requirements"

  - id: "S0-A-011"
    name: "Develop Frontend Code Scaffold"
    description: |
      Create initial frontend project structure with framework configuration.
    skill: "ln-721-frontend-restructure"
    estimated_duration: "2d"
    dependencies: ["S0-A-007"]
    dod_criteria:
      - "Project structure created"
      - "Build configuration working"
      - "Development server running"
    outputs:
      - path: "src/frontend/"
        type: "code"
    required_inputs:
      - "Technical Architecture"
      - "Frontend framework choice"

  - id: "S0-A-012"
    name: "Develop Backend Code Scaffold"
    description: |
      Create initial backend project structure with framework configuration.
    skill: "ln-722-backend-generator"
    estimated_duration: "2d"
    dependencies: ["S0-A-007"]
    dod_criteria:
      - "Project structure created"
      - "Build configuration working"
      - "Basic API endpoints functional"
    outputs:
      - path: "src/backend/"
        type: "code"
    required_inputs:
      - "Technical Architecture"
      - "Backend framework choice"

  - id: "S0-A-013"
    name: "Configure DevOps Pipeline"
    description: |
      Setup CI/CD pipeline for the project.
    skill: "ln-732-cicd-generator"
    estimated_duration: "2d"
    dependencies: ["S0-A-011", "S0-A-012"]
    dod_criteria:
      - "CI pipeline configured"
      - "CD pipeline configured"
      - "Quality gates integrated"
    outputs:
      - path: ".github/workflows/"
        type: "config"
    required_inputs:
      - "Frontend scaffold"
      - "Backend scaffold"

  - id: "S0-A-014"
    name: "Request IaaS/PaaS Resources"
    description: |
      Identify and request infrastructure resources.
    skill: "manual"
    estimated_duration: "3d"
    dependencies: ["S0-A-007"]
    dod_criteria:
      - "Resource requirements documented"
      - "Request submitted"
      - "Approval obtained"
    outputs:
      - path: "docs/infrastructure/resource_list.md"
        type: "document"
    required_inputs:
      - "Technical Architecture"
      - "Scaling requirements"

  - id: "S0-A-015"
    name: "Request Third-Party Accounts"
    description: |
      Request and configure third-party service accounts.
    skill: "manual"
    estimated_duration: "3d"
    dependencies: ["S0-A-007"]
    dod_criteria:
      - "Account list documented"
      - "Accounts created"
      - "Credentials secured"
    outputs:
      - path: "docs/infrastructure/third_party_accounts.md"
        type: "document"
    required_inputs:
      - "Integration Architecture"
      - "Third-party requirements"
```

---

## Phase 2: Sprint 1...N

### Task Template: SN-XXX

```yaml
phase: "Sprint N"
task_prefix: "SN"
sprint_duration: "2 weeks"

recurring_tasks:
  - id: "SN-001"
    name: "Sprint Planning"
    description: |
      Plan sprint scope, assign stories, estimate efforts.
    skill: "ln-210-epic-coordinator"
    estimated_duration: "0.5d"
    dod_criteria:
      - "Sprint backlog finalized"
      - "Story points assigned"
      - "Team commitment obtained"

  - id: "SN-002"
    name: "Story Development"
    description: |
      Develop user stories per acceptance criteria.
    skill: "ln-400-story-executor"
    estimated_duration: "7-8d"
    dod_criteria:
      - "Code implements acceptance criteria"
      - "Unit tests passing"
      - "Code review completed"

  - id: "SN-003"
    name: "Daily Scrum"
    description: |
      Daily standup meeting for sync.
    skill: "manual"
    estimated_duration: "15min/day"
    dod_criteria:
      - "Blockers identified"
      - "Progress communicated"

  - id: "SN-004"
    name: "Code Review"
    description: |
      Review code for quality and standards.
    skill: "ln-501-code-quality-checker"
    estimated_duration: "ongoing"
    dod_criteria:
      - "All PRs reviewed"
      - "Quality standards met"

  - id: "SN-005"
    name: "Sprint Demo"
    description: |
      Demonstrate completed features to stakeholders.
    skill: "manual"
    estimated_duration: "1h"
    dod_criteria:
      - "Demo completed"
      - "Feedback documented"
      - "Acceptance confirmed"

  - id: "SN-006"
    name: "Sprint Retrospective"
    description: |
      Review sprint, identify improvements.
    skill: "manual"
    estimated_duration: "1h"
    dod_criteria:
      - "What went well identified"
      - "Improvements planned"
      - "Action items assigned"
```

---

## Phase 3: SIT

### Task Template: SIT-XXX

```yaml
phase: "SIT"
task_prefix: "SIT"

tasks:
  - id: "SIT-001"
    name: "SIT Environment Setup"
    description: |
      Setup SIT environment including database, services, and configurations.
    skill: "ln-731-docker-generator"
    estimated_duration: "2d"
    dod_criteria:
      - "SIT database created"
      - "Services deployed"
      - "Configuration verified"

  - id: "SIT-002"
    name: "Integration Testing"
    description: |
      Test integration interfaces with surrounding systems.
    skill: "ln-512-manual-tester"
    estimated_duration: "3d"
    dod_criteria:
      - "All interfaces tested"
      - "Integration verified"
      - "Issues logged"

  - id: "SIT-003"
    name: "Functionality Testing"
    description: |
      Test all functionality and business flows.
    skill: "ln-512-manual-tester"
    estimated_duration: "5d"
    dod_criteria:
      - "All test cases executed"
      - "Results documented"
      - "Defects logged"

  - id: "SIT-004"
    name: "Defect Triage & Fix"
    description: |
      Prioritize and fix defects found during SIT.
    skill: "ln-401-task-executor"
    estimated_duration: "ongoing"
    dod_criteria:
      - "Critical defects fixed"
      - "Retesting completed"

  - id: "SIT-005"
    name: "Generate SIT Report"
    description: |
      Create SIT completion report.
    skill: "ln-600-docs-auditor"
    estimated_duration: "1d"
    dod_criteria:
      - "Test metrics documented"
      - "Defect summary included"
      - "Sign-off recommendation"

  - id: "SIT-006"
    name: "SIT Sign-Off"
    description: |
      Obtain formal SIT sign-off.
    skill: "manual"
    estimated_duration: "1d"
    dod_criteria:
      - "Sign-off document signed"
      - "Exit criteria met"
```

---

## Phase 4-7: Abbreviated Templates

> See SKILL.md for complete task definitions for UAT, Data Migration, Go-Live, and Operate phases.

---

**Template Version:** 1.0.0
**Last Updated:** 2026-01-24
