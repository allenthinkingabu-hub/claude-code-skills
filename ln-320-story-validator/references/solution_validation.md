# Solution & Standards Validation (Criteria #5-#8)

Detailed rules for solution optimization, library versions, test strategy, and documentation integration.

---

## Criterion #5: Solution Optimization (Phase 2 Findings)

**Check:** Technical approach follows industry standards researched in Phase 2

⚠️ **Important:** This criterion does NOT call MCP Ref directly. It uses findings from Phase 2 research (guides created by ln-321).

✅ **GOOD:**
- OAuth implementation: "Using RFC 6749 compliant `/token` endpoint with grant_type parameter"
- Error handling: "Following RFC 7807 Problem Details for HTTP APIs"
- REST API: "Resource-based URLs with proper HTTP methods (GET /users, POST /users)"

❌ **BAD:**
- "Custom auth mechanism for simplicity" (ignores OAuth RFC 6749)
- "Return errors as plain text" (ignores RFC 7807 standard)
- "Use GET for mutations" (violates REST principles)

**Auto-fix actions:**
1. Read findings from Phase 2 `research_results` (guides already created by ln-321)
2. Extract standards/patterns from guides (RFC numbers, OWASP rules, do/don't/when patterns)
3. Compare Story Technical Notes with standards from findings
4. IF Story violates standard:
   - Rewrite Technical Notes with RFC-compliant approach from guide
   - Add reference to guide (e.g., "See [Guide-05: REST API Patterns](docs/guides/05-rest-api-patterns.md)")
5. Update Linear issue via `mcp__linear-server__update_issue`
6. Add comment: "Solution updated to comply with [Standards list] - see guides created in Phase 2"

**Example transformation:**

**Before:**
```markdown
## Technical Notes
We'll create custom login endpoint `/do-login` that accepts username/password
and returns a session cookie.
```

**After (Phase 2 findings from oauth2-proxy Manual + Auth ADR):**
```markdown
## Technical Notes

### Standards Compliance
- OAuth 2.0 (RFC 6749): Resource Owner Password Credentials Grant
- Token endpoint: POST /token with grant_type=password
- See [Manual: oauth2-proxy v7](docs/manuals/oauth2-proxy-v7.md) for implementation details
- Architecture decision: [ADR-003: Authentication Strategy](docs/adrs/003-auth-strategy.md)

### Architecture Considerations
OAuth 2.0 compliant authentication flow:
1. Client sends POST /token with { grant_type, username, password }
2. Server validates credentials
3. Returns { access_token, token_type, expires_in, refresh_token }
4. Client uses Bearer token for subsequent requests
```

**Skip Fix When:**
- Solution already references specific RFC/standard from Phase 2 guides
- Story in Done/Canceled status

---

## Criterion #6: Library & Version (Phase 2 Findings)

**Check:** Libraries are latest stable versions from Phase 2 research

⚠️ **Important:** This criterion does NOT call Context7/WebSearch directly. It uses findings from Phase 2 research (manuals created by ln-321).

✅ **GOOD:**
- "Using express v4.19.2 (latest stable as of 2025-01)"
- "Prisma v5.8.1 (current stable, verified via npm)"
- "OAuth2-proxy v7.6.0 (latest release)"

❌ **BAD:**
- "Using express v3.x" (outdated, v4.x available)
- "Any JWT library" (no specific version)
- "Latest version" (no verification)

**Auto-fix actions:**
1. Extract library versions from manuals created in Phase 2 research
2. For EACH library in Phase 2 findings:
   - Read recommended version from manual (e.g., Manual: oauth2-proxy v7.6.0)
   - Compare with Story Technical Notes current version
3. IF outdated or unspecified → Update Technical Notes with recommended version from manual
4. Add manual reference: "See [Manual: oauth2-proxy v7](docs/manuals/oauth2-proxy-v7.md) for API details"
5. Update Linear issue via `mcp__linear-server__update_issue`
6. Add comment: "Library versions updated from Phase 2 manuals - [list of manuals]"

**Example transformation:**

**Before:**
```markdown
## Technical Notes

### Integration Points
- Use Passport.js for authentication
- PostgreSQL database
```

**After (Phase 2 manuals: passport-v0.7.md, prisma-v5.md):**
```markdown
## Technical Notes

### Integration Points
- Passport.js v0.7.0 (latest stable, see [Manual: Passport v0.7](docs/manuals/passport-v0.7.md))
- PostgreSQL v16.1 (compatible with Prisma v5.8.1, see [Manual: Prisma v5](docs/manuals/prisma-v5.md))

### Library References
| Library | Version | Manual | Phase 2 Research |
|---------|---------|--------|------------------|
| passport | v0.7.0 | docs/manuals/passport-v0.7.md | ln-321 verified |
| @prisma/client | v5.8.1 | docs/manuals/prisma-v5.md | ln-321 verified |
| postgresql | v16.1 | External dependency | Compatible check |
```

**Skip Fix When:**
- All libraries have specific versions matching Phase 2 manuals
- No library manuals created in Phase 2 (no library patterns detected)
- Story in Done/Canceled status

---

## Criterion #7: Test Strategy Section (Empty Placeholder)

**Check:** Test Strategy section exists but is EMPTY (testing planned by ln-350-story-test-planner)

⚠️ **Critical:** Test Strategy MUST be empty in Story. ln-350-story-test-planner creates comprehensive test plan in final Task.

✅ **GOOD:**
```markdown
## Test Strategy

_Testing will be planned by ln-350-story-test-planner in final Task_
```

❌ **BAD:**
```markdown
## Test Strategy

Unit tests:
- Test login() function
- Test token validation

E2E tests:
- Test login flow
- Test protected routes
```

**Auto-fix actions:**
1. Check if Test Strategy section exists
2. IF missing → Add empty section:
   ```markdown
   ## Test Strategy

   _Testing will be planned by ln-350-story-test-planner in final Task_
   ```
3. IF contains content → Clear content, add placeholder
4. Update Linear issue via `mcp__linear-server__update_issue`
5. Add comment: "Test Strategy cleared - ln-350 will create comprehensive test plan in final Task"

**Rationale:**
- ln-350 analyzes ALL implementation Tasks to create Risk-Based Test Plan
- Premature test planning in Story = incomplete coverage (Tasks not decomposed yet)
- Test Strategy in Story conflicts with ln-350's comprehensive approach

**Skip Fix When:**
- Story in Done/Canceled status
- Story older than 30 days (legacy)

---

## Criterion #8: Documentation Integration (No Standalone Doc Tasks)

**Check:** No separate Tasks for documentation - docs integrated into implementation Tasks

⚠️ **Important:** Documentation should be part of Definition of Done for each Task, NOT separate Tasks.

✅ **GOOD (Integrated):**
```markdown
## Implementation Tasks

1. **[Task] Implement OAuth 2.0 token endpoint**
   - Location: ln-220-story-coordinator/kanban_board.md, US-123-T1
   - Definition of Done:
     - [ ] Endpoint accepts grant_type parameter
     - [ ] Returns RFC 6749 compliant token response
     - [ ] **API docs updated in docs/api/authentication.md**
     - [ ] **README.md authentication section updated**

2. **[Task] Add rate limiting middleware**
   - Location: ln-220-story-coordinator/kanban_board.md, US-123-T2
   - Definition of Done:
     - [ ] Middleware configured with 100 req/min limit
     - [ ] **Rate limiting documented in Technical Guide**
```

❌ **BAD (Separate Doc Tasks):**
```markdown
## Implementation Tasks

1. **[Task] Implement OAuth endpoint**
2. **[Task] Add rate limiting**
3. **[Task] Write API documentation**  ❌ Separate doc task
4. **[Task] Update README**  ❌ Separate doc task
```

**Auto-fix actions:**
1. Parse Implementation Tasks list
2. Identify standalone doc Tasks (keywords: "Write docs", "Update README", "Create manual", "Document API")
3. IF standalone doc Task found:
   - Remove standalone doc Task from list
   - Add doc requirement to related implementation Task's Definition of Done
   - Merge documentation details into implementation Task description
4. Update Linear issue via `mcp__linear-server__update_issue`
5. Add comment: "Documentation integrated into implementation Tasks (no standalone doc Tasks)"

**Example transformation:**

**Before:**
```markdown
## Implementation Tasks

1. [Task] Implement login endpoint - US-123-T1
2. [Task] Add token validation middleware - US-123-T2
3. [Task] Write authentication documentation - US-123-T3  ❌
```

**After:**
```markdown
## Implementation Tasks

1. **[Task] Implement login endpoint** - US-123-T1
   - Definition of Done includes: Update docs/api/auth.md with endpoint spec

2. **[Task] Add token validation middleware** - US-123-T2
   - Definition of Done includes: Document middleware usage in README.md
```

**Rationale:**
- Documentation describes implementation → should be created WITH implementation
- Separate doc Tasks = outdated docs (implemented ≠ documented)
- Integrated docs = Definition of Done ensures docs updated

**Skip Fix When:**
- Story in Done/Canceled status
- Documentation Task is for architecture decision (ADR) - these CAN be separate
- Documentation Task is for user-facing guide (not implementation docs)

---

## Execution Notes

**Sequential Dependency:**
- Criteria #5-#8 depend on #1-#4 being completed first
- Cannot optimize solution (#5) until structure (#1-#2) is correct
- Cannot verify libraries (#6) until Technical Notes exist (#1)

**Phase 2 Integration:**
- Criteria #5-#6 DO NOT call MCP Ref/Context7 directly
- They READ findings from Phase 2 research (guides/manuals created by ln-321)
- All research completed BEFORE Phase 4 auto-fix begins

**Linear Updates:**
- Each criterion auto-fix updates Linear issue once
- Add single comment summarizing ALL fixes in this category

---

**Version:** 1.0.0
**Last Updated:** 2025-12-21
