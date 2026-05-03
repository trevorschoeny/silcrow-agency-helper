# §0014 | Update audits produce per-session audit ADRs

- **Status:** accepted
- **Date:** {date}
- **Authors:** scaffold initialization (inherited via §0001)
- **Supersedes:** —
- **Superseded by:** —
- **Influences:** every `:silcrow-update` skill invocation; how rejections and deferrals during updates are recorded and later consulted.
- **Influenced by:** §0001, §0002, §0004, §0010, §0012

## Why-statement

In the context of **an agency that periodically reconciles with the plugin's evolving canonical state via the `:silcrow-update` skill**,
facing the need to record rejections and deferrals canonically (acceptances are already canonical via new ADRs in `accepted/`) so that past choices are not silently re-litigated on every subsequent update,
we decided for **one canonical audit ADR per `:silcrow-update` invocation** summarizing the entire session — what was reviewed, accepted, rejected, and deferred — authored by the Registrar at the end of the session —
and neglected one ADR per individual decision (would proliferate ADRs rapidly), an ever-growing mutable audit log (would violate §0004 immutability), and inbox-archive-only storage (not canonical, re-litigates on next update),
to achieve a decision record that respects past user choices and surfaces deferrals when they're ready to be revisited, without flooding the ADR space with per-item records,
accepting that the Registrar must author one additional ADR per `:silcrow-update` invocation and that the one-per-session structure bundles heterogeneous decisions into a single ADR,
because real-world audit traditions (corporate audit, university review, peer review rounds) produce one audit record per session rather than one per item, and the canon/operational rule (§0012) requires binding decisions to be canonical.

## Context and problem statement

The `:silcrow-update` skill hands off to the Registrar, who dynamically diffs the plugin's current canonical state against the agency's current state and proposes a set of changes to User and Lead. The user responds per item: accept, reject, defer, or request more detail.

**Acceptances are already recorded canonically.** An accepted plugin ADR lands in `@ {unit_name}/1 | Canon/accepted/` with its own §-number. That's a canonical record of "yes, we adopted this."

**Rejections and deferrals are not.** Without an explicit mechanism, a rejection lives only in the inbox-thread archive. On the next `:silcrow-update` invocation, the Registrar has no canonical record of the rejection and would re-propose the same item, re-litigating resolved matters and disrespecting past user choices. A deferral is similar — without a canonical record, the deferral's "revisit at X" trigger is lost.

This ADR closes the gap.

## Decision drivers

- **Respect past decisions.** A rejection is a decision; a deferral is a decision with a trigger. Both are canonical per §0012's direction-of-constraint principle (they bind how future audits behave).
- **Preserve immutability (§0004).** Whatever form the record takes must not be a mutable growing log.
- **Avoid ADR proliferation.** A busy agency might have dozens of items per `:silcrow-update` invocation. One ADR per item would flood the §-number space.
- **Match real-world audit practice.** Corporate audits, university reviews, and peer review rounds produce one audit record per session. This is a well-understood pattern.
- **Keep the record traceable.** The Registrar must be able to look up "what happened in the last audit?" quickly when preparing the next one.

## Considered options

1. **No canonical record of rejections/deferrals.** Inbox archive only.
2. **One ADR per individual decision (per-accept, per-reject, per-defer).**
3. **Ever-growing mutable audit log (`docs/audit-log.md` or similar).**
4. **One canonical audit ADR per `:silcrow-update` invocation (chosen).**

## Decision outcome

**Chosen option: (4).**

Each `:silcrow-update` invocation produces **one canonical ADR** summarizing the entire audit session. The Registrar authors it at the end of the session, landing it in `@ {unit_name}/1 | Canon/accepted/` with its own §-number. The ADR is immutable per §0004; reconsideration produces a new audit ADR that joins the old one in the record.

Option (1) discards the decision content. Option (2) floods the §-number space and fragments a single session across many records. Option (3) violates §0004 (the log is mutable) and collapses discrete sessions into one blended document.

Option (4) matches how real-world audits work. A Big-4 audit produces one audit report per audit, not one per finding. A university external review produces one review report per cycle, not one per recommendation. Peer review for a paper produces one review letter, not one per comment. The structural pattern is the same here.

### Structure of an update-audit ADR

```
§00XX — Update audit, YYYY-MM-DD

Why-statement:
  In the context of keeping the agency aligned with the plugin's
  evolving canonical state, facing the arrival of <N> proposed
  changes from the current plugin, we decided to accept <A>,
  reject <B>, and defer <C>, and neglected bulk-accept and
  bulk-reject, to achieve an agency that adopts aligned changes
  while preserving local character, accepting the ongoing cost
  of periodic audit dialogue, because the direction-of-constraint
  rule (§0012) requires each change to pass through deliberate
  review.

Accepted (now in @ {unit_name}/1 | Canon/accepted/ under their assigned §-numbers):
  - §00YY — <descriptor of accepted plugin ADR>
  - §00ZZ — <descriptor>

Rejected (user's reasoning preserved):
  - Plugin's proposed <ADR descriptor> — reason: <user's words or summary>
  - Plugin's proposed <file/doc change> — reason: <...>

Deferred (notes on when/why to revisit):
  - Plugin's proposed <change> — deferred until <context>; revisit at <trigger>

File-level changes applied:
  <summary — paths moved, content merged, archivals, etc.>
```

Each audit ADR is immutable per §0004. Future invocations produce new audit ADRs rather than modifying old ones — the record of past decisions grows monotonically.

### How the Registrar consults past audit ADRs

On every subsequent `:silcrow-update` invocation, the Registrar scans `@ {unit_name}/1 | Canon/accepted/` for past audit ADRs before writing a new report. From those it determines:

- **Skip re-proposing rejected items** if the plugin's current version is the same as what was previously rejected. The Registrar summarizes in the new report rather than re-asking: *"2 items previously rejected in §00XX remain in the plugin's current state; skipping per your past decision. Let me know if you want to reconsider."*
- **Re-surface deferred items** with their original context: *"Previously deferred in §00YY — the reason was [context]. Ready to decide now?"*
- **Respect local supersessions** that emerged from past conflict resolutions. If a past audit authored a merged ADR to resolve a conflict, the Registrar treats that merged ADR as canonical ground and doesn't re-propose the plugin's original version.

### Reconsidering past decisions

The audit-ADR pattern doesn't lock past decisions in forever. The user can ask the Registrar to re-surface previously rejected items at any time (*"re-propose what I rejected in §00XX"*). A reconsideration produces a new audit ADR — the prior rejection isn't erased; it's joined by a newer decision. The record captures the full evolution of the user's thinking.

### Consequences

- **Positive:** Rejections and deferrals are canonically recorded; past choices are respected on subsequent audits.
- **Positive:** Deferrals carry their revisit trigger forward; the Registrar can re-surface them when the trigger fires.
- **Positive:** One ADR per session keeps the §-number space clean even for busy agencies.
- **Positive:** Matches well-understood real-world audit patterns.
- **Negative:** The Registrar must author one extra ADR per `:silcrow-update` invocation (a small but nontrivial cost).
- **Negative:** One ADR per session bundles heterogeneous decisions — a reader has to parse the audit ADR's structure to find a specific item.
- **Neutral:** Accepted items are double-recorded in a sense — once as their own ADR in `accepted/`, once as a reference in the audit ADR's "Accepted" section. This is deliberate: the audit ADR is the session summary; the accepted ADRs are the substantive decisions.

## Anti-patterns surfaced

- **Re-proposing previously rejected items without checking.** If the Registrar doesn't scan past audit ADRs before preparing a new report, it re-litigates resolved matters. The Registrar's playbook must include this scan.
- **Editing an existing audit ADR.** Violates §0004. Reconsideration produces a new audit ADR, never an edit.
- **Bundling accepted items into the audit ADR without also filing them as standalone ADRs.** The audit ADR summarizes; the accepted items have their own §-numbers in `accepted/`. Both records coexist.
- **Deferral without a trigger.** A deferral without a specified revisit condition degrades into indefinite avoidance. The Registrar should prompt for a trigger when logging a deferral.

## Review trigger

Reconsider this ADR if:

- Audit ADRs in practice become unreadably long (suggests splitting is warranted — e.g., one per category: accepts, rejects, defers).
- The one-per-session structure creates confusion when an audit spans multiple days (in which case a sessions-by-calendar-week grouping might be better).
- A structurally different update mechanism replaces the `:silcrow-update` skill (in which case this ADR is superseded with the new mechanism's pattern).

## References

- `../../Registrar @ {unit_name}/AGENTS.md` — `:silcrow-update` orchestration, audit-ADR authoring, and past-audit scanning on subsequent invocations.
- §0002 — MADR+Why-statement format used by audit ADRs.
- §0004 — immutability; audit ADRs are immutable like any other ADR.
- §0010 — Registrar as async auditor; the `:silcrow-update` workflow is the most elaborate audit.
- §0012 — canon/operational rule; rejections/deferrals are canonical because they bind future audit behavior.
- §0016 — governance commit convention; audit ADRs are committed with `§NNNN: update audit — <summary>`.
