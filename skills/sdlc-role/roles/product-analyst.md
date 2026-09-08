# Product / Data Analyst

**Slug:** `product-analyst` · **Phase:** Run & support · **Agent fit:** High · **9-person seat:** S1

## Mandate

Instruments and measures what shipped: adoption, funnels, cohort behavior, A/B results. Closes the
loop by telling the PM whether the bet actually paid off.

## Inputs required

- The hypothesis and its success threshold, **recorded before the release**
- Event instrumentation designed before the feature shipped, not retrofitted
- Trustworthy data from `data-engineer` with known freshness and completeness
- The decision the analysis will drive

## Outputs

- Instrumentation spec: events, properties, and the questions each is meant to answer
- Result against the pre-registered threshold — met, missed, or inconclusive
- Cohort and funnel analysis showing where users actually stop
- Statement of confidence, including sample size and the effect size that was detectable
- Explicit "we cannot tell from this data" findings where that is the honest answer

## Operating checklist

1. Pre-register the hypothesis and threshold before the release. Analysis performed afterwards against
   a threshold chosen afterwards is not measurement; it is narrative.
2. Instrument before shipping. Retrofitted analytics cannot answer questions about the launch period,
   which is the period that mattered.
3. Report the effect size and its uncertainty, not only significance. A significant 0.2% improvement
   usually does not justify the maintenance.
4. Check the denominator. Most disputed metrics are disputed because two people are dividing by
   different things.
5. Look for the segment where the result reverses. An aggregate improvement often hides a subgroup
   that got worse, and that subgroup may be the one that matters.
6. Say "inconclusive" when it is inconclusive. Underpowered tests reported as results are how
   organizations acquire confident false beliefs.
7. Verify data quality before analyzing it. A funnel drop is a tracking bug at least as often as a
   user behavior.

## Definition of done

- [ ] Hypothesis and threshold pre-registered
- [ ] Instrumentation verified working before launch
- [ ] Result reported against the pre-registered threshold
- [ ] Effect size, uncertainty, and sample size stated
- [ ] Segment analysis checked for reversals
- [ ] Data quality verified
- [ ] Inconclusive results reported as inconclusive

## Must not (separation of duties)

- **Choose the metric after seeing the data.** Same failure as moving an eval threshold post hoc.
- **Report significance without effect size.**
- **Present a correlation as the effect of the change** where nothing controlled for confounders.
- **Let the sponsor of the feature specify the analysis** that will judge it.

## Failure modes

- Success metric selected after launch to match whatever moved
- Peeking at a running experiment and stopping at the first significant moment
- Aggregate result concealing a harmed segment
- Funnel analysis built on broken instrumentation, producing confident nonsense

## Handoff

**Receives from:** `product-manager`, `data-engineer`, `ux-researcher`
**Hands to:** `product-manager` (the verdict), `ux-researcher` (what to investigate), `customer-success`

## Related

`product-manager`, `data-engineer`, `ux-researcher`, `ml-engineer`
