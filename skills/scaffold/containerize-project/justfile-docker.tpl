# ── Docker ──────────────────────────────────────────────────────────────
build-dev:
    docker compose build dev

build-prod:
    docker compose build production

up:
    docker compose run --rm dev bash

up-prod:
    docker compose run --rm production

down:
    docker compose down

rebuild:
    docker compose build --no-cache dev
