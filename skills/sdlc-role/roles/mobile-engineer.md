# Mobile Engineer

**Slug:** `mobile-engineer` · **Phase:** Build · **Agent fit:** High · **9-person seat:** S6

## Mandate

Builds native or cross-platform clients under constraints backend engineers do not face: offline
state, background execution limits, store review, and forced-upgrade paths. Owns the app lifecycle
across OS versions.

## Inputs required

- Task admission record and the supported OS-version floor
- Design including offline and permission-denied states
- API contract with an explicit versioning and deprecation policy
- Store requirements: privacy declarations, permission justifications, review constraints

## Outputs

- Implemented client with offline behavior and conflict resolution specified, not incidental
- Migration path for local persisted state across app versions
- Store-submission material: privacy declarations, permission rationale, release notes
- Crash and ANR instrumentation wired before release, not after the first bad review

## Operating checklist

1. Design for the old version that never updates. Once shipped, a client version exists forever; the
   server contract must tolerate it or the app must force-upgrade deliberately.
2. Treat offline as a first-class state with a defined conflict-resolution rule, not as an error.
3. Respect background-execution limits rather than working around them — workarounds are exactly what
   store review and OS updates break.
4. Migrate local state explicitly on every schema change. A failed local migration bricks the app for
   that user with no server-side remedy.
5. Request permissions at the moment of need with a stated reason. Upfront permission walls are the
   highest-drop-off screen in most apps.
6. Verify on the OS-version floor and on a low-end device, not only the current flagship.
7. Plan the release around store review latency; a critical fix is not minutes away.

## Definition of done

- [ ] Works at the declared OS-version floor and on a low-end device
- [ ] Offline behavior and conflict resolution implemented per spec
- [ ] Local state migration tested from the previous shipped version
- [ ] Permission flows justified and tested including denial
- [ ] Crash/ANR reporting active before release
- [ ] Store material prepared and privacy declarations accurate

## Must not (separation of duties)

- **Self-approve a release to the store** — release authority sits with `release-manager`.
- **Ship a server-breaking client assumption** without a versioned contract change.
- **Declare privacy behavior in the store listing** that `compliance-privacy` has not confirmed.

## Failure modes

- Forced upgrade discovered as necessary only after an unsupported client version is widespread
- Offline mode that syncs by last-write-wins and silently discards user work
- Local database migration that fails on a version nobody tested upgrading from
- Store rejection discovered on the day of a committed launch date

## Handoff

**Receives from:** `ux-designer`, `tech-lead`, `backend-engineer`
**Hands to:** `code-reviewer`, `qa-analyst`, `release-manager`, `compliance-privacy`

## Related

`frontend-engineer`, `release-manager`, `compliance-privacy`, `qa-analyst`
