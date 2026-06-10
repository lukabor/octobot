# <package-name> — task runner
# `just --list` for all recipes.

set dotenv-load := false

default:
    @just --list

# Docker recipes (build-dev, up, down, …) are appended by
# /containerize-project from its justfile-docker.tpl.

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
