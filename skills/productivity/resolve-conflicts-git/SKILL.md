---
name: resolve-conflicts-git
description: Resolve git merge/rebase conflicts by intent, not by picking sides — check topology first (phantom conflicts from wrong rebase bases), read both parents' purpose via git show :1:/:2:/:3: and zdiff3 markers, merge meanings, continue with editor guarded. Use when the user says "resolve the conflict", "fix the conflict", git reports "CONFLICT", or a merge/rebase stopped with unmerged paths, in a repo where `[ -d .jj ]` fails. jj repos → resolve-conflicts-jj.
---

# resolve-conflicts-git

git-native counterpart of `/resolve-conflicts-jj`.
Unlike jj, git conflicts are **mid-operation limbo** — `MERGE_HEAD` or a
paused rebase holds the repo until you continue or abort. The limbo is
still not an emergency: `--abort` is a clean reset to before the
operation, so you can always stop, think, and re-attempt. Never resolve
under abort-pressure.

## Process

1. **See the state.** `git status` (unmerged paths + which operation is
   in flight), `git log --oneline --graph HEAD MERGE_HEAD` (merge) or
   `git rebase --show-current-patch` (rebase) — what each side was doing.

2. **Check topology before touching markers.** A branch rebased onto
   the wrong base produces *phantom* conflicts. If the conflicted
   commits' true destination isn't the current base:
   `git rebase --abort`, then
   `git rebase --onto <correct-base> <old-base> <branch>`. Re-attempt;
   often the conflict shrinks or vanishes.

3. **Find the primary sources.** Why does each side exist?
   - `git config merge.conflictStyle zdiff3` (once, before merging) —
     markers then show the common base between `|||||||` and `=======`,
     so you see what each side *changed*, not just what it *is*.
   - Three versions on demand: `git show :1:<file>` (base),
     `:2:` (ours/HEAD), `:3:` (theirs).
   - Intent: `git log --merge -p -- <file>` shows both sides' commits
     touching the file; check blueprints/PRs/issues if cited.

4. **Resolve each hunk — preserve both intents.** Apply the *semantic
   change* of the incoming side onto the destination's evolved text,
   not a side-pick. Truly incompatible → pick the side matching the
   merge's stated goal, note the trade-off. **Never invent new
   behaviour; never abort as a way of abandoning the work.**

5. **Continue, editor guarded.** `git add <resolved-files>`, then
   `GIT_EDITOR=true git merge --continue` (or `rebase --continue`) —
   an unguarded continue spawns `$GIT_EDITOR` for the merge message and
   hangs a headless session. Rebase: repeat per stopped commit.

6. **Verify.** Run the project's automated checks (typecheck, tests,
   lint) — the conflicted span never ran them. Cross-file consistency:
   a resolved file may reference a sibling that had its own conflict —
   `grep -rn <term> <dir>`. Then `git show` — the commit message must
   still describe the resulting diff; reword if the resolution changed
   the story.

## git specifics worth knowing
- Rebase replays commit-by-commit — expect the *same* conflict shape
  repeatedly; `git config rerere.enabled true` records resolutions and
  replays them automatically.
- `git checkout --ours/--theirs <file>` is a whole-file side-pick —
  exactly what step 4 forbids, except for generated/lock files where
  regeneration is the real resolution.
- During rebase, ours/theirs invert intuition: "ours" = the base being
  rebased *onto*, "theirs" = your replayed commit.
- Aborting is cheap and safe (`merge --abort` / `rebase --abort`) —
  unlike jj there is no committed conflict to return to, so abort only
  with the topology fix (step 2) or a fresh attempt in hand.

## Output / done criteria
- `git status` clean of unmerged paths, operation concluded; checks
  green; each hunk's resolution traceable to both parents' intent;
  message still matches the diff.

## Guardrails
- **Never** resolve by side-picking without reading both intents
  (`checkout --ours/--theirs` only for regenerable files).
- **Never** invent behaviour absent from both sides.
- **Never** run `merge --continue` / `rebase --continue` headless
  without `GIT_EDITOR=true` or `-m` where accepted.
- **Never** leave conflict markers in a "resolved" file —
  `grep -rn '<<<<<<<' .` before continuing.

## See also
- `/resolve-conflicts-jj` — jj
  counterpart; topology-first rule and real-world phantom-conflict case
  (`OKF/LEARNINGS.md`) apply verbatim.
- `/commit-atomic-git` —
  sealing discipline after resolution.
- `/review-angles`
  — a resolved merge is a diff like any other; review it.
