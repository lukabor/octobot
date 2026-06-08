---
name: write-readme-py
description: Generate a README.md for a Python project scaffolded by `/build-py-project`. Reads `pyproject.toml` and `justfile` from the current directory to populate name, description, dependencies, license, and task-runner commands. Materialises a README.md and stops on `jj diff` for review before any commit. Use when the user says "write readme", "/write-readme-py", "generate readme", "document the project" inside a Python project.
---

# write-readme-py

## When to use
- Inside a Python project (has `pyproject.toml` and `justfile`).
- User says "write readme", "/write-readme-py", "generate readme".

## Process

1. **Read sources.**
   - `pyproject.toml` → `project.name`, `project.description`,
     `project.dependencies`, `dependency-groups.dev`, `project.license`.
   - `justfile` → each recipe name plus the comment line(s) above it.
     Group by section comments (lines like `# ── Docker ───`).

2. **Refuse to invent.** If `project.description` is empty, ask the user
   for a one-line description before writing. Do not fabricate
   dependency versions, deps not listed, or recipes not in the justfile.

3. **Materialise `README.md`** from
   [`readme-py.template.md`](readme-py.template.md), substituting:
   - `<project.name>`, `<project.description>`, `<project.license.text>`
   - `<core-deps-csv>`, `<dev-deps-csv>`
   - `<docker-section>`, `<lint-fmt-section>`, `<typecheck-section>`,
     `<test-section>`, `<combined-section>` — built from the justfile.
     Omit any section whose recipes are absent.

4. **Stop.** Tell the user:
   > "Review the Installation section — the `[dev]` extras may need
   > adjustment if you've added optional dependency groups beyond `dev`.
   > When satisfied, describe with [`/jj-atomic`](../../productivity/jj-atomic/SKILL.md)."

## Guardrails
- **Never** invent dependency versions or recipe descriptions.
- **Never** commit. Stop after writing the file.
- **Omit sections** with no source data instead of hallucinating.

## Out of scope
- R projects. The R counterpart (`write-readme-r`) is not yet written.
  Reading `DESCRIPTION` for packages and `_targets.R` + `index.qmd` for
  analyses is the planned interface.

## See also
- [`../../scaffold/build-py-project/SKILL.md`](../../scaffold/build-py-project/SKILL.md)
  — produces the `pyproject.toml` + `justfile` this skill reads.
- [`../dev-python/SKILL.md`](../dev-python/SKILL.md) — the workflow
  whose `just check` commands this README documents.
