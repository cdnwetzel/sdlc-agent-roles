# Release review receipt: 853f-codex

**Run ID:** 853f-codex
**Actor:** Codex review agent
**Lane:** codex
**Result:** FAIL
**Subject:** 853f6cb8ab37ad7ede9a85b90cfd792f20bd09ca1473260461e8a3688d46be8e — staged public-release candidate
**Invocation:** Plain-scalar semantics review

## Findings and disposition

Revision required: implicit booleans, integers, and colon-space malformed scalars still passed frontmatter checks.

## Coverage limits

Superseded candidate; the shared scalar helper was tightened.
