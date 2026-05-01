# §NNNN — Establish unit @{unit_name}

- **Status:** accepted <!-- populated by :silcrow-add-unit -->
- **Date:** {date}
- **Authors:** {authoring_lead_or_user} (via `silcrow:silcrow-add-unit`)
- **Supersedes:** —
- **Superseded by:** —
- **Influences:** every subsequent operational artifact scoped to `@{unit_name}`; every ADR authored inside `@{unit_name}/#ORG@{unit_name}/adr/`.
- **Influenced by:** §0010 (roster change protocol), §0019 (agency scope), §0014 (agency and unit structure).

## Y-statement

In the context of **`@{parent_unit_name}`'s need to {reason_for_unit}**,
facing the growing scope of **{area_of_concern}**,
we decided for **establishing a new sub-unit, `@{unit_name}`**, nested inside `@{parent_unit_name}`, with the purpose: **{one_sentence_purpose}**,
and neglected **{alternatives — keeping work in `@{parent_unit_name}` itself, spreading responsibility across existing roles, deferring entirely}**,
to achieve **{goal — clearer ownership, independent pace, isolated record, etc.}**,
accepting **{costs — more governance overhead, coordination across units, additional Registrar}**,
because **{driver — the area of concern has matured enough to warrant its own unit and agent team}**.

## Context and problem statement

{Two to four paragraphs. What prompted establishing this sub-unit? What work was previously handled elsewhere (or not at all) that now needs a dedicated unit? What boundary does `@{unit_name}` draw?}

## Scope

`@{unit_name}` owns:

- {responsibility_1}
- {responsibility_2}
- {responsibility_3}

`@{unit_name}` does **not** own:

- {explicit_non_responsibility_1}
- {explicit_non_responsibility_2}

## Roster

Every unit in the agency carries the same roles (§0014). `@{unit_name}` gets:

- **{Lead role name} @ {unit_display}** — tier-1 of `@{unit_name}`; reports up the tree to the {parent_lead_role} of `@{parent_unit_name}`.
- **{Implementer role name} @ {unit_display}** — tier-2 of `@{unit_name}`; reports to {Lead role name} @ {unit_display}.
- **Registrar @ {unit_display}** — audits `@{unit_name}`'s decision record. Outside the unit's decision hierarchy.

There is no User at this unit. There is one User across the agency, who is principal of every unit and lives at the agency's root unit (§0012).

## Reports to

- Every ancestor unit's ADRs bind `@{unit_name}` — `@{parent_unit_name}`'s `#ORG@{parent_unit_name}/adr/accepted/`, plus any further ancestors walking up to the agency's root.
- `@{unit_name}`'s own decisions live in `@{parent_unit_name}/@{unit_name}/#ORG@{unit_name}/adr/`.
- Federation rule (§0014): `@{unit_name}` does not adjudicate peer or cousin units; they don't adjudicate `@{unit_name}`. Cross-unit issues route up the tree to the lowest common ancestor's Lead, or to {user_role}.

## Directory structure

When this ADR is accepted, the following directory is created nested inside `@{parent_unit_name}` (alongside that parent's `#ORG@{parent_unit_name}/`):

```
{parent_path}/@{unit_name}/
├── #ORG@{unit_name}/
│   ├── adr/
│   │   ├── accepted/             ← empty; @{unit_name}'s ADRs land here
│   │   ├── proposed/
│   │   ├── rejected/
│   │   └── superseded/
│   ├── agents/
│   │   ├── {lead_dir}@{unit_name}/inbox/archive/
│   │   ├── {implementer_dir}@{unit_name}/inbox/archive/
│   │   └── registrar@{unit_name}/inbox/archive/
│   ├── docs/
│   │   └── README.md             ← points back to the agency's root #ORG@{agency_dir}/docs/
│   └── README.md                 ← @{unit_name}'s governance overview
└── (operational artifacts as @{unit_name} produces them)
```

`@{unit_name}` inherits every ancestor unit's ADRs by reference — its own `#ORG@{unit_name}/adr/accepted/` starts empty and fills only with decisions specific to `@{unit_name}`.

## Considered options

1. **Establish `@{unit_name}` as a new sub-unit (chosen).** Dedicated governance and agent team nested under `@{parent_unit_name}`.
2. **Keep the work within `@{parent_unit_name}`.** Rejected: the work has matured enough that its own Lead and record are warranted.
3. **Spread responsibility across `@{parent_unit_name}`'s existing roles without its own unit.** Rejected: those roles are already stretched; dedicated focus produces better outcomes.
4. **Defer.** Rejected: the area of concern is already producing decisions that need a home.

## Decision outcome

**Chosen option: (1) Establish `@{unit_name}` as a new sub-unit nested in `@{parent_unit_name}`**, because {primary_reason}.

`@{unit_name}` will be scaffolded as {mode — directory | submodule} per §0018. {Rationale for mode.}

### Consequences

- **Positive:** Clearer ownership of {area_of_concern}; a dedicated record for `@{unit_name}`'s decisions.
- **Positive:** Faster iteration within `@{unit_name}`; decisions don't bottleneck through `@{parent_unit_name}`'s Lead.
- **Negative:** Additional governance overhead (another Registrar, another set of inboxes, another `#ORG@<unit-name>/`).
- **Negative:** Cross-unit coordination now has a boundary to cross when it didn't before.
- **Neutral:** Registrar @ {unit_display} audits `@{unit_name}`'s record only; the parent unit's Registrar continues to audit the parent's record and any unit↔ADR consistency at that level.

## Review trigger

Reconsider `@{unit_name}`'s establishment if:

- `@{unit_name}`'s work consistently folds back into `@{parent_unit_name}`'s scope (suggests the boundary was wrong).
- `@{unit_name}` has no decisions or activity for an extended period (suggests retirement is warranted — future workflow).
- The area of concern splits into multiple distinct sub-areas (suggests sub-units within `@{unit_name}`).

## References

- `§0001` — the founding scaffold decision.
- `§0010` — roster change protocol (adding a unit creates new agents and roles).
- `§0019` — agency scope; `@{unit_name}` operates within agency scope.
- `§0014` — agency and unit structure; this ADR implements the unit-addition pattern.
- `§0018` — submodule decision (if `@{unit_name}` is a submodule).
- `@{parent_unit_name}`'s `#ORG@{parent_unit_name}/README.md` — governance overview of the parent unit.
- `silcrow:silcrow-add-unit` — the skill that orchestrated this establishment.

---

<!--
This ADR template is rendered by the `silcrow:silcrow-add-unit` skill when
adding a new unit to an agency or unit. Placeholders in curly braces are filled
during the skill's conversation phase; the skill then writes the completed file
to the parent's #ORG@<parent-unit-name>/adr/accepted/ with the next available §-number.

If you're authoring a unit-establishing ADR manually (without the skill), copy
this template to proposed/ or accepted/, assign a §-number, and fill in the
placeholders based on the actual reasoning for establishing the unit.
-->
