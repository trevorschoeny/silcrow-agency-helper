# Registrar — partitioning at scale

Read this file **when the agency's record has grown to the point where partitioning is warranted** — when an agent's `inbox/archive/` exceeds ~200 files, when `accepted/` exceeds a few hundred ADRs, or when one Registrar becomes a bottleneck. Don't load it preemptively.

The core Registrar reference is `../registrar@{unit_name}/AGENTS.md`; this file is scale-specific guidance.

---

## Inbox archive

If an agent's `inbox/archive/` grows past ~200 files, partition by year-quarter:

```
@{unit_name}/{role}@{unit_name}/inbox/archive/
├── 2026-Q1/
├── 2026-Q2/
└── ...
```

Never delete archived messages.

## ADR log

§-numbering is agency-global (or unit-global within a unit). Do **not** restart per partition. When `accepted/` grows past a few hundred files, introduce topic subfolders:

```
@{unit_name}/CANON@{unit_name}/accepted/
├── arch/§0013-...
├── data/§0088-...
└── ops/§0101-...
```

§-numbers stay globally unique. Topic folders are an organizational aid. Citations remain `§0013`; readers use the index to locate.

## Additional Registrars

At scale, one Registrar becomes a bottleneck. The pattern is **fan-out, not strata** (per `foundations/06-registrar-pattern.md`): additional Registrars handle partitioned scopes; each applies the same procedural authority; no "senior Registrar" adjudicates substance.

For cross-partition citations, designate a **Chief Registrar** responsible for resolving cross-partition references and maintaining a global index. Still strictly procedural. A Chief Registrar with substantive authority is an anti-pattern — that's a stratum concern for the decision hierarchy, not a Registrar concern.
