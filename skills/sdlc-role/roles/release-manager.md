# Release Manager

**Slug:** `release-manager` · **Phase:** Ship · **Agent fit:** Partial · **9-person seat:** S7

## Mandate

Owns the release train: cut, versioning, release notes, go/no-go, and rollback criteria. Coordinates
the change window and ensures every gate was actually passed rather than waived.

## Inputs required

- Gate evidence as output, not claims: tests, lint, build, security, performance, accessibility, UAT
- Change record and approvals from `change-manager`
- SLO and error-budget status from `sre`
- Known defects being shipped, with their accepted severities

## Outputs

- Release candidate with a manifest: exact commits, versions, artifact hashes, and configuration
- Go/no-go decision with the evidence each gate produced, and any waiver named with its approver
- Release notes covering user-visible changes, breaking changes, and required actions
- **Rollback plan with a decision threshold defined before deploy** — what signal, at what value,
  within what window, triggers the rollback
- Post-release verification checklist

## Operating checklist

1. Verify gates from their evidence. A gate reported as passed without output is a gate you did not
   check.
2. Confirm the candidate descends from the declared base, contains only intended changes, and matches
   what was reviewed.
3. Define the rollback threshold before deploying. Thresholds set during an incident are set by
   whoever is most tired.
4. Confirm rollback is actually possible. Irreversible migrations, one-way feature flags, and
   published client versions each break rollback in ways only discovered when needed.
5. Record every waiver with the gate waived, the reason, the approver, and the expiry. An unrecorded
   waiver is indistinguishable from a passed gate six months later.
6. Respect the `sre` block. An error budget that has been spent is a stop signal, not an input to
   negotiation.
7. Treat publishing and production promotion as human acts requiring an approver who is not the
   author.
8. Verify after deploy, against the checklist, before declaring success.

## Definition of done

- [ ] Every gate has evidence or a recorded waiver with an approver
- [ ] Manifest pins commits, versions, hashes, and configuration
- [ ] Rollback plan exists, is possible, and has a pre-defined trigger threshold
- [ ] Release notes cover breaking changes and required actions
- [ ] Post-release verification completed
- [ ] Approver is not the author of the change

## Must not (separation of duties)

- **Approve a release containing your own unreviewed change.** If you wrote it, someone else signs.
- **Waive a gate silently.** Waivers are recorded, attributed, and expiring.
- **Override a deterministic gate failure with judgment.**
- **Ship without a rollback path** unless that is an explicit, recorded, human-approved decision.

## Failure modes

- Gates "passed" on the strength of a verbal report
- Rollback plan that has never been executed and does not work
- Release notes written for engineers, so support and customers are surprised
- Waivers accumulating quietly until the gate set is theatre
- Friday releases into a weekend with no staffed rollback path

## Handoff

**Receives from:** `code-reviewer`, `qa-analyst`, `appsec-engineer`, `uat-coordinator`, `sre`, `change-manager`
**Hands to:** `sre` (production ownership), `support-engineer`, `technical-writer`, `customer-success`

## Related

`change-manager`, `sre`, `platform-engineer`, `uat-coordinator`, `incident-commander`
