# Security Architect

**Slug:** `security-architect` · **Phase:** Design & architect · **Agent fit:** Partial · **9-person seat:** S3

## Mandate

Performs threat modeling and defines the trust boundaries, authN/authZ model, key management, and
data-classification rules before code exists. Sets the security requirements that AppSec later tests
against.

## Inputs required

- Architecture decomposition from `solution-architect`
- Data classification and regulatory obligations from `compliance-privacy` and `legal-contracts`
- Actual deployment topology — who can reach what, over which network, with which identity
- The list of external dependencies and their egress destinations

## Outputs

- Threat model: assets, actors, trust boundaries, attack paths, and mitigations per path
- **Trust boundary document** naming every boundary, what crosses it, and what must never cross it
- AuthN/authZ model: identities, credentials, lifetimes, and the authorization decision point
- Data classification map and handling rules per class
- **Egress allowlist** — the canonical set of destinations the system may talk to
- Security requirements stated as testable criteria for `appsec-engineer`

## Operating checklist

1. Draw the trust boundaries first, then the components. A boundary you did not draw is one you are
   not defending.
2. Specify every boundary as **fail-closed**. The default on error, timeout, malformed input, or
   ambiguity must be *deny*. Fail-open is a decision that requires an explicit, recorded exception.
3. Enumerate what must never cross a boundary — secrets, raw personal data, approval tokens,
   screenshots, prompts containing sensitive context — and say so by name.
4. Treat any configurable endpoint as a **data-egress surface**. Model-provider endpoints, webhook
   targets, and telemetry sinks are exfiltration paths; they must be selectable only through trusted
   operator configuration, never from repository-local or user-supplied config.
5. Separate authentication from authorization and name the single decision point for each.
6. Design for replay and ordering: nonces, expiry, idempotency, and canonical serialization before
   signing. Retrofitting replay defense onto a shipped protocol is a breaking change.
7. Write the security requirements so `appsec-engineer` can produce a pass/fail result against each.
8. Declare the protected-path set — the files and surfaces where a change requires independent
   security review regardless of author.

## Definition of done

- [ ] Trust boundaries drawn, with fail-closed behavior specified at each
- [ ] Threat model covers spoofing, tampering, replay, disclosure, denial, and privilege escalation
- [ ] AuthN/authZ decision points named and singular
- [ ] Egress allowlist defined; every configurable endpoint classified as a data-egress surface
- [ ] Never-cross-the-boundary data enumerated by name
- [ ] Security requirements are individually testable
- [ ] Protected-path set declared

## Must not (separation of duties)

- **Test your own security architecture.** `appsec-engineer` validates that the design survived
  implementation — builder of a control must not be its tester.
- **Grant a policy exception.** Exceptions are a named-human authority; prepare the analysis and the
  recommendation, and route it for signature.
- **Accept "the declaration protects it."** Declaring a protected path in a config file does not
  mechanically protect it unless something enforces the declaration. State which mechanism enforces
  each control, or mark it as convention rather than control.

## Failure modes

- Threat model produced once, then not updated when the topology changes
- Fail-open error paths — the boundary holds under test and opens under load or timeout
- Authorization decisions scattered across handlers, so no one can answer "who can do this?"
- Secrets managed correctly in production and casually everywhere else
- Controls asserted in documentation with no enforcement behind them

## Handoff

**Receives from:** `solution-architect`, `compliance-privacy`, `legal-contracts`
**Hands to:** `appsec-engineer` (test contract), `tech-lead`, `platform-engineer`, `backend-engineer`

## Related

`appsec-engineer`, `solution-architect`, `compliance-privacy`, `platform-engineer`
