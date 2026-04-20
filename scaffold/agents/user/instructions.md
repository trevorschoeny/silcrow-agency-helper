# {user_role} — instructions

## Role identity
You are the human owner of **{project_name}**. You set strategic direction, approve or reject proposals that reach you, and you make the HR-level decisions about who (or what) sits in the roster.

## Tier
**Tier 0.** You sit above the {lead_role} in the hierarchy and outside the workflow the other agents run between themselves. Your time horizon is strategic — months to years — and your attention is finite. The structure below you exists to protect that attention: most decisions are resolved at lower tiers and never reach you. When something does reach you, it's because it genuinely needed your judgment.

## Reports to / reports from
- **Reports to:** no one.
- **Reports from:** the {lead_role}. The Registrar may surface form-integrity concerns directly to you when the {lead_role} is the source of the inconsistency.

## Owned decisions
- Strategic direction for the project — what it's for, who it serves, what success looks like.
- Agent-roster changes (hiring, retiring, restructuring tiers, renaming roles).
- Existential questions about the organization itself.
- Approving or rejecting proposals from the {lead_role} that cross the threshold into strategic territory.

## Escalation triggers
None. You are the top.

## Working pattern
- **Write briefs, not specs.** When you give the {lead_role} work, communicate what you need and why. Let the {lead_role} decide how it's shaped.
- **Approve or reject — cleanly.** When a proposal reaches you, respond with a decision. "I need to think about it" is a valid response, but leave a note so the proposal doesn't rot in your inbox.
- **Roster changes go through ADRs.** Adding or retiring an agent is a significant decision. Follow §0010 (roster change protocol). The Registrar will help you file it correctly.
- **Don't skip tiers.** If you have feedback for the {implementer_role}, route it through the {lead_role}. Skipping tiers undermines the stratification the scaffold relies on.

## First tasks
- **Expand §0011 (project scope).** The scaffold seeded `adr/accepted/§0011-project-scope.md` with a minimal scope statement. One of your earliest collaborative tasks with the {lead_role} is to supersede it with a richer version: what the project is for, who it serves, what's in scope, what's out, what "done" looks like. This ADR becomes the north star every downstream decision cites.

## Inbox conventions
- Messages arrive in `agents/{user_dir}/inbox/`.
- Read a message by moving it to `agents/{user_dir}/inbox/archive/` (archives are never deleted).
- You may also draft outgoing messages in `agents/{user_dir}/` before depositing them in a recipient's inbox. See `docs/message-protocol.md` for the filename convention.

## Key references
- `docs/philosophy.md` — the intellectual foundation for why this structure works.
- `docs/decision-process.md` — how ADRs flow through the system.
- `docs/message-protocol.md` — how messages move between agents.
- `agents/` directories — current roster. Each agent's own `instructions.md` declares its reporting lines.
- `adr/accepted/§0010-roster-change-protocol.md` — the protocol for adding, renaming, or retiring agents (roster changes are your tier-0 concern).
- `adr/accepted/§0001-adopt-agent-org-scaffold.md` — the seed decision you implicitly approved by initializing this project.
- `adr/accepted/§0011-project-scope.md` — the project-scope seed ADR; expand it early via supersession.
