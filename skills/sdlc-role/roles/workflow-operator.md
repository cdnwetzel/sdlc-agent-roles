# Workflow Operator

**Slug:** `workflow-operator` · **Phase:** Cross-cutting / desktop operation · **Agent fit:** Anchored · **9-person seat:** Operator console (human)

## Mandate

The named human accountable for what the desktop agent executes. Reviews the
stages the `workflow-stager` prepares, approves or rejects each against the exact
world-state it was bound to, and holds the only key that turns a proposal into an
authorized act. The stager prepares; this seat decides. No proposal becomes an
action without a signature produced here.

## Agent fit: Anchored

This seat is worn by a human, never by an agent — and the boundary is enforced by
key possession, not policy: no process on any fleet machine can reach the RL-010
signing material. The operator never delegates the signature, never approves a
stage they cannot see the effect of, and never approves a stage bound to a
world-state that has moved. An agent that could produce this approval would defeat
the entire point of the staging layer.

## Inputs required

- A `dx.staged_action.v1` **bundle** and its handoff record: `stage_id`,
  `bundle_hash`, `frame_hash`, `ledger_head`
- The **field-level preview** — what each parameter will actually be set to, not a
  summary
- The **current** ledger head and observed frame at decision time (to check the
  stage is not stale)
- The **bundle-level risk class** and the reasons it was assigned

## Outputs

- An **approval** or **rejection**, signed to the RL-010 standard, whose message
  covers exactly `stage_id + bundle_hash + payload_hash + frame_hash + signed_head
  + role` — a signature bound to one world-state
- On approval: a `SIGNED` ledger row (hashes only) authorizing the executor to
  replay the staged trajectory
- On rejection: a receipted verdict fed to `pxx improve triage` as a durable human
  decision

## Operating checklist

1. Re-verify the four bindings are current before signing: `ledger_head`,
   `frame_hash`, `payload_hash`, `bundle_hash`. Any moved → the stage is stale;
   send it back, do not sign it.
2. Review the field-level preview, not the risk summary. The summary is advisory;
   the diff is what executes.
3. Sign at most one world-state per signature. A signature is not a standing
   authorization for "this task, whenever."
4. Never approve a stage you drafted, wherever an invariant requires separation.
   At n=1, that is you-versus-your-past-self via the ledger and the four-question
   self-check — treat it with the same seriousness as two people.
5. A T3 stage is never approved through this path. It is hard-blocked; an
   exception is its own escalated, separately-signed decision.
6. When in doubt, the kill switch outranks every stage. Engage it and re-present.

## Definition of done

- [ ] Every approved execution bound to exactly one world-state, re-checked current
- [ ] The signature covers the full canonical message, not a subset
- [ ] Stale stages re-presented, never signed
- [ ] The field-level preview reviewed, not just the summary
- [ ] A named human (this seat) is accountable, and did not draft what they approved

## Must not (separation of duties)

- **Draft or stage** an action. Preparation is the `workflow-stager`'s mandate;
  the operator who also drafts has collapsed the separation the layer exists for.
- **Approve a stale stage** — one whose head, frame, or payload moved since staging.
- **Approve on the summary** without reviewing the field-level preview.
- **Delegate or cache the signing key** where any harness or agent could reach it
  (RL-010: no long-lived agent, keys held by their owner).
- **Downgrade a risk class or approve a T3** through the normal path.

## Failure modes

- **Rubber-stamping under fatigue** — the stager's low-acceptance alarm is this
  seat's warning too. A stream of near-identical approvals is the signature of a
  seat that stopped reading.
- **Approving the summary** — signing on the risk line without the diff, so the
  parameter that was wrong executes anyway.
- **Signing a stale stage** — skipping the freshness re-check, authorizing an act
  against a screen that has since changed (the TOCTOU the staleness rule exists to
  kill).
- **Key material within a harness's reach** — the one failure that makes every
  other control theater, because then the agent *can* mint the approval.

## Handoff

- **Receives from:** `workflow-stager` — a `dx.staged_action.v1` bundle and its
  four-value handoff record.
- **Hands to:** the executor, on approval, via a `SIGNED` ledger row bound to the
  current head. The ledger records `REVIEWED → SIGNED → EXECUTED`. On rejection,
  the stage returns to the trigger and may not be re-proposed without changed
  evidence.

## Related

- `workflow-stager` — prepares the stages this seat decides on (the pair is the
  separation of duties: builder of the proposal ≠ approver of it)
- `gatekeeper` — assigns the risk class this seat reviews
- `incident-commander` — owns the kill switch that outranks every approval
- `compliance-privacy` — owns the redaction and retention rules the evidence obeys
- The RL-010 signing ceremony and the `dx.staged_action.v1` bundle family
