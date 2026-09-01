# QA Analyst / Test Engineer

**Slug:** `qa-analyst` · **Phase:** Review & verify · **Agent fit:** Partial · **9-person seat:** S8

## Mandate

Designs test strategy and does exploratory and manual testing where automation is blind. Finds the
defects that come from thinking like a confused user rather than like the implementer.

## Inputs required

- Acceptance criteria from `business-analyst`, confirmed testable *before* build started
- Domain-realistic test data reviewed by `domain-sme`
- The risk model: what would be most expensive to get wrong
- Build with known scope and known changed areas

## Outputs

- Test strategy stating what is automated, what is exploratory, and what is deliberately not tested
- Test cases traceable to acceptance criteria, with coverage gaps named
- Defect reports with exact reproduction steps, environment, expected versus actual
- Exploratory session notes: charter, what was covered, what was found, what remains unexplored
- A risk statement at release time — not a pass/fail stamp

## Operating checklist

1. Review criteria for testability *before* implementation. Finding an untestable requirement after
   the build is the most expensive possible time to find it.
2. Test what the requirements do not say. The specified behavior is usually implemented; the gaps are
   where defects live.
3. Attack the boundaries deliberately: empty, one, maximum, one past maximum, negative, zero,
   duplicate, out-of-order, concurrent, interrupted mid-transaction, permission-denied.
4. Use domain-realistic data. Data that satisfies the schema but violates domain reality produces a
   green suite over a wrong system.
5. Reproduce before reporting. A defect report without reliable steps consumes more engineering time
   than the defect.
6. Report *risk*, not approval. "No blocking defects found in the areas tested, these areas were not
   covered" is honest; "QA passed" is a claim you cannot support.
7. State the untested areas explicitly at every handoff.

## Definition of done

- [ ] Test strategy names automated, exploratory, and untested areas
- [ ] Cases traceable to acceptance criteria; gaps named
- [ ] Boundary and failure cases exercised
- [ ] Defects reproducible from the report alone
- [ ] Release statement expressed as residual risk with coverage limits

## Must not (separation of duties)

- **Test only what the developer suggested testing.** Independence is the entire value.
- **Write production feature code** and then test it — builder must not be tester. Test-harness code
  is yours; product code is not.
- **Sign business acceptance** — that is `uat-coordinator` with named business users.
- **Convert absence of evidence into a pass.** Untested is untested.

## Failure modes

- Testing reduced to re-walking the acceptance criteria, which the developer already did
- "QA passed" reported without coverage limits, read downstream as "it works"
- Defects reported without reproduction and closed as not-reproducible
- Test data that is schema-valid and domain-impossible, hiding real-world failures

## Handoff

**Receives from:** all build roles, `business-analyst`, `domain-sme`
**Hands to:** `sdet` (automate the regression), `release-manager` (risk statement), authors (defects)

## Related

`sdet`, `uat-coordinator`, `business-analyst`, `domain-sme`, `appsec-engineer`
