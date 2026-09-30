---
name: commit-atomic-jj
description: "Atomic-commit discipline with jujutsu — read every diff line before describing, split mixed changes with `jj split`, write semantic commit messages (`type(scope): imperative phrase completing \"this change will…\"`), and update docs / docstrings / READMEs in the same change as the code. Use when the user says \"commit\", \"jj describe\", \"split this change\", \"atomic commit\", \"what's the commit message\", or is about to seal a working copy that touches more than one logical concern."
---

# commit-atomic-jj

## When to use
- User says "commit", "jj describe", "atomic commit", "split this
  change", "what should the commit message be".
- A working copy contains changes that touch more than one concern.
- A public function signature, CLI flag, env var, or config key changed
  and the docs haven't.

## Principles

### 1. Inspect first
**Never describe from memory. Read the diff.**
- `jj diff` (whole change) or `jj diff <path>` (one file).
- Read every changed line. Flag debug code, commented-out blocks,
  unrelated whitespace, accidental edits.
- If the diff doesn't match what was intended, fix or split before
  describing.

### 2. One concern per change
**Each `jj describe` covers exactly one logical thing.**
- If the diff touches two areas (a bug fix and a refactor; two
  unrelated features), **`jj split`** before describing.
- Style refactors are their own change — they shouldn't share a commit
  with logic changes (see `/style-r`).
- Test additions for an existing feature are their own change unless
  they accompany a new behaviour landing in the same diff.

### 3. Structural message format
1-3 blank-line-separated blocks: subject (`type(scope): imperative
phrase[; starts|extends|ends <REF>]`), optional justification, optional
scope bullets. `scripts/commit-msg-check` validates it mechanically —
see [message-format.md](message-format.md) for the full grammar,
examples, ticket refs, and blueprint citations.

### 4. Docs travel with the code
The same `jj describe` must include any of:
- Updated docstring for a changed public function signature.
- Updated README / AGENTS.md for a new CLI flag, script, env var, or
  command.
- A new doc under `docs/` for any analysis whose result is **not
  self-evident from reading the code** (e.g. a derived statistic, a
  threshold choice, a non-trivial pipeline output). Describe: how it
  was run, inputs, how to read the result, what was concluded.
- One-line docstrings are fine. No docstring is not.

## Workflow

```
jj diff                                             # 1. read every line
$SKILL/scripts/commit-msg-check <(printf '%s' "$MSG")  # 2. validate (jj has no hook)
jj describe -m "$MSG"                               # 3. one concern? seal it (foreground)
jj diff   --revision @-                             # 4. verify the message matches what shipped
jj new   -m 'WIP'                                   # 5. open a fresh empty @ for the next unit
```
`$SKILL` = **this skill's own base directory** — the path the harness
reports when loading `commit-atomic-jj` (e.g. `~/.claude/skills/commit-atomic-jj`),
never a path relative to the repo you're committing in; the target repo
usually isn't octobot. Step 2 is mandatory, not optional — jj has no
native hook to enforce it (nothing in `jj help` or `jj config schema` as
of 0.38), so the skill itself is the only enforcement point.

Mixed diff (more than one concern) → split **before** describing, minding
which side the selected paths land on ([anti-patterns.md](anti-patterns.md)):

```
# -m sets the FIRST/parent (selected) commit; @ keeps the original message.
JJ_EDITOR=true jj split -m 'type(scope): parent msg' <paths-for-parent>
jj describe -m 'type(scope): msg for @'   # message the remaining @ explicitly
jj new -m 'WIP'
```

**Three traps ride this workflow** — skipping `jj new`, backgrounding a
mutation, letting one spawn an editor headlessly. All three below.

## Anti-patterns

See [anti-patterns.md](anti-patterns.md) — describe-before-diff, mixed-bag
commits, past-tense messages, missing scope, deferred docs, skipped
`jj new`, backgrounded mutations, headless editors, `split`'s parent side.

## See also
- [message-format.md](message-format.md) — full block grammar, config,
  and hook-install details for `scripts/commit-msg-check`.
- [examples.md](examples.md) — a real before/after where a working copy is
  split into two atomic commits with proper messages.
- `/style-r`
  — style refactors are their own atomic change.
- `/bdd`
  — the regression test for a bug fix lands in the *same* atomic change
  as the fix.
- `/diagnose`
  — phase-6 post-mortem commit message names the confirmed hypothesis.
- `/develop-python` / `/develop-r` — workflow orchestrators that hand off here for the commit phase.
