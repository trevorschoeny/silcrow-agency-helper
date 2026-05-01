# §0019 — Agency scope

- **Status:** accepted
- **Date:** {date}
- **Authors:** scaffold initialization (inherited via §0001)
- **Supersedes:** —
- **Superseded by:** —
- **Influences:** every decision that references agency scope or north star; most prominently, the first {lead_role}-tier architectural ADRs at the root unit; every unit-establishing ADR (scope violations caught during Registrar audit).
- **Influenced by:** §0001, §0014

## Seed notice — DO NOT EDIT THIS ADR; SUPERSEDE IT

**This ADR is a seed. The thin body below is intentional — it is the agency's *first lesson* in the supersession discipline that governs every ADR in this scaffold.**

To replace §0019 with a richer scope statement, *supersede* it via §0004:

1. Author a new ADR with the next available §-number (§0020 if none exist yet beyond the seed set).
2. In the new ADR's header, set `Supersedes: §0019`.
3. Move §0019 from `accepted/` to `superseded/` (filename unchanged) and update its `Superseded by:` to point to the new ADR.
4. Append a one-paragraph retrospective note at the bottom of §0019 explaining the supersession (this is the only permitted post-acceptance body change per §0004).
5. The Registrar handles steps 3–4 mechanically if the Lead asks; or the Lead can do them directly.

**Editing §0019 in place violates §0004's immutability discipline.** It also loses the supersession chain — the readable narrative of how the agency's scope sharpened or shifted over time. Every future scope-related decision will cite back through the chain; breaking it once breaks it permanently.

This pattern (seed → supersession) is the same one used for every binding decision the agency will ever make. §0019 is positioned at the end of the founding set deliberately — it is the next ADR you author against, not part of the immutable constitutional core. By superseding it as your first collaborative act, you teach the agency how decisions evolve here. Mess up the supersession ceremony on §0019 and you'll learn the discipline on a low-stakes ADR; nail it, and you've built the muscle for every supersession that follows.

The body below captures what was said at scaffold time. One of the first collaborative tasks for {user_role} and the {lead_role} is to supersede §0019 with a richer scope statement: what the agency is for, who it serves, what is and isn't in scope, what "done" looks like in the near and medium term.

## Context and problem statement

**Inherited decision.** This is a founding constitutional decision inherited from the Silcrow plugin via §0001 at scaffold time.

Every architectural and implementation decision made in this agency cites back — directly or transitively — to agency scope. Without a citable scope statement, later decisions lack a resolvable north star, and the question "was this in scope?" has no authoritative answer. This ADR establishes the seat where that answer lives, from Day 1, even before the scope is fully articulated.

In agencies with sub-units (§0014), agency scope — the root unit's §0019 — binds every unit in the tree. A sub-unit decision that exceeds agency scope is a scope violation, which that sub-unit's Registrar surfaces during audit (§0011). Sub-units may have their own scope ADRs that further narrow within agency scope, but they may never widen it.

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
- **Positive:** In agencies with sub-units, scope violations are programmatically auditable (each unit's Registrar checks the unit's ADRs against ancestor scope ADRs).
- **Neutral:** Expansion requires a normal supersession ADR (use `madr-full.md` for a serious scope statement).
- **Negative:** An agency that never supersedes this seed leaves a thin scope statement in `accepted/`. That's a drift signal worth catching.

## Review trigger

**First review: supersede this seed (do not edit it).** As soon as {user_role} and the {lead_role} have aligned on what the agency is for, author a superseding ADR with a richer scope statement following the supersession ceremony in the seed notice above.

Subsequent reviews when:

- The agency's target users or use cases shift materially.
- A new major feature, unit, or initiative is contemplated that doesn't fit the current scope.
- At natural cadences (quarterly, annually) for a health check.
- A sub-unit's proposed ADR appears to exceed current agency scope (a scope-violation flag surfaced by that sub-unit's Registrar during audit).

## References

- `../../README.md` — the agency's orientation doc; describes structure but defers scope to this ADR.
- `§0001` — the founding decision that establishes this agency and references the original scope phrase in context.
- `§0004` — the immutability discipline that makes supersession the update mechanism.
- `§0011` — Registrar's audit checklist includes scope-violation detection.
- `§0014` — agency and unit structure; agency scope binds every unit in the tree.
- `../../docs/decision-process.md` — operational supersession rules.
