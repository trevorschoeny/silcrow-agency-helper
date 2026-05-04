---
name: silcrow-add-unit
description: Add a new sub-unit nested inside a unit. **Lead-only** — only the Lead of the parent unit invokes this. Authors the establishing ADR and scaffolds the new sub-unit's `@ <Unit Name>/` governance folder in one coherent motion. Use when the user says "add a unit," "create a new unit," "split off a unit," "new sub-unit," "scaffold unit," or similar within an existing scaffolded agency.
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

**Only the Lead of the parent unit runs this skill.**

Adding a sub-unit is a roster change (§0008) — a substantive structural decision about scope, ownership, and tier dynamics. Per §0009, that's the Lead's call, not the Registrar's (who can only audit afterwards) and not other roles'.

If you (the agent reading this) are anyone other than the Lead of the unit you'd be adding INTO — Implementer, Registrar, User, sub-unit Lead, or any custom agent — **stop**. Do not proceed. Tell the user:

> *"This skill must be run by the Lead of the unit that will be the new sub-unit's parent. Open a session inside `<Lead Role> @ <Parent Unit Name>/` and re-run `:silcrow-add-unit` there."*

The skill enforces this with a CWD check (Phase 1 below).

## Why Lead-only

- **Adding a unit is substantive.** It changes the agency's structure, allocates work to a new agent team, and writes a new establishing ADR with a Why-statement, scope claims, and reasoning. §0009 makes the Registrar's authority strictly procedural; they can audit afterwards but can't author the decision.
- **The Lead of the parent unit is the right author.** They own architecture for `@ <Parent Unit Name>` (§0006 tier model); deciding to split off a sub-unit is exactly that kind of architectural call.
- **Sub-unit Leads don't run it.** A sub-unit Lead inside `@ <Parent>` could invoke this from their own dir, but that creates a sub-sub-unit nested inside the *sub-unit*, not inside `@ <Parent>`. The parent unit's Lead is the right invoker for adding sub-units to `@ <Parent>` directly.
- **The User can invoke** by opening a session at the Lead's directory; that's the operational path. From the User's own role directory, the skill refuses (the User's session is for principal-level work, not unit-level architectural authoring).

## When to use

- The work has matured enough that an area of `@ <Parent Unit Name>`'s scope deserves its own decision record and agent team.
- The user says something like "let's split X into its own unit" or "I want to add a sub-unit for Y."
- If the user hasn't yet run `:silcrow-init`, this skill detects that and redirects them. To update an existing agency to the current scaffold, use `:silcrow-update`.

## How this skill works

Four phases: **silent peek and verify → natural conversation → run add-unit script → report with hand-off**. The bundled script `scripts/add-unit.sh` does the mechanical work — renders the establishing ADR, creates the sub-unit directory nested inside the parent unit, scaffolds the flat structure (`1 | Canon`, `2 | Working Files`, agent dirs, README, `_templates/`, seeded §0001 + §0002), and commits.

---

## Phase 1 — Verify CWD is the parent unit's Lead directory

Before any output, run all four checks. Fail any → stop and redirect the user. **Do not proceed with checks failing.**

1. **CWD shape check.** `pwd` to find CWD. Its basename must match the pattern `<X> @ <Y>` (a single space-`@`-space). If basename starts with `@ ` (i.e., the unit root) or has no `@` at all, refuse.
2. **Parent is a unit.** `<cwd>/..` must exist and its basename must start with `@ ` (it's a unit directory). This is the parent unit you'd be adding INTO.
3. **Anchor present.** Read `<cwd>/../README.md` and extract the `silcrow-meta` anchor's four fields:
   - `agency="..."`
   - `user-role="..."`
   - `lead-role="..."`
   - `implementer-role="..."`
   If the anchor is missing or any field is absent, refuse — the agency predates 0.21.0 and needs `:silcrow-update` first.
4. **CWD's prefix is the unit's Lead role.** CWD basename's prefix (the part before ` @ `) must exactly match the parent unit's `lead-role` from the anchor. If `lead-role="Lead"` and CWD's basename starts with `Lead `, you're in the Lead's dir. If `lead-role="Director"` and CWD's basename starts with `Director `, same. Mismatch (e.g., `Implementer @ Pebble`, `Registrar @ Pebble`, `Trevor @ Pebble`) → refuse.

### Failure messages

- **CWD's basename doesn't match `<X> @ <Y>`:** *"This skill must be run from the Lead's directory of the unit you're adding INTO. Navigate into `<Lead Role> @ <Parent Unit Name>/` and re-run."*
- **Parent isn't a unit:** *"You're not inside a scaffolded agency. Run `:silcrow-init` first, or navigate into an existing agency."*
- **Missing anchor or fields:** *"This unit's README is missing its complete `silcrow-meta` anchor. Run `:silcrow-update` to bring the agency in line with the current scaffold, then try again."*
- **CWD's prefix doesn't match `lead-role`:** *"Adding a sub-unit is a substantive architectural decision, which only the parent unit's Lead can author (§0009). Your current directory looks like a different role's session (its prefix doesn't match this unit's lead-role of `<the-actual-lead-role>`). Open a session inside `<Lead Role> @ <Parent Unit Name>/` and re-run."*

### What to remember after Phase 1

- The parent unit's path: `<cwd>/..`
- The parent unit's name (basename minus `@ `).
- The four anchor values: `agency`, `user-role`, `lead-role` (= the parent's lead role; the new sub-unit's `parent-lead-role`), `implementer-role` (= the parent's implementer role; the new sub-unit's default-inherit value for its own implementer role).
- Existing unit-establishing ADRs in the parent's canon (scan `<cwd>/../1 | Canon/accepted/` for filenames containing `Establish Unit`) — these tell you what sub-unit names are taken.
- Whether the unit is a git repo.
- The user's name (from environment / CLAUDE.md).

---

## Phase 2 — Natural conversation

Now converse naturally. No locked intro this time — the user has already seen one during `:silcrow-init`. Just orient briefly:

> *You're about to add a new unit to `@ <Parent Unit Name>`. Let me gather a few details.*

(Or similar, adapted to context.)

### What to suggest/confirm

- **Suggest** a unit name if the conversation context implies one.
- **Propose** inheriting the parent's role names by default — *"Keep `<lead_role>` and `<implementer_role>`, or use domain-specific roles like Director/Specialist?"*

### What you need to gather

- **Unit name** — Title-case English, can have spaces (e.g., `Pebble Core`, `Research`). Validate that `<cwd>/../@ <Unit Name>/` doesn't already exist.
- **Unit purpose** — one sentence describing what this unit owns.
- **Lead role** — default inherits the parent unit's `lead-role` from the meta anchor; may override.
- **Implementer role** — default inherits the parent unit's `implementer-role` from the meta anchor; may override.

### Role rename guidance

Same as `:silcrow-init`: the Registrar role name is fixed across all units. User/Lead/Implementer are flexible. One name per role; the directory name *is* the display name.

### When you have enough, run the script

No "shall I run it?" confirmation for well-formed answers. Proceed to Phase 3.

---

## Phase 3 — Run the script

Invoke `scripts/add-unit.sh` with positional arguments. The first positional is the parent unit's path (`<cwd>/..`). The three `--`-flagged values come from Phase 1's meta-anchor extraction:

```bash
"${CLAUDE_PLUGIN_ROOT}/scripts/add-unit.sh" \
    "<parent_unit_path>" \
    "<unit_name>" \
    "<unit_purpose>" \
    "<lead_role>" \
    "<implementer_role>" \
    --agency-name "<agency_name>" \
    --user-role "<user_role>" \
    --parent-lead-role "<parent_lead_role>"
```

- `<parent_unit_path>` is `<cwd>/..` resolved to an absolute path. Quote it (it contains spaces and `@`).
- `<agency_name>`, `<user_role>`, `<parent_lead_role>` come from the parent unit's `silcrow-meta` anchor (`agency`, `user-role`, `lead-role` respectively).
- `<lead_role>` and `<implementer_role>` are the new sub-unit's roles, gathered in Phase 2.

The script:
- Authors `§NNNN | Establish Unit @ <Unit Name>.md` in `<parent_unit_path>/1 | Canon/accepted/` using the `Establish Unit.md` template.
- Creates `<parent_unit_path>/@ <Unit Name>/`.
- Scaffolds the new sub-unit's flat structure (`1 | Canon`, `2 | Working Files`, agent dirs, README, local `_templates/`; no `3 | Silcrow Agency Reference` — that's root-only).
- Seeds the sub-unit's canon with §0001 (parent adoption) and §0002 (scope seed).
- Commits with `§NNNN: establish unit @ <Unit Name>` (per §0015), unless `--skip-commit` is passed.

On success, prints a summary block:

```
✓ Added unit @ Pebble Core at /Users/trevorschoeny/Code/@ Pebble/@ Pebble Core
  Purpose: Owns patient-facing product direction and releases.
  Roles:   Director, Specialist, Registrar
  Parent:  /Users/trevorschoeny/Code/@ Pebble
  Registering ADR (in parent's canon): ...
  Sub-unit's local canon seeded with:
    §0001 | Adopt @ Pebble as parent unit
    §0002 | @ Pebble Core Scope (seed — supersede early)
```

On failure, relay the error message and stop.

---

## Phase 4 — Report and hand off

Echo the script's summary block, then output this scripted next-steps:

> *The new unit is ready. Open a session inside `<parent_unit_path>/@ <Unit Name>/<Lead Role> @ <Unit Name>/` to brief your unit lead. The unit's Registrar is already set up to audit its decision record.*
>
> *To verify the addition landed clean, ask the agency's Registrar to run an audit: they'll check that the ADR and directory agree, and flag any inconsistencies (§0009, §0012).*
>
> *The establishing ADR has placeholders for deeper context (Why-statement reasoning, scope details, etc.). You or the new unit's Lead can edit it to fill them in — ADRs are immutable only after they're substantively complete; editing an auto-generated placeholder is part of finishing authorship.*
>
> *The new sub-unit also ships with §0001 (parent adoption) and §0002 (scope seed) in its own canon. The new unit's first authoring exercise is typically to supersede §0002 with a richer scope statement — the supersession discipline that governs every binding decision in this agency.*

Substitute the angle-bracketed tokens with actual values.

---

## Rules

- **Lead-only invocation.** Verified by Phase 1's checks. Refuse to proceed otherwise. The Lead of the parent unit (the unit that will host the new sub-unit) is the only valid invoker.
- **CWD must be the parent unit's Lead directory.** No exception — not the unit root, not Implementer's dir, not Registrar's dir, not User's dir, not a custom agent's dir.
- **All inputs come from CWD/`..`** (the parent unit). Agency name, user role, parent lead role are read from the parent unit's `silcrow-meta` anchor; the parent unit's name is the parent's basename. The skill does not look anywhere outside CWD and CWD/`..`.
- **Use the script.** Don't try to hand-create the unit's directory tree or ADR.
- **Never overwrite existing units.** The script refuses on conflict; relay the error.
- **The ADR template has placeholders** that the script fills only partially (name, purpose, roles, date, §-number). Other placeholders (reasoning, scope specifics) are left for the Lead/User to fill in after the unit is established.
- If the plugin's scripts are missing or not executable, stop and report that the plugin is not installed correctly.
