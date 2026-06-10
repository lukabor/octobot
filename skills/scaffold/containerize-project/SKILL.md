---
name: containerize-project
description: Add a three-stage Docker setup (base/production/development) to a project — Dockerfile, docker-compose.yml, .dockerignore, and Docker recipes in the justfile. Detects the ecosystem from marker files (pyproject.toml → uv on python-slim; DESCRIPTION → renv on rocker/r-ver; _targets.R → renv on rocker/verse). Hardened defaults: non-root production user, pinned package-manager install, no source mount in the production service. Materialises files and stops on `jj diff` for review before any commit. Use when the user says "containerize", "dockerize", "add docker", "/containerize-project", or a scaffold skill (build-py-project, build-r-package, build-r-analysis) delegates Docker setup here.
---

# containerize-project

## When to use
- User says "containerize", "dockerize", "add docker", "/containerize-project".
- A `build-*` scaffold skill reaches its Docker step and delegates here.
- An existing uv or renv project needs the standard three-stage setup.

## Process

1. **Detect ecosystem** (in this order; ask if none or several match):
   | Marker | Variant | Templates |
   |---|---|---|
   | `pyproject.toml` | python | `Dockerfile.python.tpl`, `docker-compose.python.yml.tpl`, `dockerignore.python.tpl` |
   | `DESCRIPTION` | r-package | `Dockerfile.r-package.tpl`, `docker-compose.r.yml.tpl`, `dockerignore.r.tpl` |
   | `_targets.R` | r-analysis | `Dockerfile.r-analysis.tpl`, `docker-compose.r.yml.tpl`, `dockerignore.r.tpl` |
2. **Materialise** with placeholder substitution:
   - `Dockerfile` ← variant Dockerfile template
   - `docker-compose.yml` ← variant compose template
   - `.dockerignore` ← variant dockerignore template
3. **Justfile recipes** from `justfile-docker.tpl`:
   - No `justfile` → create one with the standard header
     (`set dotenv-load := false`, `default: @just --list`) plus the
     Docker section.
   - `justfile` exists without a `build-dev` recipe → append the
     Docker section.
   - `build-dev` already present → leave the justfile alone.
4. **Stop. Do not run `jj describe`.** Tell the user:
   > "Review with `jj diff`. Then `just build-dev` to verify the
   > toolchain. Describe with `/jj-atomic` when satisfied."

## Placeholders
- python: `<project-name>` (kebab-case), `<package_name>` (snake_case).
- r-package: `<package-name>`.
- r-analysis: `<project-name>` (snake_case).

## Guardrails
- **Never** overwrite an existing `Dockerfile`, `docker-compose.yml`, or
  `.dockerignore` without explicit confirmation — show a diff first.
- **Never** put credentials in `ENV`, `ARG`, or `COPY`-ed files — that's
  [`add-docker-secrets`](../add-docker-secrets/SKILL.md) territory.
- **Never** add a source mount to the production service — it overrides
  the baked image and defeats immutability.
- The development stage runs as root deliberately (bind mounts +
  interactive installs); production runs as `app`. Don't "fix" either.
- Keep the pinned uv image tag; never switch to `:latest`.

## See also
- [three-stage-dockerfile.md](three-stage-dockerfile.md) — rationale for
  the base/production/development pattern, caveats, anti-patterns.
- [`../add-docker-secrets/SKILL.md`](../add-docker-secrets/SKILL.md) —
  build-time and runtime secrets once the project needs credentials.
- [`../build-py-project/SKILL.md`](../build-py-project/SKILL.md),
  [`../build-r-package/SKILL.md`](../build-r-package/SKILL.md),
  [`../build-r-analysis/SKILL.md`](../build-r-analysis/SKILL.md) —
  scaffolds that delegate their Docker step here.
