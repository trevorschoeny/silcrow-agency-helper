# ap-NNN — {anti-pattern name: what it looks like from the outside}

- **Status:** active <!-- active | retired (if the conditions that made it an anti-pattern no longer apply) -->
- **Date surfaced:** YYYY-MM-DD
- **Surfaced by:** {agent(s)}
- **Related ADRs:** {§-numbers of decisions that reference or were motivated by this anti-pattern}

## Surface appearance

{What the anti-pattern looks like to someone considering it. Why does it seem reasonable? Under what circumstances would a thoughtful person be tempted to do this?}

## Why it fails

{What actually happens when you apply this pattern. What breaks, degrades, or compounds over time? Concrete mechanisms, not abstractions — "this fails because X causes Y which eventually leads to Z," not "it's bad practice."}

## Observed instances

{If this anti-pattern has been seen in the wild — in this project, a prior project, or a credible source — list them. Otherwise, this section can be empty, but understand that anti-patterns without observed instances are weaker than those with them.}

## Correct alternative

{What to do instead. Point to the ADR(s) that capture the correct pattern. If no such ADR exists yet, note that the correct alternative is not yet recorded — and file a note for the relevant tier to author one.}

## Review trigger

{When should this record be re-examined? Often: "never — the failure mode is intrinsic" is a valid answer. But if the anti-pattern is context-sensitive (e.g., only applies under a particular technology, load level, or team size), name the conditions under which it might no longer apply.}

---

<!--
Anti-patterns are first-class records. This template is used when an
anti-pattern is reusable — likely to come up again, worth naming standalone so
future agents can recognize and avoid it without re-deriving the lesson.

For anti-patterns that are specific to a single decision, consider whether it
should be embedded in that decision's `Anti-patterns surfaced` section instead.
See `REFERENCE@{agency_dir}/decision-process.md` for the promotion criteria.

Numbering: `ap-001`, `ap-002`, etc. Separate sequence from the §-numbering used
for ADRs. Monotonic, never reused. Registrar assigns numbers.
-->
