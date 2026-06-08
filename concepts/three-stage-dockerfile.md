# Three-stage Dockerfile (base / production / development)

A pattern for projects where the same image needs to (a) build small
production artefacts and (b) host a productive interactive shell, without
maintaining two parallel Dockerfiles.

## The skeleton

```dockerfile
# ── base ────────────────────────────────────────────────────────────────
FROM <runtime>:<version>-slim AS base

RUN apt-get update && apt-get install -y --no-install-recommends \
    <shared system deps> \
    && rm -rf /var/lib/apt/lists/*

# Install the language-level package manager (uv, renv, …) — once.
WORKDIR /usr/<project>

# ── production ──────────────────────────────────────────────────────────
FROM base AS production
COPY <lock file(s)> ./
RUN <pkg-mgr> sync --no-dev --frozen
COPY . .
RUN <pkg-mgr> sync --no-dev --frozen          # final install
CMD ["<runtime>", "<entrypoint>"]

# ── development ────────────────────────────────────────────────────────
FROM base AS development
COPY <lock file(s)> ./
RUN <pkg-mgr> sync --group dev --frozen
COPY . .
RUN <pkg-mgr> sync --group dev --frozen
CMD ["bash"]
```

Both `production` and `development` inherit from `base` — system deps and
the package manager install happen **once**, not twice.

## Why three stages, not two

- **Production-only**: misses dev tools (linter, formatter, type checker,
  test runner). Any quality check forces a rebuild with a different
  Dockerfile or a `docker exec` into an unprepared image.
- **Dev-only**: ships your linter and notebook server to production.
  Image is larger; surface area for CVEs is larger.
- **Three stages**: one source of truth for system deps + package
  manager. `docker compose build --target production` and `--target
  development` produce two distinct images from one file.

## docker-compose.yml pairing

```yaml
services:
  dev:
    build: { context: ., dockerfile: Dockerfile, target: development }
    volumes:
      - .:/usr/<project>          # source mount for hot edits
  production:
    build: { context: ., dockerfile: Dockerfile, target: production }
```

`just up` runs the `dev` service interactively. CI builds the
`production` target.

## Caveats / when not to use

- **Single-binary builds** (Go, Rust release artefacts) don't benefit
  much; the production stage doesn't need a package manager at all.
  Use a `FROM scratch` final stage instead.
- **Heavyweight base images** (CUDA, JDK toolchains) where the
  cold-start cost dwarfs the package install — sometimes a single-stage
  Dockerfile with a build arg `INSTALL_DEV=true` is simpler.
- **Multi-arch builds** with QEMU — three stages multiply the
  cross-compile cost.

## Anti-pattern — copying source before lock install

```dockerfile
# WRONG — invalidates the dependency layer on every source change
FROM base AS production
COPY . .
RUN <pkg-mgr> sync --no-dev
```

Always `COPY <lock file>` and `<pkg-mgr> sync` *before* `COPY . .`. The
lock-install layer is then cached across iterations that only touch
source.

## Used by

- `scaffold/build-py-project` (uv-based)
- `scaffold/build-r-analysis` (renv on rocker/verse)
- `scaffold/build-r-package` (renv on rocker/r-ver)
