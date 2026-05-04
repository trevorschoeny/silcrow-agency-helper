# §0002 | Use MADR + Why-statement as the ADR format

- **Status:** accepted
- **Date:** {date}
- **Agency:** {agency_name}
- **Unit:** {unit_name}
- **Authors:** scaffold initialization (inherited via §0001)
- **Supersedes:** —
- **Superseded by:** —
- **Influences:** all future ADRs in this project (they use this template).
- **Influenced by:** §0001

## Context and problem statement

**Inherited decision.** This is a founding constitutional decision inherited from the Silcrow plugin via §0001 at project initialization. The reasoning and alternatives are preserved here so it can be evaluated or superseded on its own merits through the normal ADR lifecycle. "We" in this record refers to the project, which adopted this decision implicitly by adopting §0001.

The scaffold needs a uniform template for architectural decision records. Multiple widely-adopted formats exist with different strengths. The choice constrains every future ADR in the project, so it deserves its own record.

## Considered options

1. **Nygard's original ADR template (2011).** Five sections: Title, Status, Context, Decision, Consequences. Minimal, widely adopted, well-tooled.
2. **MADR 4.0 (Markdown Any Decision Records, 2024).** Extends Nygard with explicit *Considered Options* and *Pros and Cons of the Options* sections. Community-maintained spec at adr.github.io/madr.
3. **arc42 Section 9.** ADRs embedded inside a larger arc42 architecture document. Heavier, integrated.
4. **Custom format.** Design our own template tuned to whatever local conventions exist.

## Decision outcome

**Chosen option: (2) MADR 4.0 with a Why-statement header prepended** (Why-statement form from Zimmermann, SATURN 2012).

MADR's explicit alternatives sections solve the most common ADR failure mode — losing the rejected alternatives because Nygard's original template lets them be buried in prose-form *Context*. Capturing rejected alternatives is the part that survives contact with future agents who want to know "did we consider X?" (See Capilla et al., *Journal of Systems and Software* 116, 2016 — "decision rationale loss" is driven more by missing alternatives than missing decisions.) The Why-statement header adds a single-sentence compression at the top so readers can orient before reading the full body.

### Consequences

- **Positive:** Rejected alternatives are first-class content, addressing the #1 documented failure mode for ADRs.
- **Positive:** Why-statement at the top enables fast scanning; you can read an archive of 50 ADRs' Why-statements in five minutes.
- **Positive:** Both MADR and Why-statements are widely adopted, community-maintained, and tool-supported.
- **Neutral:** Slightly more ceremony per ADR than Nygard's minimal original. Mitigated by the `MADR Minimal.md` template for light decisions.
- **Negative:** Template drift over time is a risk — MADR 4.0 is current, but MADR evolves. If the spec moves, we decide whether to track or pin.

## References

- `../../3 | Silcrow Agency Reference/foundations/04 | Architecture Decision Records.md` — full intellectual history and citations.
- Nygard, M. (2011). "Documenting Architecture Decisions." cognitect.com.
- MADR spec: https://adr.github.io/madr/ (v4.0, September 17, 2024).
- Zimmermann, O. (2012). Why-statements, SATURN 2012.
- Template files: `../_templates/MADR Full.md`, `../_templates/MADR Minimal.md`.
