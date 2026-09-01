# Claude — findings

Severity per framework R6: P0 broken/misleads on a hard guardrail · P1 material, act this cycle ·
P2 nice to have. All findings default to `state: proposed`.

**Summary: 0 × P0 · 2 × P1 · 7 × P2.** Everything not listed here that the README claims about
structure was checked and found green — see `claude-adversarial.md` for the explicit list of
claims that survived attack.

---

### F-001 — other (internal contradiction) in reference/seat-map.md:27-66 (P1, state: proposed)
- 2026-08-19 proposed

The "Coverage by team size" matrix's **7-person column maps hats onto eight distinct seats**:
S1, S3, S4, S5, S6, S7, S8, and S9 all appear (S5 via `data-architect`, `data-engineer`, `dba`,
`backend-engineer`; S9 via `ux-researcher` "S9 (thin)" and `ux-designer` "S9"). Eight seats plus a
borrowed EM is not a 7-person team. The doc's own narrative (seat-map.md:70-74) says 9→7 "drops the
Engineering Manager seat **and one build engineer**", and offers two variants (UI-heavy: keep S9,
fold a backend seat; pipeline-heavy: designer goes fractional, keep both backends) — but the matrix
commits to neither: it drops only S2 and keeps both S5 and S9 as full seats. For contrast, the
6-person column *is* arithmetically consistent (S1, S3, S4, S6, S7, S8 = six, with the designer
explicitly "Fractional / contract"). Fix: pick one variant for the matrix and mark the other seat
the way the 6-person column marks the designer (e.g. `ux-designer` → "Fractional" or the S5 hats →
"S4"), or add a variant note to the column header. Effort: small. Risk: low.

Related smaller gap, folded in rather than filed separately: the seat *composition* at 7 and 6
people is never stated anywhere — the reader must reverse-engineer which seats survive from the
matrix cells. One line per team size ("6-person = S1, S3, S4, S6, S7, S8 + fractional design")
would make the arithmetic checkable at a glance and would have made this finding impossible to miss.

### F-002 — test-gap in README.md:211-214 (Status section) and scripts/ (P1, state: proposed)
- 2026-08-19 proposed

The Status section claims "Structurally validated: 38/38 cards carry all nine sections, every slug
matches its filename, every cross-referenced slug resolves, all seven anchored cards carry their
explicit may-not block." **All four claims are true today — I re-verified each mechanically** — but
nothing in the repo enforces them. The only validation that exists (`install-skills.sh`,
`build-skill-zips.sh`) checks `SKILL.md` frontmatter and never looks at a role card. The 39th card,
or an edit that drops a section or renames a slug, will silently invalidate the README while both
scripts keep passing. These invariants are cheap to script (the checks are greps; my versions are
reproduced in `claude-adversarial.md`). Fix: add a `scripts/validate-cards.sh` that asserts the
nine sections, slug=filename, anchored-block presence for `Agent fit: Anchored` cards, cross-slug
resolution, and card-header fit/seat agreement with `ROLES.md` — and have both existing scripts (or
CI) call it. Effort: small. Risk: low. This is the highest-leverage change available: it converts
the repo's central quality claim from an assertion into evidence, which is the repo's own stated
standard ("evidence beats assertion").

### F-003 — other (inert configuration) in skills/sdlc-role/SKILL.md:4-17 (P2, state: proposed)
- 2026-08-19 proposed

The frontmatter carries a `metadata.triggers:` block of regex-like patterns. No documented Claude
Code or claude.ai mechanism consumes a `triggers` key — skill invocation is driven by the
`description` text (plus the explicit `/sdlc-role` form). The repo's own authoring rule agrees:
`skills/README.md:36-37` says the description "is the only thing loaded until the skill triggers,
so it is the whole trigger surface." As written, the block is dead config that invites a false
belief that adding a pattern changes dispatch behavior. Fix: delete it, or relabel it as
documentation (e.g. a "phrasings that should match" comment in the body) so nobody tunes it
expecting an effect. Effort: small. Risk: low.

### F-004 — docs-drift in README.md:28 vs scripts/install-skills.sh:63-77 (P2, state: proposed)
- 2026-08-19 proposed

The README's install table says `--uninstall` "Remove[s] the symlinks this script created." The
uninstall path only removes the `~/.claude/skills/<name>` symlinks. The `--plugin` path *also*
creates `~/.claude/local-plugins/plugins/claude-sdlc-roles` (a symlink, created by this script), a
`marketplace.json` entry, and an installed plugin registration — none of which uninstall touches.
After `--plugin` then `--uninstall`, the skill remains active via the plugin route, which
contradicts both the README row and the script's own farewell message ("Restart Claude Code to drop
the skills"). Fix: either have `--uninstall` also unwind the plugin registration, or scope the
claim ("removes the skill symlinks; plugin registration persists — remove with `claude plugin
uninstall`"). Effort: small. Risk: low.

### F-005 — other (unverified success report) in scripts/install-skills.sh:176-178 (P2, state: proposed)
- 2026-08-19 proposed

The plugin-registration tail runs `claude plugin marketplace add … 2>/dev/null || true` and
`claude plugin install … 2>/dev/null || true`, then unconditionally prints
"registered claude-sdlc-roles@local-plugins". If either command fails, the failure is both
swallowed and contradicted by a success message — the exact "prose claim where command output can
be supplied" anti-pattern the role cards warn about. Compounding it, the repo contains no
`.claude-plugin/plugin.json`, so the plugin-shaped install depends entirely on the marketplace
entry being sufficient; if it is not, this script reports success for something that never
happened, and nothing surfaces it. Fix: capture the exit status and report honestly (registered /
already registered / failed with stderr), and verify the plugin route once end-to-end. Minor
related nit, same script: the marketplace *merge* branch requires `python3` (line 139), a
dependency never checked or documented — with `set -e` the script dies mid-run if it is absent.
Effort: small. Risk: low.

### F-006 — convention-divergence in scripts/build-skill-zips.sh:26-33 vs README.md:159 and skills/README.md:32-39 (P2, state: proposed)
- 2026-08-19 proposed

Both READMEs claim the packager enforces the authoring rules — README.md:159: "Re-validates
frontmatter and refuses to package on mismatch"; skills/README.md:32: "A skill directory must
satisfy these or the installer and packager refuse it." The packager actually checks only that
`SKILL.md` exists and that `name:` matches the directory. It does not check that frontmatter starts
on line 1 nor that a `description:` exists (the installer checks both). So a skill with a missing
description packages fine and fails only at claude.ai upload time — the surface where the
description matters most. Fix: bring the packager's validation block up to parity with the
installer's (or factor the validation into a shared function/script, which F-002's proposed
validator would naturally provide). Effort: small. Risk: low.

### F-007 — scattered-config across roles/*.md headers, ROLES.md, README.md:83-152, reference/seat-map.md:29-66 (P2, state: proposed)
- 2026-08-19 proposed

Each role's Fit and Seat values are hand-duplicated in four places: the card header, the ROLES.md
index, the README document-library tables, and the seat-map coverage matrix. Today they agree —
I diffed all 38 fits across card headers and ROLES.md, all matched — with one small existing drift:
`support-engineer` is "S8" in ROLES.md:68 and README.md:140 but "S8 + rotation" in the card header
and seat-map. Harmless now, but this is exactly the rotting-enumerated-list shape: the fifth copy
of a value diverges first and is noticed never. Fix: at minimum, add the fit/seat cross-check to
the F-002 validator (card header vs ROLES.md); optionally declare one source authoritative in a
comment. Effort: small (validator) — regenerating tables from card headers would be medium and is
not obviously worth it. Risk: low.

### F-008 — other (portability leak) in roles/product-manager.md:60, roles/solution-architect.md:322, roles/delivery-manager.md:845 area, roles/finops.md:112-113, roles/code-reviewer.md:384 (P2, state: proposed)
- 2026-08-19 proposed

The repo's premise is that cards are portable ("installable into every Claude Code project and
uploadable to claude.ai"), but several cards embed provenance-specific references that are
meaningless or false in a target project: the private-repo `*-decline.md` pattern (product-manager,
solution-architect), "the `WORKFLOW.md` `[budgets]` pattern" and "as `WORKFLOW.md` does"
(delivery-manager, finops), and code-reviewer's flat "`code-review-framework` (installed plugin)" —
an installation claim that is false on claude.ai (no plugins exist there) and in any project
without it. The repo README's Provenance section explains these names, but the README is not in
the zip; a claude.ai user gets the references with no referent. Line-number note: the
delivery-manager and solution-architect citations are to the concatenated read; in-file, search for
a named private repo and `WORKFLOW.md`. Fix: keep the *pattern descriptions* (they are good) and drop the
source-repo names, or move attribution to a single provenance note; for code-reviewer, soften
"(installed plugin)" to "where installed" (the surrounding sentence already hedges correctly).
Effort: small. Risk: low.

### F-009 — other (validation robustness) in scripts/install-skills.sh:92-99 (P2, state: proposed)
- 2026-08-19 proposed

The frontmatter checks grep the **entire** `SKILL.md` (`grep -q "^name: $name$"`,
`grep -q '^description: '`) rather than the frontmatter block. A file whose frontmatter lacks
`name:` but whose body happens to contain a line starting `name: sdlc-role` (plausible in a skill
that documents skill authoring, as this repo's do) validates cleanly and then fails at load/upload
time. The line-1 `---` check partially compensates but does not bound the search to the block.
Fix: extract the block first (`sed -n '/^---$/,/^---$/p'`, or awk between the first two `---`
lines) and grep that. Same pattern applies to build-skill-zips.sh:30. Effort: small. Risk: low.

---

## What I did not explore

- Candidates that failed the R7 quality bar and were dropped rather than filed: the
  `performance-engineer` seat assignment (S4+S8) placing perf validation partly on a build seat —
  a real tension, but the card's "Must not" (tune-then-certify) already addresses it and the
  residual point is philosophical; the gate-handoff "Used by" list in reference/handoff.md omitting
  `sdet` — arguably intentional since sdet produces evidence rather than signing gates;
  README Provenance naming private repos by name — covered by F-008's
  actionable half.
- Everything listed in `claude-overview.md`'s not-explored section (kimi folder, zip contents,
  live dispatcher behavior, actual claude.ai upload, actual plugin install).

---
Reviewed against `36ab6aafb94394e39351780c59974c5bc9d83588` on 2026-08-19.
