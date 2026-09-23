---
type: Blueprint
status: implemented
traces-to: user request 2026-07-31
sounded: 2026-07-31
cites:
  - skills/loop/write-OKF/scripts/link-check
  - skills/loop/write-OKF/scripts/render-check
  - OKF/blueprints/B-023-add-a-link-lint-over-relative-md-links.md:What it walks
  - OKF/blueprints/B-019-add-a-render-lint-over-the-loop-shape.md:dot-directories skipped
  - OKF/blueprints/B-024-rename-the-spine-and-give-chart-its-ferry-edge.md:that Contract is sealed
  - OKF/blueprints/B-022-validate-every-cite-at-every-status.md:its Contract and Verify are not touched
  - OKF/ROADMAP.md
muster: true
review-base: yommvsuw
tally:
  intent: share one git-aware walk so an ignored page cannot redden a gate
  matches: yes
---

# 026 — walk only what git does not ignore

## Justification

**A repo-wide gate reddens on a file the repo does not own.** `HANDOFF.md` is
gitignored, yet both lints walk it, so scratch prose can fail the tree. The
cost is paid: [024](B-024-rename-the-spine-and-give-chart-its-ferry-edge.md)
carries *clear gitignored `HANDOFF.md` first* as a **run condition**, and a
handoff must be written link-free, quoting no lint constant. 024 §Out of scope
declines it *"but that Contract is sealed — the fix is a supersession, not a
line in a rename."*

**The measured census.** Exactly **one** `.md` in the walk is ignored —
`HANDOFF.md`; nothing untracked. **Zero** of 516 relative links sit inside
inline-code spans, so [023](B-023-add-a-link-lint-over-relative-md-links.md)'s
ruling that inline-code spans are unreal holds for every page left once the
ignored one goes — the only page wanting one is the only ignored page. The
backtick rule earns nothing, failing
[sieve](../../skills/engineering/sieve/SKILL.md)'s Real test.

**Why both lints.** `pages()` is **byte-identical** in the two, `SKIP`
included, and `render-check` holds a retired-form constant a handoff cannot
quote either. Fixing one and leaving its twin is the shape this repo has
mechanised three times — [017](B-017-add-a-line-cap-lint-over-skills.md),
[019](B-019-add-a-render-lint-over-the-loop-shape.md) and
[020](B-020-enforce-the-prune-and-validate-every-cite.md). `okf-check` and
`skill-check` cannot reach an ignored page.

## Contract

**One shared walk, at `skills/loop/write-OKF/scripts/_pages.py`.** Both lints
import it and neither keeps a private `pages()`. A sibling module is importable
because `python3 <script>` puts the script's directory on `sys.path`; the
scripts keep their extensionless names and shebangs.

**What the walk yields.** Every `*.md` under the root that **git does not
ignore**, still with **dot-directories and `OKF/blueprints/` skipped**, still
sorted, still as `(page, rel)`. Ignoredness comes from one
`git -C <root> ls-files -z --cached --others --exclude-standard -- '*.md'`
call: tracked plus untracked-but-not-ignored is exactly *not ignored*, so a
page is walked **before it is ever added** — a `.md` census, not a staging
gate.

**Outside a repo git owns, the walk does not shrink.** If the call fails for
any reason — not a git repo, no git on `PATH` — the walk falls back to today's
`rglob`. A lint that goes quiet is worse than one that over-reports, so the
failure mode is the old behaviour, not an empty census.

**Neither lint changes in any other way** — argv shape, `ERROR ` format,
tallies, exit codes 0/1/2, fence handling, link classification, render-site
comparison, all as [023](B-023-add-a-link-lint-over-relative-md-links.md) and
[019](B-019-add-a-render-lint-over-the-loop-shape.md) set them.

**Both superseded blueprints flip status only.** 023 and 019 each state the old
walk in their Contract; that sentence stops being true, so each takes
`superseded-by-026` in frontmatter and on its `OKF/index.md` line. **Their
Contract and Verify are not touched**, per
[022](B-022-validate-every-cite-at-every-status.md) — every clause not re-ruled
above stands as written there. 019 is superseded although the loop shape, its
subject, is untouched: the test is whether a Contract sentence stops being
true, not whether the blueprint's subject moved.

**`HANDOFF.md` stops being a special case.** Its two writing constraints and
024's run condition are lifted; nothing need be written around a lint.

## Seams touched

- `skills/loop/write-OKF/scripts/_pages.py` — **new**: `pages(root)`, its git
  call, and the fallback.
- `skills/loop/write-OKF/scripts/link-check` — imports `pages`, drops its own
  and its now-unused `SKIP`; docstring gains the walk's rule.
- `skills/loop/write-OKF/scripts/render-check` — the same two edits; `SKIP`
  moves, `OWNER`/`SENTINEL`/`RETIRED` stay.
- `OKF/blueprints/023-*.md`, `019-*.md`, `OKF/index.md` — status words only.

## Verify

```sh
cd <repo-root>
LINK=skills/loop/write-OKF/scripts/link-check
REND=skills/loop/write-OKF/scripts/render-check
L='[x](../nonexistent-abc/SKILL.md)'
R=$(grep -m1 '^RETIRED' $REND | cut -d'"' -f2)   # the constant, never quoted

$LINK . && echo "OK link clean" || echo "FAIL link clean"
$REND . && echo "OK rend clean" || echo "FAIL rend clean"

cp HANDOFF.md /tmp/h.bak                          # the ignored page leaves both
printf '\n%s\n%s\n' "$L" "$R" >> HANDOFF.md
$LINK . >/dev/null && echo "OK link skips ignored" || echo "FAIL link skips ignored"
$REND . >/dev/null && echo "OK rend skips ignored" || echo "FAIL rend skips ignored"
cp /tmp/h.bak HANDOFF.md; rm /tmp/h.bak

B=skills/loop/moor/SKILL.md                       # a tracked page is still walked
printf '\n%s\n' "$L" >> $B
$LINK . | grep -q "ERROR $B:" && echo "OK tracked caught" || echo "FAIL tracked caught"
jj restore $B                                     # git: git checkout -- $B

N=OKF/zz-probe.md                                 # walked before any add
printf '# probe\n\n%s\n' "$L" > $N
$LINK . | grep -q "ERROR $N:" && echo "OK new page walked" || echo "FAIL new page walked"
rm $N

T=$(mktemp -d); printf '# t\n\n[x](nope.md)\n' > $T/a.md   # no repo, no shrink
$LINK $T | grep -q 'ERROR a.md' && echo "OK non-git" || echo "FAIL non-git"
rm -rf $T

$LINK . | grep -q 'OKF/blueprints/' && echo "FAIL bp" || echo "OK bp"
$LINK >/dev/null 2>&1; [ $? -eq 2 ] && echo "OK usage" || echo "FAIL usage"
$LINK /nonexistent >/dev/null 2>&1; [ $? -eq 2 ] && echo "OK root" || echo "FAIL root"
```

Every check prints `OK`, no `FAIL` appears, and both clean-tree tallies read
`0 error(s), 0 warning(s)` — with **no run condition**, `HANDOFF.md` left
exactly as the session wrote it.

## Out of scope

- **Skipping backticked spans.** 023 ruled it unreal at 0 live occurrences; the
  census above still reads 0, and this walk removes the only page that wanted
  it. Re-rule it when a *tracked* page needs a link inside backticks.
- **`ROADMAP.md` §Risks & gotchas.** [chart](../../skills/loop/chart/SKILL.md)
  owns that page and has already carried the entry — this blueprint does not
  edit it.
- **`okf-check` and `skill-check`.** Neither walk can reach an ignored page;
  changing them would be a fix to nothing.
- **Absorbing any sibling into one validator** — four scripts sharing one argv
  contract stays [019](B-019-add-a-render-lint-over-the-loop-shape.md)'s shape.
  `_pages.py` is a helper, not a fifth lint: it has no `main`.
- **Honouring `.jjignore` apart from git** — this colocated repo's are git's.
