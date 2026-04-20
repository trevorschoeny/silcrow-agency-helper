---
name: init
description: Scaffold a hierarchical agent organization with ADR decision tracking, actor-model message passing between agents, and registrar-enforced record integrity. One-shot initialization only — after scaffolding, the generated structure and instructions maintain the conventions without further skill invocation. Use when the developer says "scaffold agent organization," "initialize agent hierarchy," "set up agent-based project," "bootstrap multi-agent org," "new agent org," "agent-org-scaffold," or similar.
user-invocable: true
allowed-tools:
  - Read
  - Glob
  - Grep
  - Bash(ls:*)
  - Bash(test:*)
  - Bash(${CLAUDE_PLUGIN_ROOT}/scripts/scaffold.sh:*)
  - AskUserQuestion
---

# Agent Org Scaffold — Init

Initialize a disciplined multi-agent project with built-in decision tracking, actor-model messaging, and registrar-enforced record integrity. The scaffold ships with a **founding record of nine seeded ADRs** (§0001–§0009) that capture the constitutional decisions of the pattern itself — each citable, each supersedable, each paired with a foundation doc explaining its reasoning.

## One-shot skill

Run this skill **once**, at project initialization. After scaffolding completes, the generated `docs/*` files and `agents/*/instructions.md` files carry every convention forward. **Do not re-invoke this skill** to modify an existing scaffold — edit files directly, or (better) submit a new ADR through the generated decision process.

If the user asks to "re-run" the skill against an existing project, stop and explain the one-shot design. The skill performs no diff logic, no migrations, no upgrades.

## How this skill works

All file copy and token substitution is performed by a bundled bash script (`${CLAUDE_PLUGIN_ROOT}/scripts/scaffold.sh`). Your job as the skill is to:

1. Gather the scoping values from the user.
2. Confirm them.
3. Invoke the script with those values as arguments.
4. Relay the result.

The script handles conflict detection, directory creation, file copy, and sed-based token substitution across the full template tree (37 files, ~3,200 lines of markdown). It completes in under a second. Do not attempt to do these operations file-by-file via Read+Write — you will be slower by several orders of magnitude and you risk introducing accidental content changes.

---

## Phase 1 — Pre-flight

Ask the user for the **destination path** where the scaffold should be created. Default: the current working directory.

You don't need to perform a conflict check yourself — the script does it and will exit non-zero with a clear message if conflicts exist. But if you want a faster negative signal to the user, a single `ls "$DST"` or `test -d "$DST/agents"` before collecting all the answers is reasonable. Optional.

---

## Phase 2 — Scoping questions

Ask these five questions, in order. Use `AskUserQuestion` for closed-choice answers; prose for free-text answers.

1. **Project name** (free text) — Used in README, roster, §0001.
2. **One-sentence description** (free text) — Used in README and §0001.
3. **User's directory name** (free text, default: `user`) — The directory under `agents/` that represents the human user. Common choices: first name, initials, or keep as `user`. Will be lowercased and kebab-cased for the directory; a display-cased form is used in prose. (If the user gives a name, the skill derives the display form by title-casing the first letter.)
4. **Rename the generic roles?** (closed-choice) — Options: "Keep defaults (Lead, Implementer)" or "Rename to domain-specific titles". If renamed, ask separately for the new names for Lead and Implementer. Keep `registrar` as-is — the title is part of the pattern.
5. **Destination path** — already collected in Phase 1; carry forward without re-asking.

After collecting all answers, briefly echo them back in one message **and then immediately proceed to Phase 3**. Do **not** ask for confirmation — the user already invoked the skill; requesting an extra "shall I run it?" adds friction without adding safety (the script is idempotent up to the pre-flight conflict check, which handles the one real failure mode). The echo is an acknowledgment, not a gate. If the user typed something clearly wrong and catches it mid-echo, they'll say so; otherwise run the script.

Exception: if an answer is genuinely ambiguous or incomplete (user skipped a question, gave a value that can't be parsed, provided a destination that doesn't exist and can't be created), ask the clarifying question. A well-formed set of answers should never produce a "shall I run it?" prompt.

### Deriving the nine values

| Value | How to compute |
|---|---|
| `<destination>` | Phase 1 / Q5, absolute path preferred |
| `<project_name>` | Q1 verbatim |
| `<project_description>` | Q2 verbatim |
| `<user_dir>` | Q3, lowercased, kebab-cased (spaces → hyphens) |
| `<user_role>` | Display form of Q3 (title case; e.g. `user`→`User`, `alice`→`Alice`). If Q3 is `user`, pass `User`. |
| `<lead_dir>` | `lead` unless renamed in Q4 |
| `<lead_role>` | `Lead` unless renamed in Q4 (then title-cased) |
| `<implementer_dir>` | `implementer` unless renamed in Q4 |
| `<implementer_role>` | `Implementer` unless renamed in Q4 (then title-cased) |

The date is auto-computed by the script (`date -u +%Y-%m-%d`); you do not pass it.

---

## Phase 3 — Run the scaffold script

Invoke the bundled script with the nine values as positional arguments **in this exact order**:

```bash
"${CLAUDE_PLUGIN_ROOT}/scripts/scaffold.sh" \
    "<destination>" \
    "<project_name>" \
    "<project_description>" \
    "<user_dir>" \
    "<user_role>" \
    "<lead_dir>" \
    "<lead_role>" \
    "<implementer_dir>" \
    "<implementer_role>"
```

Quote each argument so values with spaces (project name, description, renamed role titles) pass through cleanly.

The script:
- Exits **0** on success and prints `✓ Scaffolded <project_name> at <destination>`.
- Exits **1** on any conflict (existing `agents/`, `adr/`, `proposed/`, `§*.md`, or scaffold docs at the destination). Error message explains what to remove.
- Exits **2** on argument-count errors (you passed the wrong number of arguments).

If the script returns non-zero, **do not attempt recovery.** Relay the error message to the user and stop.

On success, proceed to Phase 4.

---

## Phase 4 — Report and exit

Print a completion report. The script already printed `✓ Scaffolded ...`; you add the roster summary and next-reads so the user knows where to start:

```
✓ <project_name> — agent organization scaffold initialized at <destination>

Starter roster (agents/):
  <user_dir>/          — tier 0 (<user_role>): strategic direction, agent-roster changes
  <lead_dir>/          — tier 1 (<lead_role>): briefs, architecture, plan review
  <implementer_dir>/   — tier 2 (<implementer_role>): planning + execution under briefs
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
  adr/accepted/§0010-roster-change-protocol.md
  adr/accepted/§0011-project-scope.md  (seed — expected to be superseded early)

Read these, in order, before starting work:
  1. README.md                          — project orientation
  2. docs/philosophy.md                 — why this works the way it does
  3. docs/decision-process.md           — ADR lifecycle, §-numbering, supersession
  4. docs/message-protocol.md           — how agents communicate
  5. agents/<your-role>/instructions.md — your role's duties

First collaborative task for <user-role> and <lead-role>:
  Expand §0011 into a real project-scope statement via supersession.

This skill will not be invoked again. All further work happens through the
scaffold's own process: messages between agent inboxes, proposals into
proposed/, decisions into adr/accepted/ via the registrar.
```

---

## Rules

- **Use the script.** Do not open individual template files and rewrite them file-by-file. The script is orders of magnitude faster and incapable of accidentally altering template content.
- **Never overwrite existing files.** The script refuses on conflict; respect the refusal and relay the message to the user rather than trying to work around it.
- **Never modify files outside the destination directory.** The script only writes under the destination path; you should only be handing it arguments.
- If `${CLAUDE_PLUGIN_ROOT}/scripts/scaffold.sh` is missing or not executable, stop and report that the plugin is not installed correctly.

## What the script does internally (for reference, not for re-implementation)

1. Validates its 9 positional arguments and computes today's date.
2. Checks the destination for conflicts (existing `agents/`, `adr/`, `proposed/`, `docs/philosophy.md`, `docs/decision-process.md`, or `§*.md` files) and exits non-zero if any are present.
3. Creates the destination tree with `mkdir -p`.
4. Copies every `.gitkeep` file (empty placeholders).
5. For every markdown file under `${CLAUDE_PLUGIN_ROOT}/scaffold/`, runs `sed` with nine `s|{token}|value|g` substitutions and writes the output to the destination. `user/`, `lead/`, and `implementer/` source directories are remapped to `<user_dir>/`, `<lead_dir>/`, `<implementer_dir>/` at write time. Template placeholders in `_templates/*.md` (like `{short decision title in imperative form}`) do not match any of the nine tokens and pass through unchanged.
6. Prints a one-line success acknowledgment and exits 0.

See `${CLAUDE_PLUGIN_ROOT}/scripts/scaffold.sh` if you need to audit or modify this behavior.
