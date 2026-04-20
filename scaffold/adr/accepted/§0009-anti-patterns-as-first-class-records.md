# §0009 — Anti-patterns are first-class records

- **Status:** accepted
- **Date:** {date}
- **Authors:** scaffold initialization (inherited via §0001)
- **Supersedes:** —
- **Superseded by:** —
- **Influences:** every future decision that surfaces an anti-pattern.
- **Influenced by:** §0001

## Context and problem statement

**Inherited decision.** This is a founding constitutional decision inherited from the agent-org-scaffold skill via §0001 at project initialization. The reasoning and alternatives are preserved here so it can be evaluated or superseded on its own merits through the normal ADR lifecycle.

Some of the most valuable learning in a project comes from patterns that failed. Preserving that learning — and making it reusable — requires a deliberate mechanism. Without one, anti-patterns are re-derived every time the tempting-but-wrong path presents itself, and the cost of learning is paid repeatedly.

## Considered options

1. **Don't track.** Anti-patterns live in the heads of whoever was around when they were surfaced.
2. **Note-only.** Informal mentions in chat or notes, not structured records.
3. **Embedded-only.** Anti-patterns recorded inside the ADR whose decision surfaced them; never promoted.
4. **Embedded + promoted to standalone (chosen).** Anti-patterns start embedded. When one becomes reusable — cited by a second ADR — it is promoted to a standalone `ap-NNN` record.

## Decision outcome

**Chosen option: (4) Embedded + promoted to standalone.**

This option matches how anti-pattern knowledge actually accrues. The first time an anti-pattern is noticed, it is specific to a decision, and the right place for it is inside that decision's ADR. As soon as it recurs — a second decision wants to cite it — the specific context is no longer where the knowledge belongs, and a standalone record becomes the right home.

The `ap-NNN` numbering sequence is separate from §-numbering because anti-patterns are a different kind of artifact (descriptive, not decisional) and mixing the sequences would be confusing.

Options (1) and (2) fail the turnover test — agents leave with the anti-patterns they know about, and successors re-learn them the expensive way. Option (3) — embedded-only — works for one-off anti-patterns but fails as the knowledge becomes reusable; forcing the reuser to cite the original ADR's embedded section produces brittle, context-specific cross-references.

### Consequences

- **Positive:** Valuable learning from failures is preserved and reusable.
- **Positive:** The embedded-first rule keeps early anti-patterns close to their surfacing context.
- **Positive:** Promotion-on-reuse avoids premature elaboration (standalone records for anti-patterns that are never cited again).
- **Negative:** The promotion step is an extra operation someone has to perform — the Registrar, on request.
- **Neutral:** The `ap-NNN` sequence is a separate numbering system. Agents must remember the distinction.

## References

- `../../docs/decision-process.md` — the promotion criteria for embedded → standalone.
- `../../docs/foundations/04-architecture-decision-records.md` — the broader research on decision rationale preservation.
- `../anti-patterns/README.md` — the anti-pattern directory.
- `../_templates/anti-pattern.md` — the template for standalone records.
