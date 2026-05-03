# 04 | Architecture Decision Records

## What the idea is

An **Architecture Decision Record (ADR)** is a short document that captures *one* architectural decision and its underlying reasoning. It records:

- The **context** — the situation, constraints, and forces at play at the time of decision.
- The **decision** — what was chosen.
- The **alternatives** — what was considered and rejected, and why.
- The **consequences** — what follows from the decision, positive and negative.

ADRs are **immutable once accepted**. They are never edited. They are *superseded* by new ADRs when circumstances change. The superseded ADR remains in the record, preserved as history.

The purpose is to prevent what the research literature calls **decision rationale loss** — the gradual evaporation of reasoning as the people who originally reasoned move on. Without ADRs, the same decisions get re-debated, or worse, silently reversed, because no one remembers why they were made.

## The intellectual history

### Before ADRs (pre-2011)

The problem ADRs address is old. Architectural documentation has been a recognized need since the earliest software-engineering literature. Parnas' 1972 paper "On the Criteria to Be Used in Decomposing Systems into Modules" implicitly motivated recording the *reasoning* behind modular decompositions. IBM's 1970s–90s software-engineering practices produced heavyweight design documents that, in theory, captured rationale. In practice, the heavyweight documents rarely got kept current — or, if current, rarely got read.

Tyree and Akerman's 2005 *IEEE Software* paper ("Architecture decisions: Demystifying architecture") was one of the first calls for lightweight, per-decision records. But the format that actually caught on came six years later.

### Nygard (2011)

**Michael Nygard** published "Documenting Architecture Decisions" on the Cognitect blog on November 15, 2011. The post is short — about 900 words — and proposes a deliberately minimal template:

> *Context: What is the issue that we're seeing that is motivating this decision or change?*
> *Decision: What is the change that we're actually proposing or doing?*
> *Status: Proposed, accepted, deprecated, superseded, etc.*
> *Consequences: What becomes easier or more difficult to do because of this change?*

Five sections, each a paragraph or two. Nygard's core insight is that the *heavyweight* documentation teams are supposed to keep is rarely kept; the *lightweight, focused* documents actually are. By making each decision a separate short document, he made updating cheap and reading even cheaper.

The post also introduced the discipline of immutability. From Nygard:

> *If we make a decision, then later reverse it, we should keep the original decision around but marked as superseded. (It's important to know that it was a valid choice, but is no longer.)*

That one paragraph is the entire load-bearing argument for never editing an accepted ADR. It remains the best short statement of the discipline.

### Spread (2011–2018)

The format spread. A short timeline:

- **2013–2015.** ADR practice spreads through the Cognitect consulting community and the broader Clojure ecosystem, where Nygard was influential.
- **2017.** ThoughtWorks Technology Radar adds "Lightweight Architecture Decision Records" and moves it to **Adopt** status in the November 2017 edition. This is effectively the moment ADRs became industry-standard.
- **2018.** The UK Government Digital Service publishes the GDS Way with ADRs as the recommended architectural documentation practice for government projects.
- **Since.** AWS incorporates ADRs into the Well-Architected Framework. Azure, Google Cloud, and Microsoft all recommend ADR practice in their architectural guidance. The community site adr.github.io becomes a hub for templates and tooling.

### MADR (2017–present)

**Markdown Any Decision Records (MADR)** — originally "Markdown Architectural Decision Records" — is an open template project maintained at github.com/adr/madr (community site adr.github.io/madr).

MADR extends Nygard's template with sections that capture *rejected* alternatives more explicitly:

- **Considered Options** — the list of alternatives evaluated.
- **Decision Outcome** — what was chosen and the primary reason.
- **Consequences** — positive and negative (in v3.0, merged from separate sections).
- **Pros and Cons of the Options** — detailed comparison.

MADR's key contribution is that it treats the rejected alternatives as first-class content. Nygard's original format allowed them to be buried in "Context"; MADR pulls them into their own section because they are often the most useful part of the record. When someone six months later wants to know "did we consider X?" — they want the alternatives section.

MADR version history:

- **MADR 1.0** (2017)
- **MADR 2.x** (2018–2021) — introduced the explicit Pros/Cons structure.
- **MADR 3.0** (2022) — merged Positive Consequences / Negative Consequences into unified Consequences.
- **MADR 4.0** (September 17, 2024) — current version as of this writing.

### Why-statements (Zimmermann, 2012)

**Olaf Zimmermann** introduced *Why-statements* in his SATURN 2012 talk "Making Architectural Knowledge Sustainable: Industrial Practice Report and Outlook." The full treatment appears in his 2020 essay *Architectural Decisions — The Making Of* (ozimmer.ch/practices/2020/04/27/ArchitectureDecisionMaking.html).

A Why-statement is the compressed one-sentence form of a decision:

> *In the context of X, facing Y, we decided for Z and neglected W, to achieve Q, accepting D, because R.*

The six slots are:

- **Context** (X) — the system, scope, or concern.
- **Facing** (Y) — the specific problem, pressure, or question.
- **We decided for** (Z) — the chosen option.
- **and neglected** (W) — the main alternatives rejected.
- **to achieve** (Q) — the desired outcome.
- **accepting** (D) — the cost or tradeoff.
- **because** (R) — the deeper reason.

The genius of the format is that if you can write a coherent Why-statement, you have understood the decision. If you cannot, you do not yet understand it clearly enough to record. The scaffold places a Why-statement at the top of every full ADR for this reason.

### Research literature

A systematic mapping study of architectural knowledge management found that **decision rationale loss** is a documented, measurable phenomenon across hundreds of projects:

**Capilla, R., Jansen, A., Tang, A., Avgeriou, P., & Babar, M. A. (2016).** "A decade of software architecture knowledge management: A systematic literature review and mapping study." *Journal of Systems and Software*, 116, 191–205.

Key findings relevant to the scaffold:

- Teams that recorded decision rationale experienced significantly lower cost when re-examining decisions months or years later.
- Teams that did not record rationale exhibited "re-invention" — re-debating and sometimes reversing prior decisions without awareness they were doing so.
- The largest cost driver for architectural knowledge loss was personnel turnover — people moving on take rationale with them unless it's written down.

Earlier influential papers:

- **Kruchten, P. (2004).** "An Ontology of Architectural Design Decisions." Raised the importance of treating decisions as first-class artifacts.
- **Falessi, D., Becker, M., & Cantone, G. (2006).** "Design decision rationale: Experiences and steps ahead towards systematic use." Early empirical work on rationale capture.

The research foundation for ADR practice is solid. It is not "opinion in favor of documentation"; it is a body of empirical work about which documentation approaches actually survive contact with real teams over real time.

## Operational discipline

Four disciplines govern ADRs in this scaffold:

### Immutability

Accepted ADRs are never edited. If a decision turns out to be wrong, or circumstances change, the correct response is supersession: write a new ADR that replaces the old one, move the old one to `superseded/`, append a retrospective note pointing forward, and update the index.

This discipline is load-bearing because the alternative — editing ADRs in place — destroys the citation graph. If §0042 today could refer to something different than it did yesterday, every citation to §0042 becomes suspect. The same logic that governs legal citation (see `05 | Legal Citation Tradition.md`) applies here.

The Registrar (see `06 | Registrar Pattern.md`) enforces immutability. Agents are trusted to respect it, but the Registrar is the structural guarantor.

### Supersession, not deletion

Superseded ADRs are never deleted. They move from `1 | Canon/accepted/` to `1 | Canon/superseded/` but remain in the record. This is because:

- Citations to old decisions continue to resolve.
- The history of how thinking evolved is preserved and auditable.
- Mistakes are lessons — preserving them intact prevents the same mistake from being repeated after the original reasoning is forgotten.

### Anti-patterns are decisions too

Anti-patterns — patterns that look reasonable but fail in practice — are recorded as ADRs alongside positive decisions. There's no separate folder, no separate numbering, no parallel lifecycle. An anti-pattern surfaces in two natural ways:

- **Embedded** in an ADR's `Anti-patterns surfaced` section, when the negative-form lesson is bound to a positive decision the ADR is making.
- **Standalone** as its own §-numbered ADR, when the anti-pattern is reusable across future decisions or surfaces without a positive-decision parent. The title can lean negative-form: `§NNNN | Avoid <pattern>` or `§NNNN | <Pattern> Is an Anti-Pattern`.

Recognizing a bad pattern is valuable knowledge, and losing that knowledge is as costly as losing the knowledge of why good decisions were good. Treating anti-patterns as a polarity of decision rather than a separate category keeps the record uniform and the lifecycle simple.

### Review triggers

Every substantive ADR names a *review trigger* — the specific condition under which the decision should be reconsidered. Examples:

- "When request volume exceeds 1M/day."
- "When we move off {cloud provider}."
- "When the team exceeds 10 engineers."

Review triggers matter because conditions change even when logic doesn't. A decision that was right at 10 engineers may not be right at 100. Without an explicit trigger, ADRs ossify — they remain technically in force long after their premises have stopped holding.

Review triggers do not automate anything. They are a prompt for human judgment: "when you observe condition X, come back and see whether this still makes sense."

## Why this matters for the scaffold

- **MADR is the default template.** MADR 4.0-shaped, with Why-statement header prepended. See `../../1 | Canon/_templates/MADR Full.md`.
- **Why-statements are required for full MADRs** to force clarity and enable quick-scan reading.
- **§-numbering gives ADRs stable identity.** See `05 | Legal Citation Tradition.md`.
- **The Registrar enforces form.** See `06 | Registrar Pattern.md`.
- **The full lifecycle is defined in `../Decision Process.md`.**

## Debates and open questions

- **When is something "worth" an ADR?** Below the bar, decisions don't need records; above it, they do. The bar varies by team and project. `Decision Process.md` gives the scaffold's answer, but reasonable projects have found theirs at different points.
- **Location.** Some teams keep ADRs in the code repo (so they version with the code); others keep them in a separate wiki or documentation site. The scaffold keeps them in the project tree because that's where the work lives; agents routinely need to cite and read them.
- **Granularity.** How fine-grained should an ADR be? One decision per ADR is the received wisdom, but "one decision" is fuzzy. The scaffold's rule: one Why-statement per ADR. If you need two Why-statements, you need two ADRs.

## Further reading

- Nygard, M. (2011). "Documenting Architecture Decisions." Cognitect blog. https://www.cognitect.com/blog/2011/11/15/documenting-architecture-decisions.
- ADR community site: https://adr.github.io.
- MADR spec: https://adr.github.io/madr/.
- Zimmermann, O. (2012 / 2020). "Architectural Decisions — The Making Of." https://ozimmer.ch/practices/2020/04/27/ArchitectureDecisionMaking.html.
- Zimmermann, O. Why-statements essay. https://medium.com/olzzio/y-statements-10eb07b5a177.
- Capilla, R., Jansen, A., Tang, A., Avgeriou, P., & Babar, M. A. (2016). "A decade of software architecture knowledge management: A systematic literature review." *Journal of Systems and Software*, 116, 191–205.
- Tyree, J., & Akerman, A. (2005). "Architecture decisions: Demystifying architecture." *IEEE Software* 22(2), 19–27.
- ThoughtWorks Technology Radar entries for "Lightweight Architecture Decision Records" (multiple editions 2017–2020).

## See also

- `../Philosophy.md` — the short synthesis with the other five foundations.
- `../Decision Process.md` — the operational lifecycle.
- `05 | Legal Citation Tradition.md` — why §-numbering is the identity discipline for ADRs.
- `06 | Registrar Pattern.md` — who enforces the discipline.
