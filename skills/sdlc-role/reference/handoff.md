# Handoff packet

A role's output is an artifact plus a handoff. The handoff is what makes the next role able to act
without re-deriving your context, and what makes the work auditable later.

The governing principle: **a prose claim is not sufficient when command output or a machine-readable
result can be supplied.** "Tests pass" is an assertion; the captured output of the test command is
evidence.

## Task admission — before work starts

The reciprocal of a handoff. `tech-lead` (or whoever assigns) records these seven before any writing
begins. Work admitted without them produces handoffs nobody can verify.

1. Roadmap item or issue
2. Objective and explicit **non-goals**
3. Base commit
4. Allowed paths and prohibited paths
5. Dependencies and interface assumptions
6. Required tests and acceptance evidence
7. Reviewer and escalation owner

Do not assign overlapping write scopes concurrently. Where overlap is unavoidable, serialize behind a
reviewed interface commit.

## Implementation handoff

```markdown
## Handoff — <task>

**Author:** <role / person / agent>
**Task:** <issue or roadmap item>
**Branch:** <branch>   **Base:** <commit>   **Candidate:** <commit>
**Next owner:** <revise | review | integrate | decide> — <who>

### Scope
Paths changed: <list>
Assigned scope respected: <yes / no + explanation>
Unrelated changes: <none / list>

### Delivered
- <behavior delivered>

### Deliberately not delivered
- <behavior out of scope, and why>

### Evidence
| Check | Command | Result |
| --- | --- | --- |
| Test | `<cmd>` | <output summary + pass/fail> |
| Lint | `<cmd>` | ... |
| Format | `<cmd>` | ... |
| Build | `<cmd>` | ... |

<paste or link the actual output>

### Security
Trust boundaries touched: <none / list>
Fail-closed behavior preserved: <yes / no + where>
Independent security review required: <yes / no>
Secrets or personal data in diff, fixtures, or logs: <checked — none / findings>

### Risks and open questions
- <risk, and who owns deciding>
```

## Gate handoff — verify and ship roles

Used by `code-reviewer`, `qa-analyst`, `appsec-engineer`, `accessibility-specialist`,
`performance-engineer`, `uat-coordinator`, `release-manager`.

```markdown
## Gate — <gate name>

**Performed by:** <role / person>
**Independent of author:** <yes / no — if no, this gate is UNSIGNED>
**Subject:** <commit / build / release candidate>

### Result
<pass | fail | pass with findings | UNSIGNED — requires <role>>

### Covered
- <what was actually exercised>

### NOT covered
- <what was not — state this explicitly; silence reads as coverage>

### Findings
| ID | Severity | Location | Failure scenario | Blocking |
| --- | --- | --- | --- | --- |

### Waivers
| Gate | Reason | Approver | Expires |
| --- | --- | --- | --- |
```

An empty **NOT covered** section is almost always wrong. Untested is untested, and converting an
absence of evidence into a pass is the most common way a gate stops meaning anything.

## Role-switch marker

When one worker moves between hats in a single stretch of work, mark it. This is what keeps the
author from quietly becoming the reviewer.

```markdown
--- ROLE SWITCH ---
Was: <role>  →  Now: <role>
Constraint in force: <the separation-of-duties rule that now applies>
Carried forward: <what the previous role produced>
Cannot self-satisfy: <any gate this switch does NOT satisfy, and who must>
```

## Escalation

```markdown
## Escalation

**From:** <role>   **To:** <role / named human>
**Decision needed:** <the actual question, phrased so it can be answered yes/no or A/B>
**Needed by:** <date> — **because:** <what blocks or what the cost of delay is>
**Options:** <A / B / C, with consequences>
**Recommendation:** <yours, and your confidence>
**What I could not determine:** <explicit>
```

Escalations without a stated decision, a date, and a recommendation get read last and answered late.
