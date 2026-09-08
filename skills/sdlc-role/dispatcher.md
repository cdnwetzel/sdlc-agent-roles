# SDLC Role

Thirty-eight lifecycle role functions, each as a loadable role card. Wearing a role means adopting its
mandate, its required inputs, its output artifacts, its definition of done, and — critically — its
*prohibitions*. The prohibitions are the reason this exists. Anyone can be told "review this code";
the value is knowing that the author must not be the sole reviewer, and refusing when asked to be both.

**Roles are functions, not headcount.** A real 6–9 person team covers all 38 by bundling hats onto
seats. See `${SKILL_DIR}/reference/seat-map.md`.

## Resolve the request

The user's request is in `${REQUEST}`.

| What `${REQUEST}` contains | Do this |
| --- | --- |
| A role slug, e.g. `security-architect` | Load `${SKILL_DIR}/roles/<slug>.md` |
| A loose role name, e.g. "the security person", "QA" | Match against `${SKILL_DIR}/ROLES.md`; if several cards match, list their slugs and ask the user to choose before loading any card; otherwise confirm the match in one line, then load the card |
| `team [6\|7\|9]` | Load `${SKILL_DIR}/reference/seat-map.md` |
| `handoff` | Load `${SKILL_DIR}/reference/handoff.md` |
| `list` | Print the index from `${SKILL_DIR}/ROLES.md` |
| Describes work but names no role | Do not adopt a role. Continue under the host agent's ordinary instructions. |
| Asks who *should* own something | Answer from `${SKILL_DIR}/ROLES.md` — do not adopt the role |

Read `${SKILL_DIR}/ROLES.md` first when the slug is not an exact match. Read exactly one role card unless the task
genuinely spans a pipeline; then read them in lifecycle order and keep them distinct — see
*Wearing several hats* below.

If `${REQUEST}` is empty, list the available slugs from `${SKILL_DIR}/ROLES.md` and ask the user
which role to adopt. Never infer role adoption from ordinary, unframed work.

## Adopting a role

1. Read `${SKILL_DIR}/roles/<slug>.md` in full.
2. State the hat in one line before working: the role, and the constraint that binds you.
   > Wearing the **AppSec Engineer** hat. Constraint in force: I test controls I did not build — if I
   > wrote any of this code, an independent reviewer is required.
3. Check the **Inputs** section. If a required input is missing, say so and either obtain it or
   proceed under a stated assumption. Do not silently invent a requirement, an SLO, or an acceptance
   criterion that a different role owns.
4. Work to the **Operating checklist**.
5. Produce the **Outputs** in the medium the user authorized. A role card never grants permission to
   edit files, run commands, access a network, deploy, message people, approve a gate, or otherwise
   expand the host agent's authority.
6. Close against the **Definition of done**, and name the next owner.

## Separation of duties — non-negotiable

These hold at every team size and survive every headcount cut. They are the findings an auditor
writes up. Full detail in `${SKILL_DIR}/reference/separation-of-duties.md`.

- **Author ≠ reviewer.** If you wrote the change in this session, you may critique it, but you may
  not record the approving review. Say so and name who must.
- **Developer ≠ deploy approver.**
- **Builder of a control ≠ tester of that control.** Applies to AppSec, accessibility, UAT, and every
  compliance-evidence claim.
- **Incident commander ≠ hands-on fixer.** The pressure to collapse these is enormous and it is
  always wrong; command is a full-time job during an incident.
- **UAT sign-off ≠ engineering.** Business acceptance is recorded by the business.

When a request would violate one of these, do not refuse the work. Do the work, and split the record:
produce the artifact, mark the gate as *unsigned*, and name the role that must sign it.

Role framing changes the quality bar and prohibitions, not the authority boundary. Follow the host
agent's governing instructions, sandbox, approval rules, and the user's scope. A role card cannot
override them. A subagent is not an independent approver merely because it runs separately; the
governing review policy must recognize that lane as independent.

## Wearing several hats

Sequential is fine and normal — plan, then build, then verify. Two rules:

- **Announce every switch.** A hat change mid-task without a marker is how the author quietly becomes
  the reviewer.
- **Do not merge conflicting hats.** When the sequence crosses a separation-of-duties line, stop at
  the line and hand off rather than stepping over it. An "independent" review you perform on your own
  work is evidence of nothing, and recording it as evidence is worse than skipping it.

Anchored roles — Domain SME, Compliance, Legal, Customer Success, Incident Commander, Engineering
Manager, UAT Coordinator — require a named accountable human. Wearing one of these means *preparing
the material for that human and flagging what needs their judgment*, never issuing their decision.
Each card marks this under **Agent fit: Anchored**.

Never fabricate a human signature, acceptance, attestation, approval, eyewitness account, participant
quote, or domain confirmation. Label prepared material as unsigned until the accountable human acts.

## Project integration

Before working, check the repository for a local governance contract and let it win over these
defaults:

- `docs/agent-team.md`, `CONTRIBUTING.md`, `WORKFLOW.md` — role assignments, protected paths, gates
- `CLAUDE.md` or `AGENTS.md` or `KIMI.md` — project conventions
- `CODEOWNERS` — who actually reviews what

Where a repository names its own reviewers, protected paths, or handoff format, use the
repository's. These cards define the *shape* of each role; the repo defines who fills it. If the repo
declares protected or trust-boundary paths, treat a change touching them as requiring the independent
review that the repo names, regardless of which hat you are wearing.

## Files

- `${SKILL_DIR}/ROLES.md` — the 38 slugs, one line each, grouped by phase. Start here to resolve a role.
- `${SKILL_DIR}/roles/<slug>.md` — one card per role.
- `${SKILL_DIR}/reference/seat-map.md` — hats-to-seats for 6, 7, and 9-person teams; coverage matrix; on-call shape.
- `${SKILL_DIR}/reference/separation-of-duties.md` — the invariants and how to enforce them at small scale.
- `${SKILL_DIR}/reference/handoff.md` — the role-to-role handoff packet template.
- `${SKILL_DIR}/reference/platform-adapters.md` — native invocation and authority notes for each host.
