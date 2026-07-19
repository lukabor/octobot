---
name: containerize-project
description: Add the three-stage Docker setup (base/production/development) to a uv or renv project.
disable-model-invocation: true
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
   - `build-dev` already present → leave the justfile alone, but read the
     recipe and confirm it actually builds the dev image; a same-named
     recipe with different semantics → surface it, don't assume.
4. **Stop. Do not run `jj describe`.** Tell the user:
   > "Review with `jj diff`. Then `just build-dev` to verify the
   > toolchain. Describe with `/commit-atomic-jj` when satisfied."

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
