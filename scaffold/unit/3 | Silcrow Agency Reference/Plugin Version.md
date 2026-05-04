# Plugin version

**Currently synced with:** silcrow at commit `{plugin_version}`
**Sync date:** {date}

This file records the silcrow plugin commit this agency is currently in sync with. It is updated by `:silcrow-update` after each successful audit and update session.

## Why commit SHAs, not version numbers

The silcrow plugin uses commit-SHA-based versioning — `plugin.json` has no `version` field, so the Claude Code plugin cache invalidates on every commit automatically. Each commit IS the version, from the harness's perspective.

This agency tracks the SHA precisely. The User doesn't need to know specific commits — they just run `:silcrow-update` and the Registrar handles syncing.

## How to see what's changed

The agency's `./changelog/` directory has one entry per "named release" — meaningful change set, with a descriptive summary and any migration notes. Filenames use semver-style labels (e.g., `0.28.0.md`) for human-readable navigation, but those names are bookkeeping aids, not pins in `plugin.json`.

To see what's pending for this agency:

1. Note the sync date above.
2. Read every entry in `./changelog/` newer than that date (entries are typically appended in version-name order, so the highest-named entries are the most recent).

Or just ask the Registrar — when running `:silcrow-update`, they enumerate what's changed as part of the workflow.

## How to update

Run `:silcrow-update` from the agency's root Registrar session (per §0009, only the root Registrar runs this skill). The Registrar:

1. Resolves the plugin's current source path.
2. Diffs the agency against the plugin's current canonical state (root + every sub-unit).
3. Presents proposed changes for User and Lead approval.
4. Executes approved changes.
5. Authors an audit ADR (§0013).
6. Commits per §0015.
7. Updates this file: writes the new commit SHA and sync date.

`:silcrow-update`'s sync flow is dynamic-diff per §0013 — it doesn't rely on this version field for its own logic. The SHA and date here are informational, useful for humans (and future audits) to see "where this agency stands."

## File discipline

- This file is **mutable** — it changes every time `:silcrow-update` completes a successful sync.
- It lives in `3 | Silcrow Agency Reference/` (mutable reference space) rather than as an ADR (which would be immutable per §0004).
- The Registrar updates it directly during the `:silcrow-update` workflow; no supersession needed.
