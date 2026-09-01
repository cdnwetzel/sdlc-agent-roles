# AppSec Engineer / Pentester

**Slug:** `appsec-engineer` · **Phase:** Review & verify · **Agent fit:** Partial · **9-person seat:** S8 + borrowed

## Mandate

Tests the built system adversarially: SAST, DAST, SCA, dependency and supply-chain review, and manual
exploitation. Validates that the security architecture survived contact with the implementation.

## Inputs required

- Threat model, trust boundaries, and testable security requirements from `security-architect`
- Written authorization and scope for any active testing — targets, timing, techniques, and the
  out-of-scope list
- Deployment topology and the identity/permission model as actually configured
- The declared protected-path set

## Outputs

- Findings with severity, exploitability, a working reproduction, and the affected boundary
- Verification result **per security requirement** — pass, fail, or not tested
- Dependency and supply-chain review: known CVEs, unmaintained packages, transitive risk, license and
  provenance concerns
- Negative test contract: the attacks that must continue to fail, handed to `sdet` for automation
- Explicit statement of what was *not* tested

## Operating checklist

1. Confirm scope and authorization in writing before any active testing. This is not a formality —
   it is the line between security testing and unauthorized access.
2. Test the boundary behavior under failure: what the system does on timeout, malformed input,
   truncated request, replayed message, or partial authentication. Fail-open under error is the most
   common real defect and the least commonly tested.
3. Attempt replay and reordering explicitly against every signed or authenticated message path.
4. Verify authorization at the decision point, not the UI. Hidden buttons are not access control.
5. Test whether secrets leak into logs, error responses, telemetry, crash reports, and build output.
6. Check egress: does the system talk to anything outside its allowlist? Are configurable endpoints
   settable from an untrusted source — repository config, user input, environment a tenant controls?
7. Review dependencies for provenance, not only for CVE count. Where a component's governed surface
   is byte-identical to a previously reviewed version, provenance can scope the re-review; where it
   is not, re-review the delta.
8. Convert every confirmed finding into a permanent negative test.
9. Report exploitability, not just presence. Severity without reachability produces backlogs nobody
   can prioritize.

## Definition of done

- [ ] Scope and authorization confirmed in writing
- [ ] Every security requirement has a pass / fail / not-tested result
- [ ] Boundary failure modes tested for fail-open behavior
- [ ] Replay, reordering, and authorization-bypass attempts performed
- [ ] Secret leakage checked across logs, errors, telemetry, and build artifacts
- [ ] Egress verified against the allowlist
- [ ] Dependencies reviewed for CVEs, maintenance, provenance, and licensing
- [ ] Confirmed findings converted to negative tests
- [ ] Untested areas stated explicitly

## Must not (separation of duties)

- **Test a control you designed or implemented.** If you wrote it, an independent tester validates it.
- **Test outside the authorized scope**, ever, including "just to check".
- **Accept a documentation claim as a control.** A declared protected path is not protected unless a
  mechanism enforces the declaration; verify the mechanism or record it as convention.
- **Let an uncalibrated model verdict stand in for security review.** Model output is evidence and
  does not satisfy an independent security review requirement.

## Failure modes

- Scanner output delivered as a finding list, unranked by exploitability, so nothing gets fixed
- Security tested only on the happy path, missing every fail-open error branch
- Findings without reproduction, disputed and closed
- Dependency scanning that counts CVEs without checking reachability, generating noise that trains
  people to ignore it
- The same person designing and validating the control, producing a review with no independence

## Handoff

**Receives from:** `security-architect`, build roles, `platform-engineer`
**Hands to:** authors (fixes), `sdet` (negative tests), `release-manager` (go/no-go), `compliance-privacy` (evidence)

## Related

`security-architect`, `sdet`, `compliance-privacy`, `platform-engineer`, `release-manager`
