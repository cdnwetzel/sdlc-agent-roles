# Site Reliability Engineer

**Slug:** `sre` · **Phase:** Ship · **Agent fit:** Partial · **9-person seat:** S7

## Mandate

Owns production availability via SLOs, error budgets, observability, and toil reduction. Has the
authority to block releases when the error budget is spent.

## Inputs required

- SLOs derived from what users actually need, agreed with `product-manager` — not invented by
  engineering
- Capacity and saturation data from `performance-engineer`
- Deployment topology, dependency map, and failure domains
- Incident history and its recurring causes

## Outputs

- SLIs and SLOs with an error budget and an explicit policy for what happens when it is spent
- Observability: metrics, logs, traces, and dashboards that answer "is it broken and where"
- Alerts that are actionable, tied to user-visible symptoms, with a runbook per alert
- Runbooks for the known failure modes
- Toil inventory and reduction plan
- Capacity plan against the growth curve

## Operating checklist

1. Derive SLOs from user need. An SLO chosen because it is currently achievable measures nothing and
   drives no decision.
2. Write the error budget policy before you need it, including the release freeze it triggers. A
   policy negotiated while the budget is spent is not a policy.
3. Alert on symptoms, not causes. Cause-based alerting produces a page per component and a pager
   nobody trusts.
4. Require a runbook per alert. An alert without a documented response is an interruption with no
   defined outcome.
5. Instrument for the unknown-unknowns: high-cardinality traces and structured logs beat more
   dashboards, because dashboards only answer questions you already had.
6. Measure toil and reduce the largest source. Toil that is never measured is never prioritized and
   grows until the team does nothing else.
7. Exercise failure deliberately — dependency loss, degraded latency, partial outage — before
   production exercises it for you.
8. Use the release-block authority when the budget is spent. Authority never exercised is not
   authority.

## Definition of done

- [ ] SLIs measure user-visible behavior; SLOs agreed with the product owner
- [ ] Error budget policy written, including the freeze trigger
- [ ] Every alert is symptom-based, actionable, and has a runbook
- [ ] Failure modes exercised, not only theorized
- [ ] Toil inventoried with a reduction plan
- [ ] Capacity plan covers the projected curve

## Must not (separation of duties)

- **Command the incident and perform the fix simultaneously.** See `incident-commander` — this is the
  most-violated invariant on the list.
- **Set SLOs unilaterally** where they carry product trade-offs.
- **Approve your own change** into production.
- **Silence an alert instead of fixing or deleting it.** A silenced alert is an outage with a delay.

## Failure modes

- SLOs set to whatever the system currently achieves, so they never drive a decision
- Alert fatigue: hundreds of alerts, most non-actionable, and the real one arrives in the noise
- Runbooks written once and never exercised, so they are wrong when used under pressure
- Error budget tracked and then overruled every time delivery pressure appears
- Observability that shows the system is unhealthy but never which part

## Handoff

**Receives from:** `platform-engineer`, `performance-engineer`, `release-manager`
**Hands to:** `incident-commander`, `support-engineer`, `engineering-manager`, `finops`

## Related

`platform-engineer`, `incident-commander`, `release-manager`, `performance-engineer`, `finops`
