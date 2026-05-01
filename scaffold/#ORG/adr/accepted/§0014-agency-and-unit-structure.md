# §0014 — Agency and unit structure; `#ORG@<unit>/` and `@<unit>/` conventions

- **Status:** accepted
- **Date:** {date}
- **Authors:** scaffold initialization (inherited via §0001)
- **Supersedes:** —
- **Superseded by:** —
- **Influences:** every directory layout; every inbox path; every ADR-to-directory audit; the `:silcrow-add-unit` skill; the `:silcrow-update` skill's structural migrations.
- **Influenced by:** §0001, §0005, §0010, §0019, §0013

## Y-statement

In the context of **agencies whose tree of units may range from a single root unit to arbitrarily-nested multi-unit structures**,
facing the need for a consistent, recursive structural convention that keeps governance cleanly separated from operational work and makes units identifiable by tooling,
we decided for **a three-part convention** — the whole structure is the **agency** and its top-level node is the **root unit**, with every subdivision recursively also a unit; each unit's governance lives in its own `#ORG@<unit-name>/` folder and nowhere else; units are named `@<kebab-case>/` and sit as siblings of their parent unit's `#ORG@<unit-name>/` —
and neglected a flat `adr/agents/docs/` layout, a `governance/` folder name, nesting units inside the governance folder, and using no unit prefix on either governance folders or units,
to achieve a structure that's immediately recognizable (ASCII sort puts `#ORG@<unit-name>/` first, `@<sub-units>/` second, operational content last), programmatically identifiable (presence of any `#ORG@*/` directory = unit), recursively identical at every depth, and self-identifying (every governance folder and every agent directory carries its unit's name),
accepting that the `#` and `@` characters look unusual in paths and require the user to learn a small convention,
because the separation between governance and operational work (per §0013) deserves a visible structural boundary, and the recursive pattern is necessary for agencies that grow from a single root unit into a tree of sub-units without renaming everything.

## Context and problem statement

The original scaffold used a flat layout: `adr/`, `agents/`, `docs/`, `proposed/` at the project root. That was adequate for single-unit projects but doesn't answer:

- **Where does a new unit live?** As a sibling directory? Nested inside `agents/`? In a new `units/` folder?
- **How does tooling identify a unit?** By directory name convention? By a marker file? By registration in a manifest?
- **How does governance separate from operational work?** A flat layout mixes `adr/` (governance) with whatever else the agency produces (operational).
- **Does the pattern recurse cleanly?** If agencies can have units, and units can have sub-units, the layout should be identical at every level.
- **When you open a folder standalone, can you tell which unit it belongs to?** A bare `#ORG/` or `agents/lead/` doesn't tell you which unit's governance or which unit's Lead you're looking at.

This ADR answers all five questions with a single coherent convention.

## Decision drivers

- **The canon/operational split (§0013) should be visible in the filesystem.** Governance and operational content should not be mixed in the same folder; their separation is load-bearing.
- **Units should be identifiable programmatically, not by convention alone.** A marker that tooling can detect is more reliable than "we name them like this".
- **The pattern should recurse.** The root unit, sub-units, and sub-sub-units are all just units. Same rules at every depth — no special-casing the root.
- **Sort order should be sensible.** A directory listing at any level should surface the most structural content first (governance), then units, then operational material.
- **Self-identifying directories.** Opening a governance folder or agent directory standalone (in a CLI, an editor, an agent CWD) should reveal which unit it belongs to without requiring the parent path. Identity is encoded in the directory name itself.
- **Shell-friendly.** Directory names must work across bash/zsh/fish and common file managers without quoting heroics.

## Vocabulary

- **Agency** — the whole organizational tree. Named by the user at onboarding. The agency name labels the entire tree; the root unit shares this name (e.g., agency `acme` ↔ root unit at `@acme/`).
- **Root unit** — the topmost unit in the agency's tree. Same kind as any unit; the only thing distinguishing it is its position (no parent above it).
- **Unit** — any node in the agency's tree. Has its own governance (`#ORG@<unit-name>/`), agents, and operational work. Recursive: a unit may contain sub-units, which may contain sub-units, with no depth limit. Every unit is structurally identical regardless of depth.
- **Sub-unit** — any non-root unit. A sub-unit lives physically nested inside its parent unit's directory (as a sibling of the parent's `#ORG@<parent-name>/`).
- **Agent identity** — `<role>@<unit-name>` (slug, e.g. `lead@acme`) or `<Role> @ <Unit Name>` (prose, e.g. "Lead @ Acme"). Every agent reference everywhere uses its full name; bare role names are ambiguous in any tree with more than one unit.
- **`#ORG@<unit-name>/`** — the governance folder of a unit. Each unit has its own, with the unit's name encoded in the directory name (e.g., `#ORG@acme/` is the agency root's governance; `#ORG@pebble/` is sub-unit `@pebble`'s governance). The `#ORG@` prefix is the load-bearing marker; the `<unit-name>` suffix carries identity. Contains only governance artifacts.
- **Operational artifact** — anything that isn't governance (§0013 governs the distinction).
- **Scaffold namespace** — directory names that begin with `#` or `@` are scaffold-managed structural folders. `#ORG@` is reserved for unit governance folders. `@` (alone, no `ORG` prefix) is reserved for unit directories themselves (`@<kebab-case-name>/`) — including the root unit. Everything else is user-owned operational content.

## Considered options and decision

1. **Keep the flat layout (`adr/`, `agents/`, `docs/` at root; no unit support).** Rejected: doesn't support multi-unit agencies; mixes governance and operational content.
2. **Flat layout + `units/` subfolder.** Rejected: still mixes governance and operational; `units/` grouping doesn't recurse.
3. **Governance folder named `governance/` or `org/` (no prefix).** Rejected: doesn't sort to the top of listings; operational files can appear above it.
4. **Nested units inside a governance folder (`governance/units/<name>/`).** Rejected: violates §0013 by dragging operational content into a "governance" folder; doesn't recurse cleanly.
5. **Single `#ORG/` marker (no unit suffix) with `@<unit>/` siblings.** Rejected: the governance folder is structurally identical across units, so opening one bare doesn't reveal which unit it belongs to. Required the parent path to disambiguate.
6. **`#ORG@<unit-name>/` governance folder with `@<unit>/` siblings (chosen).** Governance cleanly separated; units identifiable programmatically; sort order reflects importance; recursive pattern identical at every depth; every governance folder self-identifies.

### Principles

#### `#ORG@<unit-name>/` contains governance only

At every level, the unit's `#ORG@<unit-name>/` holds:

- `adr/` — the unit's decision record (with `accepted/`, `proposed/`, `superseded/`, `rejected/`, `anti-patterns/`, `_templates/`).
- `agents/` — the unit's agent roster (each agent in a `<role>@<unit-name>/` subdirectory) and inboxes.
- `docs/` — foundational orientation, process, philosophy (root unit only; sub-units inherit by reference).
- `README.md` — governance overview for this unit.

`#ORG@<unit-name>/` contains **no operational artifacts**. Ever. This is the load-bearing rule that makes the rest of the structure clean.

#### Sub-units live as siblings of their parent's `#ORG@<parent-name>/`, not inside it

A unit's directory contains:

- Its own `#ORG@<unit-name>/` (governance for this unit)
- Zero or more **sub-unit directories** (each itself a full unit, with its own `#ORG@<sub-unit-name>/` inside)
- Any number of **operational artifacts** (files, folders, working material)

Sub-units are *not* nested inside the parent's `#ORG@<parent-name>/`. Their existence is a governance fact (registered as an ADR in the parent's `#ORG@<parent-name>/adr/`), but the sub-unit directory itself is an operational manifestation of that decision and lives alongside the parent's governance folder. This preserves the rule that governance folders hold governance only.

#### The recursive pattern

At every level — root unit, sub-unit, sub-sub-unit — the shape is identical:

```
@<unit-name>/
├── #ORG@<unit-name>/             ← this unit's governance (sorts first)
│   ├── adr/
│   ├── agents/
│   │   ├── <role>@<unit-name>/   ← agent dirs carry the unit suffix too
│   │   └── ...
│   └── docs/   (root unit only; inherited by sub-units)
├── @<sub-unit-name>/             ← sub-unit (recursive)
│   ├── #ORG@<sub-unit-name>/
│   ├── @<sub-sub-unit-name>/
│   │   ├── #ORG@<sub-sub-unit-name>/
│   │   └── ops...
│   └── ops...
└── ops...                        ← this unit's operational artifacts
```

No new vocabulary is needed as depth increases. Every governance folder and every agent directory self-identifies through the `@<unit-name>` suffix.

### Naming conventions and sort order

- **`#ORG@<unit-name>/`** — `#` sorts to ASCII 35 (before digits, letters, and common filename characters), ensuring all unit governance folders list first at any depth. The `#ORG@` prefix is fixed; the `<unit-name>` is the unit's slug. `#` is shell-safe in directory names.
- **`@<kebab-case-name>/`** — `@` sorts to ASCII 64 (between `#` and letters), so unit directories list below `#ORG@<unit-name>/` and above operational content. Lowercase kebab-case is shell-friendly and path-safe; the scaffold suggests it but accepts whatever the user provides.
- **The root unit's directory uses the `@` prefix**, the same as any unit — `@<agency-name>/` by default. There is no exception for the root. At init, the scaffold offers a rename if the current directory doesn't start with `@`; users can accept or decline (the `#ORG@<unit-name>/` marker identifies it as a unit either way).
- **Agent directories carry the unit suffix.** Inside `#ORG@<unit-name>/agents/`, each agent's directory is `<role>@<unit-name>/` (e.g., `lead@acme/`, `registrar@pebble/`). Opening one standalone reveals the agent's unit context.

Directory listings at any unit's root land in a clean three-tier order: `#ORG@<unit-name>/` → `@<sub-units>/` → operational content. Deterministic across shells, file managers, and ASCII-ordering tooling.

### Official unit identification: presence of `#ORG@<unit-name>/`

Any directory containing a `#ORG@*/` subdirectory **is** a unit. This is the structural marker agents and tooling rely on.

- The `@` prefix on the unit folder is visual convention; the `#ORG@*/` inside it is programmatic truth.
- A directory without any `#ORG@*/` subdirectory is not a unit, even if its name happens to start with `@`.
- A directory containing `#ORG@*/` is a unit, even if its own name doesn't follow the `@<kebab-case>/` convention.
- Tooling pattern-matches `#ORG@*/` (glob); the suffix after `#ORG@` is the unit's identity, recoverable from the directory name alone.

### Unit existence is registered canonically

When a new unit is created, the parent's `#ORG@<parent-name>/adr/` receives an ADR declaring it. Template lives in any unit's `#ORG@<unit-name>/adr/_templates/establish-unit.md` (root unit's, typically). Adding a unit requires both:

1. An accepted ADR in the parent's `#ORG@<parent-name>/adr/`.
2. The physical unit directory (with its own `#ORG@<unit-name>/`).

The Registrar audits the pair. A unit directory without its registering ADR is flagged (orphaned implementation). An ADR declaring a unit that has no directory is flagged (unexecuted decision). This is the canon/ops split (§0013) made structural — the ADR is the canonical fact; the directory is the operational manifestation.

### Operational artifacts live wherever is natural

- **Default:** at the unit's root, alongside `#ORG@<unit-name>/` and sub-units.
- **Allowed:** anywhere — external repo, Google Drive via connector, shared filesystem, etc. The scaffold doesn't mandate location for operational work.
- **Agents assume nothing.** When agents need to operate on operational artifacts, they check and ask; they don't assume a prescribed layout.

### Consequences

- **Positive:** Governance is cleanly separated from operational work at every level, by filesystem convention.
- **Positive:** Units are programmatically identifiable (any `#ORG@*/` subdirectory).
- **Positive:** Every governance folder and every agent directory self-identifies through its unit suffix — opening one standalone reveals which unit it belongs to without requiring the parent path.
- **Positive:** The recursive pattern means sub-units are structurally identical to their parents.
- **Positive:** Sort order matches conceptual importance: governance first, units next, operational content last.
- **Positive:** The scaffold namespace (`#ORG@`, `@` prefixes) is clearly reserved; anything else is user-owned.
- **Negative:** `#`, `@`, and the dual prefix conventions look unusual to users unfamiliar with them. Brief onboarding covers it.
- **Negative:** Path lengths grow modestly due to the unit suffix repetition (`@acme/#ORG@acme/agents/lead@acme/inbox/`). The trade-off is self-identification at every level; the alternative (bare `#ORG/`, bare `agents/lead/`) loses identity once you step inside.
- **Neutral:** The agency directory uses the `@` prefix by default but accepts unprefixed names. The `#ORG@<unit-name>/` marker is what makes it a unit.

A fully-spelled-out multi-unit tree is in the agency's `#ORG@<root-name>/README.md`; this ADR doesn't duplicate it.

## Anti-patterns surfaced

- **Operational content inside `#ORG@<unit-name>/`.** Putting a codebase or a plan inside a unit's governance folder violates the cleanest structural rule in the scaffold. Governance is `#ORG@<unit-name>/`; everything else is outside it.
- **Nesting units inside `#ORG@<unit-name>/`.** A unit has its own operational content; nesting it inside another unit's governance folder drags operational content into governance.
- **Unit without `#ORG@<unit-name>/`.** A directory named `@something/` without an `#ORG@*/` inside it is not a unit. The name alone doesn't make it one.
- **Directory without `@` but with `#ORG@*/`.** Still a unit (the marker is programmatic truth), but the missing `@` prefix is a convention violation worth flagging in audit.
- **Mismatched suffix.** A directory `@pebble/` containing `#ORG@cobble/` (or similar mismatch) is a defect — the suffix on `#ORG@*/` should match the unit folder's name.
- **Renaming the `#ORG@` prefix.** The prefix is load-bearing for tooling and audit. Don't change it per-project.

## Review trigger

Reconsider this ADR if:

- A consistent need emerges for multiple separate governance folders inside a single unit (suggests `#ORG@<unit-name>/` alone isn't carrying enough structure).
- The `#`, `@`, or the dual-prefix scheme proves to cause persistent tooling issues on some filesystem or shell (very unlikely; documented to work across POSIX and Windows NTFS).
- A different vocabulary (not "agency/unit") proves to fit some domains substantially better (though the recursion and the marker would likely stay).
- Path lengths from the unit-suffix repetition prove to genuinely impair workflow at deep nesting (consider abbreviation conventions, but only with evidence).

## References

- `../../docs/philosophy.md` — canon/operational framing underlying this structure.
- `../../agents/registrar@<unit-name>/AGENTS.md` — audit procedure for unit↔ADR consistency.
- `../../docs/foundations/07-canonical-and-operational.md` — intellectual history.
- `_templates/establish-unit.md` — the ADR template used when adding a new unit.
- §0001 — the founding decision this structure implements.
- §0005 — inboxes live at `#ORG@<unit-name>/agents/<role>@<unit-name>/inbox/` per this structure.
- §0010 — roster change protocol; adding a unit triggers it.
- §0019 — agency scope.
- §0013 — canon/operational split; this ADR is its structural expression.
- §0018 — submodule decision for units with independent versioning.
