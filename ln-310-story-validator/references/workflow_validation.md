# Workflow & Principles Validation (Criteria #9-#12)

Detailed rules for Story size, test cleanup, YAGNI, and KISS principles.

---

## Criterion #9: Story Size (3-8 Tasks)

**Check:** Story has 3-8 implementation Tasks (optimal decomposition)

⚠️ **Important:** Task count indicates proper decomposition. Too few = monolithic, too many = over-decomposed.

✅ **GOOD:**
- 3 Tasks: Small feature (add API endpoint + validation + tests)
- 5 Tasks: Medium feature (OAuth integration: DB schema + service + routes + middleware + tests)
- 8 Tasks: Large feature (User management: models + CRUD + auth + permissions + profile + tests + docs + migration)

❌ **BAD:**
- 1-2 Tasks: Monolithic (entire feature in one Task)
- 10+ Tasks: Over-decomposed (each file = separate Task)

**Optimal Task Count by Complexity:**

| Complexity | Task Count | Example |
|------------|------------|---------|
| Simple | 3-4 | Add single endpoint with validation |
| Medium | 5-6 | Integrate external service (OAuth, Stripe) |
| Complex | 7-8 | Implement multi-step workflow (registration, checkout) |

**Auto-fix actions:**
1. Count implementation Tasks (exclude final test Task created by ln-510)
2. IF <3 Tasks:
   - Suggest decomposition: "Story too large - consider splitting into multiple Stories"
   - Add comment to Linear: "Large Story detected - recommend decomposition"
   - **DO NOT auto-split** (requires user decision)
3. IF >8 Tasks:
   - **INVOKE ln-300-task-coordinator** in REPLAN mode:
     ```
     Skill(skill="ln-300-task-coordinator",
          args="story_id=[STORY_ID] mode=REPLAN")
     ```
   - ln-300 will:
     - Build IDEAL plan with optimal task count (3-8)
     - Delegate to ln-302-task-replanner to update existing Tasks
     - Return summary with updated Task URLs
   - Update kanban_board.md with new Task structure
   - Add Linear comment: "Story decomposed via ln-300 - optimal task count achieved"
4. Add comment: "Story size optimized - [N] Tasks (within 3-8 range)"

**Example transformation:**

**Before (Over-decomposed - 12 Tasks):**
```markdown
## Implementation Tasks

1. Create User model
2. Create User repository
3. Create User service
4. Create User controller
5. Create GET /users route
6. Create GET /users/:id route
7. Create POST /users route
8. Create PUT /users/:id route
9. Create DELETE /users/:id route
10. Add validation middleware
11. Add error handling
12. Write tests
```

**After (Consolidated - 5 Tasks):**
```markdown
## Implementation Tasks

1. **[Task] User model + repository layer** - US-123-T1
   - Create User model (schema, types)
   - Implement repository (CRUD operations)

2. **[Task] User service layer** - US-123-T2
   - Business logic (validation, transformation)
   - Error handling

3. **[Task] User API endpoints** - US-123-T3
   - Implement all 5 routes (GET, POST, PUT, DELETE)
   - Request validation middleware

4. **[Task] Integration tests** - US-123-T4
   - E2E tests for all endpoints
   - Error scenarios

5. **[Task] Final test suite** - US-123-T5 (created by ln-510)
```

**Integration with ln-300:**
- ln-310 invokes ln-300 when >8 Tasks detected
- ln-300 builds IDEAL plan (Foundation-First order)
- ln-300 delegates to ln-302 for existing Task updates
- ln-310 receives summary and continues validation

**Skip Fix When:**
- Story in Done/Canceled status
- User explicitly requested specific Task count

---

## Criterion #10: Test Cleanup (No Premature Test Tasks)

**Check:** No separate test Tasks BEFORE final Task (testing handled by ln-510 in final Task)

⚠️ **Critical:** Only ln-510-test-planner creates test Task as FINAL Task. No premature test Tasks allowed.

✅ **GOOD:**
```markdown
## Implementation Tasks

1. [Task] Implement login endpoint - US-123-T1
2. [Task] Add token validation - US-123-T2
3. [Task] Add rate limiting - US-123-T3
4. [Task] Comprehensive test suite - US-123-T4 (ln-510 creates this)
```

❌ **BAD:**
```markdown
## Implementation Tasks

1. [Task] Implement login endpoint - US-123-T1
2. [Task] Write unit tests for login - US-123-T2  ❌ Premature
3. [Task] Add token validation - US-123-T3
4. [Task] Write integration tests - US-123-T4  ❌ Premature
5. [Task] Final test suite - US-123-T5
```

**Auto-fix actions:**
1. Grep Implementation Tasks list for test-related keywords: "test", "spec", "e2e", "integration", "unit"
2. IF test Task found BEFORE final Task:
   - Remove premature test Tasks from list
   - Add testing note to related implementation Task's Definition of Done
3. Ensure ONLY final Task mentions comprehensive testing
4. Update Linear issue via `mcp__linear-server__update_issue`
5. Add comment: "Test Tasks consolidated - ln-510 will create comprehensive test plan in final Task"

**Rationale:**
- ln-510 analyzes ALL implementation Tasks to create Risk-Based Test Plan
- Premature test Tasks = incomplete coverage (don't know all functionality yet)
- Final comprehensive test Task covers all scenarios identified by ln-510

**Example transformation:**

**Before:**
```markdown
## Implementation Tasks

1. [Task] Create User model - US-123-T1
2. [Task] Unit tests for User model - US-123-T2  ❌
3. [Task] Create User API - US-123-T3
4. [Task] Integration tests for API - US-123-T4  ❌
5. [Task] Final E2E tests - US-123-T5
```

**After:**
```markdown
## Implementation Tasks

1. **[Task] Create User model** - US-123-T1
   - Definition of Done includes: Model passes basic validation

2. **[Task] Create User API** - US-123-T2
   - Definition of Done includes: Endpoints return correct status codes

3. **[Task] Comprehensive test suite** - US-123-T3 (ln-510 creates)
   - Risk-based test plan covering all scenarios
```

**Skip Fix When:**
- Story in Done/Canceled status
- Final Task already created by ln-510

---

## Criterion #11: YAGNI (You Aren't Gonna Need It)

**Check:** Story scope limited to current requirements (no speculative features)

⚠️ **CRITICAL:** YAGNI applies UNLESS Industry Standards (#16) require it. Standards override YAGNI.

**YAGNI Hierarchy:**
```
Level 1: Industry Standards (RFC, OWASP, REST) → CANNOT remove
Level 2: Security Standards (Auth, Encryption) → CANNOT remove
Level 3: YAGNI → Apply ONLY if no conflict with Level 1-2
```

✅ **GOOD (Standards Override YAGNI):**
- OAuth Story includes refresh token flow (RFC 6749 requires it, even if "not needed yet")
- Error handling includes all HTTP status codes (RFC 7231 defines them, even if "won't use 451")
- API includes CORS headers (Security standard, even if "no external clients yet")

✅ **GOOD (YAGNI Applies - No Standard):**
- Login Story does NOT include social auth (GitHub, Google) if not required now
- User API does NOT include export to CSV/PDF if not required now
- Payment does NOT include multi-currency if only USD needed now

❌ **BAD (Violates YAGNI - No Standard Justification):**
- "Add support for 10 languages (only English needed now)" ❌
- "Implement caching layer (no performance issue yet)" ❌
- "Add GraphQL API (REST sufficient for now)" ❌

❌ **BAD (Violates Standards by Invoking YAGNI):**
- "Skip refresh tokens for simplicity" (violates RFC 6749) ❌
- "Only return 200/500 errors for simplicity" (violates RFC 7231) ❌
- "Use custom auth for simplicity" (violates OAuth RFC 6749) ❌

**Auto-fix actions:**
1. Parse Technical Notes → Identify speculative features (keywords: "future-proof", "might need", "prepare for", "in case")
2. Check if feature required by Industry Standard:
   - IF YES → Keep feature, add justification: "Required by [RFC/Standard]"
   - IF NO → Remove feature, add TODO comment: "Future: [feature] when needed"
3. Update Linear issue via `mcp__linear-server__update_issue`
4. Add comment: "YAGNI applied - removed speculative features (or kept per RFC X)"

**Example transformation:**

**Before:**
```markdown
## Technical Notes

### Architecture Considerations
- Multi-tenant database (might need in future)
- WebSocket support (in case of real-time requirements)
- OAuth + SAML + LDAP (future-proof auth)
```

**After:**
```markdown
## Technical Notes

### Architecture Considerations
- Single-tenant database (current requirement)
- REST API with polling (sufficient for now)
- OAuth 2.0 only (RFC 6749 compliant, SAML/LDAP when needed)

### Future Considerations (Not in Scope)
- Multi-tenancy: Implement when second customer onboarded
- Real-time: Add WebSocket when polling latency >5s
- SAML/LDAP: Add when enterprise customers require SSO
```

**Skip Fix When:**
- Feature required by RFC/OWASP/Industry Standard
- Feature required by Security Standard
- Story in Done/Canceled status

---

## Criterion #12: KISS (Keep It Simple, Stupid)

**Check:** Solution uses simplest approach that meets requirements

⚠️ **CRITICAL:** KISS applies UNLESS Industry Standards (#16) require complexity. Standards override KISS.

**KISS Hierarchy:**
```
Level 1: Industry Standards (RFC, OWASP, REST) → CANNOT simplify
Level 2: Security Standards → CANNOT simplify
Level 3: KISS → Apply ONLY if no conflict with Level 1-2
```

✅ **GOOD (Standards Override KISS):**
- OAuth 2.0 flow with grant_type, redirect_uri, state parameters (RFC 6749 requires, even if "complex")
- Helmet.js with 11 security headers (OWASP requires, even if "seems excessive")
- RESTful API with proper HTTP methods (REST principles require, even if "GET only simpler")

✅ **GOOD (KISS Applies - No Standard):**
- Use bcrypt for password hashing (simpler than Argon2, sufficient for most cases)
- Use environment variables for config (simpler than Vault, sufficient for small apps)
- Use SQLite for local dev (simpler than Docker Postgres)

❌ **BAD (Over-engineered - No Standard Justification):**
- "Use microservices for 3-endpoint API" (monolith simpler, no scale requirement) ❌
- "Use Kubernetes for single server" (Docker Compose simpler) ❌
- "Use Redis caching before any performance issue" (in-memory simpler) ❌

❌ **BAD (Violates Standards by Invoking KISS):**
- "Use session cookies instead of JWT for simplicity" (violates stateless REST if API) ❌
- "Skip HTTPS for simplicity" (violates OWASP, security standard) ❌
- "Use MD5 for passwords for simplicity" (violates security standards) ❌

**Auto-fix actions:**
1. Parse Technical Notes → Identify over-engineered solutions (keywords: "microservice", "kubernetes", "distributed", "event-driven")
2. Check if complexity justified by Standard:
   - IF YES → Keep solution, add justification: "Required by [RFC/Standard]"
   - IF NO → Simplify solution, suggest simpler alternative
3. Evaluate if simpler alternative meets requirements:
   - Monolith before microservices
   - In-memory before Redis
   - SQLite before PostgreSQL (for dev/small apps)
4. Update Linear issue via `mcp__linear-server__update_issue`
5. Add comment: "KISS applied - simplified solution (or kept per RFC X)"

**Example transformation:**

**Before:**
```markdown
## Technical Notes

### Architecture Considerations
- Microservices architecture (user-service, auth-service, notification-service)
- Kubernetes deployment with 3 replicas per service
- Redis for caching + RabbitMQ for messaging
- Event-driven architecture with CQRS pattern
```

**After (Simplified - No Scale Requirement):**
```markdown
## Technical Notes

### Architecture Considerations
- Monolithic Node.js/Express application (3 endpoints, <100 users)
- Single Docker container deployment
- In-memory caching (sufficient for <1000 req/min)
- Direct function calls (no messaging needed for synchronous operations)

### When to Scale
- Microservices: When >5 teams working independently
- Kubernetes: When >10 containers or multi-region deployment
- Redis: When in-memory cache >1GB or multi-instance deployment
- Messaging: When async operations >1000/min
```

**Skip Fix When:**
- Complexity required by RFC/OWASP/Industry Standard
- Complexity required by Security Standard
- Scale requirements documented (>10,000 users, >1M req/day)
- Story in Done/Canceled status

---

## Auto-Fix Hierarchy (CRITICAL)

**Order of Checks:**
```
1. Industry Standards (#16) → CHECKED FIRST
2. Security Standards → CHECKED SECOND
3. KISS/YAGNI (#11-#12) → CHECKED LAST
```

**Decision Flow:**
```
Does solution violate Industry Standard (RFC, OWASP, REST)?
  → YES: Keep complex solution, add standard justification
  → NO: Continue to KISS/YAGNI check

Does simplified solution compromise security?
  → YES: Keep complex solution, add security justification
  → NO: Apply KISS/YAGNI simplification
```

**Example Scenarios:**

| Proposed Simplification | Standard Check | Decision |
|-------------------------|----------------|----------|
| "Skip refresh tokens" | RFC 6749 requires | ❌ REJECT - Keep refresh tokens |
| "Use GET for mutations" | REST violates | ❌ REJECT - Use POST/PUT/DELETE |
| "Skip CORS headers" | Security standard | ❌ REJECT - Keep CORS |
| "Remove Redis caching" | No standard | ✅ ACCEPT - Use in-memory |
| "Remove microservices" | No standard | ✅ ACCEPT - Use monolith |
| "Remove Kubernetes" | No standard | ✅ ACCEPT - Use Docker Compose |

---

## Execution Notes

**Sequential Dependency:**
- Criteria #9-#12 depend on #5-#8 being completed first
- Cannot apply YAGNI/KISS (#11-#12) until Industry Standards verified (#16)
- Cannot check test cleanup (#10) until Tasks decomposed

**Priority Enforcement:**
- Industry Standards > Security > KISS/YAGNI
- Never compromise standards for simplicity
- Document standard justification for complex solutions

**Linear Updates:**
- Each criterion auto-fix updates Linear issue once
- Add single comment summarizing ALL fixes in this category

---

**Version:** 1.0.0
**Last Updated:** 2025-12-21
