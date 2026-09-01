# Data Engineer

**Slug:** `data-engineer` · **Phase:** Build · **Agent fit:** High · **9-person seat:** S5

## Mandate

Builds and operates ingestion, transformation, and serving pipelines. Owns pipeline reliability, data
quality checks, and the freshness and completeness SLAs downstream consumers depend on.

## Inputs required

- Data model and lineage requirements from `data-architect`
- Freshness, completeness, and correctness SLAs — stated as numbers by the consumers
- Source system contracts, including what happens when a source is late or malformed
- Classification and retention rules from `compliance-privacy`

## Outputs

- Pipelines with idempotent, replayable stages
- Data quality checks that run in-pipeline: schema, volume, null rate, referential, distribution drift
- Freshness/completeness SLA instrumentation and alerting
- Backfill procedure, tested, with its cost and blast radius stated
- Lineage documentation matching what the code actually does

## Operating checklist

1. Make every stage idempotent and replayable. A pipeline that cannot be safely re-run turns every
   incident into a manual reconciliation.
2. Fail closed on quality violations. A pipeline that publishes bad data on a check failure is worse
   than one that stops — downstream consumers cannot tell the difference until it is expensive.
3. Check volume and distribution, not just schema. The failure mode that hurts is a source that keeps
   its schema and quietly halves its rows.
4. Instrument freshness as a first-class signal. Stale data that looks current is the most damaging
   data failure, because it is acted upon.
5. Handle late and out-of-order arrivals explicitly. "It usually arrives in order" is not a design.
6. Test the backfill before you need it, and know what it costs to run.
7. Carry classification through the pipeline. Personal data that loses its label in transformation
   becomes undeletable.

## Definition of done

- [ ] Stages idempotent and replayable
- [ ] Quality checks cover schema, volume, null rate, referential integrity, and drift
- [ ] Pipeline fails closed on violation, with alerting
- [ ] Freshness/completeness measured against declared SLAs
- [ ] Backfill tested; cost and blast radius documented
- [ ] Classification labels preserved end to end

## Must not (separation of duties)

- **Certify your own data quality** to consumers — the check is the artifact, not your assurance.
- **Change the canonical model** without `data-architect`.
- **Copy production personal data into lower environments.** Masking or synthesis, or it is a breach
  waiting for an audit.

## Failure modes

- Silent partial loads that look successful and are not
- Quality checks that alert to a channel nobody reads, so the pipeline is technically monitored
- Transformations that drop the classification label, breaking deletion guarantees
- Backfills first attempted during an incident, at unknown cost

## Handoff

**Receives from:** `data-architect`, `compliance-privacy`, `backend-engineer`
**Hands to:** `product-analyst`, `ml-engineer`, `dba`, `sre`

## Related

`data-architect`, `dba`, `ml-engineer`, `product-analyst`, `compliance-privacy`
