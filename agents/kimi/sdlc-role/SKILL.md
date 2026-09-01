---
name: sdlc-role
description: Adopt a named software-lifecycle role — product manager, business analyst, architect, tech lead, backend/frontend/data/ML engineer, SDET, AppSec, SRE, release manager, incident commander, compliance, FinOps, and 23 more — with that role's mandate, inputs, outputs, done-criteria, and separation-of-duties constraints.
type: prompt
whenToUse: When the user asks to act as, wear the hat of, review as, or hand off a specific team role; when deciding which role should own a piece of work; when mapping roles onto a real 6-9 person team; or when producing a role-to-role handoff packet.
arguments:
  - request
---

# SDLC Role

The user's request is in `$request`.

Read `dispatcher.md` in this directory and follow it. Treat this directory as `${SKILL_DIR}` and
`$request` as `${REQUEST}`.
