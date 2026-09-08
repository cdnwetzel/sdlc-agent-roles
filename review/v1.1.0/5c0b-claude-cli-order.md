# Release review receipt: 5c0b-claude-cli-order

**Run ID:** 5c0b-claude-cli-order
**Actor:** Claude Code
**Lane:** claude
**Result:** NO_REVIEW
**Subject:** 5c0bd4bbe41624a0e9712f1937cdbea18341f12c242bd6a59bf0d7f073a024b7 — staged public-release candidate
**Invocation:** Malformed direct-review CLI invocation before the successful run

## Findings and disposition

CLI option ordering consumed the prompt as disallowed-tool rules and failed before model execution. No review occurred.

## Coverage limits

Argument validation only; zero model tools and zero repository actions.
