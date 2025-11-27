---
name: ln-323-manual-creator
description: Creates package/API manuals (300-500 words) with versioned methods/params/examples. Auto-research via MCP Ref/Context7. Returns manual path.
---

# Manual Creator

Generates neutral, version-specific API manuals for packages introduced in Stories/Tasks.

## Purpose & Scope
- Auto-research package version, methods, params, returns, exceptions, config, and official sources.
- Produce OpenAPI-inspired manual from template: Package info, Overview, Methods (signature/params/returns/example), Config, Limitations, Version notes, Related + Last Updated.
- Validate against documentation standards; save to `docs/reference/manuals/package-version.md`; return path.

## When to Use
- New package/library/API appears and lacks a manual.
- Need factual reference for implementation (not patterns/decisions).

## Workflow (concise)
1) **Research:** MCP Ref + Context7 for official docs/version; extract method signatures, params (type/required/default), returns, exceptions, examples, sources (dated/versioned).
2) **Generate:** Fill template sections; neutral tone; no how-to/opinions; include at least one example per method; language per request.
3) **Validate:** Ensure SCOPE tags, maintenance/Last Updated, POSIX ending; sources dated; defaults and required flags set; no placeholders; standards auto-fix if needed.
4) **Save:** Confirm; write `docs/reference/manuals/[package]-[version].md`; optionally update `docs/reference/README.md` if placeholder present; return path.

## Critical Rules
- Version-specific filenames; no numbering.
- Neutral/factual: no recommendations or rationale (that’s guides/ADRs).
- No how-to content; focus on APIs/methods/config.
- Preserve language (EN/RU) from request.

## Definition of Done
- Research captured (methods/params/examples/sources with versions/dates).
- Manual generated with all sections and examples; no placeholders.
- Standards check passed/auto-fixed (SCOPE, maintenance, POSIX).
- Saved to manuals/ with correct filename; path returned; README updated if placeholder present.

## Reference Files
- Template: `ln-323-manual-creator/references/manual_template.md`
- Standards: `docs/DOCUMENTATION_STANDARDS.md` (if exists)

---
Version: 3.0.0 (Condensed manual creation flow)
Last Updated: 2025-11-26
