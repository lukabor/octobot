# <project-name> — task runner
# `just --list` for all recipes.

set dotenv-load := false

default:
    @just --list

# Docker recipes (build-dev, up, down, …) are appended by
# /containerize-project from its justfile-docker.tpl.

# ── Linting & Formatting ────────────────────────────────────────────────
lint:
    docker compose run --rm --no-deps dev ruff check src/ tests/

lint-fix:
    docker compose run --rm --no-deps dev ruff check --fix src/ tests/

fmt-check:
    docker compose run --rm --no-deps dev ruff format --check src/ tests/

fmt:
    docker compose run --rm --no-deps dev ruff format src/ tests/

# ── Type Checking ───────────────────────────────────────────────────────
typecheck:
    docker compose run --rm --no-deps dev ty check src/

# ── Testing ─────────────────────────────────────────────────────────────
test:
    docker compose run --rm dev pytest

test-verbose:
    docker compose run --rm dev pytest -v

# ── Combined ────────────────────────────────────────────────────────────
check: lint fmt-check typecheck test

fix-and-check: lint-fix fmt typecheck test
