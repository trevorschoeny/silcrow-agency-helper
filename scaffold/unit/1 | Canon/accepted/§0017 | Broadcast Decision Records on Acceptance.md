# §0017 | Decision-record acceptance is broadcast to every bound agent

- **Status:** accepted
- **Date:** {date}
- **Authors:** scaffold initialization (inherited via §0001)
- **Supersedes:** —
- **Superseded by:** —
- **Influences:** every ADR acceptance event from this point forward; the Registrar's audit-ADR workflow (§0014); the Implementer's draft-with-approval flow (§0011); every agent's awareness of binding decisions.
- **Influenced by:** §0001, §0005, §0010, §0011, §0013, §0014

## Why-statement

In the context of **an agency where ADRs are authored across multiple units and at any time during a session**,
facing the gap that an accepted ADR sits in the record but bound agents have no automatic signal that a binding decision was made,
we decided for **broadcasting an inbox notification on every ADR acceptance** — the author of the ADR (Lead direct-commits, Lead approving an Implementer draft, User direct authoring, or Registrar authoring an audit ADR) sends a short pointer-style message to every agent in the accepting unit and every descendant sub-unit, citing the ADR by §-number and path —
and neglected putting notices in agent instruction files (AGENTS.md edits), centralizing broadcasts on the Registrar (which would re-introduce sync gatekeeping the §0010 audit pattern moved away from), and leaving agents to check the record on demand (which produces the very awareness drift this ADR closes),
to achieve real-time decision-propagation along the inheritance edges of the unit tree, without bottlenecking the Registrar and without a special-case `:silcrow-update`-only notification path,
accepting that inboxes will accumulate notification volume over time (mitigated by short, pointer-style messages and the `read = move` discipline from §0005),
because the actor-model record (§0005) is the canonical channel for "things addressed to you," and broadcasting through it generalizes update notifications, supersession notifications, and any other awareness-propagation need into one mechanism instead of carving exceptions.

## Context and problem statement

§0010 established the Registrar as an async auditor — they no longer gatekeep every commit before it lands in `accepted/`. Lead direct-commits per §0010's first-class authority. Implementer drafts go through Lead approval per §0011. The User authors directly per their principal role. Audit ADRs are authored by the Registrar per §0014.

This works for the canonical record. But it leaves a gap in *awareness*: an ADR can land in `accepted/` and bind every agent in its subtree without any of those agents knowing until they happen to check.

The gap matters most for:
- **Cross-session changes.** An agent's session ended yesterday; today they start a new session not knowing five new ADRs were accepted overnight.
- **Sub-unit awareness.** A Lead at the agency root authors an ADR that binds @product, @mobile, @platform — none of those Leads know unless they read the parent's `@ <parent>/1 | Canon/accepted/` periodically.
- **Update audits.** `:silcrow-update` produces an audit ADR plus possibly several new/superseded ADRs. None of the agents touched by those changes know until they look.

The naïve fix — "agents should check the record" — doesn't compose well: it's an active poll instead of a passive receive, and it scales badly across many ADRs and many agents.

## Decision drivers

- **The actor model (§0005) is already the channel.** Inbox messages are how things get to agents. Broadcasting acceptance through the same channel doesn't introduce a new mechanism.
- **Author knows what their ADR means and to whom.** The natural party to compose the broadcast is the one who wrote the decision.
- **Don't re-bottleneck the Registrar.** §0010 deliberately moved Registrar out of every-commit. Centralizing broadcasts on Registrar would back-door that gatekeeping.
- **Inheritance shapes recipient set.** ADRs at unit X bind X + descendants (§0013). Broadcast scope mirrors authority scope.
- **One mechanism, not many.** Update audits are a special case of "ADR accepted" — let them flow through the same broadcast path.

## Considered options

1. **Author broadcasts on acceptance (chosen).** The agent who authored the ADR (or in Implementer-drafted cases, the agent who approved it) sends a short notification to every agent in the unit + descendants.
2. **Registrar broadcasts on every acceptance.** Rejected: re-introduces sync gatekeeping the §0010 audit pattern moved away from. Registrar would have to be in the loop for every commit.
3. **AGENTS.md notice (transient appended block, deleted after agent reads).** Rejected: introduces a special-case mechanism for what the inbox channel already does, and editing instruction files for transient state cuts against the canon/operational discipline (§0012).
4. **No broadcast — agents poll the record on their own cadence.** Rejected: produces the very awareness drift this ADR closes.
5. **Batch digest (e.g., daily Registrar email of all changes).** Rejected: latency between acceptance and awareness, and aggregating loses the per-ADR pointer that makes the message actionable.

## Decision outcome

**Chosen option: (1) Author broadcasts on acceptance.**

### The rule

When an ADR lands in `accepted/`, the author broadcasts a notification to every agent in the accepting unit + every agent in every descendant sub-unit, walking down the tree.

### Author identity per acceptance pathway

| Pathway | Author of record | Broadcaster |
|---|---|---|
| Lead direct-commits to `accepted/` (§0010) | Lead | Lead |
| Implementer drafts to `proposed/`; Lead approves; Registrar (or Lead) moves to `accepted/` | Implementer drafted, Lead approved | Lead — they exercised the authoring authority |
| User direct-commits | User | User (or asks the Registrar to do it as a courtesy) |
| Registrar authors an audit ADR (§0014) | Registrar | Registrar |
| `:silcrow-add-unit` writes an establishing ADR | Lead or User (whoever ran the skill) | The same Lead or User |
| Registrar makes a procedural correction (§0010 hybrid authority) | n/a — the original author stands | No broadcast — procedural corrections aren't acceptance events |
| ADR moved to `rejected/` | n/a | No broadcast — existing acknowledgment to drafter is sufficient |

### Recipient set

Walk down the tree from the accepting unit. For every unit at or below (sub-units, sub-sub-units, recursively), drop the message in every agent's inbox at `@ <unit>/<Role> @ <unit>/inbox/`. Skip the broadcaster themselves.

ADRs propagate downward along inheritance edges (§0013), not up or sideways. Don't broadcast to ancestor units, peer units, or cousin units — they aren't bound by this ADR.

### Message format

A new `Kind: adr-acceptance-notice` for the message protocol (§0005). Operational details — filename, body skeleton, recipient-walk algorithm — live in the agency's `@ <root-unit>/3 | Silcrow Agency Reference/Message Protocol.md`. The message is short, pointer-style: title, brief context, link to the ADR, supersession note if applicable.

### Implementer-drafted ADRs name both author and approver

When the Lead broadcasts an ADR drafted by the Implementer, the broadcast names both: *"drafted by {implementer_role} @ {unit_name}, approved by {lead_role} @ {unit_name}."* This honors the §0011 authoring split (the writing is the Implementer's; the authority is the Lead's).

### Self-bootstrapping

This ADR establishes the rule that ADRs broadcast on acceptance. Agent template instructions executed at scaffold init carry the rule from Day 1; the rule isn't dependent on §0017's own acceptance to take effect. §0017 is the canonical record of the rule; the AGENTS.md instructions are the operational expression. The first ADR an agency authors after init (typically the §0018 supersession that replaces the agency-scope seed) is the first concrete demonstration of the broadcast.

### Consequences

- **Positive:** Agents have real-time awareness of decisions that bind them.
- **Positive:** Update audits (`:silcrow-update`) require no special notification machinery — their audit ADRs broadcast like any other.
- **Positive:** Registrar's role stays async. Authors carry their own broadcast load.
- **Positive:** Inheritance scope (§0013) and broadcast scope are the same — the rule is intuitive: "decisions go where they bind."
- **Positive:** The §0018 supersession ceremony — the agency's first ADR action — broadcasts naturally, reinforcing the discipline by demonstration.
- **Negative:** Inboxes accumulate notification volume over time. In active agencies, this could be many messages per agent per year. Mitigation: notifications are short pointers, fast to read+archive; the audit checklist's section L flags stale inboxes.
- **Negative:** Authors carry a small additional procedural step on every acceptance.
- **Neutral:** Existing message kinds (brief, plan, report, proposal-notice, acknowledgment, audit-report, update-request) are joined by `adr-acceptance-notice`. The protocol gracefully extends.

## Anti-patterns surfaced

- **Skipping the broadcast because "everyone will check eventually."** Defeats the rule. The whole point is that bound agents shouldn't have to poll.
- **Broadcasting to ancestors or peers.** Inheritance is downward; broadcasts follow inheritance. An ADR in @product doesn't bind @acme; @acme's agents shouldn't receive it.
- **Registrar broadcasting on the author's behalf as a routine.** That re-creates sync gatekeeping. The Registrar broadcasts only their own audit ADRs (§0014) and only as a courtesy if asked for User-authored ADRs.
- **Aggregating multiple acceptances into one digest message.** Per-ADR messages give recipients the actionable pointer. Aggregation hides the citations.
- **Treating acceptance broadcasts as optional.** They're not. The rule is part of the authorship workflow itself.

## Review trigger

Reconsider this ADR if:
- Inbox volume from broadcasts becomes a measurable drag on agent focus (signal would be stale-inbox flags accumulating in audits).
- A pattern emerges where some classes of ADRs genuinely don't need broadcasting (suggests a refinement carving out the exception).
- Cross-agency interaction patterns produce broadcast needs the current downward-only rule doesn't cover (note: cross-agency interaction is collaborative-not-hierarchical per §0013; broadcasts inside one agency stay scoped to that agency's tree regardless).

## References

- `§0005` — inter-agent communication via inboxes; the channel this ADR uses.
- `§0010` — Registrar as async auditor; the principle this ADR preserves by making authors broadcast.
- `§0011` — User as principal; local tier numbering; Implementer drafts-with-approval; defines the authoring split that determines who broadcasts.
- `§0013` — agency and unit structure; defines the inheritance edges along which broadcasts propagate.
- `§0014` — update audits produce per-session audit ADRs; audit ADRs broadcast like any other ADR per this rule.
- `§0018` — agency scope (seed); the supersession that replaces it is the first concrete broadcast.
- `../../3 | Silcrow Agency Reference/Message Protocol.md` — the operational details: filename convention, body skeleton, recipient-walk algorithm.
