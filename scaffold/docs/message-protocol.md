# Message protocol

This document governs how agents communicate. The pattern is drawn from the actor model — private state per agent, no shared mutable memory between them, all coordination via messages deposited into mailboxes. Read it before sending or handling messages.

The *why* is in `philosophy.md` and `foundations/03-actor-model.md`. This doc is the operational how.

---

## 1. The mailbox abstraction

Every agent has:

- A **private directory** — `agents/{role}/`. Nothing in another agent's directory is citable or reviewable by anyone else. This is the actor's private state. You can draft, iterate, fail, and recover here without exposing half-formed thinking.
- An **inbox** — `agents/{role}/inbox/`. Other agents deposit messages here. This is your mailbox.
- An **archive** — `agents/{role}/inbox/archive/`. When you read a message, you move it here. Archives are **never deleted**. They are the historical record of every communication this agent received.

No agent reads another agent's directory or inbox without going through a message. No agent mutates another agent's archive. No agent deletes messages. These rules are load-bearing — they are what makes the system reconstructible.

---

## 2. Depositing a message

To send a message to another agent:

1. Draft the message in your own directory (e.g., `agents/{lead_dir}/draft-brief-2026-04-19.md`). You iterate privately.
2. When ready, copy the file into the recipient's inbox with the canonical filename (see §3). Use `Write` (or equivalent); do not edit in-place in someone else's directory.
3. Delete or keep the draft in your own directory, as you prefer. Drafts are not part of the permanent record.

**Never** edit a message already deposited in someone else's inbox. If you need to retract or correct, send a second message.

---

## 3. Filename convention

Messages in inboxes follow this filename pattern:

```
YYYY-MM-DD-{sender}-{short-kebab-subject}.md
```

Examples:

- `2026-04-19-lead-brief-implement-structured-logging.md`
- `2026-04-21-implementer-plan-for-structured-logging.md`
- `2026-04-21-registrar-ack-§0014.md`
- `2026-04-22-user-approve-§0088.md`

Rules:

- **Date is the date of deposit**, not the date of drafting.
- **Sender** is the directory name of the sending agent (e.g., `lead`, `implementer`, `registrar`, `{user_dir}`).
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
- **Kind:** {brief | plan | report | proposal-notice | acknowledgment | ...}

## {Appropriate section(s) for the kind of message}

{Body.}
```

The `References` field is the mechanism by which messages tie into the shared record. Every work artifact should be cited by relative path (from the project root) or by §-number. Never paraphrase when you can cite.

---

## 5. Reading (= archiving)

**Reading a message *is* moving it to `inbox/archive/`.** The act of opening is the act of archiving. This discipline means:

- The contents of `inbox/` (not archive) is always *unread*.
- Archives are the per-agent history of everything that was ever received.
- You cannot "mark as read" or "read but not process"; reading and taking responsibility are the same gesture.

If you need to defer a message — you've looked at it but aren't ready to act — archive it and draft a reply (in your own directory) indicating you've received it and will respond by {date}. Then the original sender knows the message was received, and your deferred intent is recorded.

---

## 6. Kinds of messages

The scaffold recognizes a handful of common message kinds. Others can be added as the project grows. The `Kind` field is descriptive, not enforced — it helps readers orient quickly.

### Brief

From a higher tier to a lower tier. Communicates *what* is needed and *why*, not *how*. The recipient drafts a plan in response.

Structure:

- **Goal** — what done looks like.
- **Why** — the motivating context. Cite ADRs, prior messages, external requirements.
- **Constraints** — things that shape the response (timelines, dependencies, ADRs the plan must respect).
- **Out of scope** — explicit non-goals.

### Plan

From a lower tier to a higher tier, in response to a brief. Communicates *how* the recipient intends to accomplish the brief.

Structure:

- **Brief referenced** — the filename of the brief this plan responds to.
- **Proposed approach** — a few paragraphs, not a spec.
- **Sequencing** — ordered list of changes, in the order they'll happen.
- **Verification** — how the plan-author will confirm the work succeeded.
- **Assumptions** — any interpretations of the brief the author made and wants confirmed.
- **Open questions** — anything the author can't resolve without further input.

### Report

After execution. Communicates what was done, what didn't get done, and what the state of the work is now.

Structure:

- **Plan referenced** — which plan this reports on.
- **What changed** — files, behaviors, interfaces.
- **What didn't** — anything deferred or dropped, and why.
- **Surprises** — things the plan didn't anticipate.
- **Follow-ups** — any new work this execution surfaced.

### Proposal notice

To the Registrar when an ADR is submitted to `../proposed/`. Short. Names the proposal file, the template used, and any relevant context (e.g., "this supersedes §0014").

### Acknowledgment

From the Registrar to the submitter when a proposal is accepted or rejected. Names the assigned §-number and status. For rejections, names the reason.

### Others

You'll develop your own conventions over time. When a recurring message kind emerges (e.g., "sync notice," "escalation," "retrospective"), don't hesitate to name it explicitly.

---

## 7. References — citing work artifacts

Everything you reference in a message should be cited by a stable, resolvable pointer. Good citations:

- `§0014` — an accepted ADR.
- `adr/superseded/§0012-shared-cache.md` — a superseded ADR (by path, since its number alone doesn't say where).
- `ap-007` — a standalone anti-pattern record.
- `docs/philosophy.md#subsidiarity` — a section within a document.
- `agents/{lead_dir}/inbox/archive/2026-04-19-implementer-plan-for-logging.md` — a specific prior message.

Avoid:

- "The one from last Tuesday" — unstable.
- "The older ADR about caching" — which one?
- "As discussed in chat" — not in the record.

If a reference is not in the record, it doesn't exist. The discipline of making yourself cite forces the record to actually carry the information.

---

## 8. No out-of-band communication

**Everything goes through inboxes.** No side channels. No "just a quick note" exchanged outside the mailbox system. If it mattered enough to say, it matters enough to record.

The motivation is the same as the immutability discipline for ADRs: if you carve out a category of communication that escapes the record, the record degrades. Over time, the important context lives in the side channel and the record becomes a decorative artifact.

Exceptions are narrow and well-defined:

- **Real-time clarification between co-working agents** — a brief in-session exchange to disambiguate something. The exchange's substantive outcome still lands in the inbox of whichever agent acts on it next.
- **Urgent escalations** — when something is genuinely on fire, get attention by whatever means necessary. Then, immediately after, record the exchange in the appropriate inboxes.

If you find yourself building routine workflows that don't touch inboxes, that's a drift signal. Raise it to the {lead_role} or {user_role}.

---

## 9. Supervision and long-running work

The actor model includes a notion of **supervision** — a higher-tier actor watching lower-tier actors and recovering from failure. In Erlang, this is the supervision tree (Armstrong, 2003).

In this scaffold, supervision is lighter-touch but follows the same shape:

- If the {implementer_role} has been working on an approved plan for longer than the plan estimated, and the {lead_role} hasn't heard back, the {lead_role} sends a status-check message.
- If the {implementer_role} is stuck, the responsibility to surface that is theirs — they send a progress message saying what's blocking and what they need.
- If an agent is reliably non-responsive, that is a roster concern. The {user_role} and {lead_role} address it through the ADR process (roster changes are ADRs — see `../agents/README.md`).

**"Let it crash."** Armstrong's principle for Erlang was that processes should fail fast rather than try to muddle through a bad state. In our context: if you're stuck or the plan is wrong, say so quickly and clearly — don't silently improvise. The supervision above assumes fast, honest signaling.

---

## 10. What the archive preserves

Over time, `inbox/archive/` accumulates. Here's what it gives you:

- **Reproducibility.** Given the archive, you can reconstruct the sequence of every communication this agent received and, inferentially, what they did in response.
- **Continuity across agent turnover.** If an agent is replaced, the replacement reads the archive to reconstruct context.
- **Auditability.** A skeptical reader can trace any decision back through the messages that produced it.

If the archive ever gets large enough to cause navigation pain, the Registrar can partition it by date (e.g., `archive/2026-Q2/`), but **never delete**. See `registrar-playbook.md` for partitioning notes.

---

## Cross-references

- `philosophy.md` — especially the actor-model and registrar-pattern sections.
- `foundations/03-actor-model.md` — the full intellectual basis for this protocol.
- `decision-process.md` — proposals and acknowledgments are both message kinds in that flow.
- `registrar-playbook.md` — how the Registrar processes incoming messages.
- `../agents/README.md` — the roster that defines who has an inbox.
