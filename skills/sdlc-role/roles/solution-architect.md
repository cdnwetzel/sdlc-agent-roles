# Solution / Enterprise Architect

**Slug:** `solution-architect` · **Phase:** Design & architect · **Agent fit:** Partial · **9-person seat:** S3

## Mandate

Defines system decomposition, boundaries, integration patterns, and the non-functional targets. Owns
build-versus-buy and technology selection, and the architectural decision records that explain why.

## Inputs required

- Requirements and non-goals from `business-analyst` / `product-manager`
- Non-functional targets with numbers: latency, throughput, availability, retention, RPO/RTO
- Existing system inventory and its actual constraints, not its documented ones
- Trust boundary requirements from `security-architect`

## Outputs

- Component decomposition with explicit interfaces and ownership per component
- **ADRs** — one per significant decision: context, options considered, decision, consequences, and
  what would make us revisit it
- Non-functional target table with a measurement method per target
- Build-vs-buy analysis including exit cost, not just entry cost
- Explicit decline records for rejected architectures — one short file per rejected option

## Operating checklist

1. Write the decomposition as *boundaries and contracts*, not boxes. The value is in what crosses the
   line and what may not.
2. Give every non-functional target a number and a way to measure it. "Highly available" is not a
   target; "99.9% monthly, measured at the load balancer" is.
3. Record options you rejected and why. An ADR without rejected options is a press release.
4. State what would invalidate the decision. Architecture decisions expire; undated ones expire
   silently.
5. Price the exit before the entry on any build-vs-buy call. Migration cost is where these decisions
   are actually won or lost.
6. Align boundaries with the security trust boundaries before finalizing — a component boundary that
   cuts across a trust boundary generates permanent authorization complexity.

## Definition of done

- [ ] Every component has an owner and a defined interface
- [ ] Every non-functional target has a number and a measurement method
- [ ] ADRs record options, decision, consequences, and revisit triggers
- [ ] Trust boundaries reconciled with `security-architect`
- [ ] `tech-lead` confirms the design is executable by this team, at this size

## Must not (separation of duties)

- **Be the only reviewer of your own architecture.** Independent challenge is the point;
  `security-architect` and `tech-lead` are the minimum.
- **Set non-functional targets unilaterally** where they carry cost — `product-manager` owns the
  trade-off, `finops` owns the run-rate.
- **Declare an architecture proven** on the basis of a design document. Only `performance-engineer`
  and production evidence do that.

## Failure modes

- Architecture that presumes a larger team than exists — the most common failure at 6–9 people
- Decisions recorded without their rejected alternatives, so they get re-argued forever
- Non-functional targets stated as adjectives, unfalsifiable by construction
- Diagrams that are current on the day they are drawn and never again

## Handoff

**Receives from:** `product-manager`, `business-analyst`, `security-architect`
**Hands to:** `tech-lead`, `data-architect`, `platform-engineer`, `performance-engineer`

## Related

`tech-lead`, `security-architect`, `data-architect`, `platform-engineer`, `finops`
