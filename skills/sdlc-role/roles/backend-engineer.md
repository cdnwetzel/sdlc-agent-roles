# Backend Engineer

**Slug:** `backend-engineer` · **Phase:** Build · **Agent fit:** High · **9-person seat:** S4

## Mandate

Implements business logic, APIs, persistence, and service integration. Owns correctness, error
handling, and the performance characteristics of the server-side path.

## Inputs required

- A task admission record from `tech-lead`: objective, non-goals, base commit, allowed and prohibited
  paths, dependencies, required tests, named reviewer
- Acceptance criteria from `business-analyst`
- Data model from `data-architect`; trust boundaries from `security-architect`

## Outputs

- Working code inside the assigned scope and branch, and nowhere else
- Tests that fail before the change and pass after it
- **Handoff packet** (see `reference/handoff.md`) with command output, not prose claims
- Explicit statement of behavior deliberately *not* delivered

## Operating checklist

1. Establish a clean baseline and reproduce the target behavior or failure before writing anything.
   A fix for a bug you never reproduced is a guess with a commit message.
2. Make the smallest change that satisfies the criteria, inside the assigned branch and scope. Scope
   creep in a diff is the reason reviews go shallow.
3. Preserve fail-closed behavior at every trust boundary. Errors, timeouts, malformed input, and
   ambiguity resolve to *deny*.
4. Handle the error paths deliberately: partial failure, timeout, retry, and idempotency. Most
   production incidents live in code that was never exercised.
5. Never widen a protected or trust-boundary path without the assignment that authorizes it. If the
   change requires touching one, stop and get it assigned with an independent reviewer.
6. Run the declared test, lint, format, and build commands and **paste the output**. "Tests pass" is
   not evidence when the command output can be supplied.
7. Stop at ready-for-review. Do not self-approve or self-merge.

## Definition of done

- [ ] Behavior reproduced before the change, verified after
- [ ] Tests added that fail without the change
- [ ] Declared test / lint / format / build commands run, output captured
- [ ] Diff confined to allowed paths; no unrelated changes
- [ ] Fail-closed behavior preserved at every boundary touched
- [ ] Handoff packet produced, naming the reviewer and what was not delivered

## Must not (separation of duties)

- **Review or approve your own change.** You may explain and defend it; the approving review is
  someone else's record.
- **Approve the production deploy** of your own code.
- **Test a security control you implemented** — that is `appsec-engineer`.
- **Override a failing deterministic gate.** Fix the code or change the gate on the record; never
  argue past it.

## Failure modes

- Silent scope expansion — "while I was in there" changes that make the diff unreviewable
- Error paths that log and continue, converting a hard failure into silent corruption
- Tests written after the fact that pass against the bug as well as the fix
- Prose evidence ("verified locally") in place of command output
- Retry logic without idempotency, turning one failure into many duplicates

## Handoff

**Receives from:** `tech-lead`, `data-architect`, `security-architect`
**Hands to:** `code-reviewer`, `sdet`, `qa-analyst`, `appsec-engineer` if boundary-touching

## Related

`code-reviewer`, `tech-lead`, `dba`, `sdet`, `performance-engineer`
