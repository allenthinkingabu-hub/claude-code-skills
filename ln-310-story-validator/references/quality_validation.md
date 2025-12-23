# Quality & Documentation Validation (Criteria #13-#20)

Detailed rules for documentation links, foundation-first order, code quality, industry standards, and API technical aspects with ln-002 integration.

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
4. IF guide does NOT exist → Note for later (ln-002 will create if needed)
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
7. Tests (final Task, created by ln-510)
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

## Criterion #16: Industry Standards Compliance (Phase 2 Findings OR MCP Ref Fallback)

**Check:** Solution follows industry standards

⚠️ **CRITICAL:** This criterion checked BEFORE KISS/YAGNI (#11-#12). Standards override simplicity.

⚠️ **CONDITIONAL RESEARCH:**
- IF `phase2_executed = true` (NON-TRIVIAL) → Reads standards from Phase 2 guides (no MCP calls)
- IF `phase2_executed = false` (TRIVIAL skip) → FALLBACK to direct MCP Ref query

**Common Standards (from Phase 2 guides):**

| Standard | Applies When | Verified in Phase 2 |
|----------|--------------|---------------------|
| RFC 6749 (OAuth 2.0) | Auth/tokens | Guide/Manual created |
| RFC 7807 (Problem Details) | Error responses | Guide created |
| RFC 7231 (HTTP Semantics) | API endpoints | Guide created |
| OWASP Top 10 | All apps | Security guide |
| REST Principles | APIs | REST guide created |
| OpenAPI 3.x | Public APIs | API guide created |

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

**Auto-fix actions (NON-TRIVIAL path - phase2_executed = true):**
1. Read standards from guides created in Phase 2 research
2. For EACH standard in Phase 2 findings:
   - Extract RFC/OWASP requirements from guide
   - Compare Story Technical Notes with standard requirements
   - IF non-compliant → Update Technical Notes with compliant approach from guide
3. Add Standards Compliance subsection to Technical Notes with guide references
4. Update Linear issue via `mcp__linear-server__update_issue`
5. Add comment: "Solution updated to comply with [Standards list] - see guides from Phase 2"

**FALLBACK Auto-fix actions (TRIVIAL path - phase2_executed = false):**
1. Identify applicable standards for Story domain (e.g., REST → RFC 7231/7807, Auth → OWASP)
2. Query MCP Ref for standards compliance:
   - Tool: `mcp__Ref__ref_search_documentation(query="[domain] RFC OWASP standards compliance")`
   - Example: "REST API RFC 7231 7807 OWASP standards"
3. Extract compliance requirements from search results
4. Compare Story Technical Notes with requirements
5. IF non-compliant:
   - Update Technical Notes with compliant approach from MCP Ref results
   - Add Standards Compliance subsection with inline RFC/OWASP references
   - **Note:** Do NOT create separate guide - just inline references
6. Update Linear issue via `mcp__linear-server__update_issue`
7. Add comment: "Solution updated to comply with [Standards list from MCP Ref] - TRIVIAL fast path"

**Skip Fix When:**
- Solution already documents standard compliance with guide references
- Story in Done/Canceled status
- Standard not applicable (e.g., OpenAPI for internal-only API)

---

## Criterion #17: Technical Documentation (Pattern-Specific Docs OR MCP Ref Fallback)

**Check:** Pattern-specific documentation exists or referenced

⚠️ **CONDITIONAL RESEARCH:**
- IF `phase2_executed = true` (NON-TRIVIAL) → Checks docs from Phase 2, adds references (no ln-002/MCP calls)
- IF `phase2_executed = false` (TRIVIAL skip) → FALLBACK to MCP Ref query for pattern docs

⚠️ **Universal:** Works for ANY pattern from `ln321_auto_trigger_matrix.md` (OAuth, REST API, Rate Limiting, Caching, WebSocket, Email, File Upload, ML, Blockchain, Database, Validation, Pagination, etc.)

✅ **GOOD (Pattern docs referenced):**
```markdown
## Technical Notes

### Architecture Considerations
- **REST API:** Resource-based URLs (see [Guide-05: RESTful API Patterns](docs/guides/05-rest-api-patterns.md))
- **Rate Limiting:** 100 req/min per IP (see [Guide-06: API Rate Limiting](docs/guides/06-api-rate-limiting.md))

### Integration Points
- **OAuth 2.0:** oauth2-proxy v7.6.0 (see [Manual: oauth2-proxy v7](docs/manuals/oauth2-proxy-v7.md))
- **Architecture Decision:** See [ADR-003: Authentication Strategy](docs/adrs/003-auth-strategy.md)

### Performance & Security
- **Error Handling:** RFC 7807 Problem Details (see [Guide-07: Error Response Patterns](docs/guides/07-error-handling.md))
- **Logging:** Structured logging with Winston (see [Guide-08: Structured Logging Strategy](docs/guides/08-logging.md))
```

❌ **BAD (Pattern docs missing):**
```markdown
## Technical Notes

We'll add OAuth authentication and REST API endpoints.
(No references to guides/manuals/ADRs created in Phase 2)
```

**Auto-fix actions (NON-TRIVIAL path - phase2_executed = true):**
1. For EACH pattern detected in Phase 2 Domain Extraction:
   - Check if corresponding documentation exists in `research_results` (guides/manuals/ADRs created by ln-002)
   - IF exists:
     - Add reference to Technical Notes under appropriate subsection
     - Example: OAuth → "See [Manual: oauth2-proxy v7](docs/manuals/oauth2-proxy-v7.md)"
   - ELSE:
     - Add WARNING to Linear comment: "Pattern documentation should have been created in Phase 2 - check ln321_auto_trigger_matrix.md"
2. Update Linear issue via `mcp__linear-server__update_issue`
3. Add comment: "Pattern documentation references added - [list of docs from Phase 2]"

**FALLBACK Auto-fix actions (TRIVIAL path - phase2_executed = false):**
1. Extract patterns from Story domain (e.g., "CRUD REST API" → REST API, Error Handling, Logging)
2. For EACH pattern:
   - Query MCP Ref for pattern-specific best practices:
     - Tool: `mcp__Ref__ref_search_documentation(query="[pattern] best practices documentation")`
     - Example: "REST API best practices RFC 7231", "Error handling RFC 7807"
   - Extract key references from search results (RFC numbers, library recommendations, patterns)
3. Add inline references to Technical Notes under appropriate subsections:
   - Example: "REST API: Resource-based URLs (RFC 7231), proper HTTP methods"
   - **Note:** Do NOT create separate guides - just inline references from MCP Ref
4. Update Linear issue via `mcp__linear-server__update_issue`
5. Add comment: "Pattern documentation references added from MCP Ref - [list of patterns] - TRIVIAL fast path"

**Example patterns handled:**
- **OAuth/Auth:** Manual (library v[version]) + ADR (Authentication Strategy)
- **REST API:** Guide (RESTful API Patterns)
- **Rate Limiting:** Guide (API Rate Limiting Pattern)
- **Error Handling:** Guide (Error Response Patterns RFC 7807)
- **Logging:** Guide (Structured Logging Strategy)
- **Caching:** Manual (Redis/Memcached version)
- **Database:** Manual (ORM/library version)
- **WebSocket:** Guide (WebSocket Patterns)
- **Email:** Manual (Nodemailer/SendGrid version)
- **File Upload:** Guide (File Upload & Storage)
- **ML/AI:** Guide (Data Validation) + Manual (TensorFlow/PyTorch version)
- **Blockchain:** Guide (Smart Contract Patterns)

**Skip Fix When:**
- No patterns detected in Phase 2 (trivial Story)
- All pattern docs already referenced in Technical Notes
- Story in Done/Canceled status

---

## ln-002 Integration Summary

**Phase 2 Research Delegation (ONE invocation per pattern):**

| Pattern | Detection | ln-002 Call (Phase 2) | Output |
|---------|-----------|----------------------|--------|
| OAuth/Auth | Keywords: auth, oauth, login, token, jwt | `doc_type=manual topic="[library]"` + `doc_type=adr topic="Auth Strategy"` | docs/manuals/[lib].md + docs/adrs/00X-auth.md |
| REST API | Keywords: API, endpoint, route, REST | `doc_type=guide topic="RESTful API Patterns"` | docs/guides/05-rest-api-patterns.md |
| Rate Limiting | Keywords: rate, throttle, quota, limit | `doc_type=guide topic="API Rate Limiting Pattern"` | docs/guides/06-api-rate-limiting.md |
| Error Handling | Universal (all Stories) | `doc_type=guide topic="Error Response Patterns (RFC 7807)"` | docs/guides/07-error-handling.md |
| Logging | Universal (all Stories) | `doc_type=guide topic="Structured Logging Strategy"` | docs/guides/08-logging.md |
| Caching | Keywords: cache, redis, memcached, TTL | `doc_type=manual topic="[library]"` | docs/manuals/redis-7.md |
| Database | Keywords: database, ORM, prisma, sequelize | `doc_type=manual topic="[library]"` | docs/manuals/prisma-5.md |
| WebSocket | Keywords: websocket, real-time, streaming, SSE | `doc_type=guide topic="WebSocket Patterns"` | docs/guides/09-websocket-patterns.md |
| Email | Keywords: email, mail, smtp, sendgrid | `doc_type=manual topic="[library]"` | docs/manuals/nodemailer-6.md |
| File Upload | Keywords: upload, file, storage, s3 | `doc_type=guide topic="File Upload & Storage"` | docs/guides/12-file-upload.md |

**Full pattern registry:** See `ln321_auto_trigger_matrix.md` for complete list.

**Phase 4 Criterion #17:** Checks docs exist + adds references (NO ln-002 calls).

**Benefit:**
- Research done ONCE in Phase 2 (no duplicates)
- Real documentation created (not TODO placeholders)
- Universal approach (works for ANY pattern from matrix)

---

## Execution Notes

**Sequential Dependency:**
- Criteria #13-#17 depend on #1-#12 being completed first
- Cannot add doc references (#13) until structure exists (#1)
- Cannot check standards (#16) until solution optimized (#5)

**Phase 2 Integration:**
- Criteria #13-#17 DO NOT invoke ln-002 directly
- ln-002 invoked in Phase 2 for ALL detected patterns (ONE invocation per pattern)
- Criterion #17 checks if docs exist from Phase 2, adds references to Technical Notes
- All research completed BEFORE Phase 4 auto-fix begins

**Linear Updates:**
- Each criterion auto-fix updates Linear issue once
- Add single comment summarizing ALL fixes + docs created

---

**Version:** 1.0.0
**Last Updated:** 2025-12-21
