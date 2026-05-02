# §0010 — Roster change protocol

- **Status:** accepted
- **Date:** {date}
- **Authors:** scaffold initialization (inherited via §0001)
- **Supersedes:** —
- **Superseded by:** —
- **Influences:** every future roster change.
- **Influenced by:** §0001, §0004, §0006

## Context and problem statement

**Inherited decision.** This is a founding constitutional decision inherited from the Silcrow plugin via §0001 at project initialization. The reasoning and alternatives are preserved here so it can be evaluated or superseded on its own merits through the normal ADR lifecycle.

§0006 establishes the initial tier model and roster. Subsequent changes to that roster — adding a new agent, retiring an existing one, renaming a role — are significant architectural decisions that require governance. This ADR records the procedure that governs them, and the rule that each individual change is itself an ADR.

## Considered options

1. **Prose in a README catalog.** A `agents/README.md` file holds the roster table and the change procedure; both are mutably edited when the roster changes.
2. **Procedure as an ADR, changes as individual ADRs (chosen).** The procedure is recorded here; each addition, retirement, or rename is its own future ADR. The roster is derivable from accepted ADRs plus the directory tree.
3. **Informal / ad hoc.** No formal governance; agents are added and removed by whoever has access, roster drift is unrecorded.
4. **Supersede §0006 on every change.** Every roster change supersedes the tier-model ADR, producing a full re-review of the structure each time.

## Decision outcome

**Chosen option: (2) Procedure as an ADR; individual changes as individual ADRs.**

The reasoning parallels §0004 (immutability) and §0003 (§-numbering): when the record is load-bearing, every significant change must be observable in the record itself, not in an editable catalog. A mutable table drifts; an ADR stream is an auditable trail with dates, authors, and reasoning preserved.

Individual roster changes — add an agent, retire an agent, rename a role — each get their own ADR following the standard lifecycle. The **initial** roster does not need per-agent ADRs: it is covered in aggregate by §0006. This bounds Day-1 overhead while ensuring every change after Day 1 is first-class.

### The procedure

1. **Draft.** {user_role} or the {lead_role} drafts an ADR proposing the change. `madr-minimal.md` is usually sufficient; use `madr-full.md` when the change is non-trivial (new tier, multiple agents at once, role rename that cascades through prose and cross-references).
2. **Submit.** The draft is moved to `proposed/` and a message is sent to the Registrar announcing the submission.
3. **Validate.** The Registrar runs the standard validation checklist (see `../../registrar@{unit_name}/AGENTS.md`).
4. **Approve.** {user_role} approves (or rejects). Roster changes are tier-0 decisions — {user_role} owns the roster as a strategic/HR concern.
5. **Execute.** On acceptance, the Registrar:
   - Assigns the next §-number and files the ADR in `CANON@{unit_name}/accepted/`.
   - Performs any required directory-level actions:
     - **Add:** creates `agents/<role>/inbox/archive/` with a `.gitkeep`.
     - **Retire:** moves the retired agent's directory to `agents/_retired/<role>/` (creating `agents/_retired/` on first use). Inbox archives are preserved.
     - **Rename:** renames the directory to match the new role's `<role>` slug. Cross-references in prose are the change-author's responsibility; the Registrar verifies they resolve before accepting.
   - Updates bidirectional citations per the standard lifecycle.

### Consequences

- **Positive:** Every roster change has a dated, reasoned, citable record. "Why is Implementer-2 in the roster?" resolves to a specific ADR.
- **Positive:** No separate catalog to maintain or drift from the ADR record.
- **Positive:** The procedure itself is supersedable — if the project's governance evolves (e.g., {user_role} delegates implementer-level additions to {lead_role}), that's a clean supersession of this ADR.
- **Positive:** Retirement is never destructive. `agents/_retired/` preserves history.
- **Neutral:** Small, uncontentious changes (rename one role, add one peer {implementer_role}) take an extra minute to write as an ADR. This is what the discipline is for; the cost is bounded.
- **Negative:** Agents used to casually editing a roster table may experience friction. This is the discipline working as intended.

## References

- `../../REFERENCE@{unit_name}/foundations/02-subsidiarity.md` — why roster decisions belong at tier 0.
- `../../registrar@{unit_name}/AGENTS.md` — the validate/execute half of the procedure.
- `../_templates/madr-minimal.md` — the usual template for roster-change ADRs.
- `§0006` — the tier model this procedure operates within.
