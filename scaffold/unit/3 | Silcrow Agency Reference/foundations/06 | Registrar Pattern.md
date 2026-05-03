# 06 | Registrar pattern

## What the idea is

**Record integrity requires a role whose authority is procedural, not substantive.** The role's job is to ratify the record — to verify that things were properly submitted, numbered, filed, and indexed — without adjudicating whether the *substance* of those things is correct. That judgment belongs to the decision-makers the record is about, not to the role maintaining the record.

Conflating form and substance in one role corrupts both. This is the core claim of the registrar pattern, and real-world registrars have followed it for centuries across universities, courts, corporations, and civil administration.

## Where the pattern appears

### University registrar

The modern university registrar's role is the most visible contemporary example. A registrar at an accredited institution:

- Maintains student records — enrollment, grades, transcripts, degree certifications.
- Verifies that academic requirements were met (coursework completed, grades recorded, exams passed).
- Certifies official documents (transcripts, diplomas, enrollment verifications).
- Processes course registration and class scheduling.
- Manages academic calendars and publishes official course catalogs.
- Ensures compliance with educational regulations (FERPA in the US; similar elsewhere).

What the registrar does **not** do:

- Evaluate whether a student's work is academically good.
- Assign grades.
- Decide admissions.
- Set academic policy.

The separation is explicit and long-established. It is codified in AACRAO's (American Association of Collegiate Registrars and Admissions Officers) professional standards. See the AACRAO blog post "What, exactly, does a registrar do?" (aacrao.org) for the clearest contemporary statement of the role.

The university registrar's **authority is procedural**. They can refuse to process a registration that violates the rules. They can insist on form. They cannot, ever, say "I disagree with the professor's grade" or "I think this student should graduate despite the missing credits."

### Court registrar

Court systems have registrars whose role is similar in spirit but varies across jurisdictions.

In common-law systems (UK, Canada, Australia, India), the court registrar is a senior administrative officer responsible for:

- Managing filings — motions, pleadings, orders.
- Maintaining the court's records and docket.
- Scheduling hearings.
- Issuing procedural directions (deadlines, filing requirements).
- In some specialized courts (e.g., Insolvency and Companies Court in England and Wales), conducting preliminary hearings and issuing binding procedural directions.
- Formally entering judgments into the court's records.

Court registrars in some jurisdictions have **quasi-judicial** procedural authority — they can issue rulings on procedural matters (continuances, form of pleadings, filing deadlines) that are binding unless appealed. But even this quasi-judicial authority is strictly procedural. A court registrar does not rule on motions, adjudicate disputes, or decide cases on the merits.

The *prothonotary* in some US state court systems is a similar role. The Federal Judicial Center's *Judiciaries Worldwide* (judiciariesworldwide.fjc.gov) offers comparative descriptions across legal systems.

### Corporate registrar (company secretary)

In corporate governance, the **company secretary** — often titled "corporate registrar" — is responsible for:

- Maintaining the register of members (shareholders).
- Recording corporate resolutions.
- Filing required disclosures with regulatory bodies.
- Certifying official corporate documents.
- Ensuring corporate-governance compliance.

The UK Companies Act requires a company secretary for public companies, and the role's duties are statutorily defined. The Delaware General Corporation Law imposes similar record-keeping requirements.

The corporate registrar does not set strategy, vote shares, or sign contracts. They record and certify; they do not decide.

### Secretary of a deliberative body

**Robert's Rules of Order** (Henry Martyn Robert, 1876; 12th edition 2020, Public Affairs) defines the role of the secretary in a deliberative assembly. The secretary:

- Records minutes of meetings.
- Maintains the organization's records.
- Reads previous minutes for approval.
- Handles correspondence on behalf of the body.

The secretary does not preside (that is the chair's job), propose motions (those come from the membership), or vote except in their capacity as a member. Their authority is strictly record-keeping. Robert's Rules is explicit that the secretary's minutes are an official record, but the secretary is not the decider of what was decided; they record what the body decided.

### Weber and bureaucratic form

Max Weber's theory of bureaucracy (*Wirtschaft und Gesellschaft*, 1922) implicitly names the registrar role as part of *legal-rational authority*. Bureaucracies require roles whose authority is based on formal rules rather than personal charisma or traditional status. The registrar is one such role: authority derives from a well-defined procedural function, not from the registrar's personal judgment.

Weber does not use the word *registrar*, but the pattern — a role whose power is *in the office*, not *in the person* — is exactly what registrar positions formalize.

## Sync gate vs async auditor — two modes, same separation

Real-world registrars operate in two modes, and both preserve the form/substance separation.

**Sync gate mode.** The registrar validates every submission before it enters the record. A university registrar reviews registration requests as they arrive and approves each one. A court clerk checks filings at the intake window.

**Async auditor mode.** Submissions enter the record immediately; the registrar audits the record periodically and flags issues. A university registrar audits enrollment records at end of term. A court clerk audits the docket on a cadence. A corporate secretary audits the share register periodically against transaction records.

The scaffold's original pattern (§0008) was sync-gate. The scaffold's current pattern (§0010) is async-auditor. **The form/substance separation is preserved in both.** What changes between modes is *when* the registrar acts — per-proposal vs on-demand — not *what* their authority covers.

Why the scaffold moved to async-auditor: sync gating produced workflow latency, evaporated the author's context (by the time a decision came back from validation, the "why" had faded from working memory), and made the registrar a soft bottleneck even when fast. The async mode removes all three costs while keeping the centuries-tested separation intact. The Registrar's authority remains strictly procedural; the cadence of its exercise is different.

If this distinction seems subtle: look at how actual registrars handle high-volume periods. They don't halt all admissions while they validate each one — they process at intake, then audit the record for form issues, and when they find an irregularity they route it for correction. That's async auditing in practice, and the world's record-keeping systems run on it every day.

## Why the separation is load-bearing

When form and substance are combined in one role, one of two failure modes follows predictably.

### Form slips because substance is more urgent

If the registrar is also a decision-maker, they prioritize the urgent substantive calls over the "paperwork" of form. Over time, records become inconsistent, citations drift, and the record's integrity degrades in proportion to how busy the decision-makers are. The more consequential the decisions, the worse the form problem.

This is observable in organizations that try to combine these roles. "Oh, I'll file that later" becomes the default, and *later* becomes *never*. By the time form issues are noticed, reconstruction is expensive.

### Substance becomes procedural because the role's bias is toward form

If the decision-maker is also the registrar, they develop the registrar's caution around form. Decisions start getting shaped by what fits the filing convention rather than what answers the question. "We can't do X because there's no form for X" is the tell. The registrar's job is to adapt form to substance; when the decision-maker is the registrar, they instead adapt substance to form.

Either failure mode destroys the scaffold's key property: that the record accurately captures what was decided and why.

## Scaling: fan-out, not strata

One registrar suffices for a small organization. As records proliferate, the pattern scales by adding more registrars, each handling a partitioned scope — **fan-out**, not **strata**.

- A large university has a single Registrar role but that office employs many staff, each handling a functional subset (course registration, grades, transcripts, degree audit).
- A large court system has a chief clerk but below them many deputy clerks, each handling a subset of the docket.
- A large corporation has a corporate secretary with a team of assistant secretaries and registrars for different record types.

In each case, the pattern is the same: **the same procedural role, duplicated across partitions**. There is not a "senior registrar" making substantive calls that junior registrars cannot make. Seniority within the registrar function is about scope and coordination, not substantive authority.

At very large scale, a **Chief Registrar** emerges to coordinate cross-partition integrity — verifying that references between partitions resolve, maintaining a global index, coordinating format changes. But the Chief Registrar is still procedural. They are not a "senior decision-maker in the record system." An organization that drifts toward giving its Chief Registrar substantive authority has drifted into one of the failure modes above.

## Why this matters for the scaffold

The scaffold includes a **Registrar** as a starter agent even though the initial workload is light. This is deliberate. Starting with a Registrar — even an underutilized one — establishes the discipline from day one that *the record has a custodian*. Retrofitting the discipline later is much harder.

The Registrar's authority in this scaffold is strictly procedural:

- **Filename format.** Correct §-numbering, kebab-case titles, folder placement.
- **§-number assignment.** Monotonic, never reused (see `05 | Legal Citation Tradition.md`). Either the author assigns it at direct commit, or the Registrar assigns it when processing a Lead-approved Implementer draft.
- **Reference integrity.** Citations resolve to real ADRs; bidirectional citation graph is maintained.
- **Status-folder placement.** Accepted ADRs in `accepted/`, superseded in `superseded/`, rejected in `rejected/`.
- **Index updates.** `1 | Canon/README.md` reflects the current state of all records.
- **Audit execution.** On-demand audit against the checklist (see `../../Registrar @ {unit_name}/AGENTS.md`).
- **Update-workflow orchestration.** The `:silcrow-update` skill's diff, report, per-item review, and audit-ADR authoring.

Per §0010, the Registrar operates as **async auditor**: Lead and User commit ADRs directly to `accepted/` when confident; Implementers draft into `proposed/` for Lead approval; the Registrar audits the record on demand and corrects procedural issues or surfaces substantive ones. No per-proposal gating.

The Registrar does **not**:

- Evaluate whether a decision is correct.
- Gate acceptance (Lead has first-class authority; §0010 superseded §0008's sync-gate mode).
- Adjudicate conflicts between ADRs (that is for the decision-makers).
- Silently fix substantive issues (they surface them via message and let the authors decide).

When the Registrar encounters inconsistencies they cannot resolve mechanically, they **surface them upward** — by message, to the author or the appropriate tier — and let the substantive decision-makers respond. The Registrar does not block acceptance because they personally disagree with content; they don't block acceptance at all (that's the mode shift).

This stance is unusual for agents accustomed to broader authority. It takes explicit articulation and repeated reinforcement. That's why the stance is the first thing in `../../Registrar @ {unit_name}/AGENTS.md` and why this foundation document restates it.

## Common failure modes

**Registrar as bottleneck.** If the Registrar is asked to review substance, they become a serialization point for all decisions. This defeats the scaffold's actor-model discipline. Solution: keep Registrar authority strictly procedural; substance review is not their job.

**Registrar as power center.** If the Registrar begins adjudicating which decisions are "right," they become a de facto senior decision-maker without the accountability that role entails. Solution: watch for this and surface it immediately. The correct response is: "that's a substantive call, not mine; I'm sending it back to the author."

**Silent substance fixes.** The Registrar sees an error in an ADR's substance — a claim that's factually wrong, an argument that's confused — and corrects it on the way through. This is a discipline violation even when the correction is *right*, because it opaquely inserts Registrar judgment into a record that should reflect the author's reasoning.

**Tiered registrars.** Junior Registrars handle "routine" cases, "senior" Registrars handle "important" ones. This replicates the conflation of form and substance in a new form. All Registrars should have the same procedural authority across their partition. Importance is a content distinction, not a form one.

## Debates and open questions

- **Should the Registrar's work be automated?** In software, much of what a registrar does (filename validation, citation-link checking, index maintenance) can be scripted. The scaffold's position: automate whatever you like, but keep a named human-or-agent Registrar responsible. Automation executes; accountability does not.
- **How strong the "never silently fix" discipline.** Some teams argue that for purely typographic issues (spelling, spacing), silent fixes are fine. The scaffold treats even these conservatively — a typo in a filename, for instance, should be checked back with the author before changing, because you can't always tell from outside whether the "typo" was intentional.
- **Can the Registrar be the same entity as the {lead_role}?** In a very small organization, one person wearing both hats is tempting. The scaffold strongly discourages this. Separation of form and substance fails if they are done by the same mind — the bias toward the more interesting work takes over, and form slips first.

## Further reading

- AACRAO resources, especially "What, exactly, does a registrar do?" (aacrao.org/resources/newsletters-blogs).
- Federal Judicial Center, *Judiciaries Worldwide*: judiciariesworldwide.fjc.gov. Search "registrar" for comparative material.
- *Robert's Rules of Order* (12th edition, 2020). The section on the secretary role is short, crisp, and useful.
- Weber, M. (1922). *Wirtschaft und Gesellschaft* (Economy and Society), Part III on bureaucracy. The classic theoretical treatment of roles defined by office rather than person.
- UK Companies Act 2006, Part 10, on the company secretary role. Statutory definition of a corporate-registrar-adjacent role.
- Wonkhe's blog post "What is a registrar anyway?" (wonkhe.com) for a modern critical take on the tensions between the role's responsibilities and its authority in higher education.

## See also

- `../Philosophy.md` — the short synthesis with the other six foundations.
- `../../Registrar @ {unit_name}/AGENTS.md` — the operational procedures the Registrar follows.
- `07 | Canonical and Operational.md` — the canon/operational split that the Registrar audits for unsafe references.
- `04 | Architecture Decision Records.md` — the immutability discipline the Registrar enforces.
- `05 | Legal Citation Tradition.md` — the §-numbering the Registrar assigns.
- `02 | Subsidiarity.md` — why the Registrar sits outside the tiered decision hierarchy.
