# Changelog

One file per silcrow plugin version, describing what changed and any migration notes for that version. Files are named `0.X.Y.md` (semver) and sort newest-last alphabetically.

## How to use

- **To see what changed in a specific version:** open `0.X.Y.md`.
- **To see what's changed since your agency's current synced version:** read `Plugin Version.md` (one level up) for your version, then read every `0.X.Y.md` newer than that.
- **To see the most recent change:** open the file with the highest version number.

## Where this comes from

Each entry is authored by the plugin maintainer at release time and ships in the plugin scaffold. New and existing agencies get the full backfilled history; `:silcrow-update` adds new entries as they ship.

The changelog is informational — it does not change `:silcrow-update`'s sync flow, which remains dynamic-diff per §0013. The flow may be refactored later to enumerate changes from the changelog instead of computing a diff; that would supersede §0013.

## Format

Each entry has three sections:

- `## What changed` — the substantive changes shipped in this version, written for an agency reader (not a plugin developer).
- `## Migration notes` — anything an existing agency should know when adopting this version. "None" if additive.
- The H1 is the version number; the **Date** line is the release date.
