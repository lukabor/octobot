---
type: Blueprint
status: implemented
traces-to: user request 2026-07-24
sounded: 2026-07-24
---

# 011 — add blueprint-level muster, the opt-in human review gate in weave

## Justification

Splits the blueprint-level half out of
[010](010-add-muster-the-human-review-gate.md) per growth-doctrine
[020](../decisions/020-every-page-has-a-growth-path.md); 010 carries the full
justification and sounding. The ferry-level half —
which needs the `ferry` skill as a seam 010 never declared — is
[012](012-add-ferry-level-muster.md).

The loop's review before it seals is all *agent* eyes; the human running it
does not read the diff after a weave. Muster is the forced human checkpoint,
opt-in, that halts weave after the seal and refuses to advance until the
human has read the whole change against intent and recorded a verdict.

Sieve — **Real**: the user's own testimony; the loop has no human gate today.
**Good**: a *did-this-do-what-I-intended* surface the four axes cannot
supply. **Minimal**: opt-in, so mode-off weave is byte-identical; reuses the
`[ -d .jj ]` split, the existing seal, and the blueprint page for storage; no
mandated dependency — hunk is a viewer, raw `jj diff` / `git diff` the fallback.

## Contract

**Muster is a mode, off by default.** `muster: true` in a blueprint's
frontmatter opts in. Absent or false → weave behaves exactly as today: no
base, no halt, no tally.

**The base is a stored ref.** With muster on, weave records `review-base:
<changeid-or-sha>` on the blueprint at Frame — `@-` (jj) or `git rev-parse
HEAD` (git), the parent of where Build begins. The whole change is the range
`review-base..@`, unioning every atomic commit the seal produced.

**The gate halts weave** after Seal, before status flips to `implemented`. At
the halt the whole-change diff is piped into **hunk** — `hunk patch -` reads
a unified diff from stdin, VCS-agnostic (hunk README,
`github.com/modem-dev/hunk`). `[ -d .jj ]` selects only the producer:

- jj: `jj diff --from <review-base> --to @ --git | hunk patch -`
- git: `git diff <review-base>..HEAD | hunk patch -`

No hunk → the same range shown raw. The teeth are the tally, not the viewer.

**The teeth are the tally.** The human records a `tally:` block on the
blueprint:

```yaml
tally:
  intent: <what the change was meant to do>
  matches: yes | no
  note: <optional>
```

`matches: yes` → weave resumes and flips to `implemented`. `matches: no` →
weave **stays halted** for a fix + re-muster; never a known miss.

**The tally is machine-enforced.** `okf-check` errors on any blueprint with
`muster: true` and `status: implemented` carrying no `tally:` block. The
block needs a parser mirroring `okf-check:pin`, because the generic
`frontmatter()` flattens a nested block to an empty list. Blueprints without
`muster` never retro-flag. The halt itself is prose in weave: okf-check
cannot see live behaviour (decision
[017](../decisions/017-pin-drift-splits-by-visibility.md)).

## Seams touched

- `skills/loop/weave/SKILL.md` — a **Muster** step between Seal and
  Close-the-loop, guarded by `muster: true`; `review-base` recorded at Frame.
- `skills/loop/blueprint/blueprint-format.md` — documents `muster`,
  `review-base`, and the `tally` block.
- `skills/loop/write-OKF/scripts/okf-check` — the tally-required-when-implemented
  rule, via a `tally:` block parser modelled on `pin()`.
- `skills/loop/write-OKF/okf-layout.md` — the new fields in the blueprint
  contract.

## Verify

```sh
cd skills/loop/write-OKF && d=$(mktemp -d) && mkdir -p "$d/blueprints" &&
printf -- '---\nokf_version: "0.1"\n---\n- [a](blueprints/a.md)\n- [b](blueprints/b.md)\n' > "$d/index.md" &&
base='---\ntype: Blueprint\nstatus: implemented\ntraces-to: t\nmuster: true\n'
printf -- "${base}---\n# a\n" > "$d/blueprints/a.md"                       # muster+implemented, NO tally
printf -- "${base}tally:\n  intent: x\n  matches: yes\n---\n# b\n" > "$d/blueprints/b.md"  # has tally
scripts/okf-check "$d"; echo "exit=$?"; scripts/okf-check ../../../OKF
```

Expect: `blueprints/a.md` errors (muster + implemented, no `tally:`),
`blueprints/b.md` passes, and octobot's own `OKF/` still reports 0 errors.

## Out of scope

- **Ferry-level muster** — the moor halt and the ferry's `review-base` writer
  are [012](012-add-ferry-level-muster.md).
- **GitHub** — no push, branch, or PR; muster is a local terminal review.
- **The agent review axes** — muster is a human gate beside them, not a change to them.
- **Any default-mode behaviour** — mode-off weave stays byte-identical.
- **Auto-fixing on `matches: no`** — weave halts for the human.
- **Promoting `muster` / `tally` to `CONTEXT.md`** — issue-local until it recurs.
