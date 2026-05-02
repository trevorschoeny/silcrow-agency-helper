# 07 — Canonical and operational artifacts

## What the idea is

**Useful organizations produce two kinds of artifacts, and the constraint between them flows one direction only.** Canonical artifacts — the rules that bind — are stable, citable, and immutable except by supersession. Operational artifacts — the work that happens under those rules — are mutable, working, and evolving. The canonical binds the operational; the operational never binds the canonical. That one-way constraint is what lets the canonical stay stable and the operational stay free to iterate.

This scaffold takes the distinction directly: ADRs are canonical; plans, briefs, implementations, research reports, schedules, codebases, and all other working material are operational. The distinction is recorded explicitly in §0013.

## Where the pattern appears

### Constitutional economics — Buchanan

James M. Buchanan (Nobel Prize in Economic Sciences, 1986) distinguished between the *"rules of the game"* and the *"plays of the game"*. Constitutional choices — what the rules are, how they can be changed, who can change them — are made rarely and under stricter decision procedures (supermajority, consensus, ratification). Operational choices — what to do within the rules — are made routinely under looser procedures.

Buchanan and Gordon Tullock worked this out in *The Calculus of Consent* (1962). Their core argument: constitutional choices need stricter decision rules *because* they bind all subsequent operational choices. A choice made under permissive rules and treated as binding on everyone thereafter is democratically suspect. A choice made under strict rules with full deliberation, then treated as binding, is democratically defensible.

The connection to ADRs is direct. ADRs are the "rules of the game" for the agency; plans and implementations are the "plays." ADRs need a stricter process (immutability, supersession, formal template); plans iterate freely.

### Legal philosophy — Hart

H. L. A. Hart, *The Concept of Law* (1961), introduced the distinction between *primary rules* and *secondary rules*.

- **Primary rules** — rules of conduct. "Don't steal." "Pay your taxes." "Stop at red lights." What people are required, permitted, or forbidden to do.
- **Secondary rules** — rules about rules. How new rules are made, how existing rules are changed, how disputes about the rules are adjudicated. Constitutions, amendment procedures, rules of recognition.

Hart's observation: a system with only primary rules is a "pre-legal" society — rules exist, but there's no mechanism for changing them, recognizing which are valid, or adjudicating disputes. Secondary rules are what make a rule system a legal system.

In the scaffold, the canon/operational split maps loosely onto Hart's distinction. ADRs define how ADRs are made (§0002 — the MADR template), how they're changed (§0004 — immutability and supersession), how they're recognized (§0003 — §-numbering). These are secondary rules in Hart's sense — rules about rules — and they sit in the same canonical layer as primary governance rules. Operational artifacts don't have their own meta-rules in the same way; they operate under the canon's secondary rules.

### Piecemeal engineering — Popper

Karl Popper, *The Open Society and Its Enemies* (1945), argued against utopian social engineering (large-scale blueprint-based reconstruction of society) and for *piecemeal engineering* — small, incremental, reversible improvements tested against observed outcomes.

For Popper, institutions should be **stable enough to be predictable** (so people can plan) but **open to piecemeal revision** (so they can improve). A perfectly stable institution is as bad as a perfectly unstable one. The useful shape is *stable frame, evolving content*.

The canon/operational split is a direct expression. Canon is the stable frame — the rules don't change daily, the ADRs are immutable except by deliberate supersession. Operational work is where piecemeal iteration happens — plans are revised, implementations are refactored, schedules shift, research changes direction based on findings. The frame lets the content iterate without chaos; the content lets the frame stay useful without freezing.

### Polycentric governance — Ostrom

Elinor Ostrom's *Governing the Commons* (1990) and later work on polycentric governance identified the design principles that successful long-lived institutions share. Her Design Principle #7 — *Recognition of rights to organize* — assumes that a local self-governing group operates **under an external legal framework**. The canon is outside the operational group; ops live inside it.

This is important because the canon doesn't have to come from within the operational group. For the scaffold, the plugin's shipped ADRs (§0001–§0018) are "external canon" — decisions inherited from outside the agency at scaffold time. The agency then makes its own ADRs (internal canon) that layer on top. Both kinds are canonical; both bind operational work; both operate under the same discipline.

Ostrom's broader point is that well-designed institutions have multiple centers of authority at different scales. The agency/unit structure in the scaffold (§0014) directly expresses this: the agency has canon; each unit has its own canon that further narrows within agency canon (but cannot contradict it). Polycentric, canon-leading-canon, with operational work at every level.

### Architecture decision records — Nygard

Michael Nygard's 2011 blog post "Documenting Architecture Decisions" (Cognitect blog) is the scaffold's direct ancestor. Nygard's core argument: architectural decisions deserve their own first-class record, separate from implementation code, requirements documents, or design documents. The ADR captures the decision — what was chosen, why, and what alternatives were rejected — as a stable, citable artifact.

Nygard explicitly distinguishes architectural decisions from implementation. Implementation is operational; it iterates based on what works. Architecture is canonical; it's the constraint implementation operates under. If you change architecture, you do it deliberately — a new ADR supersedes the old one — not silently through drift.

The canon/operational split takes Nygard's distinction and generalizes it. Nygard was thinking about software; the same distinction applies to any organized work. A wedding planner has canonical decisions (who's in the wedding party, what the theme is, what we're not doing) and operational work (the day-of schedule, the vendor list, the seating chart). A research lab has canonical decisions (what the hypothesis space is, what methods are allowed) and operational work (specific experiments, data collection, writeups). The vocabulary is the same; only the domain differs.

### Agile — product vision vs sprint plans

Agile's distinction between *product vision* (canonical) and *sprint plans* (operational) is a familiar expression of the same pattern. The product vision is meant to be stable over quarters or years; sprint plans iterate every two weeks. Vision binds sprints; sprints never change vision. (A sprint can surface evidence that the vision needs to change, but that triggers a deliberate re-visioning, not a silent drift.)

Agile's practitioners rarely use the words "canonical" and "operational," but the structure is identical. The scaffold's framing is a cleanup of Agile's vocabulary rather than a new pattern.

## Why the distinction is load-bearing

The canon/operational split is not a decorative taxonomy. It does three load-bearing things:

### 1. It keeps the record stable

Without the split, ADRs drift. Authors start referencing operational artifacts as if they were canon ("we will X according to `plans/foo.md`"), and the ADR's meaning becomes dependent on the plan's current state. When the plan changes, the ADR silently changes too — not by supersession but by back-reference. The immutability discipline (§0004) is defeated without anyone noticing.

The reference rule in §0013 directly protects against this. The delete test and contradiction test catch unsafe references before they're committed. Authors who internalize the rule learn to embed decision content inside the ADR and use external references only for orientation, provenance, or compliance measurement.

### 2. It keeps operational work free

Without the split, plans start feeling like ADRs. Authors write them with MADR structure, treat them as if immutable, resist revising them even when execution teaches better. The ADR discipline — designed for decisions that bind future work — gets misapplied to plans that should iterate freely. Overhead exceeds value.

The promotion rule in §0013 directly protects against this. An operational choice becomes canonical only when it binds future work beyond the current execution. Not when it's large. Not when it's important. *When it's binding.* A 12-phase refactor plan isn't an ADR; it's a plan. The phased-refactor *principle* might be an ADR, if it's a rule the team will apply to future refactors. The distinction lets plans be plans.

### 3. It makes promotions and demotions visible

The split makes it explicit when an operational choice is becoming canonical (promotion: write an ADR) and when a canonical choice is being demoted (supersession: write a new ADR that replaces it). Both transitions are deliberate and recorded. Nothing slides silently from one category to the other.

Compare the alternative: a single category where everything is "documentation" and the distinction between rule and plan is fuzzy. Silent promotions happen (a plan starts being cited as if it were canon). Silent demotions happen (an ADR gets treated like a plan and edited in place). The record decays because the categories aren't sharp enough to maintain.

## How the split shows up in the scaffold

- **ADRs (`@<unit-name>/CANON@<unit-name>/accepted/`) are canonical.** Immutable, citable, supersedable only by deliberate process.
- **Plans, briefs, implementations, research, schedules, codebases are operational.** Iterate freely; per §0014, the unit-level operational container is `OPS@<unit-name>/`, and external operational artifacts (connected repos, shared drives) are allowed by reference.
- **The reference rule governs how ADRs mention operational artifacts.** Safe references survive the artifact changing; unsafe references make the ADR depend on the artifact's current state.
- **The promotion rule governs when an operational choice becomes canonical.** Binding future work is the test.
- **The Registrar audits for unsafe references as part of its checklist** (§0011). The form/substance separation applies here too — the Registrar flags unsafe references, but remediation (rewriting the ADR) is the Lead's job.
- **§0014 separates canonical and operational at each unit by naming convention:** UPPERCASE-prefixed governance folders (`CANON@`, `REFERENCE@` at root only) hold canon; `OPS@<unit-name>/` holds operational artifacts; lowercase agent dirs hold per-agent private state. The capitalization makes the split visible at a glance without a wrapper folder.

## Common failure modes

**Binding-by-reference.** ADR says "we will X according to `plans/foo.md`." The ADR's meaning is now hostage to `plans/foo.md` staying where it is and saying what it currently says. Unsafe. Rewrite so the decision's content lives inside the ADR.

**Plan-as-ADR.** A long detailed plan gets ADR-ified because it's important. But the plan changes weekly; the ADR is now mutable-by-fiction, and the §0004 discipline is silently broken. Split: canonical principle goes into an ADR; specific sequence stays operational.

**Silent promotion.** An operational choice becomes binding by informal convention without being documented as canon. Later, someone violates it and there's no record to cite. The choice was functionally canonical but recorded operationally. Promote it to an ADR when the pattern is clear.

**Silent demotion.** An ADR is treated like a plan and edited in place. Covered by §0004; flagged here as the mirror of silent promotion.

**Conflating scope with canon.** "We decided that we'd do X for this project" might be a plan or an ADR. The test: will future projects be bound by this? If yes, it's canonical (maybe at the agency scope, maybe at a unit's scope). If no, it's operational.

## Debates and open questions

- **Where do hybrid artifacts sit?** A design document might be partly decision, partly plan. The scaffold's practice: split them. Write an ADR for the decision part; keep the plan part as operational. Some practitioners resist splitting; experience suggests the split pays off.
- **How many categories do you really need?** Three-tier taxonomies (decision / plan / implementation) appear in some frameworks. The scaffold sticks to two because the key structural fact is binding-or-not; subdividing the operational side produces overhead without clarity.
- **Can the canon be implicit?** Some agencies adopt a convention without writing an ADR for it, reasoning "everyone knows." This is silent promotion in disguise. If the convention binds future work, write the ADR. If it doesn't bind, it's not really canon and people shouldn't be treating it as such.

## Further reading

- Buchanan, J. M. & Tullock, G. (1962). *The Calculus of Consent.* University of Michigan Press. The foundational treatment of constitutional economics.
- Hart, H. L. A. (1961). *The Concept of Law.* Oxford University Press. Primary and secondary rules are introduced in Chapter V.
- Popper, K. (1945). *The Open Society and Its Enemies.* Routledge. Piecemeal engineering is in Volume 1, Chapter 9.
- Ostrom, E. (1990). *Governing the Commons.* Cambridge University Press. Design principles for long-lived commons, especially Chapter 3.
- Nygard, M. (2011). "Documenting Architecture Decisions." Cognitect blog. The founding ADR post; short and readable.
- Cohn, M. (various). *User Stories Applied* and *Agile Estimating and Planning*. For the product-vision-vs-sprint framing.

## See also

- `../philosophy.md` — the short synthesis with the other foundations.
- `04-architecture-decision-records.md` — ADR origins and discipline.
- `05-legal-citation-tradition.md` — citation-based canonical referencing.
- `06-registrar-pattern.md` — form/substance separation that applies within the canonical layer.
- `../decision-process.md` — how ADRs flow through proposal, acceptance, supersession.
- `../../registrar@{unit_name}/AGENTS.md` — unsafe-reference audit item the Registrar runs.
