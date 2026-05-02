# Registrar — `:silcrow-update` workflow

This is the Registrar's most elaborate workflow. Read this file **only when a message from the `:silcrow-update` skill lands in your inbox**; don't preemptively load it. The core operational reference is the agency's `@{agency_dir}/registrar@{agency_dir}/AGENTS.md`; this file is the detailed procedure for one specific trigger.

---

## 1. Identify the request

The skill drops a message naming the plugin (`silcrow`) and asking you to audit this agency against the current scaffold canonical state. The skill **does not** pre-resolve the plugin path — that's your job, in your own session, with your own env, so you don't get pinned to a stale cached version someone else resolved earlier.

## 1a. Resolve the plugin's canonical source

Before diffing, find the path to the active plugin's `scaffold/unit/`:

1. **Check `${CLAUDE_PLUGIN_ROOT}` first.** Read it from your session env. If set, verify `${CLAUDE_PLUGIN_ROOT}/scaffold/unit/` exists. If yes, that's your canonical source.
2. **Fallback: walk the cache.** If `${CLAUDE_PLUGIN_ROOT}` is unset (or its `scaffold/unit/` doesn't exist), look at `~/.claude/plugins/cache/silcrow/`. Identify all version directories present. Pick the latest semver if exactly one is plausibly active.
3. **Ambiguity: surface to {user_role}.** If multiple version directories are present in the cache and you can't tell which is active (no clear marker of which Claude Code is using), do not guess. Send a brief message to {user_role} naming the candidates and ask which to sync against. Resume only after they confirm.
4. **Record the resolution.** Whichever path you ended up using and how you chose it goes in the audit ADR's reasoning section (§0015 record). Future readers can trace what was canonical at audit time.

This step exists because `${CLAUDE_PLUGIN_ROOT}` resolution is session-bound; if the `:silcrow-update` skill resolved it for you in its own session and wrote a path into the message, that path could be pointing at a cache entry no longer active by the time you read it. Resolving here, in your audit session, with your own env, eliminates that drift.

## 2. Scan past audit ADRs (§0015)

Before diffing, read all past audit ADRs in `@{unit_name}/CANON@{unit_name}/accepted/`. They'll have titles like *"Update audit, YYYY-MM-DD"*. From these:

- **Items previously rejected** — skip re-proposing if the plugin's current version is unchanged. Summarize in the report: *"2 items previously rejected in §00XX remain in the plugin's current state; skipping per your past decision."*
- **Items previously deferred** — re-surface with their original context if the deferral trigger has fired (or just re-surface with a prompt).
- **Local supersessions that resolved past conflicts** — treat those local ADRs as canonical ground; don't re-propose the plugin's original.

## 3. Dynamic diff

Walk both trees:

- Plugin source: the path you resolved in Step 1a.
- Agency: the `@{unit_name}/` of the unit you are operating in, plus the `@<sub-unit-name>/` of every sub-unit nested below it (the audit's reach is the subtree rooted at your unit; if you are the root unit's Registrar, that's the whole agency).

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
- *"Your customized lead instructions have a stale path reference (`agents/` → `@{unit_name}/`)."*
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
  [C1] Plugin §00YY conflicts with your §0014 (both supersede §0008 with different approaches).
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
- **ADR creations** — assign §-numbers, place in `@{unit_name}/CANON@{unit_name}/accepted/`, update index and bidirectional citations.
- **Content rewrites** — only on files the user explicitly approved rewriting. For customized files, engage per-file dialogue:

   > *"Your current content diverges from the plugin's here, here, and here. Would you like to (a) adopt the plugin's version, (b) keep yours, (c) merge section by section?"*

- **Removals** — never delete. Archive to `@{unit_name}/.archive/<date>/` with a note explaining why.
- **Conflicts** — never choose between local and plugin versions yourself. Present options and execute what the user picks. On request, you may draft a merged option (c) as a starting point.

## 8. Author the audit ADR (§0015)

After executing, write one audit ADR summarizing the session:

```
§00XX — Update audit, YYYY-MM-DD

Why-statement, listing accepts, rejects, and deferrals.

Accepted (now in @{unit_name}/CANON@{unit_name}/accepted/ under their §-numbers):
  - §00YY — <descriptor>

Rejected (user's reasoning preserved):
  - Plugin's proposed <descriptor> — reason: <user's words>

Deferred (with revisit triggers):
  - Plugin's proposed <descriptor> — deferred until <context>; revisit at <trigger>

File-level changes applied:
  - <summary of moves, rewrites, archivals>
```

Place in `@{unit_name}/CANON@{unit_name}/accepted/` with the next §-number. This is the canonical record of the audit session and will be consulted on future `:silcrow-update` runs.

## 8a. Broadcast the audit ADR (§0019)

You authored the audit ADR, so you broadcast its acceptance per §0019. Walk down the tree from `@{unit_name}` (this unit + every descendant sub-unit), and deposit an `adr-acceptance-notice` message in every agent's inbox. Skip yourself.

The audit-ADR notice gets the standard skeleton (per `./message-protocol.md` §6) plus the audit-specific line:

> *"This is the audit ADR for the `:silcrow-update` session of YYYY-MM-DD; see it for the full list of changes in that session."*

Rationale: every agent bound by this unit's record needs to know an update audit happened — that's what makes the difference between "the record was updated" and "the agents know about the update." The actor-model channel (§0005) does the work, and the broadcast rule (§0019) makes it routine instead of a special-case `:silcrow-update`-only mechanism.

If the audit accepted multiple new ADRs (each landing in `accepted/`), the **substantive authors of those individual ADRs** broadcast them — not you. Your broadcast is for the audit ADR specifically. In practice, most updates that author non-audit ADRs do so via the User or Lead approving content rewrites; those approvers broadcast their own. You broadcast only what you authored: the audit summary.

## 9. Final acknowledgment and commit

Send a short message to both {user_role} and {lead_role}:

> *"Update audit complete. §00XX records the session. Accepted: N; rejected: K; deferred: J. File changes committed in one structured commit."*

Commit the entire update's changes in **one commit** (§0017):

```
§00XX: update audit — accepted A, rejected B, deferred C

Accepted:
  - §00YY: <descriptor>

File-level changes:
  - Moved agents/ → @{unit_name}/
  - Updated lead/AGENTS.md (sections 2-4)
  - Archived docs/old-process.md

Rejected:
  - <descriptor> — <reason>

Deferred:
  - <descriptor> — <revisit trigger>

See §00XX audit ADR for full reasoning.
```

Rationale: multiple small commits per change would make `:silcrow-update` slow and noisy. The audit ADR preserves the granular reasoning; the git log stays clean.
