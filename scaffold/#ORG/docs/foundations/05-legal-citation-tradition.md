# 05 — Legal citation tradition

## What the idea is

**Sequential, monotonic, never-reused identifiers make a body of writing citable across time.**

Law depends on this. A statute cited in a brief today, a brief cited in an opinion written next year, an opinion cited in a treatise published a decade later, a treatise cited in a new statute — the entire fabric of legal reasoning rests on the premise that §1983, cited anywhere, means the same §1983 everywhere. If §1983 could ever come to mean something different, every citation chain touching it would become ambiguous, and law would lose its ability to accumulate.

The discipline that makes this work is centuries old. The scaffold adopts it directly because software-engineering records have the same need for long-term citability that legal texts do.

## The section sign (§)

The typographic symbol **§** is called the **section sign**, or sometimes the **silcrow** (a portmanteau of *pilcrow*, the ¶ symbol, and *signum sectionis*).

### Origin

The symbol originated in medieval scribal practice as a ligature — the superposition or combination of two S glyphs — derived from the Latin phrase *signum sectionis*, meaning "sign of the section." Its shape stabilized by the late medieval period, and early printed legal texts preserved it. By the time modern legal publishing took shape in the 18th and 19th centuries, § was already the conventional marker for numbered divisions within statutes, codes, and treatises.

The doubled form **§§** refers to multiple sections — for example, "see §§ 101–103."

### Typographic status

§ is encoded at Unicode code point U+00A7 (inherited from Latin-1). On most keyboards it is accessible through composition sequences or IME. On macOS, for example, Option-6 produces §.

Matthew Butterick's *Typography for Lawyers* (O'Connor's, 2018) has a compact entry on the symbol's typography and usage conventions. Butterick notes that the § is one of the few symbols that has retained its specialized legal association across centuries of typographic evolution — most older scribal symbols (marginal marks, manicules, etc.) have been naturalized into general use or disappeared, but § remains characteristically legal.

## Legal citation structure

In modern American legal citation, governed by *The Bluebook: A Uniform System of Citation* (Harvard Law Review Association, now in its 21st edition, 2020), the section sign appears inside precise citation forms:

- *42 U.S.C. § 1983* — Title 42 of the United States Code, Section 1983.
- *Fed. R. Civ. P. 12(b)(6)* — Federal Rules of Civil Procedure, Rule 12(b)(6). (Note: FRCP uses "Rule" not §, but the principle is the same.)
- *Restatement (Second) of Contracts § 90* — Section 90 of the American Law Institute's Restatement of Contracts (2d).

Each citation resolves to a specific, stable textual unit. The citation format is dense because it's optimized for the opposite property: each piece of the citation answers a question ("which code?", "which section?"), and together they uniquely identify one place in a formal textual hierarchy.

Other jurisdictions have their own citation styles — *OSCOLA* in the UK, *McGill Guide* in Canada, *Chicago Manual* for non-legal academic writing — but the common feature across all of them is that sections are identified by stable, never-reused numbers.

## The three load-bearing properties

Section numbering in law obeys three rules:

### Sequential

Sections within a code or statute are numbered in order. §1 comes before §2 which comes before §3. There is no topical reordering of the numbers themselves — §2 is always §2, regardless of what it's about.

### Monotonic

Numbers go up. New sections are added at the end, or (when legislation amends existing structure) at the next unused number. Numbers do not go backward.

### Never reused

This is the most important of the three. Even if a law is repealed — even if the section it occupied is effectively deleted from current-force legislation — the number is not reassigned to something new. The original reference continues to resolve, either to the original text (preserved in historical versions) or to a record of its repeal.

The never-reused discipline is what makes legal citation robust over centuries. *42 U.S.C. § 1983* has meant the same thing since 1871 (the year the underlying Civil Rights Act was passed, though it was later codified). Citations to it from court opinions published in any intervening year continue to resolve correctly. If §1983 had been reassigned in, say, 1922 — a plausible policy choice — every citation to it from before 1922 would now be ambiguous, and the body of civil-rights case law built around §1983 would be less navigable.

## Why immutability of identifiers matters

The three properties above produce a single essential guarantee: **if you cite §N today, and someone else reads your citation in five years, they can find exactly what you were referring to**.

This guarantee is what lets a body of writing accumulate *coherence* over time. Each new document builds on prior ones by citation. The citation network is the load-bearing skeleton. If any identifier can later mean something different, the skeleton fractures.

The same guarantee is required for:

- **Event sourcing** in software (immutable event records with monotonic sequence IDs).
- **Git commit hashes** (content-addressable, never reused).
- **DOIs for academic papers** (persistent identifiers independent of where the paper currently lives).
- **ISBN numbers** for books (never reused across editions or new works).
- **IETF RFC numbers** (monotonically assigned; obsolete RFCs remain numbered, marked "obsoleted by" a successor).

Each of these systems is a different instantiation of the same insight: *stable, never-reused identifiers are the precondition for citability over time.*

## Why this matters for the scaffold

Every accepted ADR in this project receives a §-number, assigned by the Registrar, following the same three rules:

**Sequential.** ADRs receive §-numbers in the order they are accepted. Not by topic, not by importance — in submission order.

**Monotonic.** Numbers only go up. §0042 is always after §0041 in acceptance time, regardless of what each is about.

**Never reused.** Even rejected proposals consume a §-number. A proposal submitted, numbered §0087, then rejected, leaves §0087 permanently associated with that rejected proposal. The next accepted ADR is §0088 or higher.

Filenames embed the §-number literally: `§0042-adopt-observability-v2.md`. The `§` character is used as-is — valid UTF-8, widely supported in modern filesystems, and carrying the full weight of its legal-citation lineage. Status changes move files between folders (`accepted/`, `superseded/`, `rejected/`); the filename does not change. The identifier is permanent.

This means: years from now, a reference to §0042 in a message, in another ADR, in a commit message, or in external documentation, continues to resolve. You can follow any citation chain forward in time and find where each reference leads.

## The four-digit convention

The scaffold uses four digits zero-padded (§0042, not §42). Two small reasons:

- **Filesystem sorting.** A lexicographic sort of filenames puts §0001 before §0010 before §0100, which matches numeric order. Without padding, lexicographic sort produces §1, §10, §100, §2 — readable but annoying.
- **Identifier aesthetics.** Zero-padded numbers feel like identifiers; unpadded numbers feel like offsets. Small, but it nudges the right mental model.

Four digits supports up to 9999 ADRs per project, which is far more than any real project will produce. If you somehow reach §9999, that's a signal that something has gone wrong.

## Why not topic-based identifiers?

An obvious alternative to sequential numbering is topic-based (e.g., `auth-001`, `data-007`). This is attractive because it gives humans a hint about what the ADR is about without opening it.

The scaffold rejects topic-based numbering for three reasons:

1. **Topics evolve.** An ADR about "auth" today may, in six months, be better categorized as "identity." Reorganizing identifiers when topics shift breaks citations.
2. **Multi-topic decisions.** Architectural decisions often span topics. "Use JWT for session identity" is both auth and identity and cross-cutting convention. A single topic forces a misleading categorization.
3. **Sort order loses meaning.** With topic prefixes, §-numbers within each topic restart, and the global acceptance order is lost. History becomes harder to read.

The scaffold compensates for the loss of topic-at-a-glance with the filename's short title: `§0014-use-structured-logging.md` tells you what it's about. The § gives stable identity; the kebab-title gives human-readable context.

## Debates and open questions

- **Is § the right character?** Some argue for ASCII-safe identifiers (e.g., `S0014`) because § can be awkward in some tooling (shells, some search engines). The scaffold's position: use §. Tooling mostly handles it well; where it doesn't, wildcards work. The historical and semantic weight of § is worth the occasional friction.
- **Agency-global vs. partitioned numbering.** At scale, you might want to partition § sequences by topic or module. The scaffold's default is agency-global; see `../../agents/registrar/AGENTS.md` ("Partitioning at scale") for the partition discussion. The key discipline either way: never restart numbering.
- **Pilcrow for sub-sections.** Formal legal writing uses § for sections and ¶ (pilcrow) for paragraphs within them. The scaffold doesn't use ¶ today — ADRs are short enough not to need paragraph-level identifiers — but the option exists.

## Further reading

- *The Bluebook: A Uniform System of Citation* (21st ed., Harvard Law Review Association, 2020). The authoritative source on modern American legal citation. Read the introduction even if you never cite a statute; it is a masterclass in citation discipline.
- Butterick, M. (2018). *Typography for Lawyers* (O'Connor's). Entry on "Paragraph and section marks." Also generally useful for anyone writing formally.
- *OSCOLA* (Oxford Standard for the Citation of Legal Authorities), for the UK equivalent.
- Wikipedia's article on the "Section sign" has good short notes on etymology and usage. The *Grokipedia* article is even more detailed on the scribal origins.
- IETF RFC 7322, "RFC Style Guide," for a parallel convention in a different domain — RFCs have their own never-reused numbering.

## See also

- `../philosophy.md` — the short synthesis with the other five foundations.
- `../decision-process.md` — the operational rules for §-numbering in this project.
- `04-architecture-decision-records.md` — why immutable records need stable identifiers.
- `06-registrar-pattern.md` — who assigns and maintains §-numbers.
