# 2 | Working Files — {agency_name}

`2 | Working Files/` is this unit's **operational catch-all** — the open container for everything operational at the unit level. Per §0013, every unit has one.

## What goes here

- **Code repositories** — the unit's deliverable codebase, libraries, scripts. Drop them here as subfolders, or keep them in a separate repo elsewhere on disk and reference that repo from a note here.
- **Deliverables** — research papers, reports, design assets, anything the unit produces as output.
- **Shared work product** — documents, datasets, project plans, schedules that multiple agents need to reference.
- **Cross-agent reference material** — anything operational (mutable, working) that is not private to a single agent.
- **External operational artifacts** — pointers to Google Drive folders, shared filesystems, connected repos. Reference them; don't mirror them (per §0005).

## What does not go here

- **Canon (decisions).** Those go in `1 | Canon/`. ADRs are immutable per §0004; the contents of `2 | Working Files/` are mutable.
- **Procedural reference (philosophy, foundations, etc.).** Those live in the agency's root unit `3 | Silcrow Agency Reference/`. `2 | Working Files/` is operational; that folder is canonical procedural.
- **Agent-private working state.** Drafts, plans, scratch notes that one agent owns and iterates on stay in that agent's own folder (`<Role> @ <Unit Name>/`). `2 | Working Files/` is shared; agent dirs are private (per §0005's actor-model discipline).

## How agents use this folder

Per §0005's actor-model discipline, agents iterate privately in their own folders. When material reaches a quality bar where it should be visible to others, agents **publish** here. Iteration happens in agent dirs; publication lands in `2 | Working Files/`.

For shared agent-to-agent work in flight, the protocol is messages-via-inboxes (per `3 | Silcrow Agency Reference/Message Protocol.md`), not concurrent edits to a shared file here.

## Sub-structure

This folder does not prescribe sub-structure. Organize as the unit's work demands: a single repo at the unit level, or several subfolders, or one folder per project. The Registrar audits `1 | Canon/`; `2 | Working Files/` organization is operational and decided locally.

## See also

- `../1 | Canon/accepted/§0013 | Agency and Unit Structure.md` — defines OPS's role.
- `../1 | Canon/accepted/§0012 | Canonical and Operational Artifacts.md` — the canon/operational distinction.
- `../1 | Canon/accepted/§0005 | Communication via Inboxes.md` — actor-model discipline; why agent-private state and OPS-published state are separate.
