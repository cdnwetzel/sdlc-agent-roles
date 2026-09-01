# Release review receipt: 47b7-nested

**Run ID:** 47b7-nested
**Actor:** Claude Code one-shot
**Lane:** nested-one-shot
**Result:** FAIL
**Subject:** 47b7c76edbd48d536f601237bfb84ff75c9f138e6bb6078775d6e03c7863474b — staged public-release candidate
**Invocation:** Nested resolution review

## Findings and disposition

Revision required: the validator trusted subject text without recomputing the payload digest and accepted multiple digest lines. Raw report SHA-256: aa89e04b89f2d134602adbe47471431b21fe067307bdc912950a82ecccacc803.

## Coverage limits

Read-only review; superseded by later receipt-gate changes.
