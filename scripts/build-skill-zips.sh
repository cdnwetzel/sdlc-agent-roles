#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="$REPO_DIR/skills/sdlc-role"
DIST="$REPO_DIR/dist"
OUT="$DIST/sdlc-role.zip"
source "$REPO_DIR/scripts/lib-frontmatter.sh"

command -v zip >/dev/null 2>&1 || { echo "ERROR: zip is required" >&2; exit 1; }
command -v unzip >/dev/null 2>&1 || { echo "ERROR: unzip is required" >&2; exit 1; }
bash "$REPO_DIR/scripts/validate-cards.sh" -q
canonical_frontmatter_valid "$SRC/SKILL.md" \
    || { echo "ERROR: canonical SKILL.md requires exactly name and a safe one-line plain description" >&2; exit 1; }

mkdir -p "$DIST"
rm -f "$OUT"
(cd "$REPO_DIR/skills" && zip -q -r "$OUT" sdlc-role -x '*/.*' '*.DS_Store')
listing="$(unzip -Z1 "$OUT")"
[ "$(printf '%s\n' "$listing" | cut -d/ -f1 | sort -u)" = "sdlc-role" ] \
    || { echo "ERROR: archive has entries outside sdlc-role/" >&2; exit 1; }
printf '%s\n' "$listing" | grep -qx 'sdlc-role/SKILL.md' \
    || { echo "ERROR: archive lacks root SKILL.md" >&2; exit 1; }
files="$(printf '%s\n' "$listing" | grep -cv '/$' || true)"
echo "built: $OUT ($files files)"
