# Claude — review overview

**Agent:** claude · **Pass:** 1 (baseline + adversarial) · **Subject:** `claude-sdlc-roles` repo root
**Scope constraint from the user:** write only inside `review/claude/`; do not read `review/kimi/`
(honored — that directory was never opened, so nothing here is influenced by or deduplicated against it).

## What was reviewed

Every git-tracked file — 48 files: `README.md`, `.gitignore`, both scripts in `scripts/`,
`skills/README.md`, `skills/sdlc-role/SKILL.md`, `ROLES.md`, the three `reference/` docs, and all
38 role cards in full. `dist/sdlc-role.zip` was confirmed untracked and gitignored but not unpacked.

## Method

1. **Baseline pass** — read the canonical docs (README, SKILL.md, ROLES.md, references, scripts),
   then all 38 cards, checking each layer against the layers that describe it.
2. **Structural verification by tooling** — grep/find checks for the nine-section schema,
   slug-vs-filename match, anchored-block presence, and cross-reference resolution, rather than
   trusting the README's "Status" claims.
3. **Adversarial pass** — deliberately attacked the repo's own claims (the "Structurally validated"
   block, the installer/packager guarantees, the seat-map arithmetic, the portability claim) and
   then attempted to refute each of my own candidate findings before recording it. The attack log,
   including the attacks that failed (i.e., the claims that held), is in
   `claude-adversarial.md`.

## Verdict in one paragraph

The repo is in good shape. Every structural claim in the README's Status section verifies
independently: 38/38 cards carry all nine sections, every slug matches its filename, all seven
anchored cards carry the may-not block, every cross-referenced slug resolves, and the fit values are
consistent across all four places they appear. The role-card content itself is internally consistent
and unusually disciplined. **No P0 findings.** Two P1 findings: the 7-person column of the seat-map
coverage matrix maps hats onto **eight** distinct seats, contradicting the doc's own 9→7 narrative;
and the "Structurally validated" claims have no enforcing script, so they are true today and will
rot silently. Seven P2 findings, mostly small doc/script drift. Details in `claude-findings.md`.

## Files in this namespace

Use `ls review/claude/` as the inventory (per framework rule, no table maintained here).
Findings live in `claude-findings.md`; the adversarial attack log in `claude-adversarial.md`;
the pass log in `claude-passes.md`.

## What I did not explore

- `review/kimi/` — deliberately, per the user's instruction to avoid bias.
- `dist/sdlc-role.zip` contents — the build script was reviewed, the artifact was not unpacked
  and diffed against the source tree.
- Functional testing of the dispatcher (actually invoking `/sdlc-role <slug>` and observing
  behavior) — the README's own Status section also lists this as not yet done.
- Whether claude.ai's current skill-upload validator accepts the extra `metadata:` frontmatter keys
  — F-003 flags the design question; the upload itself was not attempted.
- `claude plugin install` end-to-end from the `--plugin` path — F-005 flags the concerns; the
  command was not executed (it mutates `~/.claude`, out of bounds for a review pass).

---
Reviewed against `36ab6aafb94394e39351780c59974c5bc9d83588` on 2026-08-19.
