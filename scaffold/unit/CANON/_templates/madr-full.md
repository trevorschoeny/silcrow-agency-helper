# §NNNN — {short decision title in imperative form}

- **Status:** proposed <!-- proposed | accepted | rejected | superseded-by-§XXXX -->
- **Date:** YYYY-MM-DD
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
because *{the deeper reason — often a principle from `REFERENCE@{agency_dir}/philosophy.md`}*.

## Context and problem statement

{Two to five paragraphs. What's the situation? What forces are at play — technical, organizational, strategic? What question is this ADR answering?}

## Decision drivers

- {driver 1 — e.g., a constraint, an explicit goal, a principle being upheld}
- {driver 2}
- {driver 3}

## Considered options

1. **{Option A}** — {one-sentence summary}
2. **{Option B}** — {one-sentence summary}
3. **{Option C}** — {one-sentence summary}

## Decision outcome

**Chosen option: {Option X}**, because {primary reason}.

{Expand: why this option over the others. What's the load-bearing argument? What makes this the best response to the drivers above, given the alternatives?}

### Consequences

- **Positive:** {what gets better as a result}
- **Positive:** {what else}
- **Negative:** {what gets worse or what we give up}
- **Neutral:** {changes that aren't clearly good or bad but are worth naming}

## Pros and cons of the options

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

{If this decision surfaced something people might mistakenly do instead, describe it here — or promote it to a standalone record in `CANON@{unit_name}/anti-patterns/` if it's reusable across future decisions. See `REFERENCE@{agency_dir}/decision-process.md` for the promotion criteria.}

## Review trigger

{Under what conditions should this decision be reconsidered? Time? A metric crossing a threshold? A dependency changing? Be specific enough that future agents can tell whether the trigger has fired.}

## References

- {links to any briefs, messages, PRs, or external sources that informed this decision}
- {links to related ADRs by §-number}

---

<!--
This template is MADR (Markdown Any Decision Records) 4.0-shaped, adapted with
a Why-statement header (Zimmermann, SATURN 2012) and scaffold-specific fields for
bidirectional citation and review triggers. Use this template when the decision
merits the full treatment; for quick, low-friction decisions, use
`madr-minimal.md` instead.

References:
  - Nygard, M. (2011). Documenting Architecture Decisions. Cognitect blog.
  - Zimmermann, O. (2012). Why-statements. SATURN 2012.
  - MADR project: https://adr.github.io/madr/
-->
