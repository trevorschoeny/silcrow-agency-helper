---
name: silcrow-add-unit
description: Add a new sub-unit nested inside the unit you're currently in. Authors the establishing ADR and scaffolds the new sub-unit's `@ <Unit Name>/` governance folder in one coherent motion. Use when the user says "add a unit," "create a new unit," "split off a unit," "new sub-unit," "scaffold unit," or similar within an existing scaffolded agency.
user-invocable: true
allowed-tools:
  - Read
  - Glob
  - Grep
  - Bash(ls:*)
  - Bash(test:*)
  - Bash(pwd:*)
  - Bash(git:*)
  - Bash(${CLAUDE_PLUGIN_ROOT}/scripts/add-unit.sh:*)
  - AskUserQuestion
---

# Agent Org Scaffold — Add Unit

Add a new sub-unit nested inside the unit you're currently in. The skill authors the establishing ADR (per §0012) *and* runs the mechanical scaffolding in one motion. Lead or User invokes; Registrar audits afterwards.

The new sub-unit is created nested inside the current unit's directory as a sibling of the unit's agents, `1 | Canon`, `2 | Working Files`, and any other governance folders (per §0012's flat layout). `3 | Silcrow Agency Reference` stays at the root unit only; sub-units inherit it by reference.

## When to use

- The user wants to add a sub-organization to the unit they're currently in.
- The work has matured enough that it deserves its own decision record and agent team.
- The user says something like "let's split X into its own unit" or "I want to add a sub-unit for Y."

The skill operates on a unit you're already inside. CWD can be either the unit's root (`@ <Unit Name>/`) or any agent directory inside the unit (`<Role> @ <Unit Name>/`) — the skill resolves the unit path either way. If CWD doesn't fit either shape, the skill stops and tells the user. If the user hasn't yet run `:silcrow-init`, this skill will detect that and redirect them. If they want to update an existing agency to the current scaffold, direct them to `:silcrow-update`.

## How this skill works

Four-phase flow: **silent peek → natural conversation → run add-unit script → report with hand-off**. The bundled script `scripts/add-unit.sh` does the mechanical work — renders the establishing ADR, creates the sub-unit directory nested inside the current unit, scaffolds the flat structure (`1 | Canon`, `2 | Working Files`, agent dirs, README), and commits.

---

## Phase 1 — Peek silently

Before any output:

- `pwd` to find the current working directory.
- Determine the **unit path** (the parent unit, since you'll be adding a sub-unit inside it):
  - **If CWD's basename starts with `@`**, CWD itself is the unit. The unit path is `<cwd>`.
  - **If CWD's basename matches `<X> @ <Y>`** (an agent directory), the unit is one level up: `<cwd>/..`. Per §0012's flat layout, every agent directory lives directly inside its unit, so `..` resolves the unit deterministically (single step, not iterative search).
  - **Otherwise** (CWD has no `@` in its basename, or is some other shape), stop and tell the user: *"I don't see a unit here. Navigate into either a unit's directory (the one named `@ <Unit Name>/`) or any agent's directory inside a unit (e.g., `Lead @ <Unit Name>/`), and try again. If you haven't scaffolded an agency yet, run `:silcrow-init` first."* Do not proceed.
- Read the unit's `README.md` at `<unit_path>/README.md`. Extract the four meta fields from its `silcrow-meta` anchor on the first line:
  - `agency="..."` — the agency name (used in the establishing ADR's references)
  - `user-role="..."` — the agency's user role (used for "route through the User or ..." references)
  - `lead-role="..."` — this unit's lead role (becomes the new sub-unit's `parent-lead-role`)
  - `implementer-role="..."` — this unit's implementer role (used as the default-inherit value when proposing the new sub-unit's roles)

  If the anchor is missing or any field is absent, tell the user: *"This unit's README is missing its complete `silcrow-meta` anchor. Run `:silcrow-update` to bring the agency in line with the current scaffold, then try again."* Do not proceed.

  The unit's own name is the unit path's basename minus the `@ ` prefix. That's the parent unit's name for the new sub-unit.
- Scan `<unit_path>/1 | Canon/accepted/` for existing unit-establishing ADRs (look for filenames containing `Establish Unit`) — these tell you what sub-units already exist and what names are taken.
- Check whether the unit is a git repo (`git -C "<unit_path>" rev-parse --is-inside-work-tree`).
- Check the environment / CLAUDE.md for the user's name.

No questions yet. Just orient.

---

## Phase 2 — Natural conversation

Now converse naturally. No locked intro this time — the user has already seen that during `:silcrow-init`. Just orient briefly:

> *You're about to add a new unit to `@ <Parent Name>`. Let me gather a few details.*

(Or similar, adapted to context.)

### What to suggest/confirm

- **Suggest** a unit name if the conversation context implies one.
- **Propose** inheriting the parent's role names by default — *"Keep Lead and Implementer, or use domain-specific roles like Director/Specialist?"*

### What you need to gather

- **Unit name** — Title-case English, can have spaces (e.g., `Pebble Core`, `Research`). Validate that `<unit_path>/@ <Unit Name>/` doesn't already exist.
- **Unit purpose** — one sentence describing what this unit owns.
- **Lead role** — default inherits the parent unit's `lead-role` from the meta anchor; may override.
- **Implementer role** — default inherits the parent unit's `implementer-role` from the meta anchor; may override.

### Role rename guidance

Same as `:silcrow-init`: the Registrar role name is fixed across all units. User/Lead/Implementer are flexible. One name per role; the directory name *is* the display name.

### When you have enough, run the script

No "shall I run it?" confirmation for well-formed answers. Proceed to Phase 3.

---

## Phase 3 — Run the script

Invoke `scripts/add-unit.sh` with positional arguments. The first positional is the unit path you resolved in Phase 1 (the parent unit's directory). The four `--`-flagged values come straight from Phase 1's meta-anchor extraction:

```bash
"${CLAUDE_PLUGIN_ROOT}/scripts/add-unit.sh" \
    "<unit_path>" \
    "<unit_name>" \
    "<unit_purpose>" \
    "<lead_role>" \
    "<implementer_role>" \
    --agency-name "<agency_name>" \
    --user-role "<user_role>" \
    --parent-lead-role "<parent_lead_role>"
```

- `<unit_path>` is the parent unit's own directory (basename starting with `@`), as resolved in Phase 1. The new sub-unit is created as a sibling of the parent's agents and governance folders, nested directly inside `<unit_path>`.
- `<agency_name>`, `<user_role>`, and `<parent_lead_role>` come from the parent unit's `silcrow-meta` anchor: `agency`, `user-role`, and `lead-role` respectively. These render references like "route through the parent Lead or User" in the establishing ADR with real names.
- `<lead_role>` and `<implementer_role>` are the new sub-unit's roles, gathered in Phase 2.

The script:
- Authors `§NNNN | Establish Unit @ <Unit Name>.md` in `<unit_path>/1 | Canon/accepted/` using the `Establish Unit.md` template.
- Creates `<unit_path>/@ <Unit Name>/`.
- Scaffolds the new sub-unit's flat structure (`1 | Canon`, `2 | Working Files`, agent dirs, README; no `3 | Silcrow Agency Reference` — that's root-only).
- Commits with `§NNNN: establish unit @ <Unit Name>` (per §0015), unless `--skip-commit` is passed.

On success, prints a summary block:

```
✓ Added unit @ Pebble Core at /Users/trevorschoeny/Code/@ Pebble/@ Pebble Core
  Purpose: Owns patient-facing product direction and releases.
  Roles:   Director, Specialist, Registrar
  Parent:  /Users/trevorschoeny/Code/@ Pebble
  Registering ADR: /Users/trevorschoeny/Code/@ Pebble/1 | Canon/accepted/§0018 | Establish Unit @ Pebble Core.md
```

On failure, relay the error message and stop.

---

## Phase 4 — Report and hand off

Echo the script's summary block, then output this locked scripted next-steps:

> *The new unit is ready. Open a session inside `<unit_path>/@ <Unit Name>/<Lead Role> @ <Unit Name>/` to brief your unit lead. The unit's Registrar is already set up to audit its decision record.*
>
> *To verify the addition landed clean, ask the agency's Registrar to run an audit: they'll check that the ADR and directory agree, and flag any inconsistencies (§0009, §0012).*
>
> *The establishing ADR (`§NNNN | Establish Unit @ <Unit Name>.md`) has placeholders for deeper context (Why-statement reasoning, scope details, etc.). The unit's Lead or the agency Lead can edit it to fill them in — ADRs are immutable only after they're substantively complete; editing an auto-generated placeholder is part of finishing authorship.*

Substitute the angle-bracketed tokens with actual values.

---

## Rules

- **CWD must resolve to a unit.** Either CWD's basename starts with `@` (you're at the unit's root) or CWD is an agent directory whose parent is a unit. Going from agent dir to unit dir is `..` — one deterministic step, not iterative search. Refuse if CWD doesn't fit either shape.
- **All inputs come from the resolved unit path.** Agency name, user role, and parent lead role are read from the unit's `silcrow-meta` anchor; the parent unit's name is the unit path's basename. The skill does not look anywhere outside `<unit_path>` to figure out the unit's context.
- **Use the script.** Don't try to hand-create the unit's directory tree or ADR.
- **Never overwrite existing units.** The script refuses on conflict; relay the error.
- **The ADR template has placeholders** that the script fills only partially (name, purpose, roles, date, §-number). Other placeholders (reasoning, scope specifics) are left for the Lead/User to fill in after the unit is established.
- If the plugin's scripts are missing or not executable, stop and report that the plugin is not installed correctly.
