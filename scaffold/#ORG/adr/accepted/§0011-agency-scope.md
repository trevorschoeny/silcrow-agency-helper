# §0011 — Agency scope

- **Status:** accepted
- **Date:** {date}
- **Authors:** scaffold initialization (inherited via §0001)
- **Supersedes:** —
- **Superseded by:** —
- **Influences:** every decision that references agency scope or north star; most prominently, the first {lead_role}-tier architectural ADRs; every unit-establishing ADR (scope violations caught during Registrar audit).
- **Influenced by:** §0001, §0015

## Seed notice

**This ADR is a seed — expand it early.**

The body below captures what was said at scaffold time. This is intentionally thin. One of the first collaborative tasks for {user_role} and the {lead_role} is to supersede this ADR with a richer scope statement: what the agency is for, who it serves, what is and isn't in scope, what "done" looks like in the near and medium term.

Supersession (see §0004 and `docs/decision-process.md`) is the normal update path. The supersession chain of this ADR becomes the agency's scope-evolution history — a readable narrative of how the agency's vision sharpened or shifted over time.

## Context and problem statement

**Inherited decision.** This is a founding constitutional decision inherited from the agent-org-scaffold skill via §0001 at scaffold time.

Every architectural and implementation decision made in this agency cites back — directly or transitively — to agency scope. Without a citable scope statement, later decisions lack a resolvable north star, and the question "was this in scope?" has no authoritative answer. This ADR establishes the seat where that answer lives, from Day 1, even before the scope is fully articulated.

In multi-unit agencies (§0015), agency scope binds all units. A unit-level decision that exceeds agency scope is a scope violation, which the Registrar surfaces during audit (§0012). Units may have their own unit-level scope ADRs that further narrow within agency scope, but they may never widen it.

## Initial scope

{agency_description}

## Considered options

1. **Agency scope as an ADR (chosen).** Scope lives as a first-class decision record, supersedable as the agency's vision evolves. Citable from every downstream decision.
2. **Prose in `README.md`.** Scope description lives in a mutable file; edits silently overwrite history.
3. **No formal scope artifact.** Scope is implicit in whatever decisions get made; no single citable statement exists.

## Decision outcome

**Chosen option: (1) Agency scope as an ADR.**

Scope constrains everything below it — unit boundaries, staffing, timelines, what's in and what isn't. A mutable README-style description drifts silently and loses the historical arc of how the agency's vision developed. The ADR discipline (§0004) forces changes to be visible, dated, reasoned, and citable. Supersession is the natural update path: as scope sharpens or pivots, new scope ADRs replace old ones and the full chain is preserved.

Option 2 (README prose) was the common default in pre-ADR practice and produced measurable drift in long-lived projects (see the decision-rationale-loss literature cited in `docs/foundations/04-architecture-decision-records.md`). Option 3 (implicit scope) makes "was this in scope?" unanswerable by design.

### Consequences

- **Positive:** Every downstream decision has a citable scope statement.
- **Positive:** Scope evolution is an auditable narrative, not a git-log reconstruction.
- **Positive:** The seed lets the scaffold stand up immediately without forcing a full scope debate at init.
- **Positive:** In multi-unit agencies, scope violations are programmatically audit-able (Registrar checks unit ADRs against this one).
- **Neutral:** Expansion requires a normal supersession ADR (use `madr-full.md` for a serious scope statement).
- **Negative:** An agency that never supersedes this seed leaves a thin scope statement in `accepted/`. That's a drift signal worth catching.

## Review trigger

**First review: expand this seed.** As soon as {user_role} and the {lead_role} have aligned on what the agency is for, author a superseding ADR with a richer scope statement.

Subsequent reviews when:

- The agency's target users or use cases shift materially.
- A new major feature, unit, or initiative is contemplated that doesn't fit the current scope.
- At natural cadences (quarterly, annually) for a health check.
- A unit's proposed ADR appears to exceed current agency scope (a scope-violation flag surfaced by Registrar audit).

## References

- `../../README.md` — the agency's orientation doc; describes structure but defers scope to this ADR.
- `§0001` — the founding decision that establishes this agency and references the original scope phrase in context.
- `§0004` — the immutability discipline that makes supersession the update mechanism.
- `§0012` — Registrar's audit checklist includes scope-violation detection.
- `§0015` — agency and unit structure; agency scope binds all units.
- `../../docs/decision-process.md` — operational supersession rules.
