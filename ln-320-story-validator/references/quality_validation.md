# Quality & Documentation Validation (Criteria #13-#20)

Detailed rules for documentation links, foundation-first order, code quality, industry standards, and API technical aspects with ln-321 integration.

---

## Criterion #13: Documentation Links Referenced

**Check:** Technical Notes references relevant guides/manuals from docs/

✅ **GOOD:**
```markdown
## Technical Notes

### Architecture Considerations
See [Guide-03: Database Schema Patterns](docs/guides/03-database-schema.md)
for normalization best practices.

### Integration Points
OAuth 2.0 implementation per [Manual: oauth2-proxy v7](docs/manuals/oauth2-v7.md)
```

❌ **BAD:**
```markdown
## Technical Notes

### Architecture Considerations
We'll use normalized database schema.
(No reference to existing guide)
```

**Auto-fix actions:**
1. Grep Technical Notes for keywords: "database", "auth", "api", "error", "logging"
2. For EACH keyword, check if corresponding guide/manual exists in docs/
3. IF guide exists BUT not referenced → Add reference to Technical Notes
4. IF guide does NOT exist → Note for later (ln-321 will create if needed)
5. Update Linear issue via `mcp__linear-server__update_issue`
6. Add comment: "Documentation links added to Technical Notes"

**Skip Fix When:**
- No relevant guides exist yet
- Story in Done/Canceled status

---

## Criterion #14: Foundation-First Task Order

**Check:** Tasks ordered bottom-up (Database → Service → API → UI)

⚠️ **Important:** Dependency order ensures each Task builds on previous work.

✅ **GOOD (Bottom-Up):**
```markdown
## Implementation Tasks

1. [Task] Database schema + migrations - US-123-T1
2. [Task] Repository layer (data access) - US-123-T2
3. [Task] Service layer (business logic) - US-123-T3
4. [Task] API routes (controllers) - US-123-T4
5. [Task] Frontend components (optional) - US-123-T5
```

❌ **BAD (Top-Down or Random):**
```markdown
## Implementation Tasks

1. [Task] API routes - US-123-T1  ❌ Can't implement without service
2. [Task] Frontend - US-123-T2  ❌ Can't implement without API
3. [Task] Service layer - US-123-T3
4. [Task] Database schema - US-123-T4  ❌ Should be first
```

**Correct Order:**
```
1. Database (schema, migrations, models)
2. Repository (data access, ORM queries)
3. Service (business logic, validation)
4. API/Routes (controllers, endpoints)
5. Middleware (auth, rate limiting, logging)
6. UI/Frontend (components, pages) - if applicable
7. Tests (final Task, created by ln-350)
```

**Auto-fix actions:**
1. Parse Implementation Tasks → Identify layer for each Task (keywords: "schema", "repository", "service", "route", "frontend")
2. Check if Tasks ordered bottom-up
3. IF out of order → Reorder Tasks to match foundation-first sequence
4. Update Linear issue via `mcp__linear-server__update_issue`
5. Add comment: "Tasks reordered foundation-first (DB → Service → API)"

**Example transformation:**

**Before:**
```markdown
## Implementation Tasks

1. [Task] API endpoints - US-123-T1
2. [Task] Add validation - US-123-T2
3. [Task] Database schema - US-123-T3
```

**After:**
```markdown
## Implementation Tasks

1. **[Task] Database schema + models** - US-123-T1 (Foundation)
2. **[Task] Service layer with validation** - US-123-T2 (Business Logic)
3. **[Task] API endpoints** - US-123-T3 (Interface)
```

**Skip Fix When:**
- Tasks already in correct order
- Story in Done/Canceled status

---

## Criterion #15: No Hardcoded Values (TODO Placeholders)

**Check:** No hardcoded credentials, API keys, or config values in Story

✅ **GOOD:**
```markdown
## Technical Notes

### Configuration
- Database URL: `_TODO: Add DATABASE_URL to .env_`
- OAuth Client ID: `_TODO: Register app, add OAUTH_CLIENT_ID to .env_`
- API Key: `_TODO: Generate key, add API_KEY to .env_`
```

❌ **BAD:**
```markdown
## Technical Notes

### Configuration
- Database URL: `postgresql://localhost:5432/mydb`  ❌ Hardcoded
- OAuth Client ID: `abc123xyz`  ❌ Hardcoded
- API Key: `sk_test_4eC39HqLyjWDarjtT1zdp7dc`  ❌ Hardcoded
```

**Auto-fix actions:**
1. Grep Technical Notes for patterns: URLs, keys, credentials
   - Database URLs: `postgresql://`, `mysql://`, `mongodb://`
   - API keys: `sk_`, `pk_`, `Bearer`, `token=`
   - Credentials: `password=`, `secret=`
2. IF hardcoded value found → Replace with `_TODO: Add [NAME] to .env_`
3. Add Security section if missing:
   ```markdown
   ### Security
   All sensitive values stored in environment variables (never committed to git)
   ```
4. Update Linear issue via `mcp__linear-server__update_issue`
5. Add comment: "Hardcoded values replaced with .env placeholders"

**Skip Fix When:**
- Values are examples/placeholders (clearly marked as `example.com`, `<YOUR_KEY>`)
- Story in Done/Canceled status

---

## Criterion #16: Industry Standards Compliance (RFC, OWASP)

**Check:** Solution follows industry standards (verified via MCP Ref or explicit documentation)

⚠️ **CRITICAL:** This criterion checked BEFORE KISS/YAGNI (#11-#12). Standards override simplicity.

**Common Standards:**

| Standard | Applies When | Verification |
|----------|--------------|--------------|
| RFC 6749 (OAuth 2.0) | Auth/tokens | MCP Ref: OAuth 2.0 spec |
| RFC 7807 (Problem Details) | Error responses | MCP Ref: RFC 7807 |
| RFC 7231 (HTTP Semantics) | API endpoints | HTTP method semantics |
| OWASP Top 10 | All apps | Security checklist |
| REST Principles | APIs | Resource-based URLs |
| OpenAPI 3.x | Public APIs | API documentation spec |

✅ **GOOD (Compliant):**
```markdown
## Technical Notes

### Standards Compliance
- **OAuth 2.0 (RFC 6749):** Using authorization code flow with PKCE
- **Error Handling (RFC 7807):** Problem Details for HTTP APIs format
- **REST:** Resource-based URLs, proper HTTP methods (GET/POST/PUT/DELETE)
- **Security:** OWASP Top 10 compliance (Helmet.js, input validation, HTTPS)
```

❌ **BAD (Non-Compliant):**
```markdown
## Technical Notes

We'll use custom auth with session cookies.
(Violates OAuth RFC 6749 if API requires stateless auth)
```

**Auto-fix actions:**
1. Identify Story domain (auth, API, errors, security)
2. Load applicable standards from table above
3. For EACH standard:
   - Search MCP Ref: `mcp__Ref__ref_search_documentation(query="[Standard Name]")`
   - Compare Story solution with standard requirements
   - IF non-compliant → Update Technical Notes with compliant approach
4. Add Standards Compliance subsection to Technical Notes
5. Update Linear issue via `mcp__linear-server__update_issue`
6. Add comment: "Solution updated to comply with [list of RFCs/Standards]"

**Skip Fix When:**
- Solution already documents standard compliance
- Story in Done/Canceled status
- Standard not applicable (e.g., OpenAPI for internal-only API)

---

## Criterion #17: Rate Limiting (API Stories) - ln-321 Integration

**Check:** API Stories have Rate Limiting subsection OR trigger ln-321 to create guide

⚠️ **NEW BEHAVIOR:** Instead of adding TODO placeholder, INVOKE ln-321 to create Rate Limiting Guide.

**Detection:** Story title/context contains keywords: "API", "endpoint", "route", "REST"

✅ **GOOD:**
```markdown
## Technical Notes

### Performance & Security
- **Rate Limiting:** 100 requests/minute per IP (see [Guide-06: API Rate Limiting](docs/guides/06-api-rate-limiting.md))
```

❌ **BAD:**
```markdown
## Technical Notes

### Performance & Security
(No rate limiting mentioned)
```

**Auto-fix actions:**
1. Check if Story is API-related (keywords: API, endpoint, route, REST)
2. IF NOT API Story → Skip this criterion
3. IF API Story:
   - Check if Rate Limiting subsection exists in Technical Notes
   - IF exists → ✅ Pass
   - IF missing:
     - **Invoke ln-321:** `Skill(skill="ln-321-docs-creator", args="doc_type=guide topic='API Rate Limiting Pattern'")`
     - ln-321 creates `docs/guides/06-api-rate-limiting.md`
     - Add reference to Technical Notes:
       ```markdown
       ### Performance & Security
       - **Rate Limiting:** See [Guide-06: API Rate Limiting](docs/guides/06-api-rate-limiting.md)
       ```
     - Update Linear issue via `mcp__linear-server__update_issue`
     - Add comment: "Created Rate Limiting Guide via ln-321, added reference to Story"

**Skip Fix When:**
- NOT an API Story (no endpoints/routes)
- Rate Limiting already documented
- Story in Done/Canceled status

---

## Criterion #18: Auth/Security Pattern - ln-321 Integration

**Check:** Auth Stories have Security Pattern subsection OR trigger ln-321 to create manual + ADR

⚠️ **NEW BEHAVIOR:** Instead of adding TODO placeholder, INVOKE ln-321 to create Manual + ADR.

**Detection:** Story title/context contains keywords: "auth", "login", "token", "oauth", "jwt", "session"

✅ **GOOD:**
```markdown
## Technical Notes

### Security Pattern
- **Authentication:** OAuth 2.0 (see [Manual: oauth2-proxy v7](docs/manuals/oauth2-v7.md))
- **Architecture Decision:** See [ADR-003: Authentication Strategy](docs/adrs/003-auth-strategy.md)
```

❌ **BAD:**
```markdown
## Technical Notes

We'll add login endpoint.
(No security pattern documentation)
```

**Auto-fix actions:**
1. Check if Story is Auth-related (keywords: auth, login, token, oauth, jwt, session)
2. IF NOT Auth Story → Skip this criterion
3. IF Auth Story:
   - Identify auth library from Technical Notes (oauth2-proxy, passport, etc.)
   - **Invoke ln-321 for Manual:**
     ```
     Skill(skill="ln-321-docs-creator", args="doc_type=manual topic='[library-name] v[version]'")
     ```
     ln-321 creates `docs/manuals/[library]-v[version].md`
   - **Invoke ln-321 for ADR:**
     ```
     Skill(skill="ln-321-docs-creator", args="doc_type=adr topic='Authentication Strategy'")
     ```
     ln-321 creates `docs/adrs/00X-auth-strategy.md`
   - Add references to Technical Notes:
     ```markdown
     ### Security Pattern
     - **Authentication:** [Library] (see [Manual: [library]](docs/manuals/[library].md))
     - **Architecture Decision:** See [ADR-00X: Authentication Strategy](docs/adrs/00X-auth-strategy.md)
     ```
   - Update Linear issue via `mcp__linear-server__update_issue`
   - Add comment: "Created Manual + ADR via ln-321, added references to Story"

**Skip Fix When:**
- NOT an Auth Story
- Manual + ADR already exist
- Story in Done/Canceled status

---

## Criterion #19: Error Handling Strategy - ln-321 Integration

**Check:** Stories have Error Handling subsection OR trigger ln-321 to create guide

⚠️ **NEW BEHAVIOR:** Instead of adding TODO placeholder, INVOKE ln-321 to create Error Handling Guide.

✅ **GOOD:**
```markdown
## Technical Notes

### Performance & Security
- **Error Handling:** RFC 7807 Problem Details (see [Guide-07: Error Response Patterns](docs/guides/07-error-handling.md))
```

❌ **BAD:**
```markdown
## Technical Notes

(No error handling strategy)
```

**Auto-fix actions:**
1. Check if Error Handling subsection exists in Technical Notes
2. IF exists → ✅ Pass
3. IF missing:
   - **Invoke ln-321:**
     ```
     Skill(skill="ln-321-docs-creator", args="doc_type=guide topic='Error Response Patterns (RFC 7807)'")
     ```
     ln-321 creates `docs/guides/07-error-handling.md`
   - Add reference to Technical Notes:
     ```markdown
     ### Performance & Security
     - **Error Handling:** RFC 7807 Problem Details (see [Guide-07: Error Response Patterns](docs/guides/07-error-handling.md))
     ```
   - Update Linear issue via `mcp__linear-server__update_issue`
   - Add comment: "Created Error Handling Guide via ln-321, added reference to Story"

**Skip Fix When:**
- Error Handling already documented
- Story in Done/Canceled status

---

## Criterion #20: Logging & Observability - ln-321 Integration

**Check:** Stories have Logging subsection OR trigger ln-321 to create guide

⚠️ **NEW BEHAVIOR:** Instead of adding TODO placeholder, INVOKE ln-321 to create Logging Guide.

✅ **GOOD:**
```markdown
## Technical Notes

### Performance & Security
- **Logging:** Structured logging with Winston (see [Guide-08: Structured Logging Strategy](docs/guides/08-logging.md))
```

❌ **BAD:**
```markdown
## Technical Notes

(No logging strategy)
```

**Auto-fix actions:**
1. Check if Logging subsection exists in Technical Notes
2. IF exists → ✅ Pass
3. IF missing:
   - **Invoke ln-321:**
     ```
     Skill(skill="ln-321-docs-creator", args="doc_type=guide topic='Structured Logging Strategy'")
     ```
     ln-321 creates `docs/guides/08-logging.md`
   - Add reference to Technical Notes:
     ```markdown
     ### Performance & Security
     - **Logging:** Structured logging (see [Guide-08: Structured Logging Strategy](docs/guides/08-logging.md))
     ```
   - Update Linear issue via `mcp__linear-server__update_issue`
   - Add comment: "Created Logging Guide via ln-321, added reference to Story"

**Skip Fix When:**
- Logging already documented
- Story in Done/Canceled status

---

## ln-321 Integration Summary

**Criteria triggering ln-321:**

| Criterion | Detection | ln-321 Call | Output |
|-----------|-----------|-------------|--------|
| #17 Rate Limiting | API Story | `doc_type=guide topic="API Rate Limiting"` | docs/guides/06-api-rate-limiting.md |
| #18 Auth/Security | Auth Story | `doc_type=manual topic="[library]"` + `doc_type=adr topic="Auth Strategy"` | docs/manuals/[lib].md + docs/adrs/00X-auth.md |
| #19 Error Handling | All Stories | `doc_type=guide topic="Error Response Patterns"` | docs/guides/07-error-handling.md |
| #20 Logging | All Stories | `doc_type=guide topic="Structured Logging"` | docs/guides/08-logging.md |

**Benefit:** Real documentation created (not TODO placeholders), automatically referenced in Story.

---

## Execution Notes

**Sequential Dependency:**
- Criteria #13-#20 depend on #1-#12 being completed first
- Cannot add doc references (#13) until structure exists (#1)
- Cannot check standards (#16) until solution optimized (#5)

**ln-321 Invocation:**
- Invoke ln-321 ONLY if doc does NOT exist
- If doc exists, just add reference to Technical Notes
- Each ln-321 call creates ONE document (guide/manual/ADR)

**Linear Updates:**
- Each criterion auto-fix updates Linear issue once
- Add single comment summarizing ALL fixes + docs created

---

**Version:** 1.0.0
**Last Updated:** 2025-12-21
