---
name: ln-322-adr-creator
description: Creates ADRs (Nygard format, 7 sections, ~300-500 words) via short Q&A. Assigns next ADR number and validates standards.
---

# ADR Creator

Captures a single architecture decision with minimal dialog and saves it to the ADR collection.

## Purpose & Scope
- Assign next ADR number in `docs/reference/adrs/`.
- Gather title/category/context/decision/rationale/alternatives/consequences/status via 5 questions.
- Generate ADR file from template; validate standards; return path.

## When to Use
- Need to document a specific architectural/technical decision (one per ADR).
- Project already has reference docs structure (`docs/reference/adrs/`).
- Not for broad docs creation (use ln-110/ln-114 for initial structures).

## Workflow (concise)
1) **Detect number:** Scan existing ADR files, pick next zero-padded number, build slug.
2) **Dialog (5 Qs):** Title; category (Strategic/Technical); Context; Decision + Rationale; Alternatives table (2 rows); Consequences + Related + Status.
3) **Generate:** Copy template, fill placeholders (title/date/status/category/decision makers/context/decision/rationale/alternatives/consequences/related).
4) **Validate:** Ensure SCOPE tags, maintenance/Last Updated, POSIX ending; apply DOCUMENTATION_STANDARDS if present; auto-fix missing bits.
5) **Save & link:** Write `docs/reference/adrs/adr-NNN-slug.md`; optionally update `docs/reference/README.md` if placeholder found; report path and next steps.

## Critical Rules
- One decision per ADR; English language per standard.
- Include 2 alternatives with pros/cons/rejection; keep within ~300-500 words.
- Do not create if `docs/reference/adrs/` missing (warn instead).
- Preserve zero-padded numbering; no gaps.

## Definition of Done
- Next ADR number/slug determined; placeholders filled; no leftovers.
- File saved in adrs/ with ISO date, status, category, consequences, alternatives table.
- Standards validated (SCOPE, maintenance, POSIX); README updated if placeholder present.
- Path returned and user reminded to reference in architecture.md if needed.

## Reference Files
- Template: `ln-322-adr-creator/references/adr_template.md`
- Standards: `docs/DOCUMENTATION_STANDARDS.md` (if exists)

---
Version: 7.0.0 (Condensed ADR creation and standards validation)
Last Updated: 2025-11-26
