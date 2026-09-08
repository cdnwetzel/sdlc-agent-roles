#!/usr/bin/env bash

# Read a complete YAML frontmatter block. Missing either delimiter is a failure.
frontmatter() {
    awk '
        NR == 1 { if ($0 != "---") exit 2; next }
        $0 == "---" { closed = 1; exit }
        { print }
        END { if (!closed) exit 3 }
    ' "$1"
}

frontmatter_keys() {
    frontmatter "$1" | awk '/^[A-Za-z][A-Za-z0-9_-]*:([[:space:]]|$)/ {
        key=$0; sub(/:.*/, "", key); print key
    }' | sort
}

frontmatter_has_exact_keys() {
    local file="$1" expected="$2" actual
    actual="$(frontmatter_keys "$file")" || return 1
    [ "$actual" = "$expected" ] || return 1
    [ "$(printf '%s\n' "$actual" | sort -u)" = "$actual" ] || return 1
}

# Public metadata fields are deliberately restricted to a non-empty, one-line
# plain scalar. This rejects YAML nulls, quoted/empty collections, comments, and block
# scalar markers whose bodies could be empty or ambiguous to shell validation.
frontmatter_value_nonempty() {
    local file="$1" key="$2" block value count lower
    block="$(frontmatter "$file")" || return 1
    count="$(printf '%s\n' "$block" | awk -v key="$key" '
        $0 ~ ("^" key ":[[:space:]]+") { n++ } END { print n + 0 }
    ')"
    [ "$count" -eq 1 ] || return 1
    value="$(printf '%s\n' "$block" | awk -v key="$key" '
        $0 ~ ("^" key ":[[:space:]]+") {
            line=$0
            sub("^" key ":[[:space:]]*", "", line)
            sub(/[[:space:]]+#.*/, "", line)
            gsub(/^[[:space:]]+|[[:space:]]+$/, "", line)
            print line
        }
    ')"
    [ -n "$value" ] || return 1
    lower="$(printf '%s' "$value" | tr '[:upper:]' '[:lower:]')"
    case "$lower" in
        '""'|"''"|'~'|'null'|'true'|'false'|'yes'|'no'|'on'|'off'|'.nan'|'.inf'|'+.inf'|'-.inf'|'|'|'|-'|'|+'|'>'|'>-'|'>+'|'[]'|'{}') return 1 ;;
    esac
    case "$value" in
        \#*|\"*|\'*|\[*|\{*|\]*|\}*|\!*|\&*|\**|\%*|\@*|\`*) return 1 ;;
    esac
    case "$value" in [[:alpha:]]*) ;; *) return 1 ;; esac
    printf '%s' "$value" | grep -qE ':[[:space:]]' && return 1
    return 0
}

canonical_frontmatter_valid() {
    local file="$1" block expected count
    block="$(frontmatter "$file")" || return 1
    count="$(frontmatter "$file" | awk 'END {print NR + 0}')" || return 1
    [ "$count" -eq 2 ] || return 1
    expected="$(printf '%s\n' description name | sort)"
    frontmatter_has_exact_keys "$file" "$expected" || return 1
    frontmatter_value_nonempty "$file" description || return 1
    printf '%s\n' "$block" | grep -qx 'name: sdlc-role'
}

kimi_frontmatter_valid() {
    local file="$1" block expected count arguments
    block="$(frontmatter "$file")" || return 1
    count="$(frontmatter "$file" | awk 'END {print NR + 0}')" || return 1
    [ "$count" -eq 6 ] || return 1
    expected="$(printf '%s\n' arguments description name type whenToUse | sort)"
    frontmatter_has_exact_keys "$file" "$expected" || return 1
    frontmatter_value_nonempty "$file" description || return 1
    frontmatter_value_nonempty "$file" whenToUse || return 1
    printf '%s\n' "$block" | grep -qx 'name: sdlc-role' || return 1
    printf '%s\n' "$block" | grep -qx 'type: prompt' || return 1
    arguments="$(printf '%s\n' "$block" | awk '/^arguments:/{inside=1; next} inside && /^[^ ]/{inside=0} inside && /^  - /{sub(/^  - /, ""); print}')"
    [ "$arguments" = "request" ]
}
