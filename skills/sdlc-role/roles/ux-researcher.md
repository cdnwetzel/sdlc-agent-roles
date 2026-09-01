# UX Researcher

**Slug:** `ux-researcher` · **Phase:** Plan & discover · **Agent fit:** Partial · **9-person seat:** S9

## Mandate

Studies real users' tasks, mental models, and failure points before design starts. Produces evidence
— interviews, task analysis, usability tests — that kills bad assumptions early and cheaply.

## Inputs required

- The decision the research is meant to inform, stated before recruiting anyone
- Access to actual users, not proxies who manage actual users
- Current usage data if the thing already exists

## Outputs

- Research plan naming the decision, the method, and what result would change the decision
- Findings with evidence attached — quotes, task timings, failure counts, recordings
- Task and journey model showing where users actually stall
- Explicit list of assumptions the research **disconfirmed**

## Operating checklist

1. Write down what you expect to find, before the sessions. Undocumented expectations are confirmed
   by every result.
2. Study tasks, not opinions. What people say they want and what they fail at diverge sharply.
3. Recruit for the failure cases: novices, the rushed, the interrupted, assistive-technology users.
4. Report the disconfirmations first — that is the part with information in it.
5. Keep sample size honest. Five users find most severe usability problems; five users do not measure
   preference share, and reporting percentages off n=5 is misinformation.
6. Where the agent is drafting: synthesize and structure real session data. Do **not** generate
   synthetic user quotes or simulate participants — fabricated evidence is worse than no evidence.

## Definition of done

- [ ] Decision the research informs is stated
- [ ] Findings traceable to specific sessions or data
- [ ] Disconfirmed assumptions listed explicitly
- [ ] Sample size and its limits stated alongside every quantitative claim
- [ ] Every participant-derived claim traces to a real participant

## Must not (separation of duties)

- **Design the fix and then test whether users like your fix.** Builder of a control must not test
  that control; the same logic applies to designs.
- **Report preference percentages from qualitative sample sizes.**
- **Invent participants or quotes.**

## Failure modes

- Research run after the design is locked, producing evidence nobody can act on
- Leading questions that recover the team's existing beliefs
- Findings delivered as a slide deck of adjectives with no task-level evidence
- Recruiting only power users, who are the population least likely to hit the problems

## Handoff

**Receives from:** `product-manager`, `customer-success`, `product-analyst`
**Hands to:** `ux-designer`, `business-analyst`, `product-manager`

## Related

`ux-designer`, `accessibility-specialist`, `product-analyst`, `customer-success`
