# ADR Index — {agency_name}

This is the canonical index of all Architecture Decision Records for this agency.

- **Decisions are immutable.** Once accepted, a decision is never edited. It can be *superseded* by a new decision, but the original body is preserved as history.
- **§-numbers are sequential and never reused.** Even rejected proposals consume a number. See `../docs/decision-process.md` for why.
- **Filenames are permanent once assigned.** Status changes move the file between folders — the filename does not change.

Subfolders:

| Folder | Meaning |
|---|---|
| `accepted/` | Currently binding decisions |
| `superseded/` | Decisions replaced by a newer ADR; preserved as history |
| `rejected/` | Proposals explicitly rejected; preserved so the rejection is itself citable |
| `proposed/` | Voluntary pre-review and approval channel; Implementer drafts land here awaiting Lead/User approval |
| `anti-patterns/` | Standalone anti-pattern records (prefix `ap-`, separate numbering) |
| `_templates/` | The MADR-full, MADR-minimal, anti-pattern, and establish-unit templates |

The `proposed/` directory is voluntary for Leads (who may commit directly to `accepted/` per §0012) and required for Implementers (who draft into `proposed/` awaiting approval per §0013).

## Organizing within `accepted/` — up to the agency

The scaffold prescribes one discipline about ADR identity: §-numbering is **sequential, monotonic, never-reused, and agency-global**. That rule is load-bearing and does not bend.

How ADRs are *organized within* `accepted/` — whether to introduce topic subfolders (`arch/`, `data/`, `ops/`, etc.), what to name them, when to introduce them — is a **local decision**. It's a navigation concern, not an identity concern. Citations still resolve by §-number regardless of subfolder placement; you update `adr/README.md` (this file) to point to the current location.

If the agency decides to introduce a particular subfolder scheme, **that decision is itself a candidate for an ADR** — the convention binds every future ADR, which is exactly the bar for recording. Partitioning the record incidentally demonstrates the record's own pattern. See `../agents/registrar/instructions.md` ("Partitioning at scale") for the mechanical procedure and the scaling notes.

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
| §0009 | [Anti-patterns are first-class records](accepted/§0009-anti-patterns-as-first-class-records.md) | accepted | {date} |
| §0010 | [Roster change protocol](accepted/§0010-roster-change-protocol.md) | accepted | {date} |
| §0011 | [Agency scope](accepted/§0011-agency-scope.md) — *seed, expected to be superseded early* | accepted | {date} |
| §0012 | [Registrar operates as async auditor, not sync gatekeeper](accepted/§0012-registrar-as-async-auditor.md) | accepted | {date} |
| §0013 | [User as principal; local tier numbering; Implementer drafts-with-approval](accepted/§0013-user-as-principal-and-local-tier-numbering.md) | accepted | {date} |
| §0014 | [Canonical and operational artifacts: direction of constraint, promotion rule, reference rule](accepted/§0014-canonical-and-operational-artifacts.md) | accepted | {date} |
| §0015 | [Agency and unit structure; `#ORG/` and `@<unit>/` conventions](accepted/§0015-agency-and-unit-structure.md) | accepted | {date} |
| §0016 | [Update audits produce per-session audit ADRs](accepted/§0016-update-audits-produce-audit-adrs.md) | accepted | {date} |
| §0017 | [Agency default `.gitignore` — OS, editor, and secrets patterns only](accepted/§0017-default-gitignore.md) | accepted | {date} |
| §0018 | [Governance commits cite the governing §NNNN; operational commits are free-form](accepted/§0018-governance-commits-cite-section-numbers.md) | accepted | {date} |
| §0019 | [Units with independent versioning needs are git submodules](accepted/§0019-submodules-for-independently-versioned-units.md) | accepted | {date} |

**About the founding set.** §0001 records the decision to adopt this scaffold. §0002–§0019 are **constitutional decisions inherited from the scaffold** via §0001 — they capture the load-bearing choices that define how this agency runs. Each names its alternatives and cites its foundations so it can be evaluated or superseded on its own merits, like any other ADR.

- §0011 is explicitly a seed — the scaffold invites the User and Lead to supersede it with a richer scope statement as an early collaborative task.
- §0012–§0019 evolve earlier decisions or extend them: §0012 supersedes §0008 (Registrar operating mode); §0013 extends §0006 (tier model + authorship); §0014 establishes the canon/operational split that the rest of the agency's work flows within; §0015 codifies the `#ORG/` and `@<unit>/` conventions; §0016–§0019 cover updates, gitignore, commit conventions, and submodules.

## Superseded decisions

| § | Title | Superseded by | Date |
|---|---|---|---|
| §0008 | [Registrar authority is procedural, not substantive](superseded/§0008-registrar-procedural-authority.md) | §0012 | {date} |

## Rejected proposals

*(none yet)*

## Anti-patterns

See [anti-patterns/README.md](anti-patterns/README.md).

---

## Maintenance

This index is maintained by the Registrar. Agents should not edit it directly — the Registrar updates it when authoring or superseding ADRs.

See `../agents/registrar/instructions.md` for the full procedure.
