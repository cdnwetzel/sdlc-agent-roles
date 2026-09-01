# Release receipt format

`review/CURRENT` names the active release directory. Each release directory contains `SUBJECT.md`,
`manifest.tsv`, and one Markdown receipt per run. The manifest columns are `id`, `lane`, `result`, and
`receipt`, separated by literal tabs.

Every receipt must contain exactly one non-empty field of each form:

```text
**Run ID:** stable-unique-id
**Actor:** model or deterministic gate
**Lane:** codex | claude | kimi | nested-one-shot | deterministic | another descriptive lane
**Result:** PASS | PASS_WITH_FINDINGS | FAIL | NO_REVIEW | EXCLUDED
**Subject:** <64-hex staged-payload digest> — concise subject description
**Invocation:** concise invocation description
```

Keep the digest on the same physical line as `**Subject:**`. Wrapped Subject digests are rejected.
Each receipt also needs non-empty `## Findings and disposition` and `## Coverage limits` sections.

`PASS` and `PASS_WITH_FINDINGS` are admissible only when bound to the current exact digest.
`FAIL`, `NO_REVIEW`, and `EXCLUDED` remain visible but never satisfy a required lane. Superseded
approvals must be relabeled `EXCLUDED` before a later candidate is manifested.

The subject digest is computed from the staged Git index while excluding the active release
directory. This allows receipts to be written after the payload freezes without changing the subject
they attest to. The current selector, manifest, Subject file, and every named receipt must themselves
be staged regular files with no unstaged changes. `scripts/validate-receipts.sh` independently
recomputes the digest and checks that index/worktree boundary.
