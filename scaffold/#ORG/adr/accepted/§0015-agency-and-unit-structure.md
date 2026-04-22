# §0015 — Agency and unit structure; `#ORG/` and `@<unit>/` conventions

- **Status:** accepted
- **Date:** {date}
- **Authors:** scaffold initialization (inherited via §0001)
- **Supersedes:** —
- **Superseded by:** —
- **Influences:** every directory layout; every inbox path; every ADR-to-directory audit; the `:add-unit` skill; the `:update` skill's structural migrations.
- **Influenced by:** §0001, §0005, §0010, §0011, §0014

## Y-statement

In the context of **agencies that range from single-unit to multi-unit with arbitrary nesting**,
facing the need for a consistent, recursive structural convention that keeps governance cleanly separated from operational work and makes units identifiable by tooling,
we decided for **a three-part convention** — the top level is an **agency**; any subdivision with its own governance is a **unit** (recursive); governance lives in `#ORG/` and nowhere else; units are named `@<kebab-case>/` and sit as siblings of `#ORG/` —
and neglected a flat `adr/agents/docs/` layout, a `governance/` folder name, nesting units inside `#ORG/`, and using no unit prefix,
to achieve a structure that's immediately recognizable (ASCII sort puts `#ORG/` first, `@<units>/` second, operational content last), programmatically identifiable (presence of `#ORG/` = unit), and recursively identical at every depth,
accepting that the `#` and `@` characters look unusual in paths and require the user to learn a small convention,
because the separation between governance and operational work (per §0014) deserves a visible structural boundary, and the recursive pattern is necessary for agencies that grow from one unit to many without renaming everything.

## Context and problem statement

The original scaffold used a flat layout: `adr/`, `agents/`, `docs/`, `proposed/` at the project root. That was adequate for single-unit projects but doesn't answer:

- **Where does a new unit live?** As a sibling directory? Nested inside `agents/`? In a new `units/` folder?
- **How does tooling identify a unit?** By directory name convention? By a marker file? By registration in a manifest?
- **How does governance separate from operational work?** A flat layout mixes `adr/` (governance) with whatever else the agency produces (operational).
- **Does the pattern recurse cleanly?** If agencies can have units, and units can have sub-units, the layout should be identical at every level.

This ADR answers all four questions with a single coherent convention.

## Decision drivers

- **The canon/operational split (§0014) should be visible in the filesystem.** Governance and operational content should not be mixed in the same folder; their separation is load-bearing.
- **Units should be identifiable programmatically, not by convention alone.** A marker that tooling can detect is more reliable than "we name them like this".
- **The pattern should recurse.** The agency is itself a unit (the root unit); sub-units are units; sub-sub-units are units. Same rules at every depth.
- **Sort order should be sensible.** A directory listing at any level should surface the most structural content first (governance), then units, then operational material.
- **Shell-friendly.** Directory names must work across bash/zsh/fish and common file managers without quoting heroics.

## Vocabulary

- **Agency** — the whole scaffolded thing. The top-level, root-most unit. Named by the user at onboarding.
- **Unit** — any structured subdivision with its own governance, agents, and operational work. Recursive: a unit can contain units, which can contain units. The agency itself is a unit (the root unit); "agency" is reserved for the top-level.
- **`#ORG/`** — the governance folder of any unit (agency or sub-unit). Contains only governance artifacts.
- **Operational artifact** — anything that isn't governance (§0014 governs the distinction).
- **Scaffold namespace** — directory names that begin with `#` or `@` are scaffold-managed structural folders. `#` is reserved for governance (`#ORG/`). `@` is reserved for units (`@<kebab-case-name>/`) — including the agency itself, since the agency is a unit. Everything else is user-owned operational content.

## Considered options and decision

1. **Keep the flat layout (`adr/`, `agents/`, `docs/` at root; no unit support).** Rejected: doesn't support multi-unit agencies; mixes governance and operational content.
2. **Flat layout + `units/` subfolder.** Rejected: still mixes governance and operational; `units/` grouping doesn't recurse.
3. **Governance folder named `governance/` or `org/` (no prefix).** Rejected: doesn't sort to the top of listings; operational files can appear above it.
4. **Nested units inside a governance folder (`governance/units/<name>/`).** Rejected: violates §0014 by dragging operational content into a "governance" folder; doesn't recurse cleanly.
5. **`#ORG/` folder with `@<unit>/` siblings (chosen).** Governance cleanly separated; units identifiable programmatically; sort order reflects importance; recursive pattern identical at every depth.

### Principles

#### `#ORG/` contains governance only

At every level, `#ORG/` holds:

- `adr/` — the unit's decision record (with `accepted/`, `proposed/`, `superseded/`, `rejected/`, `anti-patterns/`, `_templates/`).
- `agents/` — the unit's agent roster and inboxes.
- `docs/` — foundational orientation, process, philosophy.
- `README.md` — governance overview for this unit.

`#ORG/` contains **no operational artifacts**. Ever. This is the load-bearing rule that makes the rest of the structure clean.

#### Units live as siblings of `#ORG/`, not inside it

A unit's root contains:

- `#ORG/` (governance)
- Zero or more **sub-unit directories** (each itself a full unit)
- Any number of **operational artifacts** (files, folders, working material)

Sub-units are *not* nested inside `#ORG/`. Their existence is a governance fact (registered as an ADR in the parent's `#ORG/adr/`) but the sub-unit directory itself is an operational manifestation of that decision and lives alongside `#ORG/`. This preserves the rule that `#ORG/` holds governance only.

#### The recursive pattern

At every level — agency, unit, sub-unit, sub-sub-unit — the shape is identical:

```
<any unit>/
├── #ORG/                    ← this unit's governance (sorts first)
├── @<sub-unit>/             ← sub-unit (recursive)
│   ├── #ORG/
│   ├── @<sub-sub-unit>/
│   └── ops...
└── ops...                   ← this unit's operational artifacts
```

No new vocabulary is needed as depth increases.

### Naming conventions and sort order

- **`#ORG/`** — `#` sorts to ASCII 35 (before digits, letters, and common filename characters), ensuring it lists first at any depth. Uppercase `ORG` matches the `README.md`/`LICENSE` convention for scaffold-managed structural folders. `#` is shell-safe in directory names.
- **`@<kebab-case-name>/`** — `@` sorts to ASCII 64 (between `#` and letters), so units list below `#ORG/` and above operational content. Lowercase kebab-case is shell-friendly and path-safe; the scaffold suggests it but accepts whatever the user provides.
- **The agency directory uses the `@` prefix.** Since the agency is the root unit, it follows the same convention — `@<agency-name>/` by default. At init, the scaffold offers a rename if the current directory doesn't start with `@`; users can accept or decline (the `#ORG/` marker identifies it either way).

Directory listings at any unit's root land in a clean three-tier order: `#ORG/` → `@<units>/` → operational content. Deterministic across shells, file managers, and ASCII-ordering tooling.

### Official unit identification: presence of `#ORG/`

Any directory containing a `#ORG/` folder **is** a unit. This is the structural marker agents and tooling rely on.

- The `@` prefix is visual convention; the `#ORG/` marker is programmatic truth.
- A directory without `#ORG/` is not a unit, even if its name happens to start with `@`.
- A directory with `#ORG/` is a unit, even if its name doesn't follow the convention.

### Unit existence is registered canonically

When a new unit is created, the parent's `#ORG/adr/` receives an ADR declaring it. Template lives in `#ORG/adr/_templates/establish-unit.md`. Adding a unit requires both:

1. An accepted ADR in the parent's `#ORG/adr/`.
2. The physical unit directory (with its own `#ORG/`).

The Registrar audits the pair. A unit directory without its registering ADR is flagged (orphaned implementation). An ADR declaring a unit that has no directory is flagged (unexecuted decision). This is the canon/ops split (§0014) made structural — the ADR is the canonical fact; the directory is the operational manifestation.

### Operational artifacts live wherever is natural

- **Default:** at the unit's root, alongside `#ORG/` and sub-units.
- **Allowed:** anywhere — external repo, Google Drive via connector, shared filesystem, etc. The scaffold doesn't mandate location for operational work.
- **Agents assume nothing.** When agents need to operate on operational artifacts, they check and ask; they don't assume a prescribed layout.

### Consequences

- **Positive:** Governance is cleanly separated from operational work at every level, by filesystem convention.
- **Positive:** Units are programmatically identifiable (presence of `#ORG/`).
- **Positive:** The recursive pattern means sub-units are structurally identical to their parents.
- **Positive:** Sort order matches conceptual importance: governance first, units next, operational content last.
- **Positive:** The scaffold namespace (`#`, `@` prefixes) is clearly reserved; anything else is user-owned.
- **Negative:** `#` and `@` characters in paths look unusual to users unfamiliar with the convention. Brief onboarding covers it.
- **Neutral:** The agency directory uses the `@` prefix by default but accepts unprefixed names. The `#ORG/` marker is what makes it an agency.

A fully-spelled-out multi-unit tree is in the agency's `#ORG/README.md`; this ADR doesn't duplicate it.

## Anti-patterns surfaced

- **Operational content inside `#ORG/`.** Putting a codebase or a plan inside `#ORG/` violates the cleanest structural rule in the scaffold. Governance is `#ORG/`; everything else is outside it.
- **Nesting units inside `#ORG/`.** A unit has its own operational content; nesting it inside `#ORG/` drags that operational content into the governance folder.
- **Unit without `#ORG/`.** A directory named `@something/` without `#ORG/` inside it is not a unit. The name alone doesn't make it one.
- **Directory without `@` but with `#ORG/`.** Still a unit (the `#ORG/` marker is programmatic truth), but the missing `@` prefix is a convention violation worth flagging in audit.
- **Renaming `#ORG/` to something else.** The name is load-bearing for tooling and audit. Don't change it per-project.

## Review trigger

Reconsider this ADR if:

- A consistent need emerges for multiple separate governance folders inside a single unit (suggests `#ORG/` alone isn't carrying enough structure).
- The `#` or `@` characters prove to cause persistent tooling issues on some filesystem or shell (very unlikely; documented to work across POSIX and Windows NTFS).
- A different vocabulary (not "agency/unit") proves to fit some domains substantially better (though the recursion and the marker would likely stay).

## References

- `../../docs/philosophy.md` — canon/operational framing underlying this structure.
- `../../agents/registrar/AGENTS.md` — audit procedure for unit↔ADR consistency.
- `../../docs/foundations/07-canonical-and-operational.md` — intellectual history.
- `_templates/establish-unit.md` — the ADR template used when adding a new unit.
- §0001 — the founding decision this structure implements.
- §0005 — inboxes live at `#ORG/agents/<role>/inbox/` per this structure.
- §0010 — roster change protocol; adding a unit triggers it.
- §0011 — agency scope.
- §0014 — canon/operational split; this ADR is its structural expression.
- §0019 — submodule decision for units with independent versioning.
