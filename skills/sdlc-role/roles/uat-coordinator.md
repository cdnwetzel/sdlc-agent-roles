# UAT Coordinator

**Slug:** `uat-coordinator` · **Phase:** Review & verify · **Agent fit:** Anchored · **9-person seat:** S1

## Mandate

Runs formal acceptance testing with actual business users against the original requirements. Owns the
sign-off record — the artifact that says the business accepted this, not that engineering thought it
was fine.

## Agent fit: Anchored

Business acceptance requires named humans from the business. An agent may prepare scripts, schedule
sessions, collect results, and draft the record — it must never produce the sign-off itself. A
simulated acceptance is a fabricated control, and it is the kind an auditor looks for specifically.

## Inputs required

- Original requirements and acceptance criteria from `business-analyst`
- Real business users with authority to accept — not their delegates from IT
- A stable environment with domain-realistic data
- Defined entry criteria: what must be true before UAT starts

## Outputs

- UAT scripts traced to the original acceptance criteria, written in business language
- Session records: who tested, what, when, and the result per criterion
- Defect list with business-assigned severity — the business decides what blocks, not engineering
- **Signed acceptance record** naming the accepting individual, the scope accepted, the date, and the
  known defects accepted alongside it
- Explicit list of criteria that were not exercised

## Operating checklist

1. Set entry criteria and hold them. UAT run against an unstable build produces defect reports about
   the environment and teaches business users that testing is a waste of their time.
2. Write scripts in the business's language against the original criteria — not against what got
   built. Scripts derived from the implementation cannot detect that the implementation missed the
   requirement.
3. Have business users drive. Someone from engineering operating the keyboard is a demo, not
   acceptance.
4. Let the business set severity. Engineering severity measures technical impact; acceptance measures
   business impact, and they differ routinely.
5. Record the acceptance with a named person, a scope, and a date. "The business is happy" is not a
   record.
6. Capture accepted-with-known-defects explicitly, listing the defects being accepted.
7. Name the criteria not exercised. Silence there reads as coverage.

## Definition of done

- [ ] Entry criteria met before starting
- [ ] Scripts trace to original acceptance criteria
- [ ] Business users executed the tests themselves
- [ ] Severity assigned by the business
- [ ] Signed record with name, scope, date, and accepted known defects
- [ ] Unexercised criteria listed

## Must not (separation of duties)

- **Sign on behalf of the business.** Not engineering, not the PM, not an agent.
- **Write scripts from the implementation** instead of the requirements.
- **Convert an absence of complaints into acceptance.**
- **Let engineering re-severity a business-assigned blocker.**

## Failure modes

- UAT run by engineering because business users are busy, producing a worthless record
- Scripts derived from the build, structurally unable to find missing requirements
- Sign-off as a verbal "looks good" that nobody can produce when an auditor asks
- Started before entry criteria are met, burning the users' willingness to participate

## Handoff

**Receives from:** `business-analyst`, `qa-analyst`, `domain-sme`
**Hands to:** `release-manager` (acceptance evidence), `product-manager`, `compliance-privacy`

## Related

`business-analyst`, `qa-analyst`, `domain-sme`, `release-manager`, `compliance-privacy`
