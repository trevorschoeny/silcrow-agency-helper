# §0005 — Inter-agent communication via inboxes; no out-of-band channels

- **Status:** accepted
- **Date:** {date}
- **Authors:** scaffold initialization (inherited via §0001)
- **Supersedes:** —
- **Superseded by:** —
- **Influences:** all future agent-coordination work.
- **Influenced by:** §0001

## Context and problem statement

**Inherited decision.** This is a founding constitutional decision inherited from the Silcrow plugin via §0001 at project initialization. The reasoning and alternatives are preserved here so it can be evaluated or superseded on its own merits through the normal ADR lifecycle.

Agents need to coordinate. The mechanism for that coordination determines whether the project's history is auditable and whether agents can turn over without losing context. The choice of coordination mechanism is load-bearing — once made, it shapes every subsequent interaction.

## Considered options

1. **Inbox + archive per agent (chosen).** Each agent has `inbox/` and `inbox/archive/`. Messages deposited as files; read-means-move-to-archive. Actor-model discipline (Hewitt 1973; Armstrong 2003).
2. **Shared chat channel.** A common channel (Slack, Discord, similar) for all communication. Real-time, searchable.
3. **Email.** Traditional message queuing. Threaded, archivable, widely-supported.
4. **Meetings / verbal.** Real-time synchronous discussion; outcomes written up after.

## Decision outcome

**Chosen option: (1) Inbox + archive per agent.**

The actor model is a 50-year-old discipline for coordinating independent entities without shared mutable state. Its core rule — private state per actor, messages as the only shared artifact — is exactly what gives a multi-agent system durable history. Each message, once deposited, is a persistent file. Each archive, once an agent has read a message, is a complete record of that agent's received history. Given the archives, an outside reader can reconstruct every interaction the system ever had. That property does not hold for any of the alternatives.

Option (2) — shared chat — optimizes for immediacy but produces auditability that depends on whoever is running the chat platform retaining messages forever and on readers being able to reconstruct per-agent context from a shared stream. In practice, shared chat platforms turn over, retention windows lapse, and per-agent history becomes unreconstructible.

Option (3) — email — is closer in shape (messages in mailboxes) but fails the archive-preservation discipline: emails get deleted, archived to inaccessible systems, or lost to account changes. The discipline of "never delete; everything is a first-class artifact in the repo" is the differentiator.

Option (4) — meetings — fails catastrophically on history. Post-hoc write-ups capture outcomes but lose the reasoning, and their fidelity depends on the write-up discipline, which varies. Meetings may supplement inbox communication in specific circumstances but cannot replace it.

### Consequences

- **Positive:** Every inter-agent interaction is a persistent, auditable file in the repo.
- **Positive:** Agents can turn over; successors read the archive to reconstruct context.
- **Positive:** No reliance on external tooling retention.
- **Negative:** Slower than real-time chat for casual exchange.
- **Negative:** The discipline requires enforcement — agents trained in chat-first coordination will find inbox messaging awkward at first.
- **Neutral:** Narrow, well-defined exceptions exist (see `../../REFERENCE@{unit_name}/message-protocol.md` §8) for genuine real-time clarification and for urgent escalations; these must be recorded afterward.

## References

- `../../REFERENCE@{unit_name}/foundations/03-actor-model.md` — full intellectual history and citations.
- `../../REFERENCE@{unit_name}/message-protocol.md` — operational rules.
- Hewitt, C., Bishop, P., Steiger, R. (1973). "A Universal Modular ACTOR Formalism for Artificial Intelligence."
- Armstrong, J. (2003). *Making Reliable Distributed Systems in the Presence of Software Errors*. KTH.
