# {agency_name}

{agency_description}

---

## What this is

This directory (`@ {unit_name}/`) is the **root unit** of an agency, per §0012. The agency is the entire organizational tree; this directory is its topmost node. Every unit — root or sub-unit — is structurally identical: its own `1 | Canon/`, `2 | Working Files/`, agent directories, optional sub-units, and a README. The root unit additionally hosts the agency's `3 | Silcrow Agency Reference/` folder (foundational reference, root-only; sub-units inherit by reference).

The agency is a **hierarchical agent organization** with built-in decision tracking (ADRs), actor-model message passing between agents, a registrar that audits the record, and a clean separation between canonical and operational artifacts. The structure was initialized by the `silcrow:silcrow-init` skill on {date}.

The shape of the agency is opinionated and comes from a composition of seven independently-validated disciplines:

- **Stratified cognition** (Elliott Jaques): hierarchy reflects differences in time horizon of work.
- **Subsidiarity** (Catholic social teaching / EU law): decisions at the lowest competent level.
- **Actor model** (Hewitt, Armstrong): private state per agent, communication via messages.
- **Architecture Decision Records** (Nygard, MADR): immutable decision log with rationale.
- **Legal citation tradition**: §-numbered, sequential, never-reused identifiers.
- **Registrar pattern**: procedural authority over form, not substance; async audit mode.
- **Canonical/operational split** (Buchanan, Hart, Popper, Ostrom, Nygard, Agile): canon binds operational, never the reverse.

If you are new here, read `3 | Silcrow Agency Reference/Philosophy.md` before going deeper.

---

## Read in this order

A new reader — human or agent — should read these in order:

1. **This file** — `@ {unit_name}/README.md` — for orientation.
2. **`3 | Silcrow Agency Reference/Philosophy.md`** — the intellectual foundation for every part of the structure.
3. **`3 | Silcrow Agency Reference/Decision Process.md`** — how ADRs are proposed, accepted, superseded.
4. **`3 | Silcrow Agency Reference/Message Protocol.md`** — how agents communicate.
5. **`<Your Role> @ {unit_name}/AGENTS.md`** — if you are occupying a role, your specific duties.
6. **`1 | Canon/accepted/§0006 | Starter Roster and Tier Model.md`** and **`§0010 | User as Principal and Local Tier Numbering.md`** — the tier model and its multi-unit refinements.
7. **`1 | Canon/accepted/§0012 | Agency and Unit Structure.md`** — agency/unit vocabulary and structural conventions.

For deeper dives on any of the seven disciplines, `3 | Silcrow Agency Reference/foundations/` has per-thread treatments.

---

## Directory layout

The unit's flat structure (§0012):

```
@ {unit_name}/                              ← unit directory (you are here)
├── @ <Sub-Unit Name>/                       ← sub-units, if any (recursive; same shape)
│   └── ...
├── 1 | Canon/                              ← decisions (per-unit; immutable per §0004)
│   ├── README.md                           ← decision index
│   ├── _templates/                         ← MADR Full, MADR Minimal, Establish Unit templates
│   ├── accepted/                           ← currently binding ADRs (positive and negative-form)
│   ├── proposed/                           ← pre-review / Implementer-draft staging
│   ├── superseded/                         ← ADRs replaced by newer ones (preserved)
│   └── rejected/                           ← proposals explicitly rejected (preserved)
├── 2 | Working Files/                      ← operational artifacts (per-unit; open container)
├── 3 | Silcrow Agency Reference/           ← procedural reference (root unit only; mutable)
│   ├── Philosophy.md                       ← why this works the way it does (read first)
│   ├── Decision Process.md                 ← ADR lifecycle
│   ├── Message Protocol.md                 ← inbox / archive discipline
│   ├── Registrar Update Workflow.md        ← :silcrow-update orchestration
│   ├── Registrar Audit Checklist.md        ← Registrar's audit procedure
│   ├── Registrar Scale Partitioning.md     ← guidance for large records
│   └── foundations/                        ← deep dives on each of the seven disciplines
├── README.md                               ← this file
├── {user_role} @ {unit_name}/              ← principal (transcends tiers; root only)
├── {lead_role} @ {unit_name}/              ← tier-1: architecture, briefs, reviews
├── {implementer_role} @ {unit_name}/       ← tier-2: planning and execution
└── Registrar @ {unit_name}/                ← outside hierarchy: record integrity (async auditor)
```

Per §0012, the unit's directory is `@ <Unit Name>/` (the `@ ` prefix is load-bearing for unit detection). Governance folders use a numeric prefix and `|` separator (`1 | Canon`, `2 | Working Files`, `3 | Silcrow Agency Reference`) — these names are constants in every unit, not per-unit-suffixed. Agent directories are `<Role> @ <Unit Name>/` (Title-case role, spaces around `@`). Sub-folders deeper than the unit's top level (e.g., `accepted/`, `inbox/`, `foundations/`) carry no prefix.

Sub-units, when present, live as siblings of agents and governance folders inside `@ {unit_name}/`. They follow the same flat structure recursively. `3 | Silcrow Agency Reference/` exists only at the root; sub-units walk up to inherit it.

`2 | Working Files/` is the open container for operational artifacts — code repositories, deliverables, shared work product, anything that isn't governance and isn't private to a single agent.

---

## Core conventions — at a glance

- **Decisions are immutable** (§0004). Accepted ADRs are never edited. They are superseded by new ADRs; both remain in the record.
- **§-numbers are permanent** (§0003). Every accepted ADR gets a §-number. Numbers are sequential, monotonic, and never reused.
- **Messages are first-class** (§0005). Communication between agents goes through inboxes (`<Role> @ <Unit Name>/inbox/`) and is archived on read (`inbox/archive/`). No out-of-band communication.
- **ADR acceptance is broadcast** (§0016). When an ADR lands in `accepted/`, the author sends a short notification to every agent in the accepting unit and every descendant sub-unit.
- **The {lead_role} writes briefs, not specs** (§0007). What and why, not how. The {implementer_role} retains agency over execution.
- **The Registrar owns form, not substance** (§0009). They audit the record on demand, correct procedural issues, and surface substantive ones. They do not gate every commit.
- **Subsidiarity**. Decisions are made at the lowest tier capable of making them well.
- **Canon vs operational** (§0011). ADRs are canonical (immutable, citable); plans/briefs/implementations are operational (mutable). Canon binds operational; never the reverse.
- **The User is the principal** (§0010). Not a tier, but the one the agents serve. May act as the superior of any tier at any time.
- **Every unit is a unit** (§0012). The agency is the whole tree; the root unit is its topmost node; sub-units live nested inside their parent. Every unit follows the same flat layout (with `3 | Silcrow Agency Reference/` only at the root). The pattern is recursive at every depth.

---

## The founding constitution

The scaffold ships with **seventeen seeded ADRs** (§0001–§0017). §0001 records the decision to adopt the scaffold itself. §0002 through §0016 are **constitutional decisions inherited through §0001** — they make the load-bearing choices of the pattern explicit and supersedable rather than leaving them as unrecorded convention. §0017 is a thin scope seed expected to be superseded early.

| § | Constitutional decision |
|---|---|
| §0001 | Adopt the Silcrow agency |
| §0002 | Use MADR + Why-statement as the ADR format |
| §0003 | Use §-numbering: sequential, monotonic, never-reused |
| §0004 | Accepted ADRs are immutable; supersession replaces editing |
| §0005 | Inter-agent communication via inboxes; no out-of-band channels |
| §0006 | Starter roster and tier model |
| §0007 | {lead_role} writes briefs, not specs |
| §0008 | Roster change protocol |
| §0009 | Registrar operates as async auditor with strictly procedural authority |
| §0010 | User as principal; local tier numbering; Implementer drafts-with-approval |
| §0011 | Canonical and operational artifacts: direction of constraint, promotion rule, reference rule |
| §0012 | Agency and unit structure; flat `@ <Unit>/` convention |
| §0013 | Update audits produce per-session audit ADRs |
| §0014 | Agency default `.gitignore` — OS, editor, and secrets patterns only |
| §0015 | Governance commits cite the governing §NNNN; operational commits are free-form |
| §0016 | Decision-record acceptance is broadcast to every bound agent |
| §0017 | Agency scope (seed — supersede early) |

Each cites its foundation doc (`3 | Silcrow Agency Reference/foundations/0N-*.md`) for the full reasoning, and each lists real alternatives so it can be evaluated or superseded like any other ADR. The seed set serves as **both the working base of the agency's decision graph and a demonstration set** — showing new agents what proper ADRs look like.

---

## Adding agents, renaming roles, adding units, restructuring

These are significant decisions, each governed by its own ADR.

- **Roster changes** (adding, renaming, retiring agents) follow `1 | Canon/accepted/§0008 | Roster Change Protocol.md`.
- **New units** — use the `silcrow:silcrow-add-unit` skill, which authors the establishing ADR and creates the sub-unit's flat structure in one motion (per §0012).
- **Scaffold updates** (new ADRs, reorg, conventions shipped by the plugin) — use the `silcrow:silcrow-update` skill. The Registrar orchestrates; every change is user-approved; the session produces one audit ADR (§0013).

---

## What this scaffold does not provide

- No opinion on tech stack, build tools, or CI/CD.
- No code files.
- No prescribed workflow beyond the ADR, message-protocol, canon/operational, and git disciplines.

It is purely an *organizational* scaffold. What happens inside the agency — the software, research, writing, planning, or other substantive work — is up to you. That work lives in `2 | Working Files/` (and in any sub-unit's `2 | Working Files/`).

---

## Further reading

See `3 | Silcrow Agency Reference/Philosophy.md` first, then dig into whichever foundations are most relevant to your role. These documents are the scaffold's constitutional text — if a situation comes up that the procedural docs don't cover, the foundations are where to reason from.
