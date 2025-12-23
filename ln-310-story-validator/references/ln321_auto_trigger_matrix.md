# ln-002 Auto-Trigger Matrix

Mapping Story patterns to documentation types for automatic ln-002 invocation during ln-310 validation.

---

## Purpose

This matrix defines WHEN to invoke ln-002-docs-creator during Story validation and WHAT type of document to create.

**Usage in ln-310 SKILL.md:**
```markdown
### Phase 2: Critical Solution Review (Step 6 - Auto-Trigger ln-002)
1. Load ln321_auto_trigger_matrix.md
2. Scan Story title + Technical Notes for trigger keywords
3. IF keywords match → Invoke ln-002 with doc_type + topic from matrix
4. Add created doc links to Story Technical Notes
```

---

## Trigger Matrix

| Story Pattern | Doc Type | Topic | Trigger Keywords | Example Output | Priority |
|---------------|----------|-------|------------------|----------------|----------|
| **OAuth/OIDC** | Manual + ADR | [library] + "Authentication Strategy" | auth, oauth, oidc, token, JWT, bearer, authorization | `docs/manuals/oauth2-v7.md` + `docs/adrs/003-auth-strategy.md` | HIGH |
| **REST API** | Guide | RESTful API Patterns | endpoint, route, controller, REST, resource, CRUD | `docs/guides/05-rest-api-patterns.md` | HIGH |
| **Rate Limiting** | Guide | API Rate Limiting Pattern | rate, throttle, quota, limit, requests per | `docs/guides/06-api-rate-limiting.md` | MEDIUM |
| **Error Handling** | Guide | Error Response Patterns (RFC 7807) | error, exception, status code, 4xx, 5xx, problem details | `docs/guides/07-error-handling.md` | HIGH |
| **Logging** | Guide | Structured Logging Strategy | log, trace, audit, observability, monitoring, winston, pino | `docs/guides/08-logging.md` | MEDIUM |
| **WebSocket** | Guide | WebSocket Patterns | websocket, real-time, streaming, SSE, socket.io, ws | `docs/guides/09-websocket-patterns.md` | MEDIUM |
| **Pagination** | Guide | Pagination Patterns | page, offset, cursor, pagination, limit, next/prev | `docs/guides/10-pagination.md` | MEDIUM |
| **Caching** | Manual | [library] (redis, memcached) | cache, redis, memcached, TTL, expire, invalidation | `docs/manuals/redis-7.md` | MEDIUM |
| **Database** | Manual | [ORM/library] (prisma, sequelize) | database, ORM, prisma, sequelize, migration, schema | `docs/manuals/prisma-5.md` | MEDIUM |
| **Validation** | Guide | Input Validation Patterns | validate, sanitize, schema, joi, zod, yup | `docs/guides/11-input-validation.md` | MEDIUM |
| **File Upload** | Guide | File Upload & Storage | upload, multer, file, storage, s3, cloudinary | `docs/guides/12-file-upload.md` | LOW |
| **Email** | Manual | [library] (nodemailer, sendgrid) | email, mail, smtp, sendgrid, nodemailer, notification | `docs/manuals/nodemailer-6.md` | LOW |

---

## Trigger Logic

### 1. Keyword Detection
```
IF Story.title OR Story.context OR Story.technical_notes contains ANY trigger_keyword:
  → Pattern detected
```

**Example:**
- Story title: "Implement OAuth 2.0 authentication"
- Keywords detected: "oauth", "authentication"
- Pattern matched: **OAuth/OIDC**
- Action: Create Manual + ADR

### 2. Multiple Patterns
```
IF multiple patterns detected:
  → Create ALL applicable docs
```

**Example:**
- Story: "Add rate limiting to REST API"
- Patterns: **REST API** + **Rate Limiting**
- Action: Create Guide-05 (REST) + Guide-06 (Rate Limiting)

### 3. Library Detection
```
IF doc_type = Manual:
  → Extract library name from Technical Notes
  → Pass library name to ln-002
```

**Example:**
- Story mentions: "Using oauth2-proxy v7.6.0"
- Pattern: **OAuth/OIDC**
- Action: Create `docs/manuals/oauth2-proxy-v7.md`

---

## Integration with Criteria

### Criterion #17: Rate Limiting (Auto-Trigger)
```
IF Story matches "Rate Limiting" pattern:
  → Invoke: Skill(skill="ln-002-docs-creator", args="doc_type=guide topic='API Rate Limiting Pattern'")
  → Output: docs/guides/06-api-rate-limiting.md
  → Add reference to Technical Notes
```

### Criterion #18: Auth/Security (Auto-Trigger)
```
IF Story matches "OAuth/OIDC" pattern:
  → Extract library from Technical Notes (e.g., "oauth2-proxy v7.6.0")
  → Invoke: Skill(skill="ln-002-docs-creator", args="doc_type=manual topic='oauth2-proxy v7.6.0'")
  → Output: docs/manuals/oauth2-proxy-v7.md
  → Invoke: Skill(skill="ln-002-docs-creator", args="doc_type=adr topic='Authentication Strategy'")
  → Output: docs/adrs/003-auth-strategy.md
  → Add references to Technical Notes
```

### Criterion #19: Error Handling (Auto-Trigger)
```
FOR ALL Stories:
  IF "Error Handling" subsection missing:
    → Invoke: Skill(skill="ln-002-docs-creator", args="doc_type=guide topic='Error Response Patterns (RFC 7807)'")
    → Output: docs/guides/07-error-handling.md
    → Add reference to Technical Notes
```

### Criterion #20: Logging (Auto-Trigger)
```
FOR ALL Stories:
  IF "Logging" subsection missing:
    → Invoke: Skill(skill="ln-002-docs-creator", args="doc_type=guide topic='Structured Logging Strategy'")
    → Output: docs/guides/08-logging.md
    → Add reference to Technical Notes
```

---

## Priority Levels

**HIGH:** Always create documentation (critical architectural patterns)
- OAuth/OIDC (security)
- REST API (core architecture)
- Error Handling (user experience + debugging)

**MEDIUM:** Create if pattern detected (important but not universal)
- Rate Limiting (API protection)
- Logging (observability)
- WebSocket (real-time features)
- Pagination (data presentation)
- Caching (performance)
- Database (data layer)
- Validation (data integrity)

**LOW:** Create if pattern detected (feature-specific)
- File Upload (specific feature)
- Email (specific feature)

---

## Examples

### Example 1: OAuth Story

**Story Title:** "Implement OAuth 2.0 authentication with GitHub"

**Technical Notes:**
```markdown
## Technical Notes

### Integration Points
- Using oauth2-proxy v7.6.0 for OAuth 2.0 flow
```

**ln-310 Detection:**
- Keywords: "oauth", "authentication"
- Pattern: **OAuth/OIDC**
- Library: `oauth2-proxy v7.6.0`

**ln-002 Invocations:**
1. `Skill(skill="ln-002-docs-creator", args="doc_type=manual topic='oauth2-proxy v7.6.0'")`
   - Creates: `docs/manuals/oauth2-proxy-v7.md`
2. `Skill(skill="ln-002-docs-creator", args="doc_type=adr topic='Authentication Strategy'")`
   - Creates: `docs/adrs/003-auth-strategy.md`

**Story Update:**
```markdown
## Technical Notes

### Security Pattern
- **Authentication:** OAuth 2.0 (see [Manual: oauth2-proxy v7](docs/manuals/oauth2-proxy-v7.md))
- **Architecture Decision:** See [ADR-003: Authentication Strategy](docs/adrs/003-auth-strategy.md)
```

---

### Example 2: REST API with Rate Limiting

**Story Title:** "Create user management API"

**Technical Notes:**
```markdown
## Technical Notes

### Architecture Considerations
- RESTful API with CRUD endpoints
- Rate limiting required (100 req/min)
```

**ln-310 Detection:**
- Keywords: "RESTful", "API", "endpoints", "rate", "limiting"
- Patterns: **REST API** + **Rate Limiting**

**ln-002 Invocations:**
1. `Skill(skill="ln-002-docs-creator", args="doc_type=guide topic='RESTful API Patterns'")`
   - Creates: `docs/guides/05-rest-api-patterns.md`
2. `Skill(skill="ln-002-docs-creator", args="doc_type=guide topic='API Rate Limiting Pattern'")`
   - Creates: `docs/guides/06-api-rate-limiting.md`

**Story Update:**
```markdown
## Technical Notes

### Architecture Considerations
- RESTful API (see [Guide-05: RESTful API Patterns](docs/guides/05-rest-api-patterns.md))
- Rate limiting: 100 req/min (see [Guide-06: API Rate Limiting](docs/guides/06-api-rate-limiting.md))
```

---

### Example 3: Database with Caching

**Story Title:** "Optimize database queries with Redis caching"

**Technical Notes:**
```markdown
## Technical Notes

### Integration Points
- Prisma ORM v5.8.1
- Redis v7.2 for caching
```

**ln-310 Detection:**
- Keywords: "database", "prisma", "redis", "caching"
- Patterns: **Database** + **Caching**
- Libraries: `prisma v5.8.1`, `redis v7.2`

**ln-002 Invocations:**
1. `Skill(skill="ln-002-docs-creator", args="doc_type=manual topic='Prisma v5.8.1'")`
   - Creates: `docs/manuals/prisma-5.md`
2. `Skill(skill="ln-002-docs-creator", args="doc_type=manual topic='Redis v7.2'")`
   - Creates: `docs/manuals/redis-7.md`

**Story Update:**
```markdown
## Technical Notes

### Integration Points
- Prisma ORM v5.8.1 (see [Manual: Prisma v5](docs/manuals/prisma-5.md))
- Redis v7.2 caching (see [Manual: Redis v7](docs/manuals/redis-7.md))
```

---

## Usage Guidelines

### When to Auto-Trigger

✅ **DO auto-trigger when:**
- Pattern clearly detected (keywords match)
- Documentation does NOT already exist
- Story is in Backlog/Todo (not Done/Canceled)

❌ **DON'T auto-trigger when:**
- Documentation already exists (just add reference)
- Story in Done/Canceled status
- Pattern ambiguous (ask user for clarification)

### Fallback Strategy

**IF no pattern matched BUT technical aspect missing:**
- Add generic TODO: `_TODO: Document [aspect] in Technical Notes_`
- Log in Linear comment: "Manual documentation needed - no auto-trigger pattern matched"

---

**Version:** 1.0.0
**Last Updated:** 2025-12-21
