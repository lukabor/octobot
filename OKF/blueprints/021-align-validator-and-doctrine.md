---
type: Blueprint
status: locked
traces-to: user request 2026-07-30 (the split drift); B-020 §Out of scope
sounded: 2026-07-30
cites:
  - skills/loop/write-OKF/split-page.md
  - skills/loop/write-OKF/okf-layout.md
  - skills/loop/write-OKF/scripts/okf-check
  - skills/loop/blueprint/blueprint-format.md
  - OKF/decisions/022-prose-cites-carry-a-register-prefix.md
  - OKF/LEARNINGS.md
  - OKF/index.md
  - OKF/decisions/020-every-page-has-a-growth-path.md:alone **splits**
  - OKF/blueprints/020-enforce-the-prune-and-validate-every-cite.md:declaring `cites:`
---

# 021 — align the validator and the doctrine on splits, prefixes and cites

## Justification

Three sites where doctrine and `okf-check` disagree, found sounding
[B-020](020-enforce-the-prune-and-validate-every-cite.md): doctrine
instructing into a validator error, doctrine with no validator, and a
validated field no format declares — the defect class B-020's
§Justification names when it refuses to ship a rule beside the doc
contradicting it.

**The first is load-bearing today.**
[split-page.md](../../skills/loop/write-OKF/split-page.md) §Rewiring the
index says the capped page keeps its name and becomes its subpages' index;
`okf-check`'s `reachable()` propagates only through pages named `index.md`
or `MAP.md`, so `learnings/<theme>.md` linked from `LEARNINGS.md` errors
*not reachable from index.md*. Proved by running the validator over a
copied tree, not by reading it.
[R-020](../decisions/020-every-page-has-a-growth-path.md) grants every page
kind a growth path; this one cannot be taken. `LEARNINGS.md` sits at
exactly 110, so the next entry meets the drift.

## Contract

**Rule 1 — the split renames the parent.** `split-page.md` §Rewiring the
index and `okf-layout.md`'s `LEARNINGS.md` contract both say: at cap+1 the
parent moves to `<theme-dir>/index.md`, subpages land beside it, and
`index.md`'s single line repoints at the new parent. Reachability then
holds through the existing `index.md` rule — **`reachable()` is not
touched.** Widening it to follow any page's links was rejected: the
spine guarantee (every page hangs off the map) is what the narrow rule
buys, and a split is rare enough to pay a rename instead.

**`LEARNINGS.md` splits, under this blueprint, into `learnings/`.** This
blueprint owes an entry, the page is at 110, so R-020's cap+1 trigger
fires — the doctrine is proved by running it, not by fixture. The split is
**pure relocation, alone in its own change**: sixteen entries in, sixteen
out, nothing reworded or resequenced. Themes are named for the layer each
entry forces to change, per split-page.md §Choosing the axis; the names
are the weave's, not this blueprint's. `learnings/index.md` carries
`type: Index` like `decisions/index.md`; theme pages carry
`type: Learnings` and the append-only contract each.

**Rule 2 — an unprefixed register cite in prose is an ERROR.** A bare
three-digit run matching an existing `blueprints/NNN-` or `decisions/NNN-`
file, in the body of a root page or a `decisions/` page, is
[R-022](../decisions/022-prose-cites-carry-a-register-prefix.md)'s
ambiguity unenforced. Exclusions are the rule's hard half, all mechanical:
frontmatter, fenced blocks, code spans, markdown link text and targets, a
number touching `/`, `-`, `.` or a word character (so a path or
`superseded-by-020` never fires), the page's own `# NNN — …` H1, and
`type: Learnings` pages — R-022 §Consequences exempts the append-only
register, and typing the exemption survives rule 1's rename. Blueprints
and ferries are outside the check for the same reason their warrants are:
a locked blueprint's prose cannot be legally repaired. **One live site
fires** — R-022's own example sentence naming the collided numbers —
repaired with code spans, which is what the rule already permits.

**Rule 3 — `blueprint-format.md` declares `cites:`.** It names `traces-to`
and `sounded:` only, while every blueprint since B-014 but B-015 carries a
`cites:` that B-020 makes the validator enforce. Declared as **optional**
— B-015 is why — with the cite grammar owned by
[okf-layout.md](../../skills/loop/write-OKF/okf-layout.md) and referenced,
not restated.

**Nothing rendered by `render-check` changes**, and every touched file
stays under its cap.

## Seams touched

- `skills/loop/write-OKF/scripts/okf-check` — one new check reached from
  `main()`'s per-page loop, plus the module docstring's error list.
  `reachable()` unchanged.
- `skills/loop/write-OKF/split-page.md` — §Rewiring the index.
- `skills/loop/write-OKF/okf-layout.md` — the tree comment on
  `LEARNINGS.md` and its page contract.
- `skills/loop/blueprint/blueprint-format.md` — skeleton + one Rules bullet.
- `OKF/decisions/022-…` — one sentence, code spans only.
- `OKF/LEARNINGS.md` → `OKF/learnings/` — relocation, own change.
- `OKF/index.md` — one line repointed.

## Verify

```sh
CHECK=skills/loop/write-OKF/scripts/okf-check
"$CHECK" OKF/; echo "real exit: $?"
skills/loop/write-OKF/scripts/render-check .
ls OKF/LEARNINGS.md; ls OKF/learnings/
grep -c '^- Believed:' OKF/learnings/*.md | awk -F: '{s+=$2} END{print "entries:",s}'
grep -n 'learnings/index.md' OKF/index.md
tmp=$(mktemp -d); cp -r OKF "$tmp/"
for f in skills README.md CLAUDE.md; do ln -s "$PWD/$f" "$tmp/$f"; done
"$CHECK" "$tmp/OKF"; echo "copy exit: $?"
printf '\nA bare 017 standing in prose.\n' \
  >> "$tmp/OKF/decisions/012-one-why-register.md"
"$CHECK" "$tmp/OKF" | grep -c 'unprefixed register cite'
rm -rf "$tmp" skills/loop/write-OKF/scripts/__pycache__
grep -n 'index.md' skills/loop/write-OKF/split-page.md | head -5
grep -n 'cites' skills/loop/blueprint/blueprint-format.md
wc -l skills/loop/write-OKF/split-page.md skills/loop/write-OKF/okf-layout.md \
  skills/loop/blueprint/blueprint-format.md OKF/learnings/*.md OKF/index.md
skills/productivity/conjure-a-skill/scripts/skill-check skills/ | tail -1
```

Expect `0 error(s), 0 warning(s)` and exit 0 from `okf-check` on the real
tree and on the copy, and the same from `render-check`; `ls` reporting
`LEARNINGS.md` gone and `learnings/` populated; `entries: 16`, the count
before; `index.md` pointing at `learnings/index.md`. Then the lint alone:
`1` unprefixed cite from the injected line, against a **clean pristine
copy** — every H1, path, link and `type: Learnings` entry carrying a bare
number is an exclusion the copy's `0 errors` already proves. Then
split-page.md naming the `<theme-dir>/index.md` move, `blueprint-format.md`
naming `cites:`, all listed files under their caps, and
`0 error(s), 9 warning(s)` from the sibling.

## Out of scope

- **B-020's supersession.** Rule 1 deletes `OKF/LEARNINGS.md`, which
  B-020's **immutable** §Verify runs `wc -l` over and its §Contract pins
  the entry to; B-020 is therefore unimplementable as written and is owed
  a superseding blueprint against the `learnings/` paths. Named here,
  done there — B-020 was sounded before the drift was understood.
- **Prefix lint over `skills/` prose.** R-022's retrofit touched
  `moor/SKILL.md` and `build-r-package/SKILL.md`; `okf-check`'s domain is
  the OKF bundle, so the skills half would belong to `skill-check`.
- **Register numbers reaching 100.** Rule 2's number set would then hold
  `110` and `150`, colliding with the caps quoted in prose. A known limit
  ~80 blueprints out, not an invented exclusion today.
- **`type: Decision` colliding across a ferry `D-n` and a register entry**
  — R-022's unfinished half. **Phase 10's F6/F7/F8**,
  **`ARCHITECTURE.md:20-21`**, **B-018's Verify false-green**: carried,
  untouched.
