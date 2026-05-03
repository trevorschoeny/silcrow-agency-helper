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
- **Unit** — any node in the tree. Has its own canon (`1 | Canon/`), operational space (`2 | Working Files/`), agents, and optional sub-units. Recursive: a unit may contain sub-units, which may contain sub-units, with no depth limit. Every unit is structurally identical — root or sub-unit, the rules are the same.
- **Sub-unit** — any non-root unit. Lives nested inside its parent unit's directory as a sibling of the parent's agents and governance folders.
- **Agent identity** — `<Role> @ <Unit Name>` (e.g. `Lead @ Acme`, `Trevor @ Pebble Core`). Both directory name and prose form. One name per concept.
- **`@ <Unit Name>/`** — a unit directory. The `@ ` prefix is the load-bearing programmatic marker; `find -type d -name '@*'` reliably lists every unit and sub-unit.
- **`1 | Canon/`** — per-unit canonical decision record (ADRs). Immutable per §0004; superseded only.
- **`2 | Working Files/`** — per-unit operational artifacts: code, deliverables, shared work product. Open container.
- **`3 | Silcrow Agency Reference/`** — root-only canonical procedural reference (philosophy, foundations, message protocol, registrar workflows). Sub-units inherit by reference.
- **Canonical** (`1 | Canon/`, `3 | Silcrow Agency Reference/`) — bind operational work. **Operational** (`2 | Working Files/`, agent-private state) — mutable, working.

A single-unit agency (just the root) is the common case. Multi-unit agencies nest `@ <Sub Unit Name>/` directories inside their parent unit, each with its own flat structure.

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

Run in the directory you want to scaffold the agency inside. The skill peeks silently, delivers a short intro, and then converses naturally to gather agency name, description, your role details, any role renames, and any sub-units to seed alongside the root unit. It runs `scripts/scaffold.sh` to create the root unit's `@ <Agency Name>/` directory inside the current working directory, initializes git with a minimal `.gitignore`, and commits. If sub-units were named, it then runs `scripts/add-unit.sh` once per sub-unit.

The generated agency ships a **founding record of 17 ADRs** (§0001 + 16 constitutional decisions §0002–§0017). Each ADR cites a foundation doc; each can be superseded like any other.

### `:silcrow-add-unit` — add a sub-unit

Run inside an existing unit's directory (the one named `@ <Unit Name>/`, root or otherwise) to add a sub-unit nested inside it. The skill reads the unit's `silcrow-meta` README anchor for the agency name and role values, converses to gather the sub-unit's details, and runs `scripts/add-unit.sh` — which authors an establishing ADR in the parent's `1 | Canon/accepted/` and scaffolds the sub-unit's flat structure (`1 | Canon`, `2 | Working Files`, agent dirs, README) nested inside the parent unit.

### `:silcrow-add-agent` — add an agent to a unit

Run inside the **Lead's directory** of any unit (e.g., `<Lead Role> @ <Unit Name>/`) to add a new agent (role) to that unit. Adding an agent is a roster change (§0008): it requires an establishing ADR, redistribution of work from existing agents, and updates to the unit's coordination structure. The skill converses to gather the new agent's purpose, responsibilities, and reporting line; composes the new agent's `AGENTS.md` plus trims/additions to existing agents' `AGENTS.md`; and shows everything as one consolidated diff before applying. On approval it runs `scripts/add-agent.sh` for the mechanics (directory + establishing ADR), applies the substantive `AGENTS.md` edits, and commits as one governance commit per §0015. Refuses if invoked from any other agent's session — Registrar audits afterwards, but only the Lead can author the redistribution.

### `:silcrow-update` — reconcile with the plugin's current state

Intentionally thin. Confirms an agency exists, drops one message in the Registrar's inbox pointing at `${CLAUDE_PLUGIN_ROOT}/scaffold/unit/`, and exits. The Registrar does the real work: dynamic diff, per-item approval dialogue with User and Lead, execution of approved changes, one audit ADR (§0013) summarizing accepts/rejects/deferrals, one structured commit (§0015). No version tracking — every invocation diffs against current plugin state.

---

## Seven intellectual lineages

1. **Stratified Systems Theory** — Elliott Jaques. Hierarchy reflects time horizons of cognitive work.
2. **Subsidiarity** — Aquinas → *Quadragesimo Anno* (1931) → Article 5(3) TEU. Decisions at the lowest competent level.
3. **Actor model** — Hewitt (1973), Agha, Armstrong. Private state, message passing, supervision.
4. **Architecture Decision Records** — Nygard (2011), MADR, Zimmermann Why-statements. Immutable, context-rich decisions.
5. **Legal citation tradition** — Roman *signum sectionis* through modern Bluebook. §-numbered, monotonic, never-reused.
6. **Registrar pattern** — University, court, corporate registrars. Procedural authority over form, separated from substance. Async auditor mode preserves that separation without sync gatekeeping.
7. **Canonical/operational split** — Buchanan, Hart, Popper, Ostrom, Nygard, Agile. Canon binds operational, never the reverse.

Every generated agency includes `@ <Agency Name>/3 | Silcrow Agency Reference/Philosophy.md` (full synthesis) and `@ <Agency Name>/3 | Silcrow Agency Reference/foundations/` (per-thread intellectual history).

---

## Scaffold layout — a new agency

```
@ <Agency Name>/                                ← root unit (shares the agency's name)
├── @ <Sub Unit Name>/                          ← (optional) sub-units, recursive same shape
│   └── ...
├── 1 | Canon/                                  ← decisions (per-unit; immutable)
│   ├── accepted/, proposed/, superseded/, rejected/, _templates/
│   │   └── accepted/ ships §0001–§0017
│   └── README.md                               ← decision index
├── 2 | Working Files/                          ← operational artifacts (per-unit; open container)
│   └── README.md
├── 3 | Silcrow Agency Reference/               ← procedural reference (root only; mutable)
│   ├── Philosophy.md, Decision Process.md, Message Protocol.md
│   ├── Registrar Update Workflow.md, Registrar Audit Checklist.md, Registrar Scale Partitioning.md
│   ├── foundations/01–07
│   └── README.md
├── README.md                                   ← unit overview
├── <User Name> @ <Agency Name>/                ← user (with AGENTS.md + inbox/archive/)
├── <Lead Role> @ <Agency Name>/                ← Lead agent
├── <Implementer Role> @ <Agency Name>/         ← Implementer agent
└── Registrar @ <Agency Name>/                  ← Registrar (fixed name)
```

Every unit follows §0012's flat layout. Unit and sub-unit directories carry the `@ ` prefix. Governance folders use the numeric-prefix `1 | / 2 | / 3 | ` scheme — same names in every unit, no per-unit suffix. Agent directories are `<Role> @ <Unit Name>/`. `3 | Silcrow Agency Reference/` lives only at the root unit; sub-units inherit by reference. The pattern is identical at every depth.

Sort at any unit's root: `@ <Sub Units>/` → `1 | Canon/` → `2 | Working Files/` → `3 | Silcrow Agency Reference/` (root only) → `<Role> @ <Unit>/` (alphabetical) → `README.md` (file).

---

## Plugin internals

```
<plugin-root>/
├── .claude-plugin/plugin.json
├── skills/{init,add-unit,update}/SKILL.md
├── scripts/{scaffold,add-unit}.sh
└── scaffold/unit/              ← source-of-truth governance templates
```

`scripts/scaffold.sh` copies `scaffold/unit/` into a user's agency, substituting `{agency_name}`, `{agency_description}`, `{user_role}`, `{lead_role}`, `{implementer_role}`, `{unit_name}`, and `{date}` into prose; the governance folders (`1 | Canon`, `2 | Working Files`, `3 | Silcrow Agency Reference`) keep their plugin-source names verbatim, and the agent template folders (`Lead/`, `Implementer/`, `Registrar/`, `User/`) become per-agent dirs `<Role Name> @ <Unit Name>/`. `scripts/add-unit.sh` renders `Establish Unit.md` into a new establishing ADR and scaffolds the sub-unit's flat structure nested inside the parent unit. `:silcrow-update` diffs `scaffold/unit/` directly against an existing agency (no staging).

To customize: edit `scaffold/unit/`; changes apply to future `:silcrow-init` invocations and propagate to existing agencies via `:silcrow-update`. The Registrar role name is always `Registrar` — it's part of the pattern; everything else is flexible.

---

## Rationale

Hierarchical multi-agent systems drift without discipline. Decisions get lost, rationale evaporates, roles blur. This scaffold imposes discipline from day one — not as process theatre, but as a compact set of structural commitments with decades (or centuries) of independent validation.

The scaffold is opinionated about **structure** and flexible about **vocabulary**. The load-bearing conventions are: §-numbering, inbox/archive pattern, immutability of accepted records, form/substance separation at the Registrar, and the canonical/operational split.

If you're deciding whether to use it, read the generated `@ <Agency Name>/3 | Silcrow Agency Reference/Philosophy.md` — it explains the *why* better than anything here can.

---

## License and attribution

The scaffold cites named sources throughout its philosophy and foundations docs. The code and templates are yours to adapt — credit is appreciated but not required.
