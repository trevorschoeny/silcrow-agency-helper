# Plugin version

**Currently synced with:** silcrow {plugin_version}

This file records which version of the silcrow plugin this agency is currently in sync with. It is updated by `:silcrow-update` after a successful audit and update session.

## How to read this

The version above tells you the silcrow plugin release whose canonical state matches this agency's current state — as of the last `:silcrow-update` run (or the agency's initial scaffold, if `:silcrow-update` has not been run yet).

## How to see what's changed since

Read the changelog at `./changelog/`. Each entry (`0.X.Y.md`) describes what changed in that version and any migration notes. To see what's pending for this agency:

1. Note the version above.
2. Read every `./changelog/0.X.Y.md` file with a higher version number.

## How to update

Run `:silcrow-update`. The Registrar diffs this agency against the plugin's current canonical state, presents proposed changes for approval, executes approved changes, and updates this file to reflect the version the agency just synced to.

`:silcrow-update`'s sync flow does not depend on this version field — the flow is dynamic-diff per §0013. The version here is informational, useful for humans and the Registrar to quickly orient on "where this agency stands."

## File discipline

- This file is **mutable** — it changes every time `:silcrow-update` completes a successful sync.
- It lives in `3 | Silcrow Agency Reference/` (mutable reference space) rather than as an ADR (which would be immutable per §0004).
- The Registrar updates it directly during `:silcrow-update` workflow; no supersession needed.
