---
name: commit-atomic-jj
description: Atomic-commit discipline with jujutsu — read every diff line before describing, split mixed changes with `jj split`, write semantic commit messages (`type(scope): imperative phrase completing "this change will…"`), and update docs / docstrings / READMEs in the same change as the code. Use when the user says "commit", "jj describe", "split this change", "atomic commit", "what's the commit message", or is about to seal a working copy that touches more than one logical concern.
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
  with logic changes (see [`../../engineering/style-r/tidyverse.md`](../../engineering/style-r/tidyverse.md#tooling)).
- Test additions for an existing feature are their own change unless
  they accompany a new behaviour landing in the same diff.

### 3. Semantic format
```
type(scope): imperative phrase completing "this change will…"
```
- `type` ∈ `feat`, `fix`, `refactor`, `perf`, `test`, `docs`, `build`,
  `chore`, `style`.
- Imperative voice: **"add"**, **"fix"**, **"remove"**, **"update"** —
  never "added", "adding", "adds", "now does X".
- Subject ≤ 72 chars. Body bullets ≤ 90 chars.
- Body uses the same `type(scope): imperative` shape per sub-change.

### 4. Ticket references (optional, project-configurable)
If the project uses a ticket prefix (e.g. `DRAKE-42`, `JIRA-101`,
`CIRI-7`), use these verbs in the body:
- `starts <PREFIX>-N` — first commit on a ticket.
- `extends <PREFIX>-N` — incremental progress.
- `ends <PREFIX>-N` — final commit closing the ticket.

If the project has no ticket convention, omit. Don't invent a prefix.

### 5. Blueprint citations
A change executing an `OKF/blueprints/NNN` blueprint ([rig](../../loop/rig/SKILL.md))
cites it in the body: `implements blueprint NNN`. Readers trace the diff to
its justification without leaving the log.

### 6. Docs travel with the code
The same `jj describe` must include any of:
- Updated docstring for a changed public function signature.
- Updated README / CLAUDE.md for a new CLI flag, script, env var, or
  command.
- A new doc under `docs/` for any analysis whose result is **not
  self-evident from reading the code** (e.g. a derived statistic, a
  threshold choice, a non-trivial pipeline output). Describe: how it
  was run, inputs, how to read the result, what was concluded.
- One-line docstrings are fine. No docstring is not.

## Workflow

```
jj diff                              # 1. read every line
jj describe -m 'type(scope): ...'    # 2. one concern? seal it (foreground)
jj diff   --revision @-              # 3. verify the message matches what shipped
jj new   -m 'WIP'                    # 4. open a fresh empty @ for the next unit
```

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
- [examples.md](examples.md) — a real before/after where a working copy is
  split into two atomic commits with proper messages.
- [`../../engineering/style-r/SKILL.md`](../../engineering/style-r/SKILL.md)
  — style refactors are their own atomic change.
- [`../../engineering/bdd/SKILL.md`](../../engineering/bdd/SKILL.md)
  — the regression test for a bug fix lands in the *same* atomic change
  as the fix.
- [`../../engineering/diagnose/SKILL.md`](../../engineering/diagnose/SKILL.md)
  — phase-6 post-mortem commit message names the confirmed hypothesis.
- [`../../engineering/develop-python/SKILL.md`](../../engineering/develop-python/SKILL.md) / [`../../engineering/develop-r/SKILL.md`](../../engineering/develop-r/SKILL.md) — workflow orchestrators that hand off here for the commit phase.
