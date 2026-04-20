---
name: init
description: Scaffold a hierarchical agent organization with ADR decision tracking, actor-model message passing between agents, and registrar-enforced record integrity. One-shot initialization only — after scaffolding, the generated structure and instructions maintain the conventions without further skill invocation. Use when the developer says "scaffold agent organization," "initialize agent hierarchy," "set up agent-based project," "bootstrap multi-agent org," "new agent org," "agent-org-scaffold," or similar.
user-invocable: true
allowed-tools:
  - Read
  - Write
  - Glob
  - Grep
  - Bash(mkdir:*)
  - Bash(test:*)
  - Bash(ls:*)
  - AskUserQuestion
---

# Agent Org Scaffold — Init

Initialize a disciplined multi-agent project with built-in decision tracking, actor-model messaging, and registrar-enforced record integrity. The scaffold ships with a **founding record of nine seeded ADRs** (§0001–§0009) that capture the constitutional decisions of the pattern itself — each citable, each supersedable, each paired with a foundation doc explaining its reasoning.

## One-shot skill

Run this skill **once**, at project initialization. After scaffolding completes, the generated `docs/*` files and `agents/*/instructions.md` files carry every convention forward. **Do not re-invoke this skill** to modify an existing scaffold — edit files directly, or (better) submit a new ADR through the generated decision process.

If the user asks to "re-run" the skill against an existing project, stop and explain the one-shot design. The skill performs no diff logic, no migrations, no upgrades.

## Template source

The source-of-truth templates live at **`${CLAUDE_PLUGIN_ROOT}/scaffold/`** — the plugin's installed root. Read templates from there. Do not hardcode their contents.

If `${CLAUDE_PLUGIN_ROOT}/scaffold/` cannot be read, stop and report that the plugin is not installed correctly.

---

## Phase 1 — Pre-flight

Ask the user for the **destination path** where the scaffold should be created. Default: the current working directory.

Then check for conflicts at the destination. If **any** of these already exist, stop:

- `agents/`
- `adr/`
- `docs/philosophy.md`
- `docs/decision-process.md`
- any file matching `§*.md`
- `proposed/`

If a conflict exists, tell the user:

> This destination already contains an agent scaffold or conflicting files. To reinitialize from scratch, remove the existing `agents/`, `adr/`, `proposed/`, and scaffold docs first. This skill will not overwrite existing records.

Do not attempt to merge, migrate, or reconcile.

---

## Phase 2 — Scoping questions

Ask these five questions, in order. Use `AskUserQuestion` for closed-choice answers; prose for free-text answers.

1. **Project name** (free text) — Used in README, roster, §0001.
2. **One-sentence description** (free text) — Used in README and §0001.
3. **User's directory name** (free text, default: `user`) — The directory under `agents/` that represents the human user. Common choices: first name, initials, or keep as `user`. Will be lowercased and kebab-cased for the directory; a display-cased form is used in prose.
4. **Rename the generic roles?** (closed-choice) — Options: "Keep defaults (Lead, Implementer)" or "Rename to domain-specific titles". If renamed, ask separately for the new names for Lead and Implementer. Keep `registrar` as-is — the title is part of the pattern.
5. **Destination path** (already collected in Phase 1; confirm and proceed).

After collecting, summarize all answers back to the user in one message. Proceed on nod (or absence of objection).

---

## Phase 3 — Create directories

At the destination, create this tree:

```
{destination}/
├── agents/
│   ├── {user_dir}/inbox/archive/
│   ├── {lead_dir}/inbox/archive/
│   ├── {implementer_dir}/inbox/archive/
│   └── registrar/inbox/archive/
├── adr/
│   ├── _templates/
│   ├── accepted/
│   ├── superseded/
│   ├── rejected/
│   └── anti-patterns/
├── proposed/
└── docs/
    └── foundations/
```

Use `mkdir -p`. Preserve empty directories by copying `.gitkeep` files from the scaffold where present.

---

## Phase 4 — Interpolate and copy templates

Two kinds of files live under `${CLAUDE_PLUGIN_ROOT}/scaffold/`:

- **Interpolated files** — contain `{token}` placeholders to substitute before writing.
- **Static files** — copy verbatim.

### Interpolation tokens

| Token | Value |
|---|---|
| `{project_name}` | Phase 2 Q1 |
| `{project_description}` | Phase 2 Q2 |
| `{user_dir}` | Phase 2 Q3, lowercased/kebab-cased |
| `{user_role}` | Display form of `{user_dir}` (title case; e.g. `User`, `Alice`) |
| `{lead_dir}` | From Phase 2 Q4 — default `lead` |
| `{lead_role}` | Display form of `{lead_dir}` (e.g. `Lead`, `Architect`) |
| `{implementer_dir}` | From Phase 2 Q4 — default `implementer` |
| `{implementer_role}` | Display form of `{implementer_dir}` |
| `{date}` | Today's date, `YYYY-MM-DD` |

### Files that get interpolated

Read each of these, substitute tokens, write to the target:

| Source | Target |
|---|---|
| `${CLAUDE_PLUGIN_ROOT}/scaffold/README.md` | `{destination}/README.md` |
| `${CLAUDE_PLUGIN_ROOT}/scaffold/agents/README.md` | `{destination}/agents/README.md` |
| `${CLAUDE_PLUGIN_ROOT}/scaffold/agents/user/instructions.md` | `{destination}/agents/{user_dir}/instructions.md` |
| `${CLAUDE_PLUGIN_ROOT}/scaffold/agents/lead/instructions.md` | `{destination}/agents/{lead_dir}/instructions.md` |
| `${CLAUDE_PLUGIN_ROOT}/scaffold/agents/implementer/instructions.md` | `{destination}/agents/{implementer_dir}/instructions.md` |
| `${CLAUDE_PLUGIN_ROOT}/scaffold/agents/registrar/instructions.md` | `{destination}/agents/registrar/instructions.md` |
| `${CLAUDE_PLUGIN_ROOT}/scaffold/adr/README.md` | `{destination}/adr/README.md` |
| `${CLAUDE_PLUGIN_ROOT}/scaffold/adr/accepted/§0001-adopt-agent-org-scaffold.md` | `{destination}/adr/accepted/§0001-adopt-agent-org-scaffold.md` |
| `${CLAUDE_PLUGIN_ROOT}/scaffold/adr/accepted/§0002-use-madr-with-y-statement.md` | `{destination}/adr/accepted/§0002-use-madr-with-y-statement.md` |
| `${CLAUDE_PLUGIN_ROOT}/scaffold/adr/accepted/§0003-use-section-numbering.md` | `{destination}/adr/accepted/§0003-use-section-numbering.md` |
| `${CLAUDE_PLUGIN_ROOT}/scaffold/adr/accepted/§0004-immutability-and-supersession.md` | `{destination}/adr/accepted/§0004-immutability-and-supersession.md` |
| `${CLAUDE_PLUGIN_ROOT}/scaffold/adr/accepted/§0005-communication-via-inboxes.md` | `{destination}/adr/accepted/§0005-communication-via-inboxes.md` |
| `${CLAUDE_PLUGIN_ROOT}/scaffold/adr/accepted/§0006-starter-roster-and-tier-model.md` | `{destination}/adr/accepted/§0006-starter-roster-and-tier-model.md` |
| `${CLAUDE_PLUGIN_ROOT}/scaffold/adr/accepted/§0007-briefs-not-specs.md` | `{destination}/adr/accepted/§0007-briefs-not-specs.md` |
| `${CLAUDE_PLUGIN_ROOT}/scaffold/adr/accepted/§0008-registrar-procedural-authority.md` | `{destination}/adr/accepted/§0008-registrar-procedural-authority.md` |
| `${CLAUDE_PLUGIN_ROOT}/scaffold/adr/accepted/§0009-anti-patterns-as-first-class-records.md` | `{destination}/adr/accepted/§0009-anti-patterns-as-first-class-records.md` |

### Files to copy verbatim

Everything else under `${CLAUDE_PLUGIN_ROOT}/scaffold/`:

- `${CLAUDE_PLUGIN_ROOT}/scaffold/adr/_templates/*`
- `${CLAUDE_PLUGIN_ROOT}/scaffold/adr/anti-patterns/README.md`
- `${CLAUDE_PLUGIN_ROOT}/scaffold/docs/philosophy.md`
- `${CLAUDE_PLUGIN_ROOT}/scaffold/docs/decision-process.md`
- `${CLAUDE_PLUGIN_ROOT}/scaffold/docs/message-protocol.md`
- `${CLAUDE_PLUGIN_ROOT}/scaffold/docs/registrar-playbook.md`
- `${CLAUDE_PLUGIN_ROOT}/scaffold/docs/foundations/*`
- all `.gitkeep` files

Use `Read` + `Write` for every file — **never shell `cp`** — so substitutions and conflicts are explicit.

### Token-substitution rule (important)

**Only substitute the exact tokens listed in the "Interpolation tokens" table above.** Leave other `{...}` patterns intact. The MADR templates (`_templates/*`) and some other files contain `{placeholder}` patterns like `{short decision title in imperative form}` — those are slots for future human or agent authors to fill in, not tokens for this skill to substitute. Substituting them would destroy the templates.

A safe rule: iterate the 9 specific tokens from the table and substitute each one globally within the target file. Do not use a generic regex over `{anything}`.

---

## Phase 5 — Report and exit

Print a completion report shaped like this, filling in the tokens:

```
✓ {project_name} — agent organization scaffold initialized at {destination}

Starter roster (agents/):
  {user_dir}/          — tier 0 (User): strategic direction, agent-roster changes
  {lead_dir}/          — tier 1 ({lead_role}): briefs, architecture, plan review
  {implementer_dir}/   — tier 2 ({implementer_role}): planning + execution under briefs
  registrar/           — outside hierarchy: form-integrity of the record

Founding record (nine ADRs — §0001 + eight inherited constitutional decisions):
  adr/accepted/§0001-adopt-agent-org-scaffold.md
  adr/accepted/§0002-use-madr-with-y-statement.md
  adr/accepted/§0003-use-section-numbering.md
  adr/accepted/§0004-immutability-and-supersession.md
  adr/accepted/§0005-communication-via-inboxes.md
  adr/accepted/§0006-starter-roster-and-tier-model.md
  adr/accepted/§0007-briefs-not-specs.md
  adr/accepted/§0008-registrar-procedural-authority.md
  adr/accepted/§0009-anti-patterns-as-first-class-records.md

Read these, in order, before starting work:
  1. README.md                          — project orientation
  2. docs/philosophy.md                 — why this works the way it does
  3. docs/decision-process.md           — ADR lifecycle, §-numbering, supersession
  4. docs/message-protocol.md           — how agents communicate
  5. agents/<your-role>/instructions.md — your role's duties

This skill will not be invoked again. All further work happens through the
scaffold's own process: messages between agent inboxes, proposals into
proposed/, decisions into adr/accepted/ via the registrar.
```

---

## Rules

- **Never overwrite existing files.** If a target exists, stop and report.
- **Never modify files outside the destination directory.**
- **Use Read + Write** for every file operation so substitutions and conflicts are visible.
- **No diff/migrate logic.** If the destination isn't empty-enough for a clean init, refuse and explain.
- If `${CLAUDE_PLUGIN_ROOT}/scaffold/` cannot be read, stop and report that the plugin is not installed correctly.
