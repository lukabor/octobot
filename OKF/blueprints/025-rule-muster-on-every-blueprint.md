---
type: Blueprint
status: implemented
traces-to: user request 2026-07-31
sounded: 2026-07-31
muster: true
review-base: llookqnr
tally:
  intent: blueprint rules muster out loud — true on the form-not-meaning criterion, else an explicit false carrying its reason — and step 5 shows the ruling before the lock
  matches: yes
  note: reviewed at the halt over review-base..@, 2 files +7/-2; first muster ever run in this repo
cites:
  - skills/loop/blueprint/SKILL.md
  - OKF/blueprints/011-add-blueprint-level-muster.md
  - skills/loop/rig/SKILL.md:Muster (only if
  - skills/loop/blueprint/blueprint-format.md:opts into the human review gate
  - skills/loop/write-OKF/scripts/okf-check:muster is opt-in
---

# 025 — rule muster on every blueprint

## Justification

**The gate works and has never fired.** [011](011-add-blueprint-level-muster.md)
shipped blueprint-level muster: `muster: true` makes `rig` halt after the
seal, show the whole `review-base..@` diff, and record a `tally:` the human
signs. `okf-check` enforces it — a muster blueprint cannot reach
`implemented` without its tally. Yet **no blueprint has ever carried the
field**: `grep -c '^muster:' OKF/blueprints/*.md` hits nothing across all 24.
The machinery is live everywhere else — `rig:27,44`, `moor:27`,
`okf-layout.md:92`, the format page — and no page has ever fired it. An
opt-in nobody reaches is a feature that exists only in the record.

**Absence is not a ruling.** Today a missing `muster:` is indistinguishable
from a considered no — `rig` step 6 skips silently either way, so nothing
marks whether the gate was declined or forgotten. B-011 already made
`muster: false` legal — *absent or false → no base, no halt, no tally* — so
the explicit no needs no new grammar, only the discipline to write it. B-024
renamed 38 files on green lints that prove links resolve and blocks stay
byte-identical, and prove nothing about whether the renamed prose reads
right. That is exactly the shape muster was built for, and it was never
considered.

**Cheapest true fix: rule it, don't default it.** The user's ruling this
session: keep the opt-in, make `blueprint` decide out loud. The decision then
lands where it is already reviewed — step 5 shows the draft, and the lock is
the user's yes. No new question, no interview; `blueprint` is synthesis and
stays synthesis.

## Contract

**`blueprint` rules muster before showing the draft.** §Process step 3 gains
a fourth sub-bullet, *Muster*: rule the gate on or off and record the ruling.
On → `muster: true`; off → **`muster: false`**, the form B-011 already
allows, with the reason in the same line's trailing comment. Silent absence
stops being a legal outcome of writing a blueprint, and the ruling stays
grep-able instead of buried in prose.

**The criterion is what the Verify cannot see.** Muster on when the Verify
proves form but not meaning — prose, doctrine, renames, any change whose
checks go green on text that reads wrong. Off when the Verify observes the
behaviour the change is for: a script's output, a failing test made to pass.

**Step 5 carries the ruling to the user.** "Show the blueprint" states the
muster ruling in one line so an unwanted gate is overruled before the lock,
not after. The lock itself is unchanged.

**This blueprint rules itself on.** It edits doctrine prose; its Verify can
grep that the words exist and cannot see whether they are followed.

## Seams touched

- `skills/loop/blueprint/SKILL.md` — §Process step 3 (the ruling) and
  step 5 (showing it). The skill's interface: its procedure.

## Verify

```sh
cd <repo-root>
grep -q 'muster: false' skills/loop/blueprint/SKILL.md && echo "OK step" || echo "FAIL step"
grep -qx 'muster: true' OKF/blueprints/025-rule-muster-on-every-blueprint.md &&
  echo "OK self" || echo "FAIL self"
skills/productivity/conjure-a-skill/scripts/skill-check skills/ | tail -1
skills/loop/write-OKF/scripts/link-check . ; skills/loop/write-OKF/scripts/okf-check OKF/
```

`skill-check` prints `0 error(s), 9 warning(s)`; `link-check` and `okf-check`
print `0 error(s), 0 warning(s)`; both greps print `OK`. `rig` halts at step 6
for the muster tally before flipping this blueprint's status.

## Out of scope

- **Changing muster's default.** Absent stays off, exactly as B-011 rules it;
  this makes the choice visible, not automatic.
- **Any validator change.** `okf-check` keeps its one muster rule
  (`muster: true` → `tally:` required at `implemented`); `muster: false` stays
  inert to it and nothing checks that a ruling was made. The rule lands where
  its next reader looks — phase 10's lesson, `ROADMAP.md` §Risks.
- **`blueprint-format.md`** — the `muster:` / `review-base:` / `tally:`
  grammar already exists and is correct; only the procedure changes.
- **Ferry-level muster** at `moor` ([012](012-add-ferry-level-muster.md)) —
  a different gate on a different unit.
- **Retro-mustering implemented blueprints**, B-024 included. Muster gates a
  close; a closed one has nothing left to gate.
