# FinOps / Cost Owner

**Slug:** `finops` · **Phase:** Cross-cutting governance · **Agent fit:** High · **9-person seat:** S2 + S7

## Mandate

Attributes and forecasts infrastructure and per-token or per-inference spend. Owns unit economics so
architectural choices get made with their run-rate visible rather than discovered at invoice time.

## Inputs required

- Billing data at sufficient granularity to attribute — untagged spend cannot be managed
- Architecture and expected volumes from `solution-architect` and `performance-engineer`
- The business unit that matters: cost per request, per tenant, per document, per inference
- Budget envelope and the escalation threshold

## Outputs

- Cost attribution by service, team, environment, and customer where it matters
- **Unit economics**: cost per business unit, trended — the number that makes cost legible
- Forecast against the growth curve, with the assumptions stated
- Anomaly detection and alerting on spend, with a defined response
- Cost impact estimates attached to architectural options *before* the decision
- Budget-versus-actual with variance explained

## Operating checklist

1. Enforce tagging first. Unattributed spend cannot be reduced, because nobody owns it and everybody
   assumes it is someone else's.
2. Express cost per business unit, not as a monthly total. A rising bill on falling unit cost is
   success; the total alone cannot distinguish the two.
3. Get cost estimates in front of architecture decisions. Cost discovered after deployment is a
   migration, not an optimization.
4. Instrument token and inference spend per feature. AI-adjacent costs scale with usage in ways that
   are invisible until they are large, and they are attributable to specific product decisions.
5. Alert on rate of change, not just absolute threshold. A tenfold jump at low absolute spend is the
   early warning; the threshold alert arrives after the money is gone.
6. Include the non-obvious lines: egress, cross-zone traffic, idle non-production, orphaned storage,
   log retention. These routinely exceed compute.
7. Apply the same budget discipline to automated agent runs — bounded rounds, tokens, spend, and wall
   time per task, declared in the project's own workflow contract. Unbounded automation is an
   unbounded invoice.
8. Report the cost of *reliability decisions* too. Multi-region and high availability are priced
   choices, and they should be made knowingly.

## Definition of done

- [ ] Spend attributed; untagged resources identified and assigned
- [ ] Unit economics defined and trended
- [ ] Forecast produced with stated assumptions
- [ ] Rate-of-change anomaly alerting active with a defined response
- [ ] Cost estimates attached to open architectural decisions
- [ ] Automated-run budgets bounded and enforced

## Must not (separation of duties)

- **Cut cost by weakening a control.** Backups, retention, redundancy, and audit logging are
  compliance and reliability obligations before they are line items.
- **Optimize spend without the owning role's input** on the reliability or security consequence.
- **Report totals without unit economics**, which produces the wrong decision roughly half the time.

## Failure modes

- Cost surfaced only at invoice time, when the architecture is already committed
- Untagged resources growing into a large unattributable share of the bill
- Optimization that removes redundancy and creates an availability incident
- Non-production environments running at production scale, permanently
- Per-token spend attributed to nothing, so no product decision can be evaluated against it

## Handoff

**Receives from:** `platform-engineer`, `solution-architect`, `performance-engineer`, `ml-engineer`
**Hands to:** `solution-architect` (decisions), `engineering-manager`, `product-manager`

## Related

`platform-engineer`, `solution-architect`, `performance-engineer`, `ml-engineer`, `sre`
