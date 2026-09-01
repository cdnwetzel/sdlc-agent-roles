# Historical review workspace

This directory preserves the original two-lane review that predated the public
`sdlc-agent-roles` release process. See `inventory.md` for its independence rules. Current release
evidence is controlled by `CURRENT`, `RECEIPTS.md`, and the selected version directory.

## Pass 1 — 2026-08-19, subject `36ab6aa`

| Lane | Model | Findings | Namespace |
| --- | --- | --- | --- |
| `claude/` | Fable 5 | 2×P1, 7×P2 | `claude-*.md` |
| `kimi/` | Kimi K3 | 3×P1, 6×P2 | `kimi-*.md` |

Neither lane found a P0. Seven issues were found by **both** lanes independently — the dishonest
`--plugin` success report, the missing plugin manifest, the packager's half-validation,
`--uninstall` not undoing `--plugin`, whole-file frontmatter greps, seat values scattered across
sources, and the inert `metadata.triggers` block.

Each lane also found what the other missed. Fable: the 7-person column's seat arithmetic, and the
absence of any script enforcing the README's structural claims. Kimi: `seat-map.md` redefining
"anchored", the skill description's role count not reconciling, and two more semantic seat-drift
rows than Fable reported.

**Disposition:** all P1 and P2 findings from both lanes were resolved in the version committed
after this pass. The findings files are retained as written — including the adversarial logs'
record of which attacks *held*, which is the evidence behind the Status section's green claims.

The durable outcome is `scripts/validate-cards.sh`: it mechanically re-derives the structural and
authority-boundary claims. Every installer and packager runs it with `bash` and refuses to proceed
on failure.

These files are historical evidence, not approval of the current release subject.
