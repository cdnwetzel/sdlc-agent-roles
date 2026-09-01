# Receipt: 2026-08-20 — Kimi — agent-agnostic shim refactor

## What was done

Refactored the original Claude-only repo from agent-specific skill copies into an agent-agnostic
framework with thin shims. The original Claude `SKILL.md` dispatcher logic was extracted into a
shared `skills/sdlc-role/dispatcher.md`, and Claude/Kimi/Codex adapters were created under `agents/`.
The old `kimi-port/` directory was removed in favor of `agents/kimi/sdlc-role/`. Build, install, and
validation scripts were updated to use the new adapter layout.

## Agent(s) involved

- Primary agent: Kimi Code CLI
- Nested agent invocations:
  - `Skill(sdlc-role, list)` — tested the Kimi shim/dispatcher resolution.
  - `Skill(sdlc-role, code-reviewer)` — verified the dispatcher loads a role card and states the hat.

## Human steering

The maintainer asked for help with three parallel ports (Claude original, Kimi existing, Codex in
flight) and with Codex's suggestion of a thin shim for agent-agnostic use. The maintainer also
stated the overarching rule that public work must keep receipts and distinguish agent advice from
human artistic strokes.

## Advice given

1. **Adopt a thin-shim architecture with a shared dispatcher.** Keep one canonical core
   (`skills/sdlc-role/`) and give each agent only frontmatter plus a pointer to the shared dispatcher.
   This removes duplication of the 38 role cards and resolution rules.
2. **Keep `skills/sdlc-role/` as the canonical core and Claude entry point** rather than moving it
   into a platform wrapper. This preserves the existing Claude install/zip path with minimal churn.
3. **Use absolute symlinks inside the Kimi/Codex adapters** so the installed adapter directory works
   when symlinked into `~/.kimi-code/skills/`.
4. **Add adapter validation** to `scripts/validate-cards.sh`.
5. **Create `scripts/build-all.sh`** as a one-command validate-and-build entry point.

## Advice taken / rejected

- **Taken:** The shared dispatcher, canonical core, adapter validation, and one-command build gate.
- **Rejected:** Absolute links were replaced with portable relative Kimi links. Redundant Claude and
  Codex wrappers were removed because both hosts consume the canonical skill directly. Implicit role
  inference and role-driven write instructions were rejected because a role cannot expand authority.
  Hard-coded file counts were removed because deterministic validation is stronger than a brittle
  inventory claim.

## Artistic strokes

- **The maintainer's rule that public work must keep receipts and distinguish advice from artistic
  judgment** is the reason this file and `docs/provenance.md` exist. The agent advised the mechanics
  of a shim architecture; the decision to make provenance a first-class project requirement is the
  maintainer's own.
- **Refusing a hard-coded public file count** is the maintainer's final judgment: meaningful
  invariants belong in the README; incidental inventory does not.
- **The final voice and authority boundary** are maintainer-owned: “The prohibitions are the point”
  and “Roles are functions, not headcount” remain, while every adapter is explicitly subordinate to
  the user's authorization and repository governance.

## Validation

- This receipt records the original handoff validation. Its approvals are historical and excluded
  from the v1.1.0 release gate because the payload changed materially afterward.
- `bash scripts/install-skills.sh --check` — Claude adapter installed and resolves to canonical core.
- `bash scripts/install-kimi-skill.sh --check` — Kimi adapter installed to `~/.kimi-code/skills/sdlc-role`.
- `Skill(sdlc-role, list)` — Kimi shim loaded dispatcher and printed the role index.
- `Skill(sdlc-role, code-reviewer)` — Kimi shim loaded the code-reviewer card and stated the hat.

## Files changed

See the staged git diff for the full list. Key files:

- `skills/sdlc-role/dispatcher.md` — new shared dispatcher.
- `skills/sdlc-role/SKILL.md` — Claude thin shim.
- `agents/kimi/sdlc-role/SKILL.md` — Kimi thin shim.
- `skills/sdlc-role/agents/openai.yaml` — later replaced the redundant Codex shim.
- `scripts/validate-cards.sh` — adapter and authority validation, subsequently expanded.
- `scripts/build-skill-zips.sh`, `scripts/install-skills.sh`, `scripts/install-kimi-skill.sh` — updated for adapter layout.
- `scripts/build-all.sh` — new validate-and-build command.
- `README.md` — documents the final canonical-core architecture without a hard-coded file count.
- `docs/provenance.md`, `receipts/TEMPLATE.md`, and this receipt — new provenance infrastructure.
