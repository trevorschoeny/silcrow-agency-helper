# Why this scaffold works the way it does

This document is the scaffold's constitutional text. It explains *why* the structure is what it is — not as decoration but as a working reference. When agents encounter an edge case the procedural docs don't cover, this document is what they read to reason from principles.

The scaffold is engineered for long-horizon use. Its conventions must survive years of agents turning over, contexts changing, and enforcement pressure fluctuating. Conventions survive when the people living inside them understand why they exist. They collapse when the reasoning is lost. That is why this document is required reading, not optional background.

The seven foundations below are distinct intellectual lineages, each with independent empirical or historical validation. We draw on all seven because each one answers a question the others don't — and because, as the closing section shows, they interlock into a coherent whole.

---

## The problem this scaffold solves

Hierarchical multi-agent agencies drift without discipline. Decisions accumulate but rationale evaporates. Roles are ambiguous, so the same work gets done twice or not at all. Agents turn over and take context with them. The record of *why* things are the way they are — which is the only record that survives contact with circumstances the original decision-makers didn't anticipate — becomes irrecoverable.

Retrofitting discipline onto an already-drifted system is expensive and often impossible. This scaffold imposes discipline from day one because day-one cost is dramatically lower than day-three-hundred cost. The seven foundations below are not additive embellishments; they are the minimum coherent structure that addresses the drift.

---

## Seven foundations

### 1. Stratified Systems Theory

**Core claim.** Organizational levels are not arbitrary. They correspond to measurable differences in cognitive work — specifically, in the time horizon of the longest task the role is responsible for. Each tier represents a qualitatively different kind of work, not just a higher authority level over the same kind of work.

Elliott Jaques, a Canadian psychoanalyst and organizational theorist, developed this theory over roughly sixty years of empirical research — most notably through the "Glacier Project," a long-running engagement with the Glacier Metal Company in the 1950s and beyond, documented in *Glacier Project Papers* (Brown & Jaques, 1965) and developed in *A General Theory of Bureaucracy* (Jaques, 1976) and *Requisite Organization* (Jaques, 1996, 2nd ed., Cason Hall). He found, across many organizations and many decades, that effective structures stratify into distinct modes of cognitive work, and that the work at different strata is — in his memorable phrase — "as different in nature as water is different from steam."

Jaques identified eight strata, each with a characteristic time horizon: Stratum I (1 day to 3 months, frontline work), Stratum II (3 months to 1 year, direct supervision), Stratum III (1 to 2 years, functional management), Stratum IV (2 to 5 years, multi-function executive work), and upward through Stratum VIII (50+ years, civilization-shaping work). Crucially, the strata are not ranks; they are modes of work. A Stratum I worker's relationship to their task mirrors a Stratum V executive's relationship to their business unit — same pattern of cognition, different horizon and scope. Jaques called this fractal property the *quintave* (see *Requisite Organization*, 1996).

Two operational rules come out of Jaques' research:

**The one-stratum rule.** Each boss should sit exactly one stratum above their reports. More creates micromanagement (the boss is doing the same kind of work). Less creates burnout (the boss can't provide the cognitive scaffolding the report needs). The scaffold places {lead_role} exactly one tier above {implementer_role} (per §0006, extended by §0013 for agencies with sub-units: tier numbers are local per unit — every Lead is tier-1-of-their-unit, every Implementer is tier-2-of-their-unit, regardless of where their unit sits in the tree).

**Capacity matches stratum.** An agent is fit for a role not by general "smarts" but by whether their cognitive capacity matches the time horizon of the work. This is the correct framing when evaluating whether an agent should stay in role, be promoted, or hand work off.

**What this means for the scaffold.** The tiering is the minimum viable stratification: {user_role} as principal (§0013 — not a tier but the principal above the lattice), {lead_role} at tier 1 of their unit, {implementer_role} at tier 2 of their unit, with the Registrar outside the hierarchy (because their work is not stratified in Jaques' sense — it is categorically different). When the scaffold grows, new tiers should be added between existing ones *only when the work genuinely spans more than one stratum*.

**Where to read more.** Jaques, *Requisite Organization* (2nd ed., 1996). Jaques, *A General Theory of Bureaucracy* (1976). For a shorter entry point: Jaques, "In Praise of Hierarchy," *Harvard Business Review* (January–February 1990). And `#ORG/docs/foundations/01-stratified-cognition.md`.

---

### 2. Subsidiarity

**Core claim.** Decisions should be made at the lowest level capable of making them well. Higher levels intervene only when the lower level cannot resolve the issue, and intervention should be proportionate to need.

Subsidiarity has deep and well-documented roots. Its philosophical basis goes back to Thomas Aquinas's natural law tradition (*Summa Theologica*, 13th century), which holds that the health of a social order depends on each part fulfilling its proper function. In the 1840s, the Jesuit theologian Luigi Taparelli d'Azeglio (*Saggio teoretico di diritto naturale*, 1840–1843) formalized the idea into a social-scientific principle. It was named and articulated as *subsidiarity* by Pope Pius XI in the encyclical *Quadragesimo Anno* (May 15, 1931), with significant influence from the German theologian Oswald von Nell-Breuning. Pius XI wrote that "it is an injustice and at the same time a grave evil and disturbance of right order to assign to a greater and higher association what lesser and subordinate organizations can do."

In the 20th century, subsidiarity moved from theological and philosophical contexts into law. It is now central to European Union law: Article 5(3) of the Treaty on European Union (consolidated in the Treaty of Lisbon, 2007) establishes that "in areas which do not fall within its exclusive competence, the Union shall act only if and in so far as the objectives of the proposed action cannot be sufficiently achieved by the Member States."

Two companion ideas travel with subsidiarity:

**Authority matches responsibility.** The person or body accountable for an outcome should have the authority over the decisions that produce it. Splitting authority from accountability destabilizes both.

**Proportionality.** Article 5(4) of the TEU states that "the content and form of Union action shall not exceed what is necessary to achieve the objectives of the Treaties." Intervention from above goes no further than necessary. Higher tiers do not take over; they provide the minimum correction needed to restore trajectory.

**What this means for the scaffold.** The {implementer_role} makes implementation decisions. The {lead_role} does not override unless the implementation crosses into architectural territory. The {lead_role} makes architectural decisions. {user_role} does not override unless architecture crosses into strategic territory. When unsure whether a decision belongs to a higher tier, the default is to let the lower tier decide and observe the result. The Registrar sits outside this hierarchy because their authority is over *form*, not *substantive decisions*. In agencies with multiple units (§0015), subsidiarity scales along the tree: decisions made at deeper units stay there unless they cross into a broader scope, and decisions made at higher units (especially the root) propagate down to bind their sub-units. A unit's Lead doesn't intervene in a sub-unit's implementation; a sub-unit's Lead doesn't author decisions that bind peers or ancestors.

**Where to read more.** *Quadragesimo Anno* (1931), available at vatican.va. Article 5 TEU, via EUR-Lex. The Stanford Encyclopedia of Philosophy entry on subsidiarity is a strong secondary source. `#ORG/docs/foundations/02-subsidiarity.md`.

---

### 3. The actor model

**Core claim.** Complex systems become robust when composed of independent entities with private state, communicating only through messages, and interacting with shared state only through committed mutations.

The actor model was introduced in Hewitt, Bishop, and Steiger's paper "A Universal Modular ACTOR Formalism for Artificial Intelligence," presented at IJCAI-73 in Stanford on August 20–23, 1973. The formalism was refined by Gul Agha in *Actors: A Model of Concurrent Computation in Distributed Systems* (MIT Press, 1986). Its most influential practical implementation is Erlang, developed at Ericsson starting in the late 1980s, and documented most thoroughly in Joe Armstrong's PhD thesis *Making Reliable Distributed Systems in the Presence of Software Errors* (KTH, 2003).

An actor has three properties: a **private mailbox**, **private state**, and the ability to **send messages** to other actors. Actors do not share memory. All coordination between them is via messages. Three consequences matter for this scaffold:

**Private state enables honest thinking.** An actor reasoning in its own address space does not have to defend half-formed thoughts. It iterates privately, then sends a finished message. This is the discipline the scaffold imposes by giving each agent a private directory (`#ORG/agents/<role>@<unit-name>/`) that no other agent reads. Drafts, failures, and exploratory thinking live there, never forced into a shared artifact prematurely.

**Messages create auditable history.** Every interaction is a discrete, persistent artifact. Over time, the archive of messages is a complete record of how the system coordinated. Debugging reduces to replaying messages — you can reconstruct, from the archive alone, why a given state exists. The scaffold applies this directly: messages deposited in an agent's inbox, archived on read, never deleted.

**Supervision trees handle failure.** In Erlang, a supervisor actor watches its children and restarts them when they fail. Armstrong's famous "let it crash" principle holds that processes should fail fast and honestly rather than muddle through a bad state, trusting the supervisor to recover. In the scaffold, supervision is lighter-touch but the same shape: the {lead_role} watches the {implementer_role} for signals of stuck or struggling work and responds with scaffolding rather than takeover.

**What this means for the scaffold.** Each agent has a private directory. The only shared mutable state is the committed record — the ADR tree — and mutations to it are mediated by the Registrar. Messages are first-class artifacts. Out-of-band communication is a discipline violation because it defeats auditability.

**Where to read more.** Hewitt, Bishop, Steiger (1973). Agha (1986). Armstrong (2003) is available at erlang.org/download/armstrong_thesis_2003.pdf. `#ORG/docs/foundations/03-actor-model.md`.

---

### 4. Architecture Decision Records

**Core claim.** Significant decisions should be recorded as immutable, context-rich documents — capturing not just *what* was decided, but *why*, *what alternatives were considered*, and *what was rejected and why*.

The format was popularized by Michael Nygard in "Documenting Architecture Decisions," a Cognitect blog post dated November 15, 2011. Nygard's template is deliberately short: **Title, Status, Context, Decision, Consequences** — five sections, each a paragraph or two. The insight behind the template is that the heavyweight architecture documents that teams are supposed to keep current mostly don't get kept current; small, focused records about individual decisions actually do.

The format spread quickly. ThoughtWorks Technology Radar moved "Lightweight Architecture Decision Records" to "Adopt" status in the November 2017 edition (updated across several radars since). Major organizations adopted the practice, including AWS (incorporated into the Well-Architected Framework), the UK Government Digital Service (GDS Way), and Microsoft's Azure architecture guidance. The template has been extended by several authors:

**MADR (Markdown Any Decision Records)**, an open template project (adr.github.io/madr), adds explicit `Considered Options` and `Pros and Cons` sections — the fields most critical for capturing *rejected* alternatives. MADR 4.0 was released September 17, 2024. The scaffold's default template is MADR-shaped.

**Y-statements** were introduced by Olaf Zimmermann at SATURN 2012 ("Making Architectural Knowledge Sustainable") and formalized in a 2020 essay at ozimmer.ch. A Y-statement is a compressed one-sentence form of a decision: *"In the context of X, facing Y, we decided for Z and neglected W, to achieve Q, accepting D, because R."* The scaffold places a Y-statement at the top of every full ADR for quick-scan readability.

**Immutability** is the load-bearing discipline. Accepted decisions are never edited. They are *superseded* by new decisions that preserve the old ones as history. A retrospective note may be appended to a superseded ADR, but the original body is never rewritten.

The research literature describes the cost of not doing this as "decision rationale loss" — see Capilla, Jansen, Tang, Avgeriou, and Babar's systematic mapping study ("A decade of software architecture knowledge management: A systematic literature review," *Journal of Systems and Software* 116, 2016).

**What this means for the scaffold.** ADRs are the decision log. MADR is the default template, with a Y-statement header added. §-numbering gives them stable identifiers. Immutability is enforced by the Registrar. Supersession replaces editing. Anti-patterns are first-class records because avoiding a bad decision is as valuable as making a good one.

**Where to read more.** Nygard (2011): https://www.cognitect.com/blog/2011/11/15/documenting-architecture-decisions. The ADR community site: https://adr.github.io. MADR: https://adr.github.io/madr/. Zimmermann on Y-statements: https://ozimmer.ch/practices/2020/04/27/ArchitectureDecisionMaking.html. `#ORG/docs/foundations/04-architecture-decision-records.md`.

---

### 5. Legal citation tradition (§)

**Core claim.** Sequential, monotonic, never-reused identifiers enable stable cross-reference across time and across documents.

The section sign (§) — also called the silcrow — takes its shape from a medieval scribal ligature of two S's, derived from the Latin *signum sectionis*, meaning "sign of the section." Its form stabilized over centuries of legal writing, and by the modern era it was standard in legal citation. In American legal citation following *The Bluebook: A Uniform System of Citation* (published by the Harvard Law Review Association, currently in its 21st edition), "42 U.S.C. § 1983" refers precisely and unambiguously to a specific section of a specific code. The doubled form (§§) refers to multiple sections.

Three properties of legal section numbering are load-bearing:

**Sequential.** Numbers are assigned in order, not by topic or category.

**Monotonic.** Numbers go up, not down. New sections are added at the end, not inserted into the middle.

**Never reused.** Even if a law is repealed, its section number is not reassigned to something new. The original reference continues to resolve — either to the original text or to a record of its repeal.

These three properties together mean that if you cite § 1983 today, and someone reads your citation in fifty years, they can find exactly what you were referring to.

The same logic applies to a decision log. Decisions reference each other. A decision citing §0014 commits to a particular reading of §0014. If §0014 could be edited, the citing decision is suddenly ambiguous. The only way to keep the record citable is to enforce the same discipline legal citation has enforced for centuries — sequential, monotonic, never-reused.

**What this means for the scaffold.** Every accepted ADR gets a §-number assigned by the Registrar. Numbers are monotonic and never reused, even for rejected proposals. Filenames embed the §-number and never change after assignment. Status changes move files between folders, but the filename — the identifier — is permanent.

**Where to read more.** *The Bluebook: A Uniform System of Citation* (21st ed., Harvard Law Review Association, 2020). Matthew Butterick, *Typography for Lawyers* (O'Connor's, 2018), entry on "Paragraph and section marks." `#ORG/docs/foundations/05-legal-citation-tradition.md`.

---

### 6. The registrar pattern

**Core claim.** Record integrity requires a role whose authority is procedural, not substantive. Conflating the two corrupts both.

Real-world registrars exist in universities, courts, corporations, and civil administration. Their work is remarkably similar across these contexts: they *ratify* the record. The university registrar certifies that a thesis was properly submitted, signed, filed, and indexed — but does not evaluate whether the thesis is any good (that is the committee's job). The court registrar ensures motions are properly filed, that dockets are accurate, that judgments are formally entered — but does not rule on motions (that is the judge's job). The corporate registrar maintains the register of shareholders and certifies shareholder records — but does not set corporate strategy (that is the board's job). See AACRAO's professional materials on the university registrar role.

The separation between form and substance is load-bearing. When form and substance are combined in one role, one of two failure modes follows:

**Form slips because substance is more urgent.** When the registrar is also a decision-maker, they prioritize the urgent substantive calls over the "paperwork" of form. Over time, the record's integrity degrades in proportion to how busy the decision-makers are.

**Substance becomes procedural because the role's bias is toward form.** When the decision-maker is also the registrar, they develop the registrar's caution around form; decisions begin to be shaped by what fits the filing convention rather than what answers the question.

Either way, separation fails. Independent, dedicated registrars — with procedural authority only — avoid both failure modes.

The pattern scales by **fan-out, not strata**. As records proliferate, you add more registrars handling partitioned scopes — not a hierarchy of registrars making substantive calls. In agencies with multiple units (§0015), every unit — root and sub-units alike — has its own Registrar auditing its own unit's record. No "Chief Registrar" adjudicates across units; they federate.

**Sync gate vs async auditor.** This scaffold's Registrar operates as an **async auditor** (§0012) — not gatekeeping every ADR before it lands in `accepted/` but auditing the record on demand, correcting procedural issues directly, and surfacing substantive ones for the Lead or User. The form/substance separation is preserved by role design, not by serial validation. Historical real-world registrars operate the same way — court clerks file documents as they arrive and audit the docket periodically; university registrars process registrations in real-time and audit enrollment records on a cadence.

**What this means for the scaffold.** The Registrar is a starter agent even though their initial workload is light. They establish from day one the discipline that nothing enters the record without registration. Their authority is strictly procedural: filename format, §-number assignment, reference integrity, status-folder placement, index updates, audit execution. When they encounter substantive issues they surface them upward — they do not silently fix substance.

**Where to read more.** AACRAO professional materials (aacrao.org). *Judiciaries Worldwide*, Federal Judicial Center (judiciariesworldwide.fjc.gov). *Robert's Rules of Order*, 12th edition (2020). `#ORG/docs/foundations/06-registrar-pattern.md`.

---

### 7. The canonical/operational split

**Core claim.** Useful organizations produce two kinds of artifacts, and the constraint between them flows one direction only. Canonical artifacts — the rules that bind — are stable, citable, and immutable except by supersession. Operational artifacts — the work that happens under those rules — are mutable, working, and evolving. The canonical binds the operational; the operational never binds the canonical.

The pattern has been independently discovered across multiple traditions:

- **Constitutional economics — Buchanan** (Nobel 1986). *"Rules of the game"* (constitutional) vs *"plays of the game"* (operational). *The Calculus of Consent* (Buchanan & Tullock, 1962) argues constitutional choices need stricter decision rules *because* they bind subsequent operational choices.
- **Legal philosophy — Hart.** *Primary rules* (of conduct) vs *secondary rules* (about rules — how they're made, changed, adjudicated). Secondary rules are more stable; primary rules operate under them. *The Concept of Law* (1961).
- **Piecemeal engineering — Popper.** Institutions should be *"stable enough to be predictable but open to piecemeal revision."* *The Open Society and Its Enemies* (1945).
- **Polycentric governance — Ostrom.** Design Principle #7 assumes an external legal framework under which local self-governance operates. *Governing the Commons* (1990).
- **ADRs — Nygard.** Architectural decisions (canonical) vs implementation (operational). The scaffold's direct ancestor.
- **Agile.** Product vision (canon) vs sprint plans (ops).

That the same structural answer emerges from constitutional economics, legal philosophy, mid-century liberal political thought, polycentric commons research, and 21st-century software is evidence the pattern is load-bearing.

**Three rules.** §0014 codifies the pattern in three explicit rules:

- **Direction-of-Constraint Principle.** Canonical binds operational; never the reverse.
- **Promotion Rule.** An operational choice is promoted to canonical when it needs to constrain future work beyond the current execution.
- **Reference Rule.** ADRs may reference operational artifacts only via safe references (orienting pointer, provenance citation, compliance pointer) — references that survive the delete test and contradiction test.

**What this means for the scaffold.** ADRs are canonical; plans, briefs, implementations, research, schedules, codebases are operational. The `#ORG/` structural marker (§0015) physically separates them at the filesystem level: everything inside `#ORG/` is governance; everything outside is operational. The Registrar audits for unsafe references as part of its checklist (§0012). Authors apply the promotion rule when they notice an operational choice has quietly become binding.

**Where to read more.** Buchanan & Tullock (1962). Hart (1961). Popper (1945). Ostrom (1990). Nygard (2011). `#ORG/docs/foundations/07-canonical-and-operational.md`.

---

## How they interlock

The seven foundations are not a buffet of independently applicable practices. They are engineered as a coherent whole, each holding the others in place.

**Immutability works only because the Registrar enforces form.** Without a role whose job it is to police the record's integrity, immutability slips under pressure. Someone edits an accepted ADR "just this once" — the discipline is gone.

**The actor model works only because the record provides shared truth.** Without a canonical ledger, the private state of individual actors would fragment into irreconcilable local views. The ADR tree (and the agents' archived inboxes) is the shared ground truth that makes private thinking safe.

**Stratified cognition works only because subsidiarity prevents upward delegation.** Without subsidiarity, lower tiers punt decisions up to avoid risk, and the higher tier's time gets consumed by work that isn't theirs — defeating the stratification.

**Subsidiarity works only because stratified cognition defines what "capable of deciding" means.** Without strata, "lowest competent level" is unmeasurable and collapses to whoever asserts authority loudest. Time horizon gives *competence* an observable referent.

**ADRs work only because §-numbering gives them stable identity.** Without stable identifiers, citation graphs rot. §0042 today has to be §0042 in five years, or every citation to it becomes suspect.

**The Registrar works only because their authority is procedural.** A Registrar with substantive authority becomes either a bottleneck or a power center. Either way, the scaffold's separation of concerns erodes.

**The canon/operational split works only because the Registrar and §-numbering are already present.** The canonical category needs a role maintaining it (Registrar) and stable identifiers (§-numbers); without both, "canonical" is a label without teeth. Equally: the Registrar and §-numbering would be paper without the canon/operational split to scope them to the right artifacts.

Remove any one thread and the structure loosens. Remove two and it collapses. The scaffold is a coherent system, not a menu.

---

## Convergence across domains

The seven foundations compiled here come from radically different fields:

- **Stratified Systems Theory** — industrial psychology and organizational theory (Jaques).
- **Subsidiarity** — Catholic moral theology and European political philosophy (Aquinas, Taparelli, Nell-Breuning, Pius XI, Lisbon Treaty).
- **Actor model** — computer science and telecom engineering (Hewitt, Agha, Armstrong).
- **ADRs** — software architecture (Nygard, Zimmermann, MADR community).
- **§-numbering** — Roman legal tradition through modern legal citation (Bluebook).
- **Registrar pattern** — civil administration, university governance, court administration.
- **Canon/operational split** — constitutional economics, legal philosophy, piecemeal engineering, polycentric governance, ADR practice, Agile.

These fields did not converge through mutual influence. They converged because they are, each in their own terms, solving the same deeper problem: *how do groups of cognitive agents make durable decisions across time in a way that preserves reasoning, respects locality, and survives turnover?*

That the same structural answers emerge from different starting points — across industries, centuries, and disciplines — is evidence the principles are tracking something real about how cognition aggregates into organizations. The scaffold is not inventing; it is *recognizing*.

This framing matters for two reasons. First, it means the conventions of this scaffold are older and more deeply tested than any individual agency. If you find yourself tempted to abandon a convention under pressure, you are not just relaxing a local preference — you are stepping outside a pattern that has survived centuries of independent validation in multiple domains. The bar for that should be high.

Second, it means the conventions are *reusable*. If you understand why §-numbering works, you understand why event sourcing works, why git commit history works, why statutory citation works. You have a unified lens for an entire class of problems. The scaffold is teaching a way of seeing, not just a set of procedures.

---

## For those who want to go deeper

Each of the seven threads has its own full treatment in `foundations/`:

- [01 — Stratified cognition](foundations/01-stratified-cognition.md)
- [02 — Subsidiarity](foundations/02-subsidiarity.md)
- [03 — Actor model](foundations/03-actor-model.md)
- [04 — Architecture Decision Records](foundations/04-architecture-decision-records.md)
- [05 — Legal citation tradition](foundations/05-legal-citation-tradition.md)
- [06 — Registrar pattern](foundations/06-registrar-pattern.md)
- [07 — Canonical and operational artifacts](foundations/07-canonical-and-operational.md)

These are not decorative. They are the reference material for agents who hit edge cases and want to reason from principles. They are teaching you to recognize the patterns in unfamiliar form, so you can adapt and defend the scaffold in situations this document didn't anticipate.

The procedural docs — `decision-process.md`, `message-protocol.md`, and each agent's `AGENTS.md` — tell you *what to do*. The foundations teach you *why it works*. You need both. In a pinch, you can follow the procedures on faith; over time, you will need to understand the principles to adapt them.
