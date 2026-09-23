# Blueprint format — OKF/blueprints/B-NNN-<slug>.md

```markdown
---
type: Blueprint
status: draft | locked | implemented | superseded-by-NNN
traces-to: ROADMAP.md phase N | ferries/<topic>/D-<n> | user request <date>
sounded: YYYY-MM-DD
cites:                    # optional — what the blueprint rests on
  - path | path:line | path:symbol
muster: true              # optional — opt into the human review gate
review-base: <changeid>   # set when muster is on: parent of where rig begins
tally:                    # recorded at the muster halt; required to reach implemented
  intent: <what the change was meant to do>
  matches: yes | no
  note: <optional>
---

# NNN — <imperative title, completes "this change will…">

## Justification
<Why this exists. References (not restatements) of the roadmap phase,
ferry decision, or user need. If sieve-relevant: which Real need this
answers.>

## Contract
<Observable behaviour, exact semantics. What the change does — inputs,
outputs, states, error modes. Canonical vocabulary from OKF/CONTEXT.md
only. No implementation prescriptions unless they ARE the requirement.>

## Seams touched
<The interfaces tests will run against — module + entry point each.
bdd's pre-agreed seam list; review-blueprint checks nothing leaked past
them.>

## Verify
<ONE runnable command or observable check that proves the blueprint is met.
rig pastes its output before flipping status. "Tests pass" is not
a Verify; `just test` on a named suite is.>

## Out of scope
<Explicit non-goals — review-blueprint flags anything here that shows
up in the diff.>
```

## Rules

- Title is imperative — a blueprint names a change, not a state.
- `type: Blueprint` is the OKF-v0.1 conformance field (see `/write-OKF`'s
  `okf-layout.md`) — always first.
- `traces-to` is mandatory; a blueprint that traces to nothing fails
  `/sieve`'s Real test by definition.
- `sounded:` is the date `/sound` verified what the
  blueprint rests on; absent until then, and required to lock.
- `cites:` (optional) pins what the blueprint rests on — one entry per
  line, grammar owned by `/write-OKF`'s `okf-layout.md` §Conformance, not
  restated here. Optional because a blueprint may rest on nothing on disk:
  B-015 carries none.
- `muster: true` (optional) opts into the human review gate: rig halts
  after the seal, shows the whole `review-base..@` diff in hunk, and records
  a `tally:` block. `okf-check` errors on a `muster` blueprint reaching
  `implemented` without one. Absent → rig runs unchanged.
- Locked blueprint's Contract/Verify sections are immutable — supersede, don't
  edit. Justification may gain references; status may advance. Replacing a
  session check's state marker (`⏳ pending` → `✅ <date> (<what discharged
  it> — <what was observed>)`, per
  [021](../../../OKF/decisions/R-021-session-checks-discharge-on-the-blueprint.md))
  is not an edit to the check: the stamp records that unchanged text was run.
- A blueprint grows into `B-NNN-<slug>/` (blueprint.md + notes) when one file won't
  hold it — the format above moves to `blueprint.md` unchanged.
- Issue-local vocabulary lives here until it recurs; then promote to
  `OKF/CONTEXT.md` (model-domain's recurrence rule).
