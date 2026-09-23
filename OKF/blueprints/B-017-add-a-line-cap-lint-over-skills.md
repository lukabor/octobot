---
type: Blueprint
status: implemented
traces-to: user request 2026-07-30
sounded: 2026-07-30
cites:
  - OKF/CONTEXT.md:House cap
  - OKF/CONTEXT.md:optional topic-named siblings
  - OKF/decisions/R-020-every-page-has-a-growth-path.md:twelve pages
  - OKF/blueprints/B-016-pull-two-skills-under-cap-and-level-commit-twins.md:A line-cap lint
  - skills/productivity/conjure-a-skill/SKILL.md:exceed 110 lines
  - skills/productivity/conjure-a-skill/SKILL.md:≤ 110 lines** — octobot's house cap
  - skills/loop/write-OKF/scripts/okf-check:CAP = 110
  - skills/loop/write-OKF/scripts/okf-check:a check that cannot fail
  - skills/loop/write-OKF/SKILL.md:output pasted
  - skills/loop/write-OKF/split-page.md:errors when a page passes its cap
  - CLAUDE.md:≤ 110 lines
---

# 017 — add a line-cap lint over skills/

## Justification

[020](../decisions/R-020-every-page-has-a-growth-path.md) made the cap
enforceable by naming one legal move per page kind, and `okf-check` errors
at cap+1 across `OKF/`. `skills/` has both halves of 020 *except* the
enforcement: the named move exists (topic-named siblings,
`conjure-a-skill/principles.md`) and so does the prohibition
(`conjure-a-skill/SKILL.md`: never exceed 110 lines) — but nothing errors.
That is precisely the decay 020 measured: twelve pages over cap while the
one *mechanical* rule held without exception.

Two hand-fixes have already been spent on it —
[013](B-013-split-moor-into-skill-and-reference.md) split `moor`,
[016](B-016-pull-two-skills-under-cap-and-level-commit-twins.md) deduped
`call-charon` and `commit-atomic-jj` — and 016 §Out-of-scope reserved this
blueprint, stating the warrant. The lint is the permanent answer.

**Why a sibling script, not an extension of `okf-check`.** The two trees
share the integer 110 and nothing else. `okf-check`'s loop is
OKF-page-shaped — `reachable()` from `index.md`, the warrant contract
(`purpose:`/`answers:`/`cites:`), `check_ferries`, `check_register`, the
`sealed:`/`tally:` grabs. None applies to a skill directory, whose rules
are disjoint (a folder-matched `name:`, a 1024-char `description:`,
lowercase-kebab siblings). Threading a tree-kind flag through a 275-line
validator to reuse a two-line comparison fails
[sieve](../../skills/engineering/sieve/SKILL.md)'s Minimal test.

**Why the cap alone.** Audited today, the other CLAUDE.md §5 conventions
are clean — 41 of 41 skills match `name:` to folder and hold `description:`
under 1024 chars. They show no measured decay, so checks for them are
speculative and fail Real; and a filename rule would be red on arrival over
two dot-separated template siblings, a naming question, not a cap one.

## Contract

**A script at `skills/productivity/conjure-a-skill/scripts/skill-check`,
taking a skills root: `skill-check <skills-dir>`.** It mirrors
`okf-check <okf-dir>` — same argv shape, same `WARN `/`ERROR ` line
prefixes, same closing `N error(s), M warning(s)` tally, same exit codes
(1 on any error, 0 otherwise, 2 on usage). It is executable with a
`#!/usr/bin/env python3` shebang, as both existing skill scripts are, and
lives in `conjure-a-skill` because that skill owns the cap rule and the
never-exceed guardrail.

**It walks `*/*/SKILL.md` under the given root** — the
`skills/<category>/<name>/` layout CONTEXT.md's *Skill* entry fixes, where
all 41 sit — and counts lines as `wc -l` does. Nothing else in a skill
directory is read: not siblings, not frontmatter, not `scripts/`.

**Two thresholds, per the 2026-07-30 decision:**

- **`> 110` is an ERROR.** CONTEXT.md's **house cap**, stated identically
  in CLAUDE.md §5 and `conjure-a-skill/SKILL.md`. Matches `okf-check`'s
  `> cap`, so a file at exactly 110 is legal in both trees.
- **`> 100` is a WARNING** — the headroom band. A skill in 101–110 is
  legal but has nowhere to grow; the warning is the notice that the next
  edit needs a sibling, not more lines. It names the file, its count, and
  its remaining headroom.

**The cap is an error, not a warning, because a legal move always exists**
— 020's rule, and the same reason `okf-check` errors rather than warns
(`split-page.md`: errors when a page passes its cap). For a skill the move
is a topic-named sibling.

**Both legs must be able to fire.** A validator whose error path is
unreachable is not a validator — `okf-check`'s own docstring makes the
point (*a check that cannot fail is not a check*). Verify therefore
exercises the error leg against a synthetic over-cap skill, not only the
green path over the real tree.

**The lint has one invocation obligation.** `conjure-a-skill`'s
done-criteria list currently asserts the cap in prose (`SKILL.md` is ≤ 110
lines); that line becomes the script call, matching how
`write-OKF/SKILL.md` obliges `okf-check` to be run and its output pasted.
One line replaces one line — `conjure-a-skill` sits at 105 and stays there.

**Today's tree is green.** Zero errors; nine of 41 skills sit in the
warning band, `write-OKF` and `bdd` at the cap itself. The lint changes no
skill's content.

## Seams touched

- `skills/productivity/conjure-a-skill/scripts/skill-check` — new; the
  CLI entry point (`skill-check <skills-dir>`).
- `skills/productivity/conjure-a-skill/SKILL.md` — the done-criteria line
  asserting the cap becomes the script invocation.

## Verify

```sh
LINT=skills/productivity/conjure-a-skill/scripts/skill-check
"$LINT" skills/; echo "exit: $?"
tmp=$(mktemp -d); mkdir -p "$tmp/category/over-cap"
{ printf -- '---\nname: over-cap\n---\n'; seq 200; } > "$tmp/category/over-cap/SKILL.md"
"$LINT" "$tmp"; echo "exit: $?"
rm -rf "$tmp"
grep -c 'skill-check' skills/productivity/conjure-a-skill/SKILL.md
wc -l < skills/productivity/conjure-a-skill/SKILL.md
skills/loop/write-OKF/scripts/okf-check OKF/
```

Expect, in order: `0 error(s), 9 warning(s)` then `exit: 0` over the real
tree, with one WARN line per file in the 101–110 band; then
`1 error(s), 0 warning(s)` and `exit: 1` on the synthetic over-cap skill,
proving the error leg fires; then `1` and `105`; then
`0 error(s), 0 warning(s)`.

## Out of scope

- **Lowering the cap to 100.** Weighed and rejected for this blueprint on
  2026-07-30: it would turn nine legal skills red on arrival and require
  rewriting the 110 in CLAUDE.md §5 and `conjure-a-skill` — a shortening
  pass plus a doctrine change, past what one weave run verifies. If wanted,
  it is its own blueprint on top of this one.
- **Every other CLAUDE.md §5 convention** — folder/`name:` agreement, the
  1024-char `description:`, lowercase-kebab siblings, `SKILL.md` as the sole
  uppercase file, `scripts/` holding only deterministic helpers. All clean
  today; see §Justification. A later blueprint may add them to this script.
- **Shortening any skill.** Nothing is over 110, so the lint lands green;
  it is enforcement, not a fix. The nine warnings are notices.
- **Wiring beyond the one done-criterion** — no justfile, no git hook, no
  CI. This repo has none, and `okf-check` is obliged by prose alone.
- **Touching `okf-check` or `OKF/`.** Unchanged; the duplicated `110`
  enforces, for a second tree, a cap already stated in four places.
- **The `examples.md` §5 → §6 stale cite** left open by 016. A reference
  defect, not a cap defect; it folds into whatever next edits
  `commit-atomic-jj/`.
