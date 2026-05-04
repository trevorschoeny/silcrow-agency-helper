# §0002 | @ {unit_name} Scope

- **Status:** accepted
- **Date:** {date}
- **Authors:** scaffold initialization (inherited via §0001)
- **Supersedes:** —
- **Superseded by:** —
- **Influences:** every decision authored inside `@ {unit_name}/1 | Canon/`; every ADR that references this unit's scope or boundaries; sub-sub-unit-establishing ADRs nested inside `@ {unit_name}` (scope violations caught during Registrar audit).
- **Influenced by:** §0001 (this unit's local founding ADR); §0017 in `@ {agency_name}/1 | Canon/accepted/` (agency scope — `@ {unit_name}`'s scope must fit within agency scope per §0012's federation rule); §0004 (immutability and supersession); the unit-establishing ADR in `@ {parent_unit_name}/1 | Canon/accepted/`.

## Seed notice — DO NOT EDIT THIS ADR; SUPERSEDE IT

**This ADR is a seed.** Like the root unit's §0017 (Agency Scope), the body below is intentionally thin — it is `@ {unit_name}`'s first lesson in the supersession discipline that governs every binding decision in this scaffold.

To replace this with a richer scope statement, *supersede* it via §0004:

1. Author a new ADR with the next available §-number in `@ {unit_name}`'s canon — typically §0003 if no other ADRs have been authored in `@ {unit_name}` yet.
2. In the new ADR's header, set `Supersedes: §0002`.
3. Move §0002 from `accepted/` to `superseded/` (filename unchanged) and update its `Superseded by:` to point to the new ADR.
4. Append a one-paragraph retrospective note at the bottom of §0002 explaining the supersession (this is the only permitted post-acceptance body change per §0004).
5. The Registrar handles steps 3–4 mechanically if `{lead_role} @ {unit_name}` asks; or the Lead can do them directly.

**Editing this ADR in place violates §0004's immutability discipline.** Same rule as the agency-level §0017: supersede, don't edit.

This pattern (seed → supersession) is the same one used for every binding decision `@ {unit_name}` will ever make. §0002 is positioned right after the founding §0001 deliberately — it is the next ADR `{lead_role} @ {unit_name}` authors against. By superseding it as your first collaborative act with `{parent_lead_role} @ {parent_unit_name}` (or `{user_role}` for agency-relevant scope decisions), you teach `@ {unit_name}`'s record how decisions evolve here.

The body below captures what was said at unit establishment. One of the first collaborative tasks for `{lead_role} @ {unit_name}` (with `{parent_lead_role} @ {parent_unit_name}` or `{user_role}` as appropriate) is to supersede §0002 with a richer scope statement: what `@ {unit_name}` is for, what it owns, what it doesn't, what "done" looks like in the near and medium term — within the bounds of agency scope (§0017) and any intermediate ancestor unit's scope.

## Context and problem statement

**Inherited at unit establishment.** This is `@ {unit_name}`'s scope seat, paralleling §0017 at the agency level.

Every decision authored in `@ {unit_name}`'s canon cites back — directly or transitively — to this unit's scope. Without a citable scope statement, later decisions in `@ {unit_name}` lack a resolvable north star, and the question "was this in scope?" has no authoritative local answer.

`@ {unit_name}`'s scope must fit within agency scope (the root unit's §0017 chain) and `@ {parent_unit_name}`'s scope per §0012's federation rule. A unit-scope ADR that exceeded an ancestor's scope would be flagged by `@ {unit_name}`'s Registrar during audit (§0009).

## Initial scope

{unit_purpose}

## Considered options

1. **Unit scope as an ADR (chosen).** Scope lives as a first-class decision record, supersedable as `@ {unit_name}`'s vision evolves. Citable from every decision authored within the unit.
2. **Prose in `@ {unit_name}`'s `README.md`.** Scope description lives in a mutable file; edits silently overwrite history.
3. **No formal unit-scope artifact.** Scope is implicit in whatever decisions get made; no single citable statement exists at the unit level.

## Decision outcome

**Chosen option: (1) Unit scope as an ADR.**

Same rationale as agency scope (§0017): scope constrains everything below it; mutable READMEs drift silently and lose the historical arc; the ADR discipline (§0004) forces changes to be visible, dated, reasoned, and citable. Supersession is the natural update path.

### Consequences

- **Positive:** Every decision in `@ {unit_name}`'s canon has a citable scope statement.
- **Positive:** Scope evolution within `@ {unit_name}` is an auditable narrative, not a git-log reconstruction.
- **Positive:** The seed lets `@ {unit_name}` stand up immediately without forcing a full scope debate at establishment.
- **Positive:** `@ {unit_name}`'s Registrar can audit decisions for scope-violation programmatically against this seat.
- **Neutral:** Expansion requires a normal supersession ADR (use `MADR Full.md` for a serious scope statement).
- **Negative:** A unit that never supersedes this seed leaves a thin scope statement in `accepted/`. That's a drift signal worth catching.

## Review trigger

**First review: supersede this seed (do not edit it).** As soon as `{lead_role} @ {unit_name}` (with `{parent_lead_role} @ {parent_unit_name}` or `{user_role}` as appropriate) have aligned on what `@ {unit_name}` is for, author a superseding ADR with a richer scope statement following the supersession ceremony in the seed notice above.

Subsequent reviews when:

- `@ {unit_name}`'s focus or use cases shift materially.
- A new major effort or sub-sub-unit is contemplated within `@ {unit_name}` that doesn't fit current scope.
- At natural cadences (quarterly, annually) for a health check.
- A sub-sub-unit's proposed ADR appears to exceed `@ {unit_name}`'s current scope (a scope-violation flag surfaced by that sub-unit's Registrar during audit).

## References

- `@ {unit_name}/README.md` — `@ {unit_name}`'s orientation doc; describes structure but defers scope to this ADR.
- `§0001` (this unit's local founding) — the inheritance anchor for `@ {unit_name}`'s canon.
- `@ {agency_name}/1 | Canon/accepted/§0004 | Immutability and Supersession.md` — the immutability discipline that makes supersession the update mechanism.
- `@ {agency_name}/1 | Canon/accepted/§0009 | Registrar as Async Auditor.md` — Registrar's audit checklist includes scope-violation detection.
- `@ {agency_name}/1 | Canon/accepted/§0012 | Agency and Unit Structure.md` — agency and unit structure; agency scope binds every unit in the tree.
- `@ {agency_name}/1 | Canon/accepted/§0017 | Agency Scope.md` — agency scope (the root unit's scope chain), which constrains `@ {unit_name}`'s scope.
- The unit-establishing ADR in `@ {parent_unit_name}/1 | Canon/accepted/` — the parent's canonical record that `@ {unit_name}` was established.
- `@ {agency_name}/3 | Silcrow Agency Reference/Decision Process.md` — operational supersession rules.
