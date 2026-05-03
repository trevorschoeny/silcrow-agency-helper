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

The skill assumes the current working directory **is** the parent unit — i.e., its basename starts with `@`. If it isn't, the skill stops and tells the user. If the user hasn't yet run `:silcrow-init`, this skill will detect that and redirect them. If they want to update an existing agency to the current scaffold, direct them to `:silcrow-update`.

## How this skill works

Four-phase flow: **silent peek → natural conversation → run add-unit script → report with hand-off**. The bundled script `scripts/add-unit.sh` does the mechanical work — renders the establishing ADR, creates the sub-unit directory nested inside the current unit, scaffolds the flat structure (`1 | Canon`, `2 | Working Files`, agent dirs, README), and commits.

---

## Phase 1 — Peek silently

Before any output:

- `pwd` to find the current working directory. Verify its basename starts with `@`. If it doesn't, stop and tell the user: *"I don't see a unit here (the current directory's basename doesn't start with `@`). Navigate into a unit's directory (the one named `@ <Unit Name>/`) and try again. If you haven't scaffolded an agency yet, run `:silcrow-init` first."* Do not proceed.
- Read the unit's own `README.md` at `<cwd>/README.md`. Extract the four meta fields from its `silcrow-meta` anchor on the first line:
  - `agency="..."` — the agency name (used in the establishing ADR's references)
  - `user-role="..."` — the agency's user role (used for "route through the User or ..." references)
  - `lead-role="..."` — this unit's lead role (becomes the new sub-unit's `parent-lead-role`)
  - `implementer-role="..."` — this unit's implementer role (used as the default-inherit value when proposing the new sub-unit's roles)

  If the anchor is missing or any field is absent, tell the user: *"This unit's README is missing its complete `silcrow-meta` anchor. Run `:silcrow-update` to bring the agency in line with the current scaffold, then try again."* Do not proceed.

  The unit's own name is the CWD basename minus the `@ ` prefix. That's the parent unit's name for the new sub-unit.
- Scan `<cwd>/1 | Canon/accepted/` for existing unit-establishing ADRs (look for filenames containing `Establish Unit`) — these tell you what sub-units already exist and what names are taken.
- Check whether the unit is a git repo (`git rev-parse --is-inside-work-tree`).
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

- **Unit name** — Title-case English, can have spaces (e.g., `Pebble Core`, `Research`). Validate that `<cwd>/@ <Unit Name>/` doesn't already exist.
- **Unit purpose** — one sentence describing what this unit owns.
- **Lead role** — default inherits the parent unit's `lead-role` from the meta anchor; may override.
- **Implementer role** — default inherits the parent unit's `implementer-role` from the meta anchor; may override.

### Role rename guidance

Same as `:silcrow-init`: the Registrar role name is fixed across all units. User/Lead/Implementer are flexible. One name per role; the directory name *is* the display name.

### When you have enough, run the script

No "shall I run it?" confirmation for well-formed answers. Proceed to Phase 3.

---

## Phase 3 — Run the script

Invoke `scripts/add-unit.sh` with positional arguments. The first positional is the current working directory (the parent unit's path). The four `--`-flagged values come straight from Phase 1's meta-anchor extraction:

```bash
"${CLAUDE_PLUGIN_ROOT}/scripts/add-unit.sh" \
    "<cwd>" \
    "<unit_name>" \
    "<unit_purpose>" \
    "<lead_role>" \
    "<implementer_role>" \
    --agency-name "<agency_name>" \
    --user-role "<user_role>" \
    --parent-lead-role "<parent_lead_role>"
```

- `<cwd>` is the current working directory (the parent unit's own directory, basename starting with `@`). The new sub-unit is created as a sibling of the parent's agents and governance folders, nested directly inside `<cwd>`.
- `<agency_name>`, `<user_role>`, and `<parent_lead_role>` come from the parent unit's `silcrow-meta` anchor: `agency`, `user-role`, and `lead-role` respectively. These render references like "route through the parent Lead or User" in the establishing ADR with real names.
- `<lead_role>` and `<implementer_role>` are the new sub-unit's roles, gathered in Phase 2.

The script:
- Authors `§NNNN | Establish Unit @ <Unit Name>.md` in `<cwd>/1 | Canon/accepted/` using the `Establish Unit.md` template.
- Creates `<cwd>/@ <Unit Name>/`.
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

> *The new unit is ready. Open a session inside `<cwd>/@ <Unit Name>/<Lead Role> @ <Unit Name>/` to brief your unit lead. The unit's Registrar is already set up to audit its decision record.*
>
> *To verify the addition landed clean, ask the agency's Registrar to run an audit: they'll check that the ADR and directory agree, and flag any inconsistencies (§0009, §0012).*
>
> *The establishing ADR (`§NNNN | Establish Unit @ <Unit Name>.md`) has placeholders for deeper context (Why-statement reasoning, scope details, etc.). The unit's Lead or the agency Lead can edit it to fill them in — ADRs are immutable only after they're substantively complete; editing an auto-generated placeholder is part of finishing authorship.*

Substitute the angle-bracketed tokens with actual values.

---

## Rules

- **CWD must be a unit.** The skill operates on the current working directory and only the current working directory. Its basename must start with `@`. If not, refuse and redirect to `:silcrow-init` (or tell the user to navigate into a unit's directory first).
- **All inputs come from CWD.** Agency name, user role, and parent lead role are read from CWD's `silcrow-meta` anchor; the parent unit's name is CWD's basename. The skill does not look anywhere outside CWD to figure out what unit it's in.
- **Use the script.** Don't try to hand-create the unit's directory tree or ADR.
- **Never overwrite existing units.** The script refuses on conflict; relay the error.
- **The ADR template has placeholders** that the script fills only partially (name, purpose, roles, date, §-number). Other placeholders (reasoning, scope specifics) are left for the Lead/User to fill in after the unit is established.
- If the plugin's scripts are missing or not executable, stop and report that the plugin is not installed correctly.
