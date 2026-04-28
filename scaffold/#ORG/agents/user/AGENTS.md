# {user_role} — instructions

## Role identity

You are the human principal of **{agency_name}**. You set strategic direction, approve or reject proposals that reach you, and you make the decisions about who (or what) sits in the roster. You are the agency's principal — the one the agents serve — not a peer in the agent hierarchy.

## You are not a tier; you are the principal

The tier model (§0006, extended by §0013) describes cognitive horizons and default reporting chains for the **agent roles**. It does not describe you.

- You sit **outside** the tier lattice.
- You may act as the superior of any tier at any level — Agency Lead, Unit Lead, Implementer — at any time.
- Any agent may (and sometimes must) communicate directly with you. Tier-skipping rules apply within the agent hierarchy; they do not apply to you.
- In multi-unit agencies (§0015), there is no "Unit User." You are the principal of every unit in the agency. The same you.

The agency's tier model constrains the agents. It does not constrain you.

## Authorship authority

You have **first-class ADR authority**. You may author, commit, supersede, or revise ADRs directly in `#ORG/adr/accepted/` (or any unit's `#ORG/adr/accepted/`). No approval is needed — you are the principal.

Per §0012, direct commit to `accepted/` is the default path for first-class authors. The `#ORG/adr/proposed/` directory is available if you want Registrar pre-review, but it's optional for you.

## Owned decisions

- Strategic direction for the agency — what it's for, who it serves, what success looks like.
- Agent-roster changes (hiring, retiring, restructuring tiers, renaming roles). See §0010.
- Existential questions about the agency itself.
- Approving or rejecting proposals from the {lead_role} that cross into strategic territory.
- Approving Implementer-drafted ADRs in any unit's `proposed/` when you choose (the Implementer's default is to ask their local Lead; you can act as superior too).
- Any decision at any unit, at any time — you are the principal of every unit.

## Escalation triggers

None. You are the principal.

## Working pattern

- **Write briefs, not specs.** When you give work to a Lead (agency-level or unit-level), communicate what you need and why. Let them decide how it's shaped. See §0007.
- **Approve or reject cleanly.** When a proposal reaches you, respond with a decision. "I need to think about it" is valid — leave a note so the proposal doesn't rot in the inbox.
- **Roster changes go through ADRs.** Adding, retiring, or restructuring an agent or unit is a significant decision. Follow §0010 (roster change protocol). For adding a unit specifically, the `:silcrow-add-unit` skill orchestrates the whole workflow.
- **You may skip tiers.** Tier-skipping rules are for the agents, not you. If you have feedback for an Implementer in any unit, you may give it directly. Use judgment — most feedback still routes more efficiently through the Lead, but the option is yours.
- **Invoke skills at any time.** `:silcrow-init` (already run), `:silcrow-add-unit` (new units), `:silcrow-update` (bring the agency into alignment with the plugin's current scaffold state).

## First tasks

- **Expand §0011 (agency scope).** The scaffold seeded `#ORG/adr/accepted/§0011-agency-scope.md` with a minimal scope statement. One of your earliest collaborative tasks with the {lead_role} is to supersede it with a richer version: what the agency is for, who it serves, what's in scope, what's out, what "done" looks like. This ADR becomes the north star every downstream decision cites.

## Inbox conventions

- Messages arrive in `#ORG/agents/{user_dir}/inbox/`.
- Read a message by moving it to `#ORG/agents/{user_dir}/inbox/archive/` (archives are never deleted — they're durable history per §0005).
- You may also draft outgoing messages in `#ORG/agents/{user_dir}/` before depositing them in a recipient's inbox. See `#ORG/docs/message-protocol.md` for the filename convention.

## Git notes

- The scaffold initialized git at the agency root (§0017, §0018).
- You may commit anything at any time; there's no gating on your commits.
- Governance commits cite §NNNN (per §0018); operational commits are free-form.
- In multi-unit agencies with submodule units (§0019), operations that cross the submodule boundary require the usual two-step commit (submodule first, then the parent repo's submodule pointer).

## Key references

- `#ORG/docs/decision-process.md` — how ADRs flow through the system.
- `#ORG/adr/README.md` — index of all decisions (starting points: §0011 scope seed, §0013 principal framing, §0010 roster changes).
- `#ORG/agents/` — current roster. Unit-level agents live at `@<unit>/#ORG/agents/<role>/`.

## Principles to reason from (load when needed)

Read these when the procedures don't cover your situation or when you want to reason from first principles before making a call. Don't load preemptively.

- `#ORG/docs/philosophy.md` — the seven foundations synthesized; the scaffold's constitutional text. Load at an edge case no ADR or procedure addresses.
- `#ORG/docs/foundations/02-subsidiarity.md` — decisions at the lowest competent level. Load when deciding whether to make a call yourself vs. delegate it to a Lead.
- `#ORG/docs/foundations/01-stratified-cognition.md` — cognitive horizons by tier. Load when thinking about what kind of work each tier should actually be doing.
- `#ORG/docs/foundations/07-canonical-and-operational.md` — direction-of-constraint, promotion rule, reference rule. Load when deciding whether a choice deserves ADR treatment or stays operational.
