---
name: resolve-conflicts
description: Resolve jj conflicts by intent, not by picking sides — check topology first (phantom conflicts from wrong rebase roots), read both parents' purpose, merge meanings, squash with the destination message. Use when the user says "resolve the conflict", "fix the conflict", jj shows (conflict) markers, or a rebase left conflicted commits.
---

# resolve-conflicts

jj-native port of mattpocock/skills `resolving-merge-conflicts`. In jj,
conflicts are **first-class committed objects** — no mid-merge limbo, no
`--abort` pressure; the repo is never wedged while you think.

## Process

1. **See the state.** `jj st` (conflicted paths) + `jj log` (where the
   `×` markers sit and what their parents were doing).

2. **Check topology before touching markers.** A chain rebased onto the
   wrong root produces *phantom* conflicts. If the conflicted chain's
   base isn't its true destination, `jj rebase -s <root> -d <dest>`
   first — real-world case: this shrank a 2-file conflict (with a
   deletion side!) to a 1-file text conflict before any hand-resolution
   (`OKF/LEARNINGS.md`).

3. **Find the primary sources.** Why does each side exist? Read the
   commit descriptions; jj's conflict markers carry them — the
   `+++++++ <rev> "<desc>" (rebase destination)` header and the
   `%%%%%%% diff from:` / `to:` lines name both intents. Deeper intent:
   `jj diff -r` each side; check blueprints/PRs/issues if cited.

4. **Resolve each hunk — preserve both intents.** Apply the *semantic
   change* of the rebased side onto the destination's evolved text, not
   a side-pick. Where truly incompatible, pick the one matching the
   merge's stated goal and note the trade-off. **Never invent new
   behaviour; never abandon the conflicted work.**

5. **Squash the resolution.** Working copy sits on the conflicted
   commit (or `jj new <conflicted>` first); edit markers out; then
   `jj squash --use-destination-message` — plain `jj squash` opens an
   editor and **hangs a headless session**
   ([commit-atomic-jj anti-patterns](../commit-atomic-jj/anti-patterns.md)). Foreground
   only; backgrounded jj mutations race the snapshot.

6. **Verify.** Conflicted chains skip your checks while red — run the
   project's automated checks now (typecheck, tests, lint). Cross-file
   consistency: a marker file may reference a sibling that had its own
   conflict — grep the resolved term across the module
   (`grep -rn <term> <dir>`). Then `jj diff -r <commit>` — the message
   must still describe the diff.

## jj specifics worth knowing
- Descendants auto-rebase on resolution — one fix heals the chain.
- `jj resolve` drives a merge tool; hand-editing markers is equally
  valid (what step 5 assumes).
- Marker legend: `+++++++` = snapshot side; `%%%%%%%` = a *diff* to
  replay onto it; `-------` lines inside show removed text.
- Immutable-commit refusal (`jj` won't rewrite pushed history) →
  `--ignore-immutable` only when a force-push is the agreed plan.

## Output / done criteria
- `jj st` shows no conflicts; checks green; each hunk's resolution
  traceable to both parents' intent; message still matches the diff.

## Guardrails
- **Never** resolve by side-picking without reading both intents.
- **Never** invent behaviour absent from both sides.
- **Never** run bare `jj squash` / `jj describe` headless — always
  `-m` or `--use-destination-message`.
- **Never** leave a `%%%%%%%` diff hunk half-applied — replay it fully
  or reject it explicitly.

## See also
- [../commit-atomic-jj/SKILL.md](../commit-atomic-jj/SKILL.md) — sealing discipline
  after resolution; foreground-only rule.
- [../../engineering/review-angles/SKILL.md](../../engineering/review-angles/SKILL.md)
  — a resolved merge is a diff like any other; review it.
