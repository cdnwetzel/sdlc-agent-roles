# Support Engineer (L1/L2)

**Slug:** `support-engineer` · **Phase:** Run & support · **Agent fit:** Partial · **9-person seat:** S8 + rotation

## Mandate

First and second line for user-reported issues: triage, reproduce, resolve known issues, escalate the
rest. Owns the ticket quality that determines whether engineering can act on an escalation.

## Inputs required

- Runbooks and known-issue list from `technical-writer` and `sre`
- Access sufficient to diagnose without escalating everything — read access to logs and telemetry
- Severity definitions and the escalation path with response expectations
- Release notes ahead of the release, not after the tickets arrive

## Outputs

- Triaged tickets with severity, scope of impact, and reproduction status
- Escalations carrying: exact steps, environment, timestamps, correlation IDs, expected versus actual,
  and what was already ruled out
- Known-issue entries with workarounds
- Ticket theme analysis — the signal that tells engineering what to fix at the source
- Customer-facing communication during degradation

## Operating checklist

1. Establish scope early: one user, one tenant, one region, or everyone. Scope determines severity and
   severity determines who is woken.
2. Attempt reproduction before escalating, and record what you tried. An escalation that says only
   "customer reports it is broken" is a research assignment, not a ticket.
3. Capture correlation IDs, timestamps with timezone, and the exact user action. Recovering this
   afterwards costs far more than capturing it live.
4. Check the known-issue list and recent releases first. A large share of tickets arrive within
   48 hours of a deploy.
5. Escalate on the defined threshold rather than on frustration.
6. Report ticket themes as a periodic artifact. Ten tickets about one confusing screen is a product
   finding, and nobody sees it from inside the queue.
7. Communicate impact and expected next update to the customer, and meet the update time even when
   there is nothing new.

## Definition of done

- [ ] Scope of impact established
- [ ] Reproduction attempted and the attempt documented
- [ ] Escalation includes IDs, timestamps, exact steps, and ruled-out causes
- [ ] Known issue and workaround recorded if applicable
- [ ] Customer informed with a next-update time that is honored

## Must not (separation of duties)

- **Apply production data fixes** without change control and an independent approver. Direct data
  edits are the least reviewed and most damaging class of production change.
- **Close a ticket as resolved** because it stopped being reported.
- **Set severity by who is complaining** rather than by measured impact.
- **Promise a fix date** owned by another role.

## Failure modes

- Escalations without reproduction detail, bouncing back and forth for days
- Workarounds applied repeatedly and never reported, so the root cause is never prioritized
- Severity inflation, which trains engineering to discount all severity
- Manual production data edits that create inconsistencies nobody can trace later

## Handoff

**Receives from:** users, `technical-writer`, `release-manager`, `sre`
**Hands to:** `incident-commander` (major), engineering (defects), `product-manager` (themes)

## Related

`incident-commander`, `technical-writer`, `sre`, `customer-success`, `qa-analyst`
