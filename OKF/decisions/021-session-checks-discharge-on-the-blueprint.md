---
type: Decision
purpose: Give a check the sealing session cannot run one place to be recorded and one place to be discharged.
answers:
  - "Where is a discharged-session check recorded?"
cites:
  - skills/loop/blueprint/blueprint-format.md
  - OKF/blueprints/007-add-sound.md
  - OKF/ROADMAP.md
status: live
reversible: yes — strike the stamps; the checks they record stay in §Verify
---

# 021 — a session check discharges on its own blueprint

Some Verify checks a script cannot make — fresh-session behaviour, a
missing MCP server, a self-fire leaving its file byte-identical — so they
ride later sessions and are discharged one at a time. That record belongs
on the blueprint that wrote the check, appended to the numbered check
itself as `✅ <date> (<what discharged it> — <what was observed>)`, with
`⏳ pending` standing until then. `ROADMAP.md` keeps no discharge prose:
a phase line names its blueprint and stops.

The rule in
[blueprint-format.md](../../skills/loop/blueprint/blueprint-format.md)
that a locked blueprint's Verify is immutable is narrowed, not broken —
it binds the *text of a check*, which still may only be superseded. A
stamp records that an unchanged check was run.

## Considered options

Leaving the record in `ROADMAP.md`, where 007's already sat, was
rejected on two counts. [013](013-roadmap-is-a-plan.md) makes ROADMAP a
plan, and a discharge is past-tense; worse,
[020](020-every-page-has-a-growth-path.md) prunes a discharged phase to
one line, so the prune silently deletes any check still pending — the
one thing that must survive.

A terminal `verified` status after `implemented`, with `okf-check`
erroring on a `⏳ pending` line under `implemented`, was rejected as
premature: one blueprint has ever carried a pending check. The stamps
make the state legible first; if checks start going missing, the
validator rule is a small addition on top and costs nothing now.

## Consequences

- `007-add-sound.md` §Verify is backfilled with three `✅` stamps and one
  `⏳ pending` (check 3, the self-fire byte-identity run).
- `ROADMAP.md` phase 9 loses its parenthetical discharge prose and its
  trailing "Check 3 alone must ride the next sounding" clause.
- `blueprint-format.md` states the stamp exemption where it states the
  immutability rule, so the next blueprint author reads both together.
