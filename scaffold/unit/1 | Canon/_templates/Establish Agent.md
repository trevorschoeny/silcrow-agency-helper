# §NNNN | Establish {role_name} @ {unit_name}

- **Status:** accepted <!-- populated by :silcrow-add-agent -->
- **Date:** {date}
- **Agency:** {agency_name}
- **Unit:** {unit_name}
- **Authors:** {lead_role} @ {unit_name} (via `silcrow:silcrow-add-agent`); {user_role} (approving)
- **Supersedes:** —
- **Superseded by:** —
- **Influences:** every subsequent operational artifact and message scoped to `{role_name} @ {unit_name}`; every redistribution of work into or out of `{role_name} @ {unit_name}`'s scope.
- **Influenced by:** §0008 (roster change protocol), §0010 (tier model), §0012 (agency and unit structure), §0017 (agency scope).

## Why-statement

In the context of **`@ {unit_name}`'s need to {reason_for_agent}**,
facing the growing scope of **{area_of_concern}**,
we decided for **establishing a new agent, `{role_name} @ {unit_name}`**, with the purpose: **{one_sentence_purpose}**,
and neglected **{alternatives — distributing the work across existing agents, deferring the addition, leaving the area unowned}**,
to achieve **{goal — clearer ownership of the area, dedicated focus, faster turnaround on {area_of_concern}}**,
accepting **{costs — another inbox to manage, more coordination, more governance overhead}**,
because **{driver — the area of concern has matured enough to deserve a dedicated agent rather than continuing as a side responsibility}**.

## Context and problem statement

{Two to four paragraphs. What prompted adding this agent? What work was previously handled elsewhere (or not at all) that now needs a dedicated agent? What boundary does `{role_name} @ {unit_name}` draw within `@ {unit_name}`'s scope?}

## Scope

`{role_name} @ {unit_name}` owns:

- {responsibility_1}
- {responsibility_2}
- {responsibility_3}

`{role_name} @ {unit_name}` does **not** own:

- {explicit_non_responsibility_1}
- {explicit_non_responsibility_2}

## Reports to

`{role_name} @ {unit_name}` reports to **`{reports_to} @ {unit_name}`**.

{Reasoning for the reporting line. The default in `@ {unit_name}`'s tier model (§0010) is that new tier-2 agents report to {lead_role} @ {unit_name}. Document any deviation — e.g., a sub-tier role reporting to {implementer_role} @ {unit_name}, or a tier-1 peer reporting directly to {user_role}.}

## Redistribution from existing agents

{If responsibilities moved from existing agents to `{role_name} @ {unit_name}`, list each transfer specifically:

- **From `<existing_agent>`:** "{responsibility_moving}". Reason: {why}.
- **From `<existing_agent>`:** "{responsibility_moving}". Reason: {why}.

If this is entirely new work — no redistribution — say so explicitly:

- *No work moves from existing agents; `{role_name} @ {unit_name}` owns work that was previously not formally owned.*}

## Message routing

`{role_name} @ {unit_name}`'s inbox sits at `{role_name} @ {unit_name}/inbox/`. Default routing within `@ {unit_name}`:

- **Receives messages from:** {inbound_routing — typically the {lead_role} for briefs, peer agents for handoffs}.
- **Sends messages to:** {outbound_routing — typically the {lead_role} for plan-replies, peer agents for handoffs, the Registrar for record-integrity issues}.

Document deviations from the unit's standard routing pattern.

## Considered options

1. **Establish `{role_name} @ {unit_name}` as a new agent (chosen).** Dedicated inbox, dedicated AGENTS.md, dedicated record of decisions touching this scope.
2. **Distribute the work across existing agents in `@ {unit_name}`.** Rejected: {reason — typically that the work has matured enough to warrant a dedicated owner, or that the existing agents are stretched}.
3. **Defer.** Rejected: {reason — typically that decisions in this area are already happening and need a clear owner}.

## Decision outcome

**Chosen option: (1) Establish `{role_name} @ {unit_name}`**, because {primary_reason}.

### Consequences

- **Positive:** Clearer ownership of {area_of_concern}; a dedicated inbox and AGENTS.md.
- **Positive:** {other_positive}.
- **Negative:** Additional coordination overhead — another inbox, another routing target, another agent to brief and review.
- **Negative:** {other_negative}.
- **Neutral:** Registrar @ {unit_name} continues to audit `@ {unit_name}`'s record, including this addition and the AGENTS.md edits that accompany it.

## Review trigger

Reconsider `{role_name} @ {unit_name}`'s establishment if:

- The work consistently folds back into existing agents' scope (suggests the boundary was wrong).
- `{role_name} @ {unit_name}` has no decisions or activity for an extended period (suggests retirement is warranted — future workflow).
- Tier dynamics shift such that `{role_name} @ {unit_name}` no longer fits cleanly (e.g., the Lead's review load is dominated by this agent's work).

## References

- `§0008` — roster change protocol (this ADR enacts an agent addition).
- `§0010` — tier model and reporting structure.
- `§0012` — agency and unit structure.
- `§0017` — agency scope (the new agent operates within agency scope and `@ {unit_name}`'s scope).
- `{role_name} @ {unit_name}/AGENTS.md` — the operational specification authored alongside this ADR.
- `silcrow:silcrow-add-agent` — the skill that orchestrated this establishment.

---

<!--
This ADR template is rendered by the `silcrow:silcrow-add-agent` skill when
adding a new agent to a unit. Mechanical placeholders (date, §-number,
names, paths) are filled by the script; substantive placeholders (why,
scope, redistribution, message routing) are left for the unit's Lead to
fill in — either inline during the skill's conversation, or after the
addition lands. The accompanying AGENTS.md edits (new agent's AGENTS.md +
trims/additions to existing agents' AGENTS.md) carry the operational
substance; this ADR is the canonical record that the addition happened.

If you're authoring an agent-establishing ADR manually (without the skill),
copy this template to proposed/ or accepted/, assign a §-number, and fill
in the placeholders.
-->
