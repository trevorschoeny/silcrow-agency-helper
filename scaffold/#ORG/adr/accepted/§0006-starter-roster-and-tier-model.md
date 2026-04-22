# §0006 — Starter roster and tier model

- **Status:** accepted
- **Date:** {date}
- **Authors:** scaffold initialization (inherited via §0001)
- **Supersedes:** —
- **Superseded by:** —
- **Influences:** §0007 ({lead_role}-to-{implementer_role} pattern follows the tier gap); all future roster changes.
- **Influenced by:** §0001

## Y-statement

In the context of **bootstrapping a multi-agent project**,
facing the need to define an initial organizational structure that can operate immediately and grow gracefully,
we decided for **a three-tier stratified roster plus an out-of-hierarchy Registrar** — {user_role} (tier 0), {lead_role} (tier 1), {implementer_role} (tier 2), Registrar (outside) —
and neglected flat (no tiers), two-tier, and four-plus-tier alternatives,
to achieve the minimum viable stratification with each pair of tiers exactly one stratum apart per Jaques' one-stratum rule,
accepting that some projects will want to expand the tier model later,
because this configuration is the smallest one that honors stratified-cognition, subsidiarity, and registrar-separation simultaneously.

## Context and problem statement

**Inherited decision.** This is a founding constitutional decision inherited from the Silcrow plugin via §0001 at project initialization. The reasoning and alternatives are preserved here so it can be evaluated or superseded on its own merits through the normal ADR lifecycle.

Every hierarchical project faces an initial roster-shaping question: how many tiers, what roles, and what authority structure? The answer constrains every subsequent decision about who does what. Premature elaboration produces bureaucratic overhead; premature flattening produces coordination failure. The goal is the minimum structure that satisfies the project's current needs and provides a clear path for growth.

## Decision drivers

- **Minimum viable stratification.** Jaques' *one-stratum rule* says each boss sits exactly one stratum above their reports. The roster should implement this — no wider gaps (which produce abandonment) and no compressed tiers (which produce micromanagement).
- **Subsidiarity can actually work.** The tier structure must be rich enough that decisions have somewhere to live at an appropriate level — not everything defaulting to one tier.
- **Record integrity has a home.** A Registrar role exists from day one, even if lightly-loaded, so the discipline of registered-everything is established early rather than retrofitted.
- **Graceful growth.** New tiers can be added between existing ones later without restructuring the whole hierarchy.

## Considered options

1. **Flat (no tiers).** All agents peer. Coordination by convention only.
2. **Two-tier.** {user_role} + one "worker" role. Simplest non-flat option.
3. **Three-tier plus outside-hierarchy Registrar (chosen).** {user_role} / {lead_role} / {implementer_role} / Registrar.
4. **Four-plus-tier.** Additional strata from day one.

## Decision outcome

**Chosen option: (3) Three-tier plus Registrar.**

The three tiers cover the minimum viable span of cognitive work for any project of non-trivial scope: strategic (weeks–months–years horizon), architectural (months), executional (days–weeks). With three tiers, every pair is exactly one stratum apart (Jaques' rule), subsidiarity has meaningful distance to work across, and the project can grow by adding tiers between existing ones.

Option (1) — flat — fails for any project larger than a couple of people working on closely-related tasks. Past that, informal hierarchy emerges anyway, unrecorded and usually unhealthy.

Option (2) — two-tier — collapses architecture and execution into one role. Works for very small scopes but forces the single worker-tier to carry both stratum-I and stratum-II work, which is exactly the micromanagement or burnout condition the one-stratum rule warns against.

Option (4) — four-plus tiers from day one — is premature elaboration. Tiers exist for real work; inventing tiers before the work needs them creates roles that float without substance. The correct time to add a fourth tier is when the existing tiers' work has genuinely bifurcated into more-than-one-stratum spans.

The Registrar is placed **outside** the decision hierarchy because their authority is procedural, not substantive. Putting them inside the tier structure would imply authority over decisions made at lower tiers, which is exactly what must not happen (see §0008).

### Consequences

- **Positive:** Clear reporting lines from day one.
- **Positive:** Each tier has a distinct time horizon and kind of work, aligning with stratified-cognition theory.
- **Positive:** Registrar discipline is established from the start.
- **Positive:** Path to growth: add tiers between existing ones only when work bifurcates.
- **Negative:** Small projects may feel the structure is heavier than strictly necessary for their current size — one person may sensibly occupy {lead_role} and {implementer_role} simultaneously in the interim.
- **Neutral:** Vocabulary is flexible: {lead_role} can be renamed {lead_role} (Architect, Editor, Director, whatever fits). The structure is what matters; the names are local.

## Pros and cons of the options

### (1) Flat

- ✅ No upfront structure overhead.
- ❌ Coordination overhead grows combinatorially; decisions have no home.
- ❌ Informal hierarchy emerges anyway, unrecorded.

### (2) Two-tier

- ✅ Simpler than three-tier.
- ❌ Collapses architecture and execution; violates the one-stratum rule.
- ❌ Works only for very small projects with a single narrow scope.

### (3) Three-tier + outside Registrar

- ✅ Minimum viable stratification.
- ✅ Each tier-pair one stratum apart.
- ✅ Registrar establishes record discipline from day one.
- ❌ May feel heavier than a very small project strictly needs.

### (4) Four-plus-tier

- ✅ More headroom for growth.
- ❌ Premature; tiers without distinct work become ceremonial.
- ❌ Wastes senior agents' time on work below their stratum.

## Anti-patterns surfaced

- **Tier-skipping.** Two-stratum gaps (e.g., {user_role} giving direct feedback to {implementer_role} without going through {lead_role}) collapse the stratification. When tempted, route through tiers even when it feels slower.
- **Premature tier expansion.** Adding a fourth tier because "we're growing" rather than because the work has actually bifurcated. Produces ceremonial roles. The trigger is *work span*, not *headcount*.
- **Bundling {lead_role} and Registrar.** Combining form authority with substance authority collapses the separation §0008 depends on. Even in small projects, keep the roles distinct — one person can hold both hats, but the hats themselves should remain separate.

## Review trigger

This decision should be reconsidered when:

- Workflow evidence shows that the {lead_role}'s time is dominated by review rather than architecture, suggesting a fourth tier between {lead_role} and {implementer_role} is needed.
- The project has grown enough that a single {lead_role} cannot oversee all architectural work, suggesting multiple {lead_role}-equivalents or a level of coordination above them.
- {user_role}'s strategic work has bifurcated into genuinely distinct horizons (e.g., multi-year vs. quarterly), suggesting a tier between {user_role} and the {lead_role}.

In each case, the change is a new ADR superseding this one. Do not edit this record.

## References

- `../../docs/foundations/01-stratified-cognition.md` — full intellectual history.
- `../../docs/foundations/02-subsidiarity.md` — why the tiered structure lets subsidiarity work.
- `../../docs/foundations/06-registrar-pattern.md` — why the Registrar sits outside the hierarchy.
- `../../agents/` — the directories of the starter roster this ADR directly defines. Subsequent roster changes flow through `§0010`.
- Jaques, E. (1996). *Requisite Organization* (2nd ed.). Cason Hall.
- Jaques, E. (1990). "In Praise of Hierarchy." *HBR*, Jan–Feb.
