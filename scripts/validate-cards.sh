#!/usr/bin/env bash
# validate-cards.sh — assert every structural claim README.md's "Status" section makes.
#
#   bash scripts/validate-cards.sh        # check everything, report, exit 1 on any failure
#   bash scripts/validate-cards.sh -q     # same, but print only failures and the final tally
#
# Read-only. Runs no installer, writes nothing, touches nothing outside this repo.
#
# Exists because the README used to *assert* these invariants and nothing enforced them:
# the 39th card, or an edit that drops a section, would have silently falsified the claim
# while both other scripts kept passing. Evidence beats assertion — so this is the evidence.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILL_DIR="$REPO_DIR/skills/sdlc-role"
ROLES_DIR="$SKILL_DIR/roles"
ROLES_MD="$SKILL_DIR/ROLES.md"
SEAT_MAP="$SKILL_DIR/reference/seat-map.md"
SOD="$SKILL_DIR/reference/separation-of-duties.md"
README="$REPO_DIR/README.md"
source "$REPO_DIR/scripts/lib-frontmatter.sh"

QUIET=0
[ "${1:-}" = "-q" ] && QUIET=1

fail=0
checks=0

pass() { checks=$((checks + 1)); [ "$QUIET" -eq 1 ] || echo "  ok    $1"; }
bad()  { checks=$((checks + 1)); fail=1; echo "  FAIL  $1" >&2; }

# The nine sections every card must carry, in the schema's own words.
SECTIONS=(
    'Mandate'
    'Inputs required'
    'Outputs'
    'Operating checklist'
    'Definition of done'
    'Must not (separation of duties)'
    'Failure modes'
    'Handoff'
    'Related'
)

[ -d "$ROLES_DIR" ] || { echo "ERROR: no roles directory at $ROLES_DIR" >&2; exit 1; }

cards=()
while IFS= read -r f; do cards+=("$f"); done < <(find "$ROLES_DIR" -maxdepth 1 -name '*.md' | sort)
card_count=${#cards[@]}

[ "$QUIET" -eq 1 ] || echo "Validating $card_count role cards in $ROLES_DIR"
[ "$QUIET" -eq 1 ] || echo ""

# --- 1. every card carries all nine sections ---------------------------------
missing_sections=""
for f in "${cards[@]}"; do
    for s in "${SECTIONS[@]}"; do
        grep -qF "## $s" "$f" || missing_sections="$missing_sections\n    $(basename "$f") missing: $s"
    done
done
if [ -z "$missing_sections" ]; then
    pass "all $card_count cards carry all ${#SECTIONS[@]} sections"
else
    bad "cards missing sections:$(printf "$missing_sections")"
fi

# --- 2. slug matches filename ------------------------------------------------
slug_bad=""
for f in "${cards[@]}"; do
    slug="$(grep -m1 '^\*\*Slug:\*\*' "$f" | sed 's/.*\*\*Slug:\*\* *`\([a-z0-9-]*\)`.*/\1/')"
    base="$(basename "$f" .md)"
    [ "$slug" = "$base" ] || slug_bad="$slug_bad\n    $base declares slug '$slug'"
done
if [ -z "$slug_bad" ]; then
    pass "all $card_count slugs match their filenames"
else
    bad "slug/filename mismatches:$(printf "$slug_bad")"
fi

# --- 3. every cross-referenced role slug resolves to a card ------------------
# Backticked lowercase-hyphenated tokens across the whole skill tree must either be
# one of the 38 slugs or a known external name. A dangling role reference is a
# dispatcher dead end.
known_external='^(sdlc-role|security-review)$'
# Slugs without a hyphen (sdet, dba, sre, finops) would not match the pattern
# below, so add them explicitly. Derived from disk so the list cannot go stale.
flat_slugs="$(printf '%s\n' "${cards[@]}" | xargs -n1 basename | sed 's/.md$//' \
              | grep -v -- '-' | paste -sd'|' -)"
dangling=""
while IFS= read -r tok; do
    [ -f "$ROLES_DIR/$tok.md" ] && continue
    echo "$tok" | grep -qE "$known_external" && continue
    dangling="$dangling $tok"
done < <(grep -rhoE "\`([a-z][a-z0-9]*(-[a-z0-9]+)+|$flat_slugs)\`" "$SKILL_DIR" \
         | tr -d '`' | sort -u)
if [ -z "$dangling" ]; then
    pass "every cross-referenced role slug resolves"
else
    bad "unresolvable slug references:$dangling"
fi

# --- 4. anchored cards carry an explicit may-not block -----------------------
anchored=()
while IFS= read -r f; do anchored+=("$(basename "$f" .md)"); done \
    < <(grep -lE '^\*\*Slug:\*\* .* · \*\*Agent fit:\*\* Anchored( ·|$)' "${cards[@]}" | sort)
anchored_count=${#anchored[@]}

anchored_bad=""
for slug in "${anchored[@]}"; do
    grep -qF '## Must not (separation of duties)' "$ROLES_DIR/$slug.md" \
        || anchored_bad="$anchored_bad\n    $slug has no Must not block"
    grep -m1 '^\*\*Slug:\*\*' "$ROLES_DIR/$slug.md" | grep -qF '**Agent fit:** Anchored' \
        || anchored_bad="$anchored_bad\n    $slug header does not say Anchored"
done
if [ -z "$anchored_bad" ]; then
    pass "all $anchored_count anchored cards carry an explicit may-not block"
else
    bad "anchored-card problems:$(printf "$anchored_bad")"
fi

# --- 5. the anchored set is identical in all four places it is listed --------
# 'Anchored' decides what an agent may never do. A second definition of it
# anywhere in the tree is the most consequential drift this repo can have.
anchored_expected="$(printf '%s\n' "${anchored[@]}" | sort | tr '\n' ' ')"
anchored_roles_md="$(grep -E '^\| `[a-z-]+` \|' "$ROLES_MD" \
    | awk -F'|' '$5 ~ /Anchored/ {gsub(/[` ]/,"",$2); print $2}' | sort | tr '\n' ' ')"
if [ "$anchored_expected" = "$anchored_roles_md" ]; then
    pass "anchored set agrees between card headers and ROLES.md ($anchored_count roles)"
else
    bad "anchored set differs: cards [$anchored_expected] vs ROLES.md [$anchored_roles_md]"
fi

sod_missing=""
for slug in "${anchored[@]}"; do
    grep -qF "\`$slug\`" "$SOD" || sod_missing="$sod_missing $slug"
done
if [ -z "$sod_missing" ]; then
    pass "every anchored role appears in separation-of-duties.md"
else
    bad "anchored roles absent from separation-of-duties.md:$sod_missing"
fi

# Any paragraph anywhere in the skill that calls roles "anchored" must name only
# canonical anchored roles. Paragraph-scoped on purpose: the drift this catches
# named its slugs on one line and said "anchored" on the next, which a
# line-scoped check walks straight past.
prose_bad="$(
  find "$SKILL_DIR" -name '*.md' | sort | while IFS= read -r doc; do
    awk -v RS='' -v doc="$doc" '
      # Prose paragraphs only. Table rows carry a Fit column that legitimately
      # says "Anchored" per-role, and the legend paragraph defines the term —
      # neither is a redefinition, so strip both before looking for slugs.
      /[Aa]nchored/ {
        body = ""
        n = split($0, lines, /\n/)
        for (i = 1; i <= n; i++) {
          if (lines[i] ~ /^\|/) continue                 # table row
          if (lines[i] ~ /\*\*Anchored\*\* *=/) continue  # legend definition
          body = body " " lines[i]
        }
        if (body !~ /[Aa]nchored/) next
        m = split(body, toks, /`/)
        for (i = 2; i <= m; i += 2) print doc "\t" toks[i]
      }' "$doc"
  done | while IFS="$(printf '\t')" read -r doc tok; do
    [ -f "$ROLES_DIR/$tok.md" ] || continue
    printf '%s\n' "${anchored[@]}" | grep -qx "$tok" \
      || echo "    $(basename "$doc") calls '$tok' anchored, but its card does not"
  done | sort -u
)"
if [ -z "$prose_bad" ]; then
    pass "'anchored' means the canonical $anchored_count roles everywhere in the skill"
else
    bad "'anchored' redefined:$(printf '\n%s' "$prose_bad")"
fi

# --- 6. fit and seat agree across card header, ROLES.md, README -------------
# Four hand-maintained copies of the same value; the fifth copy diverges first
# and is noticed never. Compare them rather than trusting them.
fit_bad=""
seat_bad=""
for f in "${cards[@]}"; do
    slug="$(basename "$f" .md)"
    hdr="$(grep -m1 '^\*\*Slug:\*\*' "$f")"
    card_fit="$(echo "$hdr"  | sed -n 's/.*\*\*Agent fit:\*\* *\([A-Za-z]*\).*/\1/p')"
    card_seat="$(echo "$hdr" | sed -n 's/.*\*\*9-person seat:\*\* *\(.*\)$/\1/p' | sed 's/ *$//')"

    row="$(grep -m1 "^| \`$slug\` |" "$ROLES_MD" || true)"
    [ -n "$row" ] || { fit_bad="$fit_bad\n    $slug has no ROLES.md row"; continue; }
    idx_fit="$(echo "$row"  | awk -F'|' '{gsub(/^ +| +$/,"",$5); print $5}')"
    idx_seat="$(echo "$row" | awk -F'|' '{gsub(/^ +| +$/,"",$6); print $6}')"

    [ "$card_fit" = "$idx_fit" ] \
        || fit_bad="$fit_bad\n    $slug fit: card '$card_fit' vs ROLES.md '$idx_fit'"
    [ "$card_seat" = "$idx_seat" ] \
        || seat_bad="$seat_bad\n    $slug seat: card '$card_seat' vs ROLES.md '$idx_seat'"
done
if [ -z "$fit_bad" ]; then
    pass "fit agrees between all $card_count card headers and ROLES.md"
else
    bad "fit disagreements:$(printf "$fit_bad")"
fi
if [ -z "$seat_bad" ]; then
    pass "seat agrees between all $card_count card headers and ROLES.md"
else
    bad "seat disagreements:$(printf "$seat_bad")"
fi

# README's document-library tables carry the same two values a third time.
readme_bad=""
for f in "${cards[@]}"; do
    slug="$(basename "$f" .md)"
    row="$(grep -m1 "roles/$slug.md" "$README" || true)"
    [ -n "$row" ] || { readme_bad="$readme_bad\n    $slug missing from README library"; continue; }
    hdr="$(grep -m1 '^\*\*Slug:\*\*' "$f")"
    card_fit="$(echo "$hdr"  | sed -n 's/.*\*\*Agent fit:\*\* *\([A-Za-z]*\).*/\1/p')"
    card_seat="$(echo "$hdr" | sed -n 's/.*\*\*9-person seat:\*\* *\(.*\)$/\1/p' | sed 's/ *$//')"
    r_fit="$(echo "$row"  | awk -F'|' '{gsub(/^ +| +$/,"",$4); print $4}')"
    r_seat="$(echo "$row" | awk -F'|' '{gsub(/^ +| +$/,"",$5); print $5}')"
    [ "$card_fit" = "$r_fit" ] \
        || readme_bad="$readme_bad\n    $slug fit: card '$card_fit' vs README '$r_fit'"
    [ "$card_seat" = "$r_seat" ] \
        || readme_bad="$readme_bad\n    $slug seat: card '$card_seat' vs README '$r_seat'"
done
if [ -z "$readme_bad" ]; then
    pass "fit and seat agree between card headers and README's library tables"
else
    bad "README library drift:$(printf "$readme_bad")"
fi

# --- 7. seat-map coverage columns use the headcount they advertise ----------
# The 7-person column once mapped hats onto eight distinct seats. Arithmetic,
# not opinion — so check it.
check_column() {
    local col="$1" want="$2" label="$3"
    local seats
    seats="$(grep -E '^\| `[a-z-]+` \|' "$SEAT_MAP" \
        | awk -F'|' -v c="$col" '{print $c}' \
        | grep -oE 'S[0-9]' | sort -u | tr '\n' ' ')"
    local n
    n="$(echo "$seats" | wc -w | tr -d ' ')"
    if [ "$n" -le "$want" ]; then
        pass "$label column uses $n distinct seats ($seats) — within $want"
    else
        bad "$label column uses $n distinct seats ($seats) but claims $want"
    fi
}
check_column 3 9 "9-person"
check_column 4 7 "7-person"
check_column 5 6 "6-person"

# --- 8. every card in roles/ is indexed, and every indexed slug has a card ---
indexed="$(grep -oE '^\| `[a-z-]+`' "$ROLES_MD" | tr -d '|` ' | sort)"
ondisk="$(printf '%s\n' "${cards[@]}" | xargs -n1 basename | sed 's/.md$//' | sort)"
if [ "$indexed" = "$ondisk" ]; then
    pass "ROLES.md indexes exactly the $card_count cards on disk"
else
    bad "index/disk mismatch:$(printf '\n')$(diff <(echo "$indexed") <(echo "$ondisk") | sed 's/^/    /')"
fi

# --- 9. counts asserted in prose match reality ------------------------------
count_bad=""
for doc in "$README" "$ROLES_MD" "$SKILL_DIR/SKILL.md"; do
    while IFS= read -r n; do
        [ "$n" = "$card_count" ] \
            || count_bad="$count_bad\n    $(basename "$doc") says '$n role' but there are $card_count"
    done < <(grep -oE '\b([0-9]+) role' "$doc" | awk '{print $1}' | sort -u)
done
if [ -z "$count_bad" ]; then
    pass "prose role counts agree with the $card_count cards on disk"
else
    bad "prose role count disagreements:$(printf '%b' "$count_bad")"
fi

# --- 10. the skill description's arithmetic adds up -------------------------
# "…and N more" must reconcile with the roles actually named before it.
desc="$(sed -n '/^description: /p' "$SKILL_DIR/SKILL.md")"
more="$(echo "$desc" | grep -oE 'and ([0-9]+) more' | grep -oE '[0-9]+' || true)"
if [ -n "$more" ]; then
    named="$(echo "$desc" \
        | sed 's/.*role — //; s/, and [0-9]* more.*//' \
        | tr ',' '\n' | sed 's/^ *//; s/ *$//' | grep -c . )"
    slashes="$(echo "$desc" | sed 's/.*role — //; s/, and [0-9]* more.*//' \
        | grep -oE '[a-zA-Z]+(/[a-zA-Z]+)+' | tr '/' '\n' | grep -c . || true)"
    slashgroups="$(echo "$desc" | sed 's/.*role — //; s/, and [0-9]* more.*//' \
        | grep -coE '[a-zA-Z]+(/[a-zA-Z]+)+' || true)"
    [ -n "$slashes" ] || slashes=0
    [ -n "$slashgroups" ] || slashgroups=0
    expanded=$(( named - slashgroups + slashes ))
    if [ $(( expanded + more )) -eq "$card_count" ]; then
        pass "description arithmetic: $expanded named + $more more = $card_count"
    else
        bad "description says 'and $more more' after $expanded named roles = $(( expanded + more )), not $card_count"
    fi
else
    pass "description asserts no role count"
fi

# --- 11. README's file count matches the tracked tree -----------------------
# A hardcoded inventory in prose goes stale the moment a file is added. Check it
# rather than trusting it. Skips cleanly outside a git checkout.
if git -C "$REPO_DIR" rev-parse --git-dir >/dev/null 2>&1; then
    claimed="$(grep -oE '^[0-9]+ files\.' "$README" | head -1 | grep -oE '[0-9]+' || true)"
    actual="$(git -C "$REPO_DIR" ls-files | grep -cv '^review/' || true)"
    if [ -z "$claimed" ]; then
        pass "README asserts no file count"
    elif [ "$claimed" = "$actual" ]; then
        pass "README's file count ($claimed) matches the tracked tree"
    else
        bad "README says '$claimed files' but the tracked tree has $actual"
    fi
else
    claimed="$(grep -oE '^[0-9]+ files\.' "$README" | head -1 | grep -oE '[0-9]+' || true)"
    if [ -z "$claimed" ]; then
        pass "README asserts no file count"
    else
        bad "README asserts a file count that cannot be verified outside Git"
    fi
fi

# --- 12. no reference escapes the skill directory ---------------------------
# Cards ship in a zip without this README. A reference to anything outside the
# skill root is a dead link the moment it leaves this repo.
escapes="$(grep -rnE '\.\./\.\.|\]\(\.\./' "$SKILL_DIR" || true)"
if [ -z "$escapes" ]; then
    pass "no card references a path outside the skill directory"
else
    bad "references escaping the skill root:$(printf '\n%s' "$(echo "$escapes" | sed 's/^/    /')")"
fi

# --- 13. canonical and platform metadata ------------------------------------
canonical="$SKILL_DIR/SKILL.md"
if canonical_frontmatter_valid "$canonical"; then
    pass "canonical SKILL.md has exact, non-empty name/description frontmatter"
else
    bad "canonical SKILL.md frontmatter is missing, malformed, empty, duplicated, or has extra keys"
fi

openai="$SKILL_DIR/agents/openai.yaml"
if [ -f "$openai" ] \
   && grep -qx 'interface:' "$openai" \
   && grep -Eq '^  default_prompt: ".*\$sdlc-role( |")(.*)?"$' "$openai" \
   && grep -qx '  allow_implicit_invocation: false' "$openai"; then
    pass "Codex openai.yaml metadata exists and requires explicit invocation"
else
    bad "Codex openai.yaml metadata is missing or unsafe"
fi

dispatcher="$SKILL_DIR/dispatcher.md"
if grep -q 'Do not adopt a role' "$dispatcher" \
   && grep -qi 'never infer role adoption' "$dispatcher" \
   && grep -q 'never grants permission' "$dispatcher" \
   && grep -q 'not an independent approver' "$dispatcher" \
   && grep -q 'Never fabricate a human signature' "$dispatcher"; then
    pass "dispatcher requires explicit roles and preserves authority and approval boundaries"
else
    bad "dispatcher is missing an explicit-role, authority, independence, or anchored-human guard"
fi

adapter_doc="$SKILL_DIR/reference/platform-adapters.md"
if [ -f "$adapter_doc" ] \
   && grep -q 'Claude Code' "$adapter_doc" \
   && grep -q 'Codex' "$adapter_doc" \
   && grep -q 'Kimi Code' "$adapter_doc" \
   && grep -q 'dispatcher.md' "$adapter_doc"; then
    pass "platform-adapter guidance is bundled and routes every host to dispatcher.md"
else
    bad "platform-adapter guidance is missing or incomplete"
fi

kimi="$REPO_DIR/agents/kimi/sdlc-role"
kimi_bad=""
kimi_frontmatter_valid "$kimi/SKILL.md" || kimi_bad="frontmatter"
for item in dispatcher.md ROLES.md roles reference; do
    target="../../../skills/sdlc-role/$item"
    [ -L "$kimi/$item" ] && [ "$(readlink "$kimi/$item")" = "$target" ] && [ -e "$kimi/$item" ] \
        || kimi_bad="$kimi_bad $item"
done
if [ -z "$kimi_bad" ]; then
    pass "Kimi wrapper has exact native schema and portable canonical links"
else
    bad "Kimi wrapper/link problems:$kimi_bad"
fi

safety_bad=""
grep -q 'if several cards match' "$dispatcher" || safety_bad="$safety_bad dispatcher-disambiguation"
grep -q 'controlled internal link' "$SKILL_DIR/reference/handoff.md" || safety_bad="$safety_bad handoff-redaction"
grep -q 'executed test record' "$ROLES_DIR/accessibility-specialist.md" || safety_bad="$safety_bad accessibility-evidence"
grep -q 'Use masked or synthetic data' "$ROLES_DIR/data-engineer.md" || safety_bad="$safety_bad lower-environment-data"
grep -q 'participant consent' "$ROLES_DIR/ux-researcher.md" || safety_bad="$safety_bad research-consent"
grep -q 'host or repository policy explicitly' "$ROLES_DIR/sre.md" || safety_bad="$safety_bad release-authority"
if [ -z "$safety_bad" ]; then
    pass "high-risk role and handoff safety boundaries are explicit"
else
    bad "missing high-risk safety boundaries:$safety_bad"
fi

if grep -RniE 'waiv(e|ed|er|ers|ing)' "$README" "$SKILL_DIR" >/dev/null; then
    bad "retired waiver terminology remains outside historical review evidence"
else
    pass "release-exception terminology is consistent"
fi

# --- 14. the README's claim about THIS script is itself true ----------------
# Self-referential on purpose. The README states how many checks run here; that
# number is an enumerated count in prose, which is the exact class of claim this
# script exists to stop from rotting. `checks + 1` accounts for this check.
# Collapse newlines first — the claim wraps across a line break in the README,
# and `|| true` keeps a no-match from tripping `set -e`.
claimed_checks="$(tr '\n' ' ' < "$README" \
    | grep -oE 'runs \*{0,2}[0-9]+\*{0,2} +checks' | grep -oE '[0-9]+' | head -1 || true)"
if [ -z "$claimed_checks" ]; then
    pass "README asserts no check count"
elif [ "$claimed_checks" -eq "$((checks + 1))" ]; then
    pass "README's claimed check count ($claimed_checks) matches this script"
else
    bad "README says $claimed_checks checks; this script actually runs $((checks + 1))"
fi

# --- tally -------------------------------------------------------------------
echo ""
if [ "$fail" -eq 0 ]; then
    echo "All $checks structural checks passed."
else
    echo "$checks checks run; failures above." >&2
fi
exit "$fail"
