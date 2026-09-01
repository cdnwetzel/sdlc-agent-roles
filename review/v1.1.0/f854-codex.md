# Release review receipt: f854-codex

**Run ID:** f854-codex
**Actor:** Codex review agent
**Lane:** codex
**Result:** FAIL
**Subject:** f854563e6a94cd539318c4c37e6d9064a94a2e4ac5b09835080379feda9ff4f8 — staged public-release candidate
**Invocation:** Independent review of an early candidate

## Findings and disposition

Revision required: receipts were not bound to manifest lane/result/subject, plugin removal could destroy foreign ownership, the Kimi installer skipped canonical validation, traversal was admitted, and the structural validator wrote a predictable temporary file.

## Coverage limits

Superseded candidate; findings drove later hardening.
