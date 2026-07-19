---
name: ferry
description: Carry work too big for one session across the gap — map it as a directory of small decision files with blocking edges under OKF/ferries/<topic>/, then resolve one decision per sitting until the way is clear.
disable-model-invocation: true
---

# ferry

Matt Pocock's wayfinder, file-based. For work **more than one agent
session can hold**: don't plan it in one heroic sitting — map the
*decisions* it needs, edge them, resolve them one at a time. The ferry
directory is what crosses the session boundary.

## When to use
- User says "ferry", "/ferry", "this is too big for one session",
  "map this feature out".
- An [architect](../architect/SKILL.md) phase or
  [blueprint](../blueprint/SKILL.md) attempt turns out too large to blueprint
  as one implementable unit.
- A [write-handoff](../../productivity/write-handoff/SKILL.md) is looming on a
  half-decided design — ferry the open questions instead of prose-dumping
  them.

## Process
1. **Name the destination** — one sentence: what "the way is clear"
   means (all decisions resolved → blueprints exist → weave can run).
2. **Create `OKF/ferries/<topic>/`** with `MAP.md`: destination
   sentence + decision list (`D-1 — title — status — blocked-by`).
3. **Write decision files** `D-<n>-<slug>.md` per
   [decision-format.md](decision-format.md). Small: one genuine
   decision each — if a "decision" is really three, split it. Declare
   `blocked-by:` edges honestly; no edge, no ordering claim.
4. **Resolve one decision per sitting.** Pick an unblocked one. Grill it
   [grill-with-docs](../../engineering/grill-with-docs/SKILL.md)-style
   — research first, one question at a time, recommendation attached.
   Record resolution + rationale in the file; flip status.
5. **Crystallise as you go**: a resolved decision that unlocks
   implementable work → hand to [blueprint](../blueprint/SKILL.md);
   the blueprint's `traces-to` cites `ferries/<topic>/D-<n>`. Resolved terms →
   `OKF/CONTEXT.md` per model-domain.
6. **Arrive**: every decision resolved → update `MAP.md` with the blueprint
   numbers produced; the ferry directory stays as the decision record
   (supersede, don't delete).

## Session boundary
End of sitting → `MAP.md` *is* the handoff for this work: next session
reads MAP.md, picks the next unblocked decision. Don't duplicate ferry
state into HANDOFF.md — reference the directory
([write-handoff](../../productivity/write-handoff/SKILL.md) rule).

## Output / done criteria
- `MAP.md` lists every decision with status and edges; no cycles.
- Each sitting resolves ≥1 decision or records why it's blocked on the
  user/world.
- Every resolved decision has rationale; every spawned blueprint traces back.

## Guardrails
- **Never** resolve a decision whose `blocked-by` set has open members.
- **Never** batch-resolve — one decision per sitting keeps each one
  actually grilled, not rubber-stamped.
- **Never** put implementation or code in ferry files — decisions only.
- **Never** delete a resolved decision — it's the why-record
  (append-only history, like architect's locked decisions).

## See also
- [decision-format.md](decision-format.md) — file contract.
- [../blueprint/SKILL.md](../blueprint/SKILL.md) — downstream of every
  resolution.
- [../architect/SKILL.md](../architect/SKILL.md) — phases too big to
  blueprint directly get ferried.
