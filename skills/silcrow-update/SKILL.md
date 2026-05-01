---
name: silcrow-update
description: Bring an existing agency into conformity with the plugin's current canonical state. Drops a message into the Registrar's inbox requesting an update audit; the Registrar does the intelligent work (dynamic diff, per-change approval, execution, audit-ADR authoring). Use when the user says "update the scaffold," "sync to the latest plugin," "apply scaffold updates," "run scaffold update audit," or similar.
user-invocable: true
allowed-tools:
  - Read
  - Glob
  - Grep
  - Bash(ls:*)
  - Bash(test:*)
  - Bash(pwd:*)
  - Write
---

# Agent Org Scaffold — Update

Bring an existing agency into conformity with the plugin's current canonical state (§0015). This skill is **intentionally thin** — it drops a single message into the Registrar's inbox and exits. The Registrar does the real work: dynamic diff against the plugin source, per-item approval dialogue with User and Lead, execution of approved changes, authoring the audit ADR.

## When to use

- A new version of the Silcrow plugin has shipped and the user wants to adopt the changes.
- The user suspects their agency's governance has drifted from the current scaffold and wants a reconciliation.
- The user says something like "update my scaffold," "sync to the latest," "run an update audit," or similar.

## Two principles (§0015)

- **No version tracking.** The plugin ships "current canonical state." Every `:silcrow-update` invocation is "here's the plugin's current state; compare to your current state." Whether the agency is one small change behind or many large changes behind, the workflow is the same.
- **User approves every change.** Additions, deletions, content modifications, structural moves — all pass through user approval before execution. The Registrar never auto-clobbers.

## How this skill works

Four tiny steps:

1. Confirm the agency exists (walk up for `#ORG@<unit-name>/`).
2. Identify the Registrar's inbox (`#ORG@<unit-name>/agents/registrar@<unit-name>/inbox/`).
3. Drop a single message into that inbox containing:
   - The plugin's canonical source path: `${CLAUDE_PLUGIN_ROOT}/scaffold/#ORG/`.
   - A request: *"Audit this agency against the current scaffold canonical state. Report additions, deletions, and changes to User and Lead for approval. Execute approved changes."*
4. Let the user know the audit has been initiated and point them at the Registrar's next report.

That's it. No diffing. No reporting. No file operations. The Registrar is the engine.

---

## Phase 1 — Peek silently

Before any output:

- `pwd` to find the current working directory.
- Walk upward to find the nearest `#ORG@<unit-name>/`. That's the unit this audit will scope to — the root unit if invoked at the agency's top, or a sub-unit if invoked deeper. `:silcrow-update` works at any level; the Registrar for that scope handles it.
- If no `#ORG@<unit-name>/` is found, stop. Tell the user: *"I don't see an agency here (no `#ORG@<unit-name>/` in the current or parent directories). Run `:silcrow-init` to scaffold one, or navigate to an existing agency's directory."*
- Find the Registrar's inbox: `<found_org_parent>/#ORG@<unit-name>/agents/registrar@<unit-name>/inbox/`. Verify it exists.

---

## Phase 2 — Drop the message

Write a single message file into the Registrar's inbox. Filename:

```
YYYY-MM-DD-update-skill-request.md
```

(If a file by that name already exists — maybe because the skill was invoked twice on the same day — suffix with `-01`, `-02`, etc.)

Message body:

```markdown
# Update audit request

- **From:** :silcrow-update skill
- **To:** Registrar
- **Date:** YYYY-MM-DD
- **References:** §0011 (your async audit mode), §0015 (audit-ADR pattern), §0017 (one commit per update)
- **Kind:** update-request

## Request

Audit this agency against the current scaffold canonical state shipped by the
Silcrow plugin.

- **Plugin canonical source:** `${CLAUDE_PLUGIN_ROOT}/scaffold/#ORG/`
  - (resolve `${CLAUDE_PLUGIN_ROOT}` from the environment Claude Code provides; it points at the installed plugin's root directory)
- **Agency root:** `<agency_or_unit_path>`

Please:

1. Scan past audit ADRs (§0015) in `#ORG@<unit-name>/adr/accepted/` to determine which items
   have been previously rejected, deferred, or resolved via local supersession.
2. Compute a dynamic diff between the plugin's canonical state and the agency's
   current state. Classify each file as match, addition, removal, modification,
   or relocation.
3. Author a one-sentence descriptor for every non-match, then write a structured
   report to both User and Lead inboxes (same content in both).
4. Wait for per-item approval from User and/or Lead.
5. Execute approved changes:
   - File moves/renames — direct.
   - ADR creations — assign §-numbers, place in `#ORG@<unit-name>/adr/accepted/`, update index and bidirectional citations.
   - Content rewrites — per-file dialogue for customized files; plugin version for untouched ones.
   - Removals — archive to `#ORG@<unit-name>/.archive/<date>/`, never delete.
   - Conflicts — present options; execute the user's pick.
6. Author one audit ADR (§0015) summarizing the whole session — accepts,
   rejects, deferrals, and file-level changes.
7. Commit the whole update as one structured commit per §0017.
8. Send a final acknowledgment to User and Lead.

See the `:silcrow-update` workflow section of `#ORG@<unit-name>/agents/registrar@<unit-name>/AGENTS.md`
for the detailed orchestration procedure. This message is the single trigger;
everything from here is yours.
```

Substitute `YYYY-MM-DD` with today's date and `<agency_or_unit_path>` with the found root.

---

## Phase 3 — Acknowledge the user

Output a short message to the user:

> *Update audit initiated. I've dropped a request in the Registrar's inbox at `<agency_root>/#ORG@<unit-name>/agents/registrar@<unit-name>/inbox/YYYY-MM-DD-update-skill-request.md`.*
>
> *The Registrar will:*
> - *Diff the agency against the plugin's current canonical state.*
> - *Scan past audit ADRs to skip previously-rejected items.*
> - *Write a report to your inbox and your Lead's inbox with every proposed change — one-sentence descriptor, approve/reject/defer per item.*
> - *Execute what you approve, author an audit ADR summarizing the session (§0015), and commit it all in one structured commit (§0017).*
>
> *Open a session with the Registrar (inside `#ORG@<unit-name>/agents/registrar@<unit-name>/`) to work through the audit, or wait for the report to arrive in your inbox.*

---

## Rules

- **Be thin.** This skill does nothing except drop the trigger message. No diffing, reporting, file operations, ADR authoring. All of that is the Registrar's role.
- **Refuse to proceed without `#ORG@<unit-name>/`.** If the CWD is not inside a scaffolded agency, redirect to `:silcrow-init`.
- **Write to the correct inbox.** The audit scope is whichever unit's `#ORG@<unit-name>/` was found by walking up — the root unit if invoked at the agency's top, or a sub-unit if invoked deeper in the tree. Write to that unit's Registrar inbox; the Registrar for that scope handles their scope only (§0014 federation rule).
- **Never edit `#ORG@<unit-name>/` content directly.** This skill only writes one message file into an inbox. All substantive work happens through the Registrar.
- **The message triggers the workflow.** The Registrar's `AGENTS.md` describes what happens after. You don't orchestrate — you initiate.
