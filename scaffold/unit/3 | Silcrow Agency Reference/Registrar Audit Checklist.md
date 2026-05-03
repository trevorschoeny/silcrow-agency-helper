# Registrar — audit checklist

Read this file **when you're invoked to audit the record** (by User, Lead, or via the `:silcrow-update` skill). Don't load it preemptively in other sessions — the core audit stance and categories are in `../Registrar @ {unit_name}/AGENTS.md`; this file is the detailed walk-through for active audit sessions.

---

## A. Form

- [ ] Every accepted ADR uses one of the templates in `@ {unit_name}/1 | Canon/_templates/`.
- [ ] All required sections are present per template.
- [ ] Why-statement is present on full MADR ADRs and contains all six elements (context, problem, chosen option, alternatives rejected, desired outcome, tradeoff, underlying reason).
- [ ] Status field correctly matches the ADR's folder (`accepted` in `accepted/`, `superseded-by-§NNNN` in `superseded/`, `rejected` in `rejected/`).
- [ ] Filename follows `§NNNN | Title in Title Case.md`.
- [ ] Filename §-number matches the `# §NNNN | Title` heading line.

## B. §-numbering

- [ ] Numbers are monotonic (no gaps from reused numbers).
- [ ] No duplicates across `accepted/`, `superseded/`, `rejected/`.
- [ ] §-number is four-digit zero-padded.

## C. Citation integrity

- [ ] Every `Supersedes:` §-number resolves to a file in `superseded/`.
- [ ] Every `Superseded by:` §-number resolves to a file in `accepted/`.
- [ ] Every `Influenced by:` §-number resolves to a file somewhere in the ADR tree.
- [ ] Every `Influences:` §-number resolves.
- [ ] Bidirectional integrity: if §A's `Influences` lists §B, §B's `Influenced by` should list §A (and vice versa).
- [ ] Every relative path citation in an ADR body actually exists at that path.

## D. Contradictions

- [ ] No two accepted ADRs contradict each other on the merits. (Substantive — surface to {lead_role}.)

## E. Staleness

- [ ] No accepted ADR references artifacts that no longer exist.
- [ ] No accepted ADR's premise has been clearly falsified by subsequent events. (Substantive — surface.)

## F. Orphans

- [ ] Flag ADRs with empty `Influences` AND empty `Influenced by` fields. Not necessarily wrong, but worth noting.

## G. Scope (§0017)

- [ ] Every accepted ADR falls within this unit's scope as stated in §0017 (or the current scope ADR). Scope violations — surface to {user_role}.
- [ ] In agencies with multiple units: a unit's ADRs don't exceed that unit's scope or any ancestor unit's scope. (Each unit's ADRs are bound by every ancestor unit's ADRs, up to and including the root's.)

## H. Federation (§0012)

- [ ] No ancestor unit's ADR attempts to adjudicate matters that should be local to a descendant unit.
- [ ] No unit's ADR attempts to set policy for a peer or cousin unit (one outside its own subtree).

## I. Unsafe references (§0011)

For every reference from an ADR to an operational artifact:

- [ ] Delete test — if the referenced file vanished, does the ADR still carry its decision?
- [ ] Contradiction test — if the referenced file contradicted the ADR, does the ADR still hold?

If *no* to either, flag as unsafe and surface to {lead_role}.

## J. Unit↔ADR consistency (§0012)

- [ ] Every `@ <Unit Name>/` directory has a registering ADR in the parent's `@ <Parent Unit Name>/1 | Canon/accepted/`.
- [ ] Every unit-establishing ADR has a corresponding `@ <Unit Name>/` directory with its own `@ <Unit Name>/`.

Flag orphans (unregistered units or unexecuted ADRs) to {lead_role}.

## K. Git hygiene — informational only

- [ ] Uncommitted changes inside `@ {unit_name}/` (governance work).
- [ ] Unpushed governance commits (if a remote is configured).

Report as informational; never blocking. Operational git hygiene is outside your scope.

## L. Inbox discipline — informational

Per §0005's "reading is moving" rule, an agent's `inbox/` should hold only unread or in-flight messages; everything else belongs in `inbox/archive/`. Stale messages in the inbox suggest the discipline is slipping.

- [ ] Walk every agent's `inbox/` (not `inbox/archive/`) under `@ {unit_name}/<Role> @ {unit_name}/inbox/`.
- [ ] Flag any message file with a deposit date older than ~24 hours that's still in `inbox/` (not yet archived).
- [ ] For each flagged file, name the agent and the filename in the audit report.

Report as informational. The flag prompts the relevant agent (or {user_role}) to either archive the message (if it was already read and acted on) or follow the deferred-response pattern (archive + draft a "received, will respond by {date}" reply per `./Message Protocol.md` §5). You don't move other agents' messages on their behalf — the discipline of moving belongs to the recipient.

---

## Audit report structure

After working through the checklist, send one report to appropriate inboxes:

```
Audit report — YYYY-MM-DD

PROCEDURAL CORRECTIONS MADE (direct fixes)
  [P1] Fixed broken citation in §0034 Influences → §0042 (was pointing at §0041).
  [P2] Moved §0042 from proposed/ to accepted/; it had been approved in a past message but never filed.

SUBSTANTIVE ISSUES FOR {lead_role}
  [L1] §0088 cites plans/cache-refactor.md as load-bearing — unsafe reference
       per §0011. Recommend rewrite to embed decision content.

SUBSTANTIVE ISSUES FOR {user_role}
  [U1] §0101 establishes a practice ("we only take enterprise clients")
       that appears to exceed current agency scope (§0017). Scope clarification needed.

INFORMATIONAL
  [I1] 2 uncommitted governance files; 1 unpushed governance commit.
  [I2] 4 ADRs have no Influences/Influenced-by links (orphans).
```
