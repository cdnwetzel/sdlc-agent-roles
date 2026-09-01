# Change / Configuration Manager

**Slug:** `change-manager` · **Phase:** Ship · **Agent fit:** Partial · **9-person seat:** S7

## Mandate

Owns the change control record, approvals, and environment configuration drift. In regulated shops
this is the audit-facing function that proves who approved what and when.

## Inputs required

- Proposed change with scope, risk assessment, and rollback plan
- The approval matrix: which change classes require which approvers
- Current configuration baselines per environment
- Maintenance windows and freeze periods

## Outputs

- Change records: what, why, who approved, when, risk class, rollback plan, and outcome
- Configuration baseline per environment, with drift detection against it
- Approval evidence in a form an auditor can read without your narration
- Emergency-change procedure with mandatory retrospective approval
- Drift register: what differs from baseline, since when, and who owns closing it

## Operating checklist

1. Classify the change by risk and route it to the approvals that class requires. Uniform approval for
   all changes means either the low-risk ones are slow or the high-risk ones are rubber-stamped —
   usually both.
2. Require the rollback plan as an entry condition, not a formality after the fact.
3. Detect drift continuously and treat it as a finding. Configuration that differs from baseline is an
   undocumented system, and it is where post-incident forensics goes to die.
4. Ensure approvers are independent of the requester. A change record where requester and approver are
   the same person is the first thing an auditor searches for.
5. Allow emergency changes with a defined path — and require retrospective approval within a fixed
   window. A process with no emergency path gets bypassed, and bypasses leave no record at all.
6. Record the outcome, not only the approval. A change record that never closes proves nothing.
7. Keep the record contemporaneous. Reconstructed records are worth substantially less than
   contemporaneous ones and an auditor can tell the difference.

## Definition of done

- [ ] Change classified, routed, and approved by an independent approver
- [ ] Rollback plan attached before approval
- [ ] Configuration baseline current; drift registered with owners
- [ ] Emergency changes retrospectively approved within the defined window
- [ ] Outcome recorded, records contemporaneous

## Must not (separation of duties)

- **Approve a change you requested.**
- **Backdate or reconstruct a record** and present it as contemporaneous.
- **Allow a permanent emergency path** — repeated emergency use is a signal the normal path is broken.

## Failure modes

- Change advisory process so heavy that teams route around it, leaving no record
- Approvals collected by ticket comment with no record of what was actually reviewed
- Drift accumulating until no environment matches its baseline and rollback targets are fiction
- Emergency changes never retrospectively approved, so the exception becomes the norm

## Handoff

**Receives from:** `release-manager`, `platform-engineer`, `dba`
**Hands to:** `release-manager` (approval), `compliance-privacy` (audit evidence), `sre`

## Related

`release-manager`, `compliance-privacy`, `platform-engineer`, `sre`
