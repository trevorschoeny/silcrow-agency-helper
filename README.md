# agent-org-scaffold

A Claude Code plugin that scaffolds a disciplined multi-agent project structure with built-in decision tracking (ADRs), actor-model message passing, and registrar-enforced record integrity.

Single skill: **`/agent-org-scaffold:init`**.

## What it does

Run once, at project initialization. The skill:

1. Asks five scoping questions (project name, description, your directory name, whether to rename roles, destination path).
2. Creates a directory structure containing agents, ADRs, proposed-queue, and docs.
3. Writes a **founding record of nine ADRs** (§0001–§0009): §0001 records the decision to adopt the scaffold; §0002–§0009 capture the constitutional decisions inherited through §0001 (ADR format, §-numbering, immutability, inbox messaging, tier model, briefs-not-specs, Registrar authority, anti-patterns as first-class records). Each cites a foundation doc for depth; each can be superseded like any other ADR.
4. Populates eight reference documents covering philosophy, decision-process, message-protocol, registrar-playbook, and deep-dive foundations on the six disciplines the scaffold draws from.

After scaffolding, the generated structure is self-maintaining. **The skill is not re-invoked.** All further work in the scaffolded project flows through its own internal process: messages between agent inboxes, proposals into `proposed/`, decisions into `adr/accepted/` via the Registrar.

## What the scaffold is built on

Six intellectual lineages, each with independent empirical or historical validation:

1. **Stratified Systems Theory** — Elliott Jaques (1956–1996). Hierarchy reflects time horizons of cognitive work.
2. **Subsidiarity** — Aquinas → Taparelli → *Quadragesimo Anno* (1931) → Article 5(3) TEU (2007). Decisions at the lowest competent level.
3. **Actor model** — Hewitt (1973), Agha (1986), Armstrong (2003). Private state, message passing, supervision trees.
4. **Architecture Decision Records** — Nygard (2011), MADR (2017–), Zimmermann Y-statements (2012). Immutable, context-rich decision documents.
5. **Legal citation tradition** — Roman *signum sectionis* through modern Bluebook. §-numbered, monotonic, never-reused identifiers.
6. **Registrar pattern** — University, court, and corporate registrars. Procedural authority over form, separated from substantive decision-making.

Every generated project includes a full `docs/philosophy.md` explaining these, plus `docs/foundations/` with a 3-6 page treatment of each thread.

## Installation

### From Trevor's marketplace

```
/plugin marketplace add trevorschoeny/claude-plugins
/plugin install agent-org-scaffold@trevorschoeny-claude-plugins
```

### From source (development)

```sh
git clone https://github.com/trevorschoeny/agent-org-scaffold
/plugin marketplace add /path/to/agent-org-scaffold
/plugin install agent-org-scaffold@agent-org-scaffold
```

Or trigger conversationally: "scaffold an agent organization," "bootstrap multi-agent org," "initialize agent hierarchy."

## Usage

After installation, start Claude Code in the directory where you want to scaffold a new project (or an empty directory). Then:

```
/agent-org-scaffold:init
```

The skill will ask five questions:

1. Project name.
2. One-sentence description.
3. Your directory name under `agents/` (default: `user`).
4. Whether to rename Lead / Implementer to domain-specific titles.
5. Destination path (default: current directory).

After confirming the answers, the skill creates the structure and exits.

## Scaffold layout

The scaffold produces:

```
<destination>/
├── README.md                      (project orientation)
├── agents/
│   ├── README.md                  (roster)
│   ├── <user-dir>/                (tier 0)
│   │   ├── instructions.md
│   │   └── inbox/archive/
│   ├── <lead-dir>/                (tier 1)
│   │   └── instructions.md, inbox/archive/
│   ├── <implementer-dir>/         (tier 2)
│   │   └── instructions.md, inbox/archive/
│   └── registrar/                 (outside hierarchy)
│       └── instructions.md, inbox/archive/
├── adr/
│   ├── README.md                  (index)
│   ├── _templates/
│   │   ├── madr-full.md
│   │   ├── madr-minimal.md
│   │   └── anti-pattern.md
│   ├── accepted/
│   │   ├── §0001-adopt-agent-org-scaffold.md
│   │   ├── §0002-use-madr-with-y-statement.md
│   │   ├── §0003-use-section-numbering.md
│   │   ├── §0004-immutability-and-supersession.md
│   │   ├── §0005-communication-via-inboxes.md
│   │   ├── §0006-starter-roster-and-tier-model.md
│   │   ├── §0007-briefs-not-specs.md
│   │   ├── §0008-registrar-procedural-authority.md
│   │   └── §0009-anti-patterns-as-first-class-records.md
│   ├── superseded/
│   ├── rejected/
│   └── anti-patterns/README.md
├── proposed/
└── docs/
    ├── philosophy.md              (8–12pp)
    ├── decision-process.md
    ├── message-protocol.md
    ├── registrar-playbook.md
    └── foundations/
        ├── 01-stratified-cognition.md
        ├── 02-subsidiarity.md
        ├── 03-actor-model.md
        ├── 04-architecture-decision-records.md
        ├── 05-legal-citation-tradition.md
        └── 06-registrar-pattern.md
```

## Plugin internals

```
<plugin-root>/                     (this repo)
├── .claude-plugin/
│   └── plugin.json                (plugin manifest)
├── README.md                      (this file)
├── skills/
│   └── init/
│       └── SKILL.md               (skill entrypoint — frontmatter + procedure)
└── scaffold/                      (source-of-truth templates)
    ├── README.md                  (becomes the generated project's README)
    ├── agents/
    ├── adr/
    ├── proposed/
    └── docs/
```

`skills/init/SKILL.md` is what Claude reads when the skill is invoked. It contains the five-phase procedure (pre-flight, scoping, create dirs, interpolate templates, report). The `scaffold/` directory at the plugin root is the template source; files with `{token}` placeholders are interpolated before being written to the destination. The skill references it via `${CLAUDE_PLUGIN_ROOT}/scaffold/`.

## Customization

Templates use `{token}` placeholders substituted at scaffold time:

- `{project_name}`, `{project_description}` — from scoping Q1–Q2.
- `{user_dir}`, `{user_role}` — the user's directory and display name.
- `{lead_dir}`, `{lead_role}` — the Lead role (or its domain-specific rename).
- `{implementer_dir}`, `{implementer_role}` — the Implementer role (or its rename).
- `{date}` — scaffold date.

To customize the scaffold itself — add agents, change templates, modify the philosophy — edit the files in `scaffold/` and they will apply to future invocations. Changes do not affect already-scaffolded projects.

## Rationale

Hierarchical multi-agent systems drift without discipline. Decisions get lost, rationale evaporates, roles blur, and the record of *why* things are the way they are becomes irrecoverable. This scaffold imposes discipline from day one — not as process theatre, but as a compact set of structural commitments grounded in disciplines with decades (or centuries) of validation.

The scaffold is opinionated about *structure* but flexible about *vocabulary*. Roles can be renamed; tiers can be added as the organization grows; the ADR template can be replaced; the folder names can be changed. The load-bearing conventions are the §-numbering discipline, the inbox/archive pattern, the immutability of accepted records, and the separation of form from substance at the Registrar role.

If you are reading this and trying to decide whether to use it, the best orientation is actually the generated `docs/philosophy.md`. It is written for the end user of the scaffold, but it explains the *why* better than anything here can.

## License and attribution

The scaffold draws on named sources throughout its philosophy and foundations documents. Those sources are cited by author, work, and year. The code and templates in this skill are yours to adapt — credit is appreciated but not required.
