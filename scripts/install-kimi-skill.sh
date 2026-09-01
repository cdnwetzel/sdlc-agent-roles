#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="$REPO_DIR/agents/kimi/sdlc-role"
DEST_DIR="${KIMI_CODE_HOME:-$HOME/.kimi-code}/skills"
DEST="$DEST_DIR/sdlc-role"
source "$REPO_DIR/scripts/lib-frontmatter.sh"

MODE="install"
case "${1:-}" in
    --check) MODE="check" ;;
    --uninstall) MODE="uninstall" ;;
    --help|-h) echo "usage: $0 [--check|--uninstall]"; exit 0 ;;
    "") ;;
    *) echo "ERROR: unknown option '$1'" >&2; exit 2 ;;
esac

owned() { [ -L "$DEST" ] && [ "$(readlink "$DEST")" = "$SRC" ]; }

if [ "$MODE" = "check" ]; then
    if owned; then echo "installed: $DEST -> $SRC"; exit 0
    elif [ -e "$DEST" ] || [ -L "$DEST" ]; then echo "CONFLICT: $DEST is not owned by this repo" >&2; exit 1
    else echo "not installed: $DEST"; exit 2; fi
fi

if [ "$MODE" = "uninstall" ]; then
    if owned; then rm "$DEST"; echo "removed: $DEST"
    elif [ -e "$DEST" ] || [ -L "$DEST" ]; then echo "SKIPPED: $DEST is not owned by this repo" >&2
    else echo "already absent: $DEST"; fi
    echo "Finished. Any SKIPPED entry above remains installed; restart Kimi Code to apply removals."
    exit 0
fi

[ -f "$SRC/SKILL.md" ] || { echo "ERROR: missing Kimi wrapper" >&2; exit 1; }
bash "$REPO_DIR/scripts/validate-cards.sh" -q
kimi_frontmatter_valid "$SRC/SKILL.md" \
    || { echo "ERROR: Kimi SKILL.md differs from the exact safe native schema" >&2; exit 1; }

if owned; then echo "already installed: $DEST -> $SRC"; exit 0; fi
if [ -e "$DEST" ] || [ -L "$DEST" ]; then
    echo "ERROR: $DEST exists and is not owned by this repo" >&2; exit 1
fi
mkdir -p "$DEST_DIR"
ln -s "$SRC" "$DEST"
echo "installed: $DEST -> $SRC"
