# Solution & Standards Validation (Criteria #5-#8)

Detailed rules for solution optimization, library versions, test strategy, and documentation integration.

---

## Criterion #5: Solution Optimization (MCP Ref + Standards Research)

**Check:** Technical approach follows industry standards (RFC, OWASP, REST) researched via MCP Ref

⚠️ **Important:** Use `mcp__Ref__ref_search_documentation` to verify solution against official docs, RFCs, and best practices.

✅ **GOOD:**
- OAuth implementation: "Using RFC 6749 compliant `/token` endpoint with grant_type parameter"
- Error handling: "Following RFC 7807 Problem Details for HTTP APIs"
- REST API: "Resource-based URLs with proper HTTP methods (GET /users, POST /users)"

❌ **BAD:**
- "Custom auth mechanism for simplicity" (ignores OAuth RFC 6749)
- "Return errors as plain text" (ignores RFC 7807 standard)
- "Use GET for mutations" (violates REST principles)

**Auto-fix actions:**
1. Parse Story Technical Notes → Identify solution domain (auth, API, errors, etc.)
2. Search relevant standards via MCP Ref:
   - Auth → `mcp__Ref__ref_search_documentation(query="OAuth 2.0 RFC 6749")`
   - Errors → `mcp__Ref__ref_search_documentation(query="RFC 7807 Problem Details")`
   - REST API → `mcp__Ref__ref_search_documentation(query="RESTful API best practices")`
3. Compare current solution with standard recommendations
4. IF non-compliant → Rewrite Technical Notes with RFC-compliant approach
5. Update Linear issue via `mcp__linear-server__update_issue`
6. Add comment: "Solution updated to follow [RFC/Standard] - see Technical Notes"

**Example transformation:**

**Before:**
```markdown
## Technical Notes
We'll create custom login endpoint `/do-login` that accepts username/password
and returns a session cookie.
```

**After (MCP Ref researched RFC 6749):**
```markdown
## Technical Notes

### Standards Research
- OAuth 2.0 (RFC 6749): Resource Owner Password Credentials Grant
- Token endpoint: POST /token with grant_type=password

### Architecture Considerations
OAuth 2.0 compliant authentication flow:
1. Client sends POST /token with { grant_type, username, password }
2. Server validates credentials
3. Returns { access_token, token_type, expires_in, refresh_token }
4. Client uses Bearer token for subsequent requests
```

**Skip Fix When:**
- Solution already references specific RFC/standard
- Story in Done/Canceled status

---

## Criterion #6: Library & Version Research (Context7 + WebSearch)

**Check:** Libraries are latest stable versions, researched via Context7 or WebSearch

⚠️ **Important:** Use `mcp__context7__resolve-library-id` + `mcp__context7__get-library-docs` or `WebSearch` to verify current versions.

✅ **GOOD:**
- "Using express v4.19.2 (latest stable as of 2025-01)"
- "Prisma v5.8.1 (current stable, verified via npm)"
- "OAuth2-proxy v7.6.0 (latest release)"

❌ **BAD:**
- "Using express v3.x" (outdated, v4.x available)
- "Any JWT library" (no specific version)
- "Latest version" (no verification)

**Auto-fix actions:**
1. Parse Technical Notes → Extract library names
2. For EACH library:
   - **Try Context7 first:**
     ```
     mcp__context7__resolve-library-id(libraryName="express")
     mcp__context7__get-library-docs(context7CompatibleLibraryID="/expressjs/express")
     ```
   - **Fallback to WebSearch:**
     ```
     WebSearch(query="express npm latest stable version 2025")
     ```
3. Compare Story versions with latest stable
4. IF outdated or unspecified → Update Technical Notes with specific version + verification source
5. Update Linear issue via `mcp__linear-server__update_issue`
6. Add comment: "Library versions verified - updated to latest stable (Context7/npm/GitHub)"

**Example transformation:**

**Before:**
```markdown
## Technical Notes

### Integration Points
- Use Passport.js for authentication
- PostgreSQL database
```

**After (Context7 researched):**
```markdown
## Technical Notes

### Integration Points
- Passport.js v0.7.0 (latest stable, verified via Context7)
- PostgreSQL v16.1 (current major version, compatible with Prisma v5.8.1)

### Library Verification
| Library | Version | Source | Date Verified |
|---------|---------|--------|---------------|
| passport | v0.7.0 | Context7 | 2025-01-15 |
| @prisma/client | v5.8.1 | npm | 2025-01-15 |
| postgresql | v16.1 | Official docs | 2025-01-15 |
```

**Skip Fix When:**
- All libraries have specific versions (X.Y.Z format)
- Versions verified within last 30 days
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

**MCP Tool Priority:**
1. **MCP Ref** for RFC/standards research (Criterion #5)
2. **Context7** for library versions (Criterion #6)
3. **WebSearch** as fallback when Context7 unavailable

**Linear Updates:**
- Each criterion auto-fix updates Linear issue once
- Add single comment summarizing ALL fixes in this category

---

**Version:** 1.0.0
**Last Updated:** 2025-12-21
