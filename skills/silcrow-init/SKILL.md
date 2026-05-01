---
name: silcrow-init
description: Scaffold a Silcrow agency — a hierarchical agent organization with ADR decision tracking, actor-model messaging, and registrar-enforced record integrity. Use when the user says "scaffold agent organization," "initialize agency," "set up agent org," "bootstrap agency," "new agency," "silcrow," "Silcrow agency," or similar.
user-invocable: true
allowed-tools:
  - Read
  - Glob
  - Grep
  - Bash(ls:*)
  - Bash(test:*)
  - Bash(mv:*)
  - Bash(git:*)
  - Bash(${CLAUDE_PLUGIN_ROOT}/scripts/scaffold.sh:*)
  - Bash(${CLAUDE_PLUGIN_ROOT}/scripts/add-unit.sh:*)
  - AskUserQuestion
---

# Agent Org Scaffold — Init

Initialize a disciplined **agency** — a hierarchical agent organization with built-in decision tracking, actor-model messaging, and registrar-enforced record integrity. The scaffold ships a founding set of constitutional ADRs (§0001–§0019) that capture the pattern's load-bearing decisions.

An **agency** is the whole organizational tree. Its top-level node is the **root unit**, which shares the agency's name. The tree may stop there (a single root unit, one cohesive body of work) or extend into nested **sub-units** — each itself a full unit, recursively, with its own governance and agents (§0015). The scaffold supports both shapes.

## One-shot skill

Run this skill **once**, at agency initialization. After scaffolding completes, the generated structure carries all conventions forward. **Do not re-invoke `:silcrow-init`** to modify an existing agency — use `:silcrow-add-unit` for new units or `:silcrow-update` to bring the agency in line with the current scaffold release.

If the user asks to "re-run" `:silcrow-init` on an existing agency, stop and explain. Redirect them to `:silcrow-update` (for plugin-driven changes) or manual editing (for their own conventions).

## How this skill works

The skill follows a six-phase flow: **silent peek → locked intro → natural conversation → run scaffold script → report → locked next-steps**. Two bundled bash scripts do the mechanical work: `scripts/scaffold.sh` for the agency, and `scripts/add-unit.sh` for each additional unit (if any). Your job is to gather the inputs conversationally and invoke the scripts.

---

## Phase 1 — Peek silently

Before any output to the user:

- `ls` the current working directory (and any path the user indicates as destination).
- Look for obvious project markers: README, package.json, pyproject.toml, Cargo.toml, etc. Use these to orient.
- Check for `.git/` at the destination. If present, git init will be skipped and existing history will be preserved.
- Walk the destination (one level deep) to find any nested `.git/` directories — these are flagged for the user later but not acted on here.
- Check CLAUDE.md or the environment for the user's name. If found, you'll substitute it into the locked intro; if not, you'll silently omit.
- Note whether the destination directory's basename starts with `@`. That's the scaffold convention for units, and agencies are units (§0015). If it doesn't start with `@`, you'll offer a rename during conversation.

No questions yet. No output. Just orient.

---

## Phase 2 — Deliver the locked intro (verbatim)

Output this text exactly. The only substitution is the user's name — inserted when known, silently omitted when not. The `{, <name>}` token renders as `, <name>` when known and as empty when not.

> *This scaffold sets up an **agency** — a disciplined structure for decision-making and coordinated work, whether that work is a product, a team, a research effort, a coding project, or any kind of initiative where decisions need to be recorded and authority needs to be clear.*
>
> *Every agency has a hierarchy: a user (you{, <name>} — the human) sets strategic direction and works with the lead to brainstorm and strategize; the lead translates that into briefs; the implementer does the work. A registrar keeps the decision record clean. That's the default shape.*
>
> *An agency is the whole tree of work. Its topmost node is the **root unit** (which shares the agency's name); below the root, an agency can stay as a single unit — one cohesive body of work — or branch into **sub-units**, each itself a full unit with its own governance and agent team. Every unit, root or sub, has the same shape. Units can be departments, teams, product lines, research threads, codebases — any partition of the work that's independent enough to deserve its own decision record and agent team.*
>
> *Two rules matter: **sub-units answer to their parent unit** (decisions at any unit bind that unit and everything below it), and **sibling units don't police each other** (no cross-branch oversight).*

Output this, then drop out of scripted mode.

---

## Phase 3 — Natural conversation

Now converse naturally. Based on what you peeked, do the following in whichever order feels natural:

### What to suggest/confirm

- **Suggest** an agency name if the directory or project files imply one. Example: if the CWD is `my-wedding/`, suggest "Wedding" or similar.
- **Confirm** the user's name if you couldn't detect it.
- **Propose** single-unit vs multi-unit based on what you found. If multi-unit, suggest initial unit names and purposes.
- **Note** if a `.git/` already exists at the destination (scaffold will skip `git init`). If nested `.git/` directories exist inside the destination, mention that you'll flag them for the Registrar at first audit.
- **Check the directory-name convention.** If the current directory doesn't start with `@`, surface the convention and offer a rename:
  > *By scaffold convention, agencies use the `@` prefix like units do (§0015). Your current directory is `foo/`. Should I rename it to `@foo/` before scaffolding?*
  The user can accept the rename (do `git mv` or `mv` as appropriate) or proceed with the unprefixed name (the `#ORG/` marker identifies it as an agency either way).
- **Ask only what you can't infer.** No forms, no numbered phases. Conversational.

### What you need to gather

**Agency-level (for `scripts/scaffold.sh`):**

- Destination path (absolute preferred).
- Agency name (display form, e.g. "Acme Co" or "Wedding").
- Agency description (one sentence, one paragraph — whatever feels right).
- User directory name (kebab-case, lowercase; default `user` or the user's first name).
- User display name (title-case, e.g. "Trevor" or "User").
- Lead directory name (default `lead`).
- Lead display name (default `Lead`; user may rename to Director, Architect, Editor, etc.).
- Implementer directory name (default `implementer`).
- Implementer display name (default `Implementer`; may rename to Specialist, Engineer, Associate, etc.).

**Per unit (only if multi-unit; `scripts/add-unit.sh` invoked for each):**

- Unit name (kebab-case, lowercase; will be prefixed with `@`).
- Unit purpose (one sentence).
- Lead directory + display name for this unit (default inherits agency; may override).
- Implementer directory + display name for this unit (default inherits agency; may override).
- Mode: `directory` (default) or `submodule` (§0019 — for units with independent versioning).
- If submodule, submodule source (remote URL, local path, or blank for fresh init).

### Role rename guidance

The `Registrar` name is part of the pattern — don't rename it. User, Lead, and Implementer are flexible display names. When a user wants domain-specific vocabulary, ask for both the display name (e.g., "Director") and whether they want a different directory name (by default, derive `director` from `Director` via kebab-case).

### When you have enough, run the scaffold

No "shall I run it?" confirmation. If the answers are well-formed, proceed to Phase 4. If an answer is genuinely ambiguous, ask the clarifying question. A well-formed set of answers should never produce an extra confirmation prompt.

---

## Phase 4 — Run the scaffold

### Agency first

Invoke `scripts/scaffold.sh` with nine positional arguments:

```bash
"${CLAUDE_PLUGIN_ROOT}/scripts/scaffold.sh" \
    "<destination>" \
    "<agency_name>" \
    "<agency_description>" \
    "<user_dir>" \
    "<user_role>" \
    "<lead_dir>" \
    "<lead_role>" \
    "<implementer_dir>" \
    "<implementer_role>"
```

If the destination already contains a git repo (the user is scaffolding inside an existing repo), the script detects that and skips `git init` gracefully. If the user declined git entirely, pass `--skip-git`.

Quote every argument so values with spaces pass through cleanly.

The script:
- Prints `✓ Scaffolded <agency_name> at <destination>` on success.
- Exits 3 on conflict (existing `#ORG/` at destination). Relay the error; do not attempt recovery.
- Prints nested `.git/` warnings if any were detected. Pass these forward in your report.

### Units next (if multi-unit)

For each declared unit, invoke `scripts/add-unit.sh`. The first positional argument is the parent unit's path — at init time, that's the agency root (`<destination>`):

```bash
"${CLAUDE_PLUGIN_ROOT}/scripts/add-unit.sh" \
    "<destination>" \
    "<unit_name>" \
    "<unit_purpose>" \
    "<unit_lead_dir>" \
    "<unit_lead_role>" \
    "<unit_implementer_dir>" \
    "<unit_implementer_role>" \
    --user-role "<user_role>" \
    --user-dir "<user_dir>" \
    --parent-lead-role "<lead_role>" \
    [--unit-display "<unit_display>"] \
    [--agency-dir "<agency_dir>"] \
    [--agency-name "<agency_name>"] \
    [--mode directory|submodule] \
    [--submodule-source <url_or_path>]
```

Pass `--user-role`, `--user-dir`, and `--parent-lead-role` so the unit's
establishing ADR and templates render with the agency's actual role and
directory names (for references like "route through the agency Lead or User").

`--agency-dir` and `--agency-name` are **optional** — by default the script
walks up from the parent path to find the agency's root unit (the topmost
`#ORG/` in the tree) and reads the agency name from there. Pass them
explicitly only if you need to override the auto-detection.

`--unit-display` is also **optional** — if omitted, the script title-cases
`<unit_name>` (e.g. `pebble-core` → `Pebble Core`). Pass it when you want a
display form that differs from the auto-cased default.

Each invocation:
- Authors an establishing ADR in the agency's `#ORG/adr/accepted/`.
- Creates the unit directory (or `git submodule add` if submodule mode).
- Scaffolds the unit's `#ORG/` with agents, ADR tree, docs, and README.
- Commits with `§NNNN: establish unit @<name>`.

If any unit fails, relay the error and stop. Do not continue to further units until the user resolves the issue.

---

## Phase 5 — Ontology report

After all scripts complete, output a structured block describing what was built. Pattern:

### Single-unit — example

```
Agency: Acme Co
Description: A coding project that coordinates product experimentation and release.
User directory: trevor (display: Trevor)
Agency roles: Lead, Implementer
Destination: /Users/trevorschoeny/Code/@acme
```

### Multi-unit — example

```
Agency: Acme Org
Description: Coordinating product, research, and ops across the team.
User directory: trevor (display: Trevor)
Agency roles: Lead, Implementer
Units:
  - @product    purpose: Owns product strategy and roadmap.
                roles:   Director, Specialist
                mode:    directory
  - @research   purpose: Owns experimentation and new-area exploration.
                roles:   Lead, Implementer (inherited)
                mode:    directory
  - @ops        purpose: Owns infrastructure and day-to-day operations.
                roles:   Architect, Engineer
                mode:    submodule
Destination: /Users/trevorschoeny/Code/@acme
```

Role names reflect whatever was chosen during onboarding. Unit roles are tagged `(inherited)` when they match the agency's; otherwise the unit's own role names are listed. Unit mode is always shown. The `Destination` is the only path in the ontology report — navigation to specific agent directories belongs to the next-steps block.

If nested `.git/` directories were detected during scaffold, include a short note after the ontology report:

> *Note: detected N nested .git/ directories inside the destination. The Registrar will surface these at first audit for you to decide how to handle (submodule, leave nested, or move elsewhere).*

---

## Phase 6 — Locked scripted next-steps

Output this wording exactly, substituting agency name, user's name, role names, and §-numbers where needed.

> *If you want to ground in the theory behind this scaffold before diving in, read `#ORG/docs/philosophy.md` first, then `#ORG/docs/decision-process.md` for how ADRs flow, and `#ORG/docs/message-protocol.md` for how agents talk to each other. `#ORG/docs/foundations/` has deeper reading on stratified cognition, subsidiarity, the actor model, ADRs as a tradition, legal-citation inheritance, the registrar pattern, and the canon/operational split — each one short, each one standalone.*
>
> *Agents work together by sending messages to each other's inboxes — small markdown files dropped into the receiving agent's `inbox/` directory. Each agent already knows where its own inbox lives, who it takes messages from, who it sends messages to, and how to archive what it's read. You don't need to configure any of that — it's baked into every agent's `AGENTS.md`.*
>
> *When you're ready to start working, close this session. Open a new one inside `#ORG/agents/<lead-dir>/` — that's your agency's lead, and the first conversation you want is planning-level: expanding §0011 (agency scope) from its thin seed into a real scope statement. The lead will take it from there.*
>
> *You can start a session with any agent the same way — open it inside that agent's directory. Unit-level agents live under `@<unit-name>/#ORG/agents/<role>/`. The agent you open will read its own `AGENTS.md` and the surrounding context automatically.*
>
> *You can run the `:silcrow-add-unit` skill at any time to add a new unit, or the `:silcrow-update` skill to bring this agency into alignment with the latest plugin updates. The registrar assists with both.*
>
> *Good luck with {agency_name}! Let me know if you have any questions. Otherwise, I'll enjoy my retirement when you close this session. :)*

Substitute the angle-bracketed tokens (`<lead-dir>`, etc.) with the actual values chosen during conversation.

---

## Rules

- **Use the scripts.** Don't hand-create template files; the scripts handle copy and substitution.
- **The locked intro (Phase 2) and locked next-steps (Phase 6) are literal text** — substitute only named slots; do not paraphrase.
- **If the scripts are missing or not executable**, stop and report the plugin is not installed correctly.
- **On any script failure**, relay the error and stop. Don't attempt recovery.
