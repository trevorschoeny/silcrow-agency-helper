# §0001 — Adopt the agent-org-scaffold pattern

- **Status:** accepted
- **Date:** {date}
- **Authors:** {user_role} (approving authority); skill-generated draft
- **Supersedes:** —
- **Superseded by:** —
- **Influences:** §0002, §0003, §0004, §0005, §0006, §0007, §0008, §0009, §0010 (founding constitutional decisions inherited through this ADR); all future ADRs in this project (structural).
- **Influenced by:** — (this is §0001)

## Y-statement

In the context of **{project_name}**,
facing the need to structure a multi-agent project so that decisions, rationale, and roles survive turnover and time,
we decided for **the agent-org-scaffold pattern** — hierarchical tiers (User / {lead_role} / {implementer_role}), an immutable ADR decision log using §-numbering, a Registrar with procedural authority over record integrity, and actor-model message passing between agents —
and neglected informal conventions, lightweight-markdown-only approaches, and heavier process frameworks (Agile ceremonies, ISO/SDLC process models),
to achieve decisions preserved across turnover, roles with clear cognitive horizons, and a navigable historical record,
accepting the upfront structural overhead and the discipline required to maintain immutability,
because each element of the pattern (stratified cognition, subsidiarity, actor model, ADRs, §-numbering, registrar separation) has independently proven itself across organizational theory, distributed systems, and legal tradition (see `docs/philosophy.md`).

## Context and problem statement

{project_description}

The project is structured as a hierarchical organization of agents that will collaborate on work over time. Without explicit discipline from day one, hierarchical multi-agent systems tend to drift. Decisions get lost. Rationale evaporates. Agents drift into inconsistent formats. The record of *why* things are the way they are becomes irrecoverable. By the time the need for structure is obvious, imposing it retroactively is dramatically more expensive than having built it in at the start.

We need a structure that:

1. Preserves decisions — what was decided, why, what alternatives were rejected.
2. Makes role boundaries explicit — who owns what kind of work at what time horizon.
3. Survives turnover — agents (human or otherwise) can leave and be replaced without the record fragmenting.
4. Scales gracefully — the pattern works at today's small roster and at a plausible future larger one.
5. Is not so heavyweight that it competes with the work for attention.

## Decision drivers

- **Durability of the record.** Decisions must be preserved as immutable history, not overwritten.
- **Role clarity.** Each agent must know what they own, what they escalate, and who they report to.
- **Auditability.** Someone arriving months later must be able to reconstruct why any given state exists.
- **Subsidiarity.** Decisions should be made at the lowest tier capable of making them well.
- **Fit to cognitive work.** Tiers should reflect real differences in time horizon and work nature, not arbitrary authority levels.
- **Convergent evidence.** The scaffold's elements are not novel; each has independent empirical or historical support (see `docs/philosophy.md`).

## Considered options

1. **No formal structure.** Agents act ad-hoc, communicate freely, no formal decision log. Lowest upfront cost.
2. **Lightweight markdown notes only.** A `NOTES.md` or `DECISIONS.md` file where informal decisions accumulate. Medium upfront cost.
3. **Agent-org-scaffold (this option).** The full pattern: tiered roster, ADR decision log with §-numbering, Registrar role, actor-model inboxes, philosophy documentation. High upfront cost, highest ongoing structure.
4. **A heavier process framework.** Full Agile ceremonies, RACI matrices, formal SDLC, change-management boards. Very high upfront cost, bureaucratic overhead.

## Decision outcome

**Chosen option: (3) Agent-org-scaffold**, because the pattern directly addresses each decision driver while drawing on structural disciplines with decades (or centuries) of independent validation.

The pattern is not a single novel invention; it is the composition of six well-established disciplines (see `docs/philosophy.md`): stratified systems theory (Jaques), subsidiarity (Catholic social teaching / EU law), the actor model (Hewitt, Armstrong), architecture decision records (Nygard), §-numbering (legal citation tradition), and the registrar pattern (academic and civil administration). Each discipline holds the others in place: immutability works because the Registrar enforces form; the actor model works because the record provides shared truth; stratified cognition works because subsidiarity prevents upward delegation.

Options (1) and (2) fail driver 1 (durability) within months, based on documented experience with informal decision records (see the "decision rationale loss" literature cited in `docs/foundations/04-architecture-decision-records.md`). Option (4) is disproportionate to the size and kind of work this project will do, and risks the process consuming more attention than the work itself.

### Consequences

- **Positive:** Decisions, once accepted, are preserved as permanent history with full context — rationale, alternatives, and consequences.
- **Positive:** Role boundaries are explicit and grounded in a measurable property (time horizon), not just authority.
- **Positive:** The Registrar role creates a dedicated custodian for record integrity, so the integrity does not depend on the diligence of busy decision-makers.
- **Positive:** The scaffold is opinionated about structure but flexible about vocabulary — roles can be renamed to match any domain.
- **Negative:** Upfront effort to internalize the discipline. Agents must read `docs/philosophy.md` and `docs/decision-process.md` before operating fluently.
- **Negative:** The immutability discipline creates friction when someone wants to "just fix" an old ADR. Supersession is a heavier operation than editing.
- **Neutral:** The scaffold is opinionated about its conventions (§-numbering, inbox/archive, MADR template). Variance is accommodated through supersession, not edits.

## Pros and cons of the options

### (1) No formal structure

- ✅ Zero upfront cost.
- ✅ No friction to get moving.
- ❌ Decision rationale is lost as soon as the original conversation is forgotten.
- ❌ Role ambiguity produces friction that compounds over time.
- ❌ Recovery cost (later retrofitting of structure) is dramatically higher than the cost of building it in.

### (2) Lightweight markdown notes only

- ✅ Low upfront cost.
- ✅ Some record exists.
- ❌ Lacks stable identifiers — decisions can't be cited reliably over time.
- ❌ Lacks the separation between proposal and acceptance, so in-progress thinking bleeds into the record.
- ❌ Without a Registrar, the record's integrity degrades under busy weeks.

### (3) Agent-org-scaffold

- ✅ Addresses every driver above.
- ✅ Builds on independently validated disciplines.
- ✅ Scales by fan-out (more ADRs, more registrars) rather than restructuring.
- ❌ Upfront overhead in setup and onboarding.
- ❌ Requires discipline to maintain (especially immutability).

### (4) Heavier process framework

- ✅ Extremely thorough.
- ❌ Disproportionate: the overhead of ceremonies, boards, and formal processes would likely exceed the total work product for a small project.
- ❌ Emphasis on process compliance can displace thinking.

## Anti-patterns surfaced

- **Editing an accepted ADR in place.** Even "obvious" corrections to an accepted ADR erode immutability. The correct action is supersession (write §XXXX that references §NNNN as Supersedes) or a retrospective note appended below the original body. See `docs/decision-process.md` Example 3.
- **The Registrar making substantive calls.** If the Registrar begins adjudicating whether a decision is *right*, the separation of form and substance is gone. Surface and push back if this starts happening.
- **Tier-skipping.** Senior agents giving direct feedback to junior agents outside the reporting structure collapses the stratification. Route through tiers, even when it feels slower.

## Review trigger

Reconsider this decision if:

- The organization grows beyond what the current tier structure can carry (typically when the {lead_role}'s time is dominated by review rather than architecture).
- A proposed roster change would change the number of tiers (not just the names).
- The Registrar role becomes a bottleneck.
- Experience reveals a structural failure mode this ADR didn't anticipate.

In each case, write a superseding ADR referencing this one. Do not edit this record.

## References

- `docs/philosophy.md` — the full rationale for every element of this scaffold.
- `docs/decision-process.md` — the lifecycle of ADRs, including this one.
- `docs/foundations/` — per-thread intellectual history for the six foundational disciplines.
- `agents/` — the directories of the starter roster this ADR implicitly defines.
- Source: initialized via the `agent-org-scaffold` skill ({date}).
