# Provenance and receipts

This repo ships in public. That means every structural choice, every piece of advice taken, and every
human override must be auditable. We keep receipts.

## What a receipt records

A receipt is a single file in `receipts/` that documents one agent run or one significant decision.
It is not a chat log; it is a concise record of:

- **What was done** — the task and the concrete changes.
- **Who did it** — the agent(s) and any human steering.
- **Advice given** — recommendations, warnings, or alternative approaches raised by the agent(s).
- **Advice taken or rejected** — which recommendations were accepted, which were overridden, and why.
- **Artistic strokes** — decisions that are the maintainer's own judgment, not agent advice.
- **Receipts nested inside the run** — if one agent invoked another (a one-shot skill call, a sub-agent,
  a tool invocation that runs its own prompt), that nested receipt is named and linked.
- **Validation** — how the result was verified.

## Scope

We keep receipts for:

- Every run by Claude, Kimi, Codex, or any other agent that mutates files or makes architectural
  recommendations.
- One-shot invocations from within another agent (e.g., a skill call, a sub-agent, a code-review pass).
- Human-driven commits or merges that override agent advice.

We do not keep receipts for:

- Pure read-only exploration that produces no change and no recommendation.
- Trivial typo fixes that carry no design weight, unless they reverse an earlier agent recommendation.

## File layout

```
receipts/
  TEMPLATE.md           # Copy this to start a new receipt.
  YYYY-MM-DD_agent-brief-description.md
```

Name receipts with the ISO date, the primary agent, and a one-line slug. If multiple agents
contributed in one run, list the primary or use `multi-agent`.

## Policy on advice and artistic strokes

Agents give advice. The maintainer owns the final shape. A receipt must make that boundary visible:

- If an agent recommended X and the maintainer chose X, say so.
- If an agent recommended X and the maintainer chose Y, say so and give the reason.
- If the maintainer chose Z with no agent recommendation, label it an **artistic stroke** and explain
  the intent.

No receipt should read as if an agent authored the repo. Agents are tools; the maintainer is the
author. The receipts prove it.
