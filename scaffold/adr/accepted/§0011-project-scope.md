# §0011 — Project scope

- **Status:** accepted
- **Date:** {date}
- **Authors:** scaffold initialization (inherited via §0001)
- **Supersedes:** —
- **Superseded by:** —
- **Influences:** every decision that references project scope or north star; most prominently, the first {lead_role}-tier architectural ADRs.
- **Influenced by:** §0001

## Seed notice

**This ADR is a seed — expand it early.**

The body below captures what was said at scaffold time. This is intentionally thin. One of the first collaborative tasks for {user_role} and the {lead_role} is to supersede this ADR with a richer scope statement: what the project is for, who it serves, what is and isn't in scope, what "done" looks like in the near and medium term.

Supersession (see §0004 and `docs/decision-process.md`) is the normal update path. The supersession chain of this ADR becomes the project's scope-evolution history — a readable narrative of how the project's vision sharpened or shifted over time.

## Context and problem statement

**Inherited decision.** This is a founding constitutional decision inherited from the agent-org-scaffold skill via §0001 at project initialization.

Every architectural and implementation decision made in this scaffold cites back — directly or transitively — to project scope. Without a citable scope statement, later decisions lack a resolvable north star, and the question "was this in scope?" has no authoritative answer. This ADR establishes the seat where that answer lives, from Day 1, even before the scope is fully articulated.

## Initial scope

{project_description}

## Considered options

1. **Project scope as an ADR (chosen).** Scope lives as a first-class decision record, supersedable as the project's vision evolves. Citable from every downstream decision.
2. **Prose in `README.md`.** Scope description lives in a mutable file; edits silently overwrite history.
3. **No formal scope artifact.** Scope is implicit in whatever decisions get made; no single citable statement exists.

## Decision outcome

**Chosen option: (1) Project scope as an ADR.**

Scope constrains everything below it — module boundaries, staffing, timelines, what's in and what isn't. A mutable README-style description drifts silently and loses the historical arc of how the project's vision developed. The ADR discipline (§0004) forces changes to be visible, dated, reasoned, and citable. Supersession is the natural update path: as scope sharpens or pivots, new scope ADRs replace old ones and the full chain is preserved.

Option 2 (README prose) was the common default in pre-ADR practice and produced measurable drift in long-lived projects (see the decision-rationale-loss literature cited in `docs/foundations/04-architecture-decision-records.md`). Option 3 (implicit scope) makes "was this in scope?" unanswerable by design.

### Consequences

- **Positive:** Every downstream decision has a citable scope statement.
- **Positive:** Scope evolution is an auditable narrative, not a git-log reconstruction.
- **Positive:** The seed lets the scaffold stand up immediately without forcing a full scope debate at init.
- **Neutral:** Expansion requires a normal supersession ADR (use `madr-full.md` for a serious scope statement).
- **Negative:** A project that never supersedes this seed leaves a thin scope statement in `accepted/`. That's a drift signal worth catching.

## Review trigger

**First review: expand this seed.** As soon as {user_role} and the {lead_role} have aligned on what the project is for, author a superseding ADR with a richer scope statement.

Subsequent reviews when:

- The project's target users or use cases shift materially.
- A new major feature is contemplated that doesn't fit the current scope.
- At natural cadences (quarterly, annually) for a health check.

## References

- `../../README.md` — the project's orientation doc; describes structure but defers scope to this ADR.
- `§0001` — the founding decision that establishes this project and references the original scope phrase in context.
- `§0004` — the immutability discipline that makes supersession the update mechanism.
- `../../docs/decision-process.md` — operational supersession rules.
