---
type: Blueprint
status: implemented
traces-to: 005's Out of scope (rescan on refresh); ROADMAP.md phase 8, added by this change
---

# 006 — rescan the page plan on refresh

## Justification

005 shipped the scaffold path only — a scan proposes a plan once, at
birth. Refresh (`write-okf/SKILL.md:50-73`) never runs it, so a repo that
grows a module gets no page and one that loses a module keeps a stale
page forever. [007](../decisions/R-007-taxonomy-derived-per-repo.md) makes
the taxonomy derived per repo; today it is derived *once*.

Removal is the part nobody has ruled on: the doctrine falls out of
[010](../decisions/R-010-two-zone-pages.md)'s derived zone and
[015](../decisions/R-015-moor-collapses-ferry-directory.md)'s "history is
the archive of record", but neither states it — so it becomes decision
018 here, before this locks. The last two items are flags 005's weave
raised, both in `okf-scan`, both reproduced.

## Contract

**Refresh proposes a plan delta; it still never writes and never culls.**
Rescan runs `okf-scan <repo-root>` and sorts every candidate, and every
`modules/`/`analyses/` line already in `index.md`, into three buckets:

- **new** — a candidate `index.md` does not list → propose to add.
- **standing** — listed and still proposed → keep. Its derived zone is
  regenerated wholesale, its judgement zone untouched, per 010.
- **unwarranted** — listed but no longer proposed → propose to remove or
  supersede, per the doctrine below.

The user locks the delta as at scaffold (`taxonomy-scan.md:52`); no
bucket is applied unasked. **Jurisdiction is `modules/` and `analyses/`
only** — a page no scan can see is never proposed for removal.

**An unwarranted page is deleted only if it is wholly derived** —
nothing outside its `okf:derived` fences but frontmatter and title. One
byte of judgement and it is superseded instead, struck with a pointer per
`SKILL.md:53`. A wholly derived page loses nothing a rescan cannot
rebuild; for the rest 015's ground holds — history is the archive.

**A container proposes nothing; its members do.** A directory matched by
name alone (`analysis`/`analyses`) that has a descendant candidate yields
no page; a directory holding a notebook is a candidate whatever its name.
Today `analysis/2026-cohort/report.Rmd` proposes both
`analyses/2026-cohort.md` and `analyses/analysis.md`; the user culls that
container at scaffold, but on refresh it would return every scan.

**The scan exits 0 whatever it finds.** `iterdir()` on an unreadable
directory raises today (`okf-scan:38,48`), exiting 1 against 005's seam
promise. Such a directory yields no evidence — a permission bit is not a
page plan.

## Seams touched

- `skills/loop/write-okf/scripts/okf-scan` — container suppression;
  unreadable directories yield no evidence. No new flag, no new mode —
  the delta is read by refresh, not computed by the scanner.
- `skills/loop/write-okf/taxonomy-scan.md` (64/110) — a **Rescan on
  refresh** section: three buckets, removal doctrine, container rule.
- `skills/loop/write-okf/SKILL.md` (103/110) — refresh step 1 gains the
  rescan and its lock. **≤7 net new lines** — the whole slack it has.
- `OKF/decisions/018-<slug>.md` + `decisions/index.md` — the removal
  doctrine. 018 is spent here, so 004's carried cite/pin-split question
  takes a later number if it ever lands.
- `OKF/ROADMAP.md` (108/110) — **phase 8, ≤4 lines**, paid for by
  collapsing the three-line execution-order note (`:90-92`) to one; the
  append-only sentence phase 8 rides on survives. Ends ≤110.
- `OKF/index.md` — the 006 blueprint line; "17 live" → 18.

## Verify

Weave builds `$SCRATCH/fx-refresh/` — `analysis/2026-cohort/report.Rmd`,
`src/parser/parse.py`, `src/render/render.py`, unreadable `src/sealed/`
(mode restored after) — and an `OKF/` listing `modules/parser.md`,
`modules/render.md`, `modules/gone.md` (wholly derived) and
`modules/kept.md` (one sentinel paragraph outside the fences); copies
`parser.md` to `parser.before`; drops `src/render/`; adds
`src/emit/emit.py`; refreshes per the rewritten steps; then runs:

```sh
S=$SCRATCH/fx-refresh && O=$S/OKF && W=skills/loop/write-okf \
  && $W/scripts/okf-scan $S > $S/plan \
  && grep -q '^analyses/2026-cohort\.md ' $S/plan \
  && grep -q '^modules/emit\.md ' $S/plan \
  && ! grep -qE '^(analyses/analysis|modules/render)\.md ' $S/plan \
  && grep -q 'modules/emit.md' $O/index.md \
  && ! test -e $O/modules/gone.md && ! grep -q 'modules/gone.md' $O/index.md \
  && grep -qF "$(cat $S/sentinel)" $O/modules/kept.md \
  && diff <(sed '/okf:derived begin/,/okf:derived end/d' $S/parser.before) \
          <(sed '/okf:derived begin/,/okf:derived end/d' $O/modules/parser.md) \
  && $W/scripts/okf-check $O && $W/scripts/okf-check OKF/ \
  && for f in $W/SKILL.md $W/taxonomy-scan.md OKF/ROADMAP.md; do
       test "$(wc -l < $f)" -le 110 || exit 1; done \
  && echo PASS
```

## Out of scope

- A runner for the plan delta — refresh reads it, as it reads DRIFT
  (003's precedent: prose rule, no second validator).
- Applying any bucket without the user's lock; auto-refresh on a hook.
- Ranking, thresholds, language-aware module detection — still 005's.
- Recording the producer seam as a decision — still moor's.
- Backfilling `modules/`/`analyses/` into octobot's own OKF. No sweep.
- Raising or exempting the 110-line cap.
