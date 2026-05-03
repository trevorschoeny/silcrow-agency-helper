---
name: silcrow-add-unit
description: Add a new unit to an existing agency (or sub-unit to an existing unit). Authors the establishing ADR and scaffolds the unit's `@ <Unit Name>/` governance folder in one coherent motion. Use when the user says "add a unit," "create a new unit," "split off a unit," "new sub-unit," "scaffold unit," or similar within an existing scaffolded agency.
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

Add a new unit to an existing agency (or sub-unit to an existing unit). The skill authors the establishing ADR (per §0012) *and* runs the mechanical scaffolding in one motion. Lead or User invokes; Registrar audits afterwards.

The new sub-unit is created nested inside the parent unit's directory as a sibling of the parent's agents, `1 | Canon`, `2 | Working Files`, and any other governance folders (per §0012's flat layout). `3 | Silcrow Agency Reference` stays at the root unit only; sub-units inherit it.

## When to use

- The user wants to add a sub-organization to an existing agency.
- The work has matured enough that it deserves its own decision record and agent team.
- The user says something like "let's split X into its own unit" or "I want to add a sub-unit for Y."

If the user hasn't yet run `:silcrow-init`, this skill will detect that and redirect them. If they want to update an existing agency to the current scaffold, direct them to `:silcrow-update`.

## How this skill works

Four-phase flow: **silent peek → natural conversation → run add-unit script → report with hand-off**. The bundled script `scripts/add-unit.sh` does the mechanical work — renders the establishing ADR, creates the sub-unit directory nested inside the parent unit, scaffolds the flat structure (`1 | Canon`, `2 | Working Files`, agent dirs, README), and commits.

---

## Phase 1 — Peek silently

Before any output:

- `pwd` to find the current working directory.
- Walk upward from the CWD to find the nearest directory whose basename starts with `@`. That directory IS the parent unit this skill will add a unit inside.
  - If the CWD itself has a basename starting with `@`, the parent unit is the CWD itself.
  - If no `@`-prefixed directory is found walking up, stop and tell the user: *"I don't see an agency or unit here (no `@ <Unit Name>/` in the current or parent directories). Run `:silcrow-init` first to scaffold an agency, or navigate to an existing agency's directory."* Do not proceed.
- Read the parent unit's own `README.md` (at the parent unit's path) to understand the agency's context and naming conventions.
- Scan `<parent_path>/1 | Canon/accepted/` for existing unit-establishing ADRs (look for filenames containing `Establish Unit`) — these tell you what units already exist and what names are taken.
- Check whether the parent is a git repo (`git rev-parse --is-inside-work-tree`).
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

- **Unit name** — Title-case English, can have spaces (e.g., `Pebble Core`, `Research`). Validate that `@ <Unit Name>/` doesn't already exist under the parent.
- **Unit purpose** — one sentence describing what this unit owns.
- **Lead role** — default inherits agency; may override.
- **Implementer role** — default inherits agency; may override.

### Role rename guidance

Same as `:silcrow-init`: the Registrar role name is fixed across all units. User/Lead/Implementer are flexible. One name per role; the directory name *is* the display name.

### When you have enough, run the script

No "shall I run it?" confirmation for well-formed answers. Proceed to Phase 3.

---

## Phase 3 — Run the script

Invoke `scripts/add-unit.sh` with positional arguments:

```bash
"${CLAUDE_PLUGIN_ROOT}/scripts/add-unit.sh" \
    "<parent_path>" \
    "<unit_name>" \
    "<unit_purpose>" \
    "<lead_role>" \
    "<implementer_role>" \
    --user-role "<agency_user_role>" \
    --parent-lead-role "<parent_lead_role>"
```

To find the agency's user role and the parent unit's lead role: read the parent unit's own `README.md` or inspect the agent dir names (`<Role> @ <Parent Name>/`) and their `AGENTS.md` role names. These values feed into the unit's establishing ADR so references like "route through the parent Lead or Trevor" render with the real names.

`--agency-name` is **optional** — the script walks up the tree from `<parent_path>` to find the agency's root unit (the outermost `@`-prefixed directory in the chain) and reads the agency name from there. Pass it explicitly only when you need to override the auto-detection.

`<parent_path>` is the **parent unit's own directory** (the `@ <Parent Name>/` directory found by Phase 1's walk-up). The new sub-unit is created as a sibling of the parent's agents and governance folders, nested directly inside `<parent_path>`.

The script:
- Authors `§NNNN | Establish Unit @ <Unit Name>.md` in `<parent_path>/1 | Canon/accepted/` using the `Establish Unit.md` template.
- Creates `<parent_path>/@ <Unit Name>/`.
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

> *The new unit is ready. Open a session inside `<parent_path>/@ <Unit Name>/<Lead Role> @ <Unit Name>/` to brief your unit lead. The unit's Registrar is already set up to audit its decision record.*
>
> *To verify the addition landed clean, ask the agency's Registrar to run an audit: they'll check that the ADR and directory agree, and flag any inconsistencies (§0009, §0012).*
>
> *The establishing ADR (`§NNNN | Establish Unit @ <Unit Name>.md`) has placeholders for deeper context (Why-statement reasoning, scope details, etc.). The unit's Lead or the agency Lead can edit it to fill them in — ADRs are immutable only after they're substantively complete; editing an auto-generated placeholder is part of finishing authorship.*

Substitute the angle-bracketed tokens with actual values.

---

## Rules

- **Walk up to find a directory whose basename starts with `@`.** Don't assume the CWD is the parent unit. Sub-units can be added inside units, and the skill must figure out the correct parent.
- **Refuse to proceed if no `@`-prefixed directory is found.** Redirect to `:silcrow-init`.
- **Use the script.** Don't try to hand-create the unit's directory tree or ADR.
- **Never overwrite existing units.** The script refuses on conflict; relay the error.
- **The ADR template has placeholders** that the script fills only partially (name, purpose, roles, date, §-number). Other placeholders (reasoning, scope specifics) are left for the Lead/User to fill in after the unit is established.
- If the plugin's scripts are missing or not executable, stop and report that the plugin is not installed correctly.
