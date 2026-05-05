# §0007 | {lead_role} writes briefs, not specs

- **Status:** accepted
- **Date:** {date}
- **Agency:** {agency_name}
- **Unit:** {unit_name}
- **Authors:** scaffold initialization (inherited via §0001)
- **Supersedes:** —
- **Superseded by:** —
- **Influences:** every future {lead_role}-to-{implementer_role} work-handoff.
- **Influenced by:** §0001, §0006, §0017

## Why-statement

In the context of *Lead-to-Implementer work handoffs in a stratified agency (§0006)*,
facing *handoffs that, when too prescriptive, collapse the two tiers into one and, when too vague, leave the Implementer guessing at intent*,
we decided for *briefs-not-specs — Lead communicates what and why; Implementer drafts a plan in response; Lead reviews; Implementer executes*,
and neglected *detailed specs, verbal direction, and ad hoc no-formalization*,
to achieve *stratification preserved (each tier doing tier-appropriate work) and Implementer agency retained (their plans reflect their context)*,
accepting *that this requires the Lead's discipline to resist writing specs under pressure and the Implementer's discipline to push back when a brief drifts spec-ward*,
because *subsidiarity (foundation 02) and stratified cognition (foundation 01) both require that decisions be made at the lowest competent level — which means implementation decisions belong to the Implementer, not the Lead*.

## Context and problem statement

**Inherited decision.** This is a founding constitutional decision inherited from the Silcrow plugin via §0001 at project initialization. The reasoning and alternatives are preserved here so it can be evaluated or superseded on its own merits through the normal ADR lifecycle.

When the {lead_role} hands work to the {implementer_role}, the form of that handoff determines whether the stratification established in §0006 actually holds. A brief that's too prescriptive collapses the two tiers into one (the {lead_role} is doing {implementer_role}-stratum work); a brief that's too vague leaves the {implementer_role} guessing at intent and produces misaligned output.

## Decision drivers

- **Subsidiarity (foundation 02).** Implementation decisions — how to structure a change, what functions to write — are Implementer-stratum work and belong there.
- **Stratified cognition (foundation 01).** Lead's stratum is the months-horizon architectural work, not the days-horizon execution.
- **Implementer agency.** A brief that asks for outcome (not exact path) lets the Implementer's context and judgment shape the plan.

## Considered options

1. **Briefs-not-specs (chosen).** The {lead_role} communicates *what* is needed and *why*, plus constraints. The {implementer_role} drafts a plan — *how* — in response. The {lead_role} reviews the plan and the {implementer_role} executes.
2. **Detailed specs.** The {lead_role} writes prescriptive specifications: files to change, function signatures, test cases. The {implementer_role} executes.
3. **Verbal direction.** The {lead_role} explains work in meetings or chat; no written form.
4. **No formalization.** The {lead_role} and {implementer_role} figure out the handoff ad hoc.

## Decision outcome

**Chosen option: (1) Briefs-not-specs.**

Subsidiarity (§0006 per its foundations) requires that decisions be made at the lowest level capable of making them well. Implementation decisions — how to structure a change, what functions to write, what test strategy to use — are {implementer_role}-stratum work. When the {lead_role} writes specs, they are absorbing those decisions upward, violating subsidiarity, and doing work beneath their own stratum (violating stratification). The briefs-not-specs pattern preserves both disciplines simultaneously.

Option (2) — detailed specs — is the single most common anti-pattern for this hand-off, and worth naming explicitly. It feels safer because it "leaves less room for error," but the safety is illusory. A detailed spec is a prediction about how the work should be done, made by the agent furthest from the details. Specs are usually wrong in ways the {lead_role} can't predict because they don't have the context the {implementer_role} will have when they encounter the actual code. Briefs ask for the outcome and trust the stratum-appropriate agent to find the path.

Option (3) — verbal — fails the record-preservation discipline (§0005). Options (4) — ad hoc — fails both record-preservation and consistency.

### Consequences

- **Positive:** Stratification and subsidiarity hold. Each tier does tier-appropriate work.
- **Positive:** Briefs are faster to write than specs, freeing the {lead_role}'s time for architecture.
- **Positive:** The {implementer_role} retains genuine agency; their plans reflect their context and judgment.
- **Positive:** Misalignment is caught at plan-review time rather than at execution time.
- **Negative:** Requires discipline from the {lead_role} to resist writing specs when they're under pressure.
- **Negative:** Requires the {implementer_role} to push back when a "brief" drifts into spec territory.

## Pros and cons of the options

Covered in Decision outcome above.

## Anti-patterns surfaced

- **Specs disguised as briefs.** A "brief" that prescribes file paths, function signatures, or exact test cases is a spec. The Implementer should push back; the Lead should self-check before sending.

## Review trigger

Review trigger: none; the failure mode this addresses is not context-dependent.

## References

- `../../3 | Silcrow Agency Reference/foundations/01 | Stratified Cognition.md` — the stratification this decision preserves.
- `../../3 | Silcrow Agency Reference/foundations/02 | Subsidiarity.md` — the subsidiarity principle this decision operationalizes.
- `../../{lead_role} @ {unit_name}/AGENTS.md` — where this pattern is operationalized for the {lead_role}.
- `../../{implementer_role} @ {unit_name}/AGENTS.md` — where the receiving side is described.
- `../../3 | Silcrow Agency Reference/Message Protocol.md` §6 — brief/plan/report message kinds.
