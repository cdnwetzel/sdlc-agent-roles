# Release review receipt: e0ec-codex

**Run ID:** e0ec-codex
**Actor:** Codex independent review agent
**Lane:** codex
**Result:** FAIL
**Subject:** e0ecbef46c7fd1c8bfd53ffe4e870ec81dbc8fc63fdeb8e1402e815916c0af63 — superseded staged public-release candidate
**Invocation:** Independent exact-subject staged-index review

## Findings and disposition

Revision required. The Codex adapter smoke checked only for an unbounded `$sdlc-role` substring in
installed metadata and did not prove the documented Codex invocation. The same unbounded metadata
predicate appeared in the structural validator. Both findings were accepted: the smoke now checks
the exact documented invocation prefix, and both gates require a valid token boundary in
`agents/openai.yaml`.

## Coverage limits

Static exact-subject inspection; the remaining 638a fixes and prior authority, privacy, CI,
installer, and receipt amendments were verified. No project execution or other AI was used.
