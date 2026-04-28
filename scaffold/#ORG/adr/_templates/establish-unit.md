# §NNNN — Establish unit @{unit_name}

- **Status:** accepted <!-- populated by :silcrow-add-unit -->
- **Date:** {date}
- **Authors:** {authoring_lead_or_user} (via `silcrow:silcrow-add-unit`)
- **Supersedes:** —
- **Superseded by:** —
- **Influences:** every subsequent operational artifact scoped to `@{unit_name}`; all unit-level ADRs authored inside `@{unit_name}/#ORG/adr/`.
- **Influenced by:** §0010 (roster change protocol), §0011 (agency scope), §0015 (agency and unit structure).

## Y-statement

In the context of **the agency's need to {reason_for_unit}**,
facing the growing scope of **{area_of_concern}**,
we decided for **establishing a new unit, `@{unit_name}`**, with the purpose: **{one_sentence_purpose}**,
and neglected **{alternatives — keeping work in an existing unit, spreading responsibility across agency-level roles, deferring entirely}**,
to achieve **{goal — clearer ownership, independent pace, isolated record, etc.}**,
accepting **{costs — more governance overhead, coordination across units, additional Registrar}**,
because **{driver — the area of concern has matured enough to warrant its own unit-level record and agent team}**.

## Context and problem statement

{Two to four paragraphs. What prompted establishing this unit? What work was previously handled elsewhere (or not at all) that now needs a dedicated unit? What boundary does this unit draw?}

## Scope

This unit owns:

- {responsibility_1}
- {responsibility_2}
- {responsibility_3}

This unit does **not** own:

- {explicit_non_responsibility_1}
- {explicit_non_responsibility_2}

## Roster

- **{Lead role name}** — tier-1 of `@{unit_name}`; reports upward to the {parent_lead_role}.
- **{Implementer role name}** — tier-2 of `@{unit_name}`; reports to the unit's {Lead role name}.
- **Registrar** — audits `@{unit_name}`'s decision record. Outside the unit's decision hierarchy.

No User role exists at the unit level — the User is an agency-level role and acts as principal of every unit (§0013).

## Reports to

- Agency-level decisions (all §-numbered ADRs in the parent's `#ORG/adr/accepted/`) bind this unit automatically.
- Unit-level decisions live in `{parent_path}/@{unit_name}/#ORG/adr/`.
- Federation rule (§0015): this unit does not adjudicate peer units; peer units do not adjudicate this one. Cross-unit issues route through the agency {parent_lead_role} or {user_role}.

## Directory structure

When this ADR is accepted, the following directory is created alongside the parent's `#ORG/`:

```
{parent_path}/@{unit_name}/
├── #ORG/
│   ├── adr/
│   │   ├── accepted/             ← empty; unit ADRs will land here
│   │   ├── proposed/
│   │   ├── rejected/
│   │   └── superseded/
│   ├── agents/
│   │   ├── {lead_dir}/inbox/archive/
│   │   ├── {implementer_dir}/inbox/archive/
│   │   └── registrar/inbox/archive/
│   ├── docs/
│   │   └── README.md             ← orientation pointing back to agency's #ORG/docs/
│   └── README.md                 ← unit-level governance overview
└── (operational artifacts as the unit produces them)
```

The unit inherits the agency's ADRs (§0001–§0019 and any agency-level ADRs authored since) by reference — the unit's `#ORG/adr/accepted/` starts empty and fills only with unit-specific decisions.

## Considered options

1. **Establish this work as a new unit (chosen).** Dedicated governance and agent team.
2. **Keep the work within an existing unit.** Rejected: the work has matured enough that its own Lead and record are warranted.
3. **Handle at agency level without its own unit.** Rejected: the agency-level agents are already stretched; dedicated focus produces better outcomes.
4. **Defer.** Rejected: the area of concern is already producing decisions that need a home.

## Decision outcome

**Chosen option: (1) Establish `@{unit_name}` as a new unit**, because {primary_reason}.

The unit will be scaffolded as {mode — directory | submodule} per §0019. {Rationale for mode.}

### Consequences

- **Positive:** Clearer ownership of {area_of_concern}; a dedicated record for unit-level decisions.
- **Positive:** Faster iteration within the unit; decisions don't bottleneck through agency Lead.
- **Negative:** Additional governance overhead (another Registrar, another set of inboxes, another `#ORG/`).
- **Negative:** Cross-unit coordination now has a boundary to cross when it didn't before.
- **Neutral:** The unit's Registrar audits its own record; the agency Registrar audits only ADR↔directory consistency at the agency level.

## Review trigger

Reconsider this unit's establishment if:

- The unit's work consistently folds back into the parent's scope (suggests the boundary was wrong).
- The unit has no decisions or activity for an extended period (suggests retirement is warranted — future workflow).
- The area of concern splits into multiple distinct sub-areas (suggests sub-units within this unit).

## References

- `§0001` — the founding scaffold decision.
- `§0010` — roster change protocol (adding a unit creates new agents and roles).
- `§0011` — agency scope; this unit operates within agency scope.
- `§0015` — agency and unit structure; this ADR implements the unit-addition pattern.
- `§0019` — submodule decision (if the unit is a submodule).
- Parent unit's `#ORG/README.md` — governance overview of the parent unit.
- `silcrow:silcrow-add-unit` — the skill that orchestrated this establishment.

---

<!--
This ADR template is rendered by the `silcrow:silcrow-add-unit` skill when
adding a new unit to an agency or unit. Placeholders in curly braces are filled
during the skill's conversation phase; the skill then writes the completed file
to the parent's #ORG/adr/accepted/ with the next available §-number.

If you're authoring a unit-establishing ADR manually (without the skill), copy
this template to proposed/ or accepted/, assign a §-number, and fill in the
placeholders based on the actual reasoning for establishing the unit.
-->
