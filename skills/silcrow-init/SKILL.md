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

Initialize a disciplined **agency** — a hierarchical agent organization with built-in decision tracking, actor-model messaging, and registrar-enforced record integrity. The scaffold ships a founding set of constitutional ADRs (§0001–§0018, with §0008 superseded by §0010) that capture the pattern's load-bearing decisions.

An **agency** is the whole organizational tree. Its top-level node is the **root unit**, which shares the agency's name. The tree may stop there (a single root unit, one cohesive body of work) or extend into nested **sub-units** — each itself a full unit, recursively, with its own governance and agents (§0013). The scaffold supports both shapes.

## One-shot skill

Run this skill **once**, at agency initialization. After scaffolding completes, the generated structure carries all conventions forward. **Do not re-invoke `:silcrow-init`** to modify an existing agency — use `:silcrow-add-unit` for new units or `:silcrow-update` to bring the agency in line with the current scaffold release.

If the user asks to "re-run" `:silcrow-init` on an existing agency, stop and explain. Redirect them to `:silcrow-update` (for plugin-driven changes) or manual editing (for their own conventions).

## How this skill works

Six phases: **silent peek → locked intro → natural conversation → run scaffold script → report → locked next-steps**. Two bundled bash scripts do the mechanical work: `scripts/scaffold.sh` for the agency, and `scripts/add-unit.sh` for each additional unit (if any). Your job is to gather inputs conversationally and invoke the scripts.

The scaffold script always creates the agency directory inside the current working directory. There is no destination argument — the script operates in `$PWD` and that is the only place an agency can be created. If the user wants the agency somewhere else, that's their decision to make by `cd`-ing there before invoking the skill; it is not a parameter you negotiate.

---

## Phase 1 — Peek silently

Before any output to the user:

- Check the user's global CLAUDE.md (`~/.claude/CLAUDE.md`) or the session env for the user's name. If found, you'll substitute it into the locked intro; if not, you'll silently omit.

That's the entire peek. Do not read any file in the current working directory; do not list its contents; do not check git state. The script handles every filesystem operation, including git initialization inside the agency directory.

No questions yet. No output.

---

## Phase 2 — Deliver the locked intro (verbatim)

Output this text exactly. The only substitution is the user's name — inserted when known, silently omitted when not. The `{, <name>}` token renders as `, <name>` when known and as empty when not.

> *This scaffold sets up an **agency** — a disciplined structure for decision-making and coordinated work, whether that work is a product, a team, a research effort, a coding project, or any kind of initiative where decisions need to be recorded and authority needs to be clear.*
>
> *Every agency has a hierarchy: a user (you{, <name>} — the human) sets strategic direction and works with the lead to brainstorm and strategize; the lead translates that into briefs; the implementer does the work. A registrar keeps the decision record clean. That's the default shape.*
>
> *An agency is the whole tree of work. Its topmost node is the **root unit** (which shares the agency's name); below the root, an agency can stay as a single unit — one cohesive body of work — or branch into **sub-units**, each itself a full unit with its own governance and agent team. Every unit, root or sub, has the same shape. Units can be departments, teams, product lines, research threads, codebases — any partition of the work that's independent enough to deserve its own decision record and agent team.*
>
> *I'll create the agency directory here, in this directory.*
>
> *Two rules matter: **sub-units answer to their parent unit** (decisions at any unit bind that unit and everything below it), and **sibling units don't police each other** (no cross-branch oversight).*

Output this, then drop out of scripted mode.

---

## Phase 3 — Natural conversation

Now converse naturally. Be conversational, not formulaic. No forms, no numbered phases. Gather what the script needs in whatever order feels natural.

### Information to gather

**Agency-level (for `scripts/scaffold.sh`):**

- **Agency name** — Title-case, English, can have spaces (e.g., `Pebble`, `Pebble Core`, `Acme Co`). Used for both the directory (`@ <Agency Name>/`) and prose throughout. Ask the user; don't suggest one.
- **Agency description** — one sentence to one paragraph; whatever feels right.
- **User role** — what the user wants to be called in the agency (e.g., the user's actual name like `Trevor`, or an abstract role like `User`, `Director`). Used for both directory (`<User Role> @ <Agency Name>/`) and prose. Pull from the global CLAUDE.md / env if available; otherwise ask.
- **Lead role** — display name for the Lead position. Default `Lead`; user may rename to `Director`, `Architect`, `Editor`, etc.
- **Implementer role** — display name for the Implementer position. Default `Implementer`; user may rename to `Specialist`, `Engineer`, `Associate`, etc.
- **Single-unit or multi-unit?** Ask. If multi-unit, gather unit names and purposes.

**Per unit (only if multi-unit; `scripts/add-unit.sh` invoked for each):**

- **Unit name** — Title-case, English, can have spaces (e.g., `Pebble Core`, `Research`, `Operations`).
- **Unit purpose** — one sentence describing what the unit owns.
- **Lead role for this unit** — default inherits the agency's; user may override.
- **Implementer role for this unit** — default inherits the agency's; user may override.

### Role rename guidance

The `Registrar` name is part of the pattern — don't rename it. User, Lead, and Implementer are flexible role names. When a user wants domain-specific vocabulary, ask once (one name per role; the directory name *is* the display name now).

### When you have enough, run the scaffold

No "shall I run it?" confirmation. If the answers are well-formed, proceed to Phase 4. If an answer is genuinely ambiguous, ask the clarifying question. A well-formed set of answers should never produce an extra confirmation prompt.

---

## Phase 4 — Run the scaffold

### Agency first

Invoke `scripts/scaffold.sh` with five positional arguments:

```bash
"${CLAUDE_PLUGIN_ROOT}/scripts/scaffold.sh" \
    "<agency_name>" \
    "<agency_description>" \
    "<user_role>" \
    "<lead_role>" \
    "<implementer_role>"
```

Quote every argument so values with spaces pass through cleanly.

The script:
- Prints `✓ Scaffolded <agency_name> at <cwd>/@ <agency_name>` on success.
- Creates `@ <agency_name>/` inside the current working directory, containing the unit's flat layout (`1 | Canon`, `2 | Working Files`, `3 | Silcrow Agency Reference`, agent dirs, README) per §0013.
- Initializes git **inside the agency directory** as its own self-contained repo, with a default `.gitignore` and an initial commit (§0001). The CWD itself is never touched — no `.git/`, no `.gitignore`, no rename, no commit.
- Exits 3 if `<cwd>/@ <agency_name>/` is already a scaffolded unit (`1 | Canon` exists inside). Unrelated `@ */` siblings in the CWD are not conflicts. Relay the error if it fires.

### Units next (if multi-unit)

For each declared unit, invoke `scripts/add-unit.sh`. The first positional argument is the parent unit's path — at init time, that's the agency root unit `<cwd>/@ <agency_name>/`:

```bash
"${CLAUDE_PLUGIN_ROOT}/scripts/add-unit.sh" \
    "<cwd>/@ <agency_name>" \
    "<unit_name>" \
    "<unit_purpose>" \
    "<unit_lead_role>" \
    "<unit_implementer_role>" \
    --user-role "<user_role>" \
    --parent-lead-role "<lead_role>"
```

The first argument is the **parent unit's directory** — its basename starts with `@`. The new sub-unit will be created nested inside it as a sibling of the parent's agents and governance folders. The scaffold script's success line gave you the absolute agency path; substitute that here.

Pass `--user-role` and `--parent-lead-role` so the unit's establishing ADR and templates render with the agency's actual role names (for references like "route through the agency Lead or User").

Each invocation:
- Authors an establishing ADR in the parent unit's `1 | Canon/accepted/`.
- Creates the sub-unit directory `@ <unit_name>/` nested inside the parent unit.
- Scaffolds the sub-unit's flat structure (`1 | Canon`, `2 | Working Files`, agent dirs, README; no `3 | Silcrow Agency Reference` — that's root-only).
- Commits with `§NNNN: establish unit @ <unit_name>`.

If any unit fails, relay the error and stop. Do not continue to further units until the user resolves the issue.

---

## Phase 5 — Ontology report

After all scripts complete, output a structured block describing what was built. The "Agency lives at:" line uses the absolute path the scaffold script printed in its success line.

### Single-unit — example

```
Agency: Pebble
Description: A healthcare platform that puts patients in command of their own care.
User: Trevor
Agency roles: Lead, Implementer
Agency lives at: /Users/trevorschoeny/Code/@ Pebble
```

### Multi-unit — example

```
Agency: Acme Org
Description: Coordinating product, research, and ops across the team.
User: Trevor
Agency roles: Lead, Implementer
Units:
  - @ Product   purpose: Owns product strategy and roadmap.
                roles:   Director, Specialist
  - @ Research  purpose: Owns experimentation and new-area exploration.
                roles:   Lead, Implementer (inherited)
  - @ Ops       purpose: Owns infrastructure and day-to-day operations.
                roles:   Architect, Engineer
Agency lives at: /Users/trevorschoeny/Code/@ Acme Org
```

Unit roles are tagged `(inherited)` when they match the agency's; otherwise the unit's own role names are listed. The "Agency lives at" line is the only path in the ontology report — navigation to specific agent directories belongs to the next-steps block.

---

## Phase 6 — Locked scripted next-steps

Output this wording exactly, substituting agency name, user's name, role names, and §-numbers where needed.

> *If you want to ground in the theory behind this scaffold before diving in, read `@ <Agency Name>/3 | Silcrow Agency Reference/Philosophy.md` first, then `@ <Agency Name>/3 | Silcrow Agency Reference/Decision Process.md` for how ADRs flow, and `@ <Agency Name>/3 | Silcrow Agency Reference/Message Protocol.md` for how agents talk to each other. `@ <Agency Name>/3 | Silcrow Agency Reference/foundations/` has deeper reading on stratified cognition, subsidiarity, the actor model, ADRs as a tradition, legal-citation inheritance, the registrar pattern, and the canon/operational split — each one short, each one standalone.*
>
> *Agents work together by sending messages to each other's inboxes — small markdown files dropped into the receiving agent's `inbox/` directory. Each agent already knows where its own inbox lives, who it takes messages from, who it sends messages to, and how to archive what it's read. You don't need to configure any of that — it's baked into every agent's `AGENTS.md`.*
>
> *When you're ready to start working, close this session. Open a new one inside `@ <Agency Name>/<Lead Role> @ <Agency Name>/` — that's your agency's lead, and the first conversation you want is planning-level: superseding §0018 (agency scope) from its thin seed into a real scope statement. The lead will take it from there.*
>
> *You can start a session with any agent the same way — open it inside that agent's directory (two levels below the agency root, e.g. `@ <Agency Name>/<Role> @ <Agency Name>/`, or for sub-unit agents `@ <Agency Name>/@ <Sub Unit>/<Role> @ <Sub Unit>/`). The agent you open will read its own `AGENTS.md` and the surrounding context automatically.*
>
> *You can run the `:silcrow-add-unit` skill at any time to add a new unit, or the `:silcrow-update` skill to bring this agency into alignment with the latest plugin updates. The registrar assists with both.*
>
> *Good luck with <Agency Name>! Let me know if you have any questions. Otherwise, I'll enjoy my retirement when you close this session. :)*

Substitute the angle-bracketed tokens with the actual values chosen during conversation.

---

## Rules

- **Use the scripts.** Don't hand-create template files; the scripts handle copy and substitution.
- **The locked intro (Phase 2) and locked next-steps (Phase 6) are literal text** — substitute only named slots; do not paraphrase.
- **If the scripts are missing or not executable**, stop and report the plugin is not installed correctly.
- **On any script failure**, relay the error and stop. Don't attempt recovery.
