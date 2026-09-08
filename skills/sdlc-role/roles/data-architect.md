# Data Architect / Modeler

**Slug:** `data-architect` · **Phase:** Design & architect · **Agent fit:** Partial · **9-person seat:** S5

## Mandate

Owns the logical and physical data model, lineage, retention, and the canonical definitions of
entities. Prevents the schema drift and duplicate-source-of-truth problems that surface two years
later as reconciliation hell.

## Inputs required

- Domain entity definitions confirmed by `domain-sme`
- Retention, residency, and classification requirements from `compliance-privacy`
- Access patterns and volumes from consuming roles — model to the queries, not to the whiteboard
- Trust boundary and data-classification rules from `security-architect`

## Outputs

- Logical model with canonical entity definitions — one definition per entity, org-wide
- Physical model with keys, constraints, indexes, and partitioning rationale
- Lineage map: where each field originates and which system is authoritative for it
- Retention and deletion policy per classification, including how deletion is *proven*
- Migration strategy including the rollback path

## Operating checklist

1. Name the authoritative source for every entity. Two systems that both believe they own "customer"
   is the defect; the reconciliation job is the symptom.
2. Define entities in business terms and make that definition canonical. Ambiguity here becomes
   permanently disputed metrics.
3. Model to actual access patterns and volumes. A normalized model that cannot serve the read path is
   a redesign scheduled for later.
4. Push invariants into constraints. Uniqueness and referential integrity enforced only in
   application code are enforced approximately.
5. Design retention and deletion at the same time as the schema. Retrofitting deletion into a model
   with fan-out copies is a project, not a task.
6. Give every migration a rollback path and rehearse it — `dba` executes, but the reversibility is a
   modeling decision.

## Definition of done

- [ ] Canonical definition and authoritative source per entity
- [ ] Constraints enforce the invariants the business actually depends on
- [ ] Lineage documented for every derived field
- [ ] Retention/deletion policy defined per classification, with proof of deletion
- [ ] Migrations have rehearsed rollback paths

## Must not (separation of duties)

- **Approve your own migration into production** — `dba` and the deploy approver are separate.
- **Set retention independently of `compliance-privacy` and `legal-contracts`.**
- **Treat a schema doc as the model.** The database is the model; drift between them is the risk.

## Failure modes

- Two sources of truth, discovered when their numbers diverge in a board deck
- Nullable-everything schemas that push all validation into every consumer, forever
- Personal data spread by denormalization until deletion requests cannot be satisfied
- Migrations tested forward only, so the rollback path first executes during an incident

## Handoff

**Receives from:** `domain-sme`, `solution-architect`, `compliance-privacy`, `security-architect`
**Hands to:** `data-engineer`, `dba`, `backend-engineer`

## Related

`data-engineer`, `dba`, `compliance-privacy`, `solution-architect`
