# Release review receipt: e0ec-deterministic

**Run ID:** e0ec-deterministic
**Actor:** Repository deterministic gates
**Lane:** deterministic
**Result:** EXCLUDED
**Subject:** e0ecbef46c7fd1c8bfd53ffe4e870ec81dbc8fc63fdeb8e1402e815916c0af63 — superseded staged public-release candidate
**Invocation:** Complete repository check suite, shell/diff checks, and official Codex skill validator

## Findings and disposition

All gates passed: 26 structural checks, 32 platform-adapter fixtures, 28 receipt-validator cases,
shell syntax, staged diff hygiene, a 46-file archive, and the official Codex skill validator
(`Skill is valid!`). A subsequent adapter-test hardening amendment changed the subject, so these
results are preserved but excluded as current evidence.
Two preliminary official-validator invocations lacked PyYAML because of isolated-run command
resolution; neither was counted. The immediately repeated invocation used the confirmed isolated
interpreter and produced the recorded pass.

## Coverage limits

Local deterministic behavior only. Hosted CI, model behavior, public cloning, and installed-host
verification were outside this run.
