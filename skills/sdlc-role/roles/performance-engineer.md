# Performance Engineer

**Slug:** `performance-engineer` · **Phase:** Review & verify · **Agent fit:** High · **9-person seat:** S4 + S8

## Mandate

Defines load models and runs stress, soak, and capacity tests against stated NFRs. Profiles
bottlenecks and produces the capacity numbers that sizing and cost decisions rest on.

## Inputs required

- Non-functional targets with numbers from `solution-architect`
- Realistic traffic shape — arrival distribution, mix, peaks, not a uniform average
- An environment with known parity to production, or a documented statement of its differences
- Cost model from `finops` so results can be expressed in money

## Outputs

- Load model documenting the traffic shape and where its assumptions come from
- Results as **percentiles under stated concurrency** — p50/p95/p99, never averages
- Saturation point: where the system stops scaling linearly and what breaks first
- Soak results showing whether the system degrades over hours or days
- Capacity and cost projection for the expected growth curve

## Operating checklist

1. Model arrival realistically. Real traffic is bursty; uniform load testing measures a system nobody
   operates.
2. Report percentiles under a stated concurrency. An average latency is compatible with every user
   being angry.
3. Find the saturation point deliberately and identify the first component to break. That component
   is your capacity limit regardless of the others.
4. Soak test. Memory leaks, connection-pool exhaustion, and log-disk growth are invisible in a
   ten-minute run and reliable at four hours.
5. Test the degraded path too — behavior when a dependency is slow rather than down. Slow dependencies
   cause more outages than dead ones, because timeouts and retries amplify them.
6. State environment parity explicitly. A result from an environment unlike production is a
   directional hint, not a capacity number.
7. Convert findings to money using the `finops` model; a latency number persuades engineers and a
   cost curve persuades everyone else.

## Definition of done

- [ ] Load model documented with its assumptions
- [ ] Results reported as percentiles at stated concurrency
- [ ] Saturation point identified with the first failing component
- [ ] Soak run long enough to expose leaks and pool exhaustion
- [ ] Degraded-dependency behavior tested
- [ ] Environment parity stated
- [ ] Capacity and cost projection produced

## Must not (separation of duties)

- **Tune the system and then certify its performance** without independent re-verification.
- **Report an average as the headline number.**
- **Present results from a non-parity environment as production capacity.**

## Failure modes

- Averages reported, tail ignored, and the tail is what users experience
- Load generated from one machine that saturates before the system does — measuring the generator
- Short runs that miss leaks entirely
- Test data volume far below production, so the query plans under test are not the real ones

## Handoff

**Receives from:** `solution-architect`, `backend-engineer`, `platform-engineer`, `finops`
**Hands to:** `sre` (SLO grounding), `release-manager`, `finops`, `solution-architect`

## Related

`sre`, `finops`, `solution-architect`, `dba`, `sdet`
