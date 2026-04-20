# ADR Index — {project_name}

This is the canonical index of all Architecture Decision Records for this project.

- **Decisions are immutable.** Once accepted, a decision is never edited. It can be *superseded* by a new decision, but the original body is preserved as history.
- **§-numbers are sequential and never reused.** Even rejected proposals consume a number. See `../docs/decision-process.md` for why.
- **Filenames are permanent once assigned.** Status changes move the file between folders — the filename does not change.

Subfolders:

| Folder | Meaning |
|---|---|
| `accepted/` | Currently binding decisions |
| `superseded/` | Decisions replaced by a newer ADR; preserved as history |
| `rejected/` | Proposals explicitly rejected; preserved so the rejection is itself citable |
| `anti-patterns/` | Standalone anti-pattern records (prefix `ap-`, separate numbering) |
| `_templates/` | The MADR-full, MADR-minimal, and anti-pattern templates |

The in-queue location for new proposals is `../proposed/`, not a subfolder here. The Registrar processes `../proposed/` and moves validated ADRs into this tree.

## Organizing within `accepted/` — up to the project

The scaffold prescribes one discipline about ADR identity: §-numbering is **sequential, monotonic, never-reused, and project-global**. That rule is load-bearing and does not bend.

How ADRs are *organized within* `accepted/` — whether to introduce topic subfolders (`arch/`, `data/`, `ops/`, etc.), what to name them, when to introduce them — is a **local decision**. It's a navigation concern, not an identity concern. Citations still resolve by §-number regardless of subfolder placement; you update `adr/README.md` (this file) to point to the current location.

If the project decides to introduce a particular subfolder scheme, **that decision is itself a candidate for an ADR** — the convention binds every future ADR, which is exactly the bar for recording. Partitioning the record incidentally demonstrates the record's own pattern. See `../docs/registrar-playbook.md` §7 for the mechanical procedure and the scaling notes.

---

## Accepted decisions

| § | Title | Status | Date |
|---|---|---|---|
| §0001 | [Adopt the agent-org-scaffold pattern](accepted/§0001-adopt-agent-org-scaffold.md) | accepted | {date} |
| §0002 | [Use MADR + Y-statement as the ADR format](accepted/§0002-use-madr-with-y-statement.md) | accepted | {date} |
| §0003 | [Use §-numbering: sequential, monotonic, never-reused](accepted/§0003-use-section-numbering.md) | accepted | {date} |
| §0004 | [Accepted ADRs are immutable; supersession replaces editing](accepted/§0004-immutability-and-supersession.md) | accepted | {date} |
| §0005 | [Inter-agent communication via inboxes; no out-of-band channels](accepted/§0005-communication-via-inboxes.md) | accepted | {date} |
| §0006 | [Starter roster and tier model](accepted/§0006-starter-roster-and-tier-model.md) | accepted | {date} |
| §0007 | [{lead_role} writes briefs, not specs](accepted/§0007-briefs-not-specs.md) | accepted | {date} |
| §0008 | [Registrar authority is procedural, not substantive](accepted/§0008-registrar-procedural-authority.md) | accepted | {date} |
| §0009 | [Anti-patterns are first-class records](accepted/§0009-anti-patterns-as-first-class-records.md) | accepted | {date} |

**About the founding nine.** §0001 records the decision to adopt this scaffold. §0002–§0009 are **constitutional decisions inherited from the scaffold** via §0001 — they capture the load-bearing choices that define how this project runs. Each names its alternatives and cites its foundations so it can be evaluated or superseded on its own merits, like any other ADR.

## Superseded decisions

*(none yet)*

## Rejected proposals

*(none yet)*

## Anti-patterns

See [anti-patterns/README.md](anti-patterns/README.md).

---

## Maintenance

This index is maintained by the Registrar. Agents should not edit it directly — submit a proposal and the Registrar will update the index as part of accepting or superseding an ADR.

See `../docs/registrar-playbook.md` for the full procedure.
