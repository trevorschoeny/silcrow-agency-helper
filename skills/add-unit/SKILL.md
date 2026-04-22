---
name: add-unit
description: Add a new unit to an existing agency (or sub-unit to an existing unit). Authors the establishing ADR and scaffolds the unit's #ORG/ governance folder in one coherent motion. Use when the user says "add a unit," "create a new unit," "split off a unit," "new sub-unit," "scaffold unit," or similar within an existing scaffolded agency.
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

Add a new unit to an existing agency (or sub-unit to an existing unit). The skill authors the establishing ADR (per §0015) *and* runs the mechanical scaffolding in one motion. Lead or User invokes; Registrar audits afterwards.

## When to use

- The user wants to add a sub-organization to an existing agency.
- The work has matured enough that it deserves its own decision record and agent team.
- The user says something like "let's split X into its own unit" or "I want to add a sub-unit for Y."

If the user hasn't yet run `:init`, this skill will detect that and redirect them. If they want to update an existing agency to the current scaffold, direct them to `:update`.

## How this skill works

Four-phase flow: **silent peek → natural conversation → run add-unit script → report with hand-off**. The bundled script `scripts/add-unit.sh` does the mechanical work — renders the establishing ADR, creates the unit directory, scaffolds its `#ORG/`, and commits.

---

## Phase 1 — Peek silently

Before any output:

- `pwd` to find the current working directory.
- Walk upward from the CWD to find the nearest `#ORG/` directory. That's the parent unit this skill will add a unit inside.
  - If the CWD itself has `#ORG/`, the parent is the CWD.
  - If no `#ORG/` is found walking up, stop and tell the user: *"I don't see an agency or unit here (no `#ORG/` in the current or parent directories). Run `:init` first to scaffold an agency, or navigate to an existing agency's directory."* Do not proceed.
- Read the parent's `#ORG/README.md` to understand the agency's context and naming conventions.
- Scan the parent's `#ORG/adr/accepted/` for existing unit-establishing ADRs (look for filenames containing `establish-unit`) — these tell you what units already exist and what names are taken.
- Check whether the parent is a git repo (`git rev-parse --is-inside-work-tree`).
- Check whether the parent uses submodules (`git submodule status` — non-empty output means yes).
- Check the environment / CLAUDE.md for the user's name.

No questions yet. Just orient.

---

## Phase 2 — Natural conversation

Now converse naturally. No locked intro this time — the user has already seen that during `:init`. Just orient briefly:

> *You're about to add a new unit to `@<parent-name>`. Let me gather a few details.*

(Or similar, adapted to context.)

### What to suggest/confirm

- **Suggest** a unit name if the conversation context implies one.
- **Propose** inheriting the parent's role names by default — *"Keep Lead and Implementer, or use domain-specific roles like Director/Specialist?"*
- **Default mode** to `directory`. Only ask about submodule if the user mentions independent versioning, a separate codebase, or an existing remote repo.
- If the parent already uses submodules for other units, suggest submodule mode by default and ask the user to confirm.

### What you need to gather

- **Unit name** — kebab-case, lowercase (will be prefixed with `@`). Validate that `@<name>/` doesn't already exist under the parent.
- **Unit purpose** — one sentence describing what this unit owns.
- **Lead directory + display name** — default inherits agency; may override.
- **Implementer directory + display name** — default inherits agency; may override.
- **Mode** — `directory` (default) or `submodule` (§0019).
- **If submodule:** source (remote URL, local path, or blank for fresh init).

### Role rename guidance

Same as `:init`: the Registrar role name is fixed across all units. User/Lead/Implementer are flexible. If the user wants domain-specific titles, gather both display name and directory name (default kebab-case of display name).

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
    "<lead_dir>" \
    "<lead_role>" \
    "<implementer_dir>" \
    "<implementer_role>" \
    --user-role "<agency_user_role>" \
    --parent-lead-role "<agency_lead_role>" \
    [--mode directory|submodule] \
    [--submodule-source <url_or_path>]
```

To find the agency's user role and lead role: read the parent's `#ORG/README.md`
or inspect `#ORG/agents/` directory names and the matching `instructions.md`
role names. These values feed into the unit's establishing ADR so references
like "route through the agency Director or Trevor" render with the real names.

`<parent_path>` is the directory that contains the target `#ORG/` (the one the skill found in Phase 1). Usually that's the agency root, but for sub-units of a unit it's the unit's root.

The script:
- Authors `§NNNN-establish-unit-<name>.md` in `<parent_path>/#ORG/adr/accepted/` using the `establish-unit.md` template.
- Creates `<parent_path>/@<unit_name>/` (or `git submodule add ... @<unit_name>` if submodule mode).
- Scaffolds the unit's `#ORG/` with agents, ADR tree, docs, README.
- Commits with `§NNNN: establish unit @<name>` (per §0018), unless `--skip-commit` is passed.

On success, prints a summary block:

```
✓ Added unit @pebble-core at /Users/trevorschoeny/Code/@pebble/@pebble-core
  Purpose: Owns patient-facing product direction and releases.
  Roles:   Director, Specialist, Registrar
  Parent:  /Users/trevorschoeny/Code/@pebble
  Mode:    directory
  Registering ADR: /Users/trevorschoeny/Code/@pebble/#ORG/adr/accepted/§0020-establish-unit-pebble-core.md
```

On failure, relay the error message and stop.

---

## Phase 4 — Report and hand off

Echo the script's summary block, then output this locked scripted next-steps:

> *The new unit is ready. Open a session inside `<parent_path>/@<unit_name>/#ORG/agents/<lead_dir>/` to brief your unit lead. The unit's Registrar is already set up to audit its decision record.*
>
> *To verify the addition landed clean, ask the agency's Registrar to run an audit: they'll check that the ADR and directory agree, and flag any inconsistencies (§0012, §0015).*
>
> *The establishing ADR (`§NNNN-establish-unit-<unit_name>.md`) has placeholders for deeper context (y-statement reasoning, scope details, etc.). The unit's Lead or the agency Lead can edit it to fill them in — ADRs are immutable only after they're substantively complete; editing an auto-generated placeholder is part of finishing authorship.*

Substitute the angle-bracketed tokens with actual values.

---

## Rules

- **Walk up to find `#ORG/`.** Don't assume the CWD is the parent. Sub-units can be added inside units, and the skill must figure out the correct parent.
- **Refuse to proceed if no `#ORG/` is found.** Redirect to `:init`.
- **Use the script.** Don't try to hand-create the unit's directory tree or ADR.
- **Never overwrite existing units.** The script refuses on conflict; relay the error.
- **The ADR template has placeholders** that the script fills only partially (name, purpose, roles, date, §-number). Other placeholders (reasoning, scope specifics) are left for the Lead/User to fill in after the unit is established.
- If the plugin's scripts are missing or not executable, stop and report that the plugin is not installed correctly.
