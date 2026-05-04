---
name: silcrow-update
description: Bring an existing agency into conformity with the plugin's current canonical state. **Root Registrar only** — only the Registrar of the agency's root unit invokes this. Drops a request into the Registrar's own inbox; the workflow then runs in their session (dynamic diff, per-change approval, execution, audit-ADR authoring). Use when the user says "update the scaffold," "sync to the latest plugin," "apply scaffold updates," "run scaffold update audit," or similar.
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

**Only the Registrar of the agency's root unit runs this skill.**

If you (the agent reading this) are anyone else — Lead, Implementer, User, a sub-unit Registrar, or any custom agent in any unit — **stop**. Do not proceed. Tell the user:

> *"This skill must be run by the Registrar of the agency's root unit. Open a session inside `@ <Agency Name>/Registrar @ <Agency Name>/` and re-run `:silcrow-update` there. I'll wait."*

The skill enforces this with a CWD check (Phase 1 below). If you skip the check or work around it, you violate the discipline this skill exists to enforce.

## Why root Registrar only

- **§0009 makes the Registrar the procedural authority for record integrity.** Update audits are the most thorough form of that — diffing the agency against canonical state, proposing changes, executing approved ones, authoring an audit ADR. That's procedural work; only the Registrar does it.
- **The plugin defines agency-wide canonical state.** The whole agency's structure (root unit + every sub-unit) is governed by what the plugin ships. Reconciling an agency against the plugin is therefore an agency-wide operation. Only the **root** Registrar's scope can drive it; sub-unit Registrars' scope is just their own subtree (per §0012 federation), which can't see the whole picture.
- **Lead, Implementer, User don't run it** because they're substantive decision-makers; §0009 prohibits them from doing the procedural audit work directly. They participate in the workflow by approving items.
- **No other agent in the root unit runs it either** — not a Researcher, Designer, Marketing Lead, or any role added later. The Registrar is the single agent for record-integrity work; even at the root, that's a fixed role.

## When to use

- A new version of the Silcrow plugin has shipped and the user wants to adopt the changes.
- The user suspects their agency's governance has drifted from the current scaffold and wants a reconciliation.
- The user says something like "update my scaffold," "sync to the latest," "run an update audit," or similar.

## Two principles (§0013)

- **No version tracking in the sync flow.** The plugin ships "current canonical state." Every `:silcrow-update` invocation is "here's the plugin's current state; compare to your current state." The `Plugin Version.md` tracker (introduced in 0.26.0) is informational only — the audit itself does a dynamic diff regardless.
- **User approves every change.** Additions, deletions, content modifications, structural moves — all pass through user approval before execution. The Registrar never auto-clobbers.

## How this skill works

Three steps:

1. Verify CWD is the root Registrar's own directory (Phase 1).
2. Drop a single message into CWD's own `inbox/` — your inbox, since you're the Registrar (Phase 2).
3. Acknowledge the user; tell them you're starting the audit workflow (Phase 3).

The workflow runs in your same session: read the message you just deposited, archive it per §0005's reading-is-moving discipline, then load `@ <Agency Name>/3 | Silcrow Agency Reference/Registrar Update Workflow.md` and execute the 10-step procedure.

The drop-and-archive cycle isn't busywork — it preserves the record. The archived request shows future readers (and future audits) what triggered the session, in the same form as any other inbox-driven workflow.

---

## Phase 1 — Verify CWD is the root Registrar's directory

Before any output, run all four checks. Fail any → stop and redirect the user. **Do not proceed with checks failing.**

1. **CWD shape check.** `pwd` to find CWD. Its basename must match the literal pattern `Registrar @ <Unit Name>` (the prefix is literally "Registrar" — that role name is fixed across the scaffold and never renamed; the suffix is the unit's display name).
2. **Parent is a unit.** `<cwd>/..` must exist and its basename must start with `@ ` (it's a unit directory).
3. **Parent is the agency root.** Read `<cwd>/../README.md` and extract the `silcrow-meta` anchor's `agency` field. The parent unit's display name (basename minus `@ `) must equal that `agency` value. If they match, the parent unit IS the agency's root unit. If they differ, the parent is a sub-unit, not the root.
4. **Anchor present.** If `<cwd>/../README.md` is missing the `silcrow-meta` anchor entirely, the agency predates 0.21.0 and needs a manual fix or a different update path; refuse.

### Failure messages

- **CWD's basename doesn't match `Registrar @ <Unit Name>`:** *"This skill must be run by the Registrar of the agency's root unit. Your current directory doesn't look like a Registrar's session. Open a session inside `@ <Agency Name>/Registrar @ <Agency Name>/` and re-run `:silcrow-update` there."*
- **Parent isn't a unit:** *"You're not inside a scaffolded agency. Run `:silcrow-init` first to scaffold one, or navigate into an existing agency."*
- **Parent is a sub-unit (not the root):** *"Only the agency's ROOT Registrar runs this skill. Your current directory is a sub-unit's Registrar. Open a session at `@ <Agency Name>/Registrar @ <Agency Name>/` (the root Registrar) instead. Sub-unit Registrars don't drive plugin updates — that's an agency-wide operation by design."*
- **Missing `silcrow-meta` anchor:** *"This agency's root README is missing the `silcrow-meta` anchor that the update flow needs. The anchor was introduced in plugin version 0.21.0. Add it manually (see `<plugin>/scaffold/unit/README.md` for the format) and re-run."*

### What to remember after Phase 1

- The agency name (from the anchor's `agency` field).
- The Registrar's own inbox path: `<cwd>/inbox/`.

---

## Phase 2 — Drop the request message

Write a single message file into `<cwd>/inbox/`. Filename:

```
YYYY-MM-DD-update-skill-request.md
```

(If a file by that name already exists — second invocation on the same day — suffix with `-01`, `-02`, etc.)

Message body:

```markdown
# Update audit request

- **From:** :silcrow-update skill
- **To:** Registrar @ <Agency Name>
- **Date:** YYYY-MM-DD
- **References:** §0009 (your async audit mode), §0013 (audit-ADR pattern), §0015 (one commit per update)
- **Kind:** update-request

## Request

Audit this agency against the current scaffold canonical state shipped by the
Silcrow plugin. Audit scope is the entire agency (root unit + every sub-unit) —
since you are the root Registrar, only you can drive an agency-wide reconciliation
(per §0012 federation, sub-unit Registrars' scope is just their own subtrees).

- **Plugin:** `silcrow`. Resolve the canonical source path yourself in your
  audit session (the path includes the version, and version-pinning at
  message-write time can drift from the active install). Procedure:
  1. Read `${CLAUDE_PLUGIN_ROOT}` from your own session env. If it points
     at a path containing `scaffold/unit/`, that's the canonical source.
  2. If `${CLAUDE_PLUGIN_ROOT}` isn't set, scan
     `~/.claude/plugins/cache/silcrow/` and pick the latest semver
     directory; its `scaffold/unit/` is canonical.
  3. If multiple versions are present in cache and one isn't unambiguously
     the active one, surface the situation to the User and confirm which
     to sync against before diffing. Record the resolved path + how it
     was chosen in the audit ADR's reasoning.
- **Audit scope:** `@ <Agency Name>/` (the entire agency tree)

Please follow the 10-step workflow in `@ <Agency Name>/3 | Silcrow Agency Reference/Registrar Update Workflow.md`:

1. Identify this request.
2. Resolve the plugin's canonical source.
3. Scan past audit ADRs (§0013) in `@ <Agency Name>/1 | Canon/accepted/` for previously rejected/deferred items.
4. Map both trees (plugin source + agency) and compute a dynamic diff.
5. Author one-sentence descriptors for every non-match.
6. Write a structured report to User and Lead inboxes; wait for per-item approval.
7. Execute approved changes (file moves, ADR creations with §-numbers, content rewrites, archivals for removals).
8. Author the audit ADR (§0013) summarizing the session.
9. Commit per §0015.
10. Update `Plugin Version.md` to the version just synced to.

This message is the single trigger; everything from here is yours.
```

Substitute `YYYY-MM-DD` with today's date and `<Agency Name>` with the agency name from Phase 1.

---

## Phase 3 — Acknowledge the user

Output a short message to the user:

> *Update audit initiated. I've dropped a request in my own inbox at `<cwd>/inbox/YYYY-MM-DD-update-skill-request.md`. I'll archive it per §0005 and start the audit workflow in this session.*
>
> *The workflow:*
> - *Diff the agency (root + every sub-unit) against the plugin's current canonical state.*
> - *Scan past audit ADRs to skip previously-rejected items.*
> - *Write a report to your inbox and the Lead's inbox with every proposed change — one-sentence descriptor, approve/reject/defer per item.*
> - *Execute what you approve, author an audit ADR summarizing the session (§0013), commit per §0015, and update `Plugin Version.md` to the version just synced to.*
>
> *I'll surface progress as I go and wait for your approval at the report stage.*

Then immediately proceed to load the Update Workflow doc and begin the work — the request is in your inbox; that's your trigger.

---

## Rules

- **Root Registrar only.** Verified by Phase 1's checks. Refuse to proceed otherwise. There is no exception — not Lead, not User, not a sub-unit Registrar, not a custom agent at the root. Only `Registrar @ <Agency Name>/`.
- **Be thin.** This skill does nothing except drop the trigger message and acknowledge. The substantive workflow runs after, driven by the Update Workflow doc.
- **Write only to your own inbox.** `<cwd>/inbox/<filename>.md`. Don't write anywhere else.
- **The message triggers the workflow.** After Phase 3, load the Update Workflow doc and run it. Don't try to short-circuit by skipping the message-and-archive step — the record is part of the discipline.
