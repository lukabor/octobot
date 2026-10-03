---
type: Blueprint
status: implemented
traces-to: decision 021
sounded: 2026-07-30
---

# 015 — record session-check discharges on the blueprint

## Justification

[021](../decisions/R-021-session-checks-discharge-on-the-blueprint.md)
rules where a check the sealing session cannot run is recorded. Nothing
implements it: 007's four session checks still carry their state as
prose in `ROADMAP.md` phase 9, where
[020](../decisions/R-020-every-page-has-a-growth-path.md)'s prune deletes
the one still pending the first time that page hits its cap, and
[blueprint-format.md](../../skills/loop/blueprint/blueprint-format.md)
still says a locked Verify is immutable with no exemption for a stamp.

Doctrine before files, per
[014](B-014-unify-skill-sibling-file-naming.md)'s Justification — the
exemption lands first, or the next author reads the immutability rule
and reverts the stamps as an illegal edit.

## Contract

**The stamp.** A numbered session check in a blueprint's `## Verify`
carries exactly one state marker on its own continuation line:

- `⏳ pending` — written when the blueprint is sealed, stands until
  discharged.
- `✅ <YYYY-MM-DD> (<what discharged it> — <what was observed>)` —
  replaces the pending marker. Both fields are required: a stamp with a
  date and no observation records nothing.

**The exemption.** `blueprint-format.md`'s immutability rule binds the
*text* of a check, which may still only be superseded. Replacing a
check's state marker is not an edit to the check.

**ROADMAP's share.** A phase line names its blueprint and stops. No
discharge prose, no pending clause, no verification evidence — that is
already ROADMAP's stated contract (`ROADMAP.md:38-41`: how each phase
verified is in jj history).

## Seams touched

- `skills/loop/blueprint/blueprint-format.md` — §Rules, the
  immutability bullet gains the stamp exemption.
- `OKF/blueprints/B-007-add-sound.md` — §Verify, the four numbered
  session checks gain markers.
- `OKF/ROADMAP.md` — phase 9's `✅ verified` line collapses.

## Verify

```sh
b=OKF/blueprints/B-007-add-sound.md
printf 'stamped: %s pending: %s\n' \
  "$(grep -c '✅ 20' "$b")" "$(grep -c '⏳ pending' "$b")"
printf 'roadmap-stale: %s roadmap-verified: %s\n' \
  "$(grep -cE 'discharged|ride the next sounding|script leg' OKF/ROADMAP.md)" \
  "$(grep -c '✅ verified' OKF/ROADMAP.md)"
printf 'exemption: %s\n' \
  "$(grep -c 'stamp' skills/loop/blueprint/blueprint-format.md)"
skills/loop/write-okf/scripts/okf-check OKF/
```

Expect `stamped: 3` `pending: 1`, `roadmap-stale: 0`
`roadmap-verified: 1`, `exemption: 1`, then `0 error(s), 0 warning(s)`.

## Out of scope

- **F1 + F4** — the 117-line `call-charon` / `commit-atomic-jj` split and
  the commit-variant length balance. Pushed to blueprint 016.
- **A terminal `verified` status** and an `okf-check` rule erroring on
  `⏳ pending` under `implemented` — 021 rejected both as premature.
- **Discharging check 3 itself.** It needs a self-fired sound run; this
  blueprint records its state, it does not run it.
- **Retro-stamping other blueprints** — 007 is the only one carrying
  session checks.
