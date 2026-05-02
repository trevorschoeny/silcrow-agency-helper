# Silcrow — Agency Helper

A Claude Code plugin that scaffolds a **Silcrow agency** — a disciplined hierarchical multi-agent organization with ADR decision tracking, actor-model message passing, an async-auditor registrar, canonical/operational artifact discipline, and multi-unit support.

The name **Silcrow** is the traditional typographic name for the `§` symbol (from Latin *signum sectionis*). The plugin's most distinctive discipline is sequential, monotonic, never-reused §-numbered records — a 900-year-old legal-citation tradition applied to agent-organization decisions. You get a silcrow; your agency gets a citation graph.

Three skills:

- **`/silcrow:silcrow-init`** — create a new agency from scratch.
- **`/silcrow:silcrow-add-unit`** — add a new unit (or sub-unit) to an existing agency.
- **`/silcrow:silcrow-update`** — bring an existing agency into conformity with the plugin's current canonical state.

---

## Vocabulary

- **Agency** — the entire organizational tree. Named at onboarding. The agency name labels the whole tree.
- **Root unit** — the topmost node in the tree. Same kind as any unit; the only thing distinguishing it is its position (no parent above it). Shares the agency's name.
- **Unit** — any node in the tree. Has its own canon (`CANON@<unit-name>/`), operational space (`OPS@<unit-name>/`), agents, and optional sub-units. Recursive: a unit may contain sub-units, which may contain sub-units, with no depth limit. Every unit is structurally identical — root or sub-unit, the rules are the same.
- **Sub-unit** — any non-root unit. Lives nested inside its parent unit's directory as a sibling of the parent's agents and governance folders.
- **Agent identity** — `<role>@<unit-name>` (slug, e.g. `lead@acme`) or `<Role> @ <Unit Name>` (prose, e.g. "Lead @ Acme"). Bare role names are ambiguous in any tree with more than one unit.
- **`@<unit-name>/`** — a unit directory. The `@` prefix is the load-bearing programmatic marker; `find -type d -name '@*'` reliably lists every unit and sub-unit. The `<unit-name>` suffix self-identifies the unit.
- **`CANON@<unit-name>/`** — per-unit canonical decision record (ADRs). Immutable per §0004; superseded only.
- **`REFERENCE@<root-unit>/`** — root-only canonical procedural reference (philosophy, foundations, message protocol, registrar workflows). Sub-units inherit by reference.
- **`OPS@<unit-name>/`** — per-unit operational artifacts: code, deliverables, shared work product. Open container.
- **Canonical** (ADRs, REFERENCE) — bind operational work. **Operational** (OPS, agent-private state) — mutable, working.

A single-unit agency (just the root) is the common case. Multi-unit agencies nest `@<sub-unit-name>/` directories inside their parent unit, each with its own flat structure.

---

## Installation

```
/plugin marketplace add trevorschoeny/claude-plugins
/plugin install silcrow@trevorschoeny-claude-plugins
```

Or from source:

```sh
git clone https://github.com/trevorschoeny/silcrow-agency-helper
/plugin marketplace add /path/to/silcrow
/plugin install silcrow@silcrow
```

---

## Usage

### `:silcrow-init` — create an agency

Run in the directory you want to scaffold the agency inside. The skill peeks silently, delivers a short intro, and then converses naturally to gather agency name, description, your role details, any role renames, and any sub-units to seed alongside the root unit. It runs `scripts/scaffold.sh` to create the root unit's `@<agency-name>/` directory inside the current working directory, initializes git with a minimal `.gitignore`, and commits. If sub-units were named, it then runs `scripts/add-unit.sh` once per sub-unit.

The generated agency ships a **founding record of 20 ADRs** (§0001 + 19 constitutional decisions §0002–§0020, with §0008 superseded by §0011). Each ADR cites a foundation doc; each can be superseded like any other.

### `:silcrow-add-unit` — add a sub-unit

Run inside any existing unit's directory (root or otherwise) to add a sub-unit beneath it. The skill walks up to find the parent unit's `@<parent-unit-name>/` directory, converses to gather the sub-unit's details, and runs `scripts/add-unit.sh` — which authors an establishing ADR in the parent's `CANON@<parent-unit-name>/accepted/` and scaffolds the sub-unit's flat structure (CANON@, OPS@, agents, README) nested inside the parent unit.

### `:silcrow-update` — reconcile with the plugin's current state

Intentionally thin. Confirms an agency exists, drops one message in the Registrar's inbox pointing at `${CLAUDE_PLUGIN_ROOT}/scaffold/unit/`, and exits. The Registrar does the real work: dynamic diff, per-item approval dialogue with User and Lead, execution of approved changes, one audit ADR (§0015) summarizing accepts/rejects/deferrals, one structured commit (§0017). No version tracking — every invocation diffs against current plugin state.

---

## Seven intellectual lineages

1. **Stratified Systems Theory** — Elliott Jaques. Hierarchy reflects time horizons of cognitive work.
2. **Subsidiarity** — Aquinas → *Quadragesimo Anno* (1931) → Article 5(3) TEU. Decisions at the lowest competent level.
3. **Actor model** — Hewitt (1973), Agha, Armstrong. Private state, message passing, supervision.
4. **Architecture Decision Records** — Nygard (2011), MADR, Zimmermann Why-statements. Immutable, context-rich decisions.
5. **Legal citation tradition** — Roman *signum sectionis* through modern Bluebook. §-numbered, monotonic, never-reused.
6. **Registrar pattern** — University, court, corporate registrars. Procedural authority over form, separated from substance. Async auditor mode preserves that separation without sync gatekeeping.
7. **Canonical/operational split** — Buchanan, Hart, Popper, Ostrom, Nygard, Agile. Canon binds operational, never the reverse.

Every generated agency includes `@<agency-name>/REFERENCE@<agency-name>/philosophy.md` (full synthesis) and `@<agency-name>/REFERENCE@<agency-name>/foundations/` (per-thread intellectual history).

---

## Scaffold layout — a new agency

```
@<agency-name>/                                ← root unit (shares the agency's name)
├── @<sub-unit-name>/                          ← (optional) sub-units, recursive same shape
│   └── ...
├── CANON@<agency-name>/                       ← decisions (per-unit; immutable)
│   ├── accepted/, proposed/, superseded/, rejected/, anti-patterns/, _templates/
│   │   └── accepted/ ships §0001–§0020 (§0008 in superseded/)
│   └── README.md                              ← decision index
├── OPS@<agency-name>/                         ← operational artifacts (per-unit; open container)
│   └── README.md
├── README.md                                  ← unit overview
├── REFERENCE@<agency-name>/                   ← procedural reference (root only; mutable)
│   ├── philosophy.md, decision-process.md, message-protocol.md
│   ├── registrar-update-workflow.md, registrar-audit-checklist.md, registrar-scale-partitioning.md
│   ├── foundations/01–07
│   └── README.md
├── <user>@<agency-name>/                      ← agents (each with AGENTS.md + inbox/archive/)
├── <lead>@<agency-name>/
├── <implementer>@<agency-name>/
└── registrar@<agency-name>/
```

Every unit follows §0014's flat layout — agents and governance folders coexist at the unit's top level, distinguished by capitalization (UPPERCASE for governance, lowercase for agents). Direct-child folders carry the `@<unit-name>` suffix; subfolders (accepted/, foundations/, inbox/, etc.) do not. `REFERENCE@<unit>/` lives only at the root unit; sub-units inherit by reference. The pattern is identical at every depth.

ASCII sort at any unit's root: `@<sub-units>/` → `CANON@<unit>/` → `OPS@<unit>/` → `README.md` → `REFERENCE@<unit>/` → lowercase agent dirs.

---

## Plugin internals

```
<plugin-root>/
├── .claude-plugin/plugin.json
├── skills/{init,add-unit,update}/SKILL.md
├── scripts/{scaffold,add-unit}.sh
└── scaffold/unit/              ← source-of-truth governance templates
```

`scripts/scaffold.sh` copies `scaffold/unit/` into a user's agency, substituting `{agency_name}`, `{agency_description}`, `{agency_dir}`, `{user_dir}`, `{user_role}`, `{lead_dir}`, `{lead_role}`, `{implementer_dir}`, `{implementer_role}`, `{unit_name}`, `{unit_display}`, and `{date}` — and renaming source folders to their `@<unit-name>` suffixed forms (`CANON/` → `CANON@<unit>/`, `lead/` → `<lead-dir>@<unit>/`, etc.) per §0014. `scripts/add-unit.sh` renders `establish-unit.md` into a new establishing ADR and scaffolds the sub-unit's flat structure nested inside the parent unit. `:silcrow-update` diffs `scaffold/unit/` directly against an existing agency (no staging).

To customize: edit `scaffold/unit/`; changes apply to future `:silcrow-init` invocations and propagate to existing agencies via `:silcrow-update`. The Registrar role name is always `Registrar` — it's part of the pattern; everything else is flexible.

---

## Rationale

Hierarchical multi-agent systems drift without discipline. Decisions get lost, rationale evaporates, roles blur. This scaffold imposes discipline from day one — not as process theatre, but as a compact set of structural commitments with decades (or centuries) of independent validation.

The scaffold is opinionated about **structure** and flexible about **vocabulary**. The load-bearing conventions are: §-numbering, inbox/archive pattern, immutability of accepted records, form/substance separation at the Registrar, and the canonical/operational split.

If you're deciding whether to use it, read the generated `@<agency-name>/REFERENCE@<agency-name>/philosophy.md` — it explains the *why* better than anything here can.

---

## License and attribution

The scaffold cites named sources throughout its philosophy and foundations docs. The code and templates are yours to adapt — credit is appreciated but not required.
