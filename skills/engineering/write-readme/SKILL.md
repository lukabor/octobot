---
name: write-readme
description: Generate a README.md for any project by detecting its ecosystem from marker files (pyproject.toml → python, DESCRIPTION → R package, _targets.R → R analysis, package.json → node, Cargo.toml → rust, none → generic/shell). Reads the manifest and task runner to populate name, description, install steps, usage commands, and license, then materialises a README from a shared template and stops on `jj diff` for review. Use when the user says "write readme", "/write-readme", "generate readme", "document the project".
---

# write-readme

## When to use
- Any project needs a README and you do not know its ecosystem up front.
- User says "write readme", "/write-readme", "generate readme",
  "document the project".
- For a confirmed Python project, the dedicated
  [`../write-readme-py/SKILL.md`](../write-readme-py/SKILL.md) carries the
  fuller `[dev]`-extras handling — prefer it once python is established.

## Process

1. **Detect ecosystem** (first marker wins; ask if none or several):
   | Marker | Ecosystem | Source of truth |
   |---|---|---|
   | `pyproject.toml` | python | `[project]` + `justfile` |
   | `DESCRIPTION` | r-package | `DESCRIPTION` fields |
   | `_targets.R` | r-analysis | `index.qmd` / `_targets.R` + `justfile` |
   | `package.json` | node | `package.json` (name/description/scripts) |
   | `Cargo.toml` | rust | `[package]` + `cargo`/`justfile` |
   | *(none of the above)* | generic | scripts, `Makefile`/`justfile`, repo files |

   Field-by-field extraction per ecosystem lives in
   [REFERENCE.md](REFERENCE.md).

2. **Read sources, never memory.** Pull `name`, `description`, `license`,
   dependencies, and runnable commands from the files above. For a generic
   repo, read the scripts and any existing README to learn what it does.

3. **Refuse to invent.** If the description is empty, ask the user for a
   one-line description before writing. Never fabricate dependency
   versions, deps not listed, recipes not in the task runner, or commands
   not in the repo. Keep shell commands **verbatim** — they are the
   author's tested values; flag anything suspect instead of "fixing" it.

4. **Materialise `README.md`** from
   [`readme.template.md`](readme.template.md):
   - `<project.name>`, `<project.description>`, `<project.overview>`,
     `<project.license.text>`.
   - `<install-block>` — the ecosystem's install snippet (REFERENCE.md).
   - `<usage-block>` — task-runner recipes (grouped by section comment),
     CLI invocation, or setup steps for a config/script repo.
   - `<project-layout>` — the real top-level tree, annotated.
   - **Omit** any section with no source data instead of padding it.

5. **Stop. Do not commit.** Tell the user:
   > "Review with `jj diff`. Check that the Installation and Usage blocks
   > match how you actually run this. Describe with `/jj-atomic` when
   > satisfied."

## Guardrails
- **Never** invent versions, dependencies, recipes, or commands.
- **Never** rewrite a tested shell command — quote it as-is, flag doubts.
- **Never** commit; stop after writing the file.
- **Omit** empty sections rather than hallucinating content.

## See also
- [`../write-readme-py/SKILL.md`](../write-readme-py/SKILL.md) — the
  worked python example and `readme-py.template.md` this skill generalizes.
- [`../../scaffold/containerize-project/SKILL.md`](../../scaffold/containerize-project/SKILL.md)
  — same marker-file ecosystem detection.
- [`../../productivity/jj-atomic/SKILL.md`](../../productivity/jj-atomic/SKILL.md)
  — the commit step this skill hands off to.
