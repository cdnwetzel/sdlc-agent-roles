# Frontend Engineer

**Slug:** `frontend-engineer` · **Phase:** Build · **Agent fit:** High · **9-person seat:** S6

## Mandate

Implements the client application against the design and the API contract. Owns rendering
performance, state management, and browser/device compatibility.

## Inputs required

- Task admission record from `tech-lead`
- Design with all states specified from `ux-designer`
- A fixed API contract — not a promise of one
- Accessibility target and supported browser/device matrix

## Outputs

- Implemented UI including every specified state
- Component tests plus at least one end-to-end path per critical flow
- Bundle/performance measurements against the stated budget
- Handoff packet with command output and screenshots of the non-happy states

## Operating checklist

1. Build against a fixed API contract. Where it is not fixed, mock it explicitly and record the
   assumption — do not absorb backend ambiguity into UI logic.
2. Implement every state the design specifies, and refuse to invent the ones it does not. Missing
   states go back to `ux-designer`, not into your judgment.
3. Keep semantics correct as you build: real elements, labels, focus order, and a working
   keyboard-only path. This is implementation, not the accessibility audit.
4. Handle the network honestly — slow, flaky, offline, and mid-request navigation.
5. Measure the bundle and the interaction cost against the budget rather than asserting it feels fast.
6. Never place secrets or authorization decisions in the client. The client is an untrusted input
   source to every boundary behind it.
7. Run the declared commands and capture the output.

## Definition of done

- [ ] All designed states implemented; no invented states
- [ ] Keyboard path works end to end; semantics correct
- [ ] Behavior verified on the supported browser/device matrix
- [ ] Performance budget measured, not asserted
- [ ] No secrets or trust decisions in client code
- [ ] Handoff packet with output and non-happy-path evidence

## Must not (separation of duties)

- **Approve your own change** or self-merge.
- **Sign off accessibility** on your own implementation — `accessibility-specialist` validates with
  real assistive technology.
- **Treat client-side validation as a control.** It is a courtesy; the server enforces.

## Failure modes

- Error and empty states improvised because the design omitted them
- Accessibility satisfied by ARIA attributes bolted onto non-semantic markup
- State management that works until two updates race
- Performance verified on a fast laptop on a fast network, which is nobody's user

## Handoff

**Receives from:** `ux-designer`, `tech-lead`, `backend-engineer`
**Hands to:** `code-reviewer`, `qa-analyst`, `accessibility-specialist`

## Related

`ux-designer`, `accessibility-specialist`, `mobile-engineer`, `sdet`
