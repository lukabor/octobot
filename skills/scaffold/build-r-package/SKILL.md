---
name: build-r-package
description: Scaffold a new R package with renv for dependency management, a three-stage Docker setup (base/production/development) on rocker/r-ver, docker-compose, justfile task runner, DESCRIPTION, NAMESPACE generation via roxygen2, and testthat ed. 3. Materialises files into a target directory and stops on `jj diff` for review before any commit. Use when the user says "new R package", "scaffold R package", "create R package", "set up R package", "bootstrap R package", "/build-r-package".
---

# build-r-package

## When to use
- User says "new R package", "scaffold R package", "/build-r-package".
- A fresh empty directory needs the renv + rocker + DESCRIPTION setup.

## Inputs to collect (one grouped prompt)
- **Package name** (letters, numbers, dots; starts with a letter; no
  trailing dot). Validate.
- **Author name + email** for `Authors@R`.
- **One-line title** (sentence-case, no trailing period).
- **One-paragraph description**.
- **License** (default: `MIT + file LICENSE`).

## Process

1. **Confirm target directory** is empty (or user-confirmed override).
2. **Materialise files** from sibling templates:
   ```
   <package>/
   ├── R/<package>-package.R
   ├── tests/testthat/test-<package>.R
   ├── Dockerfile                  ← Dockerfile.tpl
   ├── docker-compose.yml          ← docker-compose.yml.tpl
   ├── justfile                    ← justfile.tpl
   ├── DESCRIPTION                 ← DESCRIPTION.tpl
   └── .gitignore                  ← gitignore.tpl
   ```
3. **Stop. Do not run `jj describe`.** Tell the user:
   > "Review with `jj diff`. Then run `just build-dev` → `just up` → `R
   > -e 'renv::init()'` to lock dependencies; then `just document` and
   > `just check`. Describe the change with
   > [`/jj-atomic`](../../productivity/jj-atomic/SKILL.md) when satisfied."
4. **Suggest** `/write-readme-py`'s R counterpart once it exists (not
   yet — see octobot/README.md *Out of scope*).

## Placeholders used by templates
- `<package-name>` — R package name (validated above).
- `<author-name>`, `<author-email>` — for `Authors@R`.
- `<title>` — one-line title.
- `<description>` — one-paragraph description.
- `<license>` — default `MIT + file LICENSE`.

## Guardrails
- **Never** scaffold into a non-empty directory without confirmation.
- **Never** invoke `jj describe` — first commit is the user's call.
- **Never** invoke `renv::init()` for the user — `renv.lock` should be
  generated from inside the container so the lock matches the runtime.
- **Never** generate `NAMESPACE` here — it's roxygen2's job, run via
  `just document` after the first edit.
- **`R/` is empty by design** apart from `<package>-package.R`. Don't
  invent stub functions.

## See also
- [`../../_concepts/three-stage-dockerfile.md`](../../_concepts/three-stage-dockerfile.md)
  — rationale for `Dockerfile.tpl`.
- [`../../engineering/dev-r/SKILL.md`](../../engineering/dev-r/SKILL.md)
  — workflow auto-detects DESCRIPTION → R-package loop.
- [`../../engineering/r-style/SKILL.md`](../../engineering/r-style/SKILL.md)
  — coding standards every function in `R/` must follow.
