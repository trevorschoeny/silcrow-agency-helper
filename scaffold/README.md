# {project_name}

{project_description}

---

## What this is

This repository is organized as a **hierarchical agent organization** with built-in decision tracking (ADRs), actor-model message passing between agents, and registrar-enforced record integrity. The structure was initialized by the `agent-org-scaffold` skill on {date}, and it is self-maintaining from here — the skill will not be re-invoked.

The shape of the project is opinionated and comes from a composition of six independently-validated disciplines:

- **Stratified cognition** (Elliott Jaques): hierarchy reflects differences in time horizon of work.
- **Subsidiarity** (Catholic social teaching / EU law): decisions at the lowest competent level.
- **Actor model** (Hewitt, Armstrong): private state per agent, communication via messages.
- **Architecture Decision Records** (Nygard, MADR): immutable decision log with rationale.
- **Legal citation tradition**: §-numbered, sequential, never-reused identifiers.
- **Registrar pattern**: procedural authority over form, not substance.

If you are new here, read `docs/philosophy.md` before going deeper. That document explains why the structure is what it is.

---

## Read in this order

A new reader — human or agent — should read these in order:

1. **This file** — `README.md` — for orientation.
2. **`docs/philosophy.md`** — the intellectual foundation for every part of the structure.
3. **`docs/decision-process.md`** — how decisions (ADRs) are proposed, accepted, superseded.
4. **`docs/message-protocol.md`** — how agents communicate.
5. **`agents/<your-role>/instructions.md`** — if you are occupying a role, your specific duties.
6. **`adr/accepted/§0006-starter-roster-and-tier-model.md`** and **`§0010-roster-change-protocol.md`** — the tier model and how the roster changes over time.

For deeper dives on any of the six disciplines, `docs/foundations/` has per-thread treatments.

---

## Directory layout

```
{project_name}/
├── README.md                      ← you are here
├── agents/
│   ├── {user_dir}/                ← tier 0: strategic direction
│   ├── {lead_dir}/                ← tier 1: architecture, briefs, reviews
│   ├── {implementer_dir}/         ← tier 2: planning and execution
│   └── registrar/                 ← outside hierarchy: record integrity
│
│   (roster is the set of agent directories above, plus any added via §0010;
│    see §0006 for the tier model and §0010 for the change protocol)
│
├── adr/                           ← architecture decision records
│   ├── README.md                  ← index of all decisions
│   ├── _templates/                ← MADR and anti-pattern templates
│   ├── accepted/                  ← currently binding decisions
│   ├── superseded/                ← decisions replaced by a newer ADR (preserved)
│   ├── rejected/                  ← proposals explicitly rejected (preserved)
│   └── anti-patterns/             ← standalone anti-pattern records
│
├── proposed/                      ← Registrar's inbox for incoming ADR proposals
│
└── docs/
    ├── philosophy.md              ← why this works the way it does (read first)
    ├── decision-process.md        ← ADR lifecycle
    ├── message-protocol.md        ← inbox / archive discipline
    ├── registrar-playbook.md      ← Registrar's operational procedures
    └── foundations/               ← deep dives on each of the six disciplines
```

---

## Core conventions — at a glance

These rules govern how work happens here. Each is explained in depth in the linked doc, but this glance may help you orient:

- **Decisions are immutable.** Accepted ADRs are never edited. They are superseded by new ADRs; both remain in the record. See `docs/decision-process.md`.
- **§-numbers are permanent.** Every accepted ADR gets a §-number. Numbers are sequential, monotonic, and never reused — even for rejected proposals. See `docs/foundations/05-legal-citation-tradition.md`.
- **Messages are first-class.** Communication between agents goes through inboxes (`agents/<role>/inbox/`) and is archived on read (`inbox/archive/`). No out-of-band communication. See `docs/message-protocol.md`.
- **The {lead_role} writes briefs, not specs.** What and why, not how. The {implementer_role} retains agency over execution. See `agents/{lead_dir}/instructions.md`.
- **The Registrar owns form, not substance.** They verify the record's integrity but do not adjudicate decisions. See `docs/registrar-playbook.md`.
- **Subsidiarity.** Decisions are made at the lowest tier capable of making them well. Higher tiers intervene proportionately, not routinely. See `docs/foundations/02-subsidiarity.md`.

---

## The founding nine

The scaffold ships with **nine seeded ADRs** (§0001–§0009). §0001 records the decision to adopt the scaffold itself. §0002 through §0009 are **constitutional decisions inherited through §0001** — they make the load-bearing choices of the pattern explicit and supersedable rather than leaving them as unrecorded convention.

| § | Constitutional decision |
|---|---|
| §0001 | Adopt the agent-org-scaffold pattern |
| §0002 | Use MADR + Y-statement as the ADR format |
| §0003 | Use §-numbering: sequential, monotonic, never-reused |
| §0004 | Accepted ADRs are immutable; supersession replaces editing |
| §0005 | Inter-agent communication via inboxes; no out-of-band channels |
| §0006 | Starter roster and tier model |
| §0007 | {lead_role} writes briefs, not specs |
| §0008 | Registrar authority is procedural, not substantive |
| §0009 | Anti-patterns are first-class records |

Each cites its foundation doc (`docs/foundations/0N-*.md`) for the full reasoning, and each lists real alternatives so it can be evaluated or superseded like any other ADR. The founding nine serve as **both the working base of the project's decision graph and a demonstration set** — they show new agents what proper ADRs look like in this project.

---

## Adding agents, renaming roles, restructuring

These are significant decisions, each governed by its own ADR. The full protocol — including the five-step procedure, the Registrar's directory-level actions, and the rule that retired agents preserve their inbox archives — is itself an ADR: **`adr/accepted/§0010-roster-change-protocol.md`**. Read it when you need to change the roster.

The roster at any point in time is the set of directories under `agents/` (plus `agents/_retired/` for historical agents). There is no separate catalog to maintain.

---

## What this scaffold does not provide

- No opinion on tech stack, build tools, or CI/CD.
- No code files.
- No git hooks, automation, or scripts.
- No prescribed workflow beyond the ADR and message-protocol disciplines.

It is purely an *organizational* scaffold. What happens inside the organization — the software, research, writing, or other substantive work — is up to you.

---

## Further reading

See `docs/philosophy.md` first, then dig into whichever of the foundations are most relevant to your role. These documents are the scaffold's constitutional text — if a situation comes up that the procedural docs don't cover, the foundations are where to reason from.
