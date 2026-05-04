# §0012 | Agency and unit structure; flat `@ <Unit>/` convention

- **Status:** accepted
- **Date:** {date}
- **Agency:** {agency_name}
- **Unit:** {unit_name}
- **Authors:** scaffold initialization (inherited via §0001)
- **Supersedes:** —
- **Superseded by:** —
- **Influences:** every directory layout; every inbox path; every ADR-to-directory audit; the `:silcrow-init` skill; the `:silcrow-add-unit` skill; the `:silcrow-add-agent` skill; the `:silcrow-update` skill's structural migrations.
- **Influenced by:** §0001, §0005, §0008, §0011

## Why-statement

In the context of **agencies whose tree of units may range from a single root unit to arbitrarily-nested multi-unit structures, used by people across many domains — not just developers**,
facing the need for a consistent, recursive structural convention that keeps governance distinguishable from operational work, makes units identifiable by tooling, stays shallow enough that agents — accessed daily — are reachable in fewer clicks, and reads naturally to non-technical users,
we decided for **a flat unit layout with English Title-case names**: the unit's directory is `@ <Unit Name>/`, its top-level children are agent directories (`<Role> @ <Unit Name>/`), governance folders (`1 | Canon/`, `2 | Working Files/`, `3 | Silcrow Agency Reference/` at root only), sub-unit directories (`@ <Sub Unit Name>/`), and a `README.md`; unit and sub-unit directories carry the `@ ` prefix; agent directories carry their role name with `@` flanked by spaces; governance folders are constants (the same names in every unit, with numeric prefixes for visual ordering); and unit detection is by the `@` prefix on a directory name,
and neglected a wrapper-folder layout, a slug-based scheme (`@pebble/`, `lead@pebble/`, `CANON@pebble/`), suffix-on-governance for self-identification, and a sentinel-file marker for unit detection,
to achieve a structure that's shallow at the agent layer (inboxes are two directory levels from the unit's root, not four), recursively identical at every depth, programmatically identifiable (`@*` prefix on a directory = unit), readable to a non-developer at a glance, and visually ordered (sub-units sort first, numeric-prefixed governance next, agents alphabetically),
accepting that paths now contain spaces, `@`, and `|` throughout — requiring rigorous quoting in every script and template — and that governance folders no longer self-identify through a per-unit suffix (the parent directory's `@ <Unit Name>` carries the unit identity instead),
because (1) silcrow is for everyone, not just developers, and English Title-case names read better than developer-shorthand slugs; (2) shallow paths to frequently-accessed locations matter for daily operators; (3) the canon/operational split (§0011) doesn't require a wrapper folder — it requires a clear convention, which the numeric-prefix scheme provides; and (4) once the quoting cost is paid for any one directory with a space in its name, paying it everywhere yields a consistent, readable scaffold.

## Context and problem statement

The plugin needs a unit structure that:

- **Stays shallow at the agent layer.** Operators interact with agents and their inboxes daily. A four-deep path imposes friction that compounds across an agency's lifetime.
- **Distinguishes governance from operational without an extra folder level.** §0011's canon/operational split is load-bearing, but enforcing it through a wrapper directory adds depth.
- **Identifies units programmatically.** Tooling — the registrar's audit, the silcrow skills' unit-detection logic — needs to recognize what's a unit and what isn't.
- **Recurses cleanly.** A sub-unit should be structurally identical to its parent. No special-casing depth.
- **Reads naturally to a non-developer.** A wedding planner, a healthcare initiative, or a research lab using silcrow should not have to learn slug conventions or shell shorthand to navigate their own agency.
- **Self-identifies enough that the parent context is recoverable.** Opening a folder standalone in an editor or file manager should reveal the unit it belongs to (via the parent dir's name, since the governance folders themselves are constants).

## Decision drivers

- **Accessibility to non-developers.** The single largest driver. English Title-case names beat slug shorthand for the broad audience silcrow serves.
- **Shallow paths to frequently-accessed locations.** Agents are touched constantly; inbox paths land two levels below the unit, not four.
- **Visible canon/operational split (§0011) without an extra folder level.** Numeric-prefix naming replaces the wrapper.
- **Programmatic unit identification.** A directory's `@` prefix in its own basename is the marker.
- **Recursive pattern.** Every unit looks the same regardless of depth (with one exception for `3 | Silcrow Agency Reference`, below).
- **Visually-ordered listings.** The numeric-prefix scheme plus `@` prefix for sub-units gives a deterministic three-tier sort in Finder and most IDEs.

## Vocabulary

- **Agency** — the whole organizational tree. Named by the user at onboarding. The agency name labels the entire tree; the root unit shares this name.
- **Root unit** — the topmost unit. Same kind as any unit; distinguished only by position (no parent above). Its directory is `@ <Agency Name>/`.
- **Unit** — any node in the agency's tree. Has its own canon (`1 | Canon/`), operational space (`2 | Working Files/`), agents, optional sub-units. Recursive: a unit may contain sub-units, with no depth limit. Every unit is structurally identical regardless of depth, with the sole exception of `3 | Silcrow Agency Reference/` (below).
- **Sub-unit** — any non-root unit. Lives nested inside its parent unit's directory as a sibling of the parent's agents and governance folders.
- **Agent identity** — `<Role> @ <Unit Name>` for both directory paths and prose narrative (e.g. `Lead @ Pebble`, `Trevor @ Pebble Core`). One name per concept; no separate slug-vs-display form.
- **`1 | Canon/`** — the unit's canonical decisions. Holds `accepted/`, `proposed/`, `superseded/`, `rejected/`, `_templates/`, and a `README.md` index. Per-unit (every unit has one). Subject to §0004's immutability and supersession discipline.
- **`2 | Working Files/`** — operational artifacts: code, deliverables, shared work product, anything that isn't governance and isn't private to a single agent. Per-unit. Open container with no prescribed sub-structure.
- **`3 | Silcrow Agency Reference/`** — canonical procedural reference (philosophy, foundations, message protocol, decision process, registrar workflows). **Root unit only**; every other unit inherits it by reference to the root's path. Mutable, unlike `1 | Canon/`.
- **Direct-child folder of a unit** — any folder placed at the unit's root: agent directory, sub-unit directory, or governance folder.
- **Subfolder** — any folder deeper than direct-child level (e.g., `accepted/`, `foundations/`, `inbox/`). Plain names; no prefix.

## Considered options and decision

1. **A wrapper-folder layout where governance is nested one level deep behind a single governance directory.** Rejected: the wrapper costs an extra directory level on every path. Operators report friction navigating agent inboxes daily. The wrapper's purpose (visible canon/operational split) is accomplishable through naming convention without an extra folder.

2. **Slug-based naming with `@<unit>` and `<role>@<unit>` directories, capitalization to distinguish governance.** Rejected: developer-shorthand slugs do not serve silcrow's broader audience. Wedding planners, healthcare initiatives, and research labs should not have to learn that `CANON@pebble` is "the canonical decisions of the Pebble unit"; that's a developer's reading. English Title-case is more accessible at modest scripting cost.

3. **Flat layout with English Title-case names throughout, numeric-prefix governance, `@` prefix on units (chosen).** Agents reachable two levels below the unit (`@ Unit/Role @ Unit/inbox/`); canon/operational split visible through numeric-prefix governance plus `2 | Working Files/` as the operational container; sub-units, agents, governance, README all coexist under one roof in a deterministic visual order. Unit detection is the `@` prefix on a directory's own basename.

4. **Flat layout but with hyphen, em-dash, or no separator on governance** (e.g., `1 - Canon`, `1 — Canon`, `1 Canon`). Rejected in favor of pipe (`|`): pipe is visually distinctive (vs. word-internal hyphens) and easy to type (Shift+\\); em-dash requires special-character knowledge; bare-space looks accidental.

5. **Sentinel file (`.unit`) as the unit marker instead of `@` prefix.** Rejected: hidden files are easy to ignore in directory listings; the visible `@` prefix is a stronger structural signal. `find -name '@*'` from above the unit reliably matches unit dirs without needing to read file contents.

### Principles

#### Unit and sub-unit directories are `@ <Title Case Name>/`

A unit's directory begins with `@` followed by a single space and the unit's English Title-case name (e.g., `@ Pebble`, `@ Pebble Core`). Sub-units follow the same convention recursively, nested inside their parent unit's directory.

#### Agent directories are `<Role> @ <Unit Name>/`

The agent's display role (e.g., `Lead`, `Trevor`, `Implementer`) is followed by ` @ ` (space, `@`, space) and the unit's name. The role is whatever the user chose at scaffolding; it's the literal directory name *and* the literal prose name (one concept, one form). Examples: `Lead @ Pebble`, `Implementer @ Pebble Core`, `Trevor @ Pebble`.

The Registrar role name is fixed across every unit — `Registrar`, never renamed. Other roles are flexible at scaffold time and can be changed via the roster-change protocol (§0008).

#### Governance folders are constants with numeric prefixes

Governance folders use the same names in every unit:

- `1 | Canon/` — canonical decisions
- `2 | Working Files/` — operational artifacts
- `3 | Silcrow Agency Reference/` — procedural reference (root unit only)

The numeric prefix gives a deterministic visual order. The pipe (`|`) separator is distinctive (not a word-internal hyphen) and easy to type. The names are constants — they are *not* per-unit-suffixed. Opening `1 | Canon/` standalone does not by itself reveal which unit's canon it holds; the parent directory (`@ <Unit Name>/`) carries that identity.

#### Sub-units live as siblings of their parent's agents and governance folders

A sub-unit's directory is at the parent unit's top level — alongside agents, `1 | Canon/`, `2 | Working Files/`, `3 | Silcrow Agency Reference/` (root only). Sub-units are not nested inside any governance folder; they're peers of governance.

The sub-unit's existence is registered as an ADR in the parent unit's `1 | Canon/accepted/` (template at `1 | Canon/_templates/Establish Unit.md`). Adding a unit requires both:

1. An accepted ADR in the parent's `1 | Canon/accepted/`.
2. The physical sub-unit directory `@ <Sub Unit Name>/` with its own flat structure.

The Registrar audits the pair. A sub-unit directory without its registering ADR is flagged (orphaned implementation). An ADR declaring a sub-unit that has no directory is flagged (unexecuted decision). This is the canon/operational split (§0011) made structural — the ADR is the canonical fact; the directory is the operational manifestation.

#### `3 | Silcrow Agency Reference/` is root-only; sub-units inherit by reference

Foundational documents (`Philosophy.md`, `Decision Process.md`, `Message Protocol.md`, registrar workflows, `foundations/`) live at the root unit's `3 | Silcrow Agency Reference/`. Sub-units do not duplicate them; agents in sub-units reference the root's folder directly via `@ {agency_name}/3 | Silcrow Agency Reference/`.

This is the one shape exception to the "every unit is structurally identical" rule: sub-units have `1 | Canon/`, `2 | Working Files/`, agents, sub-units, README — but no `3 | Silcrow Agency Reference/`. The agency's foundational reference is shared, not duplicated.

#### `1 | Canon/` contains canonical decisions (immutable, supersession-only)

`1 | Canon/` is the per-unit decision record. Its `accepted/` ADRs are immutable per §0004; superseded ADRs move to `superseded/` with a cross-link. The `_templates/` folder holds patterns for new ADRs.

Anti-patterns are recorded as regular ADRs alongside positive decisions — same numbering, same lifecycle, same folder. The polarity of a decision (positive or negative) is a property of its content, not a category that needs its own bucket.

#### `3 | Silcrow Agency Reference/` contains canonical procedural reference (mutable)

Unlike ADRs, reference docs may be edited as procedures evolve. They are canon in the sense that they bind agents (§0011), but they are not point-in-time decision records under §0004's supersession rules. Edits to reference files are governance commits and follow §0015.

#### `2 | Working Files/` is an open container for operational artifacts

`2 | Working Files/` holds anything operational at the unit level: code repositories, deliverables, shared reference material agents need, anything that isn't private to a single agent. Per §0005's actor-model discipline, agents iterate privately in their own folders; once material is ready to be shared, it is published to `2 | Working Files/`. The folder doesn't prescribe sub-structure.

If the unit's operational work involves a codebase that lives in a separate git repo elsewhere on disk, it can be referenced from `2 | Working Files/README.md` rather than physically nested. The scaffold is agnostic about whether code lives inside the unit or outside; it provides governance, and code lives wherever the user wants.

### Naming conventions and sort order

- **`@ <Unit Name>/`** — unit and sub-unit directories. The `@` (ASCII 0x40) sorts after digits (0x30–0x39) and before uppercase letters (0x41–0x5A). In Finder's natural sort, `@ <Name>` directories cluster together at the top of a parent unit's listing, before numeric-prefix governance.
- **`1 | Canon/`, `2 | Working Files/`, `3 | Silcrow Agency Reference/`** — numeric-prefix governance. The numeric prefix gives a fixed canonical-then-operational-then-reference order.
- **`<Role> @ <Unit Name>/`** — agent directories. Title-case role names sort alphabetically after the numeric-prefix governance in Finder's sort.
- **`README.md`** — the unit's overview file. Files separate from folders in folder-grouping IDEs (VS Code, Cursor, JetBrains), placing `README.md` alone at the bottom.

The deterministic listing order at any unit's root, in Finder/macOS sort: `@ <Sub Units>/` → `1 | Canon/` → `2 | Working Files/` → `3 | Silcrow Agency Reference/` (root only) → `<Role> @ <Unit>/` (alphabetical) → `README.md`. In folder-grouping views: same minus `README.md`, which drops to the file section.

### Unit-name constraints

A `<Unit Name>` must satisfy:

- **English Title-case.** First letter of each major word capitalized; articles, prepositions, and conjunctions under five letters lowercase except as the first or last word.
- **Letters, digits, spaces, and within-word hyphens.** No `/` (filesystem-prohibited), no `@` (reserved as the unit-prefix character), no `|` (reserved as the governance-prefix separator). Other punctuation (apostrophes, ampersands, etc.) is permitted but creates quoting friction in scripts and is best avoided.
- **Practical length cap of 64 characters.** Enforced for filesystem and tooling sanity.

Examples: `Pebble`, `Pebble Core`, `Open-Source Initiative`, `Acme Co`. Non-examples: `pebble` (not Title-case), `Pebble@Core` (`@` reserved), `Pebble | Core` (`|` reserved), `Pebble/Core` (slash forbidden).

### Official unit identification: `@` prefix on the directory's basename

Any directory whose own basename starts with `@` is a unit.

- `find -type d -name '@*'` reliably matches unit directories.
- Agent directories (`<Role> @ <Unit Name>/`) have `@` mid-string, not as a prefix; they don't match.
- Governance folders (`1 | Canon/`, `2 | Working Files/`, `3 | Silcrow Agency Reference/`) start with digits; they don't match.
- The unit's own `@ <Unit Name>/` matches; nested sub-units `@ <Sub Unit Name>/` match.

### Operational artifacts

- **Default:** inside `2 | Working Files/` at the unit level.
- **Allowed:** any path under `2 | Working Files/` — repositories, document collections, working sets. The scaffold doesn't mandate sub-structure inside.
- **External operational artifacts** (Google Drive, external shared filesystem, separate codebase repos, etc.) are allowed per §0005's actor-model spirit; agents reference them rather than mirror them.

### Consequences

- **Positive:** A non-developer can navigate the scaffold and read what each folder is for at a glance. "Canon", "Working Files", and "Silcrow Agency Reference" are plain English; `Lead @ Pebble` reads naturally as "Lead at Pebble."
- **Positive:** Agent paths are two directory levels from the unit's root (`@ Unit/Role @ Unit/inbox/`). The scaffold's most-trafficked paths are shallow.
- **Positive:** Numeric-prefix governance gives a deterministic, intuitive order (canon first, then operational, then reference).
- **Positive:** Unit detection is a one-line `find` invocation matching `@*` directory basenames.
- **Positive:** Sub-units live as siblings of their parent's agents and governance, recursively repeating the same shape.
- **Positive:** `2 | Working Files/` resolves "where do operational deliverables go?" — they go in `2 | Working Files/`.
- **Negative:** Paths now contain spaces, `@`, and `|` throughout. Every script and template that constructs a path must use rigorous quoting (`"$VAR"`); pipes outside quotes pipe shell commands, with potentially destructive consequences.
- **Negative:** Governance folders no longer self-identify through a per-unit suffix. Opening `1 | Canon/` alone doesn't reveal which unit's canon it holds; the parent directory's name carries the identity. In practice this matters only for tooling that operates without parent context, and that tooling can resolve the unit name from the parent directory's basename.
- **Negative:** First-time visitors must learn the `@ ` prefix convention and the `1 | / 2 | / 3 | ` governance scheme. The unit's `README.md` orients newcomers.

## Anti-patterns surfaced

- **Operational content at the unit's top level (outside `2 | Working Files/`).** Code, project files, plans should live inside `2 | Working Files/`. The unit's top level is reserved for governance, agents, sub-units, and the README.
- **Slug-style names instead of Title-case.** `@pebble/`, `lead@pebble/`, `canon@pebble/` are not the convention; they should not appear in an agency.
- **Bare governance folder names (no numeric prefix).** `Canon/`, `Working Files/`, `Silcrow Agency Reference/` (without the `1 |`, `2 |`, `3 |` prefix) lose the visual ordering and don't match the audit conventions.
- **Per-unit suffix on governance folders.** `Canon @ Pebble/`, `Working Files @ Pebble/` would re-introduce the slug-era self-identification trick that the new convention deliberately drops; governance folder names are constants.
- **Sub-units nested inside governance folders.** Sub-units are unit-level peers of governance, not children of it.
- **Mismatched unit names in agent dirs.** A directory `Lead @ Pebble/` inside `@ Cobble/` is a defect — the suffix should match the enclosing unit's name.
- **Renaming the `@ ` prefix on units.** The prefix is load-bearing for unit detection. Don't drop or change it per-project.
- **Duplicating `3 | Silcrow Agency Reference/` in sub-units.** Foundational reference is shared from the root; sub-units inherit by reference. Duplicating the foundations folder creates drift between root and sub-unit copies.
- **Forgetting to quote a path with a pipe.** `mkdir -p $AGENCY/1 | Canon` (unquoted) pipes the `Canon` portion to a shell command. Always use `mkdir -p "$AGENCY/1 | Canon"`.

## Review trigger

Reconsider this ADR if:

- Path-quoting bugs become a routine source of bugs in derivative scripts or tooling (suggests the readability win isn't worth the script-fragility cost; might warrant returning to slug-style for technical surfaces while keeping English in the user-facing display).
- Tooling proves consistently unable to distinguish unit dirs (`@ <Unit>/`) from agent dirs (`<Role> @ <Unit>/`) using filesystem operations — though `find -name '@*'` is reliable.
- A different vocabulary (not "agency/unit") proves to fit some domains substantially better.
- Filesystem case-sensitivity boundaries cause `Lead @ Pebble` and `lead @ pebble` to clash on cross-platform setups (suggests case-folding rules are needed).

## References

- `../../3 | Silcrow Agency Reference/Philosophy.md` — canon/operational framing underlying this structure.
- `../../Registrar @ {unit_name}/AGENTS.md` — audit procedure for unit↔ADR consistency.
- `../../3 | Silcrow Agency Reference/foundations/07 | Canonical and Operational.md` — intellectual history.
- `../_templates/Establish Unit.md` — the ADR template used when adding a new unit.
- §0001 — the founding decision this structure implements.
- §0005 — inboxes live at `@ <Unit Name>/<Role> @ <Unit Name>/inbox/` per this structure.
- §0008 — roster change protocol; adding a unit triggers it.
- §0011 — canon/operational split; this ADR is its structural expression.
- §0017 — agency scope.
