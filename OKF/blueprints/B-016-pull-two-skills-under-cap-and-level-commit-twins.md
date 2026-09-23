---
type: Blueprint
status: implemented
traces-to: user request 2026-07-30
sounded: 2026-07-30
cites:
  - skills/loop/call-charon/crossing-format.md:Isolation (per mode
  - skills/loop/call-charon/crossing-format.md:Reviewer brief
  - skills/productivity/commit-atomic-jj/anti-patterns.md:Backgrounding a
  - skills/productivity/resolve-conflicts-git/SKILL.md:git specifics worth knowing
  - skills/productivity/conjure-a-skill/SKILL.md:exceed 110 lines
  - skills/productivity/conjure-a-skill/principles.md:topic-named siblings
  - OKF/decisions/R-020-every-page-has-a-growth-path.md:twelve pages
  - CLAUDE.md:≤ 110 lines
---

# 016 — pull two skills under the line cap and level the commit twins

## Justification

The 2026-07-24 skills review (`~/skills-review-2026-07-24.md`, outside
the repo) left F1 and F4 untriaged; they batch as one pass.

**F1** — `call-charon/SKILL.md` and `commit-atomic-jj/SKILL.md` both
measure 117 lines against CLAUDE.md §5's ≤110 cap. Same defect class
[013](B-013-split-moor-into-skill-and-reference.md) fixed for `moor`.

**F4** — the `commit-atomic-git` / `-jj` pair is asymmetric: git has no
`## When to use` body anchor and a shorter skeleton, while
`resolve-conflicts-git` / `-jj` — the pair the review names as the
template — carry identical skeletons with mode-named slots. Both commit
variants are model-invoked (neither carries
`disable-model-invocation`), and `## When to use` is the house skeleton
`conjure-a-skill` hands every new skill
(`conjure-a-skill/SKILL.md:82`).

The two findings are coupled: any cut that shortens the jj variant's
`## Principles` without the same cut on git *creates* the asymmetry F4
asks to remove. Fixing either alone makes the other worse.

Both offenders' overage is **restatement of their own siblings**, not
irreducible doctrine, so this is a dedup, not a split:

- `call-charon/SKILL.md` step 3 restates
  [crossing-format.md](../../skills/loop/call-charon/crossing-format.md)
  §Isolation; step 4 restates its §Reviewer-brief rationale.
- `commit-atomic-jj/SKILL.md` §Workflow's tail restates
  [anti-patterns.md](../../skills/productivity/commit-atomic-jj/anti-patterns.md)
  §*Skipping `jj new`*, §*Backgrounding a `jj` mutation*, and
  §*Letting a `jj` op spawn an editor headlessly* — and cites two of
  them while restating them.

Per [012](B-012-add-ferry-level-muster.md)'s LEARNINGS entry, a blueprint
touching a near-cap skill prices the split into its scope: `commit-atomic-git`
gains ~7 lines and sits at ~104, needing no split; if dedup alone leaves
either offender over cap, this blueprint authorises a further offload into
that skill's **existing** sibling.

## Contract

**The cap.** All three files measure ≤110 by `wc -l`.

**Nothing is deleted, only relocated.** Every line leaving a `SKILL.md`
is already stated in that skill's existing sibling, or moves there.
No new sibling file, and no new duplication *between* the twins — the
overage is paid from restatement, never from doctrine.

**Positive statement, not prohibition.** `call-charon/SKILL.md` names no
VCS isolation mechanics — it names the mode and points at
`crossing-format.md` §Isolation, which owns them.
([014](B-014-unify-skill-sibling-file-naming.md)'s LEARNINGS entry: a
Verify that greps a banned string must not collide with prose that has
to say it.)

**The twins are parallel.** `commit-atomic-git/SKILL.md` and
`commit-atomic-jj/SKILL.md` carry the identical `^## ` heading sequence:
`When to use`, `Principles`, `Workflow`, `Anti-patterns`, `See also`.
`###` sub-headings and `## Workflow` bodies stay VCS-specific — the
`resolve-conflicts` pair keeps mode-named slots (`## jj specifics` /
`## git specifics`) and is still the parity template.

**The git trigger anchor.** `commit-atomic-git` gains a `## When to use`
above `## Principles`, listing its own triggers. Parity is reached by
**adding** to git, never by deleting jj's — the `resolve-conflicts` pair
is parallel *without* a `## When to use`, so subtraction would also
level the twins, and it is the wrong direction: 31 of 41 skills carry
the section, and `conjure-a-skill` hands it to every new skill.

**Back-references resolve.** `commit-atomic-jj/anti-patterns.md`'s two
`See SKILL.md …` pointers currently name `§5` (the section is §6) and
`"Workflow" step 5` (Workflow has four steps). Both are already stale
and both point into text this blueprint edits; they name existing text
when it lands.

## Seams touched

- `skills/loop/call-charon/SKILL.md` — §Process steps 3 (DISPATCH) and
  4 (REVIEW FLOTILLA).
- `skills/productivity/commit-atomic-jj/SKILL.md` — §Workflow tail and
  §Anti-patterns pointer.
- `skills/productivity/commit-atomic-git/SKILL.md` — new §When to use.
- `skills/productivity/commit-atomic-jj/anti-patterns.md` — the two
  `See SKILL.md …` back-references.

## Verify

```sh
for f in skills/loop/call-charon/SKILL.md \
         skills/productivity/commit-atomic-jj/SKILL.md \
         skills/productivity/commit-atomic-git/SKILL.md; do
  printf '%s %s\n' "$(wc -l < "$f")" "${f#skills/}"
done
diff <(grep '^## ' skills/productivity/commit-atomic-git/SKILL.md) \
     <(grep '^## ' skills/productivity/commit-atomic-jj/SKILL.md) \
  >/dev/null && echo 'twins: parallel' || echo 'twins: DIVERGED'
printf 'charon-mechanics: %s stale-backrefs: %s\n' \
  "$(grep -cE 'workspace add|isolation: worktree' skills/loop/call-charon/SKILL.md)" \
  "$(grep -cE 'SKILL\.md §5|Workflow.*step 5' \
     skills/productivity/commit-atomic-jj/anti-patterns.md)"
skills/loop/write-OKF/scripts/okf-check OKF/
```

Expect all three line counts ≤ 110, then `twins: parallel`,
`charon-mechanics: 0 stale-backrefs: 0`, then
`0 error(s), 0 warning(s)`.

## Out of scope

- **A line-cap lint.** `skills/` already has both halves of
  [020](../decisions/R-020-every-page-has-a-growth-path.md) *except* the
  enforcement: the named move exists (topic-named siblings,
  `conjure-a-skill/principles.md`) and so does the prohibition
  (`conjure-a-skill/SKILL.md`: never exceed 110 lines) — but nothing
  errors, which is exactly the decay 020 measured (twelve over-cap
  pages while the one mechanical rule held). 013 → 016 is the second
  hand-fix. The lint is the permanent answer; it is not F1, and it
  lints `skills/` where `okf-check` lints `OKF/` — its own blueprint.
- **The remaining findings** — F5 (hand-copied spine string), F6, F7
  (grill-family), F8 (heading dialects), F9 (two `decision-format.md`),
  F11 (ADR vocabulary). Separately triaged.
- **Rewriting either sibling.** `crossing-format.md` and
  `anti-patterns.md` receive relocated lines only; their existing
  sections are not restructured.
- **`commit-atomic-git`'s inline `## Anti-patterns`.** It stays inline —
  git is under cap and has no sibling; forcing one to mirror jj would
  add the duplication this blueprint refuses.
