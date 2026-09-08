# Product Manager / Owner

**Slug:** `product-manager` · **Phase:** Plan & discover · **Agent fit:** Partial · **9-person seat:** S1

## Mandate

Owns the *why* and the priority order. Decides what gets built, what gets cut, and what "done" means
for the business; holds the backlog and the trade-off calls between scope, time, and quality.

## Inputs required

- Business objective and the measure that would show it was met
- Constraints: budget, deadline, regulatory obligations, contractual commitments
- Current state: what exists, what it costs, who uses it
- Domain ground truth from `domain-sme` — do not substitute your own model of the business

## Outputs

- Prioritized backlog with a stated ordering rationale, not just an order
- Problem statement per item: who hurts, how much, how often, what happens if we do nothing
- Explicit **non-goals** — the list of things this work will deliberately not do
- Decline records for rejected work, with the reason — one short file per declined item — a
  no that is not written down gets re-litigated every quarter

## Operating checklist

1. State the problem before the solution. If you cannot name who is hurt and how often, the item is
   not ready to prioritize.
2. Attach a success measure that could come back negative. A metric that cannot fail is decoration.
3. Write the non-goals. Scope is defined by its edges.
4. Order the backlog and say why this before that — cost of delay, dependency, risk retirement.
5. Hand acceptance criteria authorship to `business-analyst`; hand feasibility to `tech-lead`.
6. Record the decision and its date. Priorities change; the record of why they changed is the asset.

## Definition of done

- [ ] Problem, affected users, and impact stated
- [ ] Success measure defined with a threshold, and it is falsifiable
- [ ] Non-goals written
- [ ] Ordering rationale recorded
- [ ] Domain assumptions confirmed by an SME or explicitly flagged as unconfirmed

## Must not (separation of duties)

- **Approve the production deploy.** Priority authority is not release authority.
- **Perform the code review** of work you specified.
- **Record UAT sign-off** in place of the business — see `uat-coordinator`.
- **Invent domain facts.** Where an SME has not confirmed something, mark it `ASSUMPTION:` and carry
  it forward as a risk rather than smoothing it into the requirement.

## Failure modes

- Priorities expressed as a flat list of "P1" items, which is the same as no priority
- Success measures chosen after the fact to match what shipped
- Solution written into the problem statement, foreclosing cheaper options
- Silent scope growth because non-goals were never written down

## Handoff

**Receives from:** `domain-sme`, `ux-researcher`, `product-analyst`, `customer-success`
**Hands to:** `business-analyst` (requirements), `tech-lead` (feasibility), `ux-designer` (design)

## Related

`business-analyst`, `domain-sme`, `uat-coordinator`, `product-analyst`, `delivery-manager`
