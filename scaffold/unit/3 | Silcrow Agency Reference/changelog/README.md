# Changelog

One file per silcrow plugin "named release" — a meaningful change set with a descriptive summary and any migration notes. Files are named `0.X.Y.md` (semver-style) and sort newest-last alphabetically.

## Names are labels, not pins

The silcrow plugin uses commit-SHA-based versioning — `plugin.json` has no `version` field, so the Claude Code cache invalidates on every commit automatically. The semver-style names here (`0.27.0.md`, `0.28.0.md`, etc.) are **bookkeeping labels** for human readability, not pins anchored anywhere in the plugin.

When the maintainer ships a meaningful change set, they author a new entry under the next "logical version" name. The name is just a navigational aid; the canonical identifier for any given commit is the git SHA, recorded in `Plugin Version.md` after each `:silcrow-update`.

## How to use

- **To see what changed in a specific named release:** open `0.X.Y.md`.
- **To see what's changed since your agency's last sync:** check `Plugin Version.md` (one level up) for your sync date, then read every changelog entry dated newer than that.
- **To see the most recent change set:** open the file with the highest version-style name.

## Where this comes from

Each entry is authored by the plugin maintainer at the time of a meaningful change set, and ships in the plugin scaffold. New and existing agencies get the full backfilled history; `:silcrow-update` adds new entries as they ship.

The changelog is informational — it does not change `:silcrow-update`'s sync flow, which remains dynamic-diff per §0013. The flow may be refactored later to enumerate changes from the changelog instead of computing a diff; that would supersede §0013.

## Format

Each entry has three sections:

- `## What changed` — the substantive changes shipped in this release, written for an agency reader (not a plugin developer).
- `## Migration notes` — anything an existing agency should know when adopting this release. "None" if additive.
- The H1 is the version-style label; the **Date** line is the date of the change set.
