---
type: Blueprint
status: locked
traces-to: ROADMAP.md phase 15
sounded: 2026-09-23
cites:
  - OKF/ROADMAP.md
  - OKF/decisions/024-register-filenames-carry-their-prefix.md
  - OKF/decisions/022-prose-cites-carry-a-register-prefix.md
  - OKF/decisions/016-one-okf-check-validator.md
  - OKF/decisions/009-index-is-the-page-plan.md
  - OKF/decisions/015-moor-collapses-ferry-directory.md
  - OKF/decisions/020-every-page-has-a-growth-path.md
  - skills/loop/write-OKF/scripts/okf-check
  - OKF/index.md
  - OKF/decisions/index.md
  - OKF/learnings/index.md
muster: true
review-base: pxryqqmw
---

# 029 — validate OKF directory completeness and normalize blueprints/ferries indexing

## Justification
[ROADMAP.md phase 15](../ROADMAP.md) opens this arc; this blueprint is its
first piece. [024](../decisions/024-register-filenames-carry-their-prefix.md)
rules that decision and blueprint filenames carry their `R-`/`B-` prefix
going forward, superseding
[022](../decisions/022-prose-cites-carry-a-register-prefix.md)'s
bare-filename ruling. That decision's own Consequences note the gap this
blueprint closes: `blueprints/` and `ferries/` have no `index.md` today —
`OKF/index.md` inlines their listings directly instead — so a
filename-search workflow (`ls OKF/blueprints/ | grep B-`) has nowhere
directory-local to land for those two, unlike `decisions/` and
`learnings/`, which already delegate. [016](../decisions/016-one-okf-check-validator.md)
rules a single `okf-check` validator carries OKF conformance, so the two
new checks this blueprint adds extend it rather than starting a sibling
script. The retroactive rename of existing `NNN-<slug>.md` files to
`R-NNN-`/`B-NNN-<slug>.md` and the repo-wide link repair it requires is
**out of scope here** — a separate, later blueprint in the same phase.

## Contract
`okf-check` gains two errors, scoped to `OKF/` only (not `skills/`, which
keeps its `SKILL.md` entry-point convention untouched):

1. **Missing directory entry point.** Every directory under `OKF/` that
   contains at least one `.md` file must itself contain an `index.md` —
   *except* an open ferry topic directory (`OKF/ferries/<topic>/`, per
   [015](../decisions/015-moor-collapses-ferry-directory.md)), which
   satisfies this with `MAP.md` instead; a moored ferry is a single file,
   not a directory, so it never triggers this check.
2. **Incomplete `index.md`.** Every `index.md` (not `MAP.md`, which has
   its own D-n table format and is unaffected by this check) must
   directly link every `.md` file that is a physical sibling in its own
   directory — a page missing from its own directory's `index.md` is an
   error, independent of `okf-check`'s existing transitive
   reachable-from-root check, which this does not replace.

`OKF/index.md`'s `## Blueprints` and `## Ferries` sections stop inlining
every entry; each becomes one summary line + a link to a new
`blueprints/index.md` / `ferries/index.md`, matching the `## Decisions` /
learnings pattern already in `OKF/index.md`. `blueprints/index.md` lists
every blueprint (`NNN — <title> — <status>`, mirroring
`OKF/index.md`'s current inline line shape); `ferries/index.md` lists
every ferry (open topics linking their `MAP.md`, moored ones linking the
collapsed page), mirroring the current inline `## Ferries` section this
replaces.

## Seams touched
- `skills/loop/write-OKF/scripts/okf-check` — two new check functions,
  parallel in shape to the existing `reachable()` check.
- `OKF/blueprints/index.md` — new file.
- `OKF/ferries/index.md` — new file.
- `OKF/index.md` — `## Blueprints` and `## Ferries` sections replaced with
  summary + link.

## Verify
```
skills/loop/write-OKF/scripts/render-check .
skills/loop/write-OKF/scripts/okf-check OKF/
skills/loop/write-OKF/scripts/link-check .
skills/productivity/conjure-a-skill/scripts/skill-ref-check skills/
```
All four `0 error(s)`, and `okf-check` errors (verified by a temporary
probe: a directory or `index.md` deliberately missing an entry) on
exactly the two new conditions this blueprint adds — confirming the
checks fire, not just that the tree happens to pass.

## Out of scope
- Renaming any existing `OKF/decisions/NNN-*.md` or `OKF/blueprints/NNN-*.md`
  file to its `R-`/`B-`-prefixed form, and the repo-wide link repair that
  rename requires — the next blueprint in phase 15.
- `skills/loop/blueprint/SKILL.md`'s numbering step and `okf-check`'s own
  number-extraction regex accounting for the new prefix — needed once
  files are actually renamed, so it belongs with that same later
  blueprint, not this one.
- Any change to `skills/` — it keeps `SKILL.md` as its entry-point file;
  this blueprint's `index.md` requirement is `OKF/`-scoped only.
- Retrofitting bare, unlinked prose numbers in `OKF/LEARNINGS.md` /
  `OKF/learnings/` — untouched per 022's precedent, unchanged by 024.
