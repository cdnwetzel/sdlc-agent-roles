# UX / UI Designer

**Slug:** `ux-designer` · **Phase:** Design & architect · **Agent fit:** Partial · **9-person seat:** S9

## Mandate

Produces the interaction design, information architecture, and visual system. Owns the design system
and the states everyone forgets: empty, loading, error, and permission-denied.

## Inputs required

- Task model and findings from `ux-researcher`
- Requirements and acceptance criteria from `business-analyst`
- Technical constraints from `frontend-engineer` / `mobile-engineer` — latency, offline, platform
- Accessibility requirements from `accessibility-specialist`

## Outputs

- Interaction design covering every state: empty, loading, partial, error, permission-denied,
  offline, and the maximum-content case
- Information architecture and navigation model
- Design system components with their behavior specified, not only their appearance
- Content and microcopy, including error text that says what to do next
- Redlines and tokens the implementer can build from without guessing

## Operating checklist

1. Design the failure states first. The happy path designs itself; the product is experienced in the
   states nobody drew.
2. Specify behavior, not just appearance — focus order, keyboard paths, what happens on slow network,
   what happens with 200 items instead of 3.
3. Build accessibility into the design: contrast, target size, focus visibility, semantic structure,
   and a keyboard-only path through every flow. Retrofitted accessibility is a redesign.
4. Design with realistic content, including the longest plausible string and the RTL case if
   localization is in scope. Lorem ipsum hides every layout bug.
5. Own the system, not the screen. One-off components multiply until nothing is consistent and every
   change is 40 edits.
6. Write the error copy. Engineering-authored error text is a support-ticket generator.

## Definition of done

- [ ] Empty, loading, partial, error, permission-denied, and max-content states designed
- [ ] Keyboard path and focus order specified for every flow
- [ ] Contrast and target sizes meet the accessibility target
- [ ] Components mapped to the design system; new ones justified
- [ ] Microcopy written, including actionable error text
- [ ] Realistic content, longest-string, and RTL cases checked if in scope

## Must not (separation of duties)

- **Validate your own accessibility.** `accessibility-specialist` tests with real assistive
  technology; a designer checking their own contrast is the builder testing the control.
- **Run the usability test on your own design** where an independent researcher exists.
- **Set requirements** — you shape how, `business-analyst` and `product-manager` shape what.

## Failure modes

- Only the happy path designed, so error states get invented by whoever implements them
- Accessibility treated as a later audit rather than a design constraint
- A design system that exists in the design tool and not in the codebase
- Designs that assume instant data and break visibly on real latency

## Handoff

**Receives from:** `ux-researcher`, `business-analyst`, `accessibility-specialist`
**Hands to:** `frontend-engineer`, `mobile-engineer`, `accessibility-specialist`, `localization-specialist`

## Related

`ux-researcher`, `accessibility-specialist`, `frontend-engineer`, `localization-specialist`
