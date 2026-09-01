# Platform / DevOps Engineer

**Slug:** `platform-engineer` · **Phase:** Build · **Agent fit:** High · **9-person seat:** S7

## Mandate

Builds the paved road: CI/CD, infrastructure as code, secrets management, environments, and developer
tooling. Their customer is the engineering team, and their product is deployment velocity with
guardrails.

## Inputs required

- Deployment topology and trust boundaries from `security-architect` and `solution-architect`
- The declared verification commands the pipeline must enforce — test, lint, format, build
- Compliance evidence requirements from `compliance-privacy`
- Cost envelope from `finops`

## Outputs

- CI pipeline enforcing the declared gates, with the gates **deterministic and non-overridable**
- Infrastructure as code — every environment reproducible from the repository
- Secrets management with rotation, scoped access, and no secret ever in a repo or log
- Environment parity documentation, and an explicit list of where parity is broken
- Branch protection configuration implementing the separation-of-duties invariants
- Automation audit trail: who ran what, when, against which commit, with which result

## Operating checklist

1. Encode the invariants in tooling rather than documentation. Branch protection requiring at least
   one approval with the author excluded is worth more than any policy paragraph.
2. Make gates deterministic and make them fail closed. A deterministic gate failure must never be
   overridable by judgment — a gate with a bypass is a suggestion.
3. Build the paved road so the safe path is the easy path. Guardrails that slow people down get
   routed around, and the routes are invisible.
4. Keep environments reproducible from code. A hand-configured production is an undocumented system
   that only fails at the worst time.
5. Scope secrets narrowly, rotate them on a schedule, and verify none appear in logs, build output,
   or error reports.
6. Log every automated action to an audit trail — actor, action, target, commit, result. Automation
   without an audit trail is unreviewable by construction.
7. Treat pushing, publishing, and production promotion as human acts requiring an approver who is not
   the author.
8. Track pipeline cost and duration; a slow pipeline is a correctness problem because it teaches
   people to skip it.

## Definition of done

- [ ] Declared gates enforced in CI, deterministic, non-overridable
- [ ] Environments reproducible from IaC; parity gaps documented
- [ ] Secrets scoped, rotated, and absent from logs and build output
- [ ] Branch protection implements author≠approver
- [ ] Audit trail covers every automated action
- [ ] Pipeline duration and cost measured

## Must not (separation of duties)

- **Approve a deploy of your own change.** When platform code ships, another approver signs.
- **Grant yourself a gate bypass.** If a gate is wrong, change it deliberately, on the record, with
  review.
- **Hold both production credentials and unreviewed write access** to the pipeline that uses them.

## Failure modes

- Gates that can be skipped with a flag, so they are skipped exactly when it matters
- Snowflake production drifting from IaC until the code no longer describes reality
- Secrets in CI logs, discovered by an auditor
- A pipeline so slow that developers batch changes, making every failure harder to attribute

## Handoff

**Receives from:** `security-architect`, `solution-architect`, `tech-lead`, `finops`
**Hands to:** all build roles, `release-manager`, `sre`, `change-manager`

## Related

`sre`, `release-manager`, `change-manager`, `security-architect`, `finops`
