---
type: Blueprint
status: draft
traces-to: user request 2026-07-24
---

# 012 — add ferry-level muster, the human review gate at moor

## Justification

The ferry-level half split out of
[010](010-add-muster-the-human-review-gate.md) per growth-doctrine
[020](../decisions/020-every-page-has-a-growth-path.md), because it needs a
seam 010 never declared: the ferry's `review-base` has no writer among 010's
seams, and planting it at ferry generation touches the `ferry` skill.
[011](011-add-blueprint-level-muster.md) shipped the weave gate; this ships
the moor gate so a whole delivered ferry gets one human read before it moors.

## Contract

**Opt in on the ferry's `MAP.md`** with `muster: true`. The `ferry` skill, at
generation, records `review-base:` on the `MAP.md` — the parent of where the
ferry's first blueprint begins. Absent → moor behaves exactly as today.

**The gate halts moor** after GATHER SIGNAL, before COLLAPSE: the whole ferry
diff `review-base..@` is reviewed via `hunk patch -` (raw diff fallback),
unioning every blueprint the ferry spawned. The human records a `tally:`
block on the collapsed page; `matches: no` stays halted for a fix +
re-muster. The ferry-level tally is **prose-enforced at moor** —
`check_ferries` is shape-only, so okf-check does not gate it.

## Seams touched

- `skills/loop/ferry/SKILL.md` — records `review-base` on `MAP.md` at
  generation when `muster: true`.
- `skills/loop/moor/SKILL.md` — a **Muster** step before COLLAPSE, guarded by
  the ferry's `muster: true`.
- `skills/loop/write-OKF/okf-layout.md` — the new fields in the ferry-map
  contract.

## Verify

To be settled at sound: a scratch moored-ferry walkthrough showing moor halts
before COLLAPSE on `muster: true` and records the tally, versus a mode-off
ferry that moors unchanged. A prose-gate resists a one-command Verify — this
is what lock must scrutinise.

## Out of scope

- **Everything 011 owns** — the weave gate, the `okf-check` tally rule, the
  `tally:` block format.
- **GitHub**, the agent axes, default-mode behaviour, auto-fix — as 011.
