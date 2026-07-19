---
name: commit-atomic-git
description: Atomic-commit discipline for plain git repos (no .jj) — read every diff line before committing, use the staging area to split mixed changes into one-concern commits, write semantic messages (`type(scope): imperative phrase completing "this change will…"`), docs travel with the code. Use when the user says "commit", "what's the commit message", or is about to commit a working tree touching more than one concern, in a repo where `[ -d .jj ]` fails. jj repos → commit-atomic-jj.
---

# commit-atomic-git

git-native counterpart of [commit-atomic-jj](../commit-atomic-jj/SKILL.md).
Same principles; the staging area replaces `jj split`, and there is no
`jj new` step — but git has its own traps (blind `-a`, `add .`).

## Principles

### 1. Inspect first — all three states
**Never commit from memory. Read the diff.**
- `git status --short` — staged, unstaged, **untracked** (invisible to
  plain `git diff`; add `-N` to make new files diffable).
- `git diff` (unstaged) **and** `git diff --cached` (what will actually
  commit). Read every line of both. Flag debug prints, commented-out
  blocks, stray whitespace, accidental edits.
- Diff doesn't match intent → fix or re-stage before committing.

### 2. One concern per commit — the staging area is the splitter
- Mixed working tree → stage one concern (`git add <paths>`), commit,
  repeat until `git status` is clean. Never `git commit -a` or
  `git add .` on a mixed tree — that's `jj describe` without `jj split`.
- Two concerns inside one file → hunk-level split. `git add -p` is
  interactive (unavailable headless); instead: `git diff <file> > c.patch`,
  edit the patch down to one concern's hunks, `git apply --cached c.patch`.
- Style refactors are their own commit — never share one with logic.
- Tests for existing behaviour: own commit, unless they land with the
  new behaviour they cover ([bdd](../../engineering/bdd/SKILL.md)).

### 3. Semantic format
```
type(scope): imperative phrase completing "this change will…"
```
- `type` ∈ `feat`, `fix`, `refactor`, `perf`, `test`, `docs`, `build`,
  `chore`, `style`.
- Imperative: **"add"**, **"fix"**, **"remove"** — never "added",
  "adds", "now does X".
- Subject ≤ 72 chars; body bullets ≤ 90, same `type(scope):` shape.

### 4. Ticket references (optional, project-configurable)
Project uses a ticket prefix → body verbs `starts/extends/ends <PREFIX>-N`.
No convention → omit; don't invent a prefix.

### 5. Blueprint citations
A change executing `OKF/blueprints/NNN` cites it in the body:
`implements blueprint NNN`.

### 6. Docs travel with the code
Same commit includes: updated docstring for a changed public signature;
README / CLAUDE.md for a new flag, script, env var, command; a doc under
`docs/` for any non-self-evident analysis result. One-line docstrings
fine; none is not.

## Workflow

```
git status --short                   # 1. see all three states
git add -N .                         # 2. make untracked diffable
git diff                             # 3. read every line
git add <paths-for-first-concern>    # 4. stage one concern only
git diff --cached                    # 5. read what will commit
git commit -m '...'                  # 6. semantic message (always -m)
git show --stat HEAD                 # 7. verify message matches diff
# tree still dirty? -> back to 4 for the next concern
```

Guard every commit-message-taking command with `-m` (and
`GIT_EDITOR=true` as belt-and-braces) — a headless `$GIT_EDITOR` spawn
hangs the session.

## Anti-patterns

- **`git commit -am` / `git add .` on a mixed tree** — sweeps strays
  and welds concerns; the staging area exists precisely so you don't.
- **Committing without reading `git diff --cached`** — staged ≠ what
  you remember staging.
- **Forgetting untracked files** — plain `git diff` never shows them;
  `status --short` + `add -N` first.
- **Past-tense / no-scope messages** — `"added auth"`, `feat: add
  login`. Use `feat(auth): add OAuth2 login flow`.
- **Docs in the next commit** — you won't. Same commit or it didn't ship.
- **Amending pushed commits** — `--amend` only before push, unless a
  force-push is the agreed plan.

## See also
- [../commit-atomic-jj/SKILL.md](../commit-atomic-jj/SKILL.md) — jj
  counterpart; shared philosophy, worked split example in its
  examples.md translates 1:1 (staging instead of `jj split`).
- [../resolve-conflicts-git/SKILL.md](../resolve-conflicts-git/SKILL.md)
  — sealing a resolved merge lands here.
