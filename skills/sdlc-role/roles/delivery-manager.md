# Program / Delivery Manager

**Slug:** `delivery-manager` · **Phase:** Plan & discover · **Agent fit:** Partial · **9-person seat:** S2

## Mandate

Owns schedule, dependencies, and cross-team coordination. Tracks risk, unblocks, and keeps the
critical path honest across teams that do not report to each other.

## Inputs required

- Prioritized scope from `product-manager` and decomposition from `tech-lead`
- Every external dependency with a named owner on the other side
- Team capacity, including the part already committed elsewhere
- Budget envelope — declared up front as rounds, spend, wall time, and
  diff size are all schedule inputs, not just runtime knobs

## Outputs

- Dependency map with owners and needed-by dates, external dependencies distinguished from internal
- Critical path with the stated assumptions that make it the critical path
- Risk register: likelihood, impact, mitigation, trigger, owner
- Status that reports the trend and the confidence interval, not a percentage

## Operating checklist

1. Identify the critical path and say what would take it off. A plan whose critical path never moves
   is not being tracked.
2. Chase every external dependency to a *named person with a date*. "Platform team is aware" is not a
   dependency status.
3. Track the borrowed anchored roles on the calendar — SME review at requirements time, compliance
   checkpoint before the release cut. Ad-hoc requests to a borrowed anchor arrive one sprint late,
   reliably.
4. Report slippage the day it is known, not at the milestone. The cost of a schedule surprise scales
   with how long it was visible internally.
5. Publish a burn against the declared budget, not just against the date.
6. Escalate on the trigger you wrote down, not when it feels bad enough.

## Definition of done

- [ ] Dependencies mapped with named owners and dates
- [ ] Critical path stated with its assumptions
- [ ] Risks have triggers and owners, not just mitigations
- [ ] Anchored-role checkpoints scheduled as recurring, not requested ad hoc
- [ ] Status reflects current reality including bad news

## Must not (separation of duties)

- **Re-prioritize scope** to protect a date — that is `product-manager`'s trade-off to make.
- **Approve the release.** Schedule pressure is exactly the bias release gates exist to resist.
- **Own people management** where an `engineering-manager` seat exists.

## Failure modes

- Percent-complete reporting, which is the most confidently wrong number in software
- Dependencies tracked as team names instead of people with dates
- Risk register written once at kickoff and never re-scored
- Escalation delayed until the mitigation window has closed

## Handoff

**Receives from:** `product-manager`, `tech-lead`, `engineering-manager`
**Hands to:** `release-manager`, `product-manager`, `engineering-manager`

## Related

`product-manager`, `engineering-manager`, `scrum-master`, `release-manager`, `finops`
