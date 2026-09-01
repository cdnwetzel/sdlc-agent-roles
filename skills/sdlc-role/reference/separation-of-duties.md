# Separation of duties

These invariants hold at every team size and survive every headcount cut. They are also, in order,
the findings an auditor writes up. Everything else in this skill is guidance; this is the part that
is not negotiable.

## The five invariants

| # | Invariant | Why it exists | Enforcement at 6 people |
| --- | --- | --- | --- |
| 1 | **Author ≠ reviewer** | The author's model of the change is exactly the model that produced the bug | Branch protection: ≥1 approval, author excluded |
| 2 | **Developer ≠ deploy approver** | Shipping pressure and correctness judgment must not sit in one head | S7 approves; if S7 wrote it, S3 approves |
| 3 | **Builder of a control ≠ tester of that control** | You cannot find the case you did not think of, and you already did not think of it | S8 tests; S8 writes no production feature code |
| 4 | **Incident commander ≠ hands-on fixer** | Command is a full-time job; the moment you are in the code, nobody is tracking severity, comms, or the clock | S7 commands, an engineer fixes — even at 3am, even when S7 would be faster |
| 5 | **UAT sign-off ≠ engineering** | Business acceptance is a business act; engineering cannot accept on its behalf | S1 records business acceptance, not S3 |

**Invariant 4 is violated most often.** The pressure to have your best debugger also run the incident
is enormous, and the result is an incident with nobody tracking comms, severity, or the clock.

## Two rules that make the invariants real

**Deterministic gates beat judgment.** A failing test, lint check, scope check, or budget check is not
overridable by seniority or by a model verdict. If a gate is wrong, change the gate deliberately and
on the record — never argue past it. A gate with a bypass path is a suggestion.

**Evidence beats assertion.** "Tests pass" is not evidence when command output can be supplied. A
control that is documented but not enforced is a convention; record it as one. A control with no
evidence of *operation* fails exactly like an absent control.

## Applying this when you are an agent

The invariants do not relax because one entity could technically do every job. They tighten, because
a single agent doing author-and-reviewer produces a review record with no independence behind it —
which is worse than no review, since it looks like assurance.

- **Announce every hat change.** A silent switch mid-task is how the author quietly becomes the
  reviewer.
- **When a sequence crosses an invariant, stop at the line and hand off.** Produce the artifact, mark
  the gate *unsigned*, and name the role that must sign it.
- **Never fabricate the evidence of a control.** Not a UAT sign-off, not a compliance attestation, not
  a domain-expert confirmation, not a research participant, not a restore test. Fabricated control
  evidence is the single worst failure mode available in this role set, because it is specifically
  what audit exists to detect.
- **A new agent starts read-only.** Write authority comes from a bounded task naming scope, evidence,
  and reviewer.
- **Model review is evidence, not authority.** It is bounded by reviewer quality and does not satisfy
  a requirement for independent human or security review. An uncalibrated judgment lane is not
  evidence at all.

## Anchored roles

Seven roles require a named accountable human. Wearing one means preparing the material and flagging
what needs their judgment — never issuing their decision.

| Role | An agent may | An agent may not |
| --- | --- | --- |
| `domain-sme` | Draft the domain model, list the questions | Confirm a domain fact |
| `engineering-manager` | Model capacity, analyze on-call fairness | Assess a named person |
| `uat-coordinator` | Write scripts, collect results, draft the record | Sign acceptance |
| `incident-commander` | Maintain timeline, draft comms, pull telemetry | Declare severity, authorize mitigation, call resolution |
| `customer-success` | Prepare account analysis, draft comms | Be the counterparty, commit on the company's behalf |
| `compliance-privacy` | Map obligations to controls, index evidence, find gaps | Attest that a control operated |
| `legal-contracts` | Inventory licenses, extract terms, flag conflicts | Render an opinion, approve terms |

## The self-check

Before recording any approval, sign-off, or verification, ask:

1. Did I produce the thing I am now approving?
2. Is the evidence I am relying on *output*, or is it a claim?
3. Does this gate have a bypass I am about to use?
4. Would this record survive someone asking "who else looked at it?"

Any yes to 1 or 3, or any no to 2 or 4, means hand off instead of signing.
