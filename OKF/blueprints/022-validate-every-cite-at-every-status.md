---
type: Blueprint
status: implemented
traces-to: user request 2026-07-31 (B-020 stranded by the learnings/ split)
sounded: 2026-07-31
cites:
  - OKF/blueprints/020-enforce-the-prune-and-validate-every-cite.md
  - OKF/blueprints/021-align-validator-and-doctrine.md
  - OKF/learnings/loop.md
  - OKF/index.md
  - skills/loop/write-OKF/scripts/okf-check
  - skills/loop/chart/SKILL.md
  - skills/loop/chart/revise.md
  - OKF/ROADMAP.md:A live decision can be contradicted
  - OKF/decisions/020-every-page-has-a-growth-path.md:a discharged phase to one
  - OKF/decisions/017-pin-drift-splits-by-visibility.md:pin drift splits by what each tool can see
  - skills/loop/write-OKF/page-warrant.md:cite drift does not split the same way
  - skills/loop/blueprint/blueprint-format.md:sections are immutable
---

# 022 — enforce the roadmap prune and validate every cite at every status

## Justification

[B-020](020-enforce-the-prune-and-validate-every-cite.md) is **locked and
stranded**: its immutable §Verify runs `wc -l` over `OKF/LEARNINGS.md`, a
path [B-021](021-align-validator-and-doctrine.md) deleted in the split to
`OKF/learnings/`. Its defects are still in the tree and supersession is the
only exit, per the learning B-021 filed at
[learnings/loop.md](../learnings/loop.md).

**Two things changed under it.** B-021 landed B-020's deferred halves —
R-022's prefix lint and `cites:` declared in `blueprint-format.md` — and took
the cite hole from four stale cites to **nine**, three from the split, one on
a blueprint already `implemented`: a ruling B-020 never had to make.

## Contract

**Rule 1 — a discharged phase keeps no verify step.** In a `type: Roadmap`
page, a phase entry — a `^\d+\. ` line plus its continuations, up to the next
such line or the next `## ` heading — carrying both `✅` and `**Verify:**` is
an **ERROR**: the mechanical half R-020's prune never had. As in B-020.

**Rule 2 — every page's cites resolve.** The `continue` at
[`okf-check`](../../skills/loop/write-OKF/scripts/okf-check):272 skips
`blueprints`/`ferries` *before* the cite loop, so no blueprint's or ferry's
cites are validated at all. The resolvability loop moves **above** that
`continue`; the `no cites:` warning stays **below** it, gated to warrant
pages — the format requires `traces-to`, not `cites:`. Cites validate
**whole**, path and symbol, per
[page-warrant.md](../../skills/loop/write-OKF/page-warrant.md): a cite needs
no repo, so it does not split the way
[R-017](../decisions/017-pin-drift-splits-by-visibility.md) splits a pin.

**Rule 3 — the rule reaches backwards, and status buys no exemption.** A
cite is validated wherever it appears, at `draft`, `locked`, `implemented`
and `superseded-by-NNN` alike. `blueprint-format.md` freezes a locked
blueprint's **Contract and Verify**; `cites:` is neither — it is a working
pointer whose form at lock is already in jj history, so repairing it destroys
nothing. Exempting `implemented` leaves the oldest, largest body of cites
unchecked forever; grandfathering "resolved at lock" asks for a fact about
the past that the tree does not carry.

**Nine stale cites are repaired**, not exempted — **repointed** at live text
making the same claim, **dropped** when the claim is gone, never repointed at
approximate text. Dropped: B-014 `CLAUDE.md:EXAMPLES.md` (file gone); B-018
`steer/SKILL.md:zero context load` (that page no longer says *context*);
B-018 `ROADMAP.md:loop diagram in` and B-019 `ROADMAP.md:checked by script`
(erased when phase 11 discharged). Repointed: B-017
`conjure-a-skill/SKILL.md:is ≤ 110 lines`, live at `:55`; B-019
`write-OKF/SKILL.md:run and its output pasted`, live at `:84`; B-019 and
B-020 `OKF/LEARNINGS.md:Append-only` and B-021 `OKF/LEARNINGS.md`, all onto
`OKF/learnings/index.md`, the page the split renamed it to.

**Rule 4 — architect stops contradicting R-020.** `SKILL.md:36` and `:54`
both say *every* phase carries a verify step; `revise.md:15` sends a
discharged phase's tick *onto* its verify line. Each narrows to the open
phase and points at R-020's pruned form — the `✅ verified <date>, [NNN](…)`
shape phases 9 and 11 already carry. Neither file may pass 110 (74, 41).

**B-020 flips to `superseded-by-022`** in its frontmatter and on its
`OKF/index.md` line; its Contract and Verify are not touched.

**One [learnings/loop.md](../learnings/loop.md) entry**, believed/true/source:
a blueprint's `cites:` point at the text it is about to change, so validating
them makes the implementing weave the repairer of its own pointers — the
durable practice is to cite a file the blueprint edits by **path alone**, as
every path cite above does. **Both new rules fire today** — rule 1 on a fixture,
rule 2 on the nine real cites before repair — and nothing rendered changes.

## Seams touched

- `skills/loop/write-OKF/scripts/okf-check` — `main()`'s per-page loop (rule
  2's move), one new roadmap check reached from it (rule 1), the docstring.
- `skills/loop/architect/SKILL.md` `:36`, `:54`; `revise.md` `:15`.
- `OKF/blueprints/014-…`, `017-…`, `018-…`, `019-…`, `021-…` — `cites:`
  frontmatter only; `020-…` — `cites:` and `status:` only.
- `OKF/learnings/loop.md` — one appended entry, under its cap.
- `OKF/index.md` — B-020's status, plus this blueprint's own line.

## Verify

```sh
CHECK=skills/loop/write-OKF/scripts/okf-check
"$CHECK" OKF/; echo "real exit: $?"
tmp=$(mktemp -d); cp -r OKF "$tmp/"
for f in skills README.md CLAUDE.md; do ln -s "$PWD/$f" "$tmp/$f"; done
"$CHECK" "$tmp/OKF"; echo "copy exit: $?"
sed -i 's|✅ verified 2026-07-22,|✅ verified 2026-07-22, **Verify:** x,|' \
  "$tmp/OKF/ROADMAP.md"
"$CHECK" "$tmp/OKF" > "$tmp/prune.log"; echo "prune exit: $?"
grep -c 'ROADMAP' "$tmp/prune.log"
cp OKF/ROADMAP.md "$tmp/OKF/ROADMAP.md"
sed -i '0,/^cites:/s|^cites:|cites:\n  - OKF/nope.md:x|' \
  "$tmp/OKF/blueprints/017-add-a-line-cap-lint-over-skills.md"
"$CHECK" "$tmp/OKF" | grep -c 'unresolvable cite'
sed -i '/^cites:/,/^---$/{/^  - /d}' \
  "$tmp/OKF/blueprints/019-add-a-render-lint-over-the-loop-shape.md"
"$CHECK" "$tmp/OKF" | grep -c 'no cites'
rm -rf "$tmp" skills/loop/write-OKF/scripts/__pycache__
grep -n 'every phase\|verify line\|\*\*Verify:\*\*' \
  skills/loop/architect/SKILL.md skills/loop/architect/revise.md
grep -h '^status:' OKF/blueprints/020-*.md
wc -l OKF/learnings/loop.md skills/loop/architect/SKILL.md \
  skills/loop/architect/revise.md
skills/productivity/conjure-a-skill/scripts/skill-check skills/ | tail -1
```

Expect `0 error(s), 0 warning(s)` / exit 0 on the real tree **after** the
nine repairs, and the same on the pristine copy. Then each rule alone:
`prune exit: 1` with `1` ROADMAP line; `1` unresolvable cite from a
blueprint — the invisible class; `0` from stripping a blueprint's cites,
proving `no cites:` stayed gated. Then architect's three lines each scoped
to an open phase or naming R-020's pruned form; `superseded-by-022` on
B-020; all three files under 110; `0 error(s), 9 warning(s)` from the
sibling.

## Out of scope

- **Enforcing a pruned entry's *length*.** R-020 says "one line"; wrapping
  makes that unmechanical, and an invented budget is not the rule.
- **The eight out-of-bundle pointers still naming `OKF/LEARNINGS.md`** —
  prose links in `AGENTS.md`, `CONTEXT.md` and six skills. Some are correct
  for a repo that has not split; the triage is not this rule's.
- Carried, untouched: **validating a `traces-to`** (no decision form);
  **`revise.md:19`**, routing a new gotcha where R-013 routes a debunked
  claim; **`type: Decision` colliding** across a ferry `D-n` and a register
  entry; **B-018's Verify false-green**; **phase 10's F6/F7/F8**;
  **`ARCHITECTURE.md:20-21`**.
