---
type: Blueprint
status: implemented
traces-to: user request 2026-07-24
sounded: 2026-07-24
---

# 012 — add ferry-level muster, the human review gate at moor

## Justification

The ferry-level half split out of
[010](B-010-add-muster-the-human-review-gate.md) per growth-doctrine
[020](../decisions/R-020-every-page-has-a-growth-path.md): 010 bundled the
weave gate and the moor gate, and the moor gate's `review-base` had no writer
among 010's declared seams. [011](B-011-add-blueprint-level-muster.md) shipped
the weave gate. Sounding (2026-07-24) resolved the base question — the
ferry's `review-base` is **derivable at moor**, so this needs no ferry-skill
seam and no weave coupling. 010 carries the full justification and sounding
of the muster concept; this ships the gate that gives a whole delivered ferry
one human read before moor finalises it.

## Contract

**Opt in on the ferry's `MAP.md`** with `muster: true`. Absent → moor behaves
exactly as today.

**The base is derived at moor.** moor's GATHER SIGNAL already reads `jj log`
since the ferry started and the ferry's blueprint numbers; `review-base` =
the parent of the earliest commit citing one of those blueprints (weave seals
cite `blueprint NNN` — commit-atomic-jj principle 5). moor persists it as
`review-base:` on the collapsed page for the record. Nothing is stored at
generation.

**The gate is moor's first act.** moor halts **after GATHER SIGNAL (2, the
last read-only step), before CONSOLIDATE (3, its first mutation)**: review the
whole-ferry diff `review-base..@` — unioning every blueprint the ferry
spawned — via `hunk patch -` (raw diff fallback). The human records a `tally:`
block. `matches: no` **halts moor before it consolidates, graduates, or
collapses anything**; `matches: yes` → moor proceeds. This is the gate on the
arrival → moor transition: nothing in moor mutates until the human signs off.

**Prose-enforced.** `check_ferries` is shape-only, so `okf-check` does not
gate the ferry tally — halt and tally both live in moor's prose (decision
[017](../decisions/R-017-pin-drift-splits-by-visibility.md): okf-check enforces
only what it can see).

## Seams touched

- `skills/loop/moor/SKILL.md` — a **Muster** step as moor's first act (after
  GATHER SIGNAL, before CONSOLIDATE), guarded by the ferry's `muster: true`;
  derives and persists `review-base`.
- `skills/loop/write-okf/okf-layout.md` — the `muster: true` (+ persisted
  `review-base:`) fields in the ferry-map contract.

## Verify

To settle at lock: a scratch moored-ferry walkthrough — a `muster: true`
ferry halts moor before CONSOLIDATE and refuses to mutate on `matches: no`,
versus a mode-off ferry that moors unchanged. A prose gate resists a
one-command Verify; this is what lock must scrutinise. (`okf-check` has no
ferry-tally rule by design — see Contract.)

## Out of scope

- **Everything 011 owns** — the weave gate, the `okf-check` tally rule, the
  `tally:` block format.
- **A ferry-skill seam** — the base is derived at moor, not stamped at ferry
  generation.
- **Clean isolation of interleaved work** — `review-base..@` is a contiguous
  range, so any non-ferry commit woven between the ferry's blueprints shows in
  the muster diff. Accept for solo / one-ferry-at-a-time; a per-commit union
  is a larger design.
- **1-blueprint muster-ferries** — the ferry muster would re-review the single
  blueprint's diff; use blueprint-level muster (011) there. Flag only
  multi-blueprint ferries.
- **GitHub**, the agent axes, default-mode behaviour, auto-fix — as 011.
