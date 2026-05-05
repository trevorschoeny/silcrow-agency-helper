# §0018 | Agency scope

- **Status:** accepted
- **Date:** {date}
- **Agency:** {agency_name}
- **Unit:** {unit_name}
- **Authors:** scaffold initialization (inherited via §0001)
- **Supersedes:** —
- **Superseded by:** —
- **Influences:** every decision that references agency scope or north star; most prominently, the first {lead_role}-tier architectural ADRs at the root unit; every unit-establishing ADR (scope violations caught during Registrar audit).
- **Influenced by:** §0001, §0012, §0017

## Why-statement

In the context of **a newly-scaffolded agency that does not yet have an articulated scope statement**,
facing the need for every downstream decision to cite *some* scope ADR — even before the {user_role} and {lead_role} have aligned on what the agency is for —
we decided for **shipping a thin scope seed at scaffold time** as the highest-numbered seeded ADR (§0018), expected to be superseded with a richer scope ADR when the agency is ready,
and neglected leaving scope unrecorded (no citable seat) and forcing a full scope debate at scaffold init (blocks bootstrap),
to achieve a citable scope seat from Day 1 that downstream ADRs can reference, plus a natural first-supersession exercise once the scope conversation has actually happened,
accepting that until the seed is superseded, "agency scope" resolves to a thin one-line statement,
because the alternative — no scope ADR at all — leaves "was this in scope?" with no authoritative answer, and forcing a synchronous scope debate at scaffold time is heavier than the seed-then-supersede pattern this scaffold uses everywhere else.

## Seed notice — supersede; don't edit

**This ADR is a seed.** The thin body below is intentional. Like every binding decision in this scaffold, scope is recorded as an ADR rather than as mutable prose; replacing it follows the supersession discipline (§0004), not in-place editing.

When the {user_role} and {lead_role} have aligned on a richer scope statement — what the agency is for, who it serves, what's in and out, what near-term "done" looks like — supersede §0018 via the standard ceremony (§0004): author a new ADR with `Supersedes: §0018` in its header, move §0018 from `accepted/` to `superseded/`, append a one-paragraph retrospective note. The Registrar handles steps 3–4 mechanically if the Lead asks; or the Lead can do them directly.

**There is no urgency.** The seed can sit in `accepted/` indefinitely. Sometimes the supersession is the first ADR an agency authors; sometimes it happens later, after other foundational decisions have settled. The pattern (seed → supersession) is the same one that governs every binding decision the agency will ever make — building the muscle on a low-stakes ADR is the value, whenever the supersession actually happens.

**Editing §0018 in place violates §0004's immutability discipline.** It also loses the supersession chain — the readable narrative of how the agency's scope sharpened or shifted over time. Every future scope-related decision will cite back through the chain; breaking it once breaks it permanently.

## Context and problem statement

**Inherited decision.** This is a founding constitutional decision inherited from the Silcrow plugin via §0001 at scaffold time.

Every architectural and implementation decision made in this agency cites back — directly or transitively — to agency scope. Without a citable scope statement, later decisions lack a resolvable north star, and the question "was this in scope?" has no authoritative answer. This ADR establishes the seat where that answer lives, from Day 1, even before the scope is fully articulated.

In agencies with sub-units (§0012), agency scope — the root unit's §0018 — binds every unit in the tree. A sub-unit decision that exceeds agency scope is a scope violation, which that sub-unit's Registrar surfaces during audit (§0009). Sub-units may have their own scope ADRs that further narrow within agency scope, but they may never widen it.

## Decision drivers

- **A citable scope seat is needed from Day 1.** Without one, downstream ADRs have nowhere to point.
- **Forcing scope debate at scaffold time is heavier than seed-then-supersede.** The scaffold's whole pattern is "ship a working state, evolve via ADRs"; scope follows the same logic.
- **The supersession discipline (§0004) needs a low-stakes first practice opportunity.** The scope seed serves this naturally whenever the supersession happens.

## Initial scope

{agency_description}

## Considered options

1. **Agency scope as an ADR (chosen).** Scope lives as a first-class decision record, supersedable as the agency's vision evolves. Citable from every downstream decision.
2. **Prose in `README.md`.** Scope description lives in a mutable file; edits silently overwrite history.
3. **No formal scope artifact.** Scope is implicit in whatever decisions get made; no single citable statement exists.

## Decision outcome

**Chosen option: (1) Agency scope as an ADR.**

Scope constrains everything below it — unit boundaries, staffing, timelines, what's in and what isn't. A mutable README-style description drifts silently and loses the historical arc of how the agency's vision developed. The ADR discipline (§0004) forces changes to be visible, dated, reasoned, and citable. Supersession is the natural update path: as scope sharpens or pivots, new scope ADRs replace old ones and the full chain is preserved.

Option 2 (README prose) was the common default in pre-ADR practice and produced measurable drift in long-lived projects (see the decision-rationale-loss literature cited in `3 | Silcrow Agency Reference/foundations/04 | Architecture Decision Records.md`). Option 3 (implicit scope) makes "was this in scope?" unanswerable by design.

### Consequences

- **Positive:** Every downstream decision has a citable scope statement.
- **Positive:** Scope evolution is an auditable narrative, not a git-log reconstruction.
- **Positive:** The seed lets the scaffold stand up immediately without forcing a full scope debate at init.
- **Positive:** In agencies with sub-units, scope violations are programmatically auditable (each unit's Registrar checks the unit's ADRs against ancestor scope ADRs).
- **Neutral:** Expansion requires a normal supersession ADR (use `MADR Full.md` for a serious scope statement).
- **Negative:** An agency that never supersedes this seed leaves a thin scope statement in `accepted/`. Not catastrophic — the seed is functional — but worth the {lead_role} and {user_role} eventually addressing.

## Pros and cons of the options

### (1) Agency scope as an ADR

- ✅ Citable, immutable, supersedable.
- ✅ Scope evolution is an auditable narrative.
- ❌ Authors must use the supersession ceremony (heavier than editing prose).

### (2) Prose in `README.md`

- ✅ Easy to edit.
- ❌ No history of how scope evolved.
- ❌ Not a stable citation target for downstream ADRs.

### (3) No formal scope artifact

- ✅ Zero upfront work.
- ❌ "Was this in scope?" is unanswerable.
- ❌ No constraint on downstream decisions.

## Anti-patterns surfaced

- **Editing the scope seed in place** instead of superseding it. Violates §0004; loses the supersession chain that future scope ADRs will cite back through.

## Review trigger

Reconsider this ADR when:

- The agency's target users or use cases shift materially.
- A new major feature, unit, or initiative is contemplated that doesn't fit the current scope.
- At natural cadences (quarterly, annually) for a health check.
- A sub-unit's proposed ADR appears to exceed current agency scope (a scope-violation flag surfaced by that sub-unit's Registrar during audit).

## References

- `../../README.md` — the agency's orientation doc; describes structure but defers scope to this ADR.
- `§0001` — the founding decision that establishes this agency and references the original scope phrase in context.
- `§0004` — the immutability discipline that makes supersession the update mechanism.
- `§0009` — Registrar's audit checklist includes scope-violation detection.
- `§0012` — agency and unit structure; agency scope binds every unit in the tree.
- `§0017` — honest minimalism; this ADR follows that discipline (every section present; single honest sentence where substance is thin).
- `../../3 | Silcrow Agency Reference/Decision Process.md` — operational supersession rules.
