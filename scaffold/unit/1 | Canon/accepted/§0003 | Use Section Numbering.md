# §0003 | Use §-numbering: sequential, monotonic, never-reused

- **Status:** accepted
- **Date:** {date}
- **Authors:** scaffold initialization (inherited via §0001)
- **Supersedes:** —
- **Superseded by:** —
- **Influences:** §0004 (immutability relies on stable identifiers); all future ADRs.
- **Influenced by:** §0001

## Context and problem statement

**Inherited decision.** This is a founding constitutional decision inherited from the Silcrow plugin via §0001 at project initialization. The reasoning and alternatives are preserved here so it can be evaluated or superseded on its own merits through the normal ADR lifecycle.

Every ADR needs an identifier that other ADRs, messages, and code can cite. The identifier needs to be unique, durable, and human-usable. The choice governs every ADR filename and every citation in the project.

## Considered options

1. **§-numbering: sequential, monotonic, never-reused** — e.g., `§0001`, `§0042`. Borrowed from legal citation tradition (*signum sectionis*, medieval scribal origin; modern Bluebook form).
2. **Topic-prefixed numbering** — e.g., `auth-001`, `data-007`. Hints at subject matter in the identifier.
3. **UUIDs** — e.g., `4b3f8e2a-...`. Guaranteed unique without coordination.
4. **Sequential plain numbers** — e.g., `0001`, `0042`. Same as (1) but without the §.

## Decision outcome

**Chosen option: (1) §-numbering with sequential, monotonic, never-reused discipline.**

The three disciplines (sequential, monotonic, never-reused) have governed legal citation for centuries. They make cross-references durable across time — you can cite *42 U.S.C. § 1983* today and the citation will resolve the same way in fifty years. Records systems that fail this discipline (topic-prefixed that get reorganized; UUIDs that humans can't remember; sequential plain numbers that tempt reassignment) exhibit citation rot measurable in months.

The `§` character is chosen over plain sequential numbering because it (a) visually signals "this is a structural identifier, not a quantity," (b) carries the historical weight of legal citation, and (c) keeps filenames sortable while making their identifier-role explicit.

### Consequences

- **Positive:** Citations remain stable over the project's lifetime.
- **Positive:** Filename sort order matches acceptance order, giving a readable history at a glance.
- **Positive:** The discipline is visible and self-enforcing — the Registrar cannot reuse §-numbers without conspicuously violating the convention.
- **Neutral:** Humans cannot infer subject from identifier; filename short titles compensate (`§0042-adopt-observability-v2.md`).
- **Negative:** The `§` character is awkward in some shells and search tools. Wildcards work; the friction is real but modest.

## References

- `../../3 | Silcrow Agency Reference/foundations/05 | Legal Citation Tradition.md` — full intellectual history and citations.
- *The Bluebook: A Uniform System of Citation* (21st ed., 2020, Harvard Law Review Association).
- Butterick, M. (2018). *Typography for Lawyers*, entry on section marks.
- `../../3 | Silcrow Agency Reference/Decision Process.md` — operational rules for §-numbering in this project.
