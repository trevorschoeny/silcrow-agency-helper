# §0017 — Agency default `.gitignore` — OS, editor, and secrets patterns only

- **Status:** accepted
- **Date:** {date}
- **Authors:** scaffold initialization (inherited via §0001)
- **Supersedes:** —
- **Superseded by:** —
- **Influences:** every agency's initial `.gitignore`; the discipline of what's tracked by default; how gitignore changes are governed.
- **Influenced by:** §0001, §0014

## Y-statement

In the context of **agencies that use git for version control and audit history** (§0018, §0019 continue this integration),
facing the question of what the scaffold's default `.gitignore` should exclude,
we decided for **a minimal default covering only OS noise, editor artifacts, and common secret-file patterns** — nothing operational is ignored by default —
and neglected a large preset of language-specific patterns (`node_modules/`, `target/`, `__pycache__/`, `.venv/`), gitignoring working folders by default, and shipping no `.gitignore` at all,
to achieve a tracked-by-default stance that makes inbox archives, plans, and operational material durable across machines, while keeping the default small enough that users rarely fight it,
accepting that users will add language-specific or artifact-specific patterns themselves when they need them,
because the scaffold supports agencies across many domains (coding, research, planning, business) and can't know in advance what "build artifacts" means in any given context, so the conservative default is to ignore only the truly-universal noise.

## Context and problem statement

The scaffold initializes git at agency creation (per the init flow) and writes a default `.gitignore`. That file sets the baseline for what is and isn't tracked. A poorly-chosen default has two failure modes:

- **Too aggressive.** Ignoring `node_modules/` is fine for a JavaScript project, but the scaffold might be used for a wedding-planner agency with no JS at all — the pattern is wasted noise. Worse, ignoring working directories by default might exclude material the user wanted tracked.
- **Too permissive (nothing ignored).** `.DS_Store` files from macOS and editor swap files from Vim or VS Code would commit to every repo by default, polluting the log for no value.

The right default is small enough to apply to every agency regardless of domain and broad enough to cover truly universal noise.

## Decision drivers

- **Scaffold-agnosticism.** Agencies can be coding projects, wedding-planning, research labs, homekeeping systems, small-business operations, family systems. The default must fit all of these.
- **Tracked-by-default for operational work.** Plans, briefs, inbox archives, research reports, working documents — all should be tracked unless the user explicitly excludes them. Durability depends on it.
- **Canonical content never ignored.** `#ORG/` is governance; nothing inside it should ever be in `.gitignore`. Audit history depends on this.
- **User extension is easy.** Whatever the default is, users should be able to add patterns trivially.
- **Governance changes flow through canon.** Additions that affect `#ORG/` tracking are governance decisions and need an ADR (see §0014 direction-of-constraint).

## Considered options

1. **No default `.gitignore`.** Ship nothing; user creates their own.
2. **Language-specific presets.** Ship a large preset covering common language build artifacts.
3. **Minimal default covering universal noise only (chosen).**
4. **Aggressive default including common working-folder patterns.**

## Decision outcome

**Chosen option: (3) Minimal default.**

### The default `.gitignore`

```
# OS
.DS_Store
Thumbs.db
.Spotlight-V100
.Trashes

# Editors
.vscode/
.idea/
*.swp
*.swo
*~

# Secrets (common patterns)
.env
.env.*
*.pem
*.key
credentials.json
```

Three sections:

1. **OS noise** — macOS `.DS_Store`, Windows `Thumbs.db`, macOS indexing/trash metadata. Universal regardless of domain; never useful in version control.
2. **Editor artifacts** — `.vscode/` and `.idea/` project folders, Vim swap files, temp backup files. The user's editor is a personal choice; those folders don't belong in shared history.
3. **Secrets** — `.env`, `.pem`, `.key`, `credentials.json`. Commonly carry API keys, tokens, or private cryptographic material. Committing them accidentally is a frequent and consequential mistake; a default ignore is cheap insurance.

**Nothing operational is ignored.** If the user's operational work should not be tracked (e.g., a large build artifact directory, `node_modules/`), they add that pattern themselves.

**Inbox archives are explicitly committed.** The whole inter-agent messaging pattern's durability depends on committed archives.

### Gitignore changes become ADRs when they touch governance

- **Governance-scope gitignore additions** — anything that affects what's tracked inside `#ORG/` (an unusual case; usually `#ORG/` contents should all be tracked). Requires an ADR proposed by the Registrar or Lead.
- **Operational-scope gitignore additions** — Lead's call; no ADR required. The Lead commits the `.gitignore` change like any other operational commit (per §0018, operational commits are free-form).
- **Initial default** — this ADR. Future changes to the default supersede this ADR.

### Consequences

- **Positive:** Safe default across every domain the scaffold serves.
- **Positive:** Operational work is tracked by default; durability follows.
- **Positive:** `#ORG/` contents are always tracked; audit history is never compromised by a stale `.gitignore`.
- **Positive:** Users add what they need without fighting the default.
- **Negative:** A JavaScript user still has to add `node_modules/` themselves on day one.
- **Negative:** The secret patterns are a best-effort safeguard, not a substitute for secret-scanning tooling. A user could still commit a secret at `api_token.txt` or some other non-matching path.
- **Neutral:** The default is intentionally short. Users who want a richer baseline copy one from elsewhere.

## Anti-patterns surfaced

- **Ignoring contents of `#ORG/`.** Violates the audit-history requirement. Every governance change must be committable.
- **Ignoring inbox archives.** Collapses the durability of inter-agent communication. Inbox archives must be tracked.
- **Adding language-specific patterns to this scaffold-shipped default.** This default should remain agnostic. If a particular language scaffold is warranted, it's a separate variant (future work), not an edit to this one.
- **Commit-by-accident of a secret.** The patterns here reduce the risk but don't eliminate it. Users who handle secrets should use additional secret-scanning tooling.

## Review trigger

Reconsider this ADR if:

- A class of agencies routinely adds the same pattern (e.g., if every scaffolded agency ends up with `node_modules/` or `.venv/`, the default might need a tier of presets).
- A new, widely-adopted editor introduces a project folder that becomes noise everywhere.
- A secret-file pattern becomes standard that this default doesn't cover.
- Tooling emerges that supersedes `.gitignore` as the primary exclusion mechanism.

## References

- `../../agents/registrar/instructions.md` — the Registrar's git-advisory role includes flagging uncommitted governance content.
- §0001 — founding scaffold decision.
- §0014 — canon/operational split; governance-scope gitignore changes are canonical.
- §0018 — commit message convention; operational commits are free-form.
- §0019 — submodule decision for independently-versioned units.
- Git documentation: `gitignore(5)` man page.
