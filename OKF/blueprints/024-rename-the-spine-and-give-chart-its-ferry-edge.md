---
type: Blueprint
status: locked
traces-to: ROADMAP.md phase 12
sounded: 2026-07-31
cites:
  - OKF/ROADMAP.md:the spine gets nautical names
  - OKF/ARCHITECTURE.md
  - skills/loop/architect/SKILL.md
  - skills/loop/weave/SKILL.md
  - skills/loop/ferry/SKILL.md
  - skills/loop/steer/SKILL.md
  - skills/loop/write-OKF/scripts/render-check
  - OKF/blueprints/022-validate-every-cite-at-every-status.md
  - OKF/learnings/loop.md
  - OKF/decisions/019-recon-may-self-fire.md
---

# 024 — rename the spine to chart and rig, and give chart its ferry edge

## Justification

[ROADMAP.md](../ROADMAP.md) phase 12, its **Precondition** cleared by
[023](023-add-a-link-lint-over-relative-md-links.md). `architect` and `weave`
are the only spine skills named for a trade, not a passage — unlike ferry,
moor, sound, call-charon and steer.

**The rename is not the risk; the pointers are.** A directory rename silently
breaks four kinds of pointer, each caught by a different check or by none:
**26 relative links** across **24 files** (`link-check`); **9 `cites:`** —
live at `decisions/002:7`, `005:7`, `learnings/loop.md:8`, sealed at
`018:16,18`, `020:14-15`, `022:12-13` (`okf-check`); **`render-check`'s
`RETIRED` constant** at `:23`, a string and not a link yet a hit for the
phase's own grep; and **two symlinks** in `~/.claude/skills/`, checked by
nothing.

**Sealed pages move their cites, and only their cites.**
[022](022-validate-every-cite-at-every-status.md) settled it: *a cite is a
working pointer, so every page carries the rule at every status — a
blueprint's `cites:` are not frozen by lock*. The nine repairs are therefore
obligations, not append-only violations — while the *prose* of those same
pages (`020:93-94`, `022:95`, `010:103`, `011:74`, every `Source: weave of
blueprint N`) is the record and stays. Frontmatter moves, body does not.

**Four implemented Verifies name what this deletes** — `018` and `019` the
strings `weave = bdd` and `architect → blueprint`, `020` and `022` the path
`skills/loop/architect/…`. [learnings/loop.md](../learnings/loop.md) records
that a blueprint moving a path owes this census, and that B-019 was stranded
so by B-021. All four are `implemented`: never run again, never repairable.

**The honest fork.** `ferry` names `architect` three times; `architect` names
`ferry` never — so a phase too big to blueprint has no documented exit from
the skill that wrote it. Phase 12 rules the edge is opened by `chart` itself,
**never** by flipping ferry's `disable-model-invocation`, since
[019](../decisions/019-recon-may-self-fire.md) exempts read-only recon only.

## Contract

**`architect` becomes `chart`; `weave` becomes `rig`.** Directory
`skills/loop/<new>/`, frontmatter `name:`, `# <heading>`, every occurrence in
any `description:`, and every word-boundary use in prose across `skills/`,
`README.md` and the live OKF pages. Where the old word carried a verb sense
the new one does not (`mid-weave`, `weaves`), the sentence is rephrased, not
substituted. Sibling files (`greenfield.md`, `revise.md`) move with the
directory under their existing names.

**The 26 links** repoint to `…/chart/` and `…/rig/`; only the last segment
moves, so `../../loop/weave/…` from `engineering/` keeps its depth.

**Flow 1 and its two byte-copies** — [ARCHITECTURE.md](../ARCHITECTURE.md)
§Main flows, `README.md` §loop, `steer` §The loop — change names only; the
box-drawing shape, the yes/no fork and the 1-vs-N executor fork are unchanged,
and `render-check` proves the three stay identical. **§Module map** also drops
*"Blueprint, ferry, weave, steer land per ROADMAP.md"* — all four shipped.

**`render-check`'s `RETIRED` becomes `"chart → blueprint"`.** It guards the
retired *flat* form — a spine with no fork — and after the rename that form
can only be hand-copied back under the new name. Both literals survive only in
`OKF/blueprints/`, which `render-check` skips.

**Eleven `cites:` repoint** — the nine above (`018`'s two keeping their
surviving `:symbol` suffixes) **plus this blueprint's own two**: it cites what
it edits by path alone, per `learnings/loop.md`, so the run that lands it
repairs its own pointers before the tally is read.

**`chart` gains the ferry edge** as prose, not a new fork in the diagram: a
phase whose arc spans more than one blueprint or session hands to
[ferry](../../skills/loop/ferry/SKILL.md), and `chart`'s See-also names it.
`chart` also states the **single-request terminal as designed** — a lone
request traces to `user request <date>` and opens no phase
([ROADMAP.md](../ROADMAP.md) §Phases), so its absence reads as a rule, not a
gap. Ferry's `disable-model-invocation` stays `true`.

**The two symlinks** `~/.claude/skills/{architect,weave}` become
`{chart,rig}` on the new directories; the old two are removed, not dangling.

## Seams touched

- `skills/loop/chart/`, `skills/loop/rig/` — the two skill interfaces:
  frontmatter `name:`/`description:`, SKILL.md body, directory path.
- `skills/loop/chart/SKILL.md` — the ferry hand-off and the single-request
  terminal, in §Shared rules and §See also.
- `OKF/ARCHITECTURE.md` flow 1 — the canonical render, plus its byte-copy
  sites in `README.md` and `steer/SKILL.md`.
- `skills/loop/write-OKF/scripts/render-check` — the `RETIRED` constant.
- Frontmatter `cites:` on `OKF/decisions/002`, `005`, `learnings/loop.md`,
  `OKF/blueprints/018`, `020`, `022`, `024`.

## Verify

```sh
cd <repo-root>; S=skills/loop/write-OKF/scripts; K=~/.claude/skills
$S/link-check . ; $S/render-check . ; $S/okf-check OKF/
skills/productivity/conjure-a-skill/scripts/skill-check skills/ | tail -1
grep -rniw 'architect\|weave' skills/ README.md AGENTS.md && echo "FAIL names" || echo "OK names"
[ -d skills/loop/chart ] && [ -d skills/loop/rig ] && echo "OK dirs" || echo "FAIL dirs"
[ ! -e skills/loop/architect ] && [ ! -e skills/loop/weave ] && echo "OK old" || echo "FAIL old"
grep -qx 'name: chart' skills/loop/chart/SKILL.md &&
  grep -qx 'name: rig' skills/loop/rig/SKILL.md && echo "OK fm" || echo "FAIL fm"
[ "$(readlink $K/chart)" = "$PWD/skills/loop/chart" ] &&
  [ "$(readlink $K/rig)" = "$PWD/skills/loop/rig" ] && echo "OK sym" || echo "FAIL sym"
[ ! -L $K/architect ] && [ ! -L $K/weave ] && echo "OK unsym" || echo "FAIL unsym"
grep -q '\.\./ferry/SKILL\.md' skills/loop/chart/SKILL.md && echo "OK edge" || echo "FAIL edge"
grep -qx 'disable-model-invocation: true' skills/loop/ferry/SKILL.md && echo "OK ferry" || echo "FAIL ferry"
```

`link-check`, `render-check` and `okf-check` each print
`0 error(s), 0 warning(s)`; `skill-check` prints `0 error(s), 9 warning(s)`;
every other line prints `OK`, no `FAIL` appears. **Run condition:** clear
gitignored `HANDOFF.md` first — `link-check` walks it (see §Out of scope).

## Out of scope

- **Repairing the four stranded Verify blocks** (`018`–`020`, `022`).
  Immutable and `implemented`; the census above is the deliverable.
- **Sealed prose naming the old skills** — `020:93-94`, `022:95`, `010:103`,
  `011:74`, `decisions/002`'s title and filename, every `Source: weave of
  blueprint N`, `index.md:36`. The phase's grep spans `skills/`, `README.md`
  and `AGENTS.md` only; the record says what was true when written.
- **The nine live pre-split `OKF/LEARNINGS.md` pointers**, one in
  `weave/SKILL.md:54` — a separate census, carried by `HANDOFF.md`.
- **Teaching `link-check` to skip gitignored files or backticked spans.**
  [023](023-add-a-link-lint-over-relative-md-links.md) ruled inline-code spans
  unreal; `HANDOFF.md` makes them real, but that Contract is sealed — the fix
  is a supersession, not a line in a rename.
- **Any change to the loop's shape** — no fork added or removed, no
  `disable-model-invocation` flipped. Names, and one documented hand-off.
- **Renaming any other skill, or flattening `skills/<category>/`** — phase 14.
- **Glossary entries for `chart`/`rig`** beyond the one word at
  `CONTEXT.md:38` — neither is contested, and the page is at 109/110.
