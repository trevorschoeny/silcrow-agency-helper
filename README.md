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
- **Unit** — any node in the tree. Has its own governance (`#ORG/`), agents, and operational work. Recursive: a unit may contain sub-units, which may contain sub-units, with no depth limit. Every unit is structurally identical — root or sub-unit, the rules are the same.
- **Sub-unit** — any non-root unit. Lives nested inside its parent unit's directory.
- **Agent identity** — `<role>@<unit>` (slug, e.g. `lead@acme`) or `<Role> @ <Unit>` (prose, e.g. "Lead @ Acme"). Bare role names are ambiguous in any tree with more than one unit.
- **`#ORG/`** — the governance folder of any unit. Contains only decisions, agent instructions, and docs. Never operational content.
- **`@<unit>/`** — a unit directory. `@` prefix for visual distinction; the `#ORG/` inside is the programmatic marker.
- **Canonical** (ADRs) — immutable, citable, stable. **Operational** (everything else) — mutable, working.

A single-unit agency (just the root) is the common case. Multi-unit agencies have `@<sub-unit>/` directories nested inside their parent, each with its own `#ORG/`.

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

Run in the directory you want to scaffold (or an empty directory). The skill peeks silently, delivers a short intro, and then converses naturally to gather agency name, description, your role details, any role renames, and any sub-units to seed alongside the root unit. It runs `scripts/scaffold.sh` to create the root unit's `#ORG/`, initializes git with a minimal `.gitignore`, and commits. If sub-units were named, it then runs `scripts/add-unit.sh` once per sub-unit.

The generated agency ships a **founding record of 19 ADRs** (§0001 + 18 constitutional decisions §0002–§0019, with §0008 superseded by §0012). Each ADR cites a foundation doc; each can be superseded like any other.

### `:silcrow-add-unit` — add a sub-unit

Run inside any existing unit's directory (root or otherwise) to add a sub-unit beneath it. The skill walks up to find the parent `#ORG/`, converses to gather the sub-unit's details, and runs `scripts/add-unit.sh` — which authors an establishing ADR in the parent's `#ORG/adr/accepted/` and scaffolds the sub-unit's own `#ORG/`.

### `:silcrow-update` — reconcile with the plugin's current state

Intentionally thin. Confirms an agency exists, drops one message in the Registrar's inbox pointing at `${CLAUDE_PLUGIN_ROOT}/scaffold/#ORG/`, and exits. The Registrar does the real work: dynamic diff, per-item approval dialogue with User and Lead, execution of approved changes, one audit ADR (§0016) summarizing accepts/rejects/deferrals, one structured commit (§0018). No version tracking — every invocation diffs against current plugin state.

---

## Seven intellectual lineages

1. **Stratified Systems Theory** — Elliott Jaques. Hierarchy reflects time horizons of cognitive work.
2. **Subsidiarity** — Aquinas → *Quadragesimo Anno* (1931) → Article 5(3) TEU. Decisions at the lowest competent level.
3. **Actor model** — Hewitt (1973), Agha, Armstrong. Private state, message passing, supervision.
4. **Architecture Decision Records** — Nygard (2011), MADR, Zimmermann Y-statements. Immutable, context-rich decisions.
5. **Legal citation tradition** — Roman *signum sectionis* through modern Bluebook. §-numbered, monotonic, never-reused.
6. **Registrar pattern** — University, court, corporate registrars. Procedural authority over form, separated from substance. Async auditor mode preserves that separation without sync gatekeeping.
7. **Canonical/operational split** — Buchanan, Hart, Popper, Ostrom, Nygard, Agile. Canon binds operational, never the reverse.

Every generated agency includes `#ORG/docs/philosophy.md` (full synthesis) and `#ORG/docs/foundations/` (per-thread intellectual history).

---

## Scaffold layout — a new agency

```
@<agency>/                              ← root unit (shares the agency's name)
├── #ORG/                               ← governance (sorts first, ASCII 35)
│   ├── README.md                       ← root-unit orientation
│   ├── agents/{user,lead,implementer,registrar}@<agency>/
│   │   └── AGENTS.md + inbox/archive/
│   ├── adr/{accepted,proposed,superseded,rejected,anti-patterns,_templates}/
│   │   └── accepted/ ships §0001–§0019 (§0008 in superseded/)
│   └── docs/
│       ├── philosophy.md, decision-process.md, message-protocol.md
│       └── foundations/01–07
├── @<sub-unit-1>/                      ← (optional) each with its own #ORG/
└── (operational artifacts)             ← your codebase, plans, research
```

Every unit — root or sub-unit — has the same shape: a `#ORG/` for governance, optional nested `@<sub-unit>/` directories, and operational artifacts alongside. Sort order at any depth: `#ORG/` first, then `@<sub-units>/`, then operational content — deterministic across shells.

---

## Plugin internals

```
<plugin-root>/
├── .claude-plugin/plugin.json
├── skills/{init,add-unit,update}/SKILL.md
├── scripts/{scaffold,add-unit}.sh
└── scaffold/#ORG/              ← source-of-truth governance templates
```

`scripts/scaffold.sh` copies `scaffold/#ORG/` into a user's agency, substituting `{agency_name}`, `{agency_description}`, `{agency_dir}`, `{user_dir}`, `{user_role}`, `{lead_dir}`, `{lead_role}`, `{implementer_dir}`, `{implementer_role}`, `{unit_name}`, `{unit_display}`, and `{date}`. `scripts/add-unit.sh` renders `establish-unit.md` into a new establishing ADR and scaffolds the sub-unit's `#ORG/`. `:silcrow-update` diffs `scaffold/#ORG/` directly against an existing agency (no staging).

To customize: edit `scaffold/#ORG/`; changes apply to future `:silcrow-init` invocations and propagate to existing agencies via `:silcrow-update`. The Registrar role name is always `Registrar` — it's part of the pattern; everything else is flexible.

---

## Rationale

Hierarchical multi-agent systems drift without discipline. Decisions get lost, rationale evaporates, roles blur. This scaffold imposes discipline from day one — not as process theatre, but as a compact set of structural commitments with decades (or centuries) of independent validation.

The scaffold is opinionated about **structure** and flexible about **vocabulary**. The load-bearing conventions are: §-numbering, inbox/archive pattern, immutability of accepted records, form/substance separation at the Registrar, and the canonical/operational split.

If you're deciding whether to use it, read the generated `#ORG/docs/philosophy.md` — it explains the *why* better than anything here can.

---

## License and attribution

The scaffold cites named sources throughout its philosophy and foundations docs. The code and templates are yours to adapt — credit is appreciated but not required.
