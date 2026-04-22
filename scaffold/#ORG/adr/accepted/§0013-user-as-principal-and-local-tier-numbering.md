# §0013 — User as principal; local tier numbering; Implementer drafts-with-approval

- **Status:** accepted
- **Date:** {date}
- **Authors:** scaffold initialization (inherited via §0001)
- **Supersedes:** —
- **Superseded by:** —
- **Influences:** every tier-based interpretation; every ADR authoring flow; multi-unit agencies.
- **Influenced by:** §0001, §0006, §0010

## Y-statement

In the context of **agencies that may grow from single-unit to multi-unit and whose User sits outside the agent hierarchy**,
facing the ambiguity of §0006's tier model when applied to nested units and the question of whether Implementers may author ADRs,
we decided for **three companion refinements** — the User transcends the tier model; tier numbers are local per unit rather than global; and Implementers may draft ADRs into `proposed/` but require Lead or User approval to accept —
and neglected adding a User tier to §0006 globally, renumbering tiers across units, and blocking Implementer authorship entirely,
to achieve a tier model that scales cleanly to multi-unit structures while preserving tier-1/tier-2 cognitive horizons locally and keeping Implementer hands-on knowledge in the authorship channel,
accepting that agents must translate "tier" between local unit frame and global reporting frame when needed,
because subsidiarity (lowest competent level) plus principal authority (the User is outside the tier lattice) plus authorized drafting (Implementers may propose, Lead/User may accept) is the minimal refinement that lets §0006 apply cleanly across nested units without contradicting itself.

## Context and problem statement

§0006 established the starter roster and tier model — User (tier 0), Lead (tier 1), Implementer (tier 2), plus an outside-hierarchy Registrar. That model was written assuming a single-unit organization. As agencies grow to multiple units (a unit per product line, per research thread, per team, etc.; see §0015), three questions arise that §0006 did not answer cleanly:

1. **Where does the User sit in a multi-unit structure?** Literally reading §0006, the User is tier-0 of the agency. But in a nested-unit structure there are potentially many Leads (Agency Lead, Unit A Lead, Unit B Lead). Does the User sit above only the Agency Lead? May a Unit Lead message the User directly? Does the User bypass tiers?

2. **What do tier numbers mean across units?** Is the Agency Lead tier-1 and every Unit Lead tier-2? That reading collapses the one-stratum rule §0006 relies on — the Unit Lead's work is full tier-1 work for their unit's scope, not tier-2 work under the Agency Lead's scope.

3. **May an Implementer author ADRs?** §0006 assigns ADR authoring to Lead-and-up by default, but the `:update` flow, §0012's audit flow, and the general principle of subsidiarity all invite cases where an Implementer has hands-on knowledge that earns ADR treatment. Blocking Implementer authorship entirely loses that signal; leaving it fully open collapses the authority split.

This ADR answers all three with three companion refinements.

## Decision drivers

- **Subsidiarity.** Decisions belong at the lowest competent level. The tier model must scale to nested units without pushing authority upward by accident.
- **The User is the principal.** The User is not an agent; the User is the one the agents serve. Treating the User as one tier among many mis-frames the relationship.
- **Cognitive horizons are local per unit.** A Unit Lead thinks at the months horizon *for their unit*. That's full tier-1 work even if their unit is smaller than the agency.
- **Authorship should track hands-on knowledge.** Implementers encounter the patterns worth codifying. Closing the authoring channel loses signal; keeping it open without a check collapses authority.
- **Minimum elaboration.** The model should be as thin a refinement of §0006 as possible.

## Considered options

1. **Add a User tier to §0006 globally (tier -1 or tier 0').** Formalize the User as a tier.
2. **Renumber tiers across units (Agency Lead = tier 1, Unit Lead = tier 2).** Flatten the unit frame into the agency frame.
3. **Block Implementer authorship entirely.** Only Lead and User may author ADRs.
4. **Three companion refinements (chosen).** User transcends tiers; tier numbers are local; Implementer may draft with Lead/User approval.

## Decision outcome

**Chosen option: (4).**

The three refinements work together. None of them alone would resolve the full ambiguity §0006 leaves in a multi-unit world.

### Refinement 1 — the User transcends the tier model

> *The User is not a tier; the User is the principal. Tiers describe cognitive horizon and default reporting chain for the agent roles. The User sits at the apex and may act as the superior of any tier at any time. Any agent may (and sometimes must) communicate directly with the User. The tier model constrains the agents; it does not constrain the User.*

The User is the one the agency serves. Treating the User as one tier among many mis-frames the relationship: tiers describe how agents coordinate with each other, but the User is not an agent. Operationally this means:

- The User may act as the superior of any tier at any level — Agency Lead, Unit Lead, Implementer. Tier-skipping rules (§0006) apply only within the agent hierarchy.
- Any agent may message the User directly when escalation is warranted. No agent is obligated to route through their Lead first for User communication.
- There is no Unit User. "User" is an agency-level role; the same User is the principal of all units in the agency.
- When the User authors an ADR, it lands like any other first-class authored ADR (direct commit to `accepted/`).

### Refinement 2 — tier numbers are local per unit

> *Each unit has its own tier-1 (Lead) and tier-2 (Implementer). In the global frame, Unit Leads report upward to the Agency Lead; in the local frame of their own unit, Unit Leads **are** tier-1. Both are true from different viewpoints.*

Tier numbers describe **position within a unit**, not a strict global enumeration. A Unit Lead thinks at the "months" horizon *for their unit* — full tier-1 work. A Unit Implementer thinks at the "weeks" horizon *for their unit* — full tier-2 work. The cross-unit reporting chain is tracked separately from the tier number.

This keeps §0006's cognitive-horizon framing stable at every level: a Lead is always tier-1-of-their-unit; an Implementer is always tier-2-of-their-unit. The hierarchy map for a multi-unit agency:

```
User (principal — transcends tiers)
  │
  └── Agency Lead (tier-1 of agency)
        ├── Agency Implementer (tier-2 of agency)
        ├── Unit A Lead (tier-1 of unit A; reports upward to Agency Lead)
        │     └── Unit A Implementer (tier-2 of unit A)
        └── Unit B Lead (tier-1 of unit B; reports upward to Agency Lead)
              └── Unit B Implementer (tier-2 of unit B)

Registrars exist outside these hierarchies, auditing their unit's record:
  - Agency Registrar
  - Unit A Registrar
  - Unit B Registrar
```

For single-unit agencies, the hierarchy is simply User → Agency Lead → Agency Implementer, with one Registrar outside. The same interpretation rules apply; there's just less to map.

### Refinement 3 — Implementer drafts with Lead or User approval

> *Implementers may draft ADRs when they recognize something ADR-worthy in their work — a pattern worth codifying, a convention they want to establish, a constraint they've hit that deserves record. They draft into `#ORG/adr/proposed/` and message their Lead (or User) for review. On approval, the ADR lands in `#ORG/adr/accepted/`. The Implementer drafts; the Lead (or User) authorizes.*

The authoring pattern mirrors how a junior associate drafts a memo and the senior partner signs off — the writing is the Implementer's; the authority is the Lead's/User's. Closing the channel entirely would lose hands-on signal; leaving it fully open would collapse the tier model. The draft-with-approval path threads the needle.

Authorship authority by role (across all units; User is agency-level):

- **Lead** — first-class. May draft, commit, and supersede ADRs directly. No approval needed.
- **User** — first-class. May act as superior of any tier at any level; authoring ADRs is within that scope.
- **Implementer** — drafts only. Commits require Lead or User approval via the `proposed/` channel.
- **Registrar** — no authoring; no substantive changes. Registrar flags; Lead or User acts (see §0012).

### Consequences

- **Positive:** Multi-unit agencies have a clean tier model that scales without contradiction.
- **Positive:** The User's role is correctly framed as principal, not tier.
- **Positive:** Implementers' hands-on knowledge can enter the record through an authorized channel.
- **Positive:** The tier-1/tier-2 cognitive-horizon distinction from §0006 holds at every unit level.
- **Negative:** Agents must translate "tier" between local unit frame and global reporting frame when the question requires it. The tier number alone is ambiguous without context.
- **Neutral:** A Unit Lead is both tier-1 (local) and reports upward to tier-1 (Agency Lead). The reporting chain is a separate fact from the tier number.

## Anti-patterns surfaced

- **Treating the User as tier-0 only of the agency.** In a multi-unit structure this blocks direct User communication with Unit agents, which contradicts the principal framing.
- **Assigning global tier numbers across units.** If you find yourself saying "Unit Lead is tier-2", the frame has slipped. Unit Lead is tier-1-of-unit.
- **Implementer commits-to-accepted without approval.** The draft-with-approval path is the authorized channel. Implementers committing directly to `accepted/` without Lead or User approval collapses the authority split.
- **Lead bottleneck on Implementer drafts.** Lead should respond to Implementer drafts promptly. If Implementer drafts pile up unreviewed, the Lead is creating the very latency §0012 was built to remove.

## Review trigger

Reconsider this ADR if:

- Multi-unit agencies reveal structural patterns this refinement doesn't cover (e.g., matrix reporting across units, temporary task-force tiers).
- Evidence emerges that the "User transcends tiers" framing produces confusion rather than clarity.
- Implementer drafts prove to be a consistent source of low-quality proposals, suggesting the approval gate needs sharper criteria.
- A new unit type emerges that doesn't fit the Lead/Implementer pair (e.g., a unit that's just a Lead with no Implementer, or a Registrar-only unit).

## References

- `../../docs/foundations/01-stratified-cognition.md` — cognitive-horizon framing that tier-1-of-unit, tier-2-of-unit preserve.
- `../../docs/foundations/02-subsidiarity.md` — decisions at lowest competent level; User-transcends-tiers is the limit case at the top.
- `../../agents/user/AGENTS.md` — the User's role as principal.
- `../../agents/lead/AGENTS.md` — Lead's first-class ADR authority.
- `../../agents/implementer/AGENTS.md` — Implementer's draft-with-approval path.
- §0006 (intact) — the starter tier model this ADR extends.
- §0010 — roster change protocol; applies to adding tiers or roles.
- §0012 — Registrar as async auditor; related role-authority refinement.
- §0015 — agency and unit structure; the multi-unit context this ADR was written to serve.
