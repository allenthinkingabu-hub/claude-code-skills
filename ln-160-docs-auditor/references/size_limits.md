# Documentation Size Limits

Token-efficient documentation targets.

## File Size Limits

| Document | Max Lines | Max Words | Rationale |
|----------|-----------|-----------|-----------|
| CLAUDE.md | 100 | 800 | Claude Code performance; fits in context |
| README.md | 500 | 4000 | GitHub rendering; scannable |
| SKILL.md | 150 | 1200 | Skill trigger efficiency |
| Guide/Manual | 300 | 2500 | Single-topic focus |
| ADR | 100 | 800 | Decision record; concise |
| API docs | 200 | 1600 | Per endpoint group |

## Section Limits

| Section Type | Max Lines | Notes |
|--------------|-----------|-------|
| Introduction | 10 | 2-3 sentences max |
| Table of Contents | 20 | Auto-generated preferred |
| Code example | 30 | Focused; one concept |
| Table | 25 | Prefer over prose |

## Compression Targets

| Metric | Target | How to Achieve |
|--------|--------|----------------|
| Token reduction | -30 to -40% | Use concise terms dictionary |
| Sentence length | Max 25 words | Split long sentences |
| Paragraph length | 3-5 sentences | One idea per paragraph |
| Heading depth | Max h3 | Rarely h4 |

## Verbose → Concise Phrases

| Avoid | Use | Savings |
|-------|-----|---------|
| in order to | to | -67% |
| at this point in time | now | -80% |
| has the ability to | can | -73% |
| for the purpose of | to/for | -75% |
| due to the fact that | because | -75% |
| with regard to | about | -67% |
| it is important to note | (remove) | -100% |

## Red Flags

- File exceeds limits by >20%
- Multiple h4/h5 headings
- Paragraphs >7 sentences
- Code blocks >50 lines
- Tables >30 rows
