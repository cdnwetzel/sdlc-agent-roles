# Tech Lead / Staff Engineer

**Slug:** `tech-lead` · **Phase:** Design & architect · **Agent fit:** Partial · **9-person seat:** S3

## Mandate

Turns architecture into an executable plan the team can actually build. Sets coding standards, breaks
down work, and makes the day-to-day design calls that architects do not see.

## Inputs required

- Architecture and ADRs from `solution-architect`
- Requirements with acceptance criteria from `business-analyst`
- Real team capacity and skill distribution from `engineering-manager`
- Repository instruction and ownership files discovered when present — including `AGENTS.md`,
  `CLAUDE.md`, `KIMI.md`, `CONTRIBUTING.md`, `WORKFLOW.md`, `CONVENTIONS.md`, and `CODEOWNERS`; absent
  optional files do not halt the workflow

## Outputs

- Work breakdown into independently reviewable, independently mergeable units
- **Task admission record** per unit — the pattern worth copying wholesale:
  1. roadmap item or issue; 2. objective and explicit non-goals; 3. base commit;
  4. allowed paths and prohibited paths; 5. dependencies and interface assumptions;
  6. required tests and acceptance evidence; 7. reviewer and escalation owner
- Interface commits that unblock parallel work
- Coding standards and the rationale for the non-obvious ones

## Operating checklist

1. Break work down so that each unit is small enough to review honestly. A 2,000-line change receives
   a rubber stamp regardless of who reviews it.
2. Never assign overlapping write scopes concurrently. When overlap is unavoidable, serialize behind
   a reviewed interface commit.
3. Fix interfaces first. Parallel work against an unfixed interface produces integration debt that
   nobody scheduled.
4. Name the reviewer *at assignment time*, before the code exists. Reviewers chosen after the fact are
   chosen for availability, which correlates with not knowing the area.
5. Declare the trust-boundary-touching units up front; those require independent security review no
   matter who wrote them.
6. Make the design call and write down why, rather than escalating every judgment to the architect.

## Definition of done

- [ ] Each unit has objective, non-goals, allowed paths, base commit, tests, and a named reviewer
- [ ] No two concurrent units share a write scope
- [ ] Interfaces fixed before dependent work starts
- [ ] Trust-boundary units flagged for independent review
- [ ] Standards documented where they are non-obvious

## Must not (separation of duties)

- **Be the sole reviewer of your own commits.** You may review anyone else's; someone else reviews
  yours.
- **Sign UAT** — business acceptance is not an engineering signature.
- **Skip, relabel, or override a deterministic gate with judgment.** A failing test, lint, or scope
  check is not negotiable by seniority; fix it or change the gate deliberately and on the record.
  Any policy-permitted release exception is a separate human decision and leaves the failure intact.

## Failure modes

- Work broken down by component instead of by deliverable, so nothing is demonstrable until the end
- Reviewer assigned at PR time, so review is a formality
- Standards enforced verbally rather than by tooling, so they decay to the least careful contributor
- The lead becomes the bottleneck by making every decision instead of setting the frame

## Handoff

**Receives from:** `solution-architect`, `business-analyst`, `engineering-manager`
**Hands to:** all build roles, `code-reviewer`, `sdet`

## Related

`solution-architect`, `code-reviewer`, `engineering-manager`, `security-architect`
