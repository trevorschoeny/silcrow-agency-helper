# REFERENCE — {agency_name}

`REFERENCE@<root-unit>/` is the agency's **procedural reference**. It holds the canonical procedural docs that explain how the agency runs: the philosophy, the decision process, the message protocol, the registrar's procedures, and the seven foundational disciplines. Per §0014, REFERENCE lives **only at the agency's root unit**; sub-units inherit by reference (walk up the tree).

## What's here

| File | Purpose |
|---|---|
| `philosophy.md` | The seven foundations synthesized — the scaffold's constitutional text. Read first when you join the agency. |
| `decision-process.md` | How ADRs are proposed, accepted, superseded; the lifecycle every author follows. |
| `message-protocol.md` | Inbox / archive discipline; message kinds; recipient-walk algorithm for broadcasts. |
| `registrar-update-workflow.md` | The 9-step `:silcrow-update` orchestration the Registrar runs. |
| `registrar-audit-checklist.md` | The full audit checklist and report format the Registrar uses. |
| `registrar-scale-partitioning.md` | Guidance for when the record grows large (>200 inbox archives or >hundreds of ADRs). |
| `foundations/` | Seven per-thread treatments of the agency's intellectual lineages — stratified cognition, subsidiarity, actor model, ADRs, legal-citation tradition, registrar pattern, canonical/operational. |

## How REFERENCE differs from CANON

- **CANON** holds **decisions** (ADRs). Subject to §0004's immutability — once accepted, never edited; superseded by new ADRs.
- **REFERENCE** holds **procedural reference**. Mutable. Procedures evolve as the agency learns; edits to REFERENCE files are governance commits per §0017.

Both are canon in the §0013 sense (they bind operational work). But they have different update disciplines.

## How to use

- Load these on demand — they're not preemptive reading.
- Each agent's `AGENTS.md` cites the REFERENCE files most relevant to its role under "Key references" and "Principles to reason from."
- When a procedural question arises that isn't covered by an ADR, walk the relevant REFERENCE doc and reason from foundations.

## REFERENCE is root-only

Sub-units do not have their own REFERENCE folder. Agents in sub-units reference the root unit's REFERENCE by walking up the tree (`@{agency_dir}/REFERENCE@{agency_dir}/...`). This avoids duplication and the drift that comes with it.

## See also

- `../CANON@{unit_name}/accepted/§0014-agency-and-unit-structure.md` — defines REFERENCE's location and root-only rule.
- `../CANON@{unit_name}/accepted/§0013-canonical-and-operational-artifacts.md` — the canon/operational distinction REFERENCE sits inside.
