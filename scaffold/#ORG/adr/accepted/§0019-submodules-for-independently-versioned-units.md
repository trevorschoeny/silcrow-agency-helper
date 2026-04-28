# §0019 — Units with independent versioning needs are git submodules; all others are plain directories

- **Status:** accepted
- **Date:** {date}
- **Authors:** scaffold initialization (inherited via §0001)
- **Supersedes:** —
- **Superseded by:** —
- **Influences:** how `:silcrow-add-unit` handles each new unit; when a unit's changes commit to the agency vs its own repo.
- **Influenced by:** §0001, §0014, §0015, §0017, §0018

## Y-statement

In the context of **multi-unit agencies where some units will be independently versioned (their own deployment cycle, their own release cadence, their own upstream source) and others will always move in sync with the agency**,
facing the choice at unit-addition time between plain directory (single git repo, everything versioned together) and git submodule (nested repo, independent versioning),
we decided for **a per-unit choice at creation time** — the default is plain directory; submodule is used when the unit has independent versioning needs — and an agency may mix both —
and neglected global submodule-for-every-unit, global directory-for-every-unit, and git worktrees (which serve a different purpose),
to achieve clean independence where it matters (units with their own release cycle) without dragging every unit through the submodule lifecycle complexity,
accepting that the mixed mode means users have to hold both patterns in their head when working across units, and that submodule management adds cognitive load for the Lead,
because the canon/operational split (§0014) applies to git the same way it applies to everything else — some units are canonically bound to the agency's lifecycle; others are operationally independent — and forcing everything into one mode wastes either independence or simplicity.

## Context and problem statement

When a user adds a unit to an agency via `:silcrow-add-unit` (§0015's unit-addition flow), the new unit becomes a directory inside the agency. That directory is tracked by git. The question is *how*:

- **Plain directory.** The agency has one git repo; the unit's files commit alongside the agency's. Everything versions together.
- **Git submodule.** The unit has its own git repo, nested inside the agency via `git submodule add`. The unit has independent history, its own remote, and its own release lifecycle.

Neither answer is universally correct:

- A wedding-planning agency with a sub-unit for "reception-planning" has no reason to version reception-planning independently. Plain directory is the right call.
- A coding agency with a sub-unit that's already an existing codebase on GitHub *wants* the submodule — the codebase has its own release cycle and its own commit history worth preserving as a separate entity.
- A research lab with a sub-unit for a spun-out project that's becoming its own deliverable *wants* submodule mode for that unit, but plain directory for the other research threads still under the lab's direct authority.

## Decision drivers

- **Respect independent versioning needs.** When a unit has its own release cycle, tying it to the agency's repo loses that independence.
- **Avoid submodule overhead where it's not needed.** Submodules add commit-cadence complexity (the parent repo tracks a specific commit of the submodule; updates require a two-step commit). For units that always move with the agency, this is pure overhead.
- **Per-unit choice, not global mode.** An agency may have some units independently versioned and others tied to the agency.
- **Defaults should match the common case.** Most units are not independently versioned; the default should be plain directory.
- **Scaffold-agnosticism.** The scaffold shouldn't force a mode that doesn't fit the user's workflow.

## Considered options

1. **All units are plain directories (no submodule support).**
2. **All units are submodules.**
3. **Per-unit choice at creation time (chosen).** Default directory; submodule when the unit has independent versioning needs.
4. **Use git worktrees instead.** Worktrees share history but have separate working trees.

## Decision outcome

**Chosen option: (3).**

### The per-unit rule

- **A unit is a submodule** when it has independent versioning needs — typically when it's also (or will be) a separately-managed project with its own deployment or release cycle.
- **A unit is a plain directory** when it's always-in-sync with the agency and has no separate release lifecycle.
- The choice is made per-unit at creation time, not globally for the agency. An agency can mix both.
- The `:silcrow-add-unit` skill inspects the agency's current pattern and suggests the same pattern by default for new units, but always accepts an override.

### Submodule source options

When a unit is added in submodule mode, the user provides the source:

- **Remote URL** — the submodule adds an existing remote (`git submodule add <url> @<unit>`).
- **Local path** — the submodule adds an existing local repo.
- **Fresh init** — the submodule is initialized as a new local repo with no remote; the user can set a remote later.

The default depends on context. If the user mentions an existing codebase URL during `:silcrow-add-unit`, that's the remote. If they say "start a new independent repo for this unit," it's fresh init. Otherwise, plain directory.

### Internal structure of a submodule unit

Identical to a plain directory unit. A submodule has:

- `#ORG/` — its governance.
- Sub-units (if any).
- Operational artifacts.

The internal structure is identical; only the git relationship to the parent repo differs.

### Mixed-mode agencies

An agency can have (for example):

- `@pebble/@pebble-core/` — plain directory (always moves with the agency).
- `@pebble/@pebble-app/` — submodule (has its own release cycle and GitHub repo).

The `:silcrow-add-unit` skill handles both. Registrar audits the canon/ops ADR record the same way for both. Only the commit-cadence behavior differs.

### Why not worktrees

Git worktrees share history across working trees — they're a tool for *checking out multiple branches simultaneously*, not for *independent versioning*. A worktree of the agency's main branch inside a unit directory gives the unit its own working tree but no independent history, no independent remote, no separate release cycle. That solves a different problem (parallel branch work) and doesn't address independent versioning.

Worktrees are still useful for agent-session isolation (an agent wants its own working tree to avoid conflicting with another session). That's a runtime tool, not a unit-level decision. Documented separately in the Lead's git notes.

### Consequences

- **Positive:** Units with their own release cycle get the independence they need.
- **Positive:** Units that move with the agency don't pay submodule overhead.
- **Positive:** Per-unit choice lets an agency mix modes as the reality demands.
- **Negative:** Mixed-mode agencies require the Lead to hold both patterns in their head when working across units.
- **Negative:** Submodule management adds cognitive load for the Lead (two-step commits, `git submodule update`, detached HEAD states on checkout).
- **Neutral:** The `:silcrow-add-unit` skill handles the mechanics; the Lead only has to answer "submodule or directory?" during unit creation.

## Anti-patterns surfaced

- **Reflexively making everything a submodule.** Adds overhead to every unit whether or not independence is needed.
- **Reflexively avoiding submodules.** Forces users to structure around the scaffold for cases where submodules are the clean answer.
- **Changing a unit's mode after the fact without an ADR.** Changing a plain-directory unit into a submodule (or vice versa) is a structural governance change; it warrants an ADR recording the change and the reasoning.
- **Using git worktrees as a unit boundary.** Worktrees don't create unit independence; they just give parallel working trees. If a unit needs independence, submodule is the answer.

## Review trigger

Reconsider this ADR if:

- A pattern emerges where a third mode is consistently needed that neither directory nor submodule handles well (e.g., git subtree, or monorepo tooling like Nx or Turborepo).
- Submodule lifecycle friction proves so costly that users routinely regret choosing submodule mode (suggests the default should lean further toward directory, or a lighter independence mechanism is warranted).
- An alternative to submodules becomes widely adopted for the "independent versioning with parent integration" use case.

## References

- `../../agents/registrar/AGENTS.md` — no special audit for submodule mode; normal unit↔ADR audit applies.
- `../../agents/lead/AGENTS.md` — Lead's git notes include submodule management.
- §0001 — founding scaffold decision.
- §0014 — canon/operational split; submodule mode aligns with operationally-independent units.
- §0015 — agency and unit structure; submodules share internal structure with plain-directory units.
- §0017 — `.gitignore` default; applies to submodule roots as well.
- §0018 — commit convention; submodule commits follow the same convention in both the submodule and the parent.
- Git documentation: `git-submodule(1)` man page; the Atlassian tutorial on submodules is a common secondary reference.
