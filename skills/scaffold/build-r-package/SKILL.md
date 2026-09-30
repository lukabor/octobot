---
name: build-r-package
description: "Scaffold an R package: renv + justfile + DESCRIPTION + testthat ed. 3; Docker via containerize-project."
disable-model-invocation: true
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
   ├── justfile                    ← justfile.tpl
   ├── DESCRIPTION                 ← DESCRIPTION.tpl
   └── .gitignore                  ← gitignore.tpl
   ```
3. **Delegate Docker** to
   `/containerize-project`
   (r-package variant): it writes `Dockerfile`, `docker-compose.yml`,
   `.dockerignore`, and appends the Docker recipes to the justfile.
4. **Stop. Do not run `jj describe`.** Tell the user:
   > "Review with `jj diff`. Then run `just build-dev` → `just up` → `R
   > -e 'renv::init()'` to lock dependencies; then `just document` and
   > `just check`. Describe the change with
   > `/commit-atomic-jj` when satisfied."
5. **Suggest** `/write-readme`,
   which already covers r-package; its dedicated R counterpart is
   B-001, still a draft.

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
- `/containerize-project`
  — owns the Docker templates and the three-stage pattern rationale.
- `/develop-r`
  — workflow auto-detects DESCRIPTION → R-package loop.
- `/style-r`
  — coding standards every function in `R/` must follow.
