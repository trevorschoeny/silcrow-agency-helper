# {user_role} — instructions

## Role identity

You are the human principal of **{agency_name}** — the agency as a whole tree, root unit and all sub-units. You set strategic direction, approve or reject proposals that reach you, and you make the decisions about who (or what) sits in the roster. You are the agency's principal — the one the agents serve — not a peer in the agent hierarchy.

## You are not a tier; you are the principal

The tier model (§0006, extended by §0012) describes cognitive horizons and default reporting chains for the **agent roles**. It does not describe you.

- You sit **outside** the tier lattice.
- You may act as the superior of any agent at any tier in any unit at any time — the Lead of the root unit, the Lead of any sub-unit, any Implementer at any depth.
- Any agent may (and sometimes must) communicate directly with you. Tier-skipping rules apply within the agent hierarchy; they do not apply to you.
- There is no "Unit User." There is one of you, and you are the principal of every unit in the agency. The same you.

The agency's tier model constrains the agents. It does not constrain you.

## Authorship authority

You have **first-class ADR authority**. You may author, commit, supersede, or revise ADRs directly in any unit's `@{agency_dir}/CANON@{agency_dir}/accepted/`. No approval is needed — you are the principal.

Per §0011, direct commit to `accepted/` is the default path for first-class authors. The `@{agency_dir}/CANON@{agency_dir}/proposed/` directory is available if you want Registrar pre-review, but it's optional for you.

## Broadcast on ADR acceptance (§0019)

When you author an ADR that lands in `accepted/`, you broadcast a short notification to every agent in the accepting unit and every agent in every descendant sub-unit. The principle is the same one Lead and Registrar follow: the actor-model record (§0005) is the channel through which bound agents become aware of decisions that bind them.

The mechanics are in `@{agency_dir}/REFERENCE@{agency_dir}/message-protocol.md` §6 and §6a — message kind `adr-acceptance-notice`, filename convention, body skeleton, and the recipient-walk algorithm.

You may also delegate the mechanical broadcast to Registrar @ {agency_dir} as a courtesy if you'd rather not handle the file deposits yourself; in that case, message the Registrar with the §-number and ADR path and ask them to broadcast on your behalf. The substantive responsibility (you authored it) stays yours; the file moves are theirs.

## Owned decisions

- Strategic direction for the agency — what it's for, who it serves, what success looks like.
- Agent-roster changes (hiring, retiring, restructuring tiers, renaming roles). See §0010.
- Existential questions about the agency itself.
- Approving or rejecting proposals from any Lead that cross into strategic territory.
- Approving Implementer-drafted ADRs in any unit's `proposed/` when you choose (the Implementer's default is to ask their local Lead; you can act as superior too).
- Any decision in any unit at any time — you are the principal of every unit in the tree.

## Escalation triggers

None. You are the principal.

## Working pattern

- **Write briefs, not specs.** When you give work to a Lead — whether at the root unit or a sub-unit — communicate what you need and why. Let them decide how it's shaped. See §0007.
- **Approve or reject cleanly.** When a proposal reaches you, respond with a decision. "I need to think about it" is valid — leave a note so the proposal doesn't rot in the inbox.
- **Roster changes go through ADRs.** Adding, retiring, or restructuring an agent or unit is a significant decision. Follow §0010 (roster change protocol). For adding a unit specifically, the `:silcrow-add-unit` skill orchestrates the whole workflow.
- **You may skip tiers and units.** Tier-skipping rules are for the agents, not you. If you have feedback for an Implementer in any unit, you may give it directly. Use judgment — most feedback still routes more efficiently through the local Lead, but the option is yours.
- **Invoke skills at any time.** `:silcrow-init` (already run), `:silcrow-add-unit` (new units), `:silcrow-update` (bring the agency into alignment with the plugin's current scaffold state).

## First tasks

- **Supersede §0020 (agency scope) — don't edit it.** The scaffold seeded `@{agency_dir}/CANON@{agency_dir}/accepted/§0020-agency-scope.md` with a minimal scope statement. One of your earliest collaborative tasks with {lead_role} @ {agency_name} is to *supersede* §0020 (per §0004) with a richer version: what the agency is for, who it serves, what's in scope, what's out, what "done" looks like. The seed lives at the end of the founding set deliberately — it's positioned to be the next ADR you author against, your first lesson in the supersession discipline that governs every binding decision in this agency. Author a new ADR with `Supersedes: §0020` in its header; the Lead or Registrar handles the file move from `accepted/` to `superseded/`. The new ADR becomes the north star every downstream decision cites.

## Inbox conventions

**Mailbox paths.** Messages arrive in `@{agency_dir}/{user_dir}@{agency_dir}/inbox/`; once read, they live in `@{agency_dir}/{user_dir}@{agency_dir}/inbox/archive/` (never deleted — §0005).

**Always check at turn start.** Before processing your own next action — every turn, every session — list `inbox/` and read whatever's new. ADR-acceptance notices from your Leads, audit reports from Registrars, drafts and briefs in flight, broadcasts from sub-unit Leads — anything addressed to you arrives here, and the principal benefits from staying current with what the agents are sending. Read and archive new messages per "Reading is moving" below before pushing forward on your own work.

**Reading is moving (§0005).** When you open a message, your *first* action — before responding or acting on it — is to move it from `inbox/` to `inbox/archive/`. The inbox represents only unread or in-flight items; archives hold the complete received history. If you've read but aren't ready to act, archive the message and draft a "received, will respond by {date}" reply per the deferred-response pattern in `@{agency_dir}/REFERENCE@{agency_dir}/message-protocol.md` §5.

**Substantial inputs you receive outside the inbox.** When you paste a report, drop in an image, attach a document, or otherwise hand substantial input directly to one of your agents (whether to a Lead, Implementer, or any other role) — instruct that agent to save it to their `inbox/archive/` with a dated, subject-tagged filename. The agents already carry this rule, but the principal noticing whether the practice is followed is part of how the discipline holds. The archive is the durable record of what shaped this agency's work; don't let pasted artifacts orphan it.

**Drafting outgoing messages.** Draft in `@{agency_dir}/{user_dir}@{agency_dir}/` before depositing in a recipient's inbox. See `@{agency_dir}/REFERENCE@{agency_dir}/message-protocol.md` for the filename convention.

## Git notes

- The scaffold initialized git at the agency root (§0016, §0017).
- You may commit anything at any time; there's no gating on your commits.
- Governance commits cite §NNNN (per §0017); operational commits are free-form.
- In agencies with submodule sub-units (§0018), operations that cross the submodule boundary require the usual two-step commit (submodule first, then the parent repo's submodule pointer).

## Key references

- `@{agency_dir}/REFERENCE@{agency_dir}/decision-process.md` — how ADRs flow through the system.
- `@{agency_dir}/CANON@{agency_dir}/README.md` — index of all decisions (starting points: §0020 scope seed, §0012 principal framing, §0010 roster changes).
- `@{agency_dir}/` — the root unit's roster. Sub-unit agents live at `@<sub-unit>/<role>@<sub-unit>/`, recursively at any depth (sub-units nest as siblings of the parent unit's agents).

## Principles to reason from (load when needed)

Read these when the procedures don't cover your situation or when you want to reason from first principles before making a call. Don't load preemptively.

- `@{agency_dir}/REFERENCE@{agency_dir}/philosophy.md` — the seven foundations synthesized; the scaffold's constitutional text. Load at an edge case no ADR or procedure addresses.
- `@{agency_dir}/REFERENCE@{agency_dir}/foundations/02-subsidiarity.md` — decisions at the lowest competent level. Load when deciding whether to make a call yourself vs. delegate it to a Lead.
- `@{agency_dir}/REFERENCE@{agency_dir}/foundations/01-stratified-cognition.md` — cognitive horizons by tier. Load when thinking about what kind of work each tier should actually be doing.
- `@{agency_dir}/REFERENCE@{agency_dir}/foundations/07-canonical-and-operational.md` — direction-of-constraint, promotion rule, reference rule. Load when deciding whether a choice deserves ADR treatment or stays operational.
