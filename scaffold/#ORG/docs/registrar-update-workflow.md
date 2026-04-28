# Registrar — `:silcrow-update` workflow

This is the Registrar's most elaborate workflow. Read this file **only when a message from the `:silcrow-update` skill lands in your inbox**; don't preemptively load it. The core operational reference is `../agents/registrar/AGENTS.md`; this file is the detailed procedure for one specific trigger.

---

## 1. Identify the request

The skill drops a message like:

```
Subject: Update audit request
From: :silcrow-update skill
Body:
  Plugin canonical source: ${CLAUDE_PLUGIN_ROOT}/scaffold/#ORG/...
  Request: Audit this agency against the current scaffold canonical state.
  Report additions, deletions, and changes to User and Lead for approval.
  Execute approved changes.
```

## 2. Scan past audit ADRs (§0016)

Before diffing, read all past audit ADRs in `#ORG/adr/accepted/`. They'll have titles like *"Update audit, YYYY-MM-DD"*. From these:

- **Items previously rejected** — skip re-proposing if the plugin's current version is unchanged. Summarize in the report: *"2 items previously rejected in §00XX remain in the plugin's current state; skipping per your past decision."*
- **Items previously deferred** — re-surface with their original context if the deferral trigger has fired (or just re-surface with a prompt).
- **Local supersessions that resolved past conflicts** — treat those local ADRs as canonical ground; don't re-propose the plugin's original.

## 3. Dynamic diff

Walk both trees:

- Plugin source: `${CLAUDE_PLUGIN_ROOT}/scaffold/#ORG/...`
- Agency: the current `#ORG/` (and any units, if auditing from the agency level).

Classify each file:

- **Match** — identical content; skip silently.
- **Addition** — in plugin, not in agency.
- **Removal** — in agency, not in plugin.
- **Modification** — in both, different content.
- **Relocation** — in both, different paths.

For equality checks, hash files; for content differences, read them. Whichever is cheaper for the context.

## 4. One-sentence descriptors

For each non-match, write a single sentence capturing what it is and why it matters. Examples:

- *"New ADR: Registrar operates as async auditor, not sync gatekeeper."*
- *"Your customized lead instructions have a stale path reference (`agents/` → `#ORG/agents/`)."*
- *"Agency has `docs/old-process.md` that the plugin no longer ships — likely safe to archive."*
- *"Plugin ships a new foundation doc (07-canonical-and-operational.md); your agency doesn't have one."*

## 5. Write the report

Send to both {user_role}'s and {lead_role}'s inboxes:

```
Scaffold update audit — YYYY-MM-DD

SUMMARY
  Additions:     N items
  Modifications: M items
  Removals:      K items
  Conflicts:     J items (local supersessions interact with plugin changes)

ADDITIONS
  [A1] §00XX — <title>.
       <descriptor>.
       → Approve / Reject / Defer / More detail

MODIFICATIONS
  [M1] <path> → <new path>
       Location change; content unchanged.
       → Approve / Reject / Defer / More detail
  [M2] <path> (content change)
       Plugin modifies section X; your file has local customizations.
       → Approve / Reject / Defer / More detail

REMOVALS
  [R1] <path>
       No longer shipped by plugin.
       → Archive / Keep / Defer

CONFLICTS
  [C1] Plugin §00YY conflicts with your §0015 (both supersede §0008 with different approaches).
       → Options: adopt plugin, keep yours, merge, defer

Previously rejected items still present in plugin (skipped):
  - [<item>] per §00XX

Previously deferred items (please revisit):
  - [<item>] per §00YY — trigger was <X>; ready to decide?

Respond with the item numbers you approve/reject/defer. I'll execute
approved changes and send a final audit when complete.
```

## 6. Wait for approval

Let the User and Lead review and respond. Each non-match needs a per-item decision. Batch approval is permitted only for mechanical moves with identical justification (e.g., 24 file moves for a structural migration). Content changes are never batch-approved.

## 7. Execute approved changes

For each approved item:

- **File moves/renames** — execute directly.
- **ADR creations** — assign §-numbers, place in `#ORG/adr/accepted/`, update index and bidirectional citations.
- **Content rewrites** — only on files the user explicitly approved rewriting. For customized files, engage per-file dialogue:

   > *"Your current content diverges from the plugin's here, here, and here. Would you like to (a) adopt the plugin's version, (b) keep yours, (c) merge section by section?"*

- **Removals** — never delete. Archive to `#ORG/.archive/<date>/` with a note explaining why.
- **Conflicts** — never choose between local and plugin versions yourself. Present options and execute what the user picks. On request, you may draft a merged option (c) as a starting point.

## 8. Author the audit ADR (§0016)

After executing, write one audit ADR summarizing the session:

```
§00XX — Update audit, YYYY-MM-DD

Y-statement, listing accepts, rejects, and deferrals.

Accepted (now in #ORG/adr/accepted/ under their §-numbers):
  - §00YY — <descriptor>

Rejected (user's reasoning preserved):
  - Plugin's proposed <descriptor> — reason: <user's words>

Deferred (with revisit triggers):
  - Plugin's proposed <descriptor> — deferred until <context>; revisit at <trigger>

File-level changes applied:
  - <summary of moves, rewrites, archivals>
```

Place in `#ORG/adr/accepted/` with the next §-number. This is the canonical record of the audit session and will be consulted on future `:silcrow-update` runs.

## 9. Final acknowledgment and commit

Send a short message to both {user_role} and {lead_role}:

> *"Update audit complete. §00XX records the session. Accepted: N; rejected: K; deferred: J. File changes committed in one structured commit."*

Commit the entire update's changes in **one commit** (§0018):

```
§00XX: update audit — accepted A, rejected B, deferred C

Accepted:
  - §00YY: <descriptor>

File-level changes:
  - Moved agents/ → #ORG/agents/
  - Updated lead/AGENTS.md (sections 2-4)
  - Archived docs/old-process.md

Rejected:
  - <descriptor> — <reason>

Deferred:
  - <descriptor> — <revisit trigger>

See §00XX audit ADR for full reasoning.
```

Rationale: multiple small commits per change would make `:silcrow-update` slow and noisy. The audit ADR preserves the granular reasoning; the git log stays clean.
