# Taxonomy scan contract

The page taxonomy is derived per repo, not fixed — a scan turns a repo's
shape into a page plan a user locks into `index.md`. Page set and
conformance: [okf-layout.md](okf-layout.md). Warrants:
[page-warrant.md](page-warrant.md).

## The boundary

**The scan proposes; it never writes and never culls.**
`scripts/okf-scan <repo-root>` prints one candidate per line to stdout,
index.md-ready, and exits 0 whatever it finds (2 on usage):

```
<dir>/<name>.md — <evidence path>
```

Every line names the disk evidence that warranted it. **No evidence, no
line.** The scan writes no page, edits no `index.md`, ranks nothing, and
removes nothing — culling is the user's, at lock time. It is not a
validator either; `okf-check` owns conformance.

## The two signals

Both directory-shaped, both language-blind. Dot-directories and the
repo's own `OKF/` are skipped.

- **`analyses/<name>.md`** — a directory holding a `.ipynb`, `.Rmd`, or
  `.qmd`, or one named `analysis`/`analyses`. One page each, named for
  the directory; the notebook is the evidence when both hold.
- **`modules/<name>.md`** — a directory holding at least one code file,
  one level under the repo root or under a single source root (`src/`,
  `lib/`, `R/`), and not already an analyses candidate.

A code file is one with a known source extension — that list is how you
spot code at all, not language awareness: no import graphs, no
per-language heuristics, no size thresholds, no ranking. **A threshold
is a decision to make**, and this scan makes none.

## What a scan cannot see

**A scan proposes only what a scan can see.** `modules/` and `analyses/`
are read off disk. The spine — `SUMMARY`, `ARCHITECTURE`, `CONTEXT`,
`ROADMAP`, `LEARNINGS`, `decisions/` — is written by loop skills out of
conversation, and no tree walk finds a glossary. That is the producer
seam [SKILL.md](SKILL.md) already draws at scaffold step 3; decision
[010](../../../OKF/decisions/010-two-zone-pages.md) draws it from the
other side, module and analysis pages being the only ones with a derived
zone at all. `context/<subroot>.md` has no disk signal either — a
bounded context is model-domain's to name.

## Proposal → locked plan

1. Run the scan; show the user the candidate lines.
2. The user edits the list — cut, rename, add spine pages the scan
   cannot see. What survives goes into `index.md`, one line + hook each.
3. Materialise only the pages a producer can fill *now*.

**A page is listed when planned, written when its producer has something
to say.** `index.md` may name a page that does not exist yet; no TODO
shell is written for it. `okf-check` cuts both ways here — an absent
link target is skipped, so plan-without-page is legal, while a page
nobody lists errors `not reachable from index.md`. An unwritten page
cannot be an empty ceremonial one.
