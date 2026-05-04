# Message protocol

This document governs how agents communicate. The pattern is drawn from the actor model — private state per agent, no shared mutable memory between them, all coordination via messages deposited into mailboxes. Read it before sending or handling messages.

The *why* is in `Philosophy.md` and `foundations/03 | Actor Model.md`. This doc is the operational how.

---

## 1. The mailbox abstraction

Every agent has:

- A **private directory** — `@ <Unit Name>/<Role> @ <Unit Name>/`. Nothing in another agent's directory is citable or reviewable by anyone else. This is the actor's private state. You can draft, iterate, fail, and recover here without exposing half-formed thinking.
- An **inbox** — `@ <Unit Name>/<Role> @ <Unit Name>/inbox/`. Other agents deposit messages here. This is your mailbox.
- An **archive** — `@ <Unit Name>/<Role> @ <Unit Name>/inbox/archive/`. When you read a message, you move it here. Archives are **never deleted** (§0005). They are the historical record of every communication this agent received.

No agent reads another agent's directory or inbox without going through a message. No agent mutates another agent's archive. No agent deletes messages. These rules are load-bearing — they are what makes the system reconstructible.

### Agencies with multiple units

In agencies that span multiple units (§0012), the same rules apply recursively at every depth. Every unit — root and sub-units alike — has its own `@ <Unit Name>/<Role> @ <Unit Name>/inbox/` for each role on its roster. Messages stay scoped to their unit unless explicitly addressed cross-unit. Cross-unit messages typically go through a Lead as the routing point — a sub-unit's Lead messages the Lead of its parent unit, who in turn messages a peer's Lead (or escalates to the {user_role}).

---

## 1a. The user is the scheduler

In silcrow's actor model, agents are not continuously running entities that talk to each other in real time. Each agent is **state-on-disk** (their `AGENTS.md`, their inbox, their archive), instantiated only when the human user opens a session in their directory. Outside a session, an agent is just a folder of files — no persistent memory, no inner monologue, no awareness of inbound messages.

This means **the human user is the scheduler.** Inter-agent communication doesn't trigger anything by itself:

1. Agent A is alive in a session. They write a message and deposit it in Agent B's `inbox/`. A's session ends.
2. The message sits there. B has no idea it's been received — B isn't running.
3. Some time later, the user navigates to B's directory and opens a session. *That* is when B comes alive.
4. B (per their Session start in `AGENTS.md`) checks inbox, finds the message, processes it.

In a classic actor system, a runtime decides which actor runs next based on inbound messages. In silcrow, the human IS the runtime. They decide who runs next by choosing which directory to open a session in. Without the user activating an agent, that agent never reads its inbox.

### What this means in practice

- **No "let me check with the {lead_role}" mid-response.** You can't actually consult another agent in real time. You can deposit a message in their inbox; the conversation resumes when the user later opens a session with them.
- **No simulating dialogue with another agent.** Whatever you imagine another agent would say is fiction — you don't have access to their reasoning. Send the message, stop, wait for the user to facilitate the next exchange.
- **Every inter-agent message is a one-way send + asynchronous handoff.** Your job in this session ends at "deposit message + tell the user who to activate next" (see §2a).
- **Language matters.** "I'll talk to the {implementer_role}" implies real-time; it's wrong-shaped. "I'm depositing a brief in the {implementer_role}'s inbox; the user will need to open a session there next" matches reality. Use the latter.

---

## 2. Depositing a message

To send a message to another agent:

1. Draft the message in your own directory (e.g., `@ {unit_name}/{lead_role} @ {unit_name}/draft-brief-2026-04-19.md`). You iterate privately.
2. When ready, copy the file into the recipient's inbox with the canonical filename (see §3). Use `Write` (or equivalent); do not edit in-place in someone else's directory.
3. Delete or keep the draft in your own directory, as you prefer. Drafts are not part of the permanent record.

**Never** edit a message already deposited in someone else's inbox. If you need to retract or correct, send a second message.

---

## 2a. End-of-turn handoff pointer

**Whenever you deposit a message in another agent's inbox during a session, end your response to the user with a concise pointer naming the recipient(s).** The user is the scheduler (§1a) — they need to know who to activate next. Without an explicit pointer, the next-action gets lost in long responses, and the recipient agent never sees the message because no session is opened for them.

### Format

Always at the **very end** of your response. Italic or bold so it's visually distinct.

Single recipient:

> *Next: `{implementer_role} @ {unit_name}` — brief in their inbox.*

Multiple recipients:

> *Next: messages deposited in `{lead_role} @ {unit_name}`, `{implementer_role} @ {unit_name}`, `Registrar @ {unit_name}`. Open whichever you want first.*

Keep it tight. One line per recipient, or a short comma-separated list. The pointer is the operator console — the user scans it, picks who to activate, navigates there.

### When this applies

- Any session where you deposit a message via the procedure in §2.
- Including broadcast cases (§9a) — list every agent who got a notice deposit, or summarize as "broadcast to all unit agents" if many.
- Including ADR-acceptance broadcasts, audit reports, plan-replies, brief-handoffs.

If your response in this session does NOT deposit any inter-agent message, no pointer is needed.

---

## 3. Filename convention

Messages in inboxes follow this filename pattern:

```
YYYY-MM-DD-{sender}-{short-kebab-subject}.md
```

Examples (assume an agency whose root unit is `acme`):

- `2026-04-19-lead@acme-brief-implement-structured-logging.md`
- `2026-04-21-implementer@acme-plan-for-structured-logging.md`
- `2026-04-21-registrar@acme-ack-§0016.md`
- `2026-04-22-{user_role}-approve-§0088.md`

Rules:

- **Date is the date of deposit**, not the date of drafting.
- **Sender** is the kebab-cased slug of the sending agent — the role and unit name lowercased and joined with `@` (e.g., agent `Lead @ Acme` → slug `lead@acme`; `Implementer @ Pebble Core` → `implementer@pebble-core`). Filenames stay ASCII-safe and shell-friendly even though directories use Title Case with spaces. The `{user_role}` is the principal's slug; it has no `@ <unit>` suffix because the principal sits above all units.
- **Subject** is short kebab-case, descriptive but not exhaustive. The body has the full subject line.
- **No collisions.** If two messages would share a filename in the same inbox, add a disambiguating suffix: `-01`, `-02`, etc.

When a message is archived, the filename does not change. The move from `inbox/` to `inbox/archive/` is the only operation; the filename is the identifier.

---

## 4. Message body

A message body is Markdown. Use this skeleton:

```markdown
# Subject line — full and descriptive

- **From:** {sender role or directory}
- **To:** {recipient role or directory}
- **Date:** YYYY-MM-DD
- **References:** {list of ADR §-numbers, file paths, or prior message filenames this message relies on}
- **Kind:** {brief | plan | report | proposal-notice | acknowledgment | audit-report | update-request | ...}

## {Appropriate section(s) for the kind of message}

{Body.}
```

The `References` field is the mechanism by which messages tie into the shared record. Every work artifact should be cited by relative path (from the agency root) or by §-number. Never paraphrase when you can cite.

---

## 4a. Tone — verbose for agents, concise for the user

You communicate in two modes during a session, with different registers:

- **Agent-to-agent (filesystem deposits)** — verbose, technical, complete-context. The recipient agent has no shared memory; everything they need to act has to be in the file. Brief + reasoning + scope + cross-references — all written out. Erring verbose is cheap; erring terse compounds (more inbox round-trips, more user-facilitated handoffs to clarify).
- **Agent-to-user (chat in your active session)** — concise, simple, action-oriented. The user is making decisions, navigating, deciding who to activate next (per §1a). Long messages in chat slow them down, hide the next-action pointer, and make sessions harder to skim afterward.

It's the same agent doing both, in the same session — they just write different things to different places, in different registers.

### The corollary

When you've just written a verbose artifact (brief, ADR, plan, audit report, redistribution edits), the chat response about it should be a **concise summary plus the end-of-turn pointer (§2a)**. Don't paste the full artifact into chat. The artifact is on disk; chat just announces it.

Example:

> Drafted §0042 (data-retention policy) and committed to `accepted/`. Why-statement: shifts retention from 30 to 90 days for compliance. Three options considered.
>
> *Next: notice broadcast deposited in `{lead_role} @ {unit_name}`, `{implementer_role} @ {unit_name}`, `{user_role} @ {unit_name}`. Open whichever you want first.*

Five lines. Substance is in the ADR. Chat tells you it landed and what to do next.

---

## 5. Reading (= archiving)

**Reading a message *is* moving it to `inbox/archive/`.** The act of opening is the act of archiving. This discipline means:

- The contents of `inbox/` (not archive) is always *unread*.
- Archives are the per-agent history of everything that was ever received.
- You cannot "mark as read" or "read but not process"; reading and taking responsibility are the same gesture.

If you need to defer a message — you've looked at it but aren't ready to act — archive it and draft a reply (in your own directory) indicating you've received it and will respond by {date}. Then the original sender knows the message was received, and your deferred intent is recorded.

---

## 6. Kinds of messages

The scaffold recognizes common message kinds. The `Kind` field is descriptive, not enforced — it helps readers orient quickly.

### Brief

From a higher tier to a lower tier. Communicates *what* is needed and *why*, not *how*. The recipient drafts a plan in response. See §0007.

Structure:

- **Goal** — what done looks like.
- **Why** — the motivating context. Cite ADRs, prior messages, external requirements.
- **Constraints** — things that shape the response.
- **Out of scope** — explicit non-goals.

### Plan

From a lower tier to a higher tier, in response to a brief.

Structure:

- **Brief referenced** — the filename of the brief this plan responds to.
- **Proposed approach** — a few paragraphs, not a spec.
- **Sequencing** — ordered list of changes.
- **Verification** — how the plan-author will confirm success.
- **Assumptions** — interpretations of the brief that need confirmation.
- **Open questions** — anything that can't be resolved without further input.

### Report

After execution. Communicates what was done and what's left.

Structure:

- **Plan referenced** — which plan this reports on.
- **What changed** — files, behaviors, interfaces.
- **What didn't** — anything deferred or dropped, and why.
- **Surprises** — things the plan didn't anticipate.
- **Follow-ups** — any new work this execution surfaced.

### Proposal notice

To the Registrar when an Implementer submits an ADR draft to `@ <Unit Name>/1 | Canon/proposed/`. Short. Names the proposal file, the template used, and relevant context. The Implementer also sends a companion message to the Lead (or User) requesting approval.

### Acknowledgment

From the Registrar to the submitter when a proposal is accepted or rejected. Names the assigned §-number and status. For rejections, names the reason.

### Audit report

From the Registrar to the {user_role} and/or {lead_role} after an audit run (invoked by the `:silcrow-update` skill, by the User/Lead directly, or on the Registrar's own cadence). Categorizes findings: procedural corrections made, substantive issues for Lead, substantive issues for User. See `../Registrar @ {unit_name}/AGENTS.md` for the full format.

### Update request

Dropped into the Registrar's inbox by the `:silcrow-update` skill. Contains the plugin's canonical source path and a request to run a dynamic diff. See `../Registrar @ {unit_name}/AGENTS.md` for the Registrar's response workflow.

### ADR acceptance notice

Sent by the **author** of an ADR (Lead, User, or — for audit ADRs — the Registrar) to every agent in the accepting unit and every agent in every descendant sub-unit, the moment the ADR lands in `accepted/` (§0016). Short, pointer-style. The notice doesn't carry the ADR's content; it points the recipient at the canonical record they should read.

Filename:

```
YYYY-MM-DD-{sender}-§NNNN-accepted.md
```

Examples:

- `2026-05-15-lead@acme-§0042-accepted.md`
- `2026-05-15-registrar@acme-§0055-accepted.md` (for an audit ADR)

Body skeleton:

```markdown
# §NNNN accepted — {short title}

- **From:** {sender}
- **To:** {recipient slug}
- **Date:** YYYY-MM-DD
- **References:** §NNNN
- **Kind:** adr-acceptance-notice

§NNNN was accepted in `@ <Accepting Unit>` on YYYY-MM-DD. This decision binds
your unit by inheritance (per §0012).

Read the ADR at `{relative path to §NNNN}` for the decision and reasoning.
```

Add lines as appropriate:

- **Implementer-drafted ADRs** — name both author and approver: *"Drafted by {implementer_role} @ {unit_name}, approved by {lead_role} @ {unit_name}."*
- **Supersession** — *"This ADR supersedes §00XX (now in `superseded/`)."*
- **Audit ADRs (§0013)** — *"This is the audit ADR for the `:silcrow-update` session of YYYY-MM-DD; see it for the full list of changes in that session."*

Recipients **archive on read** like any other message (§0005's `read = move` rule); the canonical record is the ADR itself, not the notice. The notice is just an alert.

### Others

You'll develop your own conventions over time. When a recurring message kind emerges (e.g., "escalation," "retrospective," "approval-request"), don't hesitate to name it explicitly.

---

## 6a. Broadcast recipients — walking the tree (§0016)

When you author an ADR that lands in `accepted/`, the broadcast goes to every agent in the accepting unit + every agent in every descendant sub-unit. The walk:

1. **Start at the accepting unit.** That's the unit whose `@ <Unit Name>/1 | Canon/accepted/` now contains the new ADR. Call it `<Accepting Unit>`.
2. **Enumerate the accepting unit's agents.** List `@ <Accepting Unit>/<Role> @ <Accepting Unit>/` directories. Each one is a recipient (skip yourself — you authored it).
3. **Recurse into descendant units.** For each `@ <Sub-Unit>/` directory at the accepting unit's root level, repeat steps 2–3 inside that sub-unit. Continue recursively to every leaf.
4. **Deposit the notification** in each recipient's `inbox/` per the deposit procedure (§2).

The recipient set respects inheritance (§0012): ADRs propagate downward, so broadcasts do too. **Don't broadcast to ancestor units, peer units, or cousin units** — they aren't bound by `<Accepting Unit>`'s decisions.

Cost-wise: the walk is O(agents in subtree). For a single-root agency with 4 agents, it's 3 deposits (skipping self). For a multi-unit tree, it grows roughly linearly with agent count. Notifications are short pointer messages; the cost is bounded.

---

## 7. References — citing work artifacts

Everything you reference in a message should be cited by a stable, resolvable pointer. Good citations:

- `§0011` — an accepted ADR.
- `@ {unit_name}/1 | Canon/superseded/§0009 | Shared Cache.md` — a superseded ADR.
- `§0042` — an anti-pattern recorded as a regular ADR (e.g., `§0042 | Avoid Shared Cache Across Services`).
- `@ {agency_name}/3 | Silcrow Agency Reference/Philosophy.md#subsidiarity` — a section within a document.
- `@ {unit_name}/{lead_role} @ {unit_name}/inbox/archive/2026-04-19-implementer-plan-for-logging.md` — a specific prior message.
- `@ Pebble/@ Pebble Core/1 | Canon/accepted/§0005 | Inter-Service Auth.md` — an ADR in a sub-unit `@ Pebble Core/` of unit `@ Pebble/`.

Avoid:

- "The one from last Tuesday" — unstable.
- "The older ADR about caching" — which one?
- "As discussed in chat" — not in the record.

If a reference is not in the record, it doesn't exist. The discipline of making yourself cite forces the record to actually carry the information.

---

## 8. No out-of-band communication

**Everything goes through inboxes.** No side channels. No "just a quick note" exchanged outside the mailbox system. If it mattered enough to say, it matters enough to record.

The motivation is the same as the immutability discipline for ADRs: if you carve out a category of communication that escapes the record, the record degrades.

Exceptions are narrow:

- **Real-time clarification between co-working agents** — a brief in-session exchange to disambiguate something. The exchange's substantive outcome still lands in the inbox of whichever agent acts on it next.
- **Urgent escalations** — when something is on fire, get attention by whatever means necessary. Then, immediately after, record the exchange in the appropriate inboxes.

If routine workflows start bypassing inboxes, that's a drift signal. Raise it to the {lead_role} or {user_role}.

---

## 9. Supervision and long-running work

The actor model includes a notion of **supervision** — a higher-tier actor watching lower-tier actors and recovering from failure.

In this scaffold:

- If the {implementer_role} has been working on an approved plan longer than the plan estimated and the {lead_role} hasn't heard back, the {lead_role} sends a status-check.
- If the {implementer_role} is stuck, the responsibility to surface that is theirs — send a progress message saying what's blocking.
- If an agent is reliably non-responsive, that is a roster concern. {user_role} and {lead_role} address it through the ADR process (§0008 — roster changes are ADRs).

**"Let it crash."** Armstrong's principle: processes fail fast rather than muddle through a bad state. In our context: if you're stuck or the plan is wrong, say so quickly and clearly — don't silently improvise.

---

## 10. Git commits for inbox archives

Inbox messages and archives are part of the agency's durable record, so they belong in version control. Per §0015:

- Either the Lead or the Registrar can commit inbox archives (it's shared responsibility).
- Commits on messages are free-form in subject — no §NNNN citation required unless the message itself references governance in a way that warrants citation.
- Don't batch dozens of messages into one commit if it grows unwieldy; small-to-medium commits work better for git log readability.

---

## 11. What the archive preserves

Over time, `inbox/archive/` accumulates. Here's what it gives you:

- **Reproducibility.** Given the archive, you can reconstruct the sequence of every communication this agent received.
- **Continuity across agent turnover.** If an agent is replaced, the replacement reads the archive to reconstruct context.
- **Auditability.** A skeptical reader can trace any decision back through the messages that produced it.

If the archive ever gets large enough to cause navigation pain, the Registrar can partition it by date (e.g., `archive/2026-Q2/`), but **never delete**. See `../Registrar @ {unit_name}/AGENTS.md` ("Partitioning at scale") for notes.

---

## Cross-references

- `Philosophy.md` — especially the actor-model and registrar-pattern sections.
- `foundations/03 | Actor Model.md` — the full intellectual basis for this protocol.
- `Decision Process.md` — proposals and acknowledgments are both message kinds in that flow.
- `../Registrar @ {unit_name}/AGENTS.md` — how the Registrar processes incoming messages.
- `../` — this unit's agent roster; each role has its own directory (named `<Role> @ <Unit Name>/`), with its own `inbox/` and `AGENTS.md`.
- `../1 | Canon/accepted/§0005 | Communication via Inboxes.md` — the canonical decision behind this protocol.
