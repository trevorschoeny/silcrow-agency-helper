# §0014 — Agency and unit structure; flat `@<unit>/` convention

- **Status:** accepted
- **Date:** {date}
- **Authors:** scaffold initialization (inherited via §0001)
- **Supersedes:** —
- **Superseded by:** —
- **Influences:** every directory layout; every inbox path; every ADR-to-directory audit; the `:silcrow-init` skill; the `:silcrow-add-unit` skill; the `:silcrow-update` skill's structural migrations.
- **Influenced by:** §0001, §0005, §0010, §0013, §0020

## Why-statement

In the context of **agencies whose tree of units may range from a single root unit to arbitrarily-nested multi-unit structures**,
facing the need for a consistent, recursive structural convention that keeps governance distinguishable from operational work, makes units identifiable by tooling, and stays shallow enough that agents — accessed daily — are reachable in fewer clicks,
we decided for **a flat unit layout** — the unit's directory is `@<unit-name>/`, its top-level children are agent directories (`<role>@<unit-name>/`), governance folders (`CANON@<unit-name>/`, `REFERENCE@<unit-name>/` at root only, `OPS@<unit-name>/`), sub-unit directories (`@<sub-unit-name>/`), and a `README.md`; every direct-child folder of a unit carries the `@<unit-name>` suffix; capitalization distinguishes governance (UPPERCASE prefix) from agents (lowercase prefix); and unit detection is by the `@` prefix on a directory name —
and neglected a layout where governance lives one level deeper behind a wrapper folder, an `agents/` grouping subdirectory, suffix-less governance folders that lose self-identification, and a sentinel-file marker for unit detection,
to achieve a structure that's shallow at the agent layer (inboxes are two directory levels from the unit's root, not four), recursively identical at every depth, programmatically identifiable (`@*` prefix on a directory = unit), self-identifying (every direct-child folder carries its unit's name), and visually ordered (sub-units sort first, UPPERCASE governance next, lowercase agents last),
accepting that governance folders, agents, sub-units, and README coexist at the unit's top level (mitigated by the capitalization scheme) and that operational deliverables share the unit's namespace under one roof (mitigated by `OPS@<unit-name>/` as the explicit container for everything operational),
because (1) shallow paths to frequently-accessed locations matter for the scaffold's operators, who navigate agent dirs daily, and (2) the canon/operational split (§0013) doesn't require a wrapper folder — it requires a clear convention, which capitalization plus suffix scheme provides.

## Context and problem statement

The plugin needs a unit structure that:

- **Stays shallow at the agent layer.** Operators interact with agents and their inboxes daily. A four-deep path imposes friction that compounds across an agency's lifetime.
- **Distinguishes governance from operational without an extra folder level.** §0013's canon/operational split is load-bearing, but enforcing it through a wrapper directory adds depth.
- **Identifies units programmatically.** Tooling — the registrar's audit, the `:silcrow-add-unit` skill's parent-walk, the `:silcrow-update` skill's tree traversal — needs to recognize what's a unit and what isn't.
- **Recurses cleanly.** A sub-unit should be structurally identical to its parent. No special-casing depth.
- **Self-identifies.** Opening a folder standalone (in a CLI, an editor, an agent CWD) should reveal which unit it belongs to.
- **Stays shell-friendly.** Directory names work across bash/zsh/fish without quoting heroics.

## Decision drivers

- **Shallow paths to frequently-accessed locations.** Agents are touched constantly; inbox paths land two levels below the unit, not four.
- **Visible canon/operational split (§0013) without an extra folder level.** Capitalization replaces the wrapper.
- **Programmatic unit identification.** A directory's `@` prefix in its own basename is the marker.
- **Recursive pattern.** Every unit looks the same regardless of depth (with one exception for REFERENCE, below).
- **Self-identifying directories.** Every direct child of a unit (governance, agent, sub-unit) carries the unit's suffix; opening one standalone reveals its context.
- **Shell-safe.** `@`, lowercase letters, uppercase letters, hyphens, underscores, dots are all safe across shells and POSIX/NTFS filesystems.
- **Visually-ordered listings.** The capitalization scheme plus `@` prefix for sub-units gives a deterministic three-tier ASCII sort.

## Vocabulary

- **Agency** — the whole organizational tree. Named by the user at onboarding. The agency name labels the entire tree; the root unit shares this name.
- **Root unit** — the topmost unit. Same kind as any unit; distinguished only by position (no parent above). Its directory is `@<agency-name>/`.
- **Unit** — any node in the agency's tree. Has its own canon (`CANON@<unit-name>/`), operational space (`OPS@<unit-name>/`), agents, optional sub-units. Recursive: a unit may contain sub-units, with no depth limit. Every unit is structurally identical regardless of depth, with the sole exception of REFERENCE (below).
- **Sub-unit** — any non-root unit. Lives nested inside its parent unit's directory as a sibling of the parent's agents and governance folders.
- **Agent identity** — `<role>@<unit-name>` (slug, e.g. `lead@acme`) for paths and identifiers; `<Role> @ <Unit Name>` (prose, e.g. "Lead @ Acme") for narrative. Bare role names are ambiguous in any tree with more than one unit.
- **`CANON@<unit-name>/`** — the unit's canonical decisions. Holds `accepted/`, `proposed/`, `superseded/`, `rejected/`, `anti-patterns/`, `_templates/`, and a `README.md` index. Per-unit (every unit has one). Subject to §0004's immutability and supersession discipline.
- **`REFERENCE@<unit-name>/`** — canonical procedural reference (philosophy, foundations, message protocol, decision process, registrar workflows). **Root unit only**; sub-units inherit by reference (walk up the tree). Mutable, unlike CANON.
- **`OPS@<unit-name>/`** — operational artifacts: code, deliverables, shared work product, anything that isn't governance and isn't private to a single agent. Per-unit. Open container with no prescribed sub-structure.
- **Direct-child folder of a unit** — any folder placed at the unit's root: agent directory, sub-unit directory, or `CANON@`/`REFERENCE@`/`OPS@`. Carries the `@<unit-name>` suffix.
- **Subfolder** — any folder deeper than direct-child level. Does not carry the unit suffix (e.g., `accepted/`, `foundations/`, `inbox/`).

## Considered options and decision

1. **A wrapper-folder layout where governance is nested one level deep behind a single governance directory.** Rejected: the wrapper costs an extra directory level on every path. Operators report friction navigating agent inboxes daily. The wrapper's purpose (visible canon/operational split) is accomplishable through naming convention without an extra folder.

2. **Halfway: drop only the `agents/` subdirectory, keep the governance wrapper.** Rejected as inconsistent: it shaves one level for agents but leaves governance folders one level deeper than necessary. If we're flattening, flatten fully.

3. **Flat layout with `@<unit-name>` suffix on every direct-child folder; capitalization distinguishes governance from agents (chosen).** Agents reachable two levels below the unit (`@unit/<role>@unit/inbox/`); canon/operational split visible through capitalization plus `OPS@<unit-name>/` as the operational container; sub-units, agents, governance, README all coexist under one roof but in a deterministic visual order. Unit detection is the `@` prefix on a directory's own basename.

4. **Flat layout without unit-suffix on governance folders (e.g., bare `CANON/`, `OPS/`, `REFERENCE/`).** Rejected: governance folders wouldn't self-identify; opening `CANON/` standalone wouldn't reveal which unit's canon it holds. The `@<unit-name>` suffix on every direct-child folder restores self-identification at no real cost.

5. **Sentinel file (`.unit`) as the unit marker instead of `@` prefix.** Rejected: hidden files are easy to ignore in directory listings; the visible `@` prefix is a stronger structural signal. `find -name '@*'` from above the unit reliably matches unit dirs without needing to read file contents.

### Principles

#### Every direct-child folder of a unit carries the `@<unit-name>` suffix

A unit's directory `@<unit-name>/` contains:

- Agent directories: `<role>@<unit-name>/` (lowercase role prefix)
- Governance folders: `CANON@<unit-name>/`, `REFERENCE@<unit-name>/` (root unit only), `OPS@<unit-name>/` (UPPERCASE prefix)
- Sub-unit directories: `@<sub-unit-name>/` (no role prefix, just `@`)
- Files: `README.md` (no suffix; the rule applies to folders only)

Subfolders inside any of the above (e.g., `accepted/` inside `CANON@<unit>/`, `inbox/` inside `<role>@<unit>/`, `foundations/` inside `REFERENCE@<unit>/`) do **not** carry the suffix. The rule applies one level deep only, where ambiguity would otherwise matter.

#### Capitalization distinguishes governance from agents at the unit level

- **UPPERCASE prefix** (`CANON@`, `REFERENCE@`, `OPS@`) — governance and operational containers managed by the scaffold's conventions.
- **Lowercase prefix** (`<role>@`, agents) — agent directories. Lowercase keeps role names readable and matches the slug convention used in agent identity.
- **Bare `@` prefix** (no letters before `@`) — sub-unit directories.

In ASCII sort, this produces the order: sub-units → UPPERCASE governance → README.md → lowercase agents (with README.md interleaving among the UPPERCASE block alphabetically). In folder-grouping IDEs (VS Code, Cursor, JetBrains), folders cluster first in alphabetical order, with `README.md` alone at the bottom.

#### Sub-units live as siblings of their parent's agents and governance folders

A sub-unit's directory is at the parent unit's top level — alongside agents, CANON, OPS, REFERENCE. Sub-units are not nested inside any governance folder; they're peers of governance.

The sub-unit's existence is registered as an ADR in the parent unit's `CANON@<parent-name>/accepted/` (template at `CANON@<parent>/_templates/establish-unit.md`). Adding a unit requires both:

1. An accepted ADR in the parent's `CANON@<parent-name>/accepted/`.
2. The physical sub-unit directory `@<sub-unit-name>/` with its own flat structure.

The Registrar audits the pair. A sub-unit directory without its registering ADR is flagged (orphaned implementation). An ADR declaring a sub-unit that has no directory is flagged (unexecuted decision). This is the canon/ops split (§0013) made structural — the ADR is the canonical fact; the directory is the operational manifestation.

#### REFERENCE is root-only; sub-units inherit by reference

Foundational documents (`philosophy.md`, `decision-process.md`, `message-protocol.md`, registrar workflows, `foundations/`) live at the root unit's `REFERENCE@<root-name>/`. Sub-units do not duplicate them; agents in sub-units reference the root's REFERENCE folder by walking up the tree.

This is the one shape exception to the "every unit is structurally identical" rule: sub-units have CANON, OPS, agents, sub-units, README — but no REFERENCE. The agency's foundational reference is shared, not duplicated.

#### CANON contains canonical decisions (immutable, supersession-only)

CANON is the per-unit decision record. Its `accepted/` ADRs are immutable per §0004; superseded ADRs move to `superseded/` with a cross-link. The `_templates/` folder holds patterns for new ADRs. The `anti-patterns/` folder records what to avoid (§0009).

#### REFERENCE contains canonical procedural reference (mutable)

Unlike ADRs, REFERENCE docs may be edited as procedures evolve. They are canon in the sense that they bind agents (§0013), but they are not point-in-time decision records under §0004's supersession rules. Edits to REFERENCE files are governance commits and follow §0017.

#### OPS is an open container for operational artifacts

`OPS@<unit-name>/` holds anything operational at the unit level: code repositories, deliverables, shared reference material agents need, anything that isn't private to a single agent. Per §0005's actor-model discipline, agents iterate privately in their own folders; once material is ready to be shared, it is published to OPS. OPS doesn't prescribe sub-structure.

### Naming conventions and sort order

- **`@<unit-name>/`** (the unit's own directory) — `@` is ASCII 0x40, sorting before uppercase letters (0x41+) and lowercase letters (0x61+). The unit's parent folder shows it ahead of operational siblings.
- **`@<sub-unit-name>/`** — same convention; inside a parent unit, sub-units sort first (before UPPERCASE governance and lowercase agents).
- **`CANON@<unit-name>/`, `OPS@<unit-name>/`, `REFERENCE@<unit-name>/`** — UPPERCASE prefixes sort between `@` and lowercase, placing governance folders together in the listing.
- **`<role>@<unit-name>/`** — lowercase role prefix sorts after governance folders.
- **`README.md`** — uppercase R sorts within the UPPERCASE governance block (between `OPS@` and `REFERENCE@` alphabetically) in pure ASCII. In folder-grouping IDEs, files separate from folders, placing `README.md` alone at the bottom.

The deterministic listing order at any unit's root, in pure ASCII sort: `@<sub-units>/` → `CANON@<unit>/` → `OPS@<unit>/` → `README.md` → `REFERENCE@<unit>/` → `<role>@<unit>/` (lowercase agents). In folder-grouping views: same minus `README.md`, which drops to the file section.

### Unit-name slug constraints

A `<unit-name>` slug must satisfy:

- **Lowercase only.** No uppercase letters.
- **Alphanumeric, hyphens, underscores, dots.** No spaces, no slashes, no `@`, no other shell-meaningful characters.
- **Practical length cap of 64 characters.** Enforced for filesystem and tooling sanity.

The unit-name appears in many path positions (`@<unit>/`, `<role>@<unit>/`, `CANON@<unit>/`, etc.); a slug-safe name keeps tooling and shell invocations clean.

### Official unit identification: `@` prefix on the directory's basename

Any directory whose own basename starts with `@` is a unit.

- `find -type d -name '@*'` reliably matches unit directories.
- Agent directories (`<role>@<unit-name>/`) have `@` mid-string, not as a prefix; they don't match.
- Governance folders (`CANON@<unit-name>/`, etc.) start with uppercase letters; they don't match.
- The unit's own `@<unit-name>/` matches; nested sub-units `@<sub-unit-name>/` match.

### Operational artifacts

- **Default:** inside `OPS@<unit-name>/` at the unit level.
- **Allowed:** any path under `OPS@<unit-name>/` — repositories, document collections, working sets. The scaffold doesn't mandate sub-structure inside OPS.
- **External operational artifacts** (Google Drive, external shared filesystem, etc.) are allowed per §0005's actor-model spirit; agents reference them rather than mirror them.

### Consequences

- **Positive:** Agent paths are two directory levels from the unit's root (`@unit/<role>@unit/inbox/`). The scaffold's most-trafficked paths are now shallow.
- **Positive:** Capitalization carries the canon/operational distinction visually at a single glance, without a wrapper folder.
- **Positive:** Every direct-child folder of a unit self-identifies through its `@<unit-name>` suffix; opening one standalone reveals its context.
- **Positive:** Unit detection is a one-line `find` invocation matching `@*` directory basenames.
- **Positive:** Sub-units live as siblings of their parent's agents and governance, recursively repeating the same shape.
- **Positive:** OPS as an explicit operational container resolves "where do operational deliverables go?" — they go in OPS.
- **Negative:** Governance folders, agent dirs, sub-units, and README all coexist at the unit's top level. Mitigated by the capitalization scheme and the `@` prefix conventions, but the visual density at the unit's root is higher than a wrapped layout.
- **Negative:** Path length per agent inbox is unchanged in characters (the `@<unit-name>` repeats), but path *depth* is shallower.
- **Negative:** First-time visitors must learn the capitalization-plus-suffix convention. The unit's `README.md` orients newcomers.

## Anti-patterns surfaced

- **Operational content at the unit's top level (outside OPS).** Code, project files, plans should live inside `OPS@<unit-name>/`. The unit's top level is reserved for governance, agents, sub-units, and the README.
- **Suffix-less governance folders (`CANON/`, `OPS/`, `REFERENCE/` without `@<unit-name>`).** Loses self-identification; opening one standalone doesn't reveal which unit's governance it holds. The `@<unit-name>` suffix is required.
- **Lowercase governance folders (`canon@<unit>/`, `ops@<unit>/`).** The capitalization is structural — UPPERCASE for governance, lowercase for agents. Lowering breaks the visual distinction at the unit level.
- **Subfolder `@<unit>` suffixes.** Folders deeper than direct-child level (`accepted/`, `foundations/`, `inbox/`) do not carry the suffix. Adding them creates visual clutter without disambiguation benefit.
- **Sub-units nested inside governance folders.** Sub-units are unit-level peers of governance, not children of it.
- **Mismatched suffix.** A directory `lead@pebble/` inside `@cobble/` is a defect — the suffix should match the enclosing unit's name.
- **Renaming the `@` prefix.** The prefix is load-bearing for unit detection. Don't drop it per-project.
- **Duplicating REFERENCE in sub-units.** Foundational reference is shared from the root; sub-units inherit by reference. Duplicating the foundations folder creates drift between root and sub-unit copies.

## Review trigger

Reconsider this ADR if:

- The shallow-path goal turns out to matter less than expected in practice (operators stop reporting friction with deeper paths).
- Tooling proves consistently unable to distinguish unit dirs (`@<unit>/`) from agent dirs (`<role>@<unit>/`) using filesystem operations — though `find -name '@*'` is reliable.
- A different vocabulary (not "agency/unit") proves to fit some domains substantially better.
- The capitalization-distinction scheme proves visually unstable across editor themes or filesystem case-sensitivity boundaries.

## References

- `../../REFERENCE@<unit-name>/philosophy.md` — canon/operational framing underlying this structure (root unit only; sub-units walk up).
- `../../registrar@<unit-name>/AGENTS.md` — audit procedure for unit↔ADR consistency.
- `../../REFERENCE@<unit-name>/foundations/07-canonical-and-operational.md` — intellectual history.
- `../_templates/establish-unit.md` — the ADR template used when adding a new unit.
- §0001 — the founding decision this structure implements.
- §0005 — inboxes live at `@<unit-name>/<role>@<unit-name>/inbox/` per this structure.
- §0010 — roster change protocol; adding a unit triggers it.
- §0020 — agency scope.
- §0013 — canon/operational split; this ADR is its structural expression.
- §0018 — submodule decision for units with independent versioning.
