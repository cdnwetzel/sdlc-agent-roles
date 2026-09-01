# Skills

Reusable lifecycle-role skills for Claude Code, Codex, and Kimi Code, with a canonical core that can
also be uploaded to claude.ai.

| Skill | What it does |
| --- | --- |
| `sdlc-role` | 38 software-lifecycle role cards with mandates, inputs, outputs, done-criteria, and separation-of-duties constraints; plus the seat map for 6–9 person teams and the handoff packet templates |

## Install (Claude Code CLI — all projects)

```bash
bash scripts/install-skills.sh            # symlink into ~/.claude/skills
bash scripts/install-skills.sh --check    # report state, change nothing
bash scripts/install-skills.sh --plugin   # additionally register as a local plugin
bash scripts/install-skills.sh --uninstall
```

Symlinks, not copies — a `git pull` updates the installed skill. Restart Claude Code after installing.

## Install (Codex)

```bash
bash scripts/install-codex-skills.sh
```

Use `$sdlc-role <request>`. Codex metadata disables implicit invocation.

## Install (Kimi Code)

```bash
bash scripts/install-kimi-skill.sh
```

Use `/skill:sdlc-role <request>`. The native wrapper points to the canonical core with relative links.

## Install (claude.ai web / desktop)

```bash
bash scripts/build-skill-zips.sh          # -> dist/<skill>.zip
```

Then **Settings → Capabilities → Skills → Upload skill** and select the zip. Skills uploaded to
claude.ai apply account-wide rather than per-project, and the same `SKILL.md` drives both surfaces.

## Authoring contract

The deterministic gates enforce the mechanical parts of this contract; review owns semantic quality:

1. `SKILL.md` at the root of the skill directory.
2. YAML frontmatter on line 1, with `name:` exactly equal to the directory name, and a `description:`.
3. The one-line plain description states both *what* the skill does and *when* to use it. Review
   checks that semantic claim; the scripts enforce its presence and safe shape.
4. Supporting files use canonical in-tree paths or portable relative adapter links. The adapter and
   archive fixtures mechanically verify the shipped layouts.

## Relationship to project-local governance

`sdlc-role` describes the *shape* of each role. Where a repository declares its own assignments,
those win — `docs/agent-team.md`, `CONTRIBUTING.md`, `WORKFLOW.md`, `CLAUDE.md`, and `CODEOWNERS`.
`dispatcher.md` instructs the model to check for those before working. A role changes the operating
constraint, never the authority granted by the user or host agent.

It also defers rather than duplicates for code review: the host's configured review framework owns
findings lifecycle, severity, and pass logs; the `code-reviewer` card defines the role around it.
