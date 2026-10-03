---
type: Blueprint
status: implemented
traces-to: ROADMAP.md phase 6, part B (decisions 007, 009, 010)
---

# 005 — propose the page plan from a repo scan

## Justification

Phase 6's second half, the last thing owed before it ticks.
[007](../decisions/R-007-taxonomy-derived-per-repo.md) settled that the page
taxonomy is derived per repo; [009](../decisions/R-009-index-is-the-page-plan.md)
settled where the plan is recorded. Neither has a producer — scaffold
still materialises a fixed four-template skeleton (`write-okf/SKILL.md:32`),
the exact layout 007 rejects. The Real need: a scan turning a repo's shape
into a proposal a user can lock. Brief: `ROADMAP.md:70-77`.

## Contract

**The scan proposes; it never writes and never culls.** `okf-scan
<repo-root>` walks the tree and prints one candidate page per line to
stdout, index.md-ready: `<dir>/<name>.md — <evidence path>`. Every line
names the disk evidence that warranted it. **No evidence, no line.**

Two signals, both directory-shaped, both language-blind:

- **`analyses/<name>.md`** — a directory named `analysis`/`analyses`, or
  holding a `.ipynb`, `.Rmd`, or `.qmd`. One page each, named for it.
- **`modules/<name>.md`** — a directory holding at least one code file,
  under the repo root or a single source root (`src/`, `lib/`, `R/`),
  not already an analyses candidate.

Dot-directories and the repo's own `OKF/` are skipped; no thresholds, no
ranking, no language awareness — a threshold is a decision to make.

**A scan proposes only what a scan can see.** `modules/` and `analyses/`
are read off disk; the spine — `SUMMARY`, `ARCHITECTURE`, `CONTEXT`,
`ROADMAP`, `LEARNINGS`, `decisions/` — is written by loop skills out of
conversation, and no tree walk finds a glossary. `SKILL.md:34-37` draws
that producer seam already; [010](../decisions/R-010-two-zone-pages.md)
draws it from the other side, module and analysis pages being the only
ones with a derived zone at all.

**A page is listed when planned, written when its producer has something
to say.** index.md may name a page that does not exist yet; scaffold
writes no TODO shell for it. Needs no new code, and cuts both ways in
`okf-check`: absent link targets are skipped (`:76-79`), so
plan-without-page is legal, while an unlisted page errors `not reachable
from index.md` (`:199-200`). An unwritten page cannot be empty.

**A scaffold's own output must pass `okf-check`.** It does not today:
`templates/*.tpl` carry `type:` alone, so every scaffolded page errors
`missing purpose:`. Purposes are fixed already by the page contracts
(`okf-layout.md:53-87`), so the four templates carry real warrants.
`CONTEXT.md.tpl` and `ROADMAP.md.tpl` are added for their producers to
fill, unmaterialised — no pre-warranted shell slips past the check.

## Seams touched

- `skills/loop/write-okf/scripts/okf-scan` — **new**. CLI
  `okf-scan <repo-root>`, candidates on stdout, exit 0 whatever it finds
  (2 on usage) — a scanner is not a validator, so
  [016](../decisions/R-016-one-okf-check-validator.md) holds.
- `skills/loop/write-okf/taxonomy-scan.md` — **new**. The scan contract:
  two signals, the evidence rule, the producer seam, the propose-never-
  write boundary, and how a proposal becomes a locked plan.
- `skills/loop/write-okf/okf-layout.md` — `modules/` and `analyses/` in
  the tree, marked proposable; a pointer to `taxonomy-scan.md`.
- `skills/loop/write-okf/SKILL.md` — scaffold step 2 becomes scan →
  propose → user locks `index.md` → materialise what it lists *and* a
  producer can fill.
- `skills/loop/write-okf/templates/` — warrants on the four templates;
  `CONTEXT.md.tpl` and `ROADMAP.md.tpl` added, unmaterialised.
- `OKF/ROADMAP.md` phase 6 — the ✅ tick, paid for by its spent risk line
  (`:94-96`; 004 shipped `path:symbol`).

## Verify

Weave builds two scratchpad fixtures — `fx-analysis/` with
`analysis/2026-cohort/report.Rmd` and no code module, `fx-lib/` with
`src/parser/parse.py` and `src/render/render.py` and no notebook —
scaffolds `fx-analysis/OKF` per the rewritten step 2, then runs:

```sh
S=$SCRATCH && A=$S/fx-analysis && L=$S/fx-lib && W=skills/loop/write-okf \
  && $W/scripts/okf-scan $A > $S/plan-a && $W/scripts/okf-scan $L > $S/plan-l \
  && test -s $S/plan-a && test -s $S/plan-l && ! diff -q $S/plan-a $S/plan-l \
  && grep -q '^analyses/' $S/plan-a && ! grep -q '^modules/' $S/plan-a \
  && grep -q '^modules/' $S/plan-l && ! grep -q '^analyses/' $S/plan-l \
  && ! grep -qv ' — ' $S/plan-a \
  && ! test -e $A/OKF/ROADMAP.md && grep -q ROADMAP.md $A/OKF/index.md \
  && $W/scripts/okf-check $A/OKF && $W/scripts/okf-check OKF/ \
  && for f in $W/okf-layout.md $W/taxonomy-scan.md $W/SKILL.md OKF/ROADMAP.md; do
       test "$(wc -l < $f)" -le 110 || exit 1; done \
  && echo PASS
```

## Out of scope

- Rescanning on refresh — the standing keep/expand criterion and the
  remove-if-wholly-derived rule are 006, on 010's grant and
  [015](../decisions/R-015-moor-collapses-ferry-directory.md)'s doctrine.
- Recording the producer seam as a decision — settle at moor.
- `context/<subroot>.md` proposals — a bounded context has no disk
  signal; model-domain owns it.
- The scan writing pages, editing `index.md`, or ranking candidates.
- Language-aware module detection, import graphs, size thresholds.
- Backfilling `modules/`/`analyses/` into octobot's own OKF. No sweep.
- Raising or exempting the 110-line cap.
