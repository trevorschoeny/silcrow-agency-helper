# §0010 | User as principal; local tier numbering; Implementer drafts-with-approval

- **Status:** accepted
- **Date:** {date}
- **Agency:** {agency_name}
- **Unit:** {unit_name}
- **Authors:** scaffold initialization (inherited via §0001)
- **Supersedes:** —
- **Superseded by:** —
- **Influences:** every tier-based interpretation; every ADR authoring flow; multi-unit agencies.
- **Influenced by:** §0001, §0006, §0008

## Why-statement

In the context of **agencies that may grow from single-unit to multi-unit and whose User sits outside the agent hierarchy**,
facing the ambiguity of §0006's tier model when applied to nested units and the question of whether Implementers may author ADRs,
we decided for **three companion refinements** — the User transcends the tier model; tier numbers are local per unit rather than global; and Implementers may draft ADRs into `proposed/` but require Lead or User approval to accept —
and neglected adding a User tier to §0006 globally, renumbering tiers across units, and blocking Implementer authorship entirely,
to achieve a tier model that scales cleanly to multi-unit structures while preserving tier-1/tier-2 cognitive horizons locally and keeping Implementer hands-on knowledge in the authorship channel,
accepting that agents must translate "tier" between local unit frame and global reporting frame when needed,
because subsidiarity (lowest competent level) plus principal authority (the User is outside the tier lattice) plus authorized drafting (Implementers may propose, Lead/User may accept) is the minimal refinement that lets §0006 apply cleanly across nested units without contradicting itself.

## Context and problem statement

§0006 established the starter roster and tier model — User (tier 0), Lead (tier 1), Implementer (tier 2), plus an outside-hierarchy Registrar. That model was written assuming a single-unit organization. As agencies grow into trees of nested units (a sub-unit per product line, per research thread, per team, etc.; see §0012), three questions arise that §0006 did not answer cleanly:

1. **Where does the User sit in a tree of units?** Literally reading §0006, the User is tier-0 of the agency. But in a nested-unit structure there are potentially many Leads — the root unit's Lead, plus a Lead in every sub-unit. Does the User sit above only the root unit's Lead? May a sub-unit's Lead message the User directly? Does the User bypass tiers?

2. **What do tier numbers mean across units?** Is the root unit's Lead tier-1 and every sub-unit's Lead tier-2? That reading collapses the one-stratum rule §0006 relies on — a sub-unit Lead's work is full tier-1 work for their unit's scope, not tier-2 work under the root unit's scope.

3. **May an Implementer author ADRs?** §0006 assigns ADR authoring to Lead-and-up by default, but the `:silcrow-update` flow, §0009's audit flow, and the general principle of subsidiarity all invite cases where an Implementer has hands-on knowledge that earns ADR treatment. Blocking Implementer authorship entirely loses that signal; leaving it fully open collapses the authority split.

This ADR answers all three with three companion refinements.

## Decision drivers

- **Subsidiarity.** Decisions belong at the lowest competent level. The tier model must scale to nested units without pushing authority upward by accident.
- **The User is the principal.** The User is not an agent; the User is the one the agents serve. Treating the User as one tier among many mis-frames the relationship.
- **Cognitive horizons are local per unit.** Every unit's Lead thinks at the months horizon *for their unit*. That's full tier-1 work even if their unit is smaller than the agency as a whole.
- **Authorship should track hands-on knowledge.** Implementers encounter the patterns worth codifying. Closing the authoring channel loses signal; keeping it open without a check collapses authority.
- **Minimum elaboration.** The model should be as thin a refinement of §0006 as possible.

## Considered options

1. **Add a User tier to §0006 globally (tier -1 or tier 0').** Formalize the User as a tier.
2. **Renumber tiers across units (root unit's Lead = tier 1, every sub-unit's Lead = tier 2, etc.).** Flatten the per-unit frame into a single global enumeration.
3. **Block Implementer authorship entirely.** Only Lead and User may author ADRs.
4. **Three companion refinements (chosen).** User transcends tiers; tier numbers are local; Implementer may draft with Lead/User approval.

## Decision outcome

**Chosen option: (4).**

The three refinements work together. None of them alone would resolve the full ambiguity §0006 leaves in a multi-unit world.

### Refinement 1 — the User transcends the tier model

> *The User is not a tier; the User is the principal. Tiers describe cognitive horizon and default reporting chain for the agent roles. The User sits at the apex and may act as the superior of any tier at any time. Any agent may (and sometimes must) communicate directly with the User. The tier model constrains the agents; it does not constrain the User.*

The User is the one the agency serves. Treating the User as one tier among many mis-frames the relationship: tiers describe how agents coordinate with each other, but the User is not an agent. Operationally this means:

- The User may act as the superior of any agent at any tier in any unit — the Lead of the root unit, the Lead of any sub-unit, any Implementer. Tier-skipping rules (§0006) apply only within the agent hierarchy.
- Any agent may message the User directly when escalation is warranted. No agent is obligated to route through their Lead first for User communication.
- There is no Unit User. There is one User across the entire agency, who is the principal of every unit. The User lives at the agency's root unit.
- When the User authors an ADR, it lands like any other first-class authored ADR (direct commit to `accepted/`).

### Refinement 2 — tier numbers are local per unit

> *Every unit has its own tier-1 (Lead) and tier-2 (Implementer). The Lead of any sub-unit reports up the tree to its parent unit's Lead; in the local frame of their own unit, that sub-unit's Lead **is** tier-1. Both are true from different viewpoints.*

Tier numbers describe **position within a unit**, not a strict global enumeration. The Lead of any unit — root or sub-unit — thinks at the "months" horizon *for their own unit* — full tier-1 work. The Implementer of any unit thinks at the "weeks" horizon *for their own unit* — full tier-2 work. The cross-unit reporting chain (which unit reports up to which parent) is tracked separately from the tier number.

This keeps §0006's cognitive-horizon framing stable at every depth: a Lead is always tier-1-of-their-unit; an Implementer is always tier-2-of-their-unit. The hierarchy map for an agency with sub-units:

```
User (principal — transcends tiers; one across the agency)
  │
  └── Lead @ <root unit> (tier-1 of the root unit)
        ├── Implementer @ <root unit> (tier-2 of the root unit)
        ├── Lead @ <sub-unit A> (tier-1 of sub-unit A; reports up the tree)
        │     └── Implementer @ <sub-unit A> (tier-2 of sub-unit A)
        └── Lead @ <sub-unit B> (tier-1 of sub-unit B; reports up the tree)
              └── Implementer @ <sub-unit B> (tier-2 of sub-unit B)

Every unit has its own Registrar, outside the unit's hierarchy:
  - Registrar @ <root unit>
  - Registrar @ <sub-unit A>
  - Registrar @ <sub-unit B>
```

For an agency with only a root unit (no sub-units), the hierarchy is User → Lead @ <root> → Implementer @ <root>, with Registrar @ <root> outside. The same interpretation rules apply; there's just less to map. Trees can extend arbitrarily deep — sub-units may have their own sub-units, and the same pattern recurses at every level.

### Refinement 3 — Implementer drafts with Lead or User approval

> *Implementers may draft ADRs when they recognize something ADR-worthy in their work — a pattern worth codifying, a convention they want to establish, a constraint they've hit that deserves record. They draft into `@ {unit_name}/1 | Canon/proposed/` and message their Lead (or User) for review. On approval, the ADR lands in `@ {unit_name}/1 | Canon/accepted/`. The Implementer drafts; the Lead (or User) authorizes.*

The authoring pattern mirrors how a junior associate drafts a memo and the senior partner signs off — the writing is the Implementer's; the authority is the Lead's/User's. Closing the channel entirely would lose hands-on signal; leaving it fully open would collapse the tier model. The draft-with-approval path threads the needle.

Authorship authority by role (the same rule applies in every unit; the User is unique to the agency and lives at the root):

- **Lead @ <unit>** — first-class. May draft, commit, and supersede ADRs directly in their unit's `@ {unit_name}/1 | Canon/accepted/`. No approval needed.
- **User** — first-class. May act as superior of any agent in any unit; authoring ADRs is within that scope.
- **Implementer @ <unit>** — drafts only. Commits require their Lead's or the User's approval via the `proposed/` channel.
- **Registrar @ <unit>** — no authoring; no substantive changes. Registrar flags; Lead or User acts (see §0009).

### Consequences

- **Positive:** Agencies with sub-units have a clean tier model that scales without contradiction at any depth.
- **Positive:** The User's role is correctly framed as principal, not tier.
- **Positive:** Implementers' hands-on knowledge can enter the record through an authorized channel.
- **Positive:** The tier-1/tier-2 cognitive-horizon distinction from §0006 holds in every unit, root or sub-unit.
- **Negative:** Agents must translate "tier" between local-unit frame and tree-position frame when the question requires it. The tier number alone is ambiguous without context.
- **Neutral:** A sub-unit's Lead is both tier-1 (in their own unit's frame) and reports up the tree to their parent unit's Lead. The reporting chain is a separate fact from the tier number.

## Anti-patterns surfaced

- **Treating the User as tier-0 only of the root unit.** In a tree of units this blocks direct User communication with agents in sub-units, which contradicts the principal framing — the User is principal of every unit.
- **Assigning global tier numbers across units.** If you find yourself saying "a sub-unit's Lead is tier-2", the frame has slipped. Every unit's Lead is tier-1-of-their-unit, regardless of where their unit sits in the tree.
- **Implementer commits-to-accepted without approval.** The draft-with-approval path is the authorized channel. Implementers committing directly to `accepted/` without Lead or User approval collapses the authority split.
- **Lead bottleneck on Implementer drafts.** Lead should respond to Implementer drafts promptly. If Implementer drafts pile up unreviewed, the Lead is creating the very latency §0009 was built to remove.

## Review trigger

Reconsider this ADR if:

- Multi-unit agencies reveal structural patterns this refinement doesn't cover (e.g., matrix reporting across units, temporary task-force tiers).
- Evidence emerges that the "User transcends tiers" framing produces confusion rather than clarity.
- Implementer drafts prove to be a consistent source of low-quality proposals, suggesting the approval gate needs sharper criteria.
- A new unit type emerges that doesn't fit the Lead/Implementer pair (e.g., a unit that's just a Lead with no Implementer, or a Registrar-only unit).

## References

- `../../3 | Silcrow Agency Reference/foundations/01 | Stratified Cognition.md` — cognitive-horizon framing that tier-1-of-unit, tier-2-of-unit preserve.
- `../../3 | Silcrow Agency Reference/foundations/02 | Subsidiarity.md` — decisions at lowest competent level; User-transcends-tiers is the limit case at the top.
- `../../user@ {unit_name}/AGENTS.md` — the User's role as principal.
- `../../lead@ {unit_name}/AGENTS.md` — Lead's first-class ADR authority.
- `../../implementer@ {unit_name}/AGENTS.md` — Implementer's draft-with-approval path.
- §0006 (intact) — the starter tier model this ADR extends.
- §0008 — roster change protocol; applies to adding tiers or roles.
- §0009 — Registrar as async auditor; related role-authority refinement.
- §0012 — agency and unit structure; the multi-unit context this ADR was written to serve.
