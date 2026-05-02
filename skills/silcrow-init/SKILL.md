---
name: silcrow-init
description: Scaffold a Silcrow agency — a hierarchical agent organization with ADR decision tracking, actor-model messaging, and registrar-enforced record integrity. Use when the user says "scaffold agent organization," "initialize agency," "set up agent org," "bootstrap agency," "new agency," "silcrow," "Silcrow agency," or similar.
user-invocable: true
allowed-tools:
  - Bash(${CLAUDE_PLUGIN_ROOT}/scripts/scaffold.sh:*)
  - Bash(${CLAUDE_PLUGIN_ROOT}/scripts/add-unit.sh:*)
  - AskUserQuestion
---

# Agent Org Scaffold — Init

Initialize a disciplined **agency** — a hierarchical agent organization with built-in decision tracking, actor-model messaging, and registrar-enforced record integrity. The scaffold ships a founding set of constitutional ADRs (§0001–§0020, with §0008 superseded by §0011) that capture the pattern's load-bearing decisions.

An **agency** is the whole organizational tree. Its top-level node is the **root unit**, which shares the agency's name. The tree may stop there (a single root unit, one cohesive body of work) or extend into nested **sub-units** — each itself a full unit, recursively, with its own governance and agents (§0014). The scaffold supports both shapes.

## One-shot skill

Run this skill **once**, at agency initialization. After scaffolding completes, the generated structure carries all conventions forward. **Do not re-invoke `:silcrow-init`** to modify an existing agency — use `:silcrow-add-unit` for new units or `:silcrow-update` to bring the agency in line with the current scaffold release.

If the user asks to "re-run" `:silcrow-init` on an existing agency, stop and explain. Redirect them to `:silcrow-update` (for plugin-driven changes) or manual editing (for their own conventions).

## How this skill works

The skill follows a six-phase flow: **silent peek → locked intro → natural conversation → run scaffold script → report → locked next-steps**. Two bundled bash scripts do the mechanical work: `scripts/scaffold.sh` for the agency, and `scripts/add-unit.sh` for each additional unit (if any). Your job is to gather the inputs conversationally and invoke the scripts.

---

## Phase 1 — Peek silently

Before any output to the user:

- Check CLAUDE.md or the environment for the user's name. If found, you'll substitute it into the locked intro; if not, you'll silently omit.

That's the entire peek.

**The agency-vs-CWD relationship — read this carefully:**

- The agency starts at `@<slug>/` — that is the top-level node, the root unit.
- The agency lives **inside** the CWD, at `<cwd>/@<slug>/`.
- The CWD is **not** part of the agency. It's merely a parent container the scaffold creates the agency inside. The CWD's name, contents, sibling directories, ancestors, and any git state outside the agency are all irrelevant to this skill.

**You do not inspect the CWD.** You do not `ls` it, do not read its files, do not take note of its name, do not infer anything from its contents. Your only concern is setting up the agency by gathering inputs from the user and invoking the script. The script handles every filesystem operation, including git.

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
> *The agency starts at its root unit's directory. I'll create that directory inside whatever directory we're in right now — the directory we're in is just a container, not part of the agency itself.*
>
> *Two rules matter: **sub-units answer to their parent unit** (decisions at any unit bind that unit and everything below it), and **sibling units don't police each other** (no cross-branch oversight).*

Output this, then drop out of scripted mode.

---

## Phase 3 — Natural conversation

Now converse naturally. Do the following in whichever order feels natural:

### Path placement is fixed — do not negotiate it

**The agency is always created at `<CWD>/@<slug>/`. The CWD is the parent. Always.**

- You do not propose alternative parent directories. Not as a sibling of the CWD, not in the CWD's parent, not in the user's home directory, nowhere else.
- You do not reason about whether the CWD is "the right place" or whether its name "matches" the agency. The CWD is the right place because the user invoked the skill there. That is the entire criterion.
- You do not say things like "I can't rename the CWD, so let me put it elsewhere." There is nothing to rename and nothing to put elsewhere. The agency goes inside the CWD as `@<slug>/`. End of question.
- You do not ask the user to confirm the location. State it as fact: *"The agency will be created at `<CWD>/@<slug>/`."* Then proceed.

If — and only if — the user explicitly asks to put the agency in a different parent directory, you accept that override. But you never offer the option, never suggest it, never imply that the CWD might not be where they want it.

### What to gather

- **Agency name.** Ask the user. Don't suggest one. Once they answer, show the slug you'd derive (e.g., "Wedding" → `@wedding/`) and let them adjust either the display name or the slug.
- **The user's name** if you couldn't detect it from CLAUDE.md / env. Confirm.
- **Single-unit or multi-unit.** Ask. If multi-unit, gather unit names and purposes from the user. Don't infer.
- **Role customization** if the user wants different display or directory names for User/Lead/Implementer.

Be conversational, not formulaic. No forms, no numbered phases.

### What you must not do

- **Do not inspect the CWD.** Don't `ls` it, don't read any file in it, don't take note of its name. The CWD's contents and name are irrelevant to setting up the agency.
- **Do not walk up the filesystem.** Don't look at the CWD's parent, ancestors, or siblings. Whatever exists outside the CWD is also irrelevant.
- **Do not infer anything from context around the agency.** Don't suggest an agency name from CWD contents, don't guess unit structure from project markers, don't assume role names. Ask the user.
- **Do not rename, move, or delete anything.** The script handles all filesystem work. Never run `mv`, `git mv`, or any operation that mutates paths outside what the script does internally.
- **Do not check git state.** The script git-inits the agency directory itself; that's its job. You don't need to know anything about git context anywhere on the filesystem.
- **Do not propose alternative scaffolding locations.** See "Path placement is fixed" above.

### What you need to gather

**Agency-level (for `scripts/scaffold.sh`):**

- Where the agency goes (default: CWD; user can specify a different parent directory).
- Agency name (display form, e.g. "Acme Co" or "Wedding").
- Agency directory slug (default: derived from the agency name — lowercase, spaces → hyphens, slug-safe). Show the user the proposed slug; they can override if they want a different one (e.g., display "Acme Corporation" with dir `@acme/`).
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
- Mode: `directory` (default) or `submodule` (§0018 — for units with independent versioning).
- If submodule, submodule source (remote URL, local path, or blank for fresh init).

### Role rename guidance

The `Registrar` name is part of the pattern — don't rename it. User, Lead, and Implementer are flexible display names. When a user wants domain-specific vocabulary, ask for both the display name (e.g., "Director") and whether they want a different directory name (by default, derive `director` from `Director` via kebab-case).

### When you have enough, run the scaffold

No "shall I run it?" confirmation. If the answers are well-formed, proceed to Phase 4. If an answer is genuinely ambiguous, ask the clarifying question. A well-formed set of answers should never produce an extra confirmation prompt.

---

## Phase 4 — Run the scaffold

### Agency first

Invoke `scripts/scaffold.sh` with nine positional arguments. The first argument is the parent directory the agency will live inside — typically the user's CWD. Pass `--agency-dir <slug>` if the user picked a slug different from the auto-derived one.

```bash
"${CLAUDE_PLUGIN_ROOT}/scripts/scaffold.sh" \
    "<parent_directory>" \
    "<agency_name>" \
    "<agency_description>" \
    "<user_dir>" \
    "<user_role>" \
    "<lead_dir>" \
    "<lead_role>" \
    "<implementer_dir>" \
    "<implementer_role>" \
    [--agency-dir "<slug>"]
```

If the user declined git entirely, pass `--skip-git`.

Quote every argument so values with spaces pass through cleanly.

The script:
- Prints `✓ Scaffolded <agency_name> at <parent_directory>/@<agency-dir>` on success.
- Creates `<parent_directory>/@<agency-dir>/` containing the unit's flat layout (CANON@, OPS@, REFERENCE@, agent dirs, README) per §0014.
- The agency dir slug defaults to `<agency_name>` slugified (lowercase, spaces → hyphens, slug-safe per §0014); pass `--agency-dir <slug>` to override.
- Initializes git **inside the agency directory** as its own self-contained repo, with a default `.gitignore` and an initial commit (§0001). The parent directory is never touched — no `.git/`, no `.gitignore`, no rename, no commit.
- Exits 3 if `<parent_directory>/@<agency-dir>/` is already a scaffolded unit (CANON@ exists inside). Unrelated `@*/` siblings in the parent directory are not conflicts. Relay the error if it fires.

### Units next (if multi-unit)

For each declared unit, invoke `scripts/add-unit.sh`. The first positional argument is the parent unit's path — at init time, that's the agency root unit `<parent_directory>/@<agency-dir>/`:

```bash
"${CLAUDE_PLUGIN_ROOT}/scripts/add-unit.sh" \
    "<parent_directory>/@<agency-dir>" \
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

The first argument is the **parent unit's directory** — its basename starts with `@`. The new sub-unit will be created nested inside it as a sibling of the parent's agents, CANON, OPS, etc.

Pass `--user-role`, `--user-dir`, and `--parent-lead-role` so the unit's
establishing ADR and templates render with the agency's actual role and
directory names (for references like "route through the agency Lead or User").

`--agency-dir` and `--agency-name` are **optional** — by default the script
walks up from the parent path to find the agency's root unit (the outermost
`@<unit-name>/` in the tree) and reads the agency name from there. Pass them
explicitly only if you need to override the auto-detection.

`--unit-display` is also **optional** — if omitted, the script title-cases
`<unit_name>` (e.g. `pebble-core` → `Pebble Core`). Pass it when you want a
display form that differs from the auto-cased default.

Each invocation:
- Authors an establishing ADR in the parent unit's `CANON@<parent-unit-name>/accepted/`.
- Creates the sub-unit directory `@<unit_name>/` nested inside the parent unit (or `git submodule add` if submodule mode).
- Scaffolds the sub-unit's flat structure (CANON@, OPS@, agent dirs, README; no REFERENCE — that's root-only).
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
Agency lives at: /Users/trevorschoeny/Code/@acme
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
Agency lives at: /Users/trevorschoeny/Code/@acme
```

Role names reflect whatever was chosen during onboarding. Unit roles are tagged `(inherited)` when they match the agency's; otherwise the unit's own role names are listed. Unit mode is always shown. The "Agency lives at" line is the only path in the ontology report — navigation to specific agent directories belongs to the next-steps block.

---

## Phase 6 — Locked scripted next-steps

Output this wording exactly, substituting agency name, user's name, role names, and §-numbers where needed.

> *If you want to ground in the theory behind this scaffold before diving in, read `@<agency-name>/REFERENCE@<agency-name>/philosophy.md` first, then `@<agency-name>/REFERENCE@<agency-name>/decision-process.md` for how ADRs flow, and `@<agency-name>/REFERENCE@<agency-name>/message-protocol.md` for how agents talk to each other. `@<agency-name>/REFERENCE@<agency-name>/foundations/` has deeper reading on stratified cognition, subsidiarity, the actor model, ADRs as a tradition, legal-citation inheritance, the registrar pattern, and the canon/operational split — each one short, each one standalone.*
>
> *Agents work together by sending messages to each other's inboxes — small markdown files dropped into the receiving agent's `inbox/` directory. Each agent already knows where its own inbox lives, who it takes messages from, who it sends messages to, and how to archive what it's read. You don't need to configure any of that — it's baked into every agent's `AGENTS.md`.*
>
> *When you're ready to start working, close this session. Open a new one inside `@<agency-name>/<lead-dir>@<agency-name>/` — that's your agency's lead, and the first conversation you want is planning-level: superseding §0020 (agency scope) from its thin seed into a real scope statement. The lead will take it from there.*
>
> *You can start a session with any agent the same way — open it inside that agent's directory (two levels below the agency root, e.g. `@<agency-name>/<role>@<agency-name>/`, or for sub-unit agents `@<agency-name>/@<sub-unit>/<role>@<sub-unit>/`). The agent you open will read its own `AGENTS.md` and the surrounding context automatically.*
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
