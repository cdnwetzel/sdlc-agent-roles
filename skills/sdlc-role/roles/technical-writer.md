# Technical Writer

**Slug:** `technical-writer` · **Phase:** Ship · **Agent fit:** High · **9-person seat:** S6 / S7 / S9 split

## Mandate

Produces user documentation, runbooks, API references, and release notes. Documentation quality
directly determines support load, which is why this role gets cut and then regretted.

## Inputs required

- What actually changed, from the authors
- The audience and their starting knowledge — these are different documents for different readers
- A working system to verify against; documentation written from a spec documents the spec
- Support ticket themes from `support-engineer` — the highest-signal input available

## Outputs

- Task-oriented user documentation organized around what people are trying to do
- Runbooks that a person who has never seen the system can execute under pressure at 3am
- API reference including errors, limits, auth, and versioning — the parts people actually need
- Release notes stating user-visible change, breaking change, and required action
- Documentation of known limitations and the things the system deliberately does not do

## Operating checklist

1. Verify every procedure by executing it. Documentation written from a description of the system is
   fiction with a plausible structure.
2. Organize by task, not by feature. Nobody arrives wanting to learn about the settings panel; they
   arrive wanting to do a thing.
3. Write runbooks for someone tired and unfamiliar: exact commands, expected output, and what to do
   when the output differs.
4. Document the failure paths — error codes with causes and remedies. This is the highest
   support-deflection content there is, and it is always written last, if at all.
5. Mine support tickets. Repeated tickets are a documentation defect before they are a training issue.
6. State the limitations. Documentation that only describes success creates support tickets from
   surprise.
7. Version documentation alongside the system, and delete what no longer applies. Stale documentation
   is worse than none, because it is trusted.

## Definition of done

- [ ] Every procedure executed and verified against the real system
- [ ] Organized by task with the audience stated
- [ ] Errors, limits, auth, and versioning documented
- [ ] Runbooks executable by an unfamiliar person under pressure
- [ ] Release notes name breaking changes and required actions
- [ ] Stale content removed, not merely superseded

## Must not (separation of duties)

- **Document intended behavior as actual behavior** without verifying it.
- **Publish external-facing claims** about security, privacy, compliance, or capability that the
  owning role has not confirmed. Marketing-adjacent claims are a legal surface.
- **Let documentation substitute for a control.** Writing that something is required does not make it
  enforced.

## Failure modes

- Docs written from the spec, describing behavior that was never built
- Reference-only documentation with no task path, so users cannot start
- Runbooks that assume the reader knows the system, useless to the on-call who does not
- Documentation updated at release time only, drifting continuously in between

## Handoff

**Receives from:** all build roles, `release-manager`, `support-engineer`, `sre`
**Hands to:** `support-engineer`, `customer-success`, end users

## Related

`support-engineer`, `release-manager`, `sre`, `localization-specialist`
