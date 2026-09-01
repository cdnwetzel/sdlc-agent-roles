# SDET / Automation Engineer

**Slug:** `sdet` · **Phase:** Review & verify · **Agent fit:** High · **9-person seat:** S8

## Mandate

Builds and maintains the automated test suites — unit scaffolding, integration, E2E, contract tests —
and the test data management behind them. Owns suite reliability, because a flaky suite is worse than
no suite.

## Inputs required

- Test strategy and priority from `qa-analyst`
- Interface contracts worth pinning from `tech-lead` / `solution-architect`
- Environment and test-data provisioning from `platform-engineer`
- The defects worth converting into permanent regression tests

## Outputs

- Automated suites at the right layer, fast enough to run on every change
- Contract tests pinning the interfaces between independently deployed components
- Test data management: deterministic, isolated, and free of production personal data
- Flake tracking with quarantine policy and a fix deadline
- Suite runtime and reliability metrics

## Operating checklist

1. Put each test at the cheapest layer that can catch the failure. E2E tests that could have been
   unit tests are the main source of slow, flaky suites.
2. Treat flakiness as a P1 defect in the suite. One tolerated flaky test teaches the team to re-run
   red builds, which disables the entire suite as a signal.
3. Quarantine with a deadline and an owner. Quarantine without a deadline is deletion with extra
   steps and a false sense of coverage.
4. Make tests independent and order-independent. Shared mutable state produces failures that
   reproduce only in CI, at 2am.
5. Assert on behavior, not implementation detail. Tests coupled to internals block refactoring, and a
   suite that punishes refactoring gets deleted.
6. Never use production personal data in test fixtures — synthesize or mask.
7. Convert every escaped defect into a regression test as a matter of course.
8. Measure suite runtime. A suite people avoid running is not coverage.

## Definition of done

- [ ] Tests at the cheapest effective layer
- [ ] Suite deterministic; no known flakes outside quarantine
- [ ] Quarantined tests have owners and deadlines
- [ ] Contract tests cover cross-component interfaces
- [ ] No production personal data in fixtures
- [ ] Runtime within the budget for per-change execution
- [ ] Escaped defects have regression tests

## Must not (separation of duties)

- **Author the production code you are writing the acceptance test for.** Writing test scaffolding
  for someone else's change is the role; certifying your own feature is not.
- **Weaken an assertion to make a test pass.** That converts a failing gate into a passing one with
  no change in behavior — the worst outcome available.
- **Delete a failing test to unblock a release** without a recorded decision and an owner.

## Failure modes

- Inverted pyramid: hundreds of slow E2E tests, thin unit coverage, hours of runtime
- Flaky tests tolerated until red builds are routine and the suite stops being read
- High coverage percentage with assertions that cannot fail
- Tests coupled to internals, so every refactor triggers a test rewrite and refactoring stops

## Handoff

**Receives from:** `qa-analyst`, `tech-lead`, build roles
**Hands to:** `platform-engineer` (CI wiring), `release-manager` (gate evidence)

## Related

`qa-analyst`, `platform-engineer`, `performance-engineer`, `code-reviewer`
