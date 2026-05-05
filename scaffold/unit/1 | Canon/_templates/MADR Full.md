<!--
HONEST MINIMALISM (§0017). Every section below appears in every ADR. Section
headers are non-negotiable. Section *content* is bounded by what was actually
discussed and decided: substantive content where there is substance; a single
honest sentence (e.g., "None considered.", "No anti-patterns surfaced.")
where there isn't. Never fabricate content to populate a section.
-->

# §NNNN | {short decision title in imperative form}

- **Status:** proposed <!-- proposed | accepted | rejected | superseded-by-§XXXX -->
- **Date:** YYYY-MM-DD
- **Agency:** {agency_name}
- **Unit:** {unit_name}
- **Authors:** {agent(s)}
- **Supersedes:** — <!-- or: §XXXX -->
- **Superseded by:** — <!-- left blank on creation; Registrar fills if this ADR is later superseded -->
- **Influences:** — <!-- list of §-numbers this ADR affects -->
- **Influenced by:** — <!-- list of §-numbers this ADR builds on -->

## Why-statement

In the context of *{system, concern, or scope}*,
facing *{the problem, pressure, or question}*,
we decided for *{the chosen option}*
and neglected *{the main alternatives rejected}*,
to achieve *{the outcome we want}*,
accepting *{the cost or tradeoff}*,
because *{the deeper reason — often a principle from `3 | Silcrow Agency Reference/Philosophy.md`}*.

## Context and problem statement

{Two to five paragraphs. What's the situation? What forces are at play — technical, organizational, strategic? What question is this ADR answering?}

## Decision drivers

<!-- The forces, constraints, or principles pushing on this decision. If the
context paragraph already named them clearly, write a single honest sentence
here referencing back, e.g.: "See Context above; the drivers are the explicit
constraint stated there." -->

- {driver 1 — e.g., a constraint, an explicit goal, a principle being upheld}
- {driver 2}
- {driver 3}

## Considered options

<!-- List only options that were actually considered. If only one option was
on the table because the choice followed from a constraint, write a single
honest sentence (e.g., "No alternatives were seriously considered; the choice
followed from {the constraint}.") and skip the numbered list. -->

1. **{Option A}** — {one-sentence summary}
2. **{Option B}** — {one-sentence summary}
3. **{Option C}** — {one-sentence summary}

## Decision outcome

**Chosen option: {Option X}**, because {primary reason}.

{Expand: why this option over the others. What's the load-bearing argument? What makes this the best response to the drivers above, given the alternatives?}

### Consequences

<!-- Positive / Negative / Neutral as substance allows. If a category has no
genuine entries, write a single honest line (e.g., "Negative: none surfaced.").
Don't invent entries to populate categories. -->

- **Positive:** {what gets better as a result}
- **Positive:** {what else}
- **Negative:** {what gets worse or what we give up}
- **Neutral:** {changes that aren't clearly good or bad but are worth naming}

## Pros and cons of the options

<!-- If the Decision outcome already covered the comparison adequately, write
a single honest sentence here (e.g., "Covered in Decision outcome above.").
Otherwise, expand per option. -->

### {Option A}

- ✅ {pro}
- ❌ {con}

### {Option B}

- ✅ {pro}
- ❌ {con}

### {Option C}

- ✅ {pro}
- ❌ {con}

## Anti-patterns surfaced

<!-- Most decisions don't surface a genuine anti-pattern. If this one didn't,
write: "No anti-patterns surfaced." Don't invent generic anti-patterns to
populate the section. If a real anti-pattern surfaced, describe it here; if
it's reusable enough to deserve its own record, author it as a separate
§-numbered ADR — anti-patterns are regular ADRs whose conclusion is "don't
do X." -->

{If this decision surfaced patterns that look reasonable but should be avoided, describe them here.}

## Review trigger

<!-- Specific and observable: a metric crossing a threshold, a dependency
changing, a time horizon. If the decision genuinely has no review trigger,
write: "Review trigger: none; the failure mode this addresses is not
context-dependent." That's a legitimate answer. -->

{Under what conditions should this decision be reconsidered?}

## References

- {links to any briefs, messages, PRs, or external sources that informed this decision}
- {links to related ADRs by §-number}

---

<!--
This template is MADR (Markdown Any Decision Records) 4.0-shaped, adapted with
a Why-statement header (Zimmermann, SATURN 2012) and scaffold-specific fields for
bidirectional citation and review triggers. Use this template when the decision
merits the full treatment; for quick, low-friction decisions, use
`MADR Minimal.md` instead.

Honest minimalism (§0017) governs every section: headers always present,
content faithful to what was actually discussed. Fabricating content to fill
sections is the failure mode this discipline exists to prevent.

References:
  - Nygard, M. (2011). Documenting Architecture Decisions. Cognitect blog.
  - Zimmermann, O. (2012). Why-statements. SATURN 2012.
  - MADR project: https://adr.github.io/madr/
-->
