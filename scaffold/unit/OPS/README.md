# OPS — {agency_name}

`OPS@<unit-name>/` is this unit's **operational catch-all** — the open container for everything operational at the unit level. Per §0014, every unit has one.

## What goes here

- **Code repositories** — the unit's deliverable codebase, libraries, scripts. Drop them here as subfolders, or add them as git submodules per §0018.
- **Deliverables** — research papers, reports, design assets, anything the unit produces as output.
- **Shared work product** — documents, datasets, project plans, schedules that multiple agents need to reference.
- **Cross-agent reference material** — anything operational (mutable, working) that is not private to a single agent.
- **External operational artifacts** — pointers to Google Drive folders, shared filesystems, connected repos. Reference them; don't mirror them (per §0005).

## What does not go here

- **Canon (decisions).** Those go in `CANON@<unit-name>/`. ADRs are immutable per §0004; OPS contents are mutable.
- **Procedural reference (philosophy, foundations, etc.).** Those live in the agency's root unit `REFERENCE@<root-unit>/`. OPS is operational; REFERENCE is canonical procedural.
- **Agent-private working state.** Drafts, plans, scratch notes that one agent owns and iterates on stay in that agent's own folder (`<role>@<unit-name>/`). OPS is shared; agent dirs are private (per §0005's actor-model discipline).

## How agents use OPS

Per §0005's actor-model discipline, agents iterate privately in their own folders. When material reaches a quality bar where it should be visible to others, agents **publish** to OPS. Iteration happens in agent dirs; publication lands in OPS.

For shared agent-to-agent work in flight, the protocol is messages-via-inboxes (per `REFERENCE@<root-unit>/message-protocol.md`), not concurrent edits to a shared file in OPS.

## Sub-structure

OPS does not prescribe sub-structure. Organize as the unit's work demands: a single repo at the unit level, or several subfolders, or one folder per project. The Registrar audits CANON; OPS organization is operational and decided locally.

## See also

- `../CANON@{unit_name}/accepted/§0014-agency-and-unit-structure.md` — defines OPS's role.
- `../CANON@{unit_name}/accepted/§0013-canonical-and-operational-artifacts.md` — the canon/operational distinction.
- `../CANON@{unit_name}/accepted/§0005-communication-via-inboxes.md` — actor-model discipline; why agent-private state and OPS-published state are separate.
