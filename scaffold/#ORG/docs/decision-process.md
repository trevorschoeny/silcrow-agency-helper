# Decision process

This document governs how decisions become records in this agency. It is referenced from every agent's `AGENTS.md` and from the Registrar's playbook. Read it before authoring, reviewing, or handling ADRs.

The underlying philosophy — *why* we do it this way — is in `philosophy.md`. This doc is the operational how.

---

## 1. What counts as a decision worth recording

Not every choice needs an ADR. Use the **promotion rule** from §0013:

> *An operational choice is promoted to canonical when it needs to constrain future work beyond the current execution. Not when it's large. Not when it's important. When it's **binding**.*

Record a decision when **at least one** of these is true:

- It constrains future work (API shape, naming scheme, library choice that cascades, module boundary, a rule for future experiments or future events).
- It has non-obvious reasoning — if a new agent would ask "why did we do it this way?", the answer needs to be findable.
- It was reached after real deliberation among real alternatives.
- It sits above the "implementation detail" floor — it will be cited across more than one piece of work.

Don't record:

- Ephemeral implementation choices (variable naming inside a function, this-week's chore chart).
- Decisions that are purely derived from an existing ADR ("we're using Postgres because §0023 says we use Postgres" — no new ADR needed).
- Decisions that are trivially reversible and low-stakes.

When in doubt, write the decision. A minimal ADR (see `../adr/_templates/madr-minimal.md`) takes five minutes. The cost of losing a rationale you later need is much higher.

---

## 2. §-numbering

Every accepted ADR receives a §-number. Numbers are:

- **Sequential** — assigned in the order the Registrar accepts them.
- **Monotonic** — never go backward.
- **Never reused** — not even for rejected or withdrawn proposals.
- **Unique within the unit's record** — no per-topic sub-numbering. Per §0014, every unit (including the root) is its own §-numbering scope: each unit's `#ORG@{unit_name}/adr/` carries its own monotonic sequence, and there is no separate registry above or beside the units that assigns §-numbers across the tree.

The §-number is assigned by the Registrar at acceptance time, or by a Lead/User committing directly to `accepted/`. The filename embeds the number and is permanent once assigned. Status changes move the file between folders (`accepted/`, `superseded/`, `rejected/`); the filename does not change.

### Filenames

`§NNNN-short-kebab-title.md`

- Four-digit zero-padded number. Supports up to 9999 ADRs per unit's record, which is more than enough.
- Kebab-case short title.
- The literal `§` character is used in the filename.

### Identity vs. navigation

The §-numbering discipline above governs ADR *identity* and is scaffold-prescribed. How ADRs are *organized* within `accepted/` — whether to introduce topic subfolders — is a **local decision**. See `../adr/README.md` and the "Partitioning at scale" section of `../agents/{registrar_dir}@{unit_name}/AGENTS.md` for the mechanical procedure.

---

## 3. Who may author ADRs, and the lifecycle

Per §0011 and §0012, authorship authority differs by role:

- **{lead_role}** — first-class. May draft, commit, and supersede directly in `accepted/`. May also use `proposed/` for optional Registrar pre-review.
- **{user_role}** — first-class. Same authority as Lead (and more — as principal per §0012).
- **{implementer_role}** — draft-with-approval. May draft ADRs but must place them in `proposed/` awaiting Lead or User approval.
- **Registrar** — no authoring. Registrar flags form issues and records the work others do.

### The lifecycle — three paths

The scaffold used to gate every ADR through a sync validation step by the Registrar. That's no longer the default (§0011).

#### Path A — Lead direct commit (default for Lead/User)

```
┌────────┐  draft  ┌─────────────────┐  commit  ┌──────────────────────────────┐
│ author │ ───────▶│ author's dir    │ ────────▶│ #ORG@{unit_name}/adr/accepted/│
│ (Lead) │         │ (private)       │          │ with next §-number           │
└────────┘         └─────────────────┘          └──────────────────────────────┘
```

Lead writes the draft privately, assigns themselves the next available §-number (looking at `accepted/` to see what's next), commits the file directly into `accepted/`. No Registrar pre-review. The Registrar audits later on demand (§0011).

#### Path B — Lead via `proposed/` (optional pre-review)

```
┌────────┐  draft  ┌──────────┐ submit  ┌───────────┐ approved? ┌──────────┐
│ Lead   │ ───────▶│ priv dir │ ───────▶│ proposed/ │ ─────────▶│ accepted │
└────────┘         └──────────┘         └───────────┘           └──────────┘
                                              │
                                              │ issues
                                              ▼
                                        returned for revision
```

The Lead wants a second set of eyes. They drop the draft in `proposed/` and message the Registrar. The Registrar audits form and either confirms (the Lead or Registrar then moves it to `accepted/`) or returns with issues.

#### Path C — Implementer drafts with approval (required for Implementer)

```
┌──────────────┐  draft  ┌──────────┐ submit  ┌───────────┐ approved? ┌──────────┐
│ Implementer  │ ───────▶│ priv dir │ ───────▶│ proposed/ │ ─────────▶│ accepted │
└──────────────┘         └──────────┘         └───────────┘           └──────────┘
                                                    │
                                                    │ rejected
                                                    ▼
                                            #ORG@{unit_name}/adr/rejected/
```

The Implementer drafts the ADR, places it in `proposed/`, and messages the {lead_role} (or {user_role}) explaining why this is ADR-worthy. The Lead/User decides:

- **Accept as-is** — the Registrar (or the Lead directly) moves the file to `accepted/` with an assigned §-number.
- **Request revisions** — the Lead responds with specific asks in the Implementer's inbox.
- **Reject** — the Registrar moves the draft to `rejected/` with the rejection reasoning captured.

### Status field in the file

Every ADR has a `Status:` field in its header. Valid values:

- `proposed` — currently in `proposed/` awaiting review.
- `accepted` — in `accepted/`, currently binding.
- `superseded-by-§NNNN` — in `superseded/`, replaced by §NNNN.
- `rejected` — in `rejected/`, explicitly rejected.

The Registrar updates this field as the file moves between folders.

---

## 4. Supersession

**Accepted ADRs are never edited** (§0004). If a decision turns out to be wrong or circumstances change, the correct procedure is supersession:

1. Author a new ADR. In its `Supersedes:` field, name the §-number being replaced.
2. The new ADR follows the normal lifecycle (Path A, B, or C).
3. At acceptance:
   - The old ADR moves from `accepted/` to `superseded/`.
   - The old ADR's `Status:` changes to `superseded-by-§NNNN`.
   - The old ADR's `Superseded by:` field points at the new ADR.
   - A retrospective note appends to the old ADR's body.
   - The index and bidirectional citations update.

### The retrospective note

When an ADR is superseded, a dated retrospective note appends at the bottom of the superseded ADR's body:

```markdown
---

## Retrospective note — superseded {date}

Superseded by §NNNN ({link}). {One-sentence summary of why, written by the
author of the superseding ADR.} See §NNNN for the full reasoning.
```

This is the **only permitted post-acceptance modification** to an accepted ADR. It does not edit the original body — it appends a forward-pointer. The retrospective note itself is immutable once written.

### Why never edit?

Because an ADR is a record of *what was decided, when, with what reasoning*. If you edit it later, you lose the history of how thinking evolved. Event sourcing, constitutional law, git commit history, and legal citation all rely on this same discipline.

More in `foundations/04-architecture-decision-records.md`.

---

## 5. Canonical vs operational artifacts

Per §0013, the agency produces two kinds of artifacts:

- **Canonical (ADRs)** — immutable, citable, stable.
- **Operational (everything else)** — plans, briefs, implementations, research, schedules, codebases — mutable and evolving.

Constraint flows one direction: canonical binds operational; operational never binds canonical.

### When an operational choice needs to become an ADR

Apply the **promotion rule**. The test is *binding on future work*, not size or importance. See §0013 for paired examples.

### When an ADR references operational artifacts

Use the **reference rule**. Safe references are:

- **Orienting pointer** — tells a reader where to look.
- **Provenance citation** — names the artifact that led to the decision; the decision's content lives inside the ADR.
- **Compliance pointer** — names where the rule's satisfaction is measured.

Apply the **delete test** (if the referenced file vanishes, does the ADR still carry its decision?) and the **contradiction test** (if the referenced file contradicts the ADR, does the ADR still hold on its own terms?). If either answer is "no," the reference is unsafe — rewrite so the ADR's meaning lives inside the ADR.

The Registrar audits for unsafe references (§0011) and surfaces them to the Lead for remediation.

---

## 6. Anti-patterns — embed or promote

Anti-patterns are first-class records (§0009). You can surface an anti-pattern two ways:

**Embedded** — in an ADR's `Anti-patterns surfaced` section. Appropriate when the anti-pattern is specific to that decision's context.

**Standalone** — as a record in `#ORG@{unit_name}/adr/anti-patterns/`, using the `ap-NNN` numbering sequence. Appropriate when the anti-pattern is reusable.

### Promotion criteria

Promote an embedded anti-pattern to standalone when:

- A second ADR needs to cite it.
- Its applicability is broader than the original decision's scope.
- The embedded version is getting unwieldy — it deserves the space.

---

## 7. MADR template — full vs. minimal

Use **`madr-full.md`** when:

- The decision is architectural or cross-cutting.
- There are real alternatives worth recording.
- The "why" is non-obvious or contested.

Use **`madr-minimal.md`** when:

- The decision is localized.
- The reasoning is straightforward.
- Writing the full template would cost more than the decision warrants.

---

## 8. Review triggers

Every ADR names a `Review trigger` — the condition under which it should be reconsidered. Good triggers are **specific and observable**:

- "When we cross 1M monthly requests."
- "When the team grows beyond 10 engineers."
- "When the third-party we depend on announces a sunset date."

Poor triggers are vague: *"in the future"* is not a trigger.

If a decision genuinely has no review trigger, say so: *"Review trigger: none; the failure mode this addresses is not context-dependent."* That's a legitimate answer.

---

## 9. The bidirectional citation graph

ADRs form a graph. Every ADR can name:

- `Influenced by` — §-numbers this ADR builds on.
- `Influences` — §-numbers shaped by this one.

The Registrar maintains both sides. When §N is accepted with `Influenced by: §M`, the Registrar also updates §M's `Influences` to include §N.

When an ADR is superseded, the citation graph is preserved but annotated.

---

## 10. Skill-assisted ADR flows

### `:silcrow-add-unit` — unit-establishing ADRs

When the {lead_role} or {user_role} adds a new unit via the `silcrow:silcrow-add-unit` skill, the skill authors a unit-establishing ADR automatically (§0014). The ADR lands in the parent's `#ORG@<parent-unit-name>/adr/accepted/` with the establishing reasoning captured. This is the fast path for a specific kind of structural decision; the skill is doing what the author would otherwise do by hand.

### `:silcrow-update` — update audit ADRs

When the {user_role} invokes `silcrow:silcrow-update` to bring the agency into conformity with the plugin's current canonical state, the Registrar orchestrates an audit (per §0015). At the end of the audit, the Registrar authors **one audit ADR** summarizing accepts, rejects, deferrals, and file changes. That ADR is canonical — per §0015, rejections and deferrals are decisions that bind future audit behavior, and they belong in the record.

### Both paths produce normal ADRs

Skills don't create a different kind of ADR — they produce the same MADR-with-Y-statement form as any direct author. The Registrar audits them the same way. The distinction is only in *who authors them* (the skill acts on behalf of the Lead/User).

---

## Worked examples

### Greenfield decision (Lead direct-commit, §0011)

The {lead_role} drafts in `#ORG@{unit_name}/agents/{lead_dir}@{unit_name}/draft-logging-adr.md`, assigns the next §-number by checking `accepted/` (e.g. §0019), moves the file to `#ORG@{unit_name}/adr/accepted/§0019-use-structured-logging.md`, sets `Status: accepted`, and commits `§0019: use structured logging`. Either Lead or Registrar updates the index — the Registrar will fix it at next audit if the Lead doesn't.

### Implementer draft with approval (§0012)

The {implementer_role} drafts in their own directory, moves the draft to `#ORG@{unit_name}/adr/proposed/draft-correlation-id.md`, and messages the {lead_role}: *"Drafted ADR proposing correlation IDs in API error responses — context: repeated debugging difficulty tracing errors across services. Please review."* Lead responds: accept (move to `accepted/` with §-number), request revisions (stays in `proposed/`), or reject (Registrar moves to `rejected/` with §-number — rejections consume §-numbers too).

### Supersession

Lead drafts a new ADR with `Supersedes: §0019`, commits to `accepted/` with the next §-number (say §0042). Either Lead or Registrar moves §0019 to `superseded/` (filename unchanged), updates §0019's `Status:` and `Superseded by:` fields, and appends a retrospective note. Commit cites both: `§0042: adopt observability v2; supersedes §0019`. Old citations to §0019 continue to resolve; readers see the retrospective note and follow forward.

### Anti-pattern discovered post-adoption

§0011 was adopted eight months ago and has caused repeated incidents. Three artifacts result:

- **Standalone anti-pattern** in `#ORG@{unit_name}/adr/anti-patterns/ap-007-...md` — reusable knowledge for future cache discussions.
- **Superseding ADR** §0088 — records the new decision (service-local caches), with `Supersedes: §0011`.
- **Retrospective note on §0011** — points forward to §0088 and cites `ap-007`.

Without (a) the next cache discussion re-derives the lesson; without (b) there's no new binding decision; without (c) §0011 looks current to casual readers.

The discipline — preserve the original, don't edit — is about learning, not blame. The old ADR was the best available reasoning at the time. Preserving it intact lets future agents see the real arc: decision → outcome → anti-pattern → superseded.

---

## Cross-references

- `philosophy.md` — why this process works the way it does.
- `message-protocol.md` — the message format used for proposals, briefs, and acknowledgments.
- `../agents/{registrar_dir}@{unit_name}/AGENTS.md` — the Registrar's side of every operation above.
- `foundations/04-architecture-decision-records.md` — deep dive on ADRs.
- `foundations/05-legal-citation-tradition.md` — deep dive on §-numbering.
- `foundations/07-canonical-and-operational.md` — canon/operational split.
- `../adr/_templates/` — the templates you'll use.
- `../adr/accepted/§0011-registrar-as-async-auditor.md` — why Lead commits direct.
- `../adr/accepted/§0012-user-as-principal-and-local-tier-numbering.md` — the Implementer-draft-with-approval path.
- `../adr/accepted/§0013-canonical-and-operational-artifacts.md` — the promotion rule and reference rule.
- `../adr/accepted/§0015-update-audits-produce-audit-adrs.md` — the `:silcrow-update` audit-ADR pattern.
