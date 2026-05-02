# Anti-patterns

This directory holds **standalone anti-pattern records** — records of patterns that look reasonable from the outside but fail in practice. Anti-patterns are first-class records in this project, given the same discipline as ADRs.

## When to record an anti-pattern

An anti-pattern earns a standalone record when:

1. It is **reusable** — likely to come up across future decisions, not tied to a single ADR.
2. Its surface appearance is plausible enough that a thoughtful person might do it.
3. Naming it saves future agents from re-deriving the lesson.

If the anti-pattern is specific to a single decision, **embed it** in that decision's `Anti-patterns surfaced` section instead. Promotion from embedded to standalone is a valid operation — the Registrar can perform it when the anti-pattern is cited by a second ADR.

## Numbering

Separate sequence from the §-numbering used for ADRs. Anti-patterns use `ap-001`, `ap-002`, and so on. Monotonic and never reused. Registrar assigns numbers.

Filenames follow the pattern `ap-NNN-short-title.md`.

## Template

Use `../_templates/anti-pattern.md` for new records.

## Index

*(empty — anti-patterns will be added as they are surfaced and promoted.)*

---

## See also

- `../_templates/anti-pattern.md` — the template
- The agency's `@{agency_dir}/REFERENCE@{agency_dir}/decision-process.md` — includes the promotion criteria for embedded → standalone anti-patterns
- The agency's `@{agency_dir}/REFERENCE@{agency_dir}/philosophy.md` — the discipline that makes anti-pattern records meaningful
