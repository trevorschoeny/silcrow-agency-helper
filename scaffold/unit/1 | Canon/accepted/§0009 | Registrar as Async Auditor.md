# §0009 | Registrar operates as async auditor with strictly procedural authority

- **Status:** accepted
- **Date:** {date}
- **Agency:** {agency_name}
- **Unit:** {unit_name}
- **Authors:** scaffold initialization (inherited via §0001)
- **Supersedes:** —
- **Superseded by:** —
- **Influences:** every Registrar action; every ADR submission flow; the `:silcrow-update` skill workflow.
- **Influenced by:** §0001, §0004, §0005, §0006

## Why-statement

In the context of **an agency whose decision record is load-bearing and whose agents need to move at the speed of thought**,
facing the question of how to keep the record's form clean without coupling form-discipline to a serial validation step that bottlenecks every commit,
we decided for **a Registrar with strictly procedural authority who audits the record on demand** — Lead commits directly to `accepted/` when confident; Registrar reviews the record periodically, flags issues, and corrects only procedural ones —
and neglected synchronous gatekeeping (every ADR passing through `proposed/` and Registrar validation before acceptance), abolishing the Registrar entirely (form maintenance by convention), and giving the Registrar substantive authority (allowing them to block on merits, not just form),
to achieve faster decision throughput, authorship context preserved at the moment of deliberation, and a clean separation between form and substance,
accepting that the record sometimes lands in `accepted/` with small form issues the Registrar corrects after the fact,
because the form/substance separation is preserved by role design — by *what the Registrar is allowed to decide* — not by *when* they act, so synchronous gating adds latency without adding correctness.

## Context and problem statement

A decision record needs a custodian. Without one, filenames drift, citations rot, status fields go stale, and the index falls behind. With one, the record stays clean and citable. But the custodian's authority must be carefully bounded: a custodian who can block decisions on their merits becomes a chokepoint that defeats the purpose of distributed authorship.

The discipline that resolves this is the **form/substance separation**: the Registrar has authority over form (filename, §-numbering, status placement, citation integrity, index updates) and no authority over substance (whether a decision is correct, wise, or compatible with strategy). Form questions have right answers the Registrar can determine alone; substance questions belong to the agents authoring the decisions.

That separation is the load-bearing property. The remaining question is *operating mode*: when does the Registrar act?

Two modes are workable:

- **Sync gate.** Every ADR passes through `proposed/`, gets Registrar validation, and moves to `accepted/` only after the check.
- **Async audit.** ADRs land in `accepted/` directly; the Registrar audits the record periodically and corrects or surfaces issues.

In practice, sync-gating produces three costs:

- **Workflow latency.** Every ADR is a round-trip between Lead and Registrar. Even when the Registrar is fast, it's another step.
- **Context evaporation.** The Lead leaves the decision with the Registrar; by the time acceptance comes back, the "why" has faded from working memory. Future deliberations lose the decision as a live reference.
- **Registrar as soft bottleneck.** During busy weeks the Registrar inbox grows; decisions queue; authority to act effectively slows.

The form/substance separation does not require synchronous gating. A Registrar who audits the record on demand can still flag form issues, correct procedural slips, and surface substantive concerns for the Lead or User to act on. The authority is the same; the operating mode is different.

## Decision drivers

- **Preserve the form/substance separation.** Whatever workflow we choose must keep the Registrar's authority procedural-only.
- **Remove the per-proposal bottleneck.** Lead should be able to commit decisions directly when confident.
- **Keep authorship context alive.** Decisions should land near the deliberation, not travel through a queue.
- **Keep the `proposed/` channel useful.** For agents who want pre-review (typically Implementers drafting with Lead approval), the pre-review path should remain open.

## Considered options

1. **Sync gatekeeping.** Every ADR passes through `proposed/` and Registrar validation before acceptance.
2. **Abolish the Registrar.** Form maintenance by convention; any agent can flag issues.
3. **Give the Registrar substantive authority.** Registrar can block on merits, not just form.
4. **Async auditor with procedural authority (chosen).** Registrar's authority is bounded to form. Lead commits directly when confident; Registrar audits on demand and corrects procedural issues, surfaces substantive ones.

## Decision outcome

**Chosen option: (4) Async auditor with procedural authority.**

Option (4) preserves every property that makes a Registrar role load-bearing — the authority remains procedural; form/substance stays separated; record integrity has a home — while removing the latency that per-proposal gatekeeping imposes. The Registrar's work is *auditing the record periodically*, not *validating each submission*. Same authority, different cadence.

Option (1) carries the three costs above; the costs are real and persistent in any team that handles decision volume above a few per week. Option (2) recreates the pre-Registrar failure mode — form maintenance falls on no one in particular and the record decays. Option (3) conflates form and substance — the exact failure the form/substance separation is built to prevent.

The audit model is not new; it mirrors real-world practice. University registrars don't validate every class addition synchronously; they audit enrollment records periodically. Court clerks file documents as they arrive and audit the docket for form issues on a cadence. Corporate secretaries post minutes after the meeting and reconcile against the resolution later. In each case the form/substance separation is preserved by role design, not by serial validation.

### Consequences

- **Positive:** Lead moves at the speed of thought. Decisions land close to the deliberation.
- **Positive:** Authorship context stays alive; the Lead remembers their own reasoning as a live reference.
- **Positive:** Registrar is never a bottleneck; auditing is cadenced, not blocking.
- **Positive:** `proposed/` channel remains open for agents who want pre-review (Implementers drafting with approval; Leads wanting a second set of eyes).
- **Negative:** The record sometimes lands in `accepted/` with small form issues the Registrar later corrects. Procedural drift between commits and audits is expected and normal.
- **Negative:** Detecting contradictions between ADRs happens at audit time, not proposal time — a contradictory ADR can exist in `accepted/` for a day or two before the Registrar flags it.
- **Neutral:** Requires the Lead to hold the form discipline themselves in the first instance — malformed ADRs are corrected after the fact, not blocked before commit.

## What the Registrar audits and how corrections work

On-demand audits cover form, contradictions, staleness, citation integrity, orphans, scope violations (§0017), federation-rule violations, unsafe references (§0011), unit↔ADR consistency (§0012), and git hygiene (§0015, informational). The full checklist lives in `../../Registrar @ {unit_name}/AGENTS.md`.

Correction authority is **hybrid**:
- **Procedural issues** (filename typos, malformed §-numbering, broken citation paths, bidirectional-link repair) — Registrar fixes directly.
- **Substantive issues** (contradictions, scope violations, unsafe references) — Registrar surfaces via message and recommends; never silently fixes. Scope violations route to User; internal contradictions to Lead; ambiguous to both.

The `proposed/` directory is retained as a **voluntary pre-review channel**: Lead may commit directly to `accepted/` or drop into `proposed/` for Registrar eyes first; Implementers use `proposed/` as required staging under §0010's draft-with-approval path.

## Anti-patterns surfaced

- **Registrar as sync gatekeeper.** Reverting to per-proposal validation defeats the purpose. If a workflow starts requiring Registrar sign-off before commit, push back.
- **Registrar as silent fixer.** Correcting substantive content — even subtly — under the guise of procedural repair. The distinction must be held carefully.
- **Registrar with substantive authority.** A Registrar who can block on merits, not just form, becomes a chokepoint and conflates the two kinds of authority. Their authority is bounded to form.
- **Audit queue growing without audit.** If the on-demand audit never happens, the record decays silently. The User or Lead should invoke audits periodically (and the `:silcrow-update` skill invokes one implicitly).
- **Pre-review-by-default.** Dropping everything into `proposed/` out of habit recreates the latency this ADR was built to remove. Lead's default should be direct commit.

## Review trigger

Reconsider this ADR if:

- Procedural drift between commits and audits becomes a persistent quality problem (suggests audits aren't happening often enough, or the form discipline at commit time has slipped).
- A substantially different governance pattern is being adopted that changes the Registrar's relationship to decisions.
- Evidence emerges that authorship context is no longer being preserved even with direct-commit authority (suggests something else about the workflow is evaporating context).

## References

- `../../3 | Silcrow Agency Reference/foundations/06 | Registrar Pattern.md` — full intellectual history of the procedural/substantive split, with a section on why the audit mode preserves it.
- `../../Registrar @ {unit_name}/AGENTS.md` — the Registrar's complete operational reference: audit checklist, correction procedures, and `:silcrow-update` orchestration.
- §0010 — Implementer drafting-with-approval path uses `proposed/` as required staging.
- §0011 — unsafe-reference audit item.
- §0012 — unit↔ADR consistency audit item.
- §0013 — `:silcrow-update` audit-ADR pattern builds on this model.
- §0015 — governance commit convention; Registrar audits for unpushed governance.
