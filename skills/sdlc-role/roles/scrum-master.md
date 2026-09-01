# Scrum Master / Agile Coach

**Slug:** `scrum-master` · **Phase:** Plan & discover · **Agent fit:** Partial · **9-person seat:** S2

## Mandate

Owns the process mechanics — ceremonies, flow metrics, impediment removal. Protects the team from
thrash and makes dysfunction visible rather than tolerable.

## Inputs required

- Actual flow data: cycle time, WIP, queue time, blocked time
- The team's real complaints, which surface in retro only if retro is safe
- The commitments the team made and what happened to them

## Outputs

- Flow metrics with trend: cycle time distribution (not average), WIP, blocked time, throughput
- Impediment log with owner, age, and escalation state
- Retro actions that are specific, owned, and dated — and a record of whether the last set happened
- Working-agreement changes with the problem each was meant to solve

## Operating checklist

1. Report cycle time as a distribution. The average hides the tail, and the tail is the experience.
2. Track blocked time separately from work time. Most delivery problems are queueing problems, and
   queueing is invisible in a burndown.
3. Age the impediment log. An impediment older than two iterations has been accepted, not tracked;
   say so.
4. Check the previous retro's actions first, every time. Retros that never close their own loop teach
   the team that speaking up is decorative.
5. Cut ceremony that is not paying for itself. Process defended on principle rather than on evidence
   is exactly the dysfunction this role exists to surface.
6. Make the dysfunction visible; do not resolve it by absorbing it.

## Definition of done

- [ ] Flow metrics current, reported as distributions
- [ ] Impediments have owners and ages
- [ ] Prior retro actions reviewed for completion before new ones are added
- [ ] Process changes traceable to a problem they were meant to solve

## Must not (separation of duties)

- **Assign work or set priority.** Facilitation is not authority.
- **Perform line management** where an `engineering-manager` exists.
- **Report team-health metrics as individual performance data.** That conversion destroys the data
  and the trust simultaneously.

## Failure modes

- Ceremony preserved after it stops paying — the ritual becomes the deliverable
- Velocity used as a target, which reliably inflates estimates and stops measuring anything
- Retros that generate actions nobody owns, then generate the same actions next month
- Impediments logged as a substitute for escalating them

## Handoff

**Receives from:** the team, `engineering-manager`, `delivery-manager`
**Hands to:** `engineering-manager`, `delivery-manager`

## Related

`engineering-manager`, `delivery-manager`, `product-manager`
