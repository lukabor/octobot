# Designing the project validator

The validator is the shared checkpoint every skill ends on. It turns the repo's
silent failure modes into a fast, deterministic check so contributors catch
wiring mistakes in seconds instead of hours into a pipeline run.

## 1. Enumerate the invariants

Walk the extension tasks and ask "what holds when this is done right?" Typical
invariants in a config-driven `{targets}`-style R pipeline:

- **Identity match** — a node's declared `name` string equals its
  `tar_target()` symbol.
- **Naming convention** — node names carry the expected prefix for their group.
- **Registration** — every declared node appears in the registry that decides
  what gets built. *This is usually the headline silent killer:* declared but
  unregistered → never built, no error.
- **Config completeness** — each config file has its load-critical keys,
  non-empty, and valid syntax.
- **Cross-reference** — each config id is wired into the loader/registry that
  attaches its behavior (formatter/handler).

Only encode invariants the repo *actually* holds today. Inventing stricter
rules makes the validator fail on the main branch and trains people to ignore it.

## 2. Parse structurally, not by grep

Naive `grep` for `name =` catches palette args, filenames, and unrelated keys.
Parse the source instead. In R, `parse()` + a recursive AST walk lets you match
the exact idiom (`list(name = "x", target = tar_target(x, ...))`) and ignore
look-alikes. Compare the declared string to the actual symbol; check membership
against the registry file's text.

## 3. Severities tuned to pass clean

- **Errors** fail the run (exit ≠ 0): the structural invariants above.
- **Warnings** are advisory: pre-existing inconsistencies (filename vs id
  mismatches, optional blocks). Run the validator on the untouched main branch
  and demote anything that fires there from error to warning, or fix the tree.
  Goal: **zero errors on a clean checkout.**

## 4. Scope to what changed

Default to a full audit; add a `--changed [base]` mode for the skill checkpoint
so it only reports on files the contributor touched. Combine three git sources
so a brand-new file is never skipped:

- committed diff vs the base (`git diff --name-only <base>`),
- working-tree changes (`git diff --name-only HEAD`),
- **untracked** files (`git ls-files --others --exclude-standard`).

The untracked source matters most — a freshly-added config is untracked and
`git diff` alone misses it.

## 5. Wire it and prove it

- Add a task-runner recipe: `validate *args: <runner> scripts/validate_extension.* {{args}}`.
- Prove each check fires: inject one violation of each invariant, run
  `--changed`, confirm the matching error, then revert.
- Leave style/lint rules (imports, extraction idioms) to the existing linter and
  the module skill — don't duplicate a third copy in the validator.
