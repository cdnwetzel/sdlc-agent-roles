#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="$REPO_DIR/skills/sdlc-role"
CLAUDE_ROOT="${CLAUDE_HOME:-$HOME/.claude}"
DEST_DIR="$CLAUDE_ROOT/skills"
DEST="$DEST_DIR/sdlc-role"
MARKETPLACE="$CLAUDE_ROOT/local-plugins"
PLUGIN_NAME="sdlc-agent-roles"
LEGACY_NAME="claude-sdlc-roles"
source "$REPO_DIR/scripts/lib-frontmatter.sh"

MODE="install"
case "${1:-}" in
    --plugin) MODE="plugin" ;;
    --check) MODE="check" ;;
    --uninstall) MODE="uninstall" ;;
    --help|-h) echo "usage: $0 [--plugin|--check|--uninstall]"; exit 0 ;;
    "") ;;
    *) echo "ERROR: unknown option '$1'" >&2; exit 2 ;;
esac

owned_link() { [ -L "$1" ] && [ "$(readlink "$1")" = "$2" ]; }

check_skill() {
    if owned_link "$DEST" "$SRC"; then echo "installed: $DEST -> $SRC"; return 0
    elif [ -e "$DEST" ] || [ -L "$DEST" ]; then echo "CONFLICT: $DEST is not owned by this repo" >&2; return 1
    else echo "not installed: $DEST"; return 2; fi
}

if [ "$MODE" = "check" ]; then
    if check_skill; then rc=0; else rc=$?; fi
    plugin_link="$MARKETPLACE/plugins/$PLUGIN_NAME"
    if owned_link "$plugin_link" "$REPO_DIR"; then
        echo "plugin: $plugin_link -> $REPO_DIR"
    elif [ -e "$plugin_link" ] || [ -L "$plugin_link" ]; then
        echo "plugin CONFLICT: $plugin_link is not owned by this repo" >&2
        rc=1
    else
        echo "plugin not installed: $plugin_link"
    fi
    exit "$rc"
fi

remove_manifest_entry() {
    local manifest="$1" name="$2" source="$3"
    [ -f "$manifest" ] || return 0
    command -v python3 >/dev/null 2>&1 || { echo "  SKIPPED  manifest entry for $name — python3 unavailable" >&2; return 0; }
    python3 - "$manifest" "$name" "$source" <<'PY'
import json, sys
path, name, source = sys.argv[1:]
with open(path, encoding="utf-8") as f:
    data = json.load(f)
plugins = data.get("plugins", [])
kept = []
removed = False
for plugin in plugins:
    if plugin.get("name") == name and plugin.get("source") == source:
        removed = True
    else:
        kept.append(plugin)
data["plugins"] = kept
with open(path, "w", encoding="utf-8") as f:
    json.dump(data, f, indent=2)
    f.write("\n")
print("  removed  marketplace entry " + name if removed else "  note     marketplace entry already absent")
PY
}

if [ "$MODE" = "uninstall" ]; then
    if owned_link "$DEST" "$SRC"; then rm "$DEST"; echo "  removed  sdlc-role skill link"
    elif [ -e "$DEST" ] || [ -L "$DEST" ]; then echo "  SKIPPED  $DEST — not owned by this repo" >&2; fi

    manifest="$MARKETPLACE/.claude-plugin/marketplace.json"
    for name in "$PLUGIN_NAME" "$LEGACY_NAME"; do
        link="$MARKETPLACE/plugins/$name"
        if owned_link "$link" "$REPO_DIR"; then
            rm "$link"
            echo "  removed  plugin link $name"
            remove_manifest_entry "$manifest" "$name" "./plugins/$name"
            if command -v claude >/dev/null 2>&1; then
                claude plugin uninstall "$name@local-plugins" >/dev/null 2>&1 || true
            fi
        elif [ -e "$link" ] || [ -L "$link" ]; then
            echo "  SKIPPED  plugin link $name — not owned by this repo" >&2
        else
            if [ -f "$manifest" ] && grep -qF "\"$name\"" "$manifest"; then
                echo "  SKIPPED  plugin registration $name — no owned source link proves ownership" >&2
            fi
        fi
    done
    echo "Finished. Any SKIPPED entry above remains installed; restart Claude Code to apply removals."
    exit 0
fi

bash "$REPO_DIR/scripts/validate-cards.sh" -q
canonical_frontmatter_valid "$SRC/SKILL.md" \
    || { echo "ERROR: canonical SKILL.md requires exactly name and a safe one-line plain description" >&2; exit 1; }

if { [ -e "$DEST" ] || [ -L "$DEST" ]; } && ! owned_link "$DEST" "$SRC"; then
    echo "ERROR: $DEST exists and is not owned by this repo" >&2; exit 1
fi

plugin_link="$MARKETPLACE/plugins/$PLUGIN_NAME"
if [ "$MODE" = "plugin" ] && { [ -e "$plugin_link" ] || [ -L "$plugin_link" ]; } \
   && ! owned_link "$plugin_link" "$REPO_DIR"; then
    echo "ERROR: $plugin_link exists and is not owned by this repo" >&2; exit 1
fi

mkdir -p "$DEST_DIR"
if owned_link "$DEST" "$SRC"; then echo "  ok        sdlc-role (already linked)"
else ln -s "$SRC" "$DEST"; echo "  linked    sdlc-role"; fi

if [ "$MODE" = "plugin" ]; then
    command -v claude >/dev/null 2>&1 || { echo "ERROR: claude CLI is required for --plugin" >&2; exit 1; }
    command -v python3 >/dev/null 2>&1 || { echo "ERROR: python3 is required for --plugin" >&2; exit 1; }
    mkdir -p "$MARKETPLACE/plugins" "$MARKETPLACE/.claude-plugin"

    legacy_link="$MARKETPLACE/plugins/$LEGACY_NAME"
    if owned_link "$legacy_link" "$REPO_DIR"; then
        rm "$legacy_link"
        remove_manifest_entry "$MARKETPLACE/.claude-plugin/marketplace.json" "$LEGACY_NAME" "./plugins/$LEGACY_NAME"
        claude plugin uninstall "$LEGACY_NAME@local-plugins" >/dev/null 2>&1 || true
        echo "  migrated   legacy plugin name"
    elif [ -e "$legacy_link" ] || [ -L "$legacy_link" ]; then
        echo "  SKIPPED    foreign legacy plugin link" >&2
    fi

    manifest="$MARKETPLACE/.claude-plugin/marketplace.json"
    owner="${USER:-${LOGNAME:-local-user}}"
    python3 - "$manifest" "$PLUGIN_NAME" "$owner" <<'PY'
import json, os, sys
path, name, owner = sys.argv[1:]
if os.path.exists(path):
    with open(path, encoding="utf-8") as f:
        data = json.load(f)
else:
    data = {
        "$schema": "https://anthropic.com/claude-code/marketplace.schema.json",
        "name": "local-plugins",
        "description": "Personal local Claude Code plugins",
        "owner": {"name": owner},
        "plugins": [],
    }
plugins = data.setdefault("plugins", [])
matching = [p for p in plugins if p.get("name") == name]
source = f"./plugins/{name}"
if matching and any(p.get("source") != source for p in matching):
    raise SystemExit(f"ERROR: marketplace entry {name} has foreign source")
if not matching:
    plugins.append({
        "name": name,
        "description": "SDLC role cards and separation-of-duties gates.",
        "author": {"name": owner},
        "category": "development",
        "source": source,
    })
with open(path, "w", encoding="utf-8") as f:
    json.dump(data, f, indent=2)
    f.write("\n")
PY
    owned_link "$plugin_link" "$REPO_DIR" || ln -s "$REPO_DIR" "$plugin_link"
    add_out="$(claude plugin marketplace add "$MARKETPLACE" 2>&1)" || {
        printf '%s\n' "$add_out" >&2; echo "ERROR: marketplace registration failed" >&2; exit 1; }
    install_out="$(claude plugin install "$PLUGIN_NAME@local-plugins" 2>&1)" || {
        if ! printf '%s' "$install_out" | grep -qi already; then
            printf '%s\n' "$install_out" >&2; echo "ERROR: plugin registration failed" >&2; exit 1
        fi
    }
    echo "  registered $PLUGIN_NAME@local-plugins"
fi

echo "Done. Restart Claude Code to pick up the skill."
