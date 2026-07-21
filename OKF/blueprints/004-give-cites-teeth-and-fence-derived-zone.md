---
type: Blueprint
status: implemented
traces-to: ROADMAP.md phase 6, part A (decision 017)
---

# 004 — give cites teeth and fence the derived zone

## Justification

Phase 6's first half. The warrant contract shipped with
[002](002-extract-why-register.md); what phase 6 still owes is the half
that *detects staleness*. `cite_resolves` (`okf-check:92-97`) already
resolves the path half, repo-free, and discards the `:suffix` it is
handed. The Real need is a cite that breaks when the thing it cites
moves — `ROADMAP.md:92-94` names that churn, and a path-only cite is the
bill without the detector.

## Contract

**A cite resolves to a symbol, not just a file.** `cites:` entries take
three shapes:

- `path` — resolves iff the path exists. Unchanged.
- `path:line` — resolves iff the path exists. The line number is a
  reading aid, never validated; a check that cannot fail is not a check.
- `path:symbol` — resolves iff the path exists **and** the symbol appears
  in it as a literal substring.

Substring, not parsing: no language awareness, no tags file, no
dependency. The two suffixes are told apart by whether it parses as an
integer.

**Cite drift belongs to `okf-check`, not refresh.** This extends
[017](../decisions/017-pin-drift-splits-by-visibility.md), which splits
by *what a tool can see*: a `sealed:` pin needs `jj show`, so it goes to
refresh; a cite needs only the working tree, so it stays in the validator
already reading it. 017's doctrine is untouched — a cite needs no repo.

Consequently **refresh's DRIFT rule narrows to pins**. Its cite half is
removed, not scripted: refresh is prose, and prose claiming to detect
drift with no runner behind it is a gate nobody passes or fails.

**The derived zone gets fences.** A page may carry at most one region
delimited by `<!-- okf:derived begin -->` and `<!-- okf:derived end -->`.
Refresh regenerates the inside wholesale and may not touch a byte
outside it; outside is the judgement zone (`../CONTEXT.md:63-67`),
append/supersede only. `okf-check` validates fence *shape* — balanced,
`begin` before `end`, at most one pair. Shape only, same rule as above.

**The warrant contract moves to its own sibling.** `okf-layout.md` is at
100/110 and gains two contracts here, so the warrant and `sealed:` blocks
leave for `page-warrant.md` — headroom by splitting, not by exemption.

**Phase 6 gains one hunk, two clauses.** Its `grep -rL "^purpose:"`
clause (`ROADMAP.md:73-74`) wants a warrant on every page but `index.md`;
002 later scoped warrants to root pages plus `decisions/`, exempting
`blueprints/` and `ferries/` (`okf-check:180-183`), so it cannot pass and
narrows to the scope that holds. The phase also records its own split —
`Ships as 004 (cites + fences) then 005 (taxonomy scan).` — because a
split nobody wrote down is one the next agent re-litigates.

## Seams touched

- `skills/loop/write-OKF/scripts/okf-check` — `cite_resolves` gains the
  symbol case; a fence-shape check joins it. CLI unchanged:
  `okf-check <okf-dir>`, findings on stdout, exit 0/1.
- `skills/loop/write-OKF/page-warrant.md` — **new**. The warrant contract
  and the `sealed:` pin block, moved verbatim.
- `skills/loop/write-OKF/okf-layout.md` — the cite grammar, the derived
  fence contract, and a pointer replacing the two moved blocks.
- `skills/loop/write-OKF/SKILL.md` — refresh step 4 (the cite grammar),
  step 6 (narrowed to pins), and the derived-zone regeneration rule.
- `OKF/ROADMAP.md` phase 6 — the corrected Verify clause and the split
  line. One hunk; the phase stays under 110.

## Verify

Weave builds a throwaway fixture in the scratchpad — **not** a jj repo,
which is the point — `src/conf.py` holding `def parse_config`, an OKF
citing `src/conf.py:parse_config` from a fenced `ARCHITECTURE.md`, and a
`before/` copy. It regenerates the zone by hand, then runs:

```sh
S=$SCRATCH/fx-cites && Z='/okf:derived begin/,/okf:derived end/d' \
  && test ! -d $S/.jj && skills/loop/write-OKF/scripts/okf-check $S/OKF \
  && sed -i 's/def parse_config/def load_config/' $S/src/conf.py \
  && ! skills/loop/write-OKF/scripts/okf-check $S/OKF \
  && diff <(sed "$Z" $S/OKF/ARCHITECTURE.md) <(sed "$Z" $S/before/ARCHITECTURE.md) \
  && printf '<!-- okf:derived begin -->\n' >> $S/OKF/SUMMARY.md \
  && ! skills/loop/write-OKF/scripts/okf-check $S/OKF \
  && skills/loop/write-OKF/scripts/okf-check OKF/ \
  && grep -rL "^purpose:" OKF/*.md OKF/decisions/[0-9]*.md | grep -qx OKF/index.md \
  && for f in skills/loop/write-OKF/okf-layout.md \
              skills/loop/write-OKF/page-warrant.md OKF/ROADMAP.md; do
       test "$(wc -l < $f)" -le 110 || exit 1; done \
  && echo PASS
```

## Out of scope

- The taxonomy scan, `taxonomy-scan.md`, `modules/`, `analyses/`, and the
  page-plan proposal — phase 6 part B, its own blueprint.
- A symbol parser, ctags, or language-aware resolution; and validating
  `path:line` numbers. Literal substring or nothing.
- Giving refresh a runner. Its cite half moves to `okf-check`; the pin
  half stays prose, per 017.
- Backfilling `path:symbol` into existing `cites:`. New grammar, no sweep.
- Resolving `ferries/python-siblings/` D-1..D-3.
- Raising or exempting the 110-line cap.
