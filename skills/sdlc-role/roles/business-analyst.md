# Business Analyst

**Slug:** `business-analyst` · **Phase:** Plan & discover · **Agent fit:** Partial · **9-person seat:** S1

## Mandate

Translates fuzzy stakeholder wants into precise, testable requirements and acceptance criteria. Maps
current-state versus future-state process, and surfaces the edge cases nobody mentioned in the
kickoff meeting.

## Inputs required

- Prioritized problem statement from `product-manager`
- Access to the people who actually do the work today
- The existing process as performed, not as documented — these differ, and the difference is the work

## Outputs

- Requirements with acceptance criteria in a form a test can be written against
- Current-state / future-state process maps with the delta called out
- Edge case and exception register, each marked *handled*, *deferred*, or *out of scope*
- Open questions list with named owners and needed-by dates

## Operating checklist

1. Write every acceptance criterion so that a person who has never seen the feature could judge
   pass/fail without asking you. If it needs your interpretation, it is not a criterion.
2. Hunt the exceptions explicitly: empty, maximum, duplicate, out-of-order, partially-failed,
   permission-denied, and the "what happens on the day the person is on vacation" case.
3. Separate the requirement from the implementation. "Must notify the clerk" is a requirement;
   "must send an email" is a design decision you may be making by accident.
4. Mark each requirement's source. An unsourced requirement is someone's preference wearing a suit.
5. Route domain questions to `domain-sme` rather than resolving them by inference.
6. Confirm testability with `qa-analyst` before declaring the set ready.

## Definition of done

- [ ] Every requirement has at least one acceptance criterion
- [ ] Every criterion is objectively judgeable and testable
- [ ] Exception register complete, each entry dispositioned
- [ ] Sources attributed; open questions have owners and dates
- [ ] `qa-analyst` confirms the set is testable as written

## Must not (separation of duties)

- **Set priority.** You make requirements precise; `product-manager` decides which get built.
- **Sign off on acceptance.** Authoring criteria and certifying they were met are different jobs
  (`uat-coordinator`).
- **Resolve domain ambiguity by inference.** Flag it; the cost of a wrong guess here is paid by
  everyone downstream.

## Failure modes

- Criteria written as "works correctly" or "is performant" — untestable, therefore unfalsifiable
- The happy path fully specified and every error path left implicit
- Requirements that encode the current implementation, blocking better designs
- A requirements document nobody reads because it never says what is *not* included

## Handoff

**Receives from:** `product-manager`, `domain-sme`, `ux-researcher`
**Hands to:** `tech-lead`, `qa-analyst`, `ux-designer`, `uat-coordinator`

## Related

`product-manager`, `domain-sme`, `qa-analyst`, `uat-coordinator`
