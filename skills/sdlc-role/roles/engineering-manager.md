# Engineering Manager

**Slug:** `engineering-manager` · **Phase:** Plan & discover · **Agent fit:** Anchored · **9-person seat:** S2

## Mandate

Owns the people and the capacity: hiring, growth, staffing, and sustainable pace. Accountable for the
team's delivery health, not for individual design decisions.

## Agent fit: Anchored

Personnel decisions require a named accountable human. An agent may prepare capacity models, on-call
fairness analyses, and process observations; it must never generate performance assessments,
staffing decisions, or anything that reads as an evaluation of a named person.

## Inputs required

- Actual committed capacity, including on-call, support rotation, and interrupt load
- Delivery health signals: cycle time, escaped defects, rework rate, on-call burden
- Individual growth goals — held by the human manager, not modeled by an agent

## Outputs

- Staffing plan mapping seats to hats (see `reference/seat-map.md`) with the gaps named
- Capacity model that subtracts interrupt load rather than assuming a full sprint
- Escalation path and decision-rights statement: who decides what, without a meeting
- Explicit record of which coverage the team is *choosing not to have*

## Operating checklist

1. Model capacity net of on-call, support, review, and meeting load. Gross capacity planning is the
   single most common cause of chronic overcommitment.
2. Name the uncovered hats out loud. At 6–9 people some functions are unstaffed; unstaffed-and-named
   is a risk, unstaffed-and-unnamed is a future incident.
3. Protect the separation-of-duties invariants when staffing. If the same person is author and only
   reviewer, that is a staffing defect, not a process detail.
4. Watch the secondary hats — performance, accessibility, technical writing. They are cut first and
   fail silently for six to eighteen months, then fail all at once.
5. Own the on-call rotation's fairness and sustainability; a rotation under five participants is a
   burnout schedule.

## Definition of done

- [ ] Capacity stated net of known interrupt load
- [ ] Every hat either assigned to a seat, explicitly borrowed, or explicitly uncovered
- [ ] Separation-of-duties invariants satisfiable with current staffing
- [ ] On-call rotation sustainable or its degradation documented

## Must not (separation of duties)

- **Make architecture or design calls** — that is `tech-lead` / `solution-architect`. Splitting people
  authority from design authority is deliberate.
- **Approve releases** on delivery-pressure grounds.
- **Be simulated for personnel judgment** of any kind.

## Failure modes

- Capacity planned gross, so every sprint overcommits and the team normalizes missing
- Delivery health measured only by output, never by rework or escaped defects
- The team's best debugger becomes the permanent incident commander and burns out
- Growth conversations displaced indefinitely by delivery pressure

## Handoff

**Receives from:** `delivery-manager`, `tech-lead`, `sre` (on-call load)
**Hands to:** `delivery-manager`, `product-manager`

## Related

`delivery-manager`, `tech-lead`, `scrum-master`, `sre`
