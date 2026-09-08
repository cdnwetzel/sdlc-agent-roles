# Platform adapters

The canonical skill is `skills/sdlc-role/`. Claude Code and Codex consume that directory directly.
Kimi Code uses the wrapper at `agents/kimi/sdlc-role/`, whose relative symlinks point back to the
canonical dispatcher, role index, cards, and reference documents.

## Invocation

- **Claude Code:** invoke `/sdlc-role ...`; `SKILL.md` routes to `dispatcher.md`.
- **Codex:** invoke `$sdlc-role ...`; `agents/openai.yaml` supplies the interface metadata and disables
  implicit invocation.
- **Kimi Code:** invoke `/skill:sdlc-role ...`; the Kimi wrapper translates `$request` to `${REQUEST}`
  and routes to the same `dispatcher.md`.

The adapters do not change authority. They only translate native invocation and metadata into one
shared behavioral contract. Repository-local governance and each host agent's authorization rules
remain controlling.
