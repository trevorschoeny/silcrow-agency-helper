---
name: silcrow-add-agent
description: Add a new agent (role) to the unit you're currently in. Authors the establishing ADR per §0008's Roster Change Protocol, scaffolds the agent's directory, composes its AGENTS.md from the conversation, and orchestrates redistribution of work — proposing trims and additions to existing agents' AGENTS.md before applying anything. Use when the user says "add an agent," "create a new role," "I need a [role] in this unit," "split off [responsibility] into its own agent," or similar within an existing unit.
user-invocable: true
allowed-tools:
  - Read
  - Glob
  - Grep
  - Edit
  - Write
  - Bash(ls:*)
  - Bash(test:*)
  - Bash(pwd:*)
  - Bash(git:*)
  - Bash(${CLAUDE_PLUGIN_ROOT}/scripts/add-agent.sh:*)
  - AskUserQuestion
---

# Agent Org Scaffold — Add Agent

Add a new agent (role) to the unit you're currently in. Adding an agent is a **roster change** (§0008): it requires an establishing ADR, redistribution of work from existing agents, and updates to the unit's coordination structure. This skill orchestrates all of it in one motion.

**Lead-only invocation.** §0009 makes the Registrar's authority strictly procedural; redistribution of work is substantive, so it must be the Lead's call. The skill verifies it's running from the unit's Lead directory and refuses otherwise.

## When to use

- The work has matured enough that an existing agent's scope should be split, with a new agent owning part of it.
- A new area of work needs a dedicated owner that none of the existing agents can absorb cleanly.
- The user says something like "add a Researcher," "create a Designer role," "let's split out the marketing work into its own agent," or similar.

The skill assumes the current working directory **is** the unit's Lead directory (basename like `<Lead Role> @ <Unit Name>`, where the prefix matches the unit's `lead-role` from its `silcrow-meta` anchor). If it isn't, the skill stops and tells the user.

## How this skill works

Five phases: **silent peek → natural conversation → propose with one consolidated diff → execute on approval → hand off**. The bundled script `scripts/add-agent.sh` does the mechanical bits (create the agent directory, render the establishing ADR template). The skill drives the substantive content — the new agent's `AGENTS.md`, edits to existing agents' `AGENTS.md`, the unit README's roster section — and makes a single governance commit at the end.

---

## Phase 1 — Peek silently

Before any output:

- `pwd` to find the current working directory. Verify its basename matches the pattern `<X> @ <Y>` (a single space-`@`-space). If it doesn't (e.g., basename starts with `@` — that's the unit's root, not an agent dir; or has no `@` at all — not in an agency), stop and tell the user: *"This skill must be invoked from the unit's Lead directory. Navigate into `<Unit Name>/<Lead Role> @ <Unit Name>/` and try again."* Do not proceed.
- The unit's directory is CWD's parent — `<cwd>/..` — by structural definition (every agent dir lives one level inside the unit per §0012). Read `<cwd>/../README.md` for the `silcrow-meta` anchor on its first line. Extract the four fields:
  - `agency="..."` — the agency name
  - `user-role="..."` — the agency's user role
  - `lead-role="..."` — the unit's lead role
  - `implementer-role="..."` — the unit's implementer role
- Verify CWD's basename prefix (the part before ` @ `) **exactly matches** the parent's `lead-role`. If not, this is some other role's session (Implementer, Registrar, User, etc.). Stop and tell the user: *"This skill must be invoked from the unit's Lead directory (`<lead_role> @ <unit_name>`). The current directory looks like a different role's session. Open a Lead session in `<cwd>/../<Lead Role> @ <Unit Name>/` and try again."* Do not proceed.
- The unit's name is `<cwd>/..`'s basename minus the `@ ` prefix.
- List the unit's existing agents: `ls <cwd>/..` and pick out the directories matching `* @ *` (those are agent dirs). Read each one's `AGENTS.md` so the skill has redistribution context for the conversation.
- Check whether the unit is a git repo (`git rev-parse --is-inside-work-tree`).
- Check the environment / CLAUDE.md for the user's name.

No questions yet. Just orient.

---

## Phase 2 — Natural conversation

Now converse naturally. Orient briefly:

> *You're about to add a new agent to `@ <Unit Name>`. Adding an agent is a roster change (§0008) — it'll redistribute work and update the unit's coordination structure. Let me gather the details.*

(Or similar, adapted to context.)

### What to gather

- **Role name** — Title-case English, can have spaces (e.g., `Researcher`, `Designer`, `Project Manager`). Validate against the unit's existing agents: refuse names that collide with `<lead_role>`, `<implementer_role>`, `Registrar`, or any sibling already present.
- **One-sentence purpose** — what does this agent own? Used in the establishing ADR's Why-statement.
- **Reports to** — which existing agent does this new agent report to? Default for tier-2 additions: the Lead (`<lead_role>`). Document deviations explicitly (sub-tier reporting to the Implementer; tier-1 peer reporting directly to the User).
- **Responsibilities** — list what the new agent owns. Be specific; vague descriptions produce bad redistribution.
- **Redistribution** — for each responsibility, ask:
  - Is any existing agent currently doing this work? If yes, this is a *transfer* — that responsibility moves out of the existing agent's scope.
  - Or is this entirely new work? — *No transfer*; the new agent owns work that was previously not formally owned.
- **Inbound message routing** — who will this agent receive messages from? (Briefs from the Lead, handoffs from peers, etc.)
- **Outbound message routing** — who will this agent send messages to? (Plan-replies to the Lead, handoffs to peers, audit-flags to the Registrar.)

### Asking clarifying questions

If the user describes the new agent vaguely, ask. Common ambiguities:

- *"Add a designer."* — At what tier? Reporting to whom? Owning what specifically? Does this take work from the existing Implementer?
- *"Split off marketing."* — Into a new agent within this unit, or a new sub-unit (different skill — `:silcrow-add-unit`)? If an agent: tier-1 peer of Lead, or tier-2 peer of Implementer?
- *"I want a researcher who handles user research."* — Does the existing Implementer currently do user research? If yes, that responsibility transfers; the Implementer's `AGENTS.md` needs trimming.

When in doubt, propose your understanding back and ask the user to confirm.

### When you have enough, proceed to Phase 3

No "shall I run it?" prompt for well-formed answers. Move to compose-and-propose.

---

## Phase 3 — Compose and propose (one consolidated diff)

The skill composes everything before showing it:

1. **The new agent's `AGENTS.md`.** Compose from scratch based on the conversation. Match the structural shape of the unit's existing `AGENTS.md` files (Lead, Implementer, Registrar) — same kind of sections (purpose, what you own, routing, references) but content tailored to this role's specific responsibilities. Don't copy a template verbatim; the existing AGENTS.mds are role-specific and structurally varied.
2. **Edits to existing agents' `AGENTS.md`.** For each transfer:
   - Add to the new agent's section: *(handled in step 1)*.
   - **Remove** the transferred responsibility from the originating agent's `AGENTS.md`. Find the specific bullet/line that names it and trim it.
   - **Add** routing references in any agent that needs to know to route work to the new agent (typically the Lead, sometimes peer agents). E.g., a new bullet under "Routing" or "Peer agents" that names the new agent and what to send them.
3. **Edit to the unit's `README.md` roster section.** *Only if the unit is a sub-unit* (READMEs created by `add-unit.sh` have an explicit `## This unit's roles` section). Append a new bullet for the new agent following the existing format. *If the unit is the agency's root unit*, the README's directory-tree visualization is left alone — note in Phase 5's hand-off that the user may want to update it manually.

**To distinguish root from sub-unit:** the unit's `README.md` H1 is `# <Agency Name>` for the root and `# @ <Unit Name>` for a sub-unit. The presence of `## This unit's roles` is the operational marker for "skill should edit this section."

Show the proposed changes as one consolidated review block:

```
PROPOSED CHANGES — adding <Role> @ <Unit Name>

NEW FILES
  + 1 | Canon/accepted/§NNNN | Establish <Role> @ <Unit Name>.md
  + <Role> @ <Unit Name>/AGENTS.md
  + <Role> @ <Unit Name>/inbox/archive/.gitkeep

EXISTING FILES MODIFIED
  ~ <Lead Role> @ <Unit Name>/AGENTS.md
    + add "Routes <topic> to <Role> @ <Unit Name>" under "Routing"
  ~ <Implementer Role> @ <Unit Name>/AGENTS.md
    - remove "<responsibility moving to <Role>>" from "What you own"
    + add "Receive <topic> findings from <Role> @ <Unit Name>" under "References"
  ~ README.md
    + add <Role> @ <Unit Name> to the "This unit's roles" section
       (sub-unit only; root unit README is left for manual update)

Approve all / show details on item N / revise item N / cancel
```

If the user wants details on any item, show the full proposed content for that item. If they want to revise, take their feedback and re-show the diff. If they cancel, abort with no changes made. Apply only on explicit approval.

---

## Phase 4 — Execute

Once approved:

### 4.1 — Run `scripts/add-agent.sh`

Invoke the script with positional arguments and the three required `--`-flagged values from Phase 1's anchor extraction:

```bash
"${CLAUDE_PLUGIN_ROOT}/scripts/add-agent.sh" \
    "<unit_path>" \
    "<role_name>" \
    "<one_sentence_purpose>" \
    "<reports_to>" \
    --agency-name "<agency_name>" \
    --user-role "<user_role>" \
    --lead-role "<lead_role>"
```

- `<unit_path>` is `<cwd>/..` — the unit's directory (one level up from the Lead's session). Compute and pass as an absolute path; quote it (it contains spaces and `@`).
- `<role_name>` is the new role (Title-case).
- `<one_sentence_purpose>` is what the agent owns, in one sentence.
- `<reports_to>` is the role name of the existing agent the new agent reports to (e.g., `Lead`, `Director`, `Implementer`).
- `--agency-name`, `--user-role`, `--lead-role` come from the parent unit's `silcrow-meta` anchor.

The script:
- Validates the unit and the no-collision check on the new agent name.
- Determines the next §-number for the unit's canon.
- Creates `<unit_path>/<Role> @ <Unit Name>/inbox/archive/` (with `.gitkeep`).
- Renders `§NNNN | Establish <Role> @ <Unit Name>.md` from the `Establish Agent.md` template into the unit's `1 | Canon/accepted/`. Mechanical placeholders are filled; substantive ones (why-statement specifics, scope details, redistribution narrative) remain as `{placeholders}` for the Lead to fill in.

On success, the script prints a summary block including the §-number and the ADR's path. On failure, relay the error and stop.

### 4.2 — Write the new agent's `AGENTS.md`

Use `Write` to create `<unit_path>/<Role> @ <Unit Name>/AGENTS.md` with the content composed in Phase 3.

### 4.3 — Apply redistribution edits

Use `Edit` to apply each proposed edit to existing agents' `AGENTS.md`:
- Trim transferred responsibilities from originating agents.
- Add routing references where needed.

### 4.4 — Update the unit's `README.md` roster section (sub-unit only)

If the unit is a sub-unit (README has `## This unit's roles`), use `Edit` to add a bullet for the new agent. Skip for root units; the Phase 5 hand-off mentions manual update.

### 4.5 — Substantive ADR content (optional pre-fill)

The skill may pre-fill some of the establishing ADR's substantive placeholders using `Edit`, drawing on the conversation. Common pre-fills:
- `{reason_for_agent}` — the unit's reason for adding the agent (from Phase 2).
- `{area_of_concern}` — the area the agent owns.
- `{primary_reason}` — the chosen-option rationale.

Leave the more substantial placeholders (Context and problem statement, Considered options' specific rejections) for the Lead to fill in directly. ADRs are immutable only after they're substantively complete; finishing authorship is part of the addition.

### 4.6 — Commit per §0015

Stage everything and commit with a §0015-formatted message:

```bash
git add -A
git commit -m "§NNNN: establish <Role> @ <Unit Name>"
```

If the unit isn't a git repo (rare — the agency was scaffolded with `--skip-git` or the user converted it manually), skip the commit and note it in the hand-off.

---

## Phase 5 — Report and hand off

Echo a summary block:

```
✓ Added agent <Role> @ <Unit Name>
  Purpose:        <one_sentence_purpose>
  Reports to:     <reports_to> @ <Unit Name>
  Establishing ADR: §NNNN | Establish <Role> @ <Unit Name>
  AGENTS.md:      <unit_path>/<Role> @ <Unit Name>/AGENTS.md
  Redistribution: N transfers from existing agents
```

Then output this scripted next-steps text:

> *The new agent is ready. Open a session inside `<unit_path>/<Role> @ <Unit Name>/` to brief them — their `AGENTS.md` describes what they own, who they report to, and how messages route. The unit's Registrar will audit the addition next time you run them; they'll verify the ADR-and-directory pair and the AGENTS.md edits.*
>
> *The establishing ADR (`§NNNN | Establish <Role> @ <Unit Name>.md`) has substantive placeholders for deeper context (Context and problem statement, Considered options' specific rejections, etc.). You or `<Lead Role> @ <Unit Name>` can edit it to fill them in — ADRs are immutable only after they're substantively complete; finishing the placeholders is part of authorship.*

If the unit is the agency's root, also append:

> *Note: the root README's directory-tree visualization isn't auto-updated by this skill. If you want it to reflect `<Role> @ <Unit Name>`, edit `<unit_path>/README.md`'s "Directory layout" section manually.*

Substitute the angle-bracketed tokens with actual values.

---

## Rules

- **Lead-only invocation.** Adding an agent is a substantive roster change (redistribution of work). §0009 makes the Registrar's authority strictly procedural — they can't make this call. The skill verifies CWD's basename prefix matches the parent unit's `lead-role` and refuses otherwise. Registrar audits afterwards.
- **CWD must be the Lead's directory.** The skill operates only from the Lead's session; it does not search anywhere outside CWD and `<cwd>/..` (a single deterministic dereference, not iterative search).
- **All inputs come from CWD's parent (the unit).** Agency name, user role, lead role, implementer role are read from the unit's `silcrow-meta` anchor; the unit name is the parent's basename. The skill does not look anywhere outside `<cwd>` and `<cwd>/..`.
- **One consolidated diff before any edits.** Compose every change first, show the user a single review block covering all affected files, apply only on explicit approval. No piecewise edits with intermediate state.
- **Use the script for mechanics.** Don't hand-create the agent's directory or the establishing ADR — the script does that. The skill does the substantive content (new AGENTS.md, edits to existing AGENTS.mds, README roster update, commit).
- **Never overwrite an existing agent.** The script refuses on collision; relay the error.
- **The ADR template has substantive placeholders** that the script fills only mechanically. The skill may pre-fill some from conversation, but deeper context is left for the Lead to flesh out — same pattern as `:silcrow-add-unit`.
- **One governance commit per §0015.** Everything ships in one commit, citing the §-number of the establishing ADR.
- If the plugin's scripts are missing or not executable, stop and report that the plugin is not installed correctly.
