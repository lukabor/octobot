# write-readme — per-ecosystem extraction

What to read for each ecosystem, and the `<install-block>` /
`<usage-block>` snippet to emit. Fill `<...>` from the source; omit a line
when its source is absent.

## python (`pyproject.toml`)
Read: `project.name`, `project.description`, `project.dependencies`,
`project.requires-python`, `dependency-groups.dev`, `project.license`. Task
runner: `justfile` recipes (group by `# ── Section ──` comments).

```
## Installation
Requires Python <project.requires-python>. Install with [uv](https://docs.astral.sh/uv/):

uv pip install -e "."        # core: <core-deps-csv>
uv pip install -e ".[dev]"   # + dev tools: <dev-deps-csv>
```
Usage = `just` recipes. For the full `[dev]`-extras treatment defer to
[`../write-readme-py/SKILL.md`](../write-readme-py/SKILL.md).

## r-package (`DESCRIPTION`)
Read: `Package`, `Title`, `Description`, `Imports`, `License`.

```
## Installation
# install.packages("remotes")
remotes::install_github("<owner>/<Package>")
```
Usage = exported functions / vignette entry points.

## r-analysis (`_targets.R`)
Read: title/description from `index.qmd` front matter or `_targets.R`
header comment. Pipeline targets from `_targets.R`.

```
## Installation
renv::restore()   # reproduce the recorded library
```
Usage = `targets::tar_make()` plus the `justfile` recipes that wrap it.

## node (`package.json`)
Read: `name`, `description`, `dependencies`, `devDependencies`, `license`,
`scripts`.

```
## Installation
npm install        # or pnpm / yarn
```
Usage = the `scripts` block (`npm run <name>`).

## rust (`Cargo.toml`)
Read: `package.name`, `package.description`, `package.license`,
`dependencies`.

```
## Installation
cargo build --release
```
Usage = `cargo run` / installed binary, or `justfile` recipes.

## generic (no manifest)
Config / script / dotfile repos (e.g. shell installers, system configs).
Read: every script's leading comment, `Makefile`/`justfile`, and any
existing README. Ask the user for a one-line description if none is
inferable.

- `<install-block>` → "Clone the repo" or the prerequisite packages.
- `<usage-block>` → the actual setup commands, in order, **verbatim**.
- Group long setup guides under `##` headings per concern (drivers,
  browser, display, prompt, …) and link them from the table of contents.
- `<project-layout>` → annotate each top-level script/dir with its role.
