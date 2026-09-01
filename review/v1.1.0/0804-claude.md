# Release review receipt: 0804-claude

**Run ID:** 0804-claude
**Actor:** Claude Code
**Lane:** claude
**Result:** FAIL
**Subject:** 0804327394cf60b2167c595c70cd792af5f68da493ccdda47f67ec9cc43b8275 — staged public-release candidate
**Invocation:** Direct public-candidate review

## Findings and disposition

Revision required: adapter fixtures could invoke the real Claude registry before stubbing, and PR validation required final release receipts too early. Raw report SHA-256: c5cb893d61999387673f1537f9237afe6a088b6446c7c737ef2af187e691390d.

## Coverage limits

Read-only review; superseded candidate.
