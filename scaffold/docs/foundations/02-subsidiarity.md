# 02 — Subsidiarity

## What the idea is

**Decisions should be made at the lowest level capable of making them well.**

That sentence, simple as it is, has been a live idea in political and organizational thought for roughly eight centuries. It is a claim about *authority* — who should decide what — grounded in a claim about *knowledge* — that the person or body closest to a situation typically understands it best, and that organizations structured to ignore this produce worse decisions than organizations structured to honor it.

Subsidiarity is companion to two further ideas:

**Authority matches responsibility.** The person or body accountable for an outcome should have authority over the decisions that produce it. Separating authority from accountability destabilizes both — the accountable party cannot actually steer, and the authoritative party does not feel the consequences.

**Proportionality.** When a higher level *does* intervene, it intervenes only as much as necessary to restore trajectory. It does not take over.

Together, these form the operational content of subsidiarity. It is not a call for decentralization per se; it is a discipline about *where* decisions belong and *how* hierarchies should behave when they don't belong there.

## The intellectual history

Subsidiarity has roots in multiple traditions. The most documented lineage runs through Catholic social thought:

### Thomas Aquinas (13th century)

Aquinas' natural-law philosophy (*Summa Theologica*, c. 1265–1274) holds that the social order is composed of many bodies — families, guilds, cities, states — each with its own proper function, and that the health of the whole depends on each part fulfilling its function. This "common good" tradition does not use the word *subsidiarity*, but it is the philosophical ground from which the principle later grew. The key Thomistic insight is that higher authorities are not ends in themselves; they exist to help lower authorities accomplish their ends. The name later given to this relationship — *subsidium* in Latin, meaning "help" or "support" — captures the Thomistic view directly.

### Luigi Taparelli d'Azeglio (1840s)

The Italian Jesuit Luigi Taparelli d'Azeglio (1793–1862) systematized the Thomistic insight into a social-scientific principle. His major work, *Saggio teoretico di diritto naturale appoggiato sul fatto* ("A Theoretical Essay on Natural Law, Grounded in Fact"), published 1840–1843, argued that a just society is structured by a hierarchy of associations, each with its own proper autonomy, and that violations of this structure — either by higher authorities absorbing lower ones or by lower authorities refusing their proper responsibilities — produce injustice.

Taparelli was the most consequential 19th-century expositor of this idea. Pope Pius XI explicitly credited him by name in the 1929 encyclical *Divini Illius Magistri* — an unusual degree of recognition, foreshadowing the role Taparelli's framing would play in *Quadragesimo Anno*.

### Oswald von Nell-Breuning (1920s–30s)

The German Jesuit Oswald von Nell-Breuning (1890–1991) was commissioned by Pope Pius XI to help draft the 1931 encyclical that would formally name and establish subsidiarity. Nell-Breuning brought to the drafting room a sophistication about industrial economics and labor relations that Taparelli's era had not needed to grapple with. He lived long enough to see subsidiarity enter European law and often commented on it.

### *Quadragesimo Anno* (1931)

On May 15, 1931, Pope Pius XI issued *Quadragesimo Anno* ("Forty Years," marking four decades since *Rerum Novarum* — the first major papal encyclical on labor). This document contains the formal statement that coined *subsidiarity* as a named principle:

> "Just as it is gravely wrong to take from individuals what they can accomplish by their own initiative and industry and give it to the community, so also it is an injustice and at the same time a grave evil and disturbance of right order to assign to a greater and higher association what lesser and subordinate organizations can do."

The encyclical frames the principle in terms of both *justice* (it is wrong to absorb lower authorities) and *right order* (it produces bad outcomes when you do).

### Post-1931 development

Subsidiarity moved rapidly from theological into political and legal contexts through the 20th century:

- **Federal systems.** The US, Germany, Switzerland, and Canada all incorporate subsidiarity-shaped reasoning into their federal structure, even where the word is not used. Germany's Basic Law (*Grundgesetz*, 1949) uses subsidiarity language explicitly.
- **European Union.** Subsidiarity became central to EU law with the Maastricht Treaty (1992) and was strengthened in the Treaty of Lisbon (2007). Article 5(3) of the consolidated Treaty on European Union states: "Under the principle of subsidiarity, in areas which do not fall within its exclusive competence, the Union shall act only if and in so far as the objectives of the proposed action cannot be sufficiently achieved by the Member States, either at central level or at regional and local level." Article 5(4) adds the proportionality requirement.
- **Monitoring.** The Treaty of Lisbon added formal control mechanisms: national parliaments may object when legislation is drafted, may dismiss legislative proposals on subsidiarity grounds, and may contest legislative acts before the Court of Justice.

### Secular developments

Outside the Catholic and EU traditions, the same principle appears under different names:

- **Althusius** (Johannes Althusius, 1557–1638, *Politica Methodice Digesta*). German Calvinist political philosophy contributed an early federalist theory of nested associations remarkably similar to Taparelli's. Althusius is sometimes read as a parallel root for the principle.
- **Local knowledge problem** (Friedrich Hayek, 1945, "The Use of Knowledge in Society," *American Economic Review*). Hayek's argument for decentralization in economic coordination is subsidiarity by another name: decisions belong where the relevant knowledge is, which is typically local.
- **End-to-end principle** (Saltzer, Reed, Clark, 1984, "End-to-End Arguments in System Design"). In network design, functionality belongs at the endpoints, not in the middle of the network. Same pattern of reasoning: place authority at the level that has the context.

That so many independent intellectual traditions arrive at structurally similar principles is itself a datum: something real is being tracked.

## Operational content

Subsidiarity is not just "push decisions down." It contains several distinct operational commitments:

**The presumption is toward local.** When it is unclear whether a decision belongs at level A or level B (with A below B), the presumption is A unless there is positive reason to escalate. The burden is on the escalation, not on the local decision.

**Intervention is corrective, not routine.** When the higher level *does* intervene, it intervenes proportionately and temporarily. It does not take over. Its job is to *restore* the lower level's ability to do its work — hence *subsidium*, support — not to substitute for it.

**Competence is a prerequisite, not a veto.** Subsidiarity says "lowest level capable of deciding well." That "capable" is real: if the lower level lacks information, judgment, or scope, it is not actually capable, and escalation is correct. The discipline of subsidiarity is about *not using the pretext of higher competence to bypass local authority that is genuinely capable*.

**Authority and responsibility travel together.** If the lower level is held responsible for outcomes, it must have authority to shape them. This is sometimes called the **principle of authority** in the industrial literature; subsidiarity without matched authority is pseudo-subsidiarity, and produces blame-shifting instead of good decisions.

## Why this matters for the scaffold

The scaffold's reporting structure is explicit: {user_role} → {lead_role} → {implementer_role}. Subsidiarity governs how decisions flow between these tiers:

- **The {implementer_role} makes implementation decisions.** Unless the {lead_role} has positive reason to override (architectural concern, cross-cutting implication), implementation decisions stay at tier 2.
- **The {lead_role} makes architectural decisions.** Unless {user_role} has positive reason to override (strategic concern, scope-changing implication), architecture stays at tier 1.
- **Escalation is corrective, not routine.** The {lead_role} intervenes in the {implementer_role}'s work when something architectural is at stake. They do not review every decision as a matter of course.
- **The {lead_role} writes briefs, not specs.** This is subsidiarity in operational form: the {lead_role} communicates *what* and *why*, leaving *how* to the {implementer_role} because that is where the relevant judgment and context lives.

The **one-stratum rule** from Jaques (see `01-stratified-cognition.md`) provides the measurement for "capable of deciding." You are a stratum above, so you can scaffold; you are not the stratum below, so you are not doing their work. Subsidiarity without stratification degrades into arbitrary assertions about who is "closest to the problem." Stratification gives subsidiarity an operational footing.

## Common failure modes

**Upward delegation.** A lower tier punts decisions up to avoid risk or responsibility. This inverts subsidiarity and floods the higher tier with work that is not theirs. It defeats Jaques' stratification. Watchwords: "I want to check with you on this before I...," where the checking-in is routine rather than exceptional.

**Absorptive overreach.** A higher tier takes over decisions the lower tier should make, typically because the higher tier finds the decision interesting or the lower tier's choice inconvenient. This is the failure *Quadragesimo Anno* explicitly named. Watchwords: "I'll just decide this directly to save time," where "save time" is the rationalization for bypassing the proper level.

**Pseudo-subsidiarity.** Responsibility is pushed down but authority is not. The lower level is told they own the outcome but has their decisions overridden when they come up. This is arguably worse than absorptive overreach, because it preserves the appearance of subsidiarity while destroying its substance.

**Competence-washing.** A higher tier claims to be "more competent" to justify absorbing decisions. Sometimes this is true; often it is a pretext. The discipline is: unless the higher tier's competence is *actually required* for this decision, let the lower tier decide even if they'd decide differently.

## Debates and open questions

- **Does subsidiarity limit itself too much?** Some scholars argue that subsidiarity's default-toward-local bias is too strong — that coordination problems require more upward authority than the principle would grant. (See *The Insufficiency of Subsidiarity*, Providence Magazine, for a representative critique.)
- **How to measure "capable of deciding well"?** The principle's operational content depends on an assessment of capability at each level. Jaques' stratification gives one framework; Hayek's local-knowledge framing gives another; EU law uses procedural tests.
- **Subsidiarity vs. efficiency.** Lower-level decisions are sometimes less efficient than higher-level ones (duplicated work, inconsistent choices across units). The principle's answer: apparent inefficiency is often local optimization whose value is not visible from above.

## Further reading

- Pius XI, *Quadragesimo Anno* (1931). Available at vatican.va.
- Article 5 TEU, via EUR-Lex: https://eur-lex.europa.eu/eli/treaty/teu_2016/art_5/oj.
- Taparelli, L. *Saggio teoretico di diritto naturale* (1840–1843). Now hard to find outside academic libraries; the Villanova Law Digital Commons paper on "Subsidiarity in the Tradition of Catholic Social Doctrine" is a strong secondary source.
- Hayek, F. (1945). "The Use of Knowledge in Society." *American Economic Review* 35(4).
- The Stanford Encyclopedia of Philosophy entry on "Federalism" includes a careful treatment of subsidiarity.
- European Parliament Fact Sheet on the principle of subsidiarity: europarl.europa.eu/factsheets/en/sheet/7.

## See also

- `../philosophy.md` — the short synthesis with the other five foundations.
- `01-stratified-cognition.md` — the stratification that gives subsidiarity its operational footing.
- `06-registrar-pattern.md` — the Registrar sits outside the subsidiarity hierarchy because their authority is procedural, not substantive.
