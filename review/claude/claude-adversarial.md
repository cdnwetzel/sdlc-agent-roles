# Claude — adversarial pass

Method: take every load-bearing claim the repo makes about itself, attack it with an independent
mechanical check or a hostile reading, and record the outcome — **including the attacks that
failed**. A claim listed as GREEN below was attacked and held; that is an explicit result, not an
omission. Where an attack landed, the result graduated into `claude-findings.md` and is
cross-referenced here.

## Attacks on the README "Status" block (README.md:211-214)

| Claim attacked | Check performed | Outcome |
| --- | --- | --- |
| "38/38 cards carry all nine sections" | grep for each of the 9 `##` headers across all `roles/*.md`; count per header | **GREEN** — all nine headers appear exactly 38 times; per-file loop found zero misses |
| "every slug matches its filename" | extracted `**Slug:**` line from each card, compared to basename | **GREEN** — 38/38 match |
| "every cross-referenced slug resolves" | every backticked `[a-z-]+` token across cards, ROLES.md, SKILL.md, references, resolved against `roles/<slug>.md` | **GREEN** — only non-resolving tokens are `autofix` and `code-review-framework`, which are deliberate external plugin references in code-reviewer.md, not role slugs |
| "all seven anchored cards carry their explicit may-not block" | grep `^## Agent fit: Anchored` | **GREEN** — exactly 7 cards, and the set matches the seven named in README.md, SKILL.md:85-86, and separation-of-duties.md:50-63 (three independently maintained lists, all identical) |
| The *durability* of all four claims above | looked for any script or CI that enforces them | **LANDED** → F-002. True today, enforced by nothing |

Reproduction snippets for the green checks (so the next pass, or the F-002 validator, can reuse
them):

```bash
cd skills/sdlc-role/roles
for f in *.md; do for h in 'Mandate' 'Inputs required' 'Outputs' 'Operating checklist' \
  'Definition of done' 'Must not' 'Failure modes' 'Handoff' 'Related'; do
  grep -q "^## .*$h" "$f" || echo "$f missing: $h"; done; done
for f in *.md; do slug=$(grep -m1 '^\*\*Slug:\*\*' "$f" | sed 's/.*`\([a-z0-9-]*\)`.*/\1/');
  [ "$slug" = "${f%.md}" ] || echo "MISMATCH: $f -> $slug"; done
grep -l '^## Agent fit: Anchored' *.md   # expect exactly the 7 anchored slugs
```

## Attacks on the counting and consistency claims

| Claim attacked | Check | Outcome |
| --- | --- | --- |
| "38 role cards" (everywhere) | `ls roles \| wc -l` | **GREEN** — 38 |
| "48 files" (README.md:57) | `git ls-files \| wc -l` | **GREEN** — 48 tracked files |
| ROLES.md group counts sum to 38 | 7+5+7+7+4+4+4 | **GREEN** — 38 |
| Fit values agree between ROLES.md and all 38 card headers | field-by-field comparison | **GREEN** — 38/38 agree (also spot-agreed with README library tables) |
| Seat values agree across card header / ROLES.md / README / seat-map | field-by-field | **MOSTLY GREEN** — one soft drift: `support-engineer` "S8" (ROLES.md, README) vs "S8 + rotation" (card, seat-map) → folded into F-007 |
| Seat-map arithmetic: does each column's seat set match the stated headcount? | enumerated distinct seats per column | **LANDED** → F-001. The 7-person column uses 8 seats (S5 and S9 both survive, contradicting the 9→7 narrative). 9-person and 6-person columns are consistent |
| SKILL.md dispatcher rows all have working targets | `team [6|7|9]` vs seat-map coverage; `handoff`/`list` vs files | **GREEN** — seat-map covers exactly 9/7/6; referenced files exist |
| "seven-field task admission record" (README) matches the actual field lists | tech-lead.md fields vs handoff.md "Task admission" | **GREEN** — both enumerate the same 7 fields in the same order |
| Anchored may/may-not table (separation-of-duties.md) consistent with each anchored card's own block | row-by-row against the 7 cards | **GREEN** — no contradictions found |

## Attacks on the scripts' self-descriptions

| Claim attacked | Check | Outcome |
| --- | --- | --- |
| Installer "validates frontmatter first … refuses to install anything that fails" (README.md:158) | read validation block | **GREEN** as stated — checks exist and gate installation; robustness caveat → F-009 (greps scan whole file, not the frontmatter block) |
| Packager "re-validates frontmatter and refuses to package on mismatch" (README.md:159); "installer **and packager** refuse" (skills/README.md:32) | read build-skill-zips.sh checks | **LANDED** → F-006. Packager checks name only; no description or line-1 check |
| `--uninstall` "removes the symlinks this script created" (README.md:28) | read uninstall path vs everything the script creates | **LANDED** → F-004. Plugin-route artifacts survive uninstall |
| `--plugin` registration works and reports honestly | read the tail of the plugin branch | **LANDED** → F-005. Errors swallowed, success printed unconditionally; no `.claude-plugin/plugin.json` in repo; python3 dependency unchecked |
| `--check` and default install are non-destructive/idempotent, conflict-safe | read both paths | **GREEN** — check writes nothing; install refuses to clobber a non-symlink; relink only replaces symlinks; uninstall only removes links pointing into this repo |
| Zip layout "single top-level `<name>/` directory with SKILL.md at its root" | read the `(cd "$SRC_DIR" && zip … "$name")` invocation | **GREEN** — archive is rooted at `sdlc-role/`; dotfiles excluded |
| `.gitignore` "excludes dist/ and .DS_Store" (README.md:166) | read .gitignore; `git ls-files` | **GREEN** — both patterns present; `dist/sdlc-role.zip` untracked |

## Attacks on the skill's own governance content

| Attack | Outcome |
| --- | --- |
| Hunt for a card whose "Must not" contradicts another card's mandate or a seat-map assignment | **GREEN** — none found. The closest is `performance-engineer` sitting partly on build seat S4 (builder-measures tension), which the card's own must-not (tune-then-certify without independent re-verification) already fences; judged below the R7 bar and recorded in findings' not-explored note |
| Hunt for an invariant stated differently in different places (README five-invariants vs SKILL.md vs separation-of-duties.md) | **GREEN** — the five invariants are word-for-word aligned in intent across all three; enforcement details appear only in separation-of-duties.md, which is the right layering |
| Trigger-surface honesty: does anything claim dispatch behavior the platform won't deliver? | **LANDED** → F-003. `metadata.triggers` is inert; the repo's own authoring rule (skills/README.md:36-37) says the description is the whole trigger surface |
| Portability: read each card as if installed in a foreign repo / uploaded to claude.ai with no README | **LANDED** → F-008. Private-repo/`WORKFLOW.md` provenance references and code-reviewer's "(installed plugin)" claim don't survive the trip |
| Secrets / personal data in tree | **GREEN** — none; content is entirely generic role guidance |

## Net result

Two attacks produced P1 findings (F-001 seat arithmetic, F-002 unenforced validation claims), five
produced P2s, and eleven distinct claim families were attacked and held. Nothing rose to P0: no
claim actively misleads on a hard guardrail — the seat-map error is arithmetic in a reference
table, and the validation gap is about durability, not present-day falsehood.

## What I did not explore

- Dynamic behavior of any kind: no script was executed in a mutating mode, no plugin install was
  attempted, no zip was uploaded. All script findings are from reading, not running (the only
  commands run against the repo were read-only: `ls`, `find`, `grep`, `git ls-files`,
  `git rev-parse`, `wc`).
- `review/kimi/` — never opened, per the user's bias-avoidance instruction; this adversarial log
  therefore cannot and does not comment on any other agent's findings.

---
Reviewed against `36ab6aafb94394e39351780c59974c5bc9d83588` on 2026-08-19.
