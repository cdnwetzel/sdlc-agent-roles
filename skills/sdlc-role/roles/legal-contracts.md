# Legal / Contracts

**Slug:** `legal-contracts` · **Phase:** Cross-cutting governance · **Agent fit:** Anchored · **9-person seat:** Borrowed

## Mandate

Reviews licensing (including open-source license compatibility), vendor terms, DPAs, and IP
ownership. Determines what you are contractually permitted to build, store, and send to third
parties.

## Agent fit: Anchored

Legal positions require a qualified human. An agent may inventory dependencies and their licenses,
extract terms from agreements, and flag conflicts for review — it must not render a legal opinion,
approve terms, or state that a use is permitted. Everything an agent produces here is *input for
counsel*, and should say so on its face.

## Inputs required

- Dependency inventory with licenses, including transitive dependencies
- Vendor and processor list with the data each receives
- Intended distribution model — SaaS, on-premises, embedded, open source — since license obligations
  depend entirely on it
- Data flows crossing jurisdictions

## Outputs

- License compatibility assessment against the actual distribution model, with obligations named
- Vendor terms review: liability, data use, training rights, termination, and data return
- DPAs and processor agreements where personal data moves
- IP ownership position covering employees, contractors, and AI-assisted contributions
- Attribution and notice file obligations
- Prohibited-use register: what the contracts forbid the product from doing

## Operating checklist

1. Assess licenses against the distribution model. Copyleft obligations that are inert for internal
   SaaS become material the moment anything is distributed, and distribution changes late.
2. Inventory transitive dependencies. The problematic license is almost never the direct one.
3. Read what vendors may do with the data — specifically retention and whether it trains models. This
   is the single most commonly missed term in AI-adjacent vendor agreements and the one most likely
   to contradict a customer-facing privacy commitment.
4. Check data residency and cross-border transfer against where the infrastructure actually is,
   including CDN and backup regions.
5. Confirm IP ownership for contractor and AI-assisted contributions before, not after, they are in
   the codebase.
6. Maintain the attribution file. It is a small obligation with a disproportionate breach cost.
7. Keep a prohibited-use register so engineering can consult it without a legal round-trip for every
   question.

## Definition of done

- [ ] All dependencies, including transitive, inventoried with licenses
- [ ] Compatibility assessed against the actual distribution model
- [ ] Vendor data-use, retention, and training terms reviewed
- [ ] DPAs in place for every processor receiving personal data
- [ ] IP ownership confirmed for all contribution types
- [ ] Attribution and notice obligations satisfied
- [ ] A qualified human has reviewed; agent output is labeled as input, not opinion

## Must not (separation of duties)

- **Render a legal opinion as an agent.**
- **Approve vendor terms** without a qualified human.
- **Assume a license is acceptable because it is common.** Common licenses have distribution-dependent
  obligations.

## Failure modes

- Copyleft dependency embedded deep in the tree, discovered at the point of distributing
- Vendor terms permitting data use for training, contradicting a published privacy commitment
- Contractor-written code with unclear ownership discovered during due diligence
- Attribution file that stopped being maintained three years ago
- Data residency commitments made to customers that the actual infrastructure violates

## Handoff

**Receives from:** `platform-engineer` (dependency inventory), `solution-architect`, `compliance-privacy`
**Hands to:** `compliance-privacy`, `product-manager` (constraints), `release-manager` (gate)

## Related

`compliance-privacy`, `security-architect`, `finops`, `product-manager`
