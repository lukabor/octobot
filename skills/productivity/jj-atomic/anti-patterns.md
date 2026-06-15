# jj-atomic anti-patterns

## `jj describe` before `jj diff`

You'll commit debug `cat()`s, stray `browser()` calls, and TODO
scratchpads. Read every line of every diff before you describe.

## "Mixed bag" commits

`refactor + fix + new feature` in one change is three regressions waiting
to happen and an unrevertable mess. If the diff touches more than one
concern, `jj split` before describing.

## Past-tense / declarative messages

`"added auth"`, `"auth now works"`. These don't complete the implicit
prefix *"this change will…"*. Use the imperative — `"add OAuth2 login
flow"`, `"fix token refresh on 401"`.

## No scope

`feat: add login` is weaker than `feat(auth): add OAuth2 login flow`.
Scope is the smallest area the change touches; it makes the log
greppable and the change's footprint visible at a glance.

## Docs in the next commit

"I'll update the README after." You won't. Docstrings, README sections,
CLAUDE.md updates for a new flag or env var — same change or it doesn't
ship. See SKILL.md §5 *"Docs travel with the code"*.

## Skipping `jj new` after describe

Edits land in the just-described change; its message rots into a lie. Always
open a fresh `@` immediately after `jj describe`. See SKILL.md *"Workflow"*
step 5.

## Backgrounding a `jj` mutation

Running `jj squash` / `describe` / `split` / `new` as a *background*
command (e.g. a chained `ruff format && jj squash …` fired detached)
fails — observed three times in one session, exit 144, the format step
succeeding and the `jj` step dying. A mutating `jj` op snapshots and
rewrites the working copy; backgrounding it races the harness's own
working-copy snapshot and the op aborts. Run every `jj` mutation in the
**foreground**, one at a time. Background is for long read-only work
(builds, test runs), never for sealing a commit.

## Letting a `jj` op spawn an editor headlessly

`jj describe`, `split`, and `commit` open `$JJ_EDITOR` (often a full TUI like
nvim) when no `-m` is given. In a headless / non-terminal context the editor
has no stdout to attach to, so it hangs or crashes — the transaction never
commits and `split` can leave you mid-operation. Always pass `-m` for the
message, and guard with `JJ_EDITOR=true` so any unexpected editor invocation
is an instant no-op instead of a hang. `split` describes its *first* part
from `-m`; describe the remaining `@` explicitly afterwards.
