---
name: ln-221-library-researcher
description: Research libraries/standards via MCP Context7 + Ref. Generates Research Summary for Story Technical Notes subsection. Reusable worker.
---

# Library Researcher (Worker)

This skill researches libraries, API specifications, and industry standards using MCP Context7 and Ref to generate Research Summary for Story Technical Notes.

## When to Use This Skill

This skill should be used when:
- Need to research libraries/frameworks BEFORE Story generation (ensures tasks have concrete API methods, versions, best practices)
- Epic Technical Notes mention specific libraries requiring latest documentation
- Prevent situations where tasks lack specific API methods or use outdated patterns
- Reusable for ANY skill requiring library research (ln-220-story-coordinator, ln-310-story-decomposer, ln-350-story-test-planner)

**Who calls this skill:**
- **ln-220-story-coordinator** (Phase 3) - research for Story creation
- **ln-310-story-decomposer** (optional) - research for complex Stories
- **ln-350-story-test-planner** (optional) - research for test task planning
- **Manual** - user can invoke directly for Epic/Story research

## How It Works

The skill follows a 5-phase workflow: Identify → Context7 Research → Ref Research → Existing Guides → Research Summary.

### Phase 1: Identify Libraries

**Objective**: Parse Epic/Story for libraries and technology keywords.

**Process**:
1. **Read Epic/Story description** (provided as input)
   - Parse Epic Technical Notes for mentioned libraries/frameworks
   - Parse Epic Scope In for technology keywords (authentication, rate limiting, payments, etc.)
   - Identify Story domain from Epic goal statement (e.g., "Add rate limiting" → domain = "rate limiting")

2. **Extract library list**:
   - Primary libraries (explicitly mentioned)
   - Inferred libraries (e.g., "REST API" → FastAPI, "caching" → Redis)
   - Filter out well-known libraries with stable APIs (e.g., requests, urllib3)

3. **Determine Story domain**:
   - Extract from Epic goal or Story title
   - Examples: rate limiting, authentication, payment processing, file upload

**Output**: Library list (3-5 libraries max) + Story domain

**Skip conditions**:
- NO libraries mentioned in Epic → Output empty Research Summary
- Trivial CRUD operation with well-known libraries → Output empty Research Summary
- Epic explicitly states "research not needed" → Skip

---

### Phase 2: MCP Context7 Research

**Objective**: Get latest API documentation for each library.

**Process**:
1. **FOR EACH library** in library list (parallel calls when possible):
   - Call `mcp__context7__resolve-library-id(libraryName="[library]")` → Get Context7-compatible library ID
   - Call `mcp__context7__get-library-docs(context7CompatibleLibraryID="[id]", topic="[Story domain]", tokens=3000)` → Get latest documentation

2. **Extract from documentation**:
   - **Latest stable version** (prefer LTS, avoid beta/RC/bleeding edge)
   - **Key API methods** (2-5 most relevant for Story domain) - method names and signatures
   - **Configuration parameters** (initialization, setup requirements)
   - **Known limitations** (async support, storage backends, multi-process caveats)
   - **Deprecations** (deprecated methods to avoid)
   - **Official docs URL** (link to source)

3. **Store results** for Research Summary compilation

**Fallback**: If library NOT found in Context7 → Use `WebSearch` as fallback (search "[library] latest version API documentation 2025")

**Output**: Library documentation table (library name, version, purpose, docs URL) + Key APIs list

---

### Phase 3: MCP Ref Research

**Objective**: Get industry standards and best practices.

**Process**:
1. **FOR EACH library + Story domain** combination:
   - Call `mcp__Ref__ref_search_documentation(query="[library] [domain] best practices 2025")`
   - Call `mcp__Ref__ref_search_documentation(query="[domain] industry standards RFC")`

2. **Extract from results**:
   - **Industry standards** (RFC/spec references: OAuth 2.0, REST API, OpenAPI 3.0, WebSocket)
   - **Common patterns** (do/don't examples, anti-patterns to avoid)
   - **Integration approaches** (middleware, dependency injection, decorators)
   - **Security considerations** (OWASP compliance, vulnerability mitigation)
   - **Best practices URLs** (link to authoritative sources)

3. **Store results** for Research Summary compilation

**Output**: Standards compliance table (RFC/Standard name, how to comply) + Best practices list

---

### Phase 4: Scan Existing Guides

**Objective**: Find relevant pattern guides in docs/guides/ directory.

**Process**:
1. **Scan guides directory**:
   - Use `Glob` to find `docs/guides/*.md`
   - Read guide filenames

2. **Match guides to Story domain**:
   - Match keywords (e.g., rate limiting guide for rate limiting Story)
   - Fuzzy match (e.g., "authentication" matches "auth.md", "oauth.md")

3. **Collect guide paths** for linking in Technical Notes

**Output**: Existing guides list (relative paths from project root)

---

### Phase 5: Generate Research Summary

**Objective**: Compile all research results into Research Summary for Story Technical Notes subsection.

**Process**:
1. **Generate Research Summary** in Markdown format:

   ```markdown
   ## Library Research
   **Primary libraries:**
   | Library | Version | Purpose | Docs |
   |---------|---------|---------|------|
   | [name] | v[X.Y.Z] | [use case for Story domain] | [official docs URL] |

   **Key APIs:**
   - `[method_signature]` - [purpose and when to use]
   - `[method_signature]` - [purpose and when to use]

   **Key constraints:**
   - [Limitation 1: e.g., no async support in v0.1.9] - [workaround if any]
   - [Limitation 2: e.g., in-memory storage doesn't persist] - [solution: Redis backend]

   **Standards compliance:**
   - [Standard/RFC name]: [how Story should comply - brief description]

   **Existing guides:**
   - [guide_path.md](guide_path.md) - [brief guide description]
   ```

2. **Return Research Summary** to calling skill (ln-220, ln-310, ln-350)

**Output**: Research Summary (Markdown string) for insertion into Story Technical Notes subsection

**Important notes:**
- Focus on KEY APIs only (2-5 methods), not exhaustive documentation
- Prefer official docs and RFC standards over blog posts
- If Research Summary is empty (no libraries) → Return "No library research needed"
- Research Summary will be inserted in EVERY Story's Technical Notes (Library Research subsection)

---

## Integration with Ecosystem

**Called by:**
- **ln-220-story-coordinator** (Phase 3) - research for ALL Stories in Epic (5-10 Stories reuse single research)
- **ln-310-story-decomposer** (optional) - research for complex technical Stories
- **ln-350-story-test-planner** (optional) - research for test infrastructure libraries

**Dependencies:**
- MCP Context7 (resolve-library-id, get-library-docs)
- MCP Ref (ref_search_documentation)
- Glob (scan docs/guides/)
- WebSearch (fallback for libraries not in Context7)

**Input parameters (from calling skill):**
- `epic_description` (string) - Epic Technical Notes + Scope In + Goal
- `story_domain` (string, optional) - Story domain (e.g., "rate limiting")

**Output format:**
- Markdown string (Research Summary for Technical Notes subsection)

---

## Time-Box and Performance

**Time-box:** 15-20 minutes maximum per Epic

**Performance:**
- Research is done ONCE per Epic
- Results reused for all Stories (5-10 Stories benefit from single research)
- Parallel MCP calls when possible (Context7 + Ref)

**Token efficiency:**
- Context7: max 3000 tokens per library
- Total: ~10,000 tokens for typical Epic (3-4 libraries)

---

## References

**Tools:**
- `mcp__context7__resolve-library-id()` - Get library ID from name
- `mcp__context7__get-library-docs()` - Get latest API documentation
- `mcp__Ref__ref_search_documentation()` - Search best practices and standards
- `Glob` - Scan docs/guides/ directory
- `WebSearch` - Fallback for libraries not in Context7

**Templates:**
- [research_guidelines.md](references/research_guidelines.md) - Research quality guidelines (official docs > blog posts, prefer LTS versions)

---

**Version:** 1.0.0
**Last Updated:** 2025-11-17
