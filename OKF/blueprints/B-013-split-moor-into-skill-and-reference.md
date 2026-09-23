---
type: Blueprint
status: implemented
traces-to: user request 2026-07-24
sounded: 2026-07-24
---

# 013 — split moor into SKILL.md + REFERENCE.md to hold the line cap

## Justification

weave of [012](B-012-add-ferry-level-muster.md) added moor's MUSTER step and
pushed `skills/loop/moor/SKILL.md` to 115 lines, over the repo's ≤110 skill
cap (CLAUDE.md §5). The cap's own remedy is a `REFERENCE.md` split, not
trimming load-bearing prose — the LEARNINGS note of 2026-07-24 records that a
step added to a near-cap skill must price the split. This is that split.

Sieve — **Real**: the file is over a live convention. **Good**: the process
spine stays the one page a moor run reads top-to-bottom; mechanical detail
moves where it stops crowding the steps. **Minimal**: one new file,
cross-linked, no behaviour change. Precedent:
`skills/engineering/write-readme/REFERENCE.md`.

## Contract

`skills/loop/moor/SKILL.md` ends **≤110 lines** and keeps the full process
spine — every numbered step (ORIENT … PRUNE + INDEX), its guard, and its
one-line intent readable without leaving the page. Mechanical detail a step
*invokes but need not inline* — the COLLAPSE `sealed:` / `review-base:` pin
block with its `jj log` template, the GRADUATE frontmatter-move specifics —
moves **verbatim** to a new `skills/loop/moor/REFERENCE.md`, each migrated
block linked from its step. No step, guardrail, or done-criterion is dropped;
moor's behaviour is byte-for-byte the same run. `REFERENCE.md` opens with no
frontmatter — it is skill support, not an OKF page.

## Seams touched

- `skills/loop/moor/SKILL.md` — each step keeps name + intent + guard; inlined
  mechanical detail is replaced by a link into REFERENCE.md.
- `skills/loop/moor/REFERENCE.md` — new; holds the migrated detail.

## Verify

```sh
[ "$(wc -l < skills/loop/moor/SKILL.md)" -le 110 ] && echo "cap ok"
test -f skills/loop/moor/REFERENCE.md && echo "reference exists"
grep -q 'REFERENCE.md' skills/loop/moor/SKILL.md && echo "linked"
```

Expect three lines: `cap ok`, `reference exists`, `linked`. A read confirms
every step name + guard survived in SKILL.md and the moved blocks are intact
in REFERENCE.md.

## Out of scope

- **Any change to moor's behaviour** — pure relocation; a moor run reads the
  same instructions in the same order.
- **Splitting other over-cap skills** — one skill per blueprint.
- **The MUSTER step's semantics** — [012](B-012-add-ferry-level-muster.md) owns
  those; this only relocates prose.
- **okf-check enforcing the skill cap** — it gates OKF pages, not skills; the
  cap stays a prose convention (CLAUDE.md §5).
</content>
</invoke>
