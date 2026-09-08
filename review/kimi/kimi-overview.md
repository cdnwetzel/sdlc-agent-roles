# kimi — review overview (pass 1, base)

**Subject:** this repository @ `36ab6aa` — documentation/skill repo, 48
git-tracked files, no code package, no tests, no build system beyond two bash scripts.

**Precondition:** verified before reviewing — `git rev-parse HEAD` = `36ab6aafb94394e39351780c59974c5bc9d83588`,
`git ls-files | wc -l` = 48. Both matched; review proceeded on this repo only.

## Method

Followed `review_prompt.md` top-down (§3) with `review_rules.md` as the rule companion.
Pass type: **full / base** (first pass by this agent).

Deviations and notes on the prescribed steps:

- §3.1 (prior work): my namespace contained only a discarded foreign-repo pass — not the
  `baseline.md` / `adversarial.md` files the dispatch brief named. Per the brief, that material is
  from a different repository; I did not read it and carried nothing forward. This pass is the base.
  (That material was removed from the repo on 2026-08-20; see `review/inventory.md`.)
- §3.2 (shared inventory): `review/inventory.md` and `review/README.md` **do not exist**. I did not
  create them — root files are outside the `review/kimi/kimi-*` writable envelope I was given.
  Absence recorded here so the dispatcher can decide whether to stand them up.
- §3.3–3.4: canonical docs = `README.md`, `skills/README.md`, `skills/sdlc-role/SKILL.md`,
  `ROLES.md`, the three `reference/` docs. Code walk = the two bash scripts plus scripted
  structural checks over all 38 role cards (section presence, slug/filename match, cross-reference
  resolution, fit/seat/phase consistency across four sources, anchored-role may-not blocks).
- §3.5 (plans): no `plans/` directory exists; the repo's own status ledger is `README.md`'s
  "Status" section, which I treated as the claims under test.
- No tests exist to read (§3.4 fallback); structural claims were re-verified by direct scripting
  instead of trusting the README's "Structurally validated" line.

## Safety table (review_prompt §2, derived for this project)

| Invocation | Safe during review? |
| --- | --- |
| `scripts/install-skills.sh --check` | ⚠ read-only in intent, but not run — dispatch brief forbids executing either script in any mode |
| `scripts/install-skills.sh` (default) | ❌ symlinks into `~/.claude/skills` |
| `scripts/install-skills.sh --plugin` | ❌ writes `~/.claude/local-plugins/`, runs `claude plugin` commands |
| `scripts/install-skills.sh --uninstall` | ❌ removes symlinks |
| `scripts/build-skill-zips.sh` | ❌ writes `dist/`, deletes prior zips |
| `git rev-parse / ls-files / log / status` | ✅ read-only |
| `ls / cat / grep / find / wc / sed -n` | ✅ read-only |

No safety-tag mutation was triggered; nothing outside `review/kimi/` was written.

## Verdict

The repo is in unusually good shape for a two-commit documentation project, and its headline
self-assessment is honest: every structural claim in `README.md`'s "Status" section
(38/38 nine-section cards, slug=filename, cross-references resolve, seven anchored may-not blocks)
survived independent scripted re-verification, and the "Not yet done" admission (no independent
review, no dispatcher functional test, no claude.ai upload) is accurate — this pass is the missing
independent review. The real problems cluster exactly where the README admits none: the
`--plugin` install path reports success unconditionally while registering a plugin source that has
no plugin manifest (F-001, F-002), and `reference/seat-map.md` uses the load-bearing term
"anchored" to mean a *different set of roles* than the rest of the repo defines, contradicting its
own coverage matrix (F-003). Beyond those, the findings are the expected docs-repo drift class:
seat values rendered three ways across three sources (F-004), enforcement claims for the packager
that the script doesn't implement (F-005, F-009), and small trigger-surface inaccuracies (F-006,
F-007, F-008). Nothing here is P0 — nothing actively misleads about a hard guardrail — but F-001
through F-003 should be acted on this cycle.

## What I did not explore

- **The claude.ai upload path empirically.** I did not unzip `dist/sdlc-role.zip` (read-only
  command whitelist) and did not verify claude.ai's current zip-layout/frontmatter requirements
  against any external source. The claim "single-top-level-directory layout claude.ai expects"
  (README.md:35, build-skill-zips.sh:6-7) is unverified.
- **The `code-review-framework` plugin contract.** `roles/code-reviewer.md:14-17` names commands
  (`/review-pass`, `/review-triage`, `/review-compact`) owned by an external plugin; whether those
  command names match that plugin's actual surface is unverifiable from this repo.
- **Whether Claude Code's skill loader consumes `metadata.triggers`.** F-007 rests on the repo's
  own authoring docs, not on loader source.
- **Full handoff-graph symmetry** across all 38 cards (I spot-checked 10; all held). A complete
  bidirectional audit of every `Receives from` / `Hands to` pair was not done.
- **Content quality of the role advice itself.** I checked internal consistency, not whether the
  38 cards' substantive guidance is good practice.
- `review/claude/` — another agent's namespace, not read by instruction.
- a discarded foreign-repo pass in my namespace — not read by instruction; since removed.

---
Reviewed against subject HEAD `36ab6aafb94394e39351780c59974c5bc9d83588` on 2026-08-19.
