---
name: build-r-analysis
description: Scaffold an R analysis: renv + targets + Quarto on rocker/verse; Docker via containerize-project.
disable-model-invocation: true
---

# build-r-analysis

## When to use
- User says "new R analysis", "scaffold R analysis", "/build-r-analysis".
- A fresh directory needs renv + targets + Quarto on rocker/verse.

## Inputs to collect (one grouped prompt)
- **Project name** (snake_case).
- **One-line description**.

## Process

1. **Confirm target directory** is empty (or user-confirmed override).
2. **Materialise files** from sibling templates:
   ```
   <project>/
   ├── R/functions/.gitkeep
   ├── R/pipeline/load_data.R       ← R-pipeline-load_data.R.tpl
   ├── data/raw/.gitkeep
   ├── data/processed/.gitkeep
   ├── reports/index.qmd            ← reports-index.qmd.tpl
   ├── tests/testthat/test-functions.R  ← tests-test-functions.R.tpl
   ├── _targets.R                   ← _targets.R.tpl
   ├── justfile                     ← justfile.tpl
   └── .gitignore                   ← gitignore.tpl
   ```
3. **Delegate Docker** to
   `/containerize-project`
   (r-analysis variant): it writes `Dockerfile`, `docker-compose.yml`,
   `.dockerignore`, and appends the Docker recipes to the justfile.
4. **Stop. Do not run `jj describe`.** Tell the user:
   > "Review with `jj diff`. Then `just build-dev` → `just up` → `R -e
   > 'renv::init()'` to lock dependencies. Then `just run` to execute
   > the pipeline. Describe with
   > `/commit-atomic-jj` when satisfied."

## Placeholders used by templates
- `<project-name>` — snake_case project name.
- `<description>` — one-line description (for `reports/index.qmd`).

## Guardrails
- **Never** scaffold into a non-empty directory without confirmation.
- **Never** invoke `jj describe` — first commit is the user's call.
- **Never** invoke `renv::init()` for the user.
- **`R/functions/` and `R/pipeline/` follow `box::use` rules** —
  no `library()`, no `source()`. See
  `/style-r`.
- **Skeleton `_targets.R` has two demo targets** (`raw`, `processed`)
  showing the box-imported pipeline pattern. Replace, don't extend.

## See also
- `/containerize-project`
  — owns the Docker templates and the three-stage pattern rationale.
- `/develop-r`
  — workflow auto-detects `_targets.R` → R-analysis loop.
- `/style-r`
  — every function in `R/functions/` and `R/pipeline/` follows these.
- `/bdd`
  — `tests/testthat/` opens with the standard `box::use(testthat[...])`
  prologue (see `bdd/tests-r.md`).
