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

## Phase 4 — Copy templates with token substitution

**Every file** under `${CLAUDE_PLUGIN_ROOT}/scaffold/` is copied to the destination. Every file is passed through the same token-substitution rule below — there is **no separate "verbatim" category**. Files that contain no matching tokens pass through unchanged; files that do contain tokens have them substituted. Template placeholders like `{short decision title}` survive untouched because they don't exactly match any substitution token.

### Interpolation tokens

Only these exact tokens are substituted. No other `{...}` pattern is touched.

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

### Path remapping

Source and destination paths are identical under the scaffold tree, **except**:

| Source path | Destination path |
|---|---|
| `${CLAUDE_PLUGIN_ROOT}/scaffold/agents/user/` | `{destination}/agents/{user_dir}/` |
| `${CLAUDE_PLUGIN_ROOT}/scaffold/agents/lead/` | `{destination}/agents/{lead_dir}/` |
| `${CLAUDE_PLUGIN_ROOT}/scaffold/agents/implementer/` | `{destination}/agents/{implementer_dir}/` |

All other paths — `scaffold/README.md`, `scaffold/adr/...`, `scaffold/docs/...`, `scaffold/agents/registrar/...`, `.gitkeep` files — map identically from `scaffold/X` to `{destination}/X`.

### Token-substitution rule (important)

**Iterate the nine specific tokens from the table above and substitute each one globally within the target file.** Do not use a generic regex over `{anything}`. The MADR templates in `adr/_templates/*` contain placeholder patterns like `{short decision title in imperative form}` and `{agent(s)}` — those are slots for future authors to fill in, and substituting them would destroy the templates.

Use `Read` + `Write` for every file — **never shell `cp`** — so substitutions and conflicts are explicit.

### File set

The complete set of files to copy (all under `${CLAUDE_PLUGIN_ROOT}/scaffold/`):

- `README.md`
- `agents/README.md`
- `agents/{user,lead,implementer,registrar}/instructions.md` (4 files, with path remapping above)
- `agents/{user,lead,implementer,registrar}/inbox/archive/.gitkeep` (4 `.gitkeep` files, with path remapping)
- `adr/README.md`
- `adr/_templates/{madr-full,madr-minimal,anti-pattern}.md` (3 files)
- `adr/accepted/§000N-*.md` (9 seeded ADRs, §0001 through §0009)
- `adr/anti-patterns/README.md`
- `adr/{superseded,rejected}/.gitkeep` (2 `.gitkeep` files)
- `proposed/.gitkeep`
- `docs/{philosophy,decision-process,message-protocol,registrar-playbook}.md` (4 files)
- `docs/foundations/0{1,2,3,4,5,6}-*.md` (6 files)

Glob `${CLAUDE_PLUGIN_ROOT}/scaffold/` to enumerate dynamically if more files are added in future versions.

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
