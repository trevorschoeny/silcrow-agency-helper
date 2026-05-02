# §0011 — Registrar operates as async auditor, not sync gatekeeper

- **Status:** accepted
- **Date:** {date}
- **Authors:** scaffold initialization (inherited via §0001)
- **Supersedes:** §0008
- **Superseded by:** —
- **Influences:** every Registrar action; every ADR submission flow; the `:silcrow-update` skill workflow.
- **Influenced by:** §0001, §0004, §0005, §0006

## Y-statement

In the context of **an agency whose decision record is load-bearing and whose agents need to move at the speed of thought**,
facing the serial-bottleneck effect of per-proposal Registrar validation,
we decided for **a Registrar that audits on demand rather than gatekeeping every submission** — Lead commits directly to `accepted/` when confident; Registrar reviews the record later, flags issues, and corrects only procedural ones —
and neglected keeping sync gatekeeping (§0008's original form), abolishing the Registrar entirely, and giving the Registrar substantive authority,
to achieve faster decision throughput with the context of authorship preserved and the procedural/substantive separation intact,
accepting that the record sometimes lands in `accepted/` with small form issues the Registrar corrects after the fact,
because the form/substance separation from §0008 is preserved by role design, not by serial validation.

## Context and problem statement

§0008 established the Registrar with strictly procedural authority — enforcing form, never substance — which remains the correct separation. But §0008 as written implicitly coupled that authority to a **synchronous gatekeeper** workflow: every ADR passed through `proposed/`, was validated by the Registrar, and was moved to `accepted/` only after that check.

In practice this serial workflow produces three costs:

- **Workflow latency.** Every ADR is a round-trip between Lead and Registrar. Even when the Registrar is fast, it's another step.
- **Context evaporation.** The Lead leaves the decision with the Registrar; by the time acceptance comes back, the "why" has faded from working memory. Future deliberations lose the decision as a live reference.
- **Registrar as soft bottleneck.** During busy weeks the Registrar inbox grows; decisions queue; authority to act effectively slows.

The separation between form and substance — the real load-bearing property of §0008 — does not require synchronous gating. A Registrar who audits the record on demand can still flag form issues, correct procedural slips, and surface substantive concerns for the Lead or User to act on. The authority is the same; the operating mode is different.

## Decision drivers

- **Preserve the form/substance separation.** Whatever workflow we choose must keep the Registrar's authority procedural-only.
- **Remove the per-proposal bottleneck.** Lead should be able to commit decisions directly when confident.
- **Keep authorship context alive.** Decisions should land near the deliberation, not travel through a queue.
- **Keep the `proposed/` channel useful.** For agents who want pre-review (typically Implementers drafting with Lead approval), the pre-review path should remain open.

## Considered options

1. **Keep sync gatekeeping (§0008's original form).** Every ADR passes through `proposed/` and Registrar validation before acceptance.
2. **Abolish the Registrar.** Form maintenance by convention; any agent can flag issues.
3. **Give the Registrar substantive authority.** Registrar can block on merits, not just form.
4. **Async auditor (chosen).** Lead commits directly when confident; Registrar audits on demand and corrects procedural issues, surfaces substantive ones.

## Decision outcome

**Chosen option: (4) Async auditor.**

Option (4) preserves every property that made §0008 load-bearing — the Registrar's authority remains procedural; form/substance stays separated; record integrity has a home — while removing the latency that per-proposal gatekeeping imposes. The Registrar's work shifts from *validating each submission* to *auditing the record periodically*. Same authority, different cadence.

Option (1) is what §0008 implicitly produced; the costs above are real and persistent. Option (2) recreates the pre-Registrar failure mode (form maintenance falls on no one in particular). Option (3) conflates form and substance — the exact failure §0008 was built to prevent.

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

On-demand audits cover form, contradictions, staleness, citation integrity, orphans, scope violations (§0020), federation-rule violations, unsafe references (§0013), unit↔ADR consistency (§0014), and git hygiene (§0017, informational). The full checklist lives in `../../agents/registrar/AGENTS.md`.

Correction authority is **hybrid**:
- **Procedural issues** (filename typos, malformed §-numbering, broken citation paths, bidirectional-link repair) — Registrar fixes directly.
- **Substantive issues** (contradictions, scope violations, unsafe references) — Registrar surfaces via message and recommends; never silently fixes. Scope violations route to User; internal contradictions to Lead; ambiguous to both.

The `proposed/` directory is retained as a **voluntary pre-review channel**: Lead may commit directly to `accepted/` or drop into `proposed/` for Registrar eyes first; Implementers use `proposed/` as required staging under §0012's draft-with-approval path.

## Anti-patterns surfaced

- **Registrar as sync gatekeeper.** Reverting to per-proposal validation defeats the purpose. If a workflow starts requiring Registrar sign-off before commit, push back.
- **Registrar as silent fixer.** Correcting substantive content — even subtly — under the guise of procedural repair. The distinction must be held carefully.
- **Audit queue growing without audit.** If the on-demand audit never happens, the record decays silently. The User or Lead should invoke audits periodically (and the `:silcrow-update` skill invokes one implicitly).
- **Pre-review-by-default.** Dropping everything into `proposed/` out of habit recreates the latency this ADR was built to remove. Lead's default should be direct commit.

## Review trigger

Reconsider this ADR if:

- Procedural drift between commits and audits becomes a persistent quality problem (suggests audits aren't happening often enough, or the form discipline at commit time has slipped).
- A substantially different governance pattern is being adopted that changes the Registrar's relationship to decisions.
- Evidence emerges that authorship context is no longer being preserved even with direct-commit authority (suggests something else about the workflow is evaporating context).

## References

- `../../docs/foundations/06-registrar-pattern.md` — full intellectual history of the procedural/substantive split, with a section on why the audit mode preserves it.
- `../../agents/registrar/AGENTS.md` — the Registrar's complete operational reference: audit checklist, correction procedures, and `:silcrow-update` orchestration.
- §0008 (superseded) — the synchronous-gatekeeper original whose principle this ADR preserves.
- §0012 — Implementer drafting-with-approval path uses `proposed/` as required staging.
- §0013 — unsafe-reference audit item.
- §0014 — unit↔ADR consistency audit item.
- §0015 — `:silcrow-update` audit-ADR pattern builds on this model.
- §0017 — governance commit convention; Registrar audits for unpushed governance.
