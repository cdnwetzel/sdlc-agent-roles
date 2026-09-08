# Review directory inventory

`review/` is a shared workspace for multiple coding agents producing parallel, independent
perspectives on the repository's original Claude-only form. Each agent's files live in its own folder,
with filenames prefixed by that agent's name.

## Ownership rule (belt-and-suspenders)

An agent may write a file **only** if **both** are true:

1. The path is `review/<agent>/<agent>-*.md`
2. The agent's name is the filename's prefix

Both layers must agree. The folder boundary catches misfiled paths; the filename prefix catches
misfiled content. An agent does not edit another agent's files — not even for an obvious typo.
Surface it as a finding in your own namespace instead.

## Independence rule (project-local)

Lanes here run **blind to each other**. An agent must not read another agent's namespace during its
pass. This costs some duplicate effort and buys the only thing that makes a second lane worth
running: two findings that agree are corroboration rather than echo. Pass 1 confirmed the trade is
worth it — seven issues were found by both lanes independently, and each lane also caught defects
the other missed entirely.

Deduplication is the dispatcher's job, after both lanes land.

## Agent sections

### `claude/` — Fable 5

Baseline plus adversarial, in one pass. Strong on **arithmetic and durability**: caught the
7-person coverage column mapping hats onto eight distinct seats, and framed the central structural
problem as an enforcement gap rather than a content error — the README's claims were true but
nothing kept them true. Files: `claude-overview.md`, `claude-findings.md`,
`claude-adversarial.md`, `claude-passes.md`.

### `kimi/` — Kimi K3

Baseline plus adversarial, in one pass. Strong on **terminology and semantics**: caught
`reference/seat-map.md` giving "anchored" a second, incompatible definition — the highest-
consequence defect found in either lane, since that term gates what an agent may never do. Also
more precise than the other lane on seat drift (three semantic rows vs one). Files:
`kimi-overview.md`, `kimi-findings.md`, `kimi-adversarial.md`, `kimi-passes.md`.

One discarded Kimi pass reviewed the **wrong repository** — Kimi Code was invoked from a different
project's directory, so the output described that project instead of this one. It was originally
retained here as a sound review of its actual subject.

**Removed 2026-08-20.** It was a full adversarial security review of a private project, naming
severities and file:line locations for a dozen unfixed weaknesses. That does not belong in a repo
intended for publication, regardless of the directory it sits in. It has been deleted from the
working tree **and from this repo's history**, and preserved outside the repo for relocation to its
actual subject. Recorded here rather than silently dropped, because a review inventory that hides a
removed pass is not an inventory.

## Subject-specific safety notes

This repo's own scripts mutate state outside the working tree. During a review pass:

| Invocation | Safe? |
| --- | --- |
| `scripts/validate-cards.sh` | ✅ read-only by construction; writes nothing |
| `scripts/install-skills.sh --check` | ✅ reports only |
| `scripts/install-skills.sh` (default / `--plugin` / `--uninstall`) | ❌ symlinks into `~/.claude`, registers or removes a plugin |
| `scripts/build-skill-zips.sh` | ❌ writes `dist/`, deletes prior zips |

For the current release, reviewers should remain read-only and may run `validate-cards.sh`; the
deterministic lane owns the complete `build-all.sh` mutation/build gate.
