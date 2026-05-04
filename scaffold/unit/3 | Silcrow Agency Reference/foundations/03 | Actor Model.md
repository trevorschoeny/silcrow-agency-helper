# 03 | Actor model

## What the idea is

A system composed of **independent entities with private state, communicating only through messages**, becomes more robust than a system composed of components sharing memory. Each entity — an *actor* — has:

1. A **private mailbox** where incoming messages queue.
2. **Private state** no other actor can read or write directly.
3. The ability to **send messages** to other actors.

That is the whole model. Everything else — object-oriented programming, microservices, event-driven architectures, organizational structures that rely on written communication — is some specialization or adaptation of it.

The actor model matters in this scaffold because it gives a disciplined answer to a question that every multi-agent system faces: *how do you coordinate agents without producing either chaos or brittleness?*

## The intellectual history

### Origins (1973)

The actor model was introduced in:

**Hewitt, C., Bishop, P., & Steiger, R. (1973).** "A Universal Modular ACTOR Formalism for Artificial Intelligence." In *Proceedings of the Third International Joint Conference on Artificial Intelligence* (IJCAI-73), Stanford, August 20–23, pp. 235–245.

Carl Hewitt (1944–2022) and his MIT colleagues were trying to build a theoretical foundation for concurrent, distributed computation that didn't rely on shared memory. The prevailing approaches at the time — locks, semaphores, Dijkstra-style semaphore synchronization — were demonstrably error-prone at scale. Hewitt proposed that the fundamental unit of computation should be an *actor*: an autonomous entity that processes messages sequentially from its mailbox, maintains private state, and communicates only by sending further messages.

Three properties distinguished this model:

- **No shared memory.** Any two actors' states are inaccessible to each other.
- **Asynchronous messaging.** Sending a message does not block the sender; messages queue in the recipient's mailbox.
- **Local reasoning.** Because state is private, reasoning about an actor's behavior is local to its own code. No reasoning across address spaces is required.

### Formalization (1986)

**Agha, G. (1986).** *Actors: A Model of Concurrent Computation in Distributed Systems*. MIT Press.

Gul Agha's book, based on his 1985 MIT dissertation, gave the actor model a rigorous semantic foundation — a small operational calculus, proofs of expressiveness, and comparisons with other concurrency models (CSP, π-calculus). Agha's framing is the canonical one for computer-science treatments.

### Industrial validation (1986–present)

Actor-like disciplines appeared in several practical settings:

- **Smalltalk** (Alan Kay and colleagues, 1970s–80s). Kay described Smalltalk objects as "little computers communicating by messages" — a closer cousin to the actor model than the class-based OOP that followed. Kay later said publicly that "OOP to me means only messaging" — a nearly verbatim statement of actor-model principles.
- **Erlang** (Joe Armstrong, Robert Virding, Mike Williams, late 1980s at Ericsson). The most consequential industrial implementation. Erlang was built to run telecom switches with nine-nines uptime, and its actor-model design is the reason it could. Each telephone call is an actor; calls do not share state; failures are contained; supervisors restart failed actors.
- **Joe Armstrong's PhD thesis** (2003). *Making Reliable Distributed Systems in the Presence of Software Errors* (KTH Royal Institute of Technology, SICS technical report). Available at erlang.org/download/armstrong_thesis_2003.pdf. This is the best single document on *why* actor-model discipline produces robust systems and how specific design choices (process isolation, supervision trees, "let it crash") follow from the core model.
- **Akka** (Scala / JVM), **Elixir / OTP** (modern successor to Erlang), **Microsoft Orleans**, and others have adapted actor-model thinking into mainstream software over the last two decades.

### Armstrong's contributions

Joe Armstrong (1950–2019) deserves individual credit because his writing — particularly the 2003 thesis and the book *Programming Erlang* (Pragmatic Bookshelf, 2007) — is the most readable operational statement of actor discipline. Three specific contributions:

**Supervision trees.** Actors are organized into a tree where each node supervises its children. When a child fails, the supervisor's strategy (restart, escalate, terminate) decides what happens next. The supervision tree creates localized failure containment: a fault in one actor does not propagate to unrelated actors.

**"Let it crash."** Armstrong's famous principle. Rather than trying to handle every possible error inside an actor (which tends to produce brittle, defensive code that hides bugs), let the actor fail fast and cleanly when it encounters something it doesn't know how to handle. The supervisor recovers. This is counterintuitive but empirically validated: Erlang systems achieve very high availability precisely because their components crash cleanly and are restarted into known-good states.

**Nine nines.** Armstrong cites the Ericsson AXD301 telephone switch as achieving 99.9999999% uptime — roughly 31 milliseconds of downtime per year. This is the empirical benchmark against which actor-model claims are measured.

### Related models

- **CSP (Communicating Sequential Processes).** Tony Hoare's 1978 *Communications of the ACM* paper proposed a similar but distinct model: synchronous rendezvous instead of asynchronous mailboxes. Go's goroutines and channels are CSP-inspired.
- **π-calculus** (Milner, 1992). A more mathematical treatment of name-based communication. Theoretical kin to the actor model.
- **Event-driven architectures, microservices, message queues.** Modern distributed-system designs are actor-shaped whether or not their creators use the term. The discipline of "private state + messages + queues" shows up everywhere reliable distributed systems are built.

## Why this matters for the scaffold

The scaffold applies actor-model discipline to an *organization of agents*, not a program. The mapping is direct:

| Actor-model concept | Scaffold implementation |
|---|---|
| Actor | Agent (`@ <Unit Name>/<Role> @ <Unit Name>/`) |
| Private state | Agent's own directory |
| Mailbox | `@ <Unit Name>/<Role> @ <Unit Name>/inbox/` |
| Message history | `@ <Unit Name>/<Role> @ <Unit Name>/inbox/archive/` |
| Asynchronous message | File deposit into another agent's inbox |
| Shared ledger | The ADR tree (`@ <Unit Name>/1 | Canon/accepted/`, `@ <Unit Name>/1 | Canon/superseded/`, `@ <Unit Name>/1 | Canon/rejected/`) |
| Supervision | Higher-tier agent watching lower-tier work |
| "Let it crash" | Fast, honest signaling when stuck — don't silently muddle through |

Three operational consequences matter:

**Private directories enable honest thinking.** Drafts, half-formed ideas, exploratory notes live in an agent's own directory. No one reads them. The agent can iterate freely, fail, recover, and only surface finished thought through messages. This is the same discipline that makes actor-model reasoning tractable: you can reason about an actor's internals without worrying about others peeking in.

**Messages are first-class artifacts.** Because all coordination happens through messages, the system's history is literally the set of messages that passed between actors. The scaffold's inbox-archive discipline preserves this history: every message, once read, moves to archive; archives are never deleted. Given the archives alone, an outside reader can reconstruct every interaction the system ever had.

**The ADR tree is the shared ledger.** Actors don't share memory, but they need to agree on *something* — the outcomes of decisions. The ADR tree is the one shared mutable artifact in the scaffold, and its mutations are mediated by the Registrar (who, in actor-model terms, is the transaction coordinator for shared state). The Registrar's role exists because you need exactly one point of coordination for the shared ledger; otherwise you get write-write conflicts and a corrupted record.

## The silcrow twist: the human user is the scheduler

Classic actor systems include a runtime — a process that watches mailboxes, schedules which actor runs next when a message arrives, and ensures messages are processed. Erlang's BEAM does this; Akka's dispatcher does this; Orleans's silo does this.

**Silcrow does not have such a runtime.** Each agent is state-on-disk (their AGENTS.md, their inbox, their archive), instantiated only when the human user opens a session in their directory. Outside a session, an agent is just a folder of files — no process, no thread, no awareness of inbound messages.

This means **the human user is the runtime.** They decide which agent runs next by choosing which directory to open a session in. A message deposited in agent B's inbox triggers nothing automatically — it sits there until the user navigates to B's directory and starts a session.

The implications are operational:

- **Inter-agent messages are one-way sends, period.** The sender deposits and stops; the recipient processes whenever the user gets around to opening their session. There's no synchronous "wait for reply" because there's no runtime to give one.
- **The session-end discipline matters.** When you (as an agent in a session) deposit a message and need a response, you have to clearly hand off scheduling responsibility to the human. You stop your work; you tell the user explicitly who they need to activate next; you trust the discipline to bring the conversation back when the user opens that other agent's session. The "end-of-turn handoff pointer" rule (see `../Message Protocol.md` §2a) operationalizes this.
- **Real-time coordination is impossible in this model.** Agents can't "talk to" each other in any session. They can only deposit and stop. Anything else is simulating dialogue — which is fiction, since you don't actually have access to the other agent's reasoning.

This is a deliberate constraint, not a bug. The human-as-scheduler keeps the system inspectable (every coordination event is visible in the filesystem), durable (the user's sessions and the inbox archives together preserve everything), and tractable (no runtime to debug). The cost is that the human has to do more orchestration work than they would in a system with an automated runtime.

## Operational discipline

The actor model imposes several disciplines that are worth making explicit:

**Do not read other actors' private state.** No agent reads another agent's directory. If you need information from another agent, deposit a message in their inbox and stop — your session ends or you move to other work. The reply comes when the human user (the scheduler — see §"The silcrow twist" above) opens a session with that agent and they process and respond. Reading someone else's private draft is the organizational equivalent of a shared-memory race condition.

**Do not edit messages once sent.** A message deposited in another agent's inbox is no longer yours to change. If you need to correct, send a follow-up. Mutation of sent messages breaks the archival discipline that makes the system reconstructible.

**Signal failures quickly.** If you're stuck, say so. Don't silently improvise. The supervision pattern relies on failures being visible — hidden failures accumulate and produce worse outcomes downstream. Armstrong's "let it crash" applies: honest failure with a clear message beats a muddled success.

**Out-of-band communication is a discipline violation.** If you carve out a channel that doesn't deposit into inboxes, the archive degrades. Over time the important context lives in the side channel and the record becomes decorative. Exceptions are narrow and defined in `Message Protocol.md`.

## Common failure modes

**Shared state creep.** Agents start relying on something that isn't the ADR tree or their own directory — a shared scratch space, a mutable config file, an off-system chat log. This is the actor-model equivalent of mutable shared memory: it works in the short term and produces impossible-to-debug coordination failures at scale.

**Silent muddling.** An agent stuck on a task neither signals nor escalates; instead they keep working and produce half-done output under time pressure. Supervisors cannot recover from failures they can't see.

**Message editing.** An agent sends a message, then later decides it should have said something different, and edits the message in the recipient's inbox (if they have access). This destroys the archival discipline and makes the record unreliable. The correct operation is always: send a new message.

**Out-of-band drift.** The "quick word" mechanism accumulates. What started as occasional real-time clarification becomes a parallel channel where real decisions happen, and the inbox archive becomes ceremonial.

## Debates and open questions

- **Synchronous vs. asynchronous.** CSP-style synchronous channels (Go, Occam) have their own strong proponents. The scaffold uses asynchronous discipline because organizations don't usually benefit from forcing synchronization — most work is naturally queued.
- **How strictly to enforce no-shared-state.** Fully pure actor models forbid any shared state. Practical systems (including Erlang) allow shared read-only config or named registries. The scaffold's position: the ADR tree is the *only* shared mutable state; everything else private or per-agent.
- **Message ordering.** Actor models differ on whether messages from A to B must arrive in send-order. In the scaffold, the filesystem provides ordering; the filename's date prefix makes order observable.

## Further reading

- Hewitt, C., Bishop, P., & Steiger, R. (1973). The original IJCAI-73 paper. PDF at ijcai.org/Proceedings/73/Papers/027B.pdf.
- Agha, G. (1986). *Actors: A Model of Concurrent Computation in Distributed Systems*. MIT Press.
- Armstrong, J. (2003). *Making Reliable Distributed Systems in the Presence of Software Errors*. PhD thesis, KTH. PDF at erlang.org/download/armstrong_thesis_2003.pdf. Chapter 6 on error handling is particularly good.
- Armstrong, J. (2007). *Programming Erlang: Software for a Concurrent World*. Pragmatic Bookshelf.
- Hewitt's own later "Actor Model of Computation" paper (arXiv 1008.1459) gives the mature form.
- Alan Kay's "The Early History of Smalltalk" (ACM HOPL-II, 1993) for the Smalltalk lineage.

## See also

- `../Philosophy.md` — the short synthesis with the other five foundations.
- `../Message Protocol.md` — the operational rules that implement actor discipline.
- `06 | Registrar Pattern.md` — the Registrar as transaction coordinator for shared state.
