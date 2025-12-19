# DevOps Documentation Questions (Q46-Q48)

**Purpose:** Validation questions for runbook.md.

---

## Table of Contents

| Document | Questions | Auto-Discovery | Condition |
|----------|-----------|----------------|-----------|
| [runbook.md](#docsprojectrunbookmd) | 3 | High | hasDocker |

---

<!-- DOCUMENT_START: docs/project/runbook.md -->
## docs/project/runbook.md

**File:** docs/project/runbook.md (operations guide)
**Rules:** Step-by-step instructions, env vars documented, troubleshooting

---

<!-- QUESTION_START: 46 -->
### Question 46: How do I set up the project locally?

**Expected Answer:** Prerequisites, installation steps, run commands
**Target Section:** ## Local Development Setup

**Validation Heuristics:**
- Lists prerequisites with versions
- Has numbered installation steps
- Has run commands for development

**Auto-Discovery:**
- Check: package.json -> "engines" for versions
- Check: package.json -> "scripts" (dev, start, build)
- Check: README.md for setup instructions
- Check: Dockerfile for runtime requirements
<!-- QUESTION_END: 46 -->

---

<!-- QUESTION_START: 47 -->
### Question 47: How is the application deployed?

**Expected Answer:** Deployment target, build commands, env vars, deploy steps
**Target Section:** ## Deployment

**Validation Heuristics:**
- Mentions deployment platform
- Has build commands
- Lists required env vars
- Shows deployment steps or CI/CD pipeline

**Auto-Discovery:**
- Check: package.json -> "scripts" -> "build"
- Check: .env.example for env vars
- Check: Dockerfile, vercel.json, .platform.app.yaml
- Check: .github/workflows/ for CI/CD
<!-- QUESTION_END: 47 -->

---

<!-- QUESTION_START: 48 -->
### Question 48: How do I troubleshoot common issues?

**Expected Answer:** Common errors, debugging techniques, log locations
**Target Section:** ## Troubleshooting

**Validation Heuristics:**
- Lists common errors and solutions
- Mentions debugging techniques
- Shows log locations or commands

**Auto-Discovery:**
- Check: package.json for logging libraries (winston, pino)
- Scan: README.md for troubleshooting section
<!-- QUESTION_END: 48 -->

---

**Overall File Validation:**
- Has SCOPE tag in first 10 lines
- Has setup, deployment, troubleshooting sections
- All env vars from .env.example documented

<!-- DOCUMENT_END: docs/project/runbook.md -->

---

**Total Questions:** 3
**Total Documents:** 1

---
**Version:** 1.0.0
**Last Updated:** 2025-12-19
