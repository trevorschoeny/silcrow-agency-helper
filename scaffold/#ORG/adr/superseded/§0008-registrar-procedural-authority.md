# §0008 — Registrar authority is procedural, not substantive

- **Status:** superseded-by-§0020
- **Date:** {date}
- **Authors:** scaffold initialization (inherited via §0001)
- **Supersedes:** —
- **Superseded by:** §0020
- **Influences:** every future Registrar action; all record-integrity enforcement.
- **Influenced by:** §0001, §0004

> **Retrospective note (on supersession by §0020):** The core principle this ADR
> established — the Registrar's authority is procedural, not substantive — is
> preserved in §0020. What §0020 changes is the *operating mode*: from
> synchronous gatekeeping of every proposal to asynchronous on-demand auditing.
> The separation of form and substance that made this ADR load-bearing is
> retained in §0020; the per-proposal workflow latency is not. Read both
> together for the full history.

## Y-statement

In the context of **a project that treats its decision record as load-bearing**,
facing the need for a role that enforces record integrity without becoming a substantive decision-maker,
we decided for **a Registrar with strictly procedural authority** — form, not content — operating outside the decision hierarchy,
and neglected no-registrar (integrity by convention), review-authority (Registrar can reject on the merits), and senior-role (Registrar as de facto top of the hierarchy),
to achieve record integrity that survives busy periods, controversial decisions, and agent turnover,
accepting that the Registrar will sometimes see substantive issues and have to surface them via message rather than fix them directly,
because conflating form and substance in one role is a centuries-documented failure mode in universities, courts, corporations, and deliberative assemblies.

## Context and problem statement

**Inherited decision.** This is a founding constitutional decision inherited from the Silcrow plugin via §0001 at project initialization. The reasoning and alternatives are preserved here so it can be evaluated or superseded on its own merits through the normal ADR lifecycle.

Record integrity (§0004) only works if someone is responsible for it. But the nature of that responsibility matters: a role that enforces record integrity *and* makes substantive calls on the record's content corrupts both roles over time. This decision fixes the Registrar's authority at *procedural only* — form, numbering, placement, citation — and explicitly excludes substantive adjudication.

## Decision drivers

- **Immutability must be enforceable.** The discipline in §0004 requires a dedicated enforcer; otherwise the discipline slips under pressure.
- **Substance must live with the decision-makers.** Neither the Registrar nor anyone else outside a decision's authority chain should be able to block acceptance on content grounds.
- **Separation must be observable.** Agents should be able to tell, for any Registrar action, whether it was a form call (legitimate) or a substance call (out of scope).
- **Scalability.** The pattern must work at small scale (one Registrar) and large (many Registrars per partition, perhaps a Chief Registrar) without changing the authority model.

## Considered options

1. **No registrar.** Integrity maintained by convention; any agent can enforce.
2. **Review-authority registrar.** Registrar can reject proposals on the merits, not just on form.
3. **Senior-role registrar.** Registrar as a senior agent in the hierarchy, perhaps tier-0-adjacent.
4. **Procedural-only registrar (chosen).** Registrar enforces form; substance belongs to decision-makers.

## Decision outcome

**Chosen option: (4) Procedural-only registrar.**

Real-world registrars — university (AACRAO), court (FJC *Judiciaries Worldwide*), corporate (company secretary), deliberative assembly (Robert's Rules secretary) — are all procedural-only. The separation between form and substance has been refined across these domains over centuries, and every deviation from it reliably produces one of two failure modes:

- *Form slips because substance is more urgent.* When the registrar also decides content, they prioritize the urgent content calls over the "paperwork" of form. Record integrity decays proportionately to how busy the decision-makers are.
- *Substance becomes procedural because the role's bias is toward form.* When the content-decider is also the registrar, decisions get shaped by what fits the filing convention rather than what answers the question.

Options (1), (2), and (3) all combine form and substance to varying degrees:

- (1) — no registrar — puts form maintenance on all agents, which means it falls on the most diligent, who burn out, and then on no one.
- (2) — review-authority registrar — explicitly conflates the two roles. The Registrar becomes a bottleneck or a power center, and sometimes both.
- (3) — senior-role registrar — conflates the authority structure further. A Registrar with hierarchical seniority cannot refrain from weighing in on substance; the structure invites it.

Only (4) preserves the separation that centuries of practice have refined.

### Consequences

- **Positive:** Record integrity is maintained even during busy periods or controversial decisions, because the enforcer has no incentive to look the other way.
- **Positive:** The Registrar cannot bottleneck substance, because they have no authority over it.
- **Positive:** Agents know exactly what kind of pushback to expect from the Registrar — form issues only.
- **Positive:** The role scales by fan-out without drift: more Registrars for larger record volumes, all procedural.
- **Negative:** When the Registrar sees a substantive issue, they cannot fix it; they must surface it by message and rely on the appropriate decision-maker to respond. This is slower than direct correction.
- **Negative:** The discipline requires the Registrar to hold a careful stance — specifically, to not assert their opinion as authority. This is unusual for agents accustomed to broader roles and requires explicit reinforcement.

## Pros and cons of the options

### (1) No registrar

- ✅ Minimum role overhead.
- ❌ Form maintenance falls on no one in particular, which means it falls on no one.
- ❌ Record integrity decays unpredictably.

### (2) Review-authority registrar

- ✅ One role handles everything about the record.
- ❌ Conflates form and substance; centuries of practice argue against this.
- ❌ Becomes a bottleneck or a power center; often both.

### (3) Senior-role registrar

- ✅ Clear authority to enforce discipline.
- ❌ Senior rank plus record-integrity role invites substance-adjudication.
- ❌ Structurally invites the failure modes above.

### (4) Procedural-only registrar

- ✅ Form and substance cleanly separated.
- ✅ Aligns with centuries of practice in universities, courts, corporations, assemblies.
- ✅ Scales by fan-out.
- ❌ Requires the Registrar to resist the temptation to fix substance directly.

## Anti-patterns surfaced

- **Registrar as bottleneck.** If decision-makers start waiting on the Registrar for substantive sign-off, the separation has slipped. The Registrar should push back: "I see the issue; I'm not the one to call it — sending to {lead_role}."
- **Registrar as power center.** If the Registrar begins to adjudicate which decisions are "right," they become a de facto senior decision-maker without the accountability. Surface and correct this immediately.
- **Silent substance fixes.** The Registrar quietly corrects a content issue in a proposed ADR. Even when the correction is right, it opaquely inserts Registrar judgment into a record that should reflect the author's reasoning.
- **Registrar-as-{lead_role}.** Bundling the two roles in a single agent ("for efficiency") collapses the separation. Single people can wear both hats if the hats stay separate, but the hats themselves must not merge.

## Review trigger

This decision should be reconsidered only if a radically different governance structure is being adopted (e.g., decision-making by assembly vote rather than tiered hierarchy). The separation between form and substance is not context-dependent; it is load-bearing in every governance structure where records matter.

## References

- `../../docs/foundations/06-registrar-pattern.md` — full intellectual history.
- `../../agents/registrar/AGENTS.md` — operational procedures.
- `../../agents/registrar/AGENTS.md` — the Registrar's own instructions, which open with this stance.
- AACRAO (American Association of Collegiate Registrars and Admissions Officers), professional standards materials.
- *Robert's Rules of Order*, 12th ed. (2020), on the secretary's role.
- Weber, M. (1922). *Wirtschaft und Gesellschaft*, Part III on bureaucracy.
