---
name: ln-205-market-researcher
description: Research market conditions, competitors, trends, customer profiles via WebSearch/Ref/Context7. Generate analysis documents with RICE/ICE prioritization. Standalone L2 worker for Epic-level planning.
---

# Market Researcher

Research market opportunity before Epic creation. Generates comprehensive analysis documents with feature prioritization.

## Purpose & Scope

- Research market via WebSearch, MCP Ref, Context7
- Generate 7 analysis documents in docs/market/[topic]/
- Provide RICE/ICE scoring for feature prioritization
- Support strategic decisions before Epic decomposition

## When to Use

**Use this skill when:**
- Planning new product/feature with market uncertainty
- Entering competitive market (need competitor analysis)
- Evaluating market size for investment decisions
- Prioritizing features based on market data

**Do NOT use when:**
- Internal tools (no market)
- PoC/prototype (no business case yet)
- Minor feature updates (overkill)
- Market research already exists in docs/market/

**Who calls this skill:**
- **User (manual)** - before ln-210-epic-coordinator
- **Future:** ln-200-scope-decomposer (optional Phase 0)

---

## Input Parameters

| Parameter | Required | Description | Default |
|-----------|----------|-------------|---------|
| topic | Yes | Product/market name to research | - |
| scope | No | Geographic/industry scope | "global" |
| goals | No | What decisions to inform | "feature prioritization" |
| analyses | No | Subset of 6 types to run | "all" |

**analyses options:** `competitor`, `sizing`, `trends`, `customer`, `ocean`, `all`

---

## Output Structure

```
docs/market/[topic-slug]/
├── competitor_analysis.md      # Top-10 competitors, feature matrix, positioning
├── market_sizing.md            # TAM/SAM/SOM calculations
├── trends.md                   # 5-7 key trends with impact assessment
├── customer_profile.md         # JTBD framework, 2-3 personas
├── ocean_analysis.md           # Blue/Red Ocean, ERRC grid
├── prioritization.md           # RICE/ICE scored feature list
└── summary.md                  # Executive summary, recommendations
```

---

## Research Tools

| Tool | Purpose | Example Query |
|------|---------|---------------|
| **WebSearch** | Market data, competitors, trends | "[topic] market size 2025" |
| **mcp__Ref** | Industry reports, whitepapers | "[topic] industry analysis report" |
| **mcp__context7** | Technology trends, adoption | "[library] adoption statistics" |
| **Glob** | Check existing docs/market/ | "docs/market/[topic]/*" |

**Tool selection by analysis:**
- Competitor: WebSearch (G2, Capterra, Crunchbase)
- Sizing: WebSearch + Ref (Statista, IBISWorld, Gartner)
- Trends: WebSearch + Context7 (Google Trends, GitHub, StackOverflow)
- Customer: WebSearch (forums, reviews, job postings)
- Ocean: Synthesize from above (no new research)

---

## Workflow

### Phase 1: Input & Context (5 min)

**Objective:** Gather input parameters and check existing research.

**Process:**

1. **Validate input:**
   - topic (required) - slugify for directory name
   - scope (default: global)
   - goals (default: feature prioritization)
   - analyses (default: all)

2. **Check existing research:**
   ```
   Glob: docs/market/[topic-slug]/*
   ```
   - If exists: Ask "Update existing or create new?"
   - If new: Continue to Phase 2

3. **Create output directory:**
   ```
   mkdir -p docs/market/[topic-slug]/
   ```

**Output:** Validated parameters, empty output directory

---

### Phase 2: Competitor Research (10 min)

**Objective:** Analyze competitive landscape.

**Process:**

1. **Search competitors:**
   ```
   WebSearch: "[topic] competitors 2025"
   WebSearch: "[topic] alternatives comparison"
   WebSearch: "[topic] market leaders"
   ```

2. **Extract for each competitor (top 10):**
   - Company name, founded, funding, employees, HQ
   - Key features (5-10 most important)
   - Pricing model and tiers
   - Target customer segment
   - Recent news (funding, launches)

3. **Build feature matrix:**
   - List all unique features across competitors
   - Score: Yes / No / Partial for each
   - Identify gaps (features no one offers)

4. **Create positioning map:**
   - X-axis: Feature richness (Basic → Enterprise)
   - Y-axis: Price (Low → High)
   - Plot competitors + identify white space

5. **Generate:** Fill competitor_template.md, save to docs/market/[topic]/competitor_analysis.md

**Output:** competitor_analysis.md

---

### Phase 3: Market Sizing (10 min)

**Objective:** Calculate TAM/SAM/SOM with methodology.

**Process:**

1. **Research market size:**
   ```
   WebSearch: "[topic] market size TAM 2025"
   WebSearch: "[topic] industry report forecast"
   Ref: "[topic] market analysis Gartner Statista"
   ```

2. **Calculate TAM (Total Addressable Market):**
   - Top-down: Industry reports, apply segment %
   - Bottom-up: Total customers × Average revenue
   - Cross-validate with 2+ sources

3. **Calculate SAM (Serviceable Addressable Market):**
   - Apply filters: geography, company size, tech fit
   - Document each filter with %

4. **Calculate SOM (Serviceable Obtainable Market):**
   - Realistic market share in 3-5 years
   - Factor: competition, budget, team capacity

5. **Project growth:**
   - CAGR from reports
   - Year-by-year forecast

6. **Generate:** Fill market_sizing_template.md, save to docs/market/[topic]/market_sizing.md

**Output:** market_sizing.md

---

### Phase 4: Trend Analysis (8 min)

**Objective:** Identify 5-7 key trends affecting the market.

**Process:**

1. **Research trends:**
   ```
   WebSearch: "[topic] trends 2025 2026"
   WebSearch: "[topic] future predictions"
   Context7: "[related technology] adoption trends"
   ```

2. **For each trend (5-7):**
   - Category: Technology / Market / Regulatory / Customer / Economic
   - Impact: High / Medium / Low
   - Timeframe: Now / 1-2 years / 3-5 years
   - Evidence: 2-3 data points with sources
   - Implications: Opportunity + Threat + Action

3. **Build impact matrix:**
   - X-axis: Timeframe (Now → Future)
   - Y-axis: Impact (Low → High)
   - Classify: Urgent Action / Strategic Priority / Monitor / Watch

4. **Generate:** Fill trend_analysis_template.md, save to docs/market/[topic]/trends.md

**Output:** trends.md

---

### Phase 5: Customer Profile (10 min)

**Objective:** Define target customers using JTBD framework.

**Process:**

1. **Research customer needs:**
   ```
   WebSearch: "[topic] customer segments"
   WebSearch: "[topic] user reviews pain points"
   WebSearch: "[topic] jobs to be done"
   ```

2. **Build JTBD framework:**
   - Core job statement: "When [situation], I want to [goal], so I can [outcome]"
   - Functional jobs: What they need to DO (5 items)
   - Emotional jobs: How they want to FEEL (3 items)
   - Social jobs: How they want to be PERCEIVED (3 items)

3. **Create personas (2-3):**
   - Demographics: Role, company size, industry, experience
   - Goals: Primary, secondary, tertiary
   - Pain points: With severity (Critical/Major/Minor)
   - Current solutions: With satisfaction level
   - Buying behavior: Authority, process, criteria

4. **Build buying criteria matrix:**
   - Criteria: Price, features, ease of use, integration, support, security
   - Weight % for each persona

5. **Generate:** Fill customer_profile_template.md, save to docs/market/[topic]/customer_profile.md

**Output:** customer_profile.md

---

### Phase 6: Ocean Analysis (7 min)

**Objective:** Determine Blue/Red Ocean and differentiation strategy.

**Process:**

1. **Classify ocean type:**
   - Red Ocean indicators (6): Many competitors, price wars, feature parity, slow growth, high churn, commoditization
   - Blue Ocean indicators (6): Unmet needs, new market creation, non-customers, value innovation, low competition, high growth
   - Score each indicator Y/N

2. **Build Strategy Canvas:**
   - Identify 7 key factors industry competes on
   - Plot industry average for each
   - Identify where to diverge

3. **Apply Four Actions Framework (ERRC):**
   - **Eliminate:** What to remove (industry takes for granted)
   - **Reduce:** What to lower below standard
   - **Raise:** What to increase above standard
   - **Create:** What to introduce (never offered)

4. **Analyze non-customers:**
   - Tier 1: Soon-to-be (on edge of market)
   - Tier 2: Refusing (chose against market)
   - Tier 3: Unexplored (never considered)

5. **Generate:** Fill ocean_analysis_template.md, save to docs/market/[topic]/ocean_analysis.md

**Output:** ocean_analysis.md

---

### Phase 7: Prioritization & Summary (10 min)

**Objective:** Score features and generate executive summary.

**Process:**

1. **Collect features:**
   - From competitor analysis: Feature matrix gaps
   - From customer profile: Unmet needs, pain points
   - From trends: Emerging requirements
   - From ocean analysis: ERRC Create/Raise items

2. **Score with RICE:**
   ```
   RICE = (Reach × Impact × Confidence) / Effort

   Reach: 1-10 (users affected per quarter)
   Impact: 0.25-3 (Minimal to Massive)
   Confidence: 0.5-1.0 (data quality)
   Effort: 1-10 (person-months)
   ```

3. **Score with ICE:**
   ```
   ICE = Impact × Confidence × Ease

   Impact: 1-10 (business value)
   Confidence: 1-10 (certainty)
   Ease: 1-10 (implementation simplicity)
   ```

4. **Rank features:**
   - Combined rank = average of RICE rank + ICE rank
   - Top 10 with rationale

5. **Generate prioritization.md:**
   - Fill prioritization_template.md
   - Include scoring tables and rationale

6. **Generate summary.md:**
   - Fill summary_template.md
   - Key findings (Market, Competition, Customer, Trends)
   - Strategic recommendations (Entry strategy, Product priorities, Positioning)
   - Risk assessment
   - Next steps

**Output:** prioritization.md, summary.md

---

## Integration with Ecosystem

**Position in workflow:**
```
[User Request] → ln-205-market-researcher
                        ↓
                 docs/market/[topic]/
                        ↓
              ln-210-epic-coordinator (uses in Phase 1.2)
                        ↓
              ln-220-story-coordinator
```

**Dependencies:**
- WebSearch, mcp__Ref, mcp__context7 (research)
- Glob, Write, Bash (file operations)

**Downstream usage:**
- ln-210-epic-coordinator Phase 1 Step 2 (Project Research) can reference docs/market/
- Epic description can link to research documents
- Feature priorities inform Epic scope

---

## Critical Rules

1. **Source all data** - Every number needs source + date
2. **Prefer recent data** - 2024-2025, warn if older
3. **Cross-reference** - 2+ sources for key metrics (TAM, competitor count)
4. **Time-box strictly** - 45-60 min total, skip depth for speed
5. **Confidence levels** - Mark High/Medium/Low for estimates
6. **No speculation** - Only sourced claims, note gaps
7. **Preserve language** - If user asks in Russian, respond in Russian

---

## Definition of Done

- [ ] All requested analyses completed (default: 6)
- [ ] All 7 documents generated with no placeholders
- [ ] Sources cited with dates for all data points
- [ ] Confidence levels assigned to estimates
- [ ] RICE/ICE scores calculated for 10+ features
- [ ] Executive summary includes actionable recommendations
- [ ] Files saved to docs/market/[topic-slug]/
- [ ] Total time within 45-60 minute budget

---

## Best Practices

### Time Management
- Phase 1 (Input): 5 min
- Phases 2-6 (Research): 8-10 min each = 40-50 min
- Phase 7 (Synthesis): 10 min
- **Total:** 55-65 min

### Data Quality
- Prefer: Industry reports > News > Blogs
- Require: Date on all sources
- Validate: Cross-reference TAM/SAM with 2+ sources
- Document: Note methodology for all calculations

### Research Efficiency
- Use parallel WebSearch calls where possible
- Cache competitor list for reuse across phases
- Skip deep dives if time-constrained
- Focus on actionable insights over completeness

---

## Example Usage

**Basic usage:**
```
ln-205-market-researcher topic="Document Translation API"
```

**With parameters:**
```
ln-205-market-researcher topic="AI Code Review" scope="enterprise, North America" goals="Series A pitch deck"
```

**Specific analyses only:**
```
ln-205-market-researcher topic="PDF Converter" analyses="competitor,sizing"
```

**Example output:**
```
docs/market/ai-code-review/
├── competitor_analysis.md    # GitHub Copilot, Tabnine, Codeium, Amazon Q...
├── market_sizing.md          # TAM: $5.2B, SAM: $1.2B, SOM: $50M
├── trends.md                 # AI-first development, DevEx focus, security
├── customer_profile.md       # DevOps Lead persona, JTBD: reduce review time
├── ocean_analysis.md         # Red Ocean (crowded), Blue space in security
├── prioritization.md         # #1: Security scanning (RICE: 45)
└── summary.md                # Enter via security niche, enterprise focus
```

---

## Reference Files

| File | Purpose |
|------|---------|
| [research_sources.md](references/research_sources.md) | Trusted sources by category |
| [competitor_template.md](references/competitor_template.md) | Competitor analysis output |
| [market_sizing_template.md](references/market_sizing_template.md) | TAM/SAM/SOM output |
| [trend_analysis_template.md](references/trend_analysis_template.md) | Trends output |
| [customer_profile_template.md](references/customer_profile_template.md) | JTBD + personas output |
| [ocean_analysis_template.md](references/ocean_analysis_template.md) | Blue/Red Ocean output |
| [prioritization_template.md](references/prioritization_template.md) | RICE/ICE scoring output |
| [summary_template.md](references/summary_template.md) | Executive summary output |

---

**Version:** 1.0.0
**Last Updated:** 2025-12-22
