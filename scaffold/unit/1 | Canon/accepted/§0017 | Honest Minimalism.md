# §0017 | Honest minimalism

- **Status:** accepted
- **Date:** {date}
- **Agency:** {agency_name}
- **Unit:** {unit_name}
- **Authors:** scaffold initialization (inherited via §0001)
- **Supersedes:** —
- **Superseded by:** —
- **Influences:** every ADR authored in this agency (every section falls under this discipline); every inter-agent message body; every artifact rendered from a template; the MADR templates and the agent and unit-establishment templates.
- **Influenced by:** §0001, §0002, §0004, §0011

## Why-statement

In the context of **a record-keeping agency where artifacts (ADRs, inter-agent messages, planning documents) are produced from templates with multiple defined sections**,
facing the failure mode where agents fabricate content to populate sections the template offers — generating "considered alternatives" never discussed, "antipatterns" invented for the sake of having them, "out of scope" lists with no real exclusions —
we decided for **honest minimalism: every section the template defines appears in every artifact, and each section's content is either substantive or a single honest sentence (e.g., *"None considered."*, *"Not discussed."*, *"No anti-patterns surfaced."*); fabrication-to-fill is never acceptable**,
and neglected marking sections optional (omit when no substance) and treating templates as soft suggestions,
to achieve structural predictability (every artifact has the same shape; readers know exactly where to look) **and** content faithfulness (no invented material to make a section feel complete) at the same time,
accepting that authors must distinguish between "section has substance worth recording" and "section has no substance and gets a single honest sentence" — a small discipline-shift from "fill every box" to "name what's actually there",
because the same logic that requires Why-statements to be *true* (foundation 04: if you can write a coherent Why-statement, you understand the decision; if you can't, you don't) generalizes to every section of every artifact: substance, not structure-completion, is what the record is for.

## Context and problem statement

**Inherited decision.** This is a founding constitutional decision inherited from the Silcrow plugin via §0001 at scaffold time.

The MADR template (§0002) defines multiple sections: Why-statement, Context, Decision drivers, Considered options, Decision outcome, Consequences, Pros and cons of the options, Anti-patterns surfaced, Review trigger, References. The Establish Unit and Establish Agent templates have parallel section lists. Inter-agent message kinds (brief, plan, report, etc.) per Message Protocol §6 each have sub-section structures (Goal, Why, Constraints, Out of scope; Brief referenced, Approach, Sequencing, Verification, Assumptions, Open questions; etc.).

Templates exist because predictable structure helps readers — knowing exactly where the Why-statement lives, where the alternatives are, where the consequences are, makes a corpus of hundreds of ADRs scannable. That predictability is load-bearing.

But predictability and faithfulness pull against each other unless the rule is stated. In practice — observed across the scaffold's first many drafted ADRs — agents read a template, see N sections, and feel obligated to populate all N. When the actual conversation that produced the decision touched only three of those sections substantively, the other sections get filled with content the conversation didn't produce: invented alternatives, invented antipatterns, invented out-of-scope items, generic consequences. The artifact becomes longer than the decision warranted, and worse, **less honest** than the decision warranted.

This ADR resolves the tension by codifying that every section appears in every artifact (predictability holds) but each section's content is faithful to what was actually decided (no fabrication). Sections without substance get a single honest sentence. Section *headers* are non-negotiable; section *content* is bounded by what's true.

## Decision drivers

- **Predictable structure aids navigation.** A reader scanning fifty ADRs benefits from knowing every ADR has the same section list at the same depth.
- **Faithfulness preserves trust.** A fabricated "Considered options" list is dishonest — the alternatives weren't actually considered. Once the record contains fabrication, every future reader has to treat every section with suspicion.
- **Single canonical rule beats per-section discretion.** A rule like "omit sections that don't apply" requires the author to make a judgment call per section per artifact, and templates lose their predictability. A rule like "every section appears, content is honest" is one decision, applied uniformly.
- **Symmetric with the Why-statement discipline (foundation 04).** A Why-statement must be true to be present. The same logic, generalized, gives every section the same standard.

## Considered options

1. **Honest minimalism (chosen).** Every section header always present; content is substantive or a single honest sentence; fabrication-to-fill is banned.
2. **Optional sections.** Mark each non-required section as `(omit if not discussed)`. Authors decide per section per artifact whether to include it.
3. **Status quo.** Templates list sections; authors implicitly fill them all. (No explicit rule.)

## Decision outcome

**Chosen option: (1) Honest minimalism.**

Option 1 keeps the predictability win of fixed structure (a reader scanning §0042 knows exactly where the Why-statement, Considered options, and Anti-patterns surfaced sections live, even if the latter contains only *"No anti-patterns surfaced."*) and adds an explicit rule against fabrication. The author's burden is small: when a section doesn't have substance, write the single sentence and move on.

Option 2 (optional sections) loses predictability — an ADR may or may not have a Considered options section, may or may not have Antipatterns, etc. Readers can't navigate by structure if the structure varies per artifact. It also pushes a judgment call to the author for every section of every artifact, which is more cognitive overhead than a single global rule.

Option 3 (status quo) is what produced the failure mode this ADR addresses. Without an explicit rule, the gravitational pull of an N-section template is to fill all N sections, which produces fabrication when the conversation only generated content for some.

The two valid forms for any section's content under this rule:

- **Substantive content** — real material from the actual decision, as long as it needs to be.
- **Single honest sentence** — *"None."*, *"Not discussed."*, *"No alternatives were seriously considered; the choice followed from the constraint."*, *"No anti-patterns surfaced."*, *"Review trigger: none; the failure mode this addresses is not context-dependent."*

The third form — *omitting the section header entirely* — is **not** valid. Predictability requires every artifact to have the same shape.

### Consequences

- **Positive:** Every ADR has the same scannable structure; readers learn the layout once and apply it everywhere.
- **Positive:** No agent feels licensed to invent content to "complete" an artifact. The honest sentence is the explicit alternative.
- **Positive:** Authors save time on sections without substance — one sentence instead of fabricated paragraphs.
- **Positive:** Reviewers (Registrar, Lead, User) can spot drift quickly: a section with paragraphs of content that doesn't tie to the Why-statement is a candidate for being honest-minimalism in disguise (i.e., padded).
- **Negative:** Templates feel slightly more cluttered when many sections contain only single-sentence "None." stubs. The clutter is the price of structural predictability.
- **Negative:** Agents who internalize "more content = better artifact" must un-learn that pattern. The discipline-shift takes time.
- **Neutral:** This ADR governs every artifact rendered from every template — MADR Full, MADR Minimal, Establish Unit, Establish Agent, Unit Scope, Adopt Parent Unit, and inter-agent message bodies. The rule is uniform.

## Pros and cons of the options

### (1) Honest minimalism

- ✅ Predictable structure preserved.
- ✅ Fabrication explicitly banned.
- ✅ One global rule, no per-section judgment.
- ❌ Stub-heavy artifacts can feel cluttered when many sections lack substance.

### (2) Optional sections

- ✅ Artifacts without substance for a section don't carry a stub.
- ❌ Predictable structure is lost; readers can't scan by layout.
- ❌ Pushes judgment to authors per-section per-artifact.

### (3) Status quo

- ✅ No new rule to teach.
- ❌ Produces the fabrication failure mode this ADR addresses.

## Anti-patterns surfaced

- **Fabricating to fill.** Inventing a list of "considered alternatives" or "antipatterns" because the section exists, even though the conversation that produced the decision didn't surface them. This is the single failure mode this ADR exists to prevent.
- **Comprehensiveness as artifact quality.** Praising or seeking artifacts because they "fill out every section" rather than because they faithfully record the decision. Length is not a virtue; truth is.
- **Omitting section headers to look minimal.** The mirror failure: an author who grasps "don't fabricate" but over-corrects by removing section headers they consider empty. Headers are non-negotiable; content is what's bounded.

## Review trigger

Reconsider this ADR if:

- A pattern of artifacts emerges where the single-honest-sentence form is consistently ambiguous (suggests the rule needs sharper criteria for what counts as honest minimal content).
- Stub-heavy artifacts become a genuine readability problem (suggests revisiting whether predictable structure is worth the clutter).
- A new artifact kind emerges whose template cannot accommodate either substantive content or a single honest sentence in some section (suggests the template, or the rule, needs adaptation).

## References

- `../../3 | Silcrow Agency Reference/foundations/04 | Architecture Decision Records.md` — the Why-statement discipline this ADR generalizes.
- `../../3 | Silcrow Agency Reference/Decision Process.md` §7 — MADR Full vs Minimal; this ADR adds the third axis.
- `../../3 | Silcrow Agency Reference/Message Protocol.md` §4d — the operational application to inter-agent message bodies.
- `../_templates/MADR Full.md` — the template most affected; section headers are non-negotiable, content per §0017.
- `../_templates/MADR Minimal.md` — same rule, smaller section list.
- `../_templates/Establish Unit.md`, `../_templates/Establish Agent.md`, `../_templates/Unit Scope.md` — same rule.
- §0002 — the MADR-with-Why-statement template choice this ADR supplements.
- §0004 — immutability discipline; this ADR is itself immutable.
- §0011 — canon/operational split; honest minimalism applies to canonical artifacts (ADRs) primarily, with parallel application to operational ones (briefs, plans, reports).
- §0007 and §0008 are existing ADRs whose original drafts demonstrated honest minimalism by omitting empty sections; with this ADR's adoption, those omissions become single-honest-sentence stubs to satisfy structural predictability.
