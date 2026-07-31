---
type: Blueprint
status: superseded-by-022
traces-to: user request 2026-07-30
sounded: 2026-07-30
cites:
  - OKF/ROADMAP.md:A live decision can be contradicted
  - OKF/decisions/020-every-page-has-a-growth-path.md:a discharged phase to one
  - OKF/decisions/017-pin-drift-splits-by-visibility.md:pin drift splits by what each tool can see
  - OKF/blueprints/019-add-a-render-lint-over-the-loop-shape.md:Two `okf-check` rules
  - skills/loop/write-OKF/page-warrant.md:cite drift does not split the same way
  - skills/loop/write-OKF/scripts/okf-check:carry their own frontmatter contracts
  - skills/loop/write-OKF/split-page.md
  - skills/loop/chart/SKILL.md
  - skills/loop/chart/revise.md
  - OKF/learnings/index.md:Append-only
---

# 020 — enforce the roadmap prune and validate every page's cites

## Justification

[B-019](019-add-a-render-lint-over-the-loop-shape.md)'s §Out of scope hands
this blueprint two `okf-check` defects by name, both found sounding it and
both in [ROADMAP.md](../ROADMAP.md) §Risks: a live decision with nothing to
enforce it, and a validator skipping the pages it was built to check. Not
phase 10 or 11 — drift against a live
[R-020](../decisions/020-every-page-has-a-growth-path.md).

**The doc edits are not a separate concern.** A prune rule shipped while
[architect](../../skills/loop/architect/SKILL.md) still tells its revision
loop to tick *on* the verify line is a skill teaching a lint violation; the
same holds for a validated `cites:` its own format never declares. A rule
and the doc contradicting it are one unit.

**Sizing the cite hole.** Fixing it turns four cites in three landed
blueprints red — and **all four** were erased by the blueprint that cited
them, two named in B-018's own §Seams. A finding, not a stray repair.

## Contract

**Rule 1 — a discharged phase keeps no verify step.** In a `type: Roadmap`
page, a phase entry — a `^\d+\. ` line plus its continuations, up to the
next such line or the next `## ` heading — carrying both `✅` and
`**Verify:**` is an **ERROR**. R-020's prune has had nothing to enforce it;
this is the mechanical half.

**Rule 2 — every page's cites resolve.** The `continue` at
[`okf-check`](../../skills/loop/write-OKF/scripts/okf-check):245 skips
`blueprints`/`ferries` *before* the cite loop, so no blueprint's or ferry's
cites are validated at all. The resolvability loop moves **above** that
`continue`; the `no cites:` warning stays **below** it, gated to warrant
pages — the format requires `traces-to`, not `cites:`, and eighteen live
pages carry none. Cites validate **whole**, path and symbol, per
[page-warrant.md](../../skills/loop/write-OKF/page-warrant.md): a cite needs
no repo, so it does not split the way
[R-017](../decisions/017-pin-drift-splits-by-visibility.md) splits a pin.

**Four stale cites are repaired**, not exempted: B-014's
`CLAUDE.md:EXAMPLES.md`, B-017's `conjure-a-skill/SKILL.md:is ≤ 110 lines`,
B-018's `steer/SKILL.md:zero context load` and `ROADMAP.md:loop diagram in`.
**Repairing a cite on a locked blueprint is legal** — the format freezes
Contract and Verify, and a cite is a working pointer whose historical form
lives in jj history. With no live target, a cite is dropped, never
repointed at approximate text.

**Rule 3 — architect stops contradicting R-020.** The skeleton line at
`SKILL.md:36` and the done-criterion at `:54` both say *every* phase
carries a verify step; `revise.md:15` sends a discharged phase's tick
*onto* its verify line. Each narrows to the open phase and points at
R-020's pruned form — the `✅ verified <date>, [NNN](…)` shape phase 9
already carries. Neither file may pass 110 (74 and 41 today).

**One `LEARNINGS.md` entry**, believed/true/source: a blueprint's `cites:`
point at the text it is about to change, so validating them makes the
implementing weave the repairer of its own pointers — and the durable
practice is to cite a file the blueprint edits by **path alone**, symbol
omitted. This blueprint cites every file it edits that way.

**`LEARNINGS.md` ends at or under 110 with the entry present.** It sits at
105 and B-019 owes it one too; whichever weave crosses the cap performs
R-020's named move, the split into `learnings/<theme>.md`, per
[split-page.md](../../skills/loop/write-OKF/split-page.md) — pure
relocation, alone in its own change. **Both new rules fire today** — rule 1
on a fixture, rule 2 on the four real cites before repair — and nothing
rendered changes.

## Seams touched

- `skills/loop/write-OKF/scripts/okf-check` — `main()`'s per-page loop
  (rule 2's move) plus one new roadmap check reached from it (rule 1); the
  module docstring's error list names both.
- `skills/loop/architect/SKILL.md` — `:36`, `:54`.
- `skills/loop/architect/revise.md` — `:15`.
- `OKF/blueprints/014-…`, `017-…`, `018-…` — `cites:` frontmatter only.
- `OKF/LEARNINGS.md` — one appended entry, under its cap.

## Verify

```sh
CHECK=skills/loop/write-OKF/scripts/okf-check
"$CHECK" OKF/; echo "real exit: $?"
tmp=$(mktemp -d); cp -r OKF "$tmp/"
for f in skills README.md CLAUDE.md; do ln -s "$PWD/$f" "$tmp/$f"; done
"$CHECK" "$tmp/OKF"; echo "copy exit: $?"
sed -i '48,49s|✅ verified 2026-07-22,|✅ verified 2026-07-22, **Verify:** x,|' \
  "$tmp/OKF/ROADMAP.md"
"$CHECK" "$tmp/OKF" | grep -c 'ROADMAP'; echo "prune exit: $?"
cp OKF/ROADMAP.md "$tmp/OKF/ROADMAP.md"
sed -i 's|^  - OKF/CONTEXT.md:House cap|  - OKF/nope.md:x|' \
  "$tmp/OKF/blueprints/017-add-a-line-cap-lint-over-skills.md"
"$CHECK" "$tmp/OKF" | grep -c 'unresolvable cite'
sed -i '/^cites:/,/^status:/{/^  - /d}' \
  "$tmp/OKF/blueprints/019-add-a-render-lint-over-the-loop-shape.md"
"$CHECK" "$tmp/OKF" | grep -c 'no cites'
rm -rf "$tmp" skills/loop/write-OKF/scripts/__pycache__
grep -n 'every phase\|verify line\|\*\*Verify:\*\*' \
  skills/loop/architect/SKILL.md skills/loop/architect/revise.md
wc -l OKF/LEARNINGS.md skills/loop/architect/SKILL.md \
  skills/loop/architect/revise.md
skills/productivity/conjure-a-skill/scripts/skill-check skills/ | tail -1
```

Expect `0 error(s), 0 warning(s)` / exit 0 on the real tree **after** the
four repairs, and the same on the pristine copy. Then each rule firing
alone: `1` ROADMAP line and exit 1 for the phase that kept its
`**Verify:**`; `1` unresolvable cite from a blueprint — the invisible
class; `0` from stripping a blueprint's cites, proving `no cites:` stayed
gated. Then architect's three lines each scoped to an open phase or naming
R-020's pruned form; all three files under 110; and
`0 error(s), 9 warning(s)` from the sibling.

## Out of scope

- **R-022's prefix lint — blueprint 021.** Its §Consequences names "the
  `okf-check` blueprint" as owner, but a bare three-digit number is also
  `110`, `150` and `SKILL.md:36`; the hard part is exclusion design, not
  placement. Deferred whole.
- **`revise.md:19`**, routing a new gotcha to §Risks where R-013 routes a
  debunked claim to `LEARNINGS.md`. A different decision; untouched.
- **Enforcing a pruned entry's *length*.** R-020 says "one line"; wrapping
  makes that unmechanical, and an invented budget is not the rule.
- **`blueprint-format.md` declaring `cites:`** — it names `traces-to` and
  `sounded:` only, yet every blueprint since B-014 carries a cite rule 2
  now validates. An undeclared *optional* field instructs nobody into
  failure, unlike rule 3's sites; found sounding this one, deferred.
- **`type: Decision` colliding across a ferry `D-n` and a register entry**
  — R-022's unfinished half. **B-018's Verify false-green**, **phase 10's
  F6/F7/F8**, **`ARCHITECTURE.md:20-21`**: carried, untouched.
