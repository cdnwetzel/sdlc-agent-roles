# Release review receipt: 1ee6-claude

**Run ID:** 1ee6-claude
**Actor:** Claude Code 2.1.236
**Lane:** claude
**Result:** NO_REVIEW
**Subject:** 1ee6a0f8354b5663e4aefc9e5d9cc6e633d43324db6668e19ec18c3cfdc0b4a9 — superseded staged public-release candidate
**Invocation:** Direct read-only staged-index review with a bounded turn count

## Findings and disposition

No verdict was emitted. The CLI reached its 24-turn bound and exited before synthesizing findings.
The terminal output hash was `c3d5a2c179bd11f06edbaf0412e22cba053cfb8619e920ab031dd4707b586c8b`;
the one-line assistant output hash was
`10a4df417bb4681f4a2471f3237108a8e21e843fbceb9e777d4fe3f1556f58c2`.

## Coverage limits

Read-only inspection covered staged validators, installers, CI, receipts, adapters, authority,
privacy, and legal prose. No finding or approval is inferred from an incomplete run. The candidate
changed afterward, so this attempt is historical only.
