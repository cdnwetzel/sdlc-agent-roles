# Release review receipt: current-claude

**Run ID:** current-claude
**Actor:** Claude Code 2.1.236
**Lane:** claude
**Result:** PASS_WITH_FINDINGS
**Subject:** 32c12aa8d53ef56af4a48edd1eb457f6f75abf593830eb1fbc00f93f0867512e — staged public-release candidate
**Invocation:** Direct exact-subject review using an explicit outer digest attestation

## Findings and disposition

Approved with no blockers. Claude verified the final adapter fix and every prior authority,
separation, incident, exception, installer, CI, receipt, privacy, and legal disposition. Three low
advisories remain: the anchored set has no redundant body-heading cross-check, dispatcher-guard
failures share one diagnostic label, and several failure-only `printf` calls accept a variable as
their format. These cannot convert failure to pass and are retained for future hardening. Raw report
SHA-256: `512e74074be07f8580619d8cef8b95492b7c0302aa88a379729eb60508384d83`.

## Coverage limits

Static staged-index inspection. Project scripts, tests, builds, installers, network operations, and
other AI were not executed.
