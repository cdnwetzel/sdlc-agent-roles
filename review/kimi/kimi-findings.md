# kimi — findings (pass 1)

Subject: `claude-sdlc-roles` @ `36ab6aa`. All findings are `state: proposed` (R2). Severity per R6.

---

### F-001 — other in scripts/install-skills.sh:176-178 (P1, proposed)

**Claim:** `--plugin` mode reports registration success unconditionally, even when registration
failed. Both `claude plugin marketplace add` and `claude plugin install` are invoked with
`2>/dev/null || true`, swallowing stdout-hidden errors, and line 178 then prints
`registered claude-sdlc-roles@local-plugins` no matter what happened. The script's own header
(line 9) advertises idempotency and the README table (README.md:27) presents `--plugin` as a
working install path, but a user whose `claude` CLI errors (wrong version, marketplace name
conflict, invalid plugin source — see F-002) gets a green "registered" line and a "Try:
/sdlc-role …" epilogue for a plugin that does not exist. Honest failure reporting is the entire
value of an installer wrapper; capture the exit codes, and print "registered" only when both
commands succeed (or print the actual failure with the swallowed stderr). **Effort:** small.
**Risk:** low — the fix touches only the plugin branch's reporting, not the symlink logic.

### F-002 — other in scripts/install-skills.sh:128-131 (P1, proposed)

**Claim:** the marketplace entry `--plugin` creates points at a plugin source that has no plugin
manifest. Line 131 symlinks `$REPO_DIR` into `~/.claude/local-plugins/plugins/claude-sdlc-roles`,
and the manifest source is `./plugins/claude-sdlc-roles` — but `git ls-files` shows no
`.claude-plugin/plugin.json` (or any `.claude-plugin/` path) anywhere in this repo, and the
installer never writes one. Claude Code plugin loading expects a plugin manifest at the plugin
root; without it, the registration the script claims (F-001 hides the failure) cannot yield a
loadable plugin. Either add a minimal `.claude-plugin/plugin.json` to the repo, have the installer
generate one into the symlinked layout, or drop/mark-experimental the `--plugin` flag in the
READMEs. **Effort:** small-to-medium (needs a decision on which of the three options).
**Risk:** medium if the installer generates files; low if a static manifest is committed.

### F-003 — docs-drift in skills/sdlc-role/reference/seat-map.md:21-23 and :93-97 (P1, proposed)

**Claim:** `seat-map.md` redefines the load-bearing term "anchored" to mean a different, disjoint
set of roles than the rest of the repo. The canonical anchored set is seven roles
(README.md:186-192, separation-of-duties.md:50-63, SKILL.md:85-88, and each card's
`Agent fit: Anchored`): `domain-sme`, `engineering-manager`, `uat-coordinator`,
`incident-commander`, `customer-success`, `compliance-privacy`, `legal-contracts`. But
seat-map.md:21-23 labels `domain-sme`, `legal-contracts`, `compliance-privacy`, deep-dive pentest
(= `appsec-engineer`, a **Partial** role) and professional localization (= `localization-specialist`,
also **Partial**) as "anchored roles," omitting four of the canonical seven. Worse,
seat-map.md:93-97 ("every anchored role is borrowed") is contradicted by seat-map's own coverage
matrix three screens up: `uat-coordinator` sits at S1 and `customer-success` at S1 at **every**
team size, and `incident-commander` rotates in-team. "Anchored" is the term the cards and the
separation-of-duties reference use to decide what an agent may never do; giving it a second,
incompatible meaning in the seat map invites exactly the fabricated-authority failure mode the
repo calls its worst. Align seat-map's wording — e.g. "borrowed external functions" for the
always-outside set — with the seven-role definition. **Effort:** small (two paragraphs).
**Risk:** low.

### F-004 — scattered-config across ROLES.md / README.md / reference/seat-map.md / card headers (P2, proposed)

**Claim:** the 9-person seat value for the same role is rendered differently in the four places it
is repeated, and in three cases the difference is material, not cosmetic. `appsec-engineer`:
ROLES.md:51 and README.md:123 say `S8`; seat-map.md:52 and roles/appsec-engineer.md:3 say
`S8 + borrowed` — the "borrowed" half (third-party pentest) is a coverage claim, and the index
hides it. `localization-specialist`: ROLES.md:80 / README.md:152 say `S9`; seat-map.md:66 and the
card header say `S9 + borrowed`. `support-engineer`: ROLES.md:68 / README.md:140 say `S8`;
seat-map.md:59 and the card say `S8 + rotation`. (Five more rows differ only in phrasing —
`S9+S8` vs `S9 design, S8 validate`, etc. — and are harmless.) Since ROLES.md is the dispatcher's
first resolution surface (SKILL.md:41), its seat column should carry the qualifiers or the column
should be explicitly declared primary-seat-only. **Effort:** small. **Risk:** low.

### F-005 — docs-drift in skills/README.md:32-39 and README.md:159 vs scripts/build-skill-zips.sh:26-33 (P2, proposed)

**Claim:** the authoring rules are claimed to be enforced by "the installer and packager," but the
packager enforces only half of rule 2. `build-skill-zips.sh` checks that `SKILL.md` exists and
that a `name:` line matching the directory appears somewhere in the file; unlike
`install-skills.sh:88-99` it never checks that line 1 opens YAML frontmatter or that a
`description:` exists. So a skill the installer would refuse can be packaged and uploaded. Rules
3 (description states what *and* when) and 4 (relative paths) are unenforceable by either script
and are enforced by nothing — which is fine, but then the docs should say "authoring conventions,
partially machine-checked" instead of "must satisfy these or the installer and packager refuse
it." **Effort:** small (either extend the packager's checks to match the installer's, or soften
the two doc sentences). **Risk:** low.

### F-006 — docs-drift in skills/sdlc-role/SKILL.md:3 (P2, proposed)

**Claim:** the description's role arithmetic doesn't reconcile with 38. The description names
"product manager, business analyst, architect, tech lead, backend/frontend/data/ML engineer,
SDET, AppSec, SRE, release manager, incident commander, compliance, FinOps, **and 25 more**."
Counting the slash-grouped engineers as four roles and "architect" as one gives 15 named roles,
so "23 more" would be correct; counting each comma-separated item as one gives 12 named, needing
"26 more." No natural reading yields 25. This is the one text whose precision matters most — per
skills/README.md:36-37 the description is the entire trigger surface — and it currently asserts a
count that is wrong under every consistent counting. **Effort:** small. **Risk:** low.

### F-007 — other in skills/sdlc-role/SKILL.md:4-16 (P2, proposed)

**Claim:** the `metadata.triggers` regex list is dead configuration that contradicts the repo's
own model of how skills trigger. skills/README.md:36-37 states the description "is the only thing
loaded until the skill triggers, so it is the whole trigger surface" — i.e. there is no
regex-matching trigger layer for this frontmatter to feed. If some loader does consume
`triggers`, the repo's authoring docs are wrong; if none does, the block is inert weight that
future editors will maintain believing it has an effect. Either way one of the two documents is
misleading. Confirm against the actual skill loader and then delete the block or document the
mechanism. **Effort:** small. **Risk:** low — but note the caveat in kimi-overview.md: I did not
verify loader behavior externally, so this finding's premise should be confirmed before acting.

### F-008 — docs-drift in scripts/install-skills.sh:63-77 and README.md:28 (P2, proposed)

**Claim:** `--uninstall` does not reverse a `--plugin` install, and no doc says so. The uninstall
branch removes only the `~/.claude/skills/<name>` symlinks; the
`~/.claude/local-plugins/plugins/claude-sdlc-roles` symlink, the merged `marketplace.json` entry,
and whatever `claude plugin install` registered all survive. README.md:28 ("Remove the symlinks
this script created") is literally true but a user who installed with `--plugin` will reasonably
read `--uninstall` as the inverse of what they ran. Either extend uninstall to reverse the plugin
registration or add one sentence to both READMEs stating the scope. **Effort:** small.
**Risk:** low for the doc fix; medium for extending uninstall (manifest re-merge must not clobber
other entries — the installer already handles this for install via the python merge).

### F-009 — other in scripts/install-skills.sh:92,96 (P2, proposed)

**Claim:** the installer's frontmatter validation greps the whole file, not the frontmatter
block, so its guarantee "refuses to install anything that fails" (README.md:158) is weaker than
stated. `grep -q "^name: $name\$"` and `grep -q '^description: '` will match a `name:` /
`description:` line anywhere in the markdown body, so a SKILL.md whose frontmatter is broken but
whose body mentions the right strings passes validation and gets symlinked. The line-1 `---`
check (line 88) catches the common case, which is why this is P2 and not P1: the failure requires
a specifically malformed file. Scoping the greps to the frontmatter block (e.g.
`sed -n '/^---$/,/^---$/p'`) closes it. **Effort:** small. **Risk:** low.

---
Reviewed against subject HEAD `36ab6aafb94394e39351780c59974c5bc9d83588` on 2026-08-19.
