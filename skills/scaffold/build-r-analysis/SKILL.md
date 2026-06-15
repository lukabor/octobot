---
name: build-r-analysis
description: Scaffold a new R analysis project with renv for dependency management, a justfile, a `_targets.R` workflow skeleton, and Quarto reports under `reports/`, then delegate the three-stage Docker setup on rocker/verse (Dockerfile, docker-compose, .dockerignore) to containerize-project. Configured with lintr, styler, testthat, and box. Materialises files and stops on `jj diff` for review before any commit. Use when the user says "new R analysis", "scaffold R project", "create R analysis", "set up R data science project", "new quarto project", "/build-r-analysis".
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
   [`/containerize-project`](../containerize-project/SKILL.md)
   (r-analysis variant): it writes `Dockerfile`, `docker-compose.yml`,
   `.dockerignore`, and appends the Docker recipes to the justfile.
4. **Stop. Do not run `jj describe`.** Tell the user:
   > "Review with `jj diff`. Then `just build-dev` → `just up` → `R -e
   > 'renv::init()'` to lock dependencies. Then `just run` to execute
   > the pipeline. Describe with
   > [`/jj-atomic`](../../productivity/jj-atomic/SKILL.md) when satisfied."

## Placeholders used by templates
- `<project-name>` — snake_case project name.
- `<description>` — one-line description (for `reports/index.qmd`).

## Guardrails
- **Never** scaffold into a non-empty directory without confirmation.
- **Never** invoke `jj describe` — first commit is the user's call.
- **Never** invoke `renv::init()` for the user.
- **`R/functions/` and `R/pipeline/` follow `box::use` rules** —
  no `library()`, no `source()`. See
  [`../../engineering/r-style/box.md`](../../engineering/r-style/box.md).
- **Skeleton `_targets.R` has two demo targets** (`raw`, `processed`)
  showing the box-imported pipeline pattern. Replace, don't extend.

## See also
- [`../containerize-project/SKILL.md`](../containerize-project/SKILL.md)
  — owns the Docker templates and the three-stage pattern rationale.
- [`../../engineering/dev-r/SKILL.md`](../../engineering/dev-r/SKILL.md)
  — workflow auto-detects `_targets.R` → R-analysis loop.
- [`../../engineering/r-style/SKILL.md`](../../engineering/r-style/SKILL.md)
  — every function in `R/functions/` and `R/pipeline/` follows these.
- [`../../engineering/bdd/SKILL.md`](../../engineering/bdd/SKILL.md)
  — `tests/testthat/` opens with the standard `box::use(testthat[...])`
  prologue (see `bdd/tests-r.md`).
