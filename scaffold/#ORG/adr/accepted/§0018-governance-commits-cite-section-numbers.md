# §0018 — Governance commits cite the governing §NNNN; operational commits are free-form

- **Status:** accepted
- **Date:** {date}
- **Authors:** scaffold initialization (inherited via §0001)
- **Supersedes:** —
- **Superseded by:** —
- **Influences:** every commit message inside `#ORG/`; the git-log navigability of governance history.
- **Influenced by:** §0001, §0003, §0014, §0017

## Y-statement

In the context of **an agency whose governance lives in version control alongside operational work**,
facing the tension between commit-log discipline (valuable for governance traceability) and commit-log freedom (valuable for whatever the unit is actually producing),
we decided for **a two-tier convention split along the canon/operational line** — governance-touching commits cite the governing §NNNN (`§0014: add canon/operational foundation doc` or `Move agents/ → #ORG/agents/ (per §0014)`); operational commits are free-form —
and neglected imposing §NNNN citations on all commits, requiring no convention at all, and enforcing the convention via pre-commit hooks,
to achieve `git log --grep='§0014'` as "everything that happened because of §0014" while letting operational commits match whatever style the work calls for,
accepting that the convention is followed by habit rather than enforced, and that some commits straddle governance and operational changes,
because the canon/operational split (§0014) implies different disciplines for different content, and reliable §NNNN traceability makes the governance record navigable in a way no amount of commit-log prose can replicate.

## Context and problem statement

The scaffold uses git for version control (per §0017's `.gitignore` decision) and treats the decision record as load-bearing. Those two facts interact at the commit-message level:

- A commit that adds `§0014` to `#ORG/adr/accepted/` is a governance event; future agents will want to search for "what happened with §0014?" and find every commit that implemented it.
- A commit that edits the codebase's product-roadmap.md is operational work with no governance bearing; imposing a §NNNN citation requirement on it would be noise.

Without a convention, `git log` becomes either over-formal (every commit cites something, losing signal) or un-navigable (nothing cites anything, losing traceability on the governance side).

## Decision drivers

- **Governance traceability.** Searching `git log --grep='§NNNN'` should surface every commit related to that ADR — its creation, its supersessions, any downstream implementation.
- **Operational freedom.** Commits on operational work should read naturally for whatever the work is. A scaffold that imposes a rigid format on every commit fails the "scaffold-agnosticism" principle.
- **Follow the canon/operational line.** The canonical/operational split (§0014) is the scaffold's organizing principle; commit discipline should respect it.
- **No enforcement overhead.** Hooks and linters are friction; the convention should be light enough to follow by habit.

## Considered options

1. **All commits cite §NNNN.**
2. **No convention.** All commits free-form.
3. **Two-tier split along canon/operational (chosen).**
4. **Pre-commit hook that enforces §NNNN on `#ORG/` paths.**

## Decision outcome

**Chosen option: (3).**

### The convention

- **Governance-touching commits** — any commit that creates, accepts, supersedes, or edits an ADR, agent instruction, foundation doc, or governance README — use the form `§NNNN: <short imperative>`.
  - When the commit *is* the ADR itself (e.g., creating §0014): `§0014: canon/operational split and reference rule`.
  - When the commit implements or follows from an ADR: `<change description> (per §NNNN)`. Example: `Move agents/ → #ORG/agents/ (per §0015)`.
  - When a commit touches multiple ADRs: list them. Example: `§0012, §0013: registrar and tier refinements`.
- **Operational commits** — anything outside `#ORG/`, or anything inside `#ORG/` that's purely mechanical with no ADR bearing (e.g., an inbox archive commit) — are free-form. The Lead names them however they want. The scaffold does not prescribe a format for operational work.
- **Update audits** — the `:update` skill's one-commit-per-invocation uses the form `§NNNN: update audit — accepted A, rejected B, deferred C` (with the audit ADR's §-number; see §0016).

### Enforcement: none

- No pre-commit hooks.
- No linters.
- No CI check.

The convention is documented (here) and followed by habit. The Registrar's advisory git role (§0012) may flag commits that appear to violate the convention, but only as informational — never as blocking.

### Rationale for no enforcement

Scaffold-agnosticism: the convention is already a soft guideline; adding enforcement would drag in per-agency configuration (what counts as "governance"? what should the hook reject? what's the override mechanism?). The enforcement layer would exceed the value of the convention for many use cases. Better to document and trust.

### Consequences

- **Positive:** `git log --grep='§0014'` reliably surfaces all §0014-related commits.
- **Positive:** Operational commits match the style of the work.
- **Positive:** No enforcement overhead; the convention is light to follow.
- **Positive:** Aligns with the canon/operational split (§0014).
- **Negative:** Some commits straddle governance and operational changes and need judgment on which form to use (typically: use the governance form if any `#ORG/` content is touched).
- **Negative:** Unenforced conventions drift over time; the Registrar's informational flagging is the only mitigation.
- **Neutral:** Implementers (who commit code) can work in whatever style their codebase uses; only when they touch governance do they reach for the citation form.

## Anti-patterns surfaced

- **Over-citing on operational commits.** `§0011: update product roadmap` when the update has no bearing on the scope ADR. Dilutes the citation's signal. Use citations when they mean something.
- **Missing citation on a supersession.** Superseding §0008 with §0012 is a governance-touching commit; the message must cite §0012 (creating) and §0008 (superseding). Without the citation, the supersession is invisible to `git log --grep='§0008'`.
- **Enforcing the convention via hooks.** Defeats scaffold-agnosticism. Keep the convention as a norm.
- **Mixed-concern commits that don't cite.** A commit that touches `#ORG/` and operational content at the same time should use the governance form and cite the relevant §NNNN. If no ADR applies, split the commit.

## Review trigger

Reconsider this ADR if:

- A pattern of commit-log unreadability emerges despite the convention (suggests enforcement is warranted after all, or the convention needs sharpening).
- A different governance-traceability mechanism becomes standard (e.g., a commit-trailers convention) and obviates the §NNNN-in-subject approach.
- Users report the convention is too fragile to follow by habit (suggests a lightweight check is warranted).

## References

- `../../agents/registrar/instructions.md` — the Registrar's git-advisory role includes informational flagging of convention violations.
- §0003 — §-numbering discipline that citations reference.
- §0012 — Registrar as async auditor; git-hygiene items are advisory.
- §0014 — canon/operational split that this convention mirrors.
- §0016 — `:update` audit commits use this convention.
- §0017 — `.gitignore` defaults; this ADR completes the initial git-convention set.
- §0019 — submodule decision; submodule commits follow this convention in the parent repo.
- Git documentation: commit-message conventions (there's no single standard, but this ADR aligns with the "type: subject" family of conventions by replacing "type" with the §-number).
