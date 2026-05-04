# §0001 | Adopt @ {parent_unit_name} as parent unit

- **Status:** accepted
- **Date:** {date}
- **Authors:** scaffold initialization (via `silcrow:silcrow-add-unit`)
- **Supersedes:** —
- **Superseded by:** —
- **Influences:** §0002 (this unit's scope seed); every subsequent decision authored in `@ {unit_name}/1 | Canon/`; the local-canon-readability of `@ {unit_name}` (downstream decisions cite this for the inheritance anchor).
- **Influenced by:** `@ {agency_name}/1 | Canon/accepted/§0001` (the agency's own founding ADR, which this mirrors); §0012 (federation rule); the unit-establishing ADR in `@ {parent_unit_name}/1 | Canon/accepted/`.

## Why-statement

In the context of **`@ {unit_name}`'s establishment as a sub-unit nested inside `@ {parent_unit_name}`**,
facing the need to make ancestor-canon inheritance citable from inside `@ {unit_name}`'s own record,
we decided for **adopting `@ {parent_unit_name}` as `@ {unit_name}`'s parent unit** — accepting `@ {parent_unit_name}`'s canon (and through it, the agency's canon at `@ {agency_name}`) as the constitutional foundation of this sub-unit's record,
and neglected operating independently of ancestor canon (which would violate §0012's federation rule and is forbidden by agency structure),
to achieve a citable founding act in `@ {unit_name}`'s own canon — visible from the sub-unit alone, not just inferable through up-tree references,
accepting that this ADR formalizes a binding the federation rule already imposes,
because the discipline of having a local citable founding ADR mirrors `@ {agency_name}`'s §0001 and gives every later decision in `@ {unit_name}` a clear constitutional anchor without reaching up-tree.

## Context and problem statement

Per §0012's federation rule, every unit in the agency inherits from every ancestor unit by reference. A sub-unit's decisions are bound by every ancestor's ADRs, all the way to the agency's root.

That binding is established at the agency level, in `@ {agency_name}/1 | Canon/`. But from inside `@ {unit_name}`'s own canon, the inheritance is implicit: a reader looking at `@ {unit_name}/1 | Canon/accepted/` alone would see decisions but not the constitutional anchor they're bound by.

This ADR makes the inheritance explicit in `@ {unit_name}`'s local canon. It's the sub-unit's analog of `@ {agency_name}`'s §0001 — the founding act of recordkeeping, the first ADR every later ADR cites back to.

Every silcrow unit, root or sub, has §0001 as its founding ADR. The recursive pattern is uniform.

## Considered options

1. **Adopt `@ {parent_unit_name}` by ADR (chosen).** Make the inheritance explicit with a local founding ADR; downstream decisions in `@ {unit_name}` cite §0001 (this) for the constitutional chain.
2. **Operate independently of ancestor canon.** Rejected: violates §0012's federation rule; forbidden by agency structure.
3. **Leave inheritance implicit.** Rejected: leaves `@ {unit_name}` without a local founding ADR. Downstream decisions can only cite up-tree, breaking local-canon-readability and forcing every reader to walk to the parent before understanding the sub-unit's basis.

## Decision outcome

**Chosen option: (1) Adopt `@ {parent_unit_name}` by ADR**, because it:

- Makes the federation rule (§0012) visible in `@ {unit_name}`'s own canon.
- Gives `@ {unit_name}` a local founding ADR for downstream decisions to cite.
- Mirrors `@ {agency_name}`'s §0001 — every silcrow unit, root or sub, has a "founding" ADR as §0001. The recursive pattern is uniform.

### Consequences

- **Positive:** `@ {unit_name}`'s decisions cite §0001 (this) for the constitutional anchor without needing to reach up-tree on every reference.
- **Positive:** The Registrar's audit can verify §0001 exists in every sub-unit's canon as a structural check (a sub-unit without §0001 is missing its founding ADR).
- **Positive:** Recursive and uniform — every unit (root or sub) has a §0001 founding ADR in its local canon.
- **Neutral:** Slight duplication with §0012 (the agency-level federation rule). §0012 is the constitutional decision; §0001 (this) is its local realization. Both are needed: the constitutional decision binds in principle; the local ADR makes the binding visible in this unit's own record.

## Review trigger

Reconsider this decision if:

- The federation rule (§0012) is itself superseded or amended in the agency's canon.
- `@ {unit_name}`'s relationship to `@ {parent_unit_name}` fundamentally shifts (e.g., `@ {unit_name}` becoming a peer of `@ {parent_unit_name}` rather than a child — would require rearchitecting the agency).

In each case, write a superseding ADR; don't edit this one.

## References

- `@ {agency_name}/1 | Canon/accepted/§0001 | Adopt Silcrow Agency.md` — the agency's founding ADR; this ADR is `@ {unit_name}`'s local analog.
- `@ {agency_name}/1 | Canon/accepted/§0012 | Agency and Unit Structure.md` — the federation rule that binds `@ {unit_name}` to all ancestors.
- The unit-establishing ADR in `@ {parent_unit_name}/1 | Canon/accepted/` — the parent's canonical record that `@ {unit_name}` was established (this ADR's perspectival counterpart).
- `§0002 | @ {unit_name} Scope.md` (in this unit's own canon) — the unit's scope seed, rendered alongside this ADR at unit establishment.
- `@ {agency_name}/3 | Silcrow Agency Reference/Decision Process.md` — operational supersession rules.
