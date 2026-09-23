---
type: Blueprint
status: superseded-by-026
traces-to: ROADMAP.md phase 11
sounded: 2026-07-30
cites:
  - OKF/blueprints/B-018-own-the-loop-shape-in-flow-1.md:**The lint.**
  - OKF/blueprints/B-017-add-a-line-cap-lint-over-skills.md:Why a sibling script
  - OKF/decisions/R-016-one-okf-check-validator.md:One `okf-check` validator
  - OKF/decisions/R-013-roadmap-is-a-plan.md:plan, not an archive
  - OKF/ARCHITECTURE.md:substrate (rare)
  - README.md:### loop — the metaharness spine
  - skills/loop/steer/SKILL.md:## The loop
  - skills/loop/write-OKF/scripts/okf-check:a check that cannot fail
  - skills/loop/write-OKF/SKILL.md:run and output pasted
  - skills/productivity/conjure-a-skill/scripts/skill-check:usage: skill-check
  - OKF/learnings/index.md:Append-only
---

# 019 — add a render lint over the loop's shape

## Justification

[ROADMAP.md](../ROADMAP.md) phase 11 pairs the ownership move with a lint
*"so the copies cannot diverge again"*, and its Verify names the mechanism:
**checked by script**. [018](B-018-own-the-loop-shape-in-flow-1.md) landed the
first half and reserved this one; phase 11 does not verify until it lands.
The warrant is not speculative — divergence already happened once, six sites
in three forms. What holds them together today is 018's §Verify, a `sed`
range typed into a blueprint, which expires with it.

**And that check carries a live defect.** `CANON=$(sed -n …)` yields the
empty string on a file missing the block; both copies then compare
empty-to-empty and print `match`. Only the separate `owner: 17 lines`
expectation catches it —
[`okf-check`](../../skills/loop/write-OKF/scripts/okf-check)'s own docstring
names the failure: *a check that cannot fail is not a check*. 018 sits at 149
of its 150-line cap, so the fix lands here.

**Why a third script.** README.md sits at the repo root — outside `okf-check
<okf-dir>` and outside `skill-check <skills-dir>` both. No existing walker
sees all three sites, and widening either one's root changes the argv
contract [017](B-017-add-a-line-cap-lint-over-skills.md) built `skill-check` to
mirror. [016](../decisions/R-016-one-okf-check-validator.md) is not crossed: it
fixes how *OKF conformance* is enforced, and 017 already shipped a second
validator under it.

## Contract

**A script at `skills/loop/write-OKF/scripts/render-check`, taking a repo
root: `render-check <repo-root>`.** It mirrors its two siblings — same argv
shape, same `WARN `/`ERROR ` prefixes, same closing `N error(s), M
warning(s)` tally, same exit codes (1 on any error, 0 otherwise, 2 on usage),
same `#!/usr/bin/env python3` shebang. Under `write-OKF` because the owner
page is a write-OKF page.

**The owner is a fixed path; the copies are discovered.** `OKF/ARCHITECTURE.md`
is the sole owner per 018, so the script names it. Copies come from walking
`*.md` from the root, dot-directories skipped: a **render site** is any fenced
block whose first line is the canonical block's. A file with no such fence is
a pointer, which phase 11 declares legal. **Three error legs, each able to fire:**

- **No owner block.** Zero blocks at the owner path matching the sentinel, or
  more than one, is an ERROR that stops the comparison — the false-green fix:
  the script never compares against a vacuum.
- **A copy diverges.** Compared **byte-for-byte** against the owner, after
  stripping trailing whitespace per line; nothing else is normalised. The
  block is box-drawing art whose column positions carry the fork, so a
  reflowed copy is a broken diagram, not a legal variant — and this is how
  the copies are produced: spliced, never transcribed.
- **The retired flat form survives.** `architect → blueprint` anywhere under
  the root is an ERROR; 018 retired it, its §Verify grepped for it once.

**`OKF/blueprints/` is skipped.** A locked blueprint's Contract is immutable
by [blueprint-format](../../skills/loop/blueprint/blueprint-format.md), so a
rule that could turn one red would be unfixable by design, and blueprints
quote retired forms as record. 018's `--exclude='018-*'` becomes a rule.

**One invocation obligation, one line for one line.** `write-OKF/SKILL.md:83`
obliges `okf-check` to be run and its output pasted; that line grows to name
both scripts. The file sits at exactly 110 — the cap — so it must not grow.

**One `LEARNINGS.md` entry** in the file's believed/true/source form: a
Contract carrying a byte-exact artifact eats the blueprint cap. Confirmed
twice — 018 crossed 150 five times in drafting, every fix prose, and then had
no room to absorb its own Verify defect.

**Phase 11 closes** — its entry ticked and pruned to the
`✅ verified <date>, [019](…)` form phase 9 already carries, per
[013](../decisions/R-013-roadmap-is-a-plan.md): a verified phase keeps no verify
step. **Today's tree is green** — three sites matching, no stray form; the
lint changes no rendered content.

## Seams touched

- `skills/loop/write-OKF/scripts/render-check` — new; the CLI entry point
  (`render-check <repo-root>`).
- `skills/loop/write-OKF/SKILL.md` — the §Output done-criteria line at :83.
- `OKF/LEARNINGS.md` — one appended entry.
- `OKF/ROADMAP.md` — phase 11's entry, ticked and pruned.

## Verify

```sh
LINT=skills/loop/write-OKF/scripts/render-check
"$LINT" .; echo "exit: $?"
tmp=$(mktemp -d); mkdir -p "$tmp/OKF" "$tmp/skills/loop/steer"
cp OKF/ARCHITECTURE.md "$tmp/OKF/"; cp README.md "$tmp/"
cp skills/loop/steer/SKILL.md "$tmp/skills/loop/steer/"
"$LINT" "$tmp"; echo "clean exit: $?"
echo 'architect → blueprint' > "$tmp/stray.md"
"$LINT" "$tmp"; echo "stray exit: $?"; rm "$tmp/stray.md"
sed -i 's/^  blueprint → sound/  blueprint →  sound/' "$tmp/README.md"
"$LINT" "$tmp"; echo "divergent exit: $?"
sed -i '/^substrate (rare)/,/^weave = bdd/d' "$tmp/OKF/ARCHITECTURE.md"
"$LINT" "$tmp"; echo "no-owner exit: $?"
rm -rf "$tmp"
grep -c 'render-check' skills/loop/write-OKF/SKILL.md
wc -l skills/loop/write-OKF/SKILL.md OKF/LEARNINGS.md OKF/ROADMAP.md
grep -n '^11\.' OKF/ROADMAP.md
skills/loop/write-OKF/scripts/okf-check OKF/
skills/productivity/conjure-a-skill/scripts/skill-check skills/ | tail -1
```

Expect `0 error(s), 0 warning(s)` / exit 0 over the real repo and again over
the pristine copy, then each leg firing alone at exit 1: `stray.md` naming
the retired form, `README.md` diverging on one added space, and the missing
owner block reported as an error — **not** as a `match`, the defect this
blueprint exists to remove. Then `1`; `110` for `write-OKF/SKILL.md` with
both OKF pages at or under 110; a phase 11 line carrying `✅`; and
`0 error(s), 0 warning(s)` / `0 error(s), 9 warning(s)` from the siblings.

## Out of scope

- **Two `okf-check` rules — blueprint 020.** A phase entry carrying both `✅`
  and `**Verify:**` should error (the trigger `ROADMAP.md` §Risks calls
  unenforced); and `okf-check:245` skips `blueprints/` before the cite loop,
  so no blueprint's cites are validated — found sounding this one. Both trace
  to those defects, not to phase 11; 020 owns them and the second learning.
- **Wiring beyond the one done-criterion** — no justfile, no git hook, no CI.
  This repo has none; `okf-check` is obliged by prose alone.
- **Touching the rendered block or any site's content.** The lint is
  enforcement; 018 already placed what it enforces.
- **A general "one owner, N copies" mechanism** — an abstraction over a
  single instance fails [sieve](../../skills/engineering/sieve/SKILL.md)'s
  Real test.
- **`OKF/ARCHITECTURE.md`'s stale module-map line**, carried open from 018,
  and **phase 10**'s F6/F7/F8. Untouched.
