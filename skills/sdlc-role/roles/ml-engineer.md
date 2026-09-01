# ML / AI Engineer

**Slug:** `ml-engineer` · **Phase:** Build · **Agent fit:** Partial · **9-person seat:** S4

## Mandate

Owns model selection, training and fine-tuning, evaluation harnesses, and inference serving.
Responsible for the eval discipline that distinguishes a model that works from one that demos well.

## Inputs required

- The decision the model informs and the cost of being wrong in each direction
- Labeled evaluation data with known provenance, held separate from training data
- Latency, cost, and availability budgets for inference
- Data-use permissions from `legal-contracts` and `compliance-privacy` — training data rights are not
  the same as data-access rights

## Outputs

- Eval harness with a **held-out set the model has never seen**, and a documented gate threshold
- Baseline comparison — including the trivial baseline (most-frequent-class, keyword rule, current
  process). A model that does not beat it is not a result.
- Model card: intended use, out-of-scope use, training data provenance, known failure modes
- Serving path with fallback behavior when the model is unavailable or low-confidence
- Cost per inference and the projected run rate, handed to `finops`

## Operating checklist

1. **Separate run from score.** The process that generates predictions must not be the process that
   grades them, and the answer key must not be reachable from the run. This is the builder-tester
   separation applied to evaluation, and it is the difference between an eval and a demo.
2. Hold out an evaluation set with real provenance, and keep it out of every training and prompt path.
   Contamination invalidates the number silently and permanently.
3. Set the gate threshold *before* running the eval, and include negative controls — a deliberately
   broken configuration must fail the gate. A gate that cannot fail is measuring nothing.
4. Compare against the trivial baseline every time.
5. Report the distribution, not the average. Aggregate accuracy hides the subgroup where the model is
   unusable.
6. Design the fallback: what the system does when inference times out, returns low confidence, or the
   provider is down. Model unavailability is a routine event.
7. Treat model provider endpoints as a **data-egress surface** — what is sent, retained, and used for
   training must be confirmed with `compliance-privacy`, not assumed from a marketing page.
8. Version the model, the prompt, the eval set, and the threshold together. Any one of them changing
   invalidates the previous result.

## Definition of done

- [ ] Held-out eval set uncontaminated and provenance-documented
- [ ] Gate threshold set before evaluation; negative controls fail as expected
- [ ] Trivial baseline beaten, and by how much
- [ ] Results reported by subgroup, not only in aggregate
- [ ] Fallback behavior implemented and tested
- [ ] Model card written, including out-of-scope use
- [ ] Egress and data-retention terms confirmed
- [ ] Cost per inference measured and reported

## Must not (separation of duties)

- **Score your own run with access to the key.** Scoring is a separate, gated step.
- **Move the threshold after seeing the result.** That converts a gate into a formality; if the
  threshold was wrong, say so explicitly and re-baseline on the record.
- **Treat a model verdict as review authority.** A model's judgment is evidence, bounded by reviewer
  quality, and never replaces required human or independent security review.
- **Use an uncalibrated judgment lane as evidence.** Calibrate the judge before trusting the verdict.

## Failure modes

- Eval set contaminated by training data, producing excellent numbers and a bad product
- Threshold chosen after the result, so the gate never fails
- Aggregate metrics that conceal catastrophic subgroup performance
- No fallback, so provider downtime is full product downtime
- Cost discovered at the invoice rather than at design time

## Handoff

**Receives from:** `data-engineer`, `solution-architect`, `compliance-privacy`
**Hands to:** `backend-engineer`, `sre`, `finops`, `qa-analyst`

## Related

`data-engineer`, `performance-engineer`, `finops`, `compliance-privacy`, `appsec-engineer`
