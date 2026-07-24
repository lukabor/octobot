---
type: Blueprint
status: superseded-by-011
traces-to: user request 2026-07-24
sounded: 2026-07-24
---

# 010 — add muster, the opt-in human review gate on the loop's close

## Justification

**Superseded 2026-07-24 — split per growth-doctrine
[020](../decisions/020-every-page-has-a-growth-path.md): the blueprint-level
gate ships as [011](011-add-blueprint-level-muster.md) (implemented); the
ferry-level gate — which needs the `ferry` skill as a seam this blueprint
never declared — becomes [012](012-add-ferry-level-muster.md). The
justification and sounding below stand for both.**

The loop reviews before it seals — [review-angles](../../engineering/review-angles/SKILL.md),
[review-blueprint](../../engineering/review-blueprint/SKILL.md),
[nuke-review](../../engineering/nuke-review/SKILL.md) — but all of it is
*agent* eyes. The human running the loop is present at the keyboard yet, by
their own account, does not read the diff after a weave and does not confirm
the agents' verdicts. So the diff a blueprint ships is, in practice, never
read by the person who owns the intent. That is the gap: not access, but a
forced checkpoint.

Muster is that checkpoint — an opt-in mode that **halts the loop** after the
seal and refuses to advance until the human has read the whole change against
what they meant and recorded a verdict.

Sieve — **Real**: the need is the user's own testimony, not speculation; the
loop has no human gate today. **Good**: adds a correctness surface the agent
axes cannot supply — *did this do what I intended* — nameable and distinct
from the four axes. **Minimal**: opt-in, so it costs **nothing** when off (no
marker, no prompt, no artifact); reuses the existing `[ -d .jj ]` VCS split,
the existing seal, and existing pages for storage; mandates no new
dependency — hunk is a viewer, and plain `jj diff` / `git diff` is the
fallback.

## Contract

**Muster is a mode, off by default.** Set at generation, on the unit that
owns the gate: `muster: true` in a blueprint's frontmatter, or in a ferry's
`MAP.md`. Absent or false → weave and moor behave exactly as today: no base
marker, no halt, no tally. The zero-overhead path is the default path.

**The base is a stored ref, not a repo marker.** When muster is set, the
generating step records `review-base: <changeid-or-sha>` on the same page —
the parent of where work begins (`@-` for jj, `git rev-parse HEAD` for git).
The whole change is then the range `review-base..@`, which unions every
atomic commit the seal produced and, for a ferry, every blueprint it spawned.
Nothing is planted in the repo; storage is VCS-agnostic, the range command is
not.

**The gate halts the loop, opt-in only.**

| unit | halts | reviews |
|---|---|---|
| blueprint (`weave`) | after Seal, before status flips to `implemented` | `review-base..@` |
| ferry (`moor`) | after GATHER SIGNAL, before COLLAPSE | `review-base..@` |

At the halt, the whole-change diff is piped into **hunk** as a patch —
`hunk patch -` reads a unified diff from stdin and is VCS-agnostic (hunk
README, `github.com/modem-dev/hunk`). `[ -d .jj ]` — the same idiom as
[commit-atomic-jj](../../productivity/commit-atomic-jj/SKILL.md) /
commit-atomic-git — selects only the diff *producer*:

- jj: `jj diff --from <base> --to @ --git | hunk patch -`
- git: `git diff <base>..HEAD | hunk patch -`

When hunk is not installed, the same range is shown raw (`jj diff --from
<base> --to @` / `git diff <base>..HEAD`). The teeth are the tally, not the
viewer — an absent hunk degrades the review surface, it never blocks the loop.

**The teeth are the tally, not the viewer.** The human records a `tally:`
block on the unit's page:

```yaml
tally:
  intent: <what the change was meant to do>
  matches: yes | no
  note: <optional>
```

`matches: yes` → the loop resumes and advances. `matches: no` → the loop
**stays halted** for the human to fix, then re-muster; it never advances a
known miss.

**The tally is machine-enforced where it can be seen.** `okf-check` errors on
any blueprint with `muster: true` and `status: implemented` that carries no
`tally:` block — the artifact cannot be skipped even if the prose halt is
bypassed. Detecting the block needs a dedicated parser mirroring
`okf-check:pin`, because the generic `frontmatter()` flattens a nested block
to an empty list. Existing implemented blueprints carry no `muster` field, so
the rule never retro-flags them. The **ferry**-level tally is prose-enforced
at moor — `check_ferries` is shape-only — and the halt itself is prose in
weave/moor: okf-check cannot see live behaviour (decision
[017](../decisions/017-pin-drift-splits-by-visibility.md)).

## Seams touched

- `skills/loop/weave/SKILL.md` — Process gains a **Muster** step between Seal
  and Close-the-loop, guarded by `muster: true`; records `review-base` at
  Frame when the mode is on.
- `skills/loop/moor/SKILL.md` — a **Muster** step before COLLAPSE, guarded by
  the ferry's `muster: true`.
- `skills/loop/blueprint/blueprint-format.md` — documents `muster`,
  `review-base`, and the `tally` block.
- `skills/loop/write-OKF/scripts/okf-check` — the tally-required-when-implemented
  rule, via a `tally:` block parser modelled on the existing `pin()`.
- `skills/loop/write-OKF/okf-layout.md` — the new frontmatter fields in the
  blueprint and ferry-map contracts.

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

- **GitHub** — no push, branch, or PR flow; muster is a local terminal
  review, hunk is a local viewer.
- **The agent review axes** — muster adds a human gate beside review+verify,
  it does not replace or modify them.
- **Any default-mode behaviour** — mode-off weave/moor stay byte-identical.
- **Auto-fixing on `matches: no`** — the loop halts for the human; it does
  not attempt the fix itself.
- **Promoting `muster` / `tally` to `CONTEXT.md`** — issue-local vocabulary
  until it recurs (blueprint-format's rule); a follow-up promotes it.
- **A decision-register entry** for "does the loop have a human gate" —
  graduate it separately if it earns the warrant test.
