# Seat map — hats onto real people

Roles are **functions**, not headcount. A real team staffs *seats*, and each seat carries a bundle of
hats. The bundling is not arbitrary: hats are grouped by when they fire in the cycle, so no seat is
double-booked at crunch, and by which pairs must stay apart for separation of duties.

## The 9-person team (full coverage)

| Seat | Primary hats | Secondary hats (part-time) | Must NOT also hold |
| --- | --- | --- | --- |
| **S1 — Product Manager** | `product-manager`, `business-analyst` | `uat-coordinator`, `product-analyst`, `customer-success` liaison, localization content owner | Prod deploy approval; peer review of code |
| **S2 — Engineering Manager / Delivery Lead** | `engineering-manager`, `delivery-manager` | `scrum-master`, `finops`, change-approval authority | `tech-lead` — people and design authority must split |
| **S3 — Tech Lead / Staff Engineer** | `tech-lead`, `solution-architect` | `security-architect`, ADR owner, senior reviewer, IC rotation | Sole reviewer of own commits; UAT sign-off |
| **S4 — Senior Backend Engineer** | `backend-engineer`, `ml-engineer` | `performance-engineer`, `code-reviewer`, IC rotation | Reviewer of own PRs; release approver |
| **S5 — Backend / Data Engineer** | `data-engineer`, `data-architect` | `dba`, backend overflow, `code-reviewer` | Approver of own migrations into prod |
| **S6 — Frontend / Mobile Engineer** | `frontend-engineer`, `mobile-engineer` | accessibility *implementation*, `technical-writer` (user docs) | Accessibility *validation* of own work |
| **S7 — Platform / SRE** | `platform-engineer`, `sre` | `release-manager`, `change-manager`, IC rotation lead, FinOps telemetry, runbooks | Feature-code author on releases they approve |
| **S8 — QA / SDET** | `qa-analyst`, `sdet` | `appsec-engineer` first pass, a11y validation, perf execution, UAT facilitation, L2 escalation | Author of the code under test |
| **S9 — Product Designer** | `ux-designer`, `ux-researcher` | design system owner, a11y-by-design, localization layout, in-product copy | — |

**Never in-team, always borrowed:** `domain-sme`, `legal-contracts`, `compliance-privacy`, deep-dive
pentest (annual third party), professional localization. These sit outside the delivery team because
the team's incentive is to ship and theirs is not.

Do not read that list as the anchored set — the two overlap but are not the same thing. *Borrowed*
is about **staffing**: the work happens outside this team. *Anchored* is about **accountability**:
the sign-off needs a named human and an agent may only prepare material for it. The seven anchored
roles are `domain-sme`, `engineering-manager`, `uat-coordinator`, `incident-commander`,
`customer-success`, `compliance-privacy`, and `legal-contracts` — defined once in
`reference/separation-of-duties.md`, which is authoritative. Four of them sit *inside* the team
(S1, S2, and the IC rotation), and two roles borrowed above — deep-dive pentest and professional
localization — are `Partial`, not anchored.

## Coverage by team size

| Function | 9-person | 7-person | 6-person |
| --- | --- | --- | --- |
| `product-manager` | S1 | S1 | S1 |
| `business-analyst` | S1 | S1 | S1 |
| `domain-sme` | Borrowed | Borrowed | Borrowed |
| `ux-researcher` | S9 | S9 (thin) | S1 + borrowed |
| `delivery-manager` | S2 | S1 | S1 |
| `engineering-manager` | S2 | Borrowed (skip-level) | Borrowed |
| `scrum-master` | S2 | S3 (lightweight) | Rotating |
| `solution-architect` | S3 | S3 | S3 |
| `tech-lead` | S3 | S3 | S3 |
| `data-architect` | S5 | S4 | S3 + S4 |
| `security-architect` | S3 | S3 | S3 + borrowed |
| `ux-designer` | S9 | S9 | Fractional / contract |
| `backend-engineer` | S4, S5 | S4 | S4 |
| `frontend-engineer` | S6 | S6 | S6 |
| `mobile-engineer` | S6 | S6 or dropped | Dropped (web-only) |
| `data-engineer` | S5 | S4 | S4 |
| `ml-engineer` | S4 | S4 | S4 (or dropped) |
| `platform-engineer` | S7 | S7 | S7 |
| `dba` | S5 | S4 | S7 + S4 |
| `code-reviewer` | All engineers | All engineers | All engineers |
| `qa-analyst` | S8 | S8 | S8 |
| `sdet` | S8 | S8 | S8 + engineers |
| `performance-engineer` | S4 + S8 | S4 + S8 | S7 |
| `appsec-engineer` | S8 + borrowed | S8 + borrowed | Borrowed |
| `accessibility-specialist` | S9 design, S8 validate | Same | Borrowed audit |
| `uat-coordinator` | S1 | S1 | S1 |
| `release-manager` | S7 | S7 | S7 |
| `change-manager` | S7, approved by S2 | S7, approved by S1 | S7, approved by S1 |
| `sre` | S7 | S7 | S7 |
| `technical-writer` | S6 / S7 / S9 split | S6 + S7 | S7 runbooks only |
| `support-engineer` | S8 + rotation | Rotation | Rotation |
| `incident-commander` | S3/S4/S7 rotation | S3/S7 rotation | S7 + S3 |
| `customer-success` | S1 | S1 | S1 |
| `product-analyst` | S1 | S1 | S1 |
| `compliance-privacy` | Borrowed | Borrowed | Borrowed |
| `legal-contracts` | Borrowed | Borrowed | Borrowed |
| `finops` | S2 + S7 | S7 + S1 | S7 |
| `localization-specialist` | S9 + borrowed | Deferred | Deferred |

## What actually changes at each size

**9 → 7** drops the Engineering Manager seat (S2) and the Backend/Data seat (S5), leaving
**S1, S3, S4, S6, S7, S8, S9**. People management goes to a skip-level; delivery coordination goes to
the PM; the data and DBA hats fold into S4. This works until the team has a personnel problem, at
which point nobody owns it and it festers.

The matrix above commits to that shape — the UI-heavy variant, which keeps the designer. If the
product is pipeline- or service-heavy, invert it: cut S9 to fractional and keep both backend seats,
so the seven become **S1, S3, S4, S5, S6, S7, S8** and every `S9` cell above reads
"Fractional / contract" as it does in the 6-person column. Pick one before staffing; a matrix that
keeps both S5 and S9 is a 7-person team on paper and an 8-person team in payroll.

**7 → 6** takes the designer fractional, leaving **S1, S3, S4, S6, S7, S8**. It is where things get
structurally uncomfortable, because the first thing actually cut is never a seat — it is the
*secondary hats*. Performance engineering, accessibility validation, and technical writing
quietly stop happening. They produce no visible failure for six to eighteen months, then produce all
of them at once.

## On-call shape

At 6–9 people you cannot run a healthy 24/7 primary rotation. Five or six participants is the minimum
to avoid burning people out, and at 6 total that is everyone including the PM. Realistic options:

- Business-hours-only with a documented degraded-service SLA overnight
- Follow-the-sun handoff, if a second team exists
- A managed NOC for L1 triage with only L3 escalation in-house

Whichever is chosen, write it down. An undocumented overnight gap is discovered by a customer.

## Where the model breaks

The honest failure mode of a 6–9 person team is not any single missing role — it is that **the
roles carrying external accountability are the ones nobody in the room reports to**.
`compliance-privacy`, `legal-contracts`, and `domain-sme` sit outside the team entirely; deep-dive
`appsec-engineer` work is bought in. All have their own priorities, and all get consulted at the
point where their input is most expensive to act on.

The in-team anchors fail differently and more quietly. `uat-coordinator` and `customer-success` sit
at S1 at every size, and `incident-commander` is a rotation — so the accountable human is *present*,
but is the same person already carrying the delivery pressure the anchor exists to counterbalance.
That is not a staffing gap; it is a conflict of interest, and it needs the calendar and the
separation-of-duties gates rather than another seat.

The mitigation is calendar-forced, not intention-based: a standing SME review at requirements time and
a standing compliance checkpoint before the release cut, both scheduled recurring rather than
requested ad hoc. Ad-hoc requests to a borrowed anchor role reliably arrive one sprint too late.

## Using this with agents

Mapping these hats onto automated workers follows the same rules, with two additions:

1. **A new agent starts read-only.** Write authority comes only from a bounded task that names its
   scope, its evidence requirements, and its reviewer.
2. **The reviewer must be a different entity than the author** — a different agent, or a human. The
   same agent reviewing its own output in a second pass satisfies nothing, and recording it as an
   independent review is worse than skipping the review.
