---
name: build-py-project
description: Scaffold a Python project: uv + justfile + pyproject (ruff, ty, pytest); Docker via containerize-project.
disable-model-invocation: true
---

# build-py-project

## When to use
- User says "new python project", "scaffold python", "/build-py-project".
- A fresh empty directory needs the standard uv + Docker + justfile setup.

## Inputs to collect (one grouped prompt)
- **Project name** (kebab-case, e.g. `my-project`).
- **Package name** (derived: lowercase, hyphens → underscores; confirm).
- **Author name + email** for `pyproject.toml`.
- **One-line description** for `pyproject.toml`.
- **License** (default: MIT).

## Process

1. **Confirm target directory.** Refuse to write into a non-empty
   directory unless the user explicitly opts in.
2. **Materialise files** from sibling templates with placeholder
   substitution. Files written:
   ```
   <project>/
   ├── src/<package>/__init__.py
   ├── tests/fixtures/.gitkeep
   ├── justfile                   ← justfile.tpl
   ├── pyproject.toml             ← pyproject.toml.tpl
   ├── README.md                  ← README.md.tpl (stub; hatchling needs
   │                                it to exist — /write-readme-py replaces it)
   └── .gitignore                 ← gitignore.tpl
   ```
3. **Delegate Docker** to
   [`/containerize-project`](../containerize-project/SKILL.md) (python
   variant): it writes `Dockerfile`, `docker-compose.yml`,
   `.dockerignore`, and appends the Docker recipes to the justfile.
4. **Stop. Do not run `jj describe`.** Tell the user:
   > "Review with `jj diff` (or `git status` + `git diff`). Then run
   > `just build-dev` to verify the toolchain. Describe the change with
   > [`/jj-atomic`](../../productivity/jj-atomic/SKILL.md) when satisfied."
5. **Suggest** running [`/write-readme-py`](../../engineering/write-readme-py/SKILL.md)
   after the first successful build to generate the README.

## Placeholders used by templates
- `<project-name>` — kebab-case project name.
- `<package_name>` — snake_case Python package name.
- `<author-name>`, `<author-email>` — for `pyproject.toml`.
- `<description>` — one-line project description.
- `<license>` — SPDX identifier (default `MIT`).

## Guardrails
- **Never** scaffold into a non-empty directory without explicit user
  confirmation.
- **Never** invoke `jj describe` — the first commit is the user's call.
- **Never** invent dependency versions beyond the conservative pins in
  `pyproject.toml.tpl`.
- **Never** add packages outside the templates without asking — keep
  the scaffold lean and let the user grow it.

## See also
- [`../containerize-project/SKILL.md`](../containerize-project/SKILL.md)
  — owns the Docker templates and the three-stage pattern rationale.
- [`../../engineering/dev-python/SKILL.md`](../../engineering/dev-python/SKILL.md)
  — workflow that this scaffold sets up.
- [`../../engineering/write-readme-py/SKILL.md`](../../engineering/write-readme-py/SKILL.md)
  — README generator that reads the scaffolded `pyproject.toml` and
  `justfile`.
