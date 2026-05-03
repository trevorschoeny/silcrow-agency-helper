# §0004 | Accepted ADRs are immutable; supersession replaces editing

- **Status:** accepted
- **Date:** {date}
- **Authors:** scaffold initialization (inherited via §0001)
- **Supersedes:** —
- **Superseded by:** —
- **Influences:** §0008 (immutability is what the Registrar enforces); all future ADRs.
- **Influenced by:** §0001, §0003

## Why-statement

In the context of **maintaining a durable decision log over years**,
facing the reality that decisions sometimes turn out to be wrong and circumstances always change,
we decided for **immutability of accepted ADRs, with supersession as the only change mechanism**
and neglected edit-in-place-with-changelog, versioned-in-place, and Wiki-style free editing,
to achieve a record that remains citable across time and preserves the arc of how thinking evolved,
accepting heavier ceremony to replace a decision than a simple edit would impose,
because the same discipline is what makes legal citation, git commit history, event sourcing, and constitutional law work — and because every system that relaxed it eventually lost the integrity it was meant to preserve.

## Context and problem statement

**Inherited decision.** This is a founding constitutional decision inherited from the Silcrow plugin via §0001 at project initialization. The reasoning and alternatives are preserved here so it can be evaluated or superseded on its own merits through the normal ADR lifecycle.

Every decision log has to answer the same question: what happens when an accepted decision turns out to be wrong, or when circumstances change? The answer shapes everything downstream — whether citations remain stable, whether history is preserved, whether the log accumulates trust or decays into a decorative artifact.

The stakes are concrete. A citation is a commitment to a specific reading of the cited artifact. If §0042 today could refer to something different than it did yesterday, every citation to §0042 becomes ambiguous, and every chain of reasoning that flows through §0042 becomes suspect. The entire network of cross-references depends on the cited nodes staying themselves.

## Decision drivers

- **Durability of citations** over multi-year horizons.
- **Preservation of rationale history** — future agents should see not just the current position but how thinking got there.
- **Observability of drift** — changes to the record should be visible and auditable, not silent.
- **Proportionate ceremony** — the discipline should cost more than an edit but less than a formal amendment process.

## Considered options

1. **Immutability + supersession (chosen).** Accepted ADRs are never edited. Replacement is via a new ADR that references the old via `Supersedes`. The old ADR is moved from `accepted/` to `superseded/` and gains a retrospective note pointing forward.
2. **Edit-in-place with changelog.** Edit the existing ADR; maintain a changelog at the bottom. Familiar from Wikipedia, many wikis.
3. **Versioned-in-place.** Keep the ADR filename but add a version suffix each time it changes (`§0042.v1`, `§0042.v2`). Git-like.
4. **Wiki-style free editing.** No change discipline. Anyone can edit any ADR. Only the latest version is authoritative; history lives in version control.

## Decision outcome

**Chosen option: (1) Immutability + supersession.**

The same discipline governs legal statutes (sections aren't reassigned when repealed; new sections supersede old ones), git commit history (content-addressed, never rewritten — though mutable branches can lie about their history), event sourcing (events are appended, never mutated), and constitutional amendment processes (amendments don't edit the original; they reference and modify it explicitly).

Each of these disciplines works because it preserves the artifact that was cited from outside. Each of their alternatives — editable statutes, rewritable commits, mutable event streams, freely-edited constitutions — has been tried at scale and produces measurable integrity loss. The empirical record is one-sided.

Options (2), (3), and (4) all share a common failure: they make the cited artifact mutable. (2) makes the body mutable (the changelog is supposed to track this, but changelogs decay under busyness — see any multi-year wiki). (3) multiplies filenames, which defeats stable citation. (4) gives up on stability entirely. None of the three preserves the property that "what I cite today is what you read tomorrow."

### Consequences

- **Positive:** Citations to §N resolve to the same body text forever; the record remains load-bearing.
- **Positive:** The arc of how thinking evolved is preserved as history — a superseded ADR plus its retrospective note plus the superseding ADR together form a readable narrative.
- **Positive:** "Fix" pressure is channeled into deliberate supersession; careless edits are impossible without violating the convention openly.
- **Positive:** Mistakes become lessons rather than being quietly rewritten.
- **Negative:** Heavier ceremony to change a decision than a simple edit. Most projects experience this as friction initially; the friction attenuates once the pattern is familiar.
- **Negative:** Retrospective notes are the one permitted post-acceptance modification; they themselves are immutable once written, which requires a small amount of discipline when drafting them.
- **Neutral:** Projects that want higher churn than supersession supports are signaling that their decisions are too fine-grained — the bar for what deserves an ADR should move upward.

## Pros and cons of the options

### (1) Immutability + supersession

- ✅ Citations remain stable over any horizon.
- ✅ Arc of reasoning preserved; mistakes become learning.
- ✅ Aligns with centuries-proven disciplines in law, event sourcing, git.
- ❌ Heavier to change a decision than a simple edit.

### (2) Edit-in-place with changelog

- ✅ Simple to make small corrections.
- ✅ Familiar pattern from wikis.
- ❌ Changelogs decay under busyness; the convention erodes before the record is old.
- ❌ Citations become ambiguous ("I cited §0042 — which version?").

### (3) Versioned-in-place

- ✅ Preserves history more visibly than (2).
- ❌ Multiplies filenames, breaks stable-citation property.
- ❌ Complicated: citers must pick a version, which most won't do.

### (4) Wiki-style free editing

- ✅ Zero friction.
- ❌ Zero durability. The record exists but doesn't mean anything.

## Anti-patterns surfaced

- **Silent "just this once" edits.** The most dangerous pattern. An agent edits an accepted ADR with a small correction, reasoning that it's minor. The discipline is gone; the next correction is larger; within months the record is unreliable. The only defense is strict refusal, enforced by the Registrar.
- **Changelog-at-bottom.** A fallback temptation: "I'll keep the body clean and put updates in a changelog." This is option (2) in a different costume and fails the same way.
- **Back-dating retrospective notes.** If a retrospective note is appended weeks after the supersession, date it the day the supersession happened, not the day the note was written. The note's provenance should point to the decision event, not the ceremonial catch-up.

## Review trigger

This decision should be reconsidered only if the project adopts an external record system (e.g., moves ADRs into a fully-versioned database) that provides the same immutability guarantees through a different mechanism. The discipline is not context-dependent; the failure modes of alternatives are intrinsic.

## References

- `../../3 | Silcrow Agency Reference/foundations/04 | Architecture Decision Records.md` — full intellectual history.
- `../../3 | Silcrow Agency Reference/foundations/05 | Legal Citation Tradition.md` — the legal-citation parallel.
- `../../3 | Silcrow Agency Reference/Decision Process.md` — operational rules for supersession.
- Capilla, R., Jansen, A., Tang, A., Avgeriou, P., & Babar, M. A. (2016). "A decade of software architecture knowledge management." *JSS* 116.
- Nygard, M. (2011). "Documenting Architecture Decisions."
