# Incident Commander / On-call

**Slug:** `incident-commander` · **Phase:** Run & support · **Agent fit:** Anchored · **9-person seat:** Rotation (S3/S4/S7)

## Mandate

Runs live incidents — coordinates responders, owns comms cadence, declares severity and resolution.
Distinct from fixing the bug; the job is decision-making under pressure, then driving the postmortem.

## Agent fit: Anchored

Command authority during a live incident belongs to a named human. An agent can maintain the timeline,
draft comms, pull telemetry, and track action items — genuinely useful and genuinely load-reducing —
but it does not declare severity, authorize mitigations, or call resolution.

## Inputs required

- Severity definitions agreed in advance
- Runbooks, dependency map, and current deploy state
- Comms templates and the stakeholder list, prepared before the incident
- Authority to page anyone required, established in advance

## Outputs

- Declared severity, and a named commander announced to everyone involved
- Running timeline: what was observed, decided, and done, with timestamps
- Regular stakeholder comms on a stated cadence, including "no change yet"
- Mitigation decisions with their rationale recorded at the time
- Resolution declaration and handoff to postmortem
- Blameless postmortem with contributing factors and owned, dated actions

## Operating checklist

1. **Command or fix — never both.** The moment you are in the code you have stopped tracking severity,
   comms, and the clock. If you are the only person who can fix it, hand command to someone less
   technical; commanding is the more delegable job.
2. Declare severity early and adjust. Under-declaring to avoid noise is how a one-hour incident
   becomes a six-hour one.
3. Assign roles explicitly by name: who investigates, who communicates, who executes mitigations.
   Unassigned work in an incident is unstarted work.
4. Keep the timeline as you go. Reconstructed timelines are wrong in the specific places that matter,
   because memory under stress compresses.
5. Mitigate before diagnosing. Restore service first; root cause is a postmortem activity.
6. Communicate on a fixed cadence and honor it even with no news. Silence generates escalation.
7. Prefer the rollback. Forward fixes under pressure are how incidents multiply.
8. Declare resolution explicitly, and separately from the postmortem.
9. Run the postmortem blameless and land actions with owners and dates, or the same incident returns.

## Definition of done

- [ ] Severity declared, commander named and announced
- [ ] Roles assigned by name
- [ ] Timeline maintained contemporaneously
- [ ] Comms delivered on cadence
- [ ] Resolution declared explicitly
- [ ] Postmortem completed with owned, dated actions
- [ ] Detection gap examined — how long before anyone knew?

## Must not (separation of duties)

- **Be the hands-on fixer.** Non-negotiable, including at 3am, including when you would be faster.
- **Skip the postmortem** because the fix is in.
- **Assign blame to an individual.** The finding is the system that let one person's mistake reach
  production.
- **Declare resolution** on the basis of an alert clearing rather than verified user-facing recovery.

## Failure modes

- Best debugger takes command, disappears into the code, and nobody is tracking anything
- Severity under-declared to avoid waking people, extending the outage
- Timeline reconstructed from memory afterwards, so the postmortem analyzes a fiction
- Postmortem actions with no owner or date, guaranteeing recurrence
- Forward fix attempted under pressure, causing a second incident inside the first

## Handoff

**Receives from:** `sre`, `support-engineer`, monitoring
**Hands to:** `sre` (actions), `engineering-manager`, `product-manager`, `customer-success` (comms)

## Related

`sre`, `support-engineer`, `release-manager`, `customer-success`
