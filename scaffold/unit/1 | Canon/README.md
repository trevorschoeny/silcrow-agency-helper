# 1 | Canon — {agency_name}

`1 | Canon/` is the canonical decision record for this unit. It holds Architecture Decision Records (ADRs) and the templates and structure that govern them. `1 | Canon/` is part of every unit (root and sub-units alike) per §0012; the `3 | Silcrow Agency Reference/` folder at the agency's root carries the procedural reference docs that explain how this folder works.

- **Decisions are immutable.** Once accepted, an ADR is never edited. It can be *superseded* by a new ADR, but the original body is preserved as history.
- **§-numbers are sequential and never reused.** Even rejected proposals consume a number. See the agency's `@ {agency_name}/3 | Silcrow Agency Reference/Decision Process.md` for why.
- **Filenames are permanent once assigned.** Status changes move the file between folders — the filename does not change.

Subfolders:

| Folder | Meaning |
|---|---|
| `accepted/` | Currently binding decisions |
| `superseded/` | Decisions replaced by a newer ADR; preserved as history |
| `rejected/` | Proposals explicitly rejected; preserved so the rejection is itself citable |
| `proposed/` | Voluntary pre-review and approval channel; Implementer drafts land here awaiting Lead/User approval |
| `_templates/` | The MADR-Full, MADR-Minimal, and Establish-Unit templates |

The `proposed/` directory is voluntary for Leads (who may commit directly to `accepted/` per §0009) and required for Implementers (who draft into `proposed/` awaiting approval per §0010).

Anti-patterns are recorded as regular ADRs in `accepted/` — same numbering, same lifecycle. The polarity of a decision (positive or negative) is a property of its content, not a separate category.

## Organizing within `accepted/` — up to the agency

The scaffold prescribes one discipline about ADR identity: §-numbering is **sequential, monotonic, never-reused, and agency-global**. That rule is load-bearing and does not bend.

How ADRs are *organized within* `accepted/` — whether to introduce topic subfolders (`arch/`, `data/`, `ops/`, etc.), what to name them, when to introduce them — is a **local decision**. It's a navigation concern, not an identity concern. Citations still resolve by §-number regardless of subfolder placement; you update `1 | Canon/README.md` (this file) to point to the current location.

If the agency decides to introduce a particular subfolder scheme, **that decision is itself a candidate for an ADR** — the convention binds every future ADR, which is exactly the bar for recording. Partitioning the record incidentally demonstrates the record's own pattern. See `../Registrar @ {unit_name}/AGENTS.md` ("Partitioning at scale") for the mechanical procedure and the scaling notes.

---

## Accepted decisions

| § | Title | Status | Date |
|---|---|---|---|
| §0001 | [Adopt the Silcrow agency](accepted/§0001%20%7C%20Adopt%20Silcrow%20Agency.md) | accepted | {date} |
| §0002 | [Use MADR + Why-statement as the ADR format](accepted/§0002%20%7C%20Use%20MADR%20with%20Why-Statement.md) | accepted | {date} |
| §0003 | [Use §-numbering: sequential, monotonic, never-reused](accepted/§0003%20%7C%20Use%20Section%20Numbering.md) | accepted | {date} |
| §0004 | [Accepted ADRs are immutable; supersession replaces editing](accepted/§0004%20%7C%20Immutability%20and%20Supersession.md) | accepted | {date} |
| §0005 | [Inter-agent communication via inboxes; no out-of-band channels](accepted/§0005%20%7C%20Communication%20via%20Inboxes.md) | accepted | {date} |
| §0006 | [Starter roster and tier model](accepted/§0006%20%7C%20Starter%20Roster%20and%20Tier%20Model.md) | accepted | {date} |
| §0007 | [{lead_role} writes briefs, not specs](accepted/§0007%20%7C%20Briefs%2C%20Not%20Specs.md) | accepted | {date} |
| §0008 | [Roster change protocol](accepted/§0008%20%7C%20Roster%20Change%20Protocol.md) | accepted | {date} |
| §0009 | [Registrar operates as async auditor with strictly procedural authority](accepted/§0009%20%7C%20Registrar%20as%20Async%20Auditor.md) | accepted | {date} |
| §0010 | [User as principal; local tier numbering; Implementer drafts-with-approval](accepted/§0010%20%7C%20User%20as%20Principal%20and%20Local%20Tier%20Numbering.md) | accepted | {date} |
| §0011 | [Canonical and operational artifacts: direction of constraint, promotion rule, reference rule](accepted/§0011%20%7C%20Canonical%20and%20Operational%20Artifacts.md) | accepted | {date} |
| §0012 | [Agency and unit structure; flat `@ <Unit>/` convention](accepted/§0012%20%7C%20Agency%20and%20Unit%20Structure.md) | accepted | {date} |
| §0013 | [Update audits produce per-session audit ADRs](accepted/§0013%20%7C%20Update%20Audits%20Produce%20Audit%20ADRs.md) | accepted | {date} |
| §0014 | [Agency default `.gitignore` — OS, editor, and secrets patterns only](accepted/§0014%20%7C%20Default%20Gitignore.md) | accepted | {date} |
| §0015 | [Governance commits cite the governing §NNNN; operational commits are free-form](accepted/§0015%20%7C%20Governance%20Commits%20Cite%20Section%20Numbers.md) | accepted | {date} |
| §0016 | [Decision-record acceptance is broadcast to every bound agent](accepted/§0016%20%7C%20Broadcast%20Decision%20Records%20on%20Acceptance.md) | accepted | {date} |
| §0017 | [Agency scope](accepted/§0017%20%7C%20Agency%20Scope.md) — *seed, expected to be superseded early; intentional first lesson in the supersession discipline* | accepted | {date} |

**About the founding set.** §0001 records the decision to adopt this scaffold. §0002–§0016 are **constitutional decisions inherited from the scaffold** via §0001 — they capture the load-bearing choices that define how this agency runs. Each names its alternatives and cites its foundations so it can be evaluated or superseded on its own merits, like any other ADR.

- §0017 (Agency Scope) is explicitly a seed — the scaffold invites the User and Lead to supersede it with a richer scope statement as an early collaborative task. Its supersession is the first concrete demonstration of §0016 (broadcast on acceptance).
- §0008–§0016 build on the earlier ADRs: §0008 codifies how roster changes happen; §0009 establishes the Registrar's async-auditor mode and procedural-only authority; §0010 extends §0006 (tier model + authorship); §0011 establishes the canon/operational split that the rest of the agency's work flows within; §0012 codifies the flat `@ <Unit>/` layout with numeric-prefix governance folders (`1 | Canon`, `2 | Working Files`, `3 | Silcrow Agency Reference`); §0013–§0015 cover update audits, gitignore defaults, and commit conventions; §0016 establishes that ADRs broadcast through inboxes on acceptance, propagating awareness along the inheritance edges of the unit tree.

## Superseded decisions

*(none yet)*

## Rejected proposals

*(none yet)*

---

## Maintenance

This index is maintained by the Registrar. Agents should not edit it directly — the Registrar updates it when authoring or superseding ADRs.

See `../Registrar @ {unit_name}/AGENTS.md` for the full procedure.
