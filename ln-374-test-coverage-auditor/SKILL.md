---
name: ln-374-test-coverage-auditor
description: Coverage Gaps audit worker (L3). Identifies missing tests for critical paths (Money 20+, Security 20+, Data Integrity 15+, Core Flows 15+). Returns list of untested critical business logic with priority justification.
allowed-tools: Read, Grep, Glob, Bash
---

# Coverage Gaps Auditor (L3 Worker)

Specialized worker identifying missing tests for critical business logic.

## Purpose & Scope

- **Worker in ln-370 coordinator pipeline**
- Audit **Coverage Gaps** (Category 4: High Priority)
- Identify untested critical paths
- Classify by category (Money, Security, Data, Core Flows)
- Calculate compliance score (X/10)

## Inputs (from Coordinator)

Receives `contextStore` with critical paths classification, codebase structure, test file list.

## Workflow

1) Parse context
2) Identify critical paths in codebase
3) Check test coverage for each critical path
4) Collect missing tests
5) Calculate score
6) Return JSON

## Critical Paths Classification

### 1. Money Flows (Priority 20+)

**What:** Any code handling financial transactions

**Examples:**
- Payment processing (`/payment`, `processPayment()`)
- Discounts/promotions (`calculateDiscount()`, `applyPromoCode()`)
- Tax calculations (`calculateTax()`, `getTaxRate()`)
- Refunds (`processRefund()`, `/refund`)
- Invoices/billing (`generateInvoice()`, `createBill()`)
- Currency conversion (`convertCurrency()`)

**Min Priority:** 20

**Why Critical:** Money loss, fraud, legal compliance

### 2. Security Flows (Priority 20+)

**What:** Authentication, authorization, encryption

**Examples:**
- Login/logout (`/login`, `authenticate()`)
- Token refresh (`/refresh-token`, `refreshAccessToken()`)
- Password reset (`/forgot-password`, `resetPassword()`)
- Permissions/RBAC (`checkPermission()`, `hasRole()`)
- Encryption/hashing (custom crypto logic, NOT bcrypt/argon2)
- API key validation (`validateApiKey()`)

**Min Priority:** 20

**Why Critical:** Security breach, data leak, unauthorized access

### 3. Data Integrity (Priority 15+)

**What:** CRUD operations, transactions, validation

**Examples:**
- Critical CRUD (`createUser()`, `deleteOrder()`, `updateProduct()`)
- Database transactions (`withTransaction()`)
- Data validation (custom validators, NOT framework defaults)
- Data migrations (`runMigration()`)
- Unique constraints (`checkDuplicateEmail()`)

**Min Priority:** 15

**Why Critical:** Data corruption, lost data, inconsistent state

### 4. Core User Journeys (Priority 15+)

**What:** Multi-step flows critical to business

**Examples:**
- Registration → Email verification → Onboarding
- Search → Product details → Add to cart → Checkout
- Upload file → Process → Download result
- Submit form → Approval workflow → Notification

**Min Priority:** 15

**Why Critical:** Broken user flow = lost customers

## Audit Rules

### 1. Identify Critical Paths

**Process:**
- Scan codebase for money-related keywords: `payment`, `refund`, `discount`, `tax`, `price`, `currency`
- Scan for security keywords: `auth`, `login`, `password`, `token`, `permission`, `encrypt`
- Scan for data keywords: `transaction`, `validation`, `migration`, `constraint`
- Scan for user journeys: multi-step flows in routes/controllers

### 2. Check Test Coverage

**For each critical path:**
- Search test files for matching test name/description
- If NO test found → add to missing tests list
- If test found but inadequate (only positive, no edge cases) → add to gaps list

### 3. Categorize Gaps

**Severity by Priority:**
- **CRITICAL:** Priority 20+ (Money, Security)
- **HIGH:** Priority 15-19 (Data, Core Flows)
- **MEDIUM:** Priority 10-14 (Important but not critical)

### 4. Provide Justification

**For each missing test:**
- Explain WHY it's critical (money loss, security breach, etc.)
- Suggest test type (E2E, Integration, Unit)
- Estimate effort (S/M/L)

## Scoring Algorithm

```
critical_paths = count of critical paths
tested_paths = count of critical paths with tests
coverage_percentage = (tested_paths / critical_paths) * 100
score = coverage_percentage / 10  // 100% coverage = 10 score
score = max(0, min(10, score))
```

## Output Format

```json
{
  "category": "Coverage Gaps",
  "score": 6,
  "critical_paths_total": 25,
  "tested_paths": 15,
  "untested_paths": 10,
  "coverage_percentage": 60,
  "findings": [
    {
      "severity": "CRITICAL",
      "category": "Money",
      "missing_test": "E2E: Payment with discount code",
      "location": "services/payment.ts:processPayment()",
      "priority": 25,
      "justification": "Money calculation with discount logic — high risk of incorrect total",
      "test_type": "E2E",
      "effort": "M"
    },
    {
      "severity": "CRITICAL",
      "category": "Security",
      "missing_test": "Unit: Password reset token expiration",
      "location": "auth/reset-password.ts:validateResetToken()",
      "priority": 20,
      "justification": "Security vulnerability — expired tokens must be rejected",
      "test_type": "Unit",
      "effort": "S"
    },
    {
      "severity": "HIGH",
      "category": "Data Integrity",
      "missing_test": "Integration: Database transaction rollback on error",
      "location": "db/transaction.ts:withTransaction()",
      "priority": 18,
      "justification": "Data corruption risk — failed transactions must rollback completely",
      "test_type": "Integration",
      "effort": "M"
    },
    {
      "severity": "HIGH",
      "category": "Core Flow",
      "missing_test": "E2E: User registration → Email verification → First login",
      "location": "routes/auth.ts + routes/users.ts",
      "priority": 16,
      "justification": "Critical onboarding flow — broken flow loses new users",
      "test_type": "E2E",
      "effort": "L"
    }
  ]
}
```

---
**Version:** 1.0.0
**Last Updated:** 2025-12-21
