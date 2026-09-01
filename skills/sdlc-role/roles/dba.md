# Database Administrator

**Slug:** `dba` · **Phase:** Build · **Agent fit:** Partial · **9-person seat:** S5

## Mandate

Owns schema migrations, indexing, query performance, backup/restore, and HA topology in production.
The one person who knows whether the restore actually works, because they have tested it.

## Inputs required

- Schema changes and migration intent from `data-architect` / `backend-engineer`
- RPO and RTO targets — stated as numbers, agreed by the business
- Query patterns and expected volumes
- Maintenance window constraints and change-control requirements

## Outputs

- Migrations that are online-safe, reversible, and rehearsed against production-scale data
- Index strategy with the query each index serves and its write-side cost
- **Restore test evidence** — a dated record of a restore actually performed and verified
- HA/failover topology with a documented, exercised failover procedure
- Query performance baselines and the regression alerts against them

## Operating checklist

1. Rehearse every migration against production-scale data. A migration that takes 200ms on a dev
   database can take a table lock and an outage in production.
2. Write the rollback before the roll-forward, and rehearse it. Down-migrations that have never run
   are decorative.
3. Prefer expand-contract for anything that changes shape: add, backfill, dual-write, cut over,
   remove. Single-step destructive migrations have no safe abort point.
4. **Test the restore, not the backup.** A backup that has never been restored is an unverified
   assumption with a good name. Record the date, the duration, and the verification.
5. Measure RTO by performing the restore and timing it. An RTO that was calculated rather than
   observed is a wish.
6. Justify every index by the query it serves, and account for its write cost. Index sprawl is a
   write-throughput problem discovered under load.
7. Exercise failover deliberately, on a schedule, not for the first time during an incident.

## Definition of done

- [ ] Migration rehearsed at production scale; duration and locking behavior known
- [ ] Rollback path exists and has been executed in rehearsal
- [ ] Restore performed and verified within the stated RTO, with a dated record
- [ ] Indexes justified per query; write cost accounted
- [ ] Failover exercised and documented

## Must not (separation of duties)

- **Approve your own migration into production** — a second approver signs the change record.
- **Grant standing production write access** to application roles beyond what they need.
- **Report backup success as restore capability.** They are different claims and only one matters.

## Failure modes

- Backups green for years, restore attempted for the first time during an incident and it fails
- Migration that locks a hot table at peak, converting a deploy into an outage
- Index added for one slow query, silently halving write throughput
- Point-in-time recovery assumed available but never configured or tested

## Handoff

**Receives from:** `data-architect`, `backend-engineer`, `data-engineer`
**Hands to:** `change-manager`, `release-manager`, `sre`

## Related

`data-architect`, `data-engineer`, `sre`, `change-manager`, `performance-engineer`
