---
name: ln-321-guide-creator
description: Creates minimal guides (6 sections, ~300-500 words) for reusable patterns. Auto-research via MCP Ref/Context7. Returns guide path for linking.
---

# Guide Creator

Produces pattern guides with sources and patterns table when a new reusable approach is found.

## Purpose & Scope
- Auto-research best practices for a named pattern; cite versions/dates.
- Generate 6-section guide: SCOPE tags, Principle, Our Implementation, Patterns table (Do/Don't/When), Sources, Related + Last Updated.
- Validate against documentation standards; save to `docs/reference/guides/NN-pattern.md`; return path.

## When to Use
- Pattern is missing in `docs/reference/guides/` or Task/Story Technical Notes reference an undocumented pattern.
- Need a concise “how to implement” reference (not ADR/decision, not API manual).

## Workflow (concise)
1) **Research:** MCP Ref + Context7 for official docs and framework usage; extract principle, 2-3 do/don'ts, versions/dates.
2) **Generate:** Fill 6 sections with patterns table; no code snippets; 300-500 words; language per Story/Task.
3) **Validate:** Ensure SCOPE tags, sources dated, patterns table, no ADR-style rationale, POSIX ending, maintenance/Last Updated; auto-fix standards if needed.
4) **Save:** Confirm, write `docs/reference/guides/NN-pattern-name.md` (NN = next number), optionally update `docs/reference/README.md` if placeholder exists; return path.

## Critical Rules
- Cite official sources with versions/dates (>=2025 or version-specific).
- No code snippets or ADR rationale; keep neutral instructional tone.
- One pattern per guide; include Do/Don't/When table.
- Preserve language (EN/RU) from request.

## Definition of Done
- Research done (Ref + Context7) with principle and sources extracted.
- Guide generated with all 6 sections and patterns table; no placeholders.
- Standards check passed/auto-fixed (SCOPE, maintenance, POSIX).
- Saved to guides with correct numbering; path returned; README updated if placeholder present.

## Reference Files
- Template/reference: `ln-321-guide-creator/references/guide_template.md`
- Standards (if present): `docs/DOCUMENTATION_STANDARDS.md`

---
Version: 6.0.0 (Condensed flow and rules)
Last Updated: 2025-11-26
