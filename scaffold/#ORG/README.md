# {agency_name}

{agency_description}

---

## What this is

This directory (`#ORG/`) is the **governance folder** for the root unit of this agency, per §0015. It contains only governance artifacts — decisions, agent instructions, foundational docs. Operational work — codebases, plans, research, schedules, deliverables — lives alongside `#ORG/`, either at this unit's root or inside any sub-unit's directory.

The agency is the entire organizational tree. Its topmost node is the **root unit** (this directory's parent, sharing the agency's name). Every unit — root or sub-unit — is structurally identical: its own `#ORG/`, its own agents, its own operational work, with sub-units arbitrarily nested below. The agency is organized as a **hierarchical agent organization** with built-in decision tracking (ADRs), actor-model message passing between agents, a registrar that audits the record, and a clean separation between canonical and operational artifacts. The structure was initialized by the `silcrow:silcrow-init` skill on {date}.

The shape of the agency is opinionated and comes from a composition of seven independently-validated disciplines:

- **Stratified cognition** (Elliott Jaques): hierarchy reflects differences in time horizon of work.
- **Subsidiarity** (Catholic social teaching / EU law): decisions at the lowest competent level.
- **Actor model** (Hewitt, Armstrong): private state per agent, communication via messages.
- **Architecture Decision Records** (Nygard, MADR): immutable decision log with rationale.
- **Legal citation tradition**: §-numbered, sequential, never-reused identifiers.
- **Registrar pattern**: procedural authority over form, not substance; async audit mode.
- **Canonical/operational split** (Buchanan, Hart, Popper, Ostrom, Nygard, Agile): canon binds operational, never the reverse.

If you are new here, read `docs/philosophy.md` before going deeper.

---

## Read in this order

A new reader — human or agent — should read these in order:

1. **This file** — `#ORG/README.md` — for orientation.
2. **`#ORG/docs/philosophy.md`** — the intellectual foundation for every part of the structure.
3. **`#ORG/docs/decision-process.md`** — how ADRs are proposed, accepted, superseded.
4. **`#ORG/docs/message-protocol.md`** — how agents communicate.
5. **`#ORG/agents/<your-role>@<unit>/AGENTS.md`** — if you are occupying a role, your specific duties.
6. **`#ORG/adr/accepted/§0006-starter-roster-and-tier-model.md`** and **`§0013-user-as-principal-and-local-tier-numbering.md`** — the tier model and its multi-unit refinements.
7. **`#ORG/adr/accepted/§0015-agency-and-unit-structure.md`** — agency/unit vocabulary and structural conventions.

For deeper dives on any of the seven disciplines, `docs/foundations/` has per-thread treatments.

---

## Directory layout

### Inside this `#ORG/` (governance only)

```
#ORG/
├── README.md                      ← you are here
├── agents/
│   ├── {user_dir}@{agency_dir}/         ← principal (transcends tiers)
│   ├── {lead_dir}@{agency_dir}/         ← tier-1: architecture, briefs, reviews
│   ├── {implementer_dir}@{agency_dir}/  ← tier-2: planning and execution
│   └── registrar@{agency_dir}/          ← outside hierarchy: record integrity (async auditor)
│
├── adr/                           ← architecture decision records
│   ├── README.md                  ← index of all decisions
│   ├── _templates/                ← MADR, anti-pattern, establish-unit templates
│   ├── accepted/                  ← currently binding decisions
│   ├── proposed/                  ← pre-review / Implementer-draft staging
│   ├── superseded/                ← decisions replaced by a newer ADR (preserved)
│   ├── rejected/                  ← proposals explicitly rejected (preserved)
│   └── anti-patterns/             ← standalone anti-pattern records
│
└── docs/
    ├── philosophy.md              ← why this works the way it does (read first)
    ├── decision-process.md        ← ADR lifecycle
    ├── message-protocol.md        ← inbox / archive discipline
    └── foundations/               ← deep dives on each of the seven disciplines
```

### Alongside `#ORG/` at the root unit's directory

```
@{agency-dir-name}/                ← root unit (shares the agency's name)
├── #ORG/                          ← governance (this folder)
├── @<sub-unit>/                   ← sub-units, if any (each with its own #ORG/)
│   └── ...
└── (operational artifacts)        ← your codebase, plans, research, etc.
```

Operational artifacts live wherever is natural — alongside any unit's `#ORG/`, inside sub-unit directories, or externally (connected repos, shared drives, etc.). `#ORG/` contains only governance.

---

## Core conventions — at a glance

- **Decisions are immutable** (§0004). Accepted ADRs are never edited. They are superseded by new ADRs; both remain in the record.
- **§-numbers are permanent** (§0003). Every accepted ADR gets a §-number. Numbers are sequential, monotonic, and never reused.
- **Messages are first-class** (§0005). Communication between agents goes through inboxes (`#ORG/agents/<role>@<unit>/inbox/`) and is archived on read (`inbox/archive/`). No out-of-band communication.
- **The {lead_role} writes briefs, not specs** (§0007). What and why, not how. The {implementer_role} retains agency over execution.
- **The Registrar owns form, not substance** (§0012). They audit the record on demand, correct procedural issues, and surface substantive ones. They do not gate every commit.
- **Subsidiarity**. Decisions are made at the lowest tier capable of making them well.
- **Canon vs operational** (§0014). ADRs are canonical (immutable, citable); plans/briefs/implementations are operational (mutable). Canon binds operational; never the reverse.
- **The User is the principal** (§0013). Not a tier, but the one the agents serve. May act as the superior of any tier at any time.
- **Every unit is a unit** (§0015). The agency is the whole tree; the root unit is its topmost node; sub-units live nested inside their parent. Every unit — root or sub — has its own `#ORG/` and follows the same rules. The pattern is recursive; the rules are identical at every depth.

---

## The founding constitution

The scaffold ships with **nineteen seeded ADRs** (§0001–§0019, minus §0008 which has been superseded by §0012). §0001 records the decision to adopt the scaffold itself. §0002 through §0019 are **constitutional decisions inherited through §0001** — they make the load-bearing choices of the pattern explicit and supersedable rather than leaving them as unrecorded convention.

| § | Constitutional decision |
|---|---|
| §0001 | Adopt the Silcrow agency |
| §0002 | Use MADR + Y-statement as the ADR format |
| §0003 | Use §-numbering: sequential, monotonic, never-reused |
| §0004 | Accepted ADRs are immutable; supersession replaces editing |
| §0005 | Inter-agent communication via inboxes; no out-of-band channels |
| §0006 | Starter roster and tier model |
| §0007 | {lead_role} writes briefs, not specs |
| §0008 | *(superseded by §0012)* Registrar authority is procedural, not substantive |
| §0009 | Anti-patterns are first-class records |
| §0010 | Roster change protocol |
| §0011 | Agency scope (seed — expand early) |
| §0012 | Registrar operates as async auditor, not sync gatekeeper |
| §0013 | User as principal; local tier numbering; Implementer drafts-with-approval |
| §0014 | Canonical and operational artifacts: direction of constraint, promotion rule, reference rule |
| §0015 | Agency and unit structure; `#ORG/` and `@<unit>/` conventions |
| §0016 | Update audits produce per-session audit ADRs |
| §0017 | Agency default `.gitignore` — OS, editor, and secrets patterns only |
| §0018 | Governance commits cite the governing §NNNN; operational commits are free-form |
| §0019 | Units with independent versioning needs are git submodules |

Each cites its foundation doc (`docs/foundations/0N-*.md`) for the full reasoning, and each lists real alternatives so it can be evaluated or superseded like any other ADR. The seed set serves as **both the working base of the agency's decision graph and a demonstration set** — showing new agents what proper ADRs look like.

---

## Adding agents, renaming roles, adding units, restructuring

These are significant decisions, each governed by its own ADR.

- **Roster changes** (adding, renaming, retiring agents) follow `#ORG/adr/accepted/§0010-roster-change-protocol.md`.
- **New units** — use the `silcrow:silcrow-add-unit` skill, which authors the establishing ADR and creates the unit's `#ORG/` and directory structure in one motion (per §0015).
- **Scaffold updates** (new ADRs, reorg, conventions shipped by the plugin) — use the `silcrow:silcrow-update` skill. The Registrar orchestrates; every change is user-approved; the session produces one audit ADR (§0016).

---

## What this scaffold does not provide

- No opinion on tech stack, build tools, or CI/CD.
- No code files.
- No prescribed workflow beyond the ADR, message-protocol, canon/operational, and git disciplines.

It is purely an *organizational* scaffold. What happens inside the agency — the software, research, writing, planning, or other substantive work — is up to you.

---

## Further reading

See `docs/philosophy.md` first, then dig into whichever foundations are most relevant to your role. These documents are the scaffold's constitutional text — if a situation comes up that the procedural docs don't cover, the foundations are where to reason from.
