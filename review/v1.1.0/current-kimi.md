# Release review receipt: current-kimi

**Run ID:** current-kimi
**Actor:** Kimi Code 0.39.1
**Lane:** kimi
**Result:** PASS_WITH_FINDINGS
**Subject:** 32c12aa8d53ef56af4a48edd1eb457f6f75abf593830eb1fbc00f93f0867512e — staged public-release candidate
**Invocation:** Six-call resolution review over the delta from Kimi's exact 638a approval

## Findings and disposition

Approved with no defects found. Kimi verified the README's release-exception, legal, and count
changes; exact documented platform invocations and aggregate diagnostics; header-derived anchored
roles; and the two-layer provenance record. The subject digest matched the declared `SUBJECT.md`
value, but Kimi did not independently reproduce its repository-specific canonicalization within the
six-call limit. Outer pre/post verification kept the digest unchanged.

## Coverage limits

Targeted read-only inspection only; no project scripts, tests, builds, installers, edits, or
subagents. The validator's waiver and Codex-token lines fell beyond a capped grep view and were
covered independently by Codex, Claude, and the deterministic gates. A private CLI resume reference
is intentionally omitted.
