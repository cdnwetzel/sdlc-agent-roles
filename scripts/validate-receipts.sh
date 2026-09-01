#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CURRENT="$REPO_DIR/review/CURRENT"

die() { echo "ERROR: $*" >&2; exit 1; }
field_lines() { grep -E "^\*\*$2:\*\*" "$1" || true; }
sha256_stream() {
    if command -v shasum >/dev/null 2>&1; then shasum -a 256
    elif command -v sha256sum >/dev/null 2>&1; then sha256sum
    else die "shasum or sha256sum is required"; fi
}
require_staged_regular() {
    local rel="$1" entry mode count
    entry="$(git -C "$REPO_DIR" ls-files -s -- "$rel")"
    count="$(printf '%s\n' "$entry" | grep -c . || true)"
    [ "$count" -eq 1 ] || die "evidence must be staged exactly once: $rel"
    mode="${entry%% *}"
    case "$mode" in 100644|100755) ;; *) die "evidence must be a staged regular file: $rel" ;; esac
    git -C "$REPO_DIR" diff --quiet -- "$rel" || die "evidence has unstaged changes: $rel"
}
field_value() {
    local lines
    lines="$(field_lines "$1" "$2")"
    [ "$(printf '%s\n' "$lines" | grep -c . || true)" -eq 1 ] || return 1
    printf '%s\n' "$lines" | sed "s/^\*\*$2:\*\*[[:space:]]*//"
}
section_nonempty() {
    awk -v heading="$2" '
        $0 == heading { seen=1; next }
        seen && /^## / { exit }
        seen && $0 !~ /^[[:space:]]*$/ { content=1 }
        END { exit !(seen && content) }
    ' "$1"
}

git -C "$REPO_DIR" rev-parse --git-dir >/dev/null 2>&1 || die "receipt validation requires a Git worktree"
[ -f "$CURRENT" ] || die "review/CURRENT is missing"
require_staged_regular "review/CURRENT"
release="$(tr -d '\r\n' < "$CURRENT")"
printf '%s' "$release" | grep -Eq '^v[0-9]+\.[0-9]+\.[0-9]+$' || die "review/CURRENT is invalid"
release_dir="$REPO_DIR/review/$release"
subject_file="$release_dir/SUBJECT.md"
manifest="$release_dir/manifest.tsv"
[ -f "$manifest" ] || die "current review manifest is missing: review/$release/manifest.tsv"
[ -f "$subject_file" ] || die "current subject file is missing"
require_staged_regular "review/$release/manifest.tsv"
require_staged_regular "review/$release/SUBJECT.md"
[ -n "$(tail -c 1 "$manifest")" ] && die "manifest must end with a newline"

unstaged_payload="$(git -C "$REPO_DIR" diff --name-only \
    | awk -v prefix="review/$release/" 'index($0,prefix)!=1 {print}')"
untracked_payload="$(git -C "$REPO_DIR" ls-files --others --exclude-standard \
    | awk -v prefix="review/$release/" 'index($0,prefix)!=1 {print}')"
[ -z "$unstaged_payload" ] || die "payload has unstaged tracked changes"
[ -z "$untracked_payload" ] || die "payload has untracked files"

plugin_version="$(sed -n 's/^[[:space:]]*"version":[[:space:]]*"\([^"]*\)".*/\1/p' "$REPO_DIR/.claude-plugin/plugin.json")"
[ "v$plugin_version" = "$release" ] || die "plugin version ($plugin_version) does not match review/CURRENT ($release)"

subject_lines="$(grep -E '^[0-9a-f]{64}$' "$subject_file" || true)"
[ "$(printf '%s\n' "$subject_lines" | grep -c . || true)" -eq 1 ] || die "SUBJECT.md must contain exactly one bare 64-hex digest line"
subject_digest="$subject_lines"

payload_digest="$(git -C "$REPO_DIR" ls-files -s \
    | awk -F '\t' -v prefix="review/$release/" 'index($2,prefix)!=1 {print}' \
    | sha256_stream | awk '{print $1}')"
[ "$subject_digest" = "$payload_digest" ] \
    || die "SUBJECT.md digest does not match the staged payload ($payload_digest)"

header="$(head -n 1 "$manifest")"
[ "$header" = "id lane result receipt" ] \
    && die "manifest must be tab-separated, not space-separated"
[ "$header" = "$(printf 'id\tlane\tresult\treceipt')" ] || die "manifest header is invalid"

ids=""
paths=""
admissible_lanes=""
rows=0
while IFS="$(printf '\t')" read -r id lane result receipt extra; do
    rows=$((rows + 1))
    [ -z "${extra:-}" ] || die "manifest row $rows has extra columns"
    [ -n "$id" ] && [ -n "$lane" ] && [ -n "$result" ] && [ -n "$receipt" ] \
        || die "manifest row $rows has an empty value"
    printf '%s\n' "$ids" | grep -qxF "$id" && die "duplicate manifest id: $id"
    printf '%s\n' "$paths" | grep -qxF "$receipt" && die "duplicate receipt path: $receipt"
    ids="${ids}${ids:+$'\n'}$id"
    paths="${paths}${paths:+$'\n'}$receipt"
    case "$result" in PASS|PASS_WITH_FINDINGS|FAIL|NO_REVIEW|EXCLUDED) ;; *) die "invalid result: $result" ;; esac
    [ "$(dirname "$receipt")" = "review/$release" ] || die "receipt is not a direct child of review/$release: $receipt"
    case "$(basename "$receipt")" in *.md) ;; *) die "receipt is not Markdown: $receipt" ;; esac
    file="$REPO_DIR/$receipt"
    [ -f "$file" ] || die "receipt does not exist: $receipt"
    require_staged_regular "$receipt"
    [ -n "$(tail -c 1 "$file")" ] && die "receipt must end with a newline: $receipt"

    rid="$(field_value "$file" "Run ID")" || die "receipt needs exactly one non-empty Run ID: $receipt"
    actor="$(field_value "$file" "Actor")" || die "receipt needs exactly one non-empty Actor: $receipt"
    rlane="$(field_value "$file" "Lane")" || die "receipt needs exactly one non-empty Lane: $receipt"
    rresult="$(field_value "$file" "Result")" || die "receipt needs exactly one non-empty Result: $receipt"
    rsubject="$(field_value "$file" "Subject")" || die "receipt needs exactly one non-empty Subject: $receipt"
    invocation="$(field_value "$file" "Invocation")" || die "receipt needs exactly one non-empty Invocation: $receipt"
    [ -n "$rid" ] && [ -n "$actor" ] && [ -n "$rlane" ] && [ -n "$rresult" ] \
        && [ -n "$rsubject" ] && [ -n "$invocation" ] || die "receipt has an empty required field: $receipt"
    [ "$rid" = "$id" ] || die "manifest/receipt Run ID mismatch: $receipt"
    [ "$rlane" = "$lane" ] || die "manifest/receipt lane mismatch: $receipt"
    [ "$rresult" = "$result" ] || die "manifest/receipt result mismatch: $receipt"
    section_nonempty "$file" "## Findings and disposition" || die "empty Findings and disposition: $receipt"
    section_nonempty "$file" "## Coverage limits" || die "empty Coverage limits: $receipt"

    case "$result" in
        PASS|PASS_WITH_FINDINGS)
            printf '%s\n' "$rsubject" | grep -Eq "^$subject_digest([[:space:]]|$)" \
                || die "admissible receipt Subject is not bound to the current digest: $receipt"
            admissible_lanes="${admissible_lanes}${admissible_lanes:+$'\n'}$lane"
            ;;
    esac
done < <(tail -n +2 "$manifest")
[ "$rows" -gt 0 ] || die "manifest contains no receipts"

expected_release_paths="$(
    printf '%s\n' "review/$release/SUBJECT.md" "review/$release/manifest.tsv"
    printf '%s\n' "$paths" | grep -v '^$'
    )"
expected_release_paths="$(printf '%s\n' "$expected_release_paths" | sort)"
staged_release_paths="$(git -C "$REPO_DIR" ls-files -- "review/$release" | sort)"
[ "$expected_release_paths" = "$staged_release_paths" ] \
    || die "staged release directory must contain only SUBJECT.md, manifest.tsv, and every manifest receipt"

for required in codex claude kimi nested-one-shot deterministic; do
    printf '%s\n' "$admissible_lanes" | grep -qxF "$required" \
        || die "required lane lacks exact-subject admissible evidence: $required"
done

echo "Receipt gate passed for $release ($subject_digest)."
