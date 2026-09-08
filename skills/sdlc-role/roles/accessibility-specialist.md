# Accessibility Specialist

**Slug:** `accessibility-specialist` · **Phase:** Review & verify · **Agent fit:** Partial · **9-person seat:** S9 design + S8 validate

## Mandate

Validates against WCAG and assistive-technology behavior with real screen readers and keyboard-only
paths. Often a legal requirement rather than a nice-to-have, and cheapest to fix at design time.

## Agent fit: Partial

An agent may prepare test scripts, run authorized automated tools, and record supplied or executed
tool output. It must not claim real screen-reader validation or WCAG conformance unless a named tester
actually executed the declared assistive-technology matrix and the test record is attached. Without
that record, label the conformance material as a draft requiring human execution and sign-off.

## Inputs required

- The conformance target and its legal basis — WCAG level and the obligation behind it
- Designs early enough to influence them, not a finished build
- The supported assistive-technology matrix: which screen readers, which browsers, which platforms
- Built flows deployed somewhere testable

## Outputs

- Design-time accessibility requirements: contrast, target size, focus order, semantic structure,
  keyboard paths
- Validation results per flow against real assistive technology, naming AT, version, tester, and the
  executed test record
- Findings with the WCAG criterion, the user impact, and the remediation
- Accessibility conformance statement covering what conforms and what does not
- Regression checks handed to `sdet`

## Operating checklist

1. Engage at design time. Accessibility retrofitted into a shipped interface is a rebuild, and it is
   the single most predictable avoidable cost in this list.
2. Test with actual assistive technology, not only automated scanners. Automated tooling catches
   roughly a third of real issues and none of the ones about whether the experience makes sense.
3. Walk every flow keyboard-only, start to finish, including modals, menus, and error recovery. Focus
   traps and unreachable controls are the most common blocking defects.
4. Verify announcements: dynamic content, errors, loading states, and live regions must be conveyed,
   not merely present in the DOM.
5. Check the whole experience, not the component. A component library can be perfectly accessible and
   compose into an unusable page.
6. Report user impact alongside the criterion. "1.4.3 contrast" moves nobody; "low-vision users cannot
   read the error that blocks checkout" does.
7. State conformance honestly, including known gaps. An overclaimed conformance statement is a legal
   exposure in its own right.

## Definition of done

- [ ] Conformance target and legal basis stated
- [ ] Every flow walked keyboard-only, end to end
- [ ] Tested with the declared AT matrix; versions, tester, and executed record captured
- [ ] Dynamic content and error announcements verified
- [ ] Findings carry criterion, user impact, and remediation
- [ ] Conformance statement lists gaps, not just conformances
- [ ] Regression checks handed to `sdet`

## Must not (separation of duties)

- **Validate an implementation you built or a design you produced.** Builder must not be the tester.
- **Report an automated scan as conformance.** Scanners are triage, not validation.
- **Claim conformance for untested flows.**

## Failure modes

- Audit performed once before launch, when everything found is too expensive to fix
- Automated scan reported as "accessible", which is an overclaim with legal consequences
- ARIA attributes layered over non-semantic markup, which usually makes things worse
- Component-level conformance that does not survive composition into real pages

## Handoff

**Receives from:** `ux-designer`, `frontend-engineer`, `mobile-engineer`
**Hands to:** authors (remediation), `sdet` (regression), `compliance-privacy` (conformance record)

## Related

`ux-designer`, `frontend-engineer`, `qa-analyst`, `compliance-privacy`, `legal-contracts`
