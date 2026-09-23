# commit-atomic-jj message format

Structural grammar checked by `scripts/commit-msg-check` — mechanical,
run it rather than eyeballing.

## Blocks

A message is 1 to 3 blocks, each separated by exactly one blank line. No
leading or trailing blank line; no doubled blank line between blocks.

**Block 1 — subject (always required, exactly one line, ≤80 chars)**
```
type(scope): imperative phrase
type(scope): imperative phrase; starts|extends|ends <REF>
```
`type` is one of `build, chore, ci, docs, feat, fix, perf, refactor,
revert, style, test` — the full Conventional Commits set. A repo can add
its own via `.commit-lint.toml` at repo root:
```toml
extra_types = ["hotfix"]
```
`<REF>` matches `[A-Z][A-Z0-9]*-[0-9]+` (e.g. `B-024`, `DRAKE-42`). The
`;` is reserved for this trailer — never use it inside the phrase itself.
Never starts with `-` or `*`.

**Block 2 — justification (optional, 1-2 lines, ≤80 chars each)**
Plain English: why this change exists. Two lines max, no more. The
"plain English" part is a style rule, not something the script checks —
skip jargon (refute, provenance, leverage, utilize…) and write like
you're explaining it to a teammate, not defending a thesis.

**Block 3 — scope bullets (optional, must come after block 2 if both
are present)**
```
* type(scope): imperative phrase
* type(scope): imperative phrase; starts|extends|ends <REF>
```
Same grammar as block 1, one per line, each prefixed `* ` exactly. Use
when the change has more than one distinct scope worth listing
separately; skip it for a single-concern commit.

A lone second block is classified by shape: lines starting `* ` are
block 3, anything else is block 2. So valid shapes are `[1]`, `[1,2]`,
`[1,3]`, `[1,2,3]` — never bullets before prose.

## Blueprint work

No separate citation convention — express it in the same grammar:
```
docs(blueprint): implement blueprint NNN
```
or as a block 3 bullet when it's one of several changes in the commit.

## Examples

Trivial fix, block 1 only:
```
fix(parser): reject trailing commas
```

With justification:
```
fix(parser): reject trailing commas

Old parser crashed on trailing commas. Users hit this often.
```

Multi-scope refactor:
```
refactor(auth): split login module

Module grew too big to review well. Splitting keeps each piece small.

* fix(auth): correct token refresh
* test(auth): add refresh coverage; ends B-024
```

## Enforcement

Lives at `scripts/commit-msg-check` in *this skill's own* base
directory — resolve it from the path the harness reports when
`commit-atomic-jj` loads, not from the repo being committed in; that
repo usually isn't octobot.

`commit-msg-check <message-file>` validates structure; all violations
are hard errors, no warning tier. `commit-msg-check --install-hook
[repo-dir]` copies the script to `<repo>/.githooks/commit-msg` and sets
`core.hooksPath` for the current clone — `core.hooksPath` is local
config, not versioned, so each teammate runs `git config core.hooksPath
.githooks` once after pulling the directory.

jj has no native hook mechanism (checked: nothing in `jj help` or `jj
config schema` as of 0.38) — SKILL.md's workflow runs the script against
the message before `jj describe` instead of relying on a hook.
