# {agency_name}

{agency_description}

---

## What this is

This directory (`@{unit_name}/`) is the **root unit** of an agency, per §0014. The agency is the entire organizational tree; this directory is its topmost node. Every unit — root or sub-unit — is structurally identical: its own `CANON@<unit-name>/`, `OPS@<unit-name>/`, agent directories, optional sub-units, and a README. The root unit additionally hosts the agency's `REFERENCE@<root-name>/` folder (foundational reference, root-only; sub-units inherit by reference).

The agency is a **hierarchical agent organization** with built-in decision tracking (ADRs), actor-model message passing between agents, a registrar that audits the record, and a clean separation between canonical and operational artifacts. The structure was initialized by the `silcrow:silcrow-init` skill on {date}.

The shape of the agency is opinionated and comes from a composition of seven independently-validated disciplines:

- **Stratified cognition** (Elliott Jaques): hierarchy reflects differences in time horizon of work.
- **Subsidiarity** (Catholic social teaching / EU law): decisions at the lowest competent level.
- **Actor model** (Hewitt, Armstrong): private state per agent, communication via messages.
- **Architecture Decision Records** (Nygard, MADR): immutable decision log with rationale.
- **Legal citation tradition**: §-numbered, sequential, never-reused identifiers.
- **Registrar pattern**: procedural authority over form, not substance; async audit mode.
- **Canonical/operational split** (Buchanan, Hart, Popper, Ostrom, Nygard, Agile): canon binds operational, never the reverse.

If you are new here, read `REFERENCE@{agency_dir}/philosophy.md` before going deeper.

---

## Read in this order

A new reader — human or agent — should read these in order:

1. **This file** — `@{unit_name}/README.md` — for orientation.
2. **`REFERENCE@{agency_dir}/philosophy.md`** — the intellectual foundation for every part of the structure.
3. **`REFERENCE@{agency_dir}/decision-process.md`** — how ADRs are proposed, accepted, superseded.
4. **`REFERENCE@{agency_dir}/message-protocol.md`** — how agents communicate.
5. **`<your-role>@{unit_name}/AGENTS.md`** — if you are occupying a role, your specific duties.
6. **`CANON@{unit_name}/accepted/§0006-starter-roster-and-tier-model.md`** and **`§0012-user-as-principal-and-local-tier-numbering.md`** — the tier model and its multi-unit refinements.
7. **`CANON@{unit_name}/accepted/§0014-agency-and-unit-structure.md`** — agency/unit vocabulary and structural conventions.

For deeper dives on any of the seven disciplines, `REFERENCE@{agency_dir}/foundations/` has per-thread treatments.

---

## Directory layout

The unit's flat structure (§0014):

```
@{unit_name}/                              ← unit directory (you are here)
├── @<sub-unit-name>/                       ← sub-units, if any (recursive; same shape)
│   └── ...
├── CANON@{unit_name}/                      ← decisions (per-unit; immutable per §0004)
│   ├── README.md                           ← decision index
│   ├── _templates/                         ← MADR, anti-pattern, establish-unit templates
│   ├── accepted/                           ← currently binding ADRs
│   ├── proposed/                           ← pre-review / Implementer-draft staging
│   ├── superseded/                         ← ADRs replaced by newer ones (preserved)
│   ├── rejected/                           ← proposals explicitly rejected (preserved)
│   └── anti-patterns/                      ← standalone anti-pattern records
├── OPS@{unit_name}/                        ← operational artifacts (per-unit; open container)
├── README.md                               ← this file
├── REFERENCE@{unit_name}/                  ← procedural reference (root unit only; mutable)
│   ├── philosophy.md                       ← why this works the way it does (read first)
│   ├── decision-process.md                 ← ADR lifecycle
│   ├── message-protocol.md                 ← inbox / archive discipline
│   ├── registrar-update-workflow.md        ← :silcrow-update orchestration
│   ├── registrar-audit-checklist.md        ← Registrar's audit procedure
│   ├── registrar-scale-partitioning.md     ← guidance for large records
│   └── foundations/                        ← deep dives on each of the seven disciplines
├── {user_dir}@{unit_name}/                 ← principal (transcends tiers; root only)
├── {lead_dir}@{unit_name}/                 ← tier-1: architecture, briefs, reviews
├── {implementer_dir}@{unit_name}/          ← tier-2: planning and execution
└── registrar@{unit_name}/                  ← outside hierarchy: record integrity (async auditor)
```

Each direct-child folder of the unit carries the `@{unit_name}` suffix (per §0014). Capitalization distinguishes governance (`CANON@`, `OPS@`, `REFERENCE@` — UPPERCASE) from agents (lowercase). Sub-folders deeper than the unit's top level (e.g., `accepted/`, `inbox/`, `foundations/`) do not carry the suffix.

Sub-units, when present, live as siblings of agents and governance folders inside `@{unit_name}/`. They follow the same flat structure recursively. `REFERENCE@<unit>/` exists only at the root; sub-units walk up to inherit it.

`OPS@{unit_name}/` is the open container for operational artifacts — code repositories, deliverables, shared work product, anything that isn't governance and isn't private to a single agent.

---

## Core conventions — at a glance

- **Decisions are immutable** (§0004). Accepted ADRs are never edited. They are superseded by new ADRs; both remain in the record.
- **§-numbers are permanent** (§0003). Every accepted ADR gets a §-number. Numbers are sequential, monotonic, and never reused.
- **Messages are first-class** (§0005). Communication between agents goes through inboxes (`<role>@<unit-name>/inbox/`) and is archived on read (`inbox/archive/`). No out-of-band communication.
- **ADR acceptance is broadcast** (§0019). When an ADR lands in `accepted/`, the author sends a short notification to every agent in the accepting unit and every descendant sub-unit.
- **The {lead_role} writes briefs, not specs** (§0007). What and why, not how. The {implementer_role} retains agency over execution.
- **The Registrar owns form, not substance** (§0011). They audit the record on demand, correct procedural issues, and surface substantive ones. They do not gate every commit.
- **Subsidiarity**. Decisions are made at the lowest tier capable of making them well.
- **Canon vs operational** (§0013). ADRs are canonical (immutable, citable); plans/briefs/implementations are operational (mutable). Canon binds operational; never the reverse.
- **The User is the principal** (§0012). Not a tier, but the one the agents serve. May act as the superior of any tier at any time.
- **Every unit is a unit** (§0014). The agency is the whole tree; the root unit is its topmost node; sub-units live nested inside their parent. Every unit follows the same flat layout (with REFERENCE only at the root). The pattern is recursive at every depth.

---

## The founding constitution

The scaffold ships with **twenty seeded ADRs** (§0001–§0020, with §0008 superseded by §0011). §0001 records the decision to adopt the scaffold itself. §0002 through §0019 are **constitutional decisions inherited through §0001** — they make the load-bearing choices of the pattern explicit and supersedable rather than leaving them as unrecorded convention. §0020 is a thin scope seed expected to be superseded early.

| § | Constitutional decision |
|---|---|
| §0001 | Adopt the Silcrow agency |
| §0002 | Use MADR + Why-statement as the ADR format |
| §0003 | Use §-numbering: sequential, monotonic, never-reused |
| §0004 | Accepted ADRs are immutable; supersession replaces editing |
| §0005 | Inter-agent communication via inboxes; no out-of-band channels |
| §0006 | Starter roster and tier model |
| §0007 | {lead_role} writes briefs, not specs |
| §0008 | *(superseded by §0011)* Registrar authority is procedural, not substantive |
| §0009 | Anti-patterns are first-class records |
| §0010 | Roster change protocol |
| §0011 | Registrar operates as async auditor, not sync gatekeeper |
| §0012 | User as principal; local tier numbering; Implementer drafts-with-approval |
| §0013 | Canonical and operational artifacts: direction of constraint, promotion rule, reference rule |
| §0014 | Agency and unit structure; flat `@<unit>/` convention |
| §0015 | Update audits produce per-session audit ADRs |
| §0016 | Agency default `.gitignore` — OS, editor, and secrets patterns only |
| §0017 | Governance commits cite the governing §NNNN; operational commits are free-form |
| §0018 | Units with independent versioning needs are git submodules |
| §0019 | Decision-record acceptance is broadcast to every bound agent |
| §0020 | Agency scope (seed — supersede early) |

Each cites its foundation doc (`REFERENCE@{agency_dir}/foundations/0N-*.md`) for the full reasoning, and each lists real alternatives so it can be evaluated or superseded like any other ADR. The seed set serves as **both the working base of the agency's decision graph and a demonstration set** — showing new agents what proper ADRs look like.

---

## Adding agents, renaming roles, adding units, restructuring

These are significant decisions, each governed by its own ADR.

- **Roster changes** (adding, renaming, retiring agents) follow `CANON@{unit_name}/accepted/§0010-roster-change-protocol.md`.
- **New units** — use the `silcrow:silcrow-add-unit` skill, which authors the establishing ADR and creates the sub-unit's flat structure in one motion (per §0014).
- **Scaffold updates** (new ADRs, reorg, conventions shipped by the plugin) — use the `silcrow:silcrow-update` skill. The Registrar orchestrates; every change is user-approved; the session produces one audit ADR (§0015).

---

## What this scaffold does not provide

- No opinion on tech stack, build tools, or CI/CD.
- No code files.
- No prescribed workflow beyond the ADR, message-protocol, canon/operational, and git disciplines.

It is purely an *organizational* scaffold. What happens inside the agency — the software, research, writing, planning, or other substantive work — is up to you. That work lives in `OPS@{unit_name}/` (and in any sub-unit's `OPS@<sub-unit>/`).

---

## Further reading

See `REFERENCE@{agency_dir}/philosophy.md` first, then dig into whichever foundations are most relevant to your role. These documents are the scaffold's constitutional text — if a situation comes up that the procedural docs don't cover, the foundations are where to reason from.
