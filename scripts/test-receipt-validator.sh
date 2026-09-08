#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ROOT="$(mktemp -d "${TMPDIR:-/tmp}/sdlc-receipts.XXXXXX")"
ROOT="$(cd "$ROOT" && pwd -P)"
trap 'rm -rf "$ROOT"' EXIT
BASE="$ROOT/base"
command -v python3 >/dev/null 2>&1 || { echo "ERROR: python3 is required for receipt fixtures" >&2; exit 1; }
sha256_stream() {
    if command -v shasum >/dev/null 2>&1; then shasum -a 256
    elif command -v sha256sum >/dev/null 2>&1; then sha256sum
    else echo "ERROR: shasum or sha256sum is required" >&2; exit 1; fi
}
mkdir -p "$BASE/scripts" "$BASE/review/v1.1.0" "$BASE/.claude-plugin"
cp "$REPO_DIR/scripts/validate-receipts.sh" "$BASE/scripts/"
printf 'payload\n' > "$BASE/payload.txt"
printf 'v1.1.0\n' > "$BASE/review/CURRENT"
printf '{\n  "name": "fixture",\n  "version": "1.1.0"\n}\n' > "$BASE/.claude-plugin/plugin.json"
git -C "$BASE" init -q
git -C "$BASE" config user.email fixture@example.invalid
git -C "$BASE" config user.name Fixture
git -C "$BASE" add payload.txt scripts/validate-receipts.sh review/CURRENT .claude-plugin/plugin.json
digest="$(git -C "$BASE" ls-files -s | awk -F '\t' -v prefix='review/v1.1.0/' 'index($2,prefix)!=1 {print}' | sha256_stream | awk '{print $1}')"
printf '# Subject\n\n%s\n' "$digest" > "$BASE/review/v1.1.0/SUBJECT.md"

write_receipt() {
    local path="$1" id="$2" lane="$3" result="$4" subject="$5"
    cat > "$path" <<EOF
# Receipt

**Run ID:** $id
**Actor:** fixture reviewer
**Lane:** $lane
**Result:** $result
**Subject:** $subject
**Invocation:** isolated fixture

## Findings and disposition

No findings.

## Coverage limits

Fixture evidence only.
EOF
}

for lane in codex claude kimi nested-one-shot deterministic; do
    file="$BASE/review/v1.1.0/$lane.md"
    write_receipt "$file" "$lane-1" "$lane" PASS "$digest — fixture payload"
done
{
    printf 'id\tlane\tresult\treceipt\n'
    for lane in codex claude kimi nested-one-shot deterministic; do
        printf '%s\t%s\tPASS\treview/v1.1.0/%s.md\n' "$lane-1" "$lane" "$lane"
    done
} > "$BASE/review/v1.1.0/manifest.tsv"
git -C "$BASE" add review/v1.1.0
bash "$BASE/scripts/validate-receipts.sh" >/dev/null
passed=1

expect_fail() {
    local name="$1" command="$2" stage_release="${3:-yes}" case_dir
    case_dir="$ROOT/$name"
    cp -R "$BASE" "$case_dir"
    (cd "$case_dir" && eval "$command")
    if [ "$stage_release" = "yes" ]; then
        git -C "$case_dir" add -A review/v1.1.0
    fi
    if bash "$case_dir/scripts/validate-receipts.sh" >/dev/null 2>&1; then
        echo "FAIL: receipt validator accepted $name" >&2; exit 1
    fi
    passed=$((passed + 1))
}

expect_fail payload-mismatch "printf changed >> payload.txt; git add payload.txt"
expect_fail absent-lane "sed -i.bak '/kimi-1/d' review/v1.1.0/manifest.tsv; rm -f review/v1.1.0/manifest.tsv.bak"
expect_fail non-admissible "awk -F '\t' 'BEGIN{OFS=\"\t\"} \$1==\"kimi-1\"{\$3=\"NO_REVIEW\"} {print}' review/v1.1.0/manifest.tsv > review/v1.1.0/manifest.tmp; mv review/v1.1.0/manifest.tmp review/v1.1.0/manifest.tsv; sed -i.bak 's/\*\*Result:\*\* PASS/\*\*Result:\*\* NO_REVIEW/' review/v1.1.0/kimi.md; rm -f review/v1.1.0/*.bak"
expect_fail extra-column "awk 'NR==2{\$0=\$0 \"\textra\"} {print}' review/v1.1.0/manifest.tsv > review/v1.1.0/manifest.tmp; mv review/v1.1.0/manifest.tmp review/v1.1.0/manifest.tsv"
expect_fail invalid-result "sed -i.bak '2s/PASS/MAYBE/' review/v1.1.0/manifest.tsv; rm -f review/v1.1.0/manifest.tsv.bak"
expect_fail traversal "sed -i.bak '2s#review/v1.1.0/codex.md#review/v1.1.0/../codex.md#' review/v1.1.0/manifest.tsv; rm -f review/v1.1.0/manifest.tsv.bak"
expect_fail lane-mismatch "sed -i.bak 's/\*\*Lane:\*\* codex/\*\*Lane:\*\* claude/' review/v1.1.0/codex.md; rm -f review/v1.1.0/codex.md.bak"
expect_fail result-mismatch "sed -i.bak 's/\*\*Result:\*\* PASS/\*\*Result:\*\* FAIL/' review/v1.1.0/codex.md; rm -f review/v1.1.0/codex.md.bak"
expect_fail duplicate-path "printf 'other\tother\tPASS\treview/v1.1.0/codex.md\n' >> review/v1.1.0/manifest.tsv"
expect_fail duplicate-id "cp review/v1.1.0/codex.md review/v1.1.0/other.md; printf 'codex-1\tother\tPASS\treview/v1.1.0/other.md\n' >> review/v1.1.0/manifest.tsv"
expect_fail digest-outside-subject "sed -i.bak 's/\*\*Subject:\*\*.*/\*\*Subject:\*\* old candidate/' review/v1.1.0/codex.md; awk -v d='$digest' '{print} /No findings/{print d}' review/v1.1.0/codex.md > review/v1.1.0/codex.tmp; mv review/v1.1.0/codex.tmp review/v1.1.0/codex.md; rm -f review/v1.1.0/codex.md.bak"
expect_fail duplicate-subject "sed -i.bak '/\*\*Subject:\*\*/p' review/v1.1.0/codex.md; rm -f review/v1.1.0/codex.md.bak"
expect_fail empty-field "sed -i.bak 's/\*\*Actor:\*\*.*/\*\*Actor:\*\*/' review/v1.1.0/codex.md; rm -f review/v1.1.0/codex.md.bak"
expect_fail empty-section "sed -i.bak '/No findings./d' review/v1.1.0/codex.md; rm -f review/v1.1.0/codex.md.bak"
expect_fail no-final-newline "python3 -c \"p='review/v1.1.0/codex.md'; d=open(p).read(); open(p,'w').write(d.rstrip('\\n'))\""
expect_fail unstaged-evidence "printf '\nunstaged\n' >> review/v1.1.0/codex.md" no
expect_fail untracked-evidence "cp review/v1.1.0/codex.md review/v1.1.0/untracked.md; sed -i.bak 's/codex-1/untracked-1/; s/\*\*Lane:\*\* codex/\*\*Lane:\*\* extra/' review/v1.1.0/untracked.md; rm -f review/v1.1.0/untracked.md.bak; printf 'untracked-1\textra\tPASS\treview/v1.1.0/untracked.md\n' >> review/v1.1.0/manifest.tsv; git add review/v1.1.0/manifest.tsv" no
expect_fail symlink-evidence "rm review/v1.1.0/codex.md; ln -s claude.md review/v1.1.0/codex.md"
expect_fail omitted-receipt "cp review/v1.1.0/codex.md review/v1.1.0/omitted.md; sed -i.bak 's/codex-1/omitted-1/; s/\*\*Lane:\*\* codex/\*\*Lane:\*\* extra/' review/v1.1.0/omitted.md; rm -f review/v1.1.0/omitted.md.bak"
expect_fail space-header "printf 'id lane result receipt\n' > review/v1.1.0/manifest.tmp; tail -n +2 review/v1.1.0/manifest.tsv >> review/v1.1.0/manifest.tmp; mv review/v1.1.0/manifest.tmp review/v1.1.0/manifest.tsv"
expect_fail manifest-no-newline "python3 -c \"p='review/v1.1.0/manifest.tsv'; d=open(p).read(); open(p,'w').write(d.rstrip('\\n'))\""
expect_fail subject-no-digest "sed -i.bak '/^[0-9a-f][0-9a-f]*$/d' review/v1.1.0/SUBJECT.md; rm -f review/v1.1.0/SUBJECT.md.bak"
expect_fail subject-multiple-digests "printf '$digest\n' >> review/v1.1.0/SUBJECT.md"
expect_fail non-markdown-receipt "cp review/v1.1.0/codex.md review/v1.1.0/codex.txt; sed -i.bak 's#review/v1.1.0/codex.md#review/v1.1.0/codex.txt#' review/v1.1.0/manifest.tsv; rm -f review/v1.1.0/manifest.tsv.bak"
expect_fail malformed-current "printf 'release-next\n' > review/CURRENT; git add review/CURRENT" no
expect_fail unmanifested-extra "printf 'not a receipt\n' > review/v1.1.0/extra.txt"
expect_fail nested-release-file "mkdir -p review/v1.1.0/nested; cp review/v1.1.0/codex.md review/v1.1.0/nested/codex.md"

echo "Receipt validator fixtures passed ($passed cases)."
