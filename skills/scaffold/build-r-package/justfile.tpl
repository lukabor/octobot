# <package-name> — task runner
# `just --list` for all recipes.

set dotenv-load := false

default:
    @just --list

# ── Docker ──────────────────────────────────────────────────────────────
build-dev:
    docker compose build dev

build-prod:
    docker compose build production

up:
    docker compose run --rm dev bash

down:
    docker compose down

rebuild:
    docker compose build --no-cache dev

# ── Documentation ───────────────────────────────────────────────────────
document:
    docker compose run --rm --no-deps dev Rscript -e "devtools::document()"

# ── Linting & Formatting ────────────────────────────────────────────────
lint:
    docker compose run --rm --no-deps dev Rscript -e "lintr::lint_package()"

style:
    docker compose run --rm --no-deps dev Rscript -e "styler::style_pkg()"

style-check:
    docker compose run --rm --no-deps dev Rscript \
        -e "styler::style_pkg(dry = 'on')"

# ── Testing ─────────────────────────────────────────────────────────────
test:
    docker compose run --rm --no-deps dev Rscript -e "devtools::test()"

test-verbose:
    docker compose run --rm --no-deps dev Rscript \
        -e "devtools::test(reporter = 'progress')"

# ── Package checks ──────────────────────────────────────────────────────
check:
    docker compose run --rm dev Rscript -e "devtools::check()"

# ── Combined ────────────────────────────────────────────────────────────
check-fast: lint style-check test

fix-and-check: style document check
