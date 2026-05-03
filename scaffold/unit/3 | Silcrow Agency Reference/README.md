# 3 | Silcrow Agency Reference — {agency_name}

`3 | Silcrow Agency Reference/` is the agency's **procedural reference**. It holds the canonical procedural docs that explain how the agency runs: the philosophy, the decision process, the message protocol, the registrar's procedures, and the seven foundational disciplines. Per §0012, this folder lives **only at the agency's root unit**; every other unit inherits it by reference to that path.

## What's here

| File | Purpose |
|---|---|
| `Philosophy.md` | The seven foundations synthesized — the scaffold's constitutional text. Read first when you join the agency. |
| `Decision Process.md` | How ADRs are proposed, accepted, superseded; the lifecycle every author follows. |
| `Message Protocol.md` | Inbox / archive discipline; message kinds; recipient-walk algorithm for broadcasts. |
| `Registrar Update Workflow.md` | The 9-step `:silcrow-update` orchestration the Registrar runs. |
| `Registrar Audit Checklist.md` | The full audit checklist and report format the Registrar uses. |
| `Registrar Scale Partitioning.md` | Guidance for when the record grows large (>200 inbox archives or >hundreds of ADRs). |
| `foundations/` | Seven per-thread treatments of the agency's intellectual lineages — stratified cognition, subsidiarity, actor model, ADRs, legal-citation tradition, registrar pattern, canonical/operational. |

## How this folder differs from `1 | Canon/`

- **`1 | Canon/`** holds **decisions** (ADRs). Subject to §0004's immutability — once accepted, never edited; superseded by new ADRs.
- **`3 | Silcrow Agency Reference/`** holds **procedural reference**. Mutable. Procedures evolve as the agency learns; edits to these files are governance commits per §0015.

Both are canon in the §0011 sense (they bind operational work). But they have different update disciplines.

## How to use

- Load these on demand — they're not preemptive reading.
- Each agent's `AGENTS.md` cites the reference files most relevant to its role under "Key references" and "Principles to reason from."
- When a procedural question arises that isn't covered by an ADR, work through the relevant reference doc and reason from foundations.

## This folder is root-only

Sub-units do not have their own `3 | Silcrow Agency Reference/`. Agents in sub-units reference the root unit's copy directly at `@ {agency_name}/3 | Silcrow Agency Reference/...`. This avoids duplication and the drift that comes with it.

## See also

- `../1 | Canon/accepted/§0012 | Agency and Unit Structure.md` — defines `3 | Silcrow Agency Reference/`'s location and root-only rule.
- `../1 | Canon/accepted/§0011 | Canonical and Operational Artifacts.md` — the canon/operational distinction this folder sits inside.
