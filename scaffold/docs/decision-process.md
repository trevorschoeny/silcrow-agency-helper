# Decision process

This document governs how decisions become records in this project. It is referenced from every agent's `instructions.md` and from the Registrar's playbook. Read it before authoring, reviewing, or handling ADRs.

The underlying philosophy — *why* we do it this way — is in `philosophy.md`. This doc is the operational how.

---

## 1. What counts as a decision worth recording

Not every choice needs an ADR. Use this significance bar:

Record a decision when **at least one** of these is true:

- It constrains future work (API shape, naming scheme, library choice that cascades, module boundary).
- It has non-obvious reasoning — if a new agent would ask "why did we do it this way?", the answer needs to be findable.
- It was reached after real deliberation among real alternatives.
- It sits above the "implementation detail" floor — it will be cited across more than one piece of work.

Don't record:

- Ephemeral implementation choices (variable naming inside a function, local refactoring).
- Decisions that are purely derived from an existing ADR ("we're using Postgres because §0023 says we use Postgres" — no new ADR needed).
- Decisions that are trivially reversible and low-stakes.

When in doubt, write the decision. A minimal ADR (see `../adr/_templates/madr-minimal.md`) takes five minutes. The cost of losing a rationale you later need is much higher.

---

## 2. §-numbering

Every accepted ADR receives a §-number. Numbers are:

- **Sequential** — assigned in the order the Registrar accepts them.
- **Monotonic** — never go backward.
- **Never reused** — not even for rejected or withdrawn proposals.
- **Globally unique within the project** — no per-topic sub-numbering.

The §-number is assigned by the Registrar at acceptance time. The filename embeds the number and is permanent once assigned. Status changes move the file between folders (`accepted/`, `superseded/`, `rejected/`); the filename does not change.

### Why §?

The section sign (§) — also called the silcrow — comes from the Latin *signum sectionis*, "sign of the section," and evolved from medieval scribal practice into modern legal citation (e.g., *42 U.S.C. § 1983*). Sequential, monotonic, never-reused section numbering is the discipline that makes legal texts citable across centuries. We adopt the same discipline for the same reason: stable cross-reference over long time horizons.

More in `foundations/05-legal-citation-tradition.md`.

### Filenames

`§NNNN-short-kebab-title.md`

- Four-digit zero-padded number. Supports up to 9999 ADRs per project, which is more than enough and makes sorting trivial.
- Kebab-case short title. Descriptive but not exhaustive — the full title lives inside the file.
- The literal `§` character is used in the filename. If your tooling objects, use a wildcard or search the file body.

### Identity vs. navigation

The §-numbering discipline above governs ADR *identity* and is scaffold-prescribed. How ADRs are *organized* within `../adr/accepted/` — whether to introduce topic subfolders, what to name them, when to introduce them — is a **local project decision**, not a scaffold rule. See `../adr/README.md` ("Organizing within `accepted/` — up to the project") and `registrar-playbook.md` §7 for the mechanical procedure. If the project adopts a particular subfolder scheme, record that choice as its own ADR.

---

## 3. The lifecycle

An ADR moves through these states:

```
    ┌────────┐   draft    ┌─────────┐   submit    ┌───────────┐   validate    ┌──────────┐
    │ author │ ─────────▶ │ agent's │ ──────────▶ │ proposed/ │ ───────────▶  │ accepted │
    │        │            │   dir   │             │           │               │          │
    └────────┘            └─────────┘             └───────────┘               └──────────┘
                                                        │
                                                        │ invalid
                                                        ▼
                                              ┌─────────────────────┐
                                              │ returned to author  │
                                              │ (via message)       │
                                              └─────────────────────┘
```

A proposal can also be **rejected** at any point after submission, in which case the Registrar moves it to `adr/rejected/` and assigns a §-number (rejection still consumes a number, because the rejection itself is part of the permanent record).

### Draft

The author writes a draft inside their own agent directory. This is private workspace — no other agent reviews drafts here, no citations point here. The author iterates freely.

Use `adr/_templates/madr-full.md` for the full template, `adr/_templates/madr-minimal.md` for a lighter form.

### Submit

When the draft is ready, the author:

1. Moves (copies) the file into `proposed/`. The filename at this stage is `draft-NNNN-short-title.md` where `NNNN` is any unique placeholder the author uses to disambiguate. The `§` and final number are **not** assigned yet.
2. Sends a message to the Registrar (`agents/registrar/inbox/`) announcing the submission. See `message-protocol.md` for the filename convention.

### Validate

The Registrar runs the checklist in `registrar-playbook.md`:

- Required sections present (per template).
- Citations resolve (every referenced §-number exists in `adr/accepted/` or `adr/superseded/`).
- Template followed.
- Status field set to `proposed`.

If the Registrar finds issues, they send a message back to the author explaining what to fix. The file stays in `proposed/` until fixed or withdrawn.

### Accept

When validated, the Registrar:

1. Assigns the next §-number.
2. Renames the file: `§NNNN-short-title.md`.
3. Moves it to `adr/accepted/`.
4. Updates the status field in the file from `proposed` to `accepted`.
5. Updates `adr/README.md` (the index).
6. Updates bidirectional citations: if the new ADR references existing ADRs in `Influenced by`, updates those ADRs' `Influences` section.
7. Sends an acknowledgment message to the submitter with the assigned §-number.

### Reject

If the decision-maker with authority over the ADR's scope rejects the proposal, the Registrar:

1. Assigns the next §-number (rejection consumes a number).
2. Renames the file.
3. Adds a rejection note inside the file explaining who rejected and why.
4. Changes status to `rejected`.
5. Moves the file to `adr/rejected/`.
6. Updates the index.

Rejected ADRs are part of the record. They prevent the same proposal from being raised again without citing the prior rejection.

---

## 4. Supersession

**Accepted ADRs are never edited.** If a decision turns out to be wrong, or if circumstances change, the correct procedure is supersession:

1. Author a new ADR. In its `Supersedes` field, name the §-number being replaced.
2. The new ADR follows the same lifecycle: draft → proposed → validate → accept.
3. At acceptance, the Registrar:
   - Moves the old ADR from `adr/accepted/` to `adr/superseded/`.
   - Updates the old ADR's `Status` field to `superseded-by-§NNNN`.
   - Updates the old ADR's `Superseded by` field to point at the new ADR.
   - Appends a retrospective note to the old ADR (see below).
   - Updates bidirectional citations.

### The retrospective note

When an ADR is superseded, the Registrar appends a dated note at the bottom of the superseded ADR's body:

```markdown
---

## Retrospective note — superseded {date}

Superseded by §NNNN ({link}). {One-sentence summary of why, written by the author
of the superseding ADR.} See §NNNN for the full reasoning.
```

This is the **only permitted post-acceptance modification** to an accepted ADR. It does not edit the original body — it appends a forward-pointer. The retrospective note itself is immutable once written.

### Why never edit?

Because an ADR is a record of *what was decided, when, with what reasoning*. If you edit it later, you lose the history of how thinking evolved. Event sourcing, constitutional law, git commit history, and legal citation all rely on this same discipline. If §0042 could later refer to something different than it did yesterday, every citation to §0042 becomes suspect. The record has to mean what it meant.

More in `foundations/04-architecture-decision-records.md`.

---

## 5. Anti-patterns — embed or promote

Anti-patterns are first-class records in this project. You can surface an anti-pattern two ways:

**Embedded** — in an ADR's `Anti-patterns surfaced` section. Appropriate when the anti-pattern is specific to that decision's context.

**Standalone** — as a record in `adr/anti-patterns/`, using the `ap-NNN` numbering sequence. Appropriate when the anti-pattern is reusable (likely to come up across future decisions, independent of the original surfacing context).

### Promotion criteria

Promote an embedded anti-pattern to a standalone record when:

- A second ADR needs to cite it.
- Its applicability is broader than the original decision's scope.
- The embedded version is getting unwieldy — it deserves the space.

The Registrar handles promotion: a short message requesting promotion is enough. The Registrar extracts the anti-pattern into a new `ap-NNN-*.md`, replaces the embedded text with a pointer to the standalone record, and updates cross-references. The §-number of the original ADR is not affected.

---

## 6. MADR template — full vs. minimal

Use **`madr-full.md`** when:

- The decision is architectural or cross-cutting.
- There are real alternatives worth recording.
- The "why" is non-obvious or contested.
- Future agents will need to understand not just the outcome but the reasoning.

Use **`madr-minimal.md`** when:

- The decision is localized (single module, single area of concern).
- The reasoning is straightforward enough that the core sections carry it.
- Writing the full template would cost more than the decision warrants.

If a minimal ADR turns out to need more depth, it can be expanded in place without changing its §-number. That's a procedural change the Registrar handles on request. Going the other way — shrinking a full ADR — is uncommon; the body typically stays.

---

## 7. Review triggers

Every ADR (both full and minimal, where applicable) names a `Review trigger` — the condition under which it should be reconsidered. Review triggers are important because:

- Circumstances change even when logic doesn't.
- A decision that was right under last year's constraints may not be right under this year's.
- Without an explicit trigger, ADRs ossify silently.

Good review triggers are **specific and observable**:

- "When we cross 1M monthly requests."
- "When the team grows beyond 10 engineers."
- "When the third-party we depend on announces a sunset date."

Poor review triggers are **vague or unobservable**:

- "When it seems appropriate." (Who decides? Based on what?)
- "In the future." (When? How will we know?)

If a decision genuinely has no review trigger — the logic is intrinsic, circumstances don't alter it — say so explicitly. "Review trigger: none; the failure mode this addresses is not context-dependent." That's a legitimate answer.

---

## 8. The bidirectional citation graph

ADRs form a graph. Every ADR can name:

- `Influenced by` — §-numbers of ADRs whose conclusions this ADR builds on.
- `Influences` — §-numbers of ADRs whose conclusions are shaped by this one.

The Registrar maintains both sides. When §N is accepted with `Influenced by: §M`, the Registrar also updates §M's `Influences` to include §N. This discipline means:

- You can read *forward* (from an ADR to what it shaped).
- You can read *backward* (from an ADR to what shaped it).

When an ADR is superseded, the citation graph is preserved but annotated. §M's `Influences` still lists §N; but §N now shows `Status: superseded-by-§X`, and any forward-readers know where to look next.

---

## Example 1 — Greenfield decision

The {lead_role} needs to decide how errors are logged across {project_name}. There are several reasonable options. Here's how an ADR flows through the system.

**1. Draft.** The {lead_role} works on the draft inside `agents/{lead_dir}/` — say, `agents/{lead_dir}/draft-logging-adr.md`. They iterate. Nothing is citable yet.

**2. Submit.** When ready, they copy the draft to `proposed/draft-001-structured-logging.md` (the `001` is just their internal counter, not the final §-number). They send a message to the Registrar:

```
proposed/draft-001-structured-logging.md submitted for review.
Uses madr-full template. No Influences/Influenced-by; no Supersedes.
```

**3. Validate.** The Registrar reads the proposal, confirms required sections are present, confirms no broken citations (none to check, in this case), confirms template compliance.

**4. Accept.** Registrar assigns the next §-number — say, §0014. Renames the file to `§0014-use-structured-logging.md`. Moves it to `adr/accepted/`. Updates the status field in the file from `proposed` to `accepted`. Updates `adr/README.md` to add §0014 to the accepted list. Sends an acknowledgment to the {lead_role}.

**5. Cascade.** The {lead_role} writes a brief to the {implementer_role} to implement §0014. That brief is a message; it lives in `agents/{implementer_dir}/inbox/`. The {implementer_role}'s plan will cite §0014 directly.

Total file movements:

```
agents/{lead_dir}/draft-logging-adr.md        (stays; local draft)
proposed/draft-001-structured-logging.md      (created at submit, deleted at accept)
adr/accepted/§0014-use-structured-logging.md  (final home)
```

---

## Example 2 — Supersession

Three months later, the structured logging decision (§0014) turns out to be inadequate — the project has new observability requirements that weren't anticipated. The {lead_role} wants to replace it.

**1. Draft** a new ADR in `agents/{lead_dir}/`. In its `Supersedes` field, name `§0014`. The body explains what changed and why the old decision is no longer adequate.

**2. Submit** to `proposed/`. Send a message to the Registrar noting this is a supersession of §0014.

**3. Validate.** Registrar verifies the supersession target exists and is in `adr/accepted/`. Registrar also checks the new ADR doesn't silently contradict other accepted ADRs without acknowledging them.

**4. Accept.** Registrar assigns §0042 (or whatever the next number is). The following happens atomically:

- New ADR: moved to `adr/accepted/§0042-adopt-observability-v2.md` with status `accepted`.
- Old ADR §0014: moved from `adr/accepted/` to `adr/superseded/`. Its filename stays `§0014-use-structured-logging.md`. Its `Status` field changes to `superseded-by-§0042`. Its `Superseded by` field is set to `§0042`.
- Retrospective note appended to §0014's body:

  ```markdown
  ---

  ## Retrospective note — superseded 2026-07-14

  Superseded by §0042 (../accepted/§0042-adopt-observability-v2.md). New observability
  requirements revealed that structured-logging-only was insufficient; §0042 specifies
  a broader approach including structured traces and metrics. See §0042 for full reasoning.
  ```

- `adr/README.md` is updated: §0014 moves from "Accepted" to "Superseded" table; §0042 is added to "Accepted".
- Bidirectional citations updated: §0042's `Supersedes` points at §0014; §0014's `Superseded by` points at §0042. Any ADRs that cited §0014's conclusions continue to cite §0014 (the history), but readers can walk forward to §0042 for the current position.

Total file state:

```
adr/accepted/§0014-use-structured-logging.md    → moved to adr/superseded/
adr/accepted/§0042-adopt-observability-v2.md    → new, final home
adr/README.md                                    → updated index
```

Old citations to §0014 do not break. Readers of §0014 see the retrospective note and follow it forward.

---

## Example 3 — Anti-pattern discovered post-adoption (the hard case)

§0012 was a decision made eight months ago to use a shared in-memory cache across services. It seemed correct at the time. In practice, it has caused repeated incidents where cache invalidation bugs in one service caused data corruption in another. The {implementer_role} has surfaced this pattern and brought it to the {lead_role}.

This case produces **three artifacts**:

**(a) A standalone anti-pattern record** — `ap-007-shared-mutable-cache-across-services.md`.

This records the anti-pattern itself: what it looks like, why it seems reasonable, why it actually fails. This anti-pattern is reusable (the next caching discussion will benefit from it), so it gets promoted to standalone rather than embedded.

**(b) A superseding ADR** — §0088 or similar.

This supersedes §0012 and records the new decision (say: service-local caches, no sharing). Its `Supersedes` field names §0012; its body explains the anti-pattern (by reference to `ap-007`) and the replacement.

**(c) A retrospective note on §0012**.

Appended to §0012 at supersession time, pointing forward to §0088. Also names `ap-007` so future readers of §0012 see both the successor decision *and* the anti-pattern the original decision fell into.

### Why all three?

- The **anti-pattern record** is reusable knowledge. The next cache discussion will cite `ap-007` directly, without re-deriving the lesson.
- The **superseding ADR** is the new binding decision. It replaces §0012.
- The **retrospective note** preserves §0012 intact (immutability) while pointing forward. A reader arriving at §0012 from an old citation sees both the history *and* the current position, and knows where to go for each.

If we skipped any of the three, we'd lose something:

- Without (a), the next cache discussion re-derives the lesson.
- Without (b), we have no new binding decision, just a dead one.
- Without (c), §0012 looks current to casual readers.

Total file state:

```
adr/accepted/§0012-shared-cache.md                 → moved to adr/superseded/
adr/accepted/§0088-service-local-caches.md         → new, final home
adr/anti-patterns/ap-007-shared-mutable-cache.md   → new
adr/README.md                                       → updated
```

### Handling the emotional dimension

Decisions that fail are uncomfortable. The discipline here — do not edit the original, preserve the mistake as history — is not about blame; it is about learning. The old ADR is not "wrong." It was the best available reasoning at the time, given what was known. Preserving it intact lets future agents see the real arc: decision → outcome → anti-pattern recognized → superseded. That arc is much more informative than a clean, sanitized record that pretends the mistake never happened.

---

## Cross-references

- `philosophy.md` — why this process works the way it does.
- `message-protocol.md` — the message format used for proposals and acknowledgments.
- `registrar-playbook.md` — the Registrar's side of every operation above.
- `foundations/04-architecture-decision-records.md` — deep dive on ADRs.
- `foundations/05-legal-citation-tradition.md` — deep dive on §-numbering.
- `../adr/_templates/` — the templates you'll use.
