#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ROOT="$(mktemp -d "${TMPDIR:-/tmp}/sdlc-adapters.XXXXXX")"
ROOT="$(cd "$ROOT" && pwd -P)"
trap 'rm -rf "$ROOT"' EXIT
FIXTURE="$ROOT/repo"
mkdir -p "$FIXTURE"
cp -R "$REPO_DIR/." "$FIXTURE/"
rm -rf "$FIXTURE/.git" "$FIXTURE/dist"

passed=0
ok() { passed=$((passed + 1)); }
must_fail() { "$@" >/dev/null 2>&1 && { echo "FAIL: unexpectedly succeeded: $*" >&2; exit 1; } || true; }

# Put an inert Claude CLI first on PATH before any installer can attempt plugin cleanup.
mkdir -p "$ROOT/bin"
cat > "$ROOT/bin/claude" <<'SH'
#!/usr/bin/env bash
exit 0
SH
chmod +x "$ROOT/bin/claude"
export PATH="$ROOT/bin:$PATH"

bash "$FIXTURE/scripts/validate-cards.sh" -q >/dev/null
ok

# Happy paths, idempotence, check, and full inverse in isolated homes.
CLAUDE_HOME="$ROOT/claude" bash "$FIXTURE/scripts/install-skills.sh" >/dev/null
CLAUDE_HOME="$ROOT/claude" bash "$FIXTURE/scripts/install-skills.sh" >/dev/null
CLAUDE_HOME="$ROOT/claude" bash "$FIXTURE/scripts/install-skills.sh" --check >/dev/null
CODEX_HOME="$ROOT/codex" bash "$FIXTURE/scripts/install-codex-skills.sh" >/dev/null
CODEX_HOME="$ROOT/codex" bash "$FIXTURE/scripts/install-codex-skills.sh" >/dev/null
CODEX_HOME="$ROOT/codex" bash "$FIXTURE/scripts/install-codex-skills.sh" --check >/dev/null
KIMI_CODE_HOME="$ROOT/kimi" bash "$FIXTURE/scripts/install-kimi-skill.sh" >/dev/null
KIMI_CODE_HOME="$ROOT/kimi" bash "$FIXTURE/scripts/install-kimi-skill.sh" >/dev/null
KIMI_CODE_HOME="$ROOT/kimi" bash "$FIXTURE/scripts/install-kimi-skill.sh" --check >/dev/null
CLAUDE_HOME="$ROOT/claude" bash "$FIXTURE/scripts/install-skills.sh" --uninstall >/dev/null
CODEX_HOME="$ROOT/codex" bash "$FIXTURE/scripts/install-codex-skills.sh" --uninstall >/dev/null
KIMI_CODE_HOME="$ROOT/kimi" bash "$FIXTURE/scripts/install-kimi-skill.sh" --uninstall >/dev/null
[ ! -e "$ROOT/claude/skills/sdlc-role" ] && [ ! -e "$ROOT/codex/skills/sdlc-role" ] && [ ! -e "$ROOT/kimi/skills/sdlc-role" ]
ok

# Non-symlinks and foreign symlinks are never overwritten or removed.
mkdir -p "$ROOT/foreign" "$ROOT/foreign-claude/skills" "$ROOT/foreign-codex/skills" "$ROOT/foreign-kimi/skills"
ln -s "$ROOT/foreign" "$ROOT/foreign-claude/skills/sdlc-role"
ln -s "$ROOT/foreign" "$ROOT/foreign-codex/skills/sdlc-role"
ln -s "$ROOT/foreign" "$ROOT/foreign-kimi/skills/sdlc-role"
must_fail env CLAUDE_HOME="$ROOT/foreign-claude" bash "$FIXTURE/scripts/install-skills.sh"
must_fail env CODEX_HOME="$ROOT/foreign-codex" bash "$FIXTURE/scripts/install-codex-skills.sh"
must_fail env KIMI_CODE_HOME="$ROOT/foreign-kimi" bash "$FIXTURE/scripts/install-kimi-skill.sh"
CLAUDE_HOME="$ROOT/foreign-claude" bash "$FIXTURE/scripts/install-skills.sh" --uninstall >/dev/null 2>&1
CODEX_HOME="$ROOT/foreign-codex" bash "$FIXTURE/scripts/install-codex-skills.sh" --uninstall >/dev/null 2>&1
KIMI_CODE_HOME="$ROOT/foreign-kimi" bash "$FIXTURE/scripts/install-kimi-skill.sh" --uninstall >/dev/null 2>&1
[ "$(readlink "$ROOT/foreign-claude/skills/sdlc-role")" = "$ROOT/foreign" ]
[ "$(readlink "$ROOT/foreign-codex/skills/sdlc-role")" = "$ROOT/foreign" ]
[ "$(readlink "$ROOT/foreign-kimi/skills/sdlc-role")" = "$ROOT/foreign" ]
ok

# Kimi's archive/install links are relative and resolve inside this checkout.
for item in dispatcher.md ROLES.md roles reference; do
    target="$(readlink "$FIXTURE/agents/kimi/sdlc-role/$item")"
    case "$target" in /*) echo "FAIL: absolute Kimi link: $item" >&2; exit 1 ;; esac
    [ -e "$FIXTURE/agents/kimi/sdlc-role/$item" ]
done
ok

# Plugin ownership and legacy-name migration fixtures use the inert CLI above.
plugin_home="$ROOT/plugin-claude"
mkdir -p "$plugin_home/local-plugins/plugins" "$plugin_home/local-plugins/.claude-plugin"
ln -s "$FIXTURE" "$plugin_home/local-plugins/plugins/claude-sdlc-roles"
cat > "$plugin_home/local-plugins/.claude-plugin/marketplace.json" <<'JSON'
{"name":"local-plugins","plugins":[{"name":"claude-sdlc-roles","source":"./plugins/claude-sdlc-roles"}]}
JSON
env -u USER -u LOGNAME PATH="$ROOT/bin:$PATH" CLAUDE_HOME="$plugin_home" bash "$FIXTURE/scripts/install-skills.sh" --plugin >/dev/null
[ ! -e "$plugin_home/local-plugins/plugins/claude-sdlc-roles" ]
[ "$(readlink "$plugin_home/local-plugins/plugins/sdlc-agent-roles")" = "$FIXTURE" ]
PATH="$ROOT/bin:$PATH" CLAUDE_HOME="$plugin_home" bash "$FIXTURE/scripts/install-skills.sh" --uninstall >/dev/null
ok

foreign_plugin="$ROOT/foreign-plugin"
mkdir -p "$foreign_plugin/local-plugins/plugins"
ln -s "$ROOT/foreign" "$foreign_plugin/local-plugins/plugins/sdlc-agent-roles"
must_fail env PATH="$ROOT/bin:$PATH" CLAUDE_HOME="$foreign_plugin" bash "$FIXTURE/scripts/install-skills.sh" --plugin
[ "$(readlink "$foreign_plugin/local-plugins/plugins/sdlc-agent-roles")" = "$ROOT/foreign" ]
ok

# Every product caller uses bash, so lost executable bits do not bypass or break validation.
chmod -x "$FIXTURE/scripts/validate-cards.sh"
bash "$FIXTURE/scripts/validate-cards.sh" -q >/dev/null
CLAUDE_HOME="$ROOT/mode-claude" bash "$FIXTURE/scripts/install-skills.sh" >/dev/null
CODEX_HOME="$ROOT/mode-codex" bash "$FIXTURE/scripts/install-codex-skills.sh" >/dev/null
KIMI_CODE_HOME="$ROOT/mode-kimi" bash "$FIXTURE/scripts/install-kimi-skill.sh" >/dev/null
bash "$FIXTURE/scripts/build-skill-zips.sh" >/dev/null
if direct="$(grep -R -n -E '^[[:space:]]*"\$REPO_DIR/scripts/validate-cards\.sh"' "$FIXTURE/scripts")"; then
    echo "FAIL: direct validator execution remains: $direct" >&2; exit 1
else
    rc=$?
    [ "$rc" -eq 1 ] || { echo "FAIL: direct-execution scan failed (grep $rc)" >&2; exit 1; }
fi
ok

# Canonical frontmatter attacks must fail every canonical consumer and Kimi's preflight.
canonical="$FIXTURE/skills/sdlc-role/SKILL.md"
cp "$canonical" "$ROOT/canonical.good"
replace_description() {
    awk -v replacement="$1" '/^description:/{print replacement; next} {print}' "$ROOT/canonical.good" > "$canonical"
}
reject_canonical() {
    local failures="$ROOT/unexpected-success.$passed"
    (bash "$FIXTURE/scripts/validate-cards.sh" -q >/dev/null 2>&1 && echo validator >> "$failures" || true) &
    (CLAUDE_HOME="$ROOT/bad-claude" bash "$FIXTURE/scripts/install-skills.sh" >/dev/null 2>&1 && echo claude >> "$failures" || true) &
    (CODEX_HOME="$ROOT/bad-codex" bash "$FIXTURE/scripts/install-codex-skills.sh" >/dev/null 2>&1 && echo codex >> "$failures" || true) &
    (KIMI_CODE_HOME="$ROOT/bad-kimi" bash "$FIXTURE/scripts/install-kimi-skill.sh" >/dev/null 2>&1 && echo kimi >> "$failures" || true) &
    (bash "$FIXTURE/scripts/build-skill-zips.sh" >/dev/null 2>&1 && echo packager >> "$failures" || true) &
    wait
    if [ -s "$failures" ]; then
        echo "FAIL: malformed canonical frontmatter accepted by: $(tr '\n' ' ' < "$failures")" >&2
        exit 1
    fi
    ok
}
for value in 'description:foo' 'description:  ' 'description: null' 'description: true' 'description: false' 'description: 123' 'description: foo: bar' 'description: ""' 'description: # comment' 'description: |' 'description: >-' 'description: []' 'description: {}' 'description: &x' 'description: *x' 'description: !!str ""'; do
    replace_description "$value"
    reject_canonical
done
cp "$ROOT/canonical.good" "$canonical"
awk 'NR==3{print "garbage"} {print}' "$ROOT/canonical.good" > "$canonical"
reject_canonical
cp "$ROOT/canonical.good" "$canonical"
awk 'NR==3{print "description: duplicate"} {print}' "$ROOT/canonical.good" > "$canonical"
reject_canonical
cp "$ROOT/canonical.good" "$canonical"
awk 'NR==3{print "metadata: extra"} {print}' "$ROOT/canonical.good" > "$canonical"
reject_canonical
cp "$ROOT/canonical.good" "$canonical"
awk 'BEGIN{n=0} $0=="---"{n++; if(n==2) next} {print}' "$ROOT/canonical.good" > "$canonical"
reject_canonical
cp "$ROOT/canonical.good" "$canonical"

# Kimi-native schema attacks are independently rejected.
kimi="$FIXTURE/agents/kimi/sdlc-role/SKILL.md"
cp "$kimi" "$ROOT/kimi.good"
awk 'NR==3{print "extra: forbidden"} {print}' "$ROOT/kimi.good" > "$kimi"
must_fail env KIMI_CODE_HOME="$ROOT/bad-kimi2" bash "$FIXTURE/scripts/install-kimi-skill.sh"
ok
awk '/^whenToUse:/{print "whenToUse: null"; next} {print}' "$ROOT/kimi.good" > "$kimi"
must_fail env KIMI_CODE_HOME="$ROOT/bad-kimi3" bash "$FIXTURE/scripts/install-kimi-skill.sh"
ok
awk '/^whenToUse:/{print "whenToUse: true"; next} {print}' "$ROOT/kimi.good" > "$kimi"
must_fail env KIMI_CODE_HOME="$ROOT/bad-kimi4" bash "$FIXTURE/scripts/install-kimi-skill.sh"
ok
awk 'NR==3{print "garbage"} {print}' "$ROOT/kimi.good" > "$kimi"
must_fail env KIMI_CODE_HOME="$ROOT/bad-kimi5" bash "$FIXTURE/scripts/install-kimi-skill.sh"
ok
cp "$ROOT/kimi.good" "$kimi"

echo "Platform adapter fixtures passed ($passed checks)."
