# sdlc-agent-roles

Reusable software-lifecycle roles for Claude Code, Codex, and Kimi Code. One canonical skill, 38 role
cards, native adapters, separation-of-duties gates, and public release receipts.

## What this is

Thirty-eight lifecycle role *functions* — not headcount — each as a loadable card carrying that
role's mandate, required inputs, output artifacts, definition of done, and prohibitions.

The prohibitions are the point. Anyone can be told "review this code"; the value is knowing that the
author must not be the sole reviewer, and refusing when asked to be both.

---

## Install — Claude Code CLI (all projects)

```bash
git clone https://github.com/cdnwetzel/sdlc-agent-roles.git ~/ai/sdlc-agent-roles
bash ~/ai/sdlc-agent-roles/scripts/install-skills.sh
```

| Command | Effect |
| --- | --- |
| `install-skills.sh` | Symlink each skill into `~/.claude/skills` |
| `install-skills.sh --check` | Report install state, change nothing |
| `install-skills.sh --plugin` | Additionally register as a local plugin marketplace entry |
| `install-skills.sh --uninstall` | Remove only skill and plugin artifacts whose current links prove ownership by this checkout |

Symlinks, not copies — `git pull` updates the installed skill. Restart Claude Code afterwards.

## Install — Codex

```bash
cd ~/ai/sdlc-agent-roles
bash scripts/install-codex-skills.sh
```

This links the canonical skill into `${CODEX_HOME:-~/.codex}/skills`. Use `--check` to inspect and
`--uninstall` to remove only a link owned by this checkout.

## Install — Kimi Code

```bash
cd ~/ai/sdlc-agent-roles
bash scripts/install-kimi-skill.sh
```

This links Kimi's native wrapper into `${KIMI_CODE_HOME:-~/.kimi-code}/skills`. The wrapper uses
portable relative links to the canonical dispatcher and cards.

## Install — claude.ai web / desktop

```bash
bash scripts/build-skill-zips.sh    # -> dist/sdlc-role.zip
```

Upload at **Settings → Capabilities → Skills → Upload skill**. Skills uploaded to claude.ai apply
account-wide rather than per-project; the same `SKILL.md` drives both surfaces.

## Usage

| Host | Invocation |
| --- | --- |
| Claude Code | `/sdlc-role security-architect` |
| Codex | `$sdlc-role security-architect` |
| Kimi Code | `/skill:sdlc-role security-architect` |

The request can also be `team 7`, `handoff`, or `list`. Role adoption is explicit: a normal unframed
task never silently acquires a role or the authority associated with one.

---

# Document library

Every card follows the same nine-section schema: **Mandate · Inputs required · Outputs ·
Operating checklist · Definition of done · Must not (separation of duties) · Failure modes · Handoff ·
Related.**

`Fit` is how well the function delegates to an automated worker — **High** (mostly mechanical given
good inputs), **Partial** (agent drafts, human decides), **Anchored** (requires a named accountable
human; the agent prepares material only). `Seat` is the seat carrying the hat on a 9-person team.

## Skill entry points

| File | Purpose |
| --- | --- |
| `skills/sdlc-role/dispatcher.md` | The shared, agent-neutral dispatcher. Resolves a request to a role, states the hat and the constraint binding it, enforces the multi-hat and separation-of-duties rules, and defers to repo-local governance. |
| `skills/sdlc-role/SKILL.md` | Canonical Claude/Codex skill entry point. Loads `dispatcher.md`. |
| `skills/sdlc-role/ROLES.md` | Index of all 38 slugs grouped by phase with fit and seat, plus a "picking a role from the work" table. Read first when the requested slug is not an exact match. |
| `agents/kimi/sdlc-role/SKILL.md` | Kimi shim. Loads `dispatcher.md` and treats this directory as `${SKILL_DIR}`. |
| `skills/sdlc-role/agents/openai.yaml` | Codex interface metadata; explicit invocation only. |
| `skills/README.md` | Cross-platform install overview and canonical authoring contract. |

## Reference

| File | Purpose |
| --- | --- |
| `reference/seat-map.md` | Hats mapped onto seats for 9-, 7-, and 6-person teams; full 38-row coverage matrix; what actually breaks at each headcount cut; on-call shape; how the mapping applies to agents. |
| `reference/separation-of-duties.md` | The five invariants with enforcement at 6 people, the two supporting rules, the anchored-role may/may-not table, and the four-question self-check before signing anything. |
| `reference/handoff.md` | Templates: task admission record, implementation handoff, gate handoff, role-switch marker, escalation. |
| `reference/platform-adapters.md` | Native invocation and authority-boundary mapping for Claude Code, Codex, and Kimi Code. |

## Role cards — Plan & discover

| File | Role | Fit | Seat | Purpose |
| --- | --- | --- | --- | --- |
| `roles/product-manager.md` | Product Manager / Owner | Partial | S1 | Owns the why and the priority order. Enforces falsifiable success measures, written non-goals, and decline records for rejected work. |
| `roles/business-analyst.md` | Business Analyst | Partial | S1 | Turns fuzzy wants into testable acceptance criteria judgeable without the author, plus an exception register with each entry dispositioned. |
| `roles/domain-sme.md` | Domain / Subject-Matter Expert | Anchored | Borrowed | Supplies domain ground truth with cited authority. Agent drafts the domain model and question list; it never confirms a domain fact. |
| `roles/ux-researcher.md` | UX Researcher | Partial | S9 | Studies tasks before design starts and reports disconfirmed assumptions first. Never generates synthetic participants or quotes. |
| `roles/delivery-manager.md` | Program / Delivery Manager | Partial | S2 | Owns critical path and dependencies chased to a named person with a date; schedules borrowed anchored-role checkpoints as recurring, not ad hoc. |
| `roles/engineering-manager.md` | Engineering Manager | Anchored | S2 | Owns people and capacity net of interrupt load, and names the hats the team is choosing not to cover. Never assesses a named person. |
| `roles/scrum-master.md` | Scrum Master / Agile Coach | Partial | S2 | Owns flow mechanics; reports cycle time as a distribution and checks the previous retro's actions before adding new ones. |

## Role cards — Design & architect

| File | Role | Fit | Seat | Purpose |
| --- | --- | --- | --- | --- |
| `roles/solution-architect.md` | Solution / Enterprise Architect | Partial | S3 | Defines decomposition, boundaries, and numeric non-functional targets. ADRs must record rejected options and what would trigger a revisit. |
| `roles/tech-lead.md` | Tech Lead / Staff Engineer | Partial | S3 | Turns architecture into executable units via the seven-field task admission record; forbids concurrent overlapping write scopes. |
| `roles/data-architect.md` | Data Architect / Modeler | Partial | S5 | Owns canonical entity definitions with one authoritative source each; designs deletion and retention alongside the schema, not after. |
| `roles/security-architect.md` | Security Architect | Partial | S3 | Draws trust boundaries first and specifies fail-closed at each; classifies every configurable endpoint as a data-egress surface; declares the protected-path set. |
| `roles/ux-designer.md` | UX / UI Designer | Partial | S9 | Designs the failure states first — empty, loading, partial, error, permission-denied — and builds accessibility in as a design constraint. |

## Role cards — Build

| File | Role | Fit | Seat | Purpose |
| --- | --- | --- | --- | --- |
| `roles/backend-engineer.md` | Backend Engineer | High | S4 | Reproduce before fixing, smallest change in assigned scope, fail-closed preserved, command output pasted as evidence, stop at ready-for-review. |
| `roles/frontend-engineer.md` | Frontend Engineer | High | S6 | Builds against a fixed API contract, implements every designed state and invents none, keeps secrets and trust decisions out of the client. |
| `roles/mobile-engineer.md` | Mobile Engineer | High | S6 | Designs for the shipped version that never updates; offline as a first-class state with a conflict rule; local state migration tested from the prior release. |
| `roles/data-engineer.md` | Data Engineer | High | S5 | Idempotent replayable stages that fail closed on quality violation; checks volume and distribution, not just schema; preserves classification end to end. |
| `roles/ml-engineer.md` | ML / AI Engineer | Partial | S4 | Separates run from score with the key out of reach, sets the gate threshold before evaluating, requires negative controls and a beaten trivial baseline. |
| `roles/platform-engineer.md` | Platform / DevOps Engineer | High | S7 | Encodes the invariants in tooling; gates are deterministic, fail closed, and non-overridable; every automated action lands in an audit trail. |
| `roles/dba.md` | Database Administrator | Partial | S5 | Tests the restore rather than the backup, rehearses migrations at production scale, and executes the rollback before it is needed. |

## Role cards — Review & verify

| File | Role | Fit | Seat | Purpose |
| --- | --- | --- | --- | --- |
| `roles/code-reviewer.md` | Peer Code Reviewer | High | All engineers (rotating) | Confirms base and scope before reading code; every finding carries a concrete failure scenario. Defers to the host's configured review framework for lifecycle and severity. |
| `roles/qa-analyst.md` | QA Analyst / Test Engineer | Partial | S8 | Tests what the requirements do not say, uses domain-realistic data, and reports residual risk with coverage limits rather than "QA passed". |
| `roles/sdet.md` | SDET / Automation Engineer | High | S8 | Places each test at the cheapest effective layer and treats flakiness as a P1 suite defect; quarantine requires an owner and a deadline. |
| `roles/performance-engineer.md` | Performance Engineer | High | S4 + S8 | Reports percentiles at stated concurrency, finds the saturation point and its first failing component, soaks long enough to expose leaks. |
| `roles/appsec-engineer.md` | AppSec Engineer / Pentester | Partial | S8 + borrowed | Confirms written authorization first, hunts fail-open error branches and replay paths, verifies egress, and reports exploitability rather than presence. |
| `roles/accessibility-specialist.md` | Accessibility Specialist | Partial | S9 design + S8 validate | Validates with real assistive technology rather than scanners, walks every flow keyboard-only, and states conformance gaps rather than overclaiming. |
| `roles/uat-coordinator.md` | UAT Coordinator | Anchored | S1 | Runs business acceptance against the original criteria and owns the signed record. Never signs on the business's behalf. |

## Role cards — Ship

| File | Role | Fit | Seat | Purpose |
| --- | --- | --- | --- | --- |
| `roles/release-manager.md` | Release Manager | Partial | S7 | Verifies gates from evidence not claims, defines the rollback threshold before deploying, and records every waiver with approver and expiry. |
| `roles/change-manager.md` | Change / Configuration Manager | Partial | S7 | Routes changes by risk class to independent approvers, tracks configuration drift as a finding, and requires retrospective approval for emergency changes. |
| `roles/sre.md` | Site Reliability Engineer | Partial | S7 | Owns SLOs derived from user need, an error-budget policy written before it is needed, symptom-based alerts each with a runbook. |
| `roles/technical-writer.md` | Technical Writer | High | S6 / S7 / S9 split | Executes every documented procedure against the real system, organizes by task, and documents the failure paths that deflect support load. |

## Role cards — Run & support

| File | Role | Fit | Seat | Purpose |
| --- | --- | --- | --- | --- |
| `roles/support-engineer.md` | Support Engineer (L1/L2) | Partial | S8 + rotation | Establishes scope of impact, reproduces before escalating, and never applies production data fixes outside change control. |
| `roles/incident-commander.md` | Incident Commander / On-call | Anchored | Rotation (S3/S4/S7) | Commands or fixes, never both. Maintains a contemporaneous timeline, communicates on cadence, drives a blameless postmortem with owned dated actions. |
| `roles/customer-success.md` | Customer Success / Account Manager | Anchored | S1 | Synthesizes feedback into themes with frequency and impact rather than relaying requests; records every customer commitment in writing. |
| `roles/product-analyst.md` | Product / Data Analyst | High | S1 | Pre-registers hypothesis and threshold before release, reports effect size with uncertainty, and says inconclusive when it is. |

## Role cards — Cross-cutting governance

| File | Role | Fit | Seat | Purpose |
| --- | --- | --- | --- | --- |
| `roles/compliance-privacy.md` | Compliance / Privacy (GRC) | Anchored | Borrowed | Separates control design from control operation, requires evidence generated by the control itself, and verifies the enforcement mechanism behind every claimed control. |
| `roles/legal-contracts.md` | Legal / Contracts | Anchored | Borrowed | Assesses licenses against the actual distribution model, reads vendor data-retention and training-rights terms, confirms IP ownership for AI-assisted contributions. |
| `roles/finops.md` | FinOps / Cost Owner | High | S2 + S7 | Reports unit economics rather than totals, gets cost in front of architecture decisions, and bounds automated agent runs by rounds, tokens, spend, and wall time. |
| `roles/localization-specialist.md` | Localization / i18n Specialist | Partial | S9 + borrowed | Externalizes strings with context, forbids concatenated translated fragments, validates text expansion and RTL, and routes jurisdictional variants to legal. |

## Scripts

| File | Purpose |
| --- | --- |
| `scripts/validate-cards.sh` | Read-only structural and authority-boundary validation for cards, metadata, dispatcher, and adapters. |
| `scripts/validate-receipts.sh` | Binds required review lanes to the exact staged release payload. |
| `scripts/lib-frontmatter.sh` | Shared fail-closed frontmatter parser and plain-scalar checks. |
| `scripts/install-skills.sh` | Ownership-safe Claude Code install, check, plugin, migration, and uninstall paths. |
| `scripts/install-codex-skills.sh` | Ownership-safe Codex install, check, and uninstall paths. |
| `scripts/install-kimi-skill.sh` | Ownership-safe Kimi Code install, check, and uninstall paths. |
| `scripts/test-platform-adapters.sh` | Isolated installer, schema, portability, and foreign-ownership fixtures. |
| `scripts/test-receipt-validator.sh` | Negative fixtures for stale, malformed, duplicated, or misbound evidence. |
| `scripts/build-skill-zips.sh` | Builds the canonical claude.ai bundle after validation. |
| `scripts/check.sh` | Contributor/PR gate: validates the candidate and builds the artifact. |
| `scripts/build-all.sh` | Maintainer release gate: runs `check.sh` plus exact-subject receipt validation. |

## Repository meta

| File | Purpose |
| --- | --- |
| `README.md` | This file — install paths, the invariants, and the document library. |
| `.gitignore` | Excludes `dist/` build artifacts and `.DS_Store`. |
| `.claude-plugin/plugin.json` | Plugin manifest, so the `--plugin` install path registers something Claude Code can actually load. |
| `LICENSE` | MIT License; copyright 2026 Chris Wetzel. |
| `SECURITY.md` / `CONTRIBUTING.md` | Vulnerability reporting and contribution/release gates. |
| `AGENTS.md` / `CLAUDE.md` / `KIMI.md` | Repository-local instructions for supported coding agents. |
| `.github/workflows/validate.yml` | Contributor checks on pull requests and exact-subject evidence validation on `main`. |
| `skills/sdlc-role/` | Canonical core: dispatcher, role index, 38 cards, and reference docs. |
| `agents/` | Platform-specific adapters. Only Kimi needs a wrapper; Claude Code and Codex use the canonical skill directly. |
| `docs/provenance.md` | Public-shipping policy: we keep receipts for every agent run, advice taken/rejected, and human artistic stroke. |
| `receipts/` | One receipt per significant agent run or decision. `TEMPLATE.md` is the starting point. |
| `review/` | Exact-candidate review manifests, receipts, and authoring rules. |

Current release: **v1.1.0**, licensed under the **MIT License**.

## Agent adapters

The framework is now agent-agnostic:

- **Canonical core** (`skills/sdlc-role/`): one dispatcher, one role index, 38 cards, and four reference docs. This is the single source of truth.
- **Native metadata where needed:** Codex metadata lives inside the canonical skill; Kimi gets the one
  thin wrapper its native schema requires. Claude Code consumes the canonical skill directly.

This means a change to the resolution rules, separation-of-duties invariants, or project-integration notes is edited once in `skills/sdlc-role/dispatcher.md` and applies to every agent.

To add a host that cannot consume the canonical skill directly, create `agents/<agent>/sdlc-role/` with:

1. The agent-specific shim file (e.g., `SKILL.md`, `instructions.md`, or a custom manifest).
2. A short instruction to read `dispatcher.md` and treat the shim directory as `${SKILL_DIR}`.
3. Portable relative symlinks to `skills/sdlc-role/dispatcher.md`, `ROLES.md`, `roles/`, and `reference/`.
4. An install/build script or documented manual step, if the agent supports one.


---

## The five invariants

These hold at every team size and survive every headcount cut. They are, in order, the findings an
auditor writes up.

1. **Author ≠ reviewer**
2. **Developer ≠ deploy approver**
3. **Builder of a control ≠ tester of that control**
4. **Incident commander ≠ hands-on fixer** — the most frequently violated
5. **UAT sign-off ≠ engineering**

Two supporting rules: *deterministic gates beat judgment* (a failing gate is not overridable by
seniority or by a model verdict), and *evidence beats assertion* ("tests pass" is not evidence when
command output can be supplied).

## Anchored roles

Seven roles require a named accountable human — `domain-sme`, `engineering-manager`,
`uat-coordinator`, `incident-commander`, `customer-success`, `compliance-privacy`,
`legal-contracts`. Wearing one means preparing material and flagging what needs their judgment, never
issuing their decision. Fabricated control evidence — a simulated sign-off, attestation, or SME
confirmation — is the worst failure mode in this role set, because it is specifically what audit
exists to detect.

## Interoperation

The cards define the *shape* of each role. Where a repository declares its own assignments, the
repository wins — `docs/agent-team.md`, `CONTRIBUTING.md`, `WORKFLOW.md`, `CLAUDE.md`, `CODEOWNERS`.
`dispatcher.md` instructs the model to check for these first.

For code review specifically the `code-reviewer` card **defers rather than duplicates**: where the
host provides a review framework, that framework owns findings lifecycle, severity, and pass logs.

## Provenance

Governance patterns are drawn from working systems rather than invented: read-only default with
explicit write escalation, non-overridable deterministic gates, and reviewer calibration from a
model-backed orchestrator;
fail-closed trust boundaries, egress surfaces, and run-≠-score eval separation from a governed
agent platform; the seven-field task admission record and handoff contract from a desktop-operator
agent; findings lifecycle and the local-marketplace install idiom from a code-review framework.

The unnamed sources are private repositories. They are described by capability rather than by name
so this repo can be published without disclosing them.

## Review

Public releases are reviewed by Codex, Claude, Kimi, a nested one-shot reviewer, and deterministic
gates. `review/CURRENT` selects the release candidate; its manifest names every admissible and
excluded run. An approval counts only when the receipt's one-line `Subject` field contains the exact
digest recomputed from the staged payload. Unavailable, failed, stale, or superseded runs remain in
the record but never become approval by implication.

## Status

**Structurally validated, and enforced rather than asserted.** `scripts/validate-cards.sh` runs 24
checks — nine sections per card, slug = filename, every cross-referenced slug resolves, the anchored
set identical in all four places it appears, no other document redefining "anchored", fit and seat
agreeing across card headers / `ROLES.md` / this README, each seat-map column using no more seats
than its headcount, the index matching the cards on disk, prose role counts, the absence of a brittle
file-count claim, the skill description's arithmetic, no reference escaping the skill directory, agent-adapter
consistency, and — since a count in prose is exactly what rots — that this sentence's own number is
correct. Every installer and the packager runs it with `bash` and refuses to proceed on failure.

```bash
bash scripts/validate-cards.sh     # All 24 structural checks passed.
```

This exists because the previous version of this section made the same claims with nothing behind
them: the 39th card, or an edit dropping a section, would have falsified the README silently while
both scripts kept passing. Evidence beats assertion is one of this repo's own two supporting rules;
it now applies to the repo itself.

**Functionally gated.** `bash scripts/build-all.sh` exercises all three installers in isolated homes,
including idempotence, lost executable bits, invalid metadata, foreign symlinks, legacy plugin
migration, uninstall ownership, receipt-binding attacks, and archive layout.

The claude.ai upload remains a manual step in **Settings → Capabilities → Skills**. The packager
builds and verifies the bundle, but only the account owner can upload it.
