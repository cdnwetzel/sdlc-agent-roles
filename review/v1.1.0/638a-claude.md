# Release review receipt: 638a-claude

**Run ID:** 638a-claude
**Actor:** Claude Code 2.1.236
**Lane:** claude
**Result:** FAIL
**Subject:** 638a05f739ee2f58cf3c1eff5b24581a5b84e4f76456d88863c97fad8f5722e5 — superseded staged public-release candidate
**Invocation:** Direct independent read-only staged-index review

## Findings and disposition

Revision required. Claude found one contradictory README row that still described release waivers
after the canonical policy adopted separate human-approved release exceptions. It also identified
useful low-severity polish in the adapter smoke's exact matching and diagnostics, anchored-role
detection, and the legal-role summary. All were accepted and corrected. Raw report SHA-256:
`ceb880d34d87a29b717bc6a9c8a82fae9e7436b5eca2dce26cdeae9d94ab87b3`.

## Coverage limits

Static exact-subject inspection; no project scripts, tests, builds, installers, network operations,
or other AI were used. The candidate changed during disposition, so this is failure evidence rather
than current approval.
