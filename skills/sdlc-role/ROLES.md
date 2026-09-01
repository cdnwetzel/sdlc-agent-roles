# Role index

38 role functions across the lifecycle. `Fit` is how well the function delegates to an automated
worker: **High** = mostly mechanical given good inputs · **Partial** = agent drafts, human decides ·
**Anchored** = requires a named accountable human, agent prepares material only.

`Seat` is the seat that carries the hat on a 9-person team (see `reference/seat-map.md`).

## Plan & discover

| Slug | Role | One line | Fit | Seat |
| --- | --- | --- | --- | --- |
| `product-manager` | Product Manager / Owner | Owns the why and the priority order; decides what ships and what "done" means | Partial | S1 |
| `business-analyst` | Business Analyst | Turns fuzzy wants into precise, testable requirements and acceptance criteria | Partial | S1 |
| `domain-sme` | Domain / Subject-Matter Expert | Supplies ground truth about the actual business domain and its exceptions | Anchored | Borrowed |
| `ux-researcher` | UX Researcher | Studies real users before design starts; kills bad assumptions cheaply | Partial | S9 |
| `delivery-manager` | Program / Delivery Manager | Owns schedule, dependencies, and cross-team critical path | Partial | S2 |
| `engineering-manager` | Engineering Manager | Owns people, capacity, and sustainable pace | Anchored | S2 |
| `scrum-master` | Scrum Master / Agile Coach | Owns process mechanics and makes dysfunction visible | Partial | S2 |

## Design & architect

| Slug | Role | One line | Fit | Seat |
| --- | --- | --- | --- | --- |
| `solution-architect` | Solution / Enterprise Architect | Defines system decomposition, boundaries, and non-functional targets | Partial | S3 |
| `tech-lead` | Tech Lead / Staff Engineer | Turns architecture into an executable plan and makes day-to-day design calls | Partial | S3 |
| `data-architect` | Data Architect / Modeler | Owns the data model, lineage, retention, and canonical entity definitions | Partial | S5 |
| `security-architect` | Security Architect | Threat models and sets trust boundaries, authN/authZ, and data classification | Partial | S3 |
| `ux-designer` | UX / UI Designer | Produces interaction design, the design system, and the states everyone forgets | Partial | S9 |

## Build

| Slug | Role | One line | Fit | Seat |
| --- | --- | --- | --- | --- |
| `backend-engineer` | Backend Engineer | Implements business logic, APIs, persistence, and service integration | High | S4 |
| `frontend-engineer` | Frontend Engineer | Implements the client against the design and the API contract | High | S6 |
| `mobile-engineer` | Mobile Engineer | Builds native/cross-platform clients under offline, background, and store constraints | High | S6 |
| `data-engineer` | Data Engineer | Builds ingestion, transformation, and serving pipelines with quality checks | High | S5 |
| `ml-engineer` | ML / AI Engineer | Owns model selection, eval harnesses, and inference serving | Partial | S4 |
| `platform-engineer` | Platform / DevOps Engineer | Builds the paved road: CI/CD, IaC, secrets, environments, tooling | High | S7 |
| `dba` | Database Administrator | Owns migrations, indexing, query performance, backup/restore, and HA | Partial | S5 |

## Review & verify

| Slug | Role | One line | Fit | Seat |
| --- | --- | --- | --- | --- |
| `code-reviewer` | Peer Code Reviewer | Reviews changes for correctness, readability, and hidden coupling before merge | High | All engineers (rotating) |
| `qa-analyst` | QA Analyst / Test Engineer | Designs test strategy and finds what automation is blind to | Partial | S8 |
| `sdet` | SDET / Automation Engineer | Builds and maintains automated suites and test data; owns suite reliability | High | S8 |
| `performance-engineer` | Performance Engineer | Defines load models, runs stress/soak tests, produces capacity numbers | High | S4 + S8 |
| `appsec-engineer` | AppSec Engineer / Pentester | Tests the built system adversarially against the security architecture | Partial | S8 + borrowed |
| `accessibility-specialist` | Accessibility Specialist | Validates WCAG and assistive-technology behavior with real tools | Partial | S9 design + S8 validate |
| `uat-coordinator` | UAT Coordinator | Runs formal business acceptance and owns the sign-off record | Anchored | S1 |

## Ship

| Slug | Role | One line | Fit | Seat |
| --- | --- | --- | --- | --- |
| `release-manager` | Release Manager | Owns the release train, go/no-go, and rollback criteria | Partial | S7 |
| `change-manager` | Change / Configuration Manager | Owns change control records, approvals, and config drift | Partial | S7 |
| `sre` | Site Reliability Engineer | Owns SLOs, error budgets, observability, and the authority to block releases | Partial | S7 |
| `technical-writer` | Technical Writer | Produces user docs, runbooks, API references, and release notes | High | S6 / S7 / S9 split |

## Run & support

| Slug | Role | One line | Fit | Seat |
| --- | --- | --- | --- | --- |
| `support-engineer` | Support Engineer (L1/L2) | Triages, reproduces, resolves known issues, and escalates with quality tickets | Partial | S8 + rotation |
| `incident-commander` | Incident Commander / On-call | Runs live incidents: severity, comms, coordination, and the postmortem | Anchored | Rotation (S3/S4/S7) |
| `customer-success` | Customer Success / Account Manager | Owns adoption and renewal risk; supplies the signal telemetry misses | Anchored | S1 |
| `product-analyst` | Product / Data Analyst | Instruments and measures what shipped; closes the loop on the bet | High | S1 |

## Cross-cutting governance

| Slug | Role | One line | Fit | Seat |
| --- | --- | --- | --- | --- |
| `compliance-privacy` | Compliance / Privacy (GRC) | Maps obligations to controls and owns the evidence that they operated | Anchored | Borrowed |
| `legal-contracts` | Legal / Contracts | Reviews licensing, vendor terms, DPAs, and IP ownership | Anchored | Borrowed |
| `finops` | FinOps / Cost Owner | Attributes and forecasts spend; owns unit economics | High | S2 + S7 |
| `localization-specialist` | Localization / i18n Specialist | Owns translation, locale formatting, RTL, and jurisdictional content | Partial | S9 + borrowed |

## Picking a role from the work

| The work is | Role |
| --- | --- |
| Deciding whether to build it at all | `product-manager` |
| Writing down what "it works" means | `business-analyst` |
| Choosing between two system designs | `solution-architect` |
| Deciding where trust boundaries sit | `security-architect` |
| Writing the change | the matching build role |
| Deciding whether the change is safe to merge | `code-reviewer` |
| Deciding whether the change is *correct* | `qa-analyst` or `sdet` |
| Deciding whether the change is *exploitable* | `appsec-engineer` |
| Deciding whether the change can go to production now | `release-manager` + `sre` |
| Production is on fire | `incident-commander` |
| Deciding whether the bet paid off | `product-analyst` |
| Proving to an auditor that any of the above happened | `compliance-privacy` |
