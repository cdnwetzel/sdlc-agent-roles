# kimi — adversarial pass (pass 1)

Attacks on the claims this repo makes about itself, including the attacks that **failed**.
"What held" is recorded with the same care as "what broke," per the dispatch brief. Subject:
`claude-sdlc-roles` @ `36ab6aa`. Every scripted check below was run read-only against the working
tree at that SHA.

## Attacks that BROKE something

**A-1 — "The installer and packager enforce the authoring rules."**
(skills/README.md:32-39, README.md:158-159)
Attack: diff the two scripts' validation blocks. **Broke.** The installer checks SKILL.md
presence, line-1 frontmatter, name match, description presence. The packager checks only SKILL.md
presence and name match (build-skill-zips.sh:26-33). Rules 3–4 are enforced by neither.
→ F-005, F-009.

**A-2 — "`--plugin` registers a working local plugin."** (README.md:27, skills/README.md:15)
Attack: trace what `--plugin` actually produces. Line 131 symlinks the repo root as the plugin
source; `git ls-files` shows no `.claude-plugin/plugin.json`; the installer writes none; and both
`claude plugin` commands at lines 176-177 discard their errors before line 178 prints
"registered" unconditionally. **Broke twice:** the artifact is missing a manifest, and the
reporting is dishonest about it. → F-001, F-002.

**A-3 — "'Anchored' means one consistent thing across the repo."**
Attack: enumerate every use. Canonical set of seven (README.md:186-192,
separation-of-duties.md:50-63, SKILL.md:85-88, card headers) vs seat-map.md:21-23 (five entries,
two of which are Partial roles — `appsec-engineer`, `localization-specialist` — and four canonical
anchored roles missing) vs seat-map.md:93-97 ("every anchored role is borrowed," falsified by
seat-map's own matrix seating `uat-coordinator` and `customer-success` at S1 at all sizes).
**Broke.** The term that decides what an agent may never do has two incompatible definitions in
the same skill. → F-003.

**A-4 — "The same value means the same thing wherever it is repeated."**
Attack: join the seat column across ROLES.md, README.md, seat-map.md's 9-person column, and all
38 card headers (normalized for whitespace/punctuation). Fit values: **held** everywhere (38/38
across all four sources). Seat values: **broke** for three roles where the delta is semantic —
`appsec-engineer` (`S8` vs `S8 + borrowed`), `localization-specialist` (`S9` vs `S9 + borrowed`),
`support-engineer` (`S8` vs `S8 + rotation`); five more rows differ cosmetically only. → F-004.

**A-5 — "The description's arithmetic is right."** (SKILL.md:3: "…and 25 more")
Attack: count the named roles under every consistent reading. 15 named → 23 more; 12
comma-items → 26 more. **Broke** — no reading yields 25. Small, but this is the trigger surface
the repo itself calls the most important text in the skill. → F-006.

**A-6 — "`--uninstall` undoes the install."** (README.md:28)
Attack: install with `--plugin`, then uninstall, and inventory what remains. The skills symlinks
go; the marketplace manifest entry, the `plugins/` symlink, and the CLI-side registration stay.
**Partially broke** — the README sentence is literally true ("the symlinks") but materially
incomplete. → F-008.

**A-7 — "The `metadata.triggers` block does something."** (SKILL.md:4-16)
Attack: find the consumer. The repo's own authoring rule (skills/README.md:36-37) says the
description is the *whole* trigger surface, which leaves no mechanism for a regex list to feed.
**Broke as internal contradiction**; whether some external loader actually consumes `triggers` is
unverified (recorded below). → F-007.

## Attacks that FAILED — the repo's claims held

**A-8 — "38/38 cards carry all nine sections."** (README.md:213)
Scripted check for all nine section headers (`Mandate`, `Inputs required`, `Outputs`,
`Operating checklist`, `Definition of done`, `Must not (separation of duties)`, `Failure modes`,
`Handoff`, `Related`) across all 38 files: zero misses. **Held.** (Extra sections exist —
`code-reviewer` adds "Existing tooling," anchored cards add "Agent fit: Anchored" — but the claim
is presence, not exclusivity.)

**A-9 — "Every slug matches its filename."** (README.md:214)
Extracted the `**Slug:**` header from all 38 cards; 38/38 equal the filename minus `.md`. **Held.**

**A-10 — "Every cross-referenced slug resolves."** (README.md:214)
Extracted every lowercase-hyphenated backtick token from SKILL.md, ROLES.md, all reference docs,
and all 38 cards; every token either is one of the 38 slugs or is an external tool/product name
(`code-review-framework`, `autofix`, `sdlc-role` itself). No dangling role references. **Held.**

**A-11 — "All seven anchored cards carry their explicit may-not block."** (README.md:214)
Each of the seven has an `## Agent fit: Anchored` section *and* a `Must not` block with explicit
never-do items (e.g. uat-coordinator "Sign on behalf of the business… not an agent";
compliance-privacy "Sign an attestation as an agent"). **Held.** My first scripted grep
undercounted (matched only 2/7) because the cards phrase the prohibitions in role-specific
language; reading the sections directly confirmed all seven. Recorded so the next pass doesn't
repeat the false alarm.

**A-12 — "Card phase groupings agree with ROLES.md."**
Joined each card's `**Phase:**` header against its ROLES.md section: 38/38 match. **Held.**

**A-13 — "Card Fit values agree with ROLES.md and README.md."**
Joined `**Agent fit:**` across card headers, ROLES.md, and README.md's card tables: 38/38 agree
in all three sources. **Held.** (The seat column is where drift lives — see A-4.)

**A-14 — "The document library accounts for all 48 files."** (README.md:57)
Counted the library tables: 3 skill entry points + 3 reference + 38 roles + 2 scripts + 2 meta
= 48 = `git ls-files | wc -l`. **Held.** No untracked-but-shipped or shipped-but-undocumented
files (the only untracked path is `review/`, which is the review workspace, and `dist/` is
gitignored build output).

**A-15 — "The cards survive installation without this README."**
Greped the entire skill tree for references escaping the skill directory (`../`, `README`):
zero. All internal references are skill-root-relative and every referenced file ships in the zip
(`ROLES.md`, `roles/`, `reference/`). **Held.** Two soft spots, not findings: (a) two cards
reference `reference/handoff.md` / `reference/seat-map.md` from inside `roles/` — correct under
the repo's stated SKILL.md-relative convention (skills/README.md:38-39), but a model reading a
card standalone may resolve relative to the card's own directory; (b) `code-reviewer.md`'s
tooling section names commands from external plugins — the conditional framing ("where the
environment already provides") makes this defensible, but the specific command names are
unverifiable from this repo (see below).

**A-16 — "Handoff references are reciprocal."**
Spot check of 10 cards (`domain-sme`, `product-manager`, `business-analyst`, `qa-analyst`,
`uat-coordinator`, `code-reviewer`, `release-manager`, `appsec-engineer`, `tech-lead`, plus
transitive targets): every `Hands to` slug exists, and the sampled pairs are bidirectionally
consistent (e.g. `domain-sme`⇄`business-analyst`, `uat-coordinator`→`release-manager`⇄back).
**Held** for the sample; a full 38-card bidirectional audit was not run.

**A-17 — "The five invariants are stated identically everywhere."**
README.md:170-183, SKILL.md:58-73, separation-of-duties.md:7-18: same five, same order, same
supporting rules, same "invariant 4 is violated most often" emphasis. seat-map's per-seat
"Must NOT also hold" column is consistent with the enforcement column in
separation-of-duties.md (S7 approves deploys / if S7 wrote it, S3 approves; S1 records UAT, not
S3). **Held.**

## Attacks that could not be executed (unverified, not conceded)

- **Zip layout.** "The single-top-level-directory layout claude.ai expects" (build-skill-zips.sh:6-7)
  was not verified: the pass whitelist excluded running `unzip`, and claude.ai's current
  requirement was not checked against an external source. The build script's construction
  (`zip -r` from the skills dir) does produce `<name>/…` at top level by inspection.
- **`metadata.triggers` consumer.** No external loader documentation was consulted; F-007 rests on
  the repo's internal contradiction only.
- **External plugin command names** in `roles/code-reviewer.md:14-21` (`/review-pass`,
  `/review-triage`, `/review-compact`, `/code-review`, `autofix`) — unverifiable from this repo.
- **Dispatcher behavior.** Nothing here executes `/sdlc-role` end-to-end; README.md:216 already
  admits functional testing of the dispatcher is not done. This review is the structural half of
  that gap, not the functional half.

---
Reviewed against subject HEAD `36ab6aafb94394e39351780c59974c5bc9d83588` on 2026-08-19.
