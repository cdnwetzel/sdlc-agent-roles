# Receipt: 2026-08-29–2026-09-03 — Codex — public release integration

## What was done

Codex integrated the multi-agent handoff into a publication-ready cross-platform repository. The
work converged Claude Code and Codex on one canonical skill, retained only Kimi's necessary native
wrapper, hardened the dispatcher authority boundary, added ownership-safe installers, and built an
exact-subject release receipt gate with adversarial fixtures.

The private pull-request review then drove a final professional-polish pass: checkout credentials
were disabled, receipt layers and redaction rules were clarified, platform routing gained a bounded
model-free smoke test, and high-risk role cards gained sharper evidence, consent, privacy, legal,
incident-command, release-exception, and approval-authority boundaries.

A temporary integration checkout was removed by system cleanup during the run. Codex reported the
loss, reconstructed the candidate from the untouched source worktree in a persistent workspace, and
reran all evidence instead of treating lost results as current.

## Agent(s) involved

- Primary integration agent: Codex
- Text-polish and adapter handoff: Kimi Code
- Independent review and nested one-shot review: Claude Code
- Local model-backed review: PXX NativeReviewer
- Hosted pull-request review: CodeRabbit and GitHub Copilot
- Human author and release owner: Chris Wetzel

## Human steering

Chris required a polished public release that can withstand scrutiny; visible advice versus artistic
judgment; receipts for Codex, Claude, Kimi, and nested invocations; and shared ownership across all
three agents. Codex was authorized to own the final commit, push, and release workflow.

## Advice given

- Use one canonical core rather than three behavioral copies.
- Make role adoption explicit and prevent role cards from creating write or approval authority.
- Bind each review receipt to the exact staged payload digest.
- Preserve failed, unavailable, and superseded reviews without counting them as approval.
- Prove installer ownership and frontmatter failure modes with isolated mutation fixtures.
- Keep deterministic gate results unchanged; represent any policy-permitted release exception as a
  separate, attributed, expiring human decision.
- Make evidence handoffs safe to publish by requiring redacted output or a controlled internal link.

## Advice taken / rejected

- **Taken:** canonical core, Kimi-only native wrapper, explicit role framing, authority guards,
  exact-subject receipts, clean public history, ownership-safe installers, and deterministic gates.
- **Taken:** CodeRabbit's substantive recommendations on CI credential handling, receipt-layer
  clarity, disambiguation, evidence redaction, accessibility claims, lower-environment data,
  research consent, license-specific AGPL analysis, incident command, and release authority.
- **Rejected:** absolute adapter links, redundant Claude/Codex shims, implicit role inference,
  unconditional “write the artifact” behavior, brittle file-count prose, and advisory review results
  presented as approval.
- **Rejected:** a generic docstring-coverage warning for Bash helpers, because comments describe the
  non-obvious behavior and synthetic docstrings would reduce rather than improve readability.
- **Rejected:** PXX's recommendation to remove the model-free adapter smoke, because it directly
  proves the native invocation strings and shared dispatcher routing identified during PR review.

## Artistic strokes

- Chris's phrase **“The prohibitions are the point”** remains the project's center of gravity.
- Chris's phrase **“Roles are functions, not headcount”** defines the seat-map model.
- Chris chose public receipts as part of the product's professional surface, not merely internal logs.
- Chris requires agent advice to remain visible while retaining final authorship and judgment.
- Chris required Claude, Kimi, and Codex to share ownership of the polish pass while Codex remained
  accountable for integration, release, installation, and the final public record.

## Validation

- Structural, adapter, installer, receipt, and packaging gates are implemented in `scripts/build-all.sh`.
- The private pull request was reviewed before publication; accepted findings and superseded model
  verdicts remain visible under `review/v1.1.0/` rather than being rewritten as a clean first pass.
- Fresh exact-candidate review receipts are written under the active release directory only after the
  payload freezes; earlier candidates and failed invocations remain explicitly excluded or
  non-admissible.

## Files changed

- `skills/sdlc-role/` — canonical cross-platform skill and authority-safe dispatcher.
- `agents/kimi/sdlc-role/` — native Kimi wrapper with portable relative links.
- `scripts/` — validation, installer, packaging, receipt, and adversarial fixture gates.
- `review/` and `receipts/` — public provenance and exact-candidate review evidence.
- Repository meta files — public licensing, security, contribution, CI, and host guidance.
