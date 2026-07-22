---
name: write-readme-py
description: Generate a README from pyproject.toml + justfile in the Saduko two-column layout.
disable-model-invocation: true
---

# write-readme-py

## When to use
- Inside a Python project (has `pyproject.toml` and `justfile`).
- User says "write readme", "/write-readme-py", "generate readme".

## Process

1. **Read sources.**
   - `pyproject.toml` → `project.name`, `project.description`,
     `project.requires-python`, `project.dependencies`,
     `project.optional-dependencies` (every group,
     not just `dev`), `project.license`, `project.authors[0]`,
     `project.urls.Repository` (fall back to `Homepage`).
   - `justfile` → each recipe name plus the comment line(s) above it.
     Group by section comments (lines like `# ── Docker ───`).
     Detect `local-*` recipes separately for the Local subsection.
   - `assets/` → first match of `<name>.png`, `<name>.svg`, `<name>.jpg`
     becomes the logo. Missing is fine — skip the `<img>` tag.

2. **Refuse to invent.** If `project.description` is empty, ask for one
   line before writing. Do not fabricate dependency versions, deps not
   listed, recipes not in the justfile, an author, or a repo URL.

3. **Materialise `README.md`** from
   [`readme-py.template.md`](readme-py.template.md), substituting:
   - `<project.name>`, `<project.description>`, `<project.requires-python>`,
     `<package_name>` (the `project.name` with hyphens → underscores).
   - `<logo-block>` → `<img src="assets/<name>.<ext>" alt="<name> logo" width="200"/>`
     if the asset exists; empty string otherwise.
   - `<install-block>` → one `uv pip install -e ".[<group>]"` line per
     optional-dependencies group, each annotated with the group's deps in
     a trailing comment. Lead with `uv pip install -e "."` for the core.
   - `<docker-section>`, `<lint-fmt-section>`, `<typecheck-section>`,
     `<test-section>`, `<combined-section>` — built from the justfile.
     Omit any section whose recipes are absent.
   - `<local-checks-preamble>` → ` Use \`local-*\` variants if you have
     \`uv\` installed locally.` when any `local-*` recipes exist; empty
     otherwise.
   - `<local-section>` → a `# Local (requires uv)` block listing each
     `local-*` recipe; empty if none.
   - `<license-block>` →
     - **Apache 2.0**: full rights / requirements / attribution / bibtex
       block (see [`saduko-license-block.md`](saduko-license-block.md)),
       substituting `<project.name>`, `<author>`, `<author-surname>`,
       `<author-given>`, `<year>`, `<repo-url>`.
     - **Anything else**: one line — `<project.name> is licensed under
       <project.license.text>.`

4. **Stop.** Tell the user:
   > "Review the Installation extras and the License block — extras must
   > match `project.optional-dependencies`; the License block defaults to
   > Apache 2.0 wording only when `project.license` says so. Drop a
   > `assets/<name>.png` if you want the logo to render. When satisfied,
   > describe with [`/commit-atomic-jj`](../../productivity/commit-atomic-jj/SKILL.md)."

## Guardrails
- **Never** invent dependency versions, recipe descriptions, author
  names, or repo URLs.
- **Never** commit. Stop after writing the file.
- **Omit sections** with no source data instead of hallucinating.
- **License wording is license-specific.** Only emit the rich Saduko
  attribution block for Apache 2.0; other licenses get the one-liner.

## Out of scope
- R projects. Generic [`../write-readme/SKILL.md`](../write-readme/SKILL.md)
  covers them — it detects `DESCRIPTION` (r-package) and `_targets.R`
  (r-analysis) and reads their fields. No R counterpart to this skill is
  planned.

## See also
- [`saduko-license-block.md`](saduko-license-block.md) — the Apache 2.0
  rights / requirements / attribution / bibtex template, lifted from the
  Saduko reference and parameterised.
- [`../../scaffold/build-py-project/SKILL.md`](../../scaffold/build-py-project/SKILL.md)
  — produces the `pyproject.toml` + `justfile` this skill reads.
- [`../develop-python/SKILL.md`](../develop-python/SKILL.md) — the workflow
  whose `just check` commands this README documents.
