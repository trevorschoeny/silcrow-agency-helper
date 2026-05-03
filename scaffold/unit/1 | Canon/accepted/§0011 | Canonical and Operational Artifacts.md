# §0011 | Canonical and operational artifacts: direction of constraint, promotion rule, reference rule

- **Status:** accepted
- **Date:** {date}
- **Authors:** scaffold initialization (inherited via §0001)
- **Supersedes:** —
- **Superseded by:** —
- **Influences:** every ADR; every plan, brief, or working document; how the Registrar audits references; how updates migrate between plans and ADRs.
- **Influenced by:** §0001, §0002, §0004, §0007

## Why-statement

In the context of **an agency whose canonical decisions must coexist with a living mass of mutable working material — plans, briefs, implementations, research, schedules, codebases**,
facing the tension between keeping ADRs stable and citable and letting operational work evolve freely,
we decided for **a two-category split with a one-way constraint** — canonical artifacts (ADRs) bind operational artifacts (everything else); operational artifacts never bind canonical ones — governed by a promotion rule (operational choices become canonical only when they bind future work) and a reference rule (ADRs may mention operational artifacts only in ways that survive those artifacts changing, disappearing, or being contradicted) —
and neglected a three-tier or finer-grained artifact taxonomy, binding ADRs via `proposed/` only, and outsourcing decision content to external living documents,
to achieve ADRs that remain immutable and load-bearing while operational work iterates freely, with references between the two that don't silently corrupt the record,
accepting that authors must notice when an operational choice has become binding (promotion rule) and check references against the delete-and-contradiction tests (reference rule),
because the canon/operational split has been independently discovered across constitutional economics (Buchanan), legal philosophy (Hart), piecemeal engineering (Popper), polycentric governance (Ostrom), ADR practice (Nygard), and product/sprint patterns (Agile) — a convergence that consistently indicates load-bearing structure.

## Context and problem statement

The scaffold has a sharp treatment of decisions (ADRs, immutable, supersedable — §0004) but leaves the rest of the agency's artifacts under-specified. When an ADR needs to sit alongside operational work — a phased refactor plan, a weekly chore chart, a research report, a cash-flow tracker, a codebase — it's unclear:

- Whether those mutable artifacts get folded into ADRs, live separately, or both.
- Whether ADRs may reference those mutable artifacts.
- When operational content should be promoted to an ADR vs left as a working document.

Without a clear rule, ADRs tend to drift: some become thinly-disguised plans (and inherit the plan's mutability through back-references), others silently depend on external files that later change or disappear. Either outcome corrupts the decision record.

The useful distinction is not "decision vs plan vs implementation" as three rigid tiers. It's a two-category split with a one-way constraint.

## Decision drivers

- **ADR immutability (§0004) must be preserved.** Anything that silently introduces mutability into an ADR — via reference or dependency — defeats the discipline.
- **Working material must iterate freely.** Plans, briefs, implementations, research, schedules all change constantly. The canon model must not force that material into the ADR lifecycle.
- **The boundary must be learnable.** Authors should have a test they can apply to know which category an artifact belongs to and when a reference is safe.
- **The distinction has been found elsewhere.** Multiple independent traditions converge on this split; the scaffold should not be inventing vocabulary where good vocabulary exists.

## Considered options

1. **Everything is an ADR.** Plans, implementations, research all get ADR-ified.
2. **Everything outside ADRs is free-form with no rules.** No promotion rule, no reference rule.
3. **Three-tier taxonomy (decision / plan / implementation).** Rigid three-category split with inter-tier rules.
4. **Canon / operational split with one-way constraint and explicit rules (chosen).**

## Decision outcome

**Chosen option: (4) Canon / operational split with three rules.**

### The Direction-of-Constraint Principle

> *Canonical artifacts constrain operational artifacts; operational artifacts never constrain canonical ones. Constraint flows one direction only — down the stability gradient, from immutable to mutable.*

This is the load-bearing rule. Every other rule follows from it.

The principle is about **authority and binding**, not pointers. An ADR may *mention* operational facts as context, but it may not *depend on* or *defer to* operational state for its own meaning. The ADR is binding; the plan is not.

### The Promotion Rule

> *An operational choice is promoted to canonical when it needs to constrain future work beyond the current execution. Not when it's large. Not when it's important. When it's binding.*

A 12-phase refactor plan is not an ADR because it's long. It's an ADR candidate only if something constitutional is embedded in it that deserves to outlive the execution. Split the plan into (a) the *approach and constraints* — canonical if binding on future work — and (b) the *specific sequence* — operational.

Paired examples of the distinction:

| Context | Not ADR-worthy (operational) | ADR-worthy (binding) |
|---|---|---|
| Code | *"For this module, I'll rename these 12 functions to snake_case."* | *"We use snake_case for all functions in this codebase."* |
| Wedding | *"We'll seat Uncle Joe next to Cousin Mary at the reception."* | *"We never seat anyone from Aunt Susan's side next to Uncle Joe at any family gathering."* |
| Business | *"This quarter's campaign emphasizes enterprise users."* | *"We do not market to consumers under 13."* |
| Research | *"For this experiment, we'll use a sample size of 200."* | *"All experiments must include a control group of at least 30."* |

The left column describes this-execution choices. The right column binds all future executions of the same kind.

### The Reference Rule

ADRs may reference operational artifacts, but only in ways that do not create dependency. Three categories of **safe reference**:

- **Orienting pointer** — *"the current implementation lives in `services/audit/`"* — tells a reader where to look.
- **Provenance citation** — *"this decision was based on findings in `research/market-study.md`"* — names the artifact that led to the decision; the finding itself is embedded in the ADR.
- **Compliance pointer** — *"current cash position is tracked in the monthly cash-flow report"* — names where the rule's satisfaction is measured.

All three share the property that the ADR's meaning survives the referenced artifact changing, disappearing, or being contradicted.

**Two tests for any reference in an ADR:**

- **Delete test:** If the referenced artifact vanishes entirely, does the ADR still carry its decision?
- **Contradiction test:** If the referenced artifact is replaced with one that contradicts the ADR's intent, does the ADR still hold on its own terms?

If *yes* to both → safe reference. If *no* to either → unsafe — the ADR is silently depending on mutable state. Rewrite so the decision and its reasoning live inside the ADR's own text; the reference becomes decorative rather than load-bearing.

### Linguistic tells

Safe references typically use: *"see also..."*, *"tracked in..."*, *"as reflected in..."*, *"based on findings from..."*, *"an initial draft exists at..."*.

Unsafe references typically use: *"according to..."*, *"as described in..."*, *"as defined by..."*, *"per the current state of..."*.

Paired safe/unsafe example:

- **Safe:** *"We adopt a phased refactor for the payments module, because a big-bang rewrite would exceed our rollback window. Initial phasing is tracked in `plans/payments-refactor.md`."* — decision content lives in the ADR; the reference is orientation.
- **Unsafe:** *"We will refactor the payments module according to the phases listed in `plans/payments-refactor.md`."* — the ADR's meaning now depends on the plan staying put.

More paired examples in `foundations/07 | Canonical and Operational.md`.

### Consequences

- **Positive:** ADRs remain immutable and load-bearing; plans and working material iterate freely; references between them don't silently corrupt the record.
- **Positive:** The boundary is learnable via two explicit tests (delete test, contradiction test).
- **Positive:** The promotion rule catches operational choices that have silently become binding before they've drifted into mutable documents.
- **Positive:** Aligns with multiple independent theoretical traditions; vocabulary is shared across them.
- **Negative:** Authors must remember to apply the reference tests when writing ADRs that mention external files. Drift toward unsafe references is easy without discipline.
- **Negative:** The promotion rule requires judgment — not every binding choice is obvious until after the fact.
- **Neutral:** Some artifacts sit near the boundary (e.g., a design document that's partly decision, partly plan). Authors split these into a canonical ADR plus an operational companion document.

## Theoretical backing

The canon/operational split has been independently discovered across multiple traditions — constitutional economics (Buchanan), legal philosophy (Hart), piecemeal engineering (Popper), polycentric governance (Ostrom), ADRs (Nygard), and Agile. That the same structural answer emerges from such different starting points is evidence it's tracking something real. Full intellectual history in `../../3 | Silcrow Agency Reference/foundations/07 | Canonical and Operational.md`.

## Anti-patterns surfaced

- **Binding-by-reference.** ADR says "we will X according to `plans/foo.md`" — the ADR's meaning now depends on `plans/foo.md` staying put and staying consistent. Unsafe. Rewrite with the decision inside the ADR.
- **Plan-as-ADR.** A 12-phase plan becomes an ADR because it's important. But the plan changes weekly; the ADR is now mutable-by-fiction. Split: canonical principle goes into the ADR; specific sequence stays operational.
- **Silent promotion.** An operational choice becomes binding by informal convention without being documented as canon. Later, someone violates it and there's no record to cite. Promote it to an ADR when the pattern is clear.
- **Silent demotion.** An ADR is treated like a plan and edited in place. Covered by §0004; flagged here as the mirror of silent promotion.

## Review trigger

Reconsider this ADR if:

- A pattern of artifacts emerges that consistently sits between canon and operational and can't be cleanly split (suggests the two-category taxonomy is too coarse).
- The delete-and-contradiction tests prove ambiguous in practice (suggests the test needs sharper criteria).
- A new theoretical framing emerges that resolves the canon/operational tension differently and better.

## References

- `../../3 | Silcrow Agency Reference/foundations/07 | Canonical and Operational.md` — full intellectual history covering Buchanan, Hart, Popper, Ostrom, Nygard, and the Agile analog.
- `../../3 | Silcrow Agency Reference/Philosophy.md` — canon/operational framing embedded in the agency's guiding principles.
- `../../Registrar @ {unit_name}/AGENTS.md` — the unsafe-reference audit item and how the Registrar surfaces it.
- §0004 — immutability discipline that this ADR protects against reference-based erosion.
- §0007 — briefs-not-specs sits inside the operational side; this ADR governs its relation to canon.
- §0009 — Registrar audit includes unsafe-reference detection.
- Buchanan, J. M. & Tullock, G. (1962). *The Calculus of Consent.*
- Hart, H. L. A. (1961). *The Concept of Law.*
- Popper, K. (1945). *The Open Society and Its Enemies.*
- Ostrom, E. (1990). *Governing the Commons.*
- Nygard, M. (2011). *Documenting Architecture Decisions.* Cognitect blog.
