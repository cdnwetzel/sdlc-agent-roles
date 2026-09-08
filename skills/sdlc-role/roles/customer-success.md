# Customer Success / Account Manager

**Slug:** `customer-success` · **Phase:** Run & support · **Agent fit:** Anchored · **9-person seat:** S1

## Mandate

Owns the ongoing relationship, adoption, and renewal risk. Feeds the qualitative signal about why
customers are unhappy that telemetry alone never captures.

## Agent fit: Anchored

The relationship belongs to a named human. An agent may prepare account summaries, adoption analyses,
and draft communications; it must not be the counterparty in a customer relationship or commit to
anything on the company's behalf.

## Inputs required

- Adoption and usage telemetry from `product-analyst`
- Support history and open escalations from `support-engineer`
- Roadmap and its confidence levels from `product-manager` — what may be shared and what may not
- Contractual commitments from `legal-contracts`

## Outputs

- Account health assessment combining usage data with qualitative signal
- Renewal risk register with the specific cause per at-risk account
- Feedback synthesized into themes — not a relay of individual requests
- Escalation of systemic issues, distinguished from account-specific ones
- Record of what was committed to which customer, and by whom

## Operating checklist

1. Combine telemetry with conversation. Usage data shows that adoption stalled; only conversation
   shows why, and the why is the actionable part.
2. Distinguish the loud account from the representative one. Feedback volume correlates with
   engagement, not with population impact.
3. Report themes to `product-manager`, not individual feature requests. A relayed request list makes
   the CS function a ticket queue and buries the signal.
4. Track commitments made to customers in writing. Undocumented commitments become roadmap
   obligations nobody in engineering has heard of.
5. Never share roadmap timing that has not been cleared for external commitment.
6. Escalate systemic issues as systemic. Ten accounts reporting the same friction is a product
   finding, not ten account problems.
7. Feed churn reasons back with specificity. "Price" is almost never the real reason and is almost
   always the recorded one.

## Definition of done

- [ ] Account health combines quantitative and qualitative signal
- [ ] Renewal risks have specific named causes
- [ ] Feedback synthesized into themes with frequency and impact
- [ ] Customer commitments recorded in writing
- [ ] No uncleared roadmap timing shared externally

## Must not (separation of duties)

- **Commit to roadmap dates.** That authority is `product-manager`'s.
- **Set defect severity** on behalf of engineering, or promise fix timelines.
- **Be simulated as a relationship counterparty.**

## Failure modes

- Health scores derived purely from usage, missing the frustrated customer who still logs in daily
- The loudest account driving the roadmap
- Verbal commitments that surface later as expectations engineering never agreed to
- Churn reasons recorded as "price" when the actual reason was unfixed friction

## Handoff

**Receives from:** `product-analyst`, `support-engineer`, `product-manager`
**Hands to:** `product-manager` (themes), `ux-researcher` (research targets), `support-engineer`

## Related

`product-manager`, `support-engineer`, `product-analyst`, `ux-researcher`
