# <project-name> — task runner
# `just --list` for all recipes.

set dotenv-load := false

default:
    @just --list

# Docker recipes (build-dev, up, down, …) are appended by
# /containerize-project from its justfile-docker.tpl.

# ── Pipeline ────────────────────────────────────────────────────────────
run:
    docker compose run --rm dev Rscript -e "targets::tar_make()"

status:
    docker compose run --rm --no-deps dev Rscript -e "targets::tar_visnetwork()"

rerun:
    docker compose run --rm dev Rscript \
        -e "targets::tar_invalidate(everything()); targets::tar_make()"

# ── Reports ─────────────────────────────────────────────────────────────
render:
    docker compose run --rm dev quarto render reports/

# ── Linting & Formatting ────────────────────────────────────────────────
lint:
    docker compose run --rm --no-deps dev Rscript \
        -e "lintr::lint_dir('R/')"

style:
    docker compose run --rm --no-deps dev Rscript \
        -e "styler::style_dir('R/')"

style-check:
    docker compose run --rm --no-deps dev Rscript \
        -e "styler::style_dir('R/', dry = 'on')"

# ── Testing ─────────────────────────────────────────────────────────────
test:
    docker compose run --rm --no-deps dev Rscript \
        -e "testthat::test_dir('tests/testthat')"

# ── Combined ────────────────────────────────────────────────────────────
check: lint style-check test

fix-and-check: style run test
