# <project.name>

<table>
<tr>
<td width="40%" align="center">
  <logo-block>
  <h3><project.name></h3>
  <p><project.description></p>
</td>
<td width="60%">

## Table of Contents
- [Installation](#installation)
- [Docker (dev)](#docker-dev)
- [Quality checks](#quality-checks)
- [Project layout](#project-layout)
- [License](#license)

</td>
</tr>
</table>

## Installation

Requires Python <project.requires-python>. Install with [uv](https://docs.astral.sh/uv/):

```bash
<install-block>
```

## Docker (dev)

Uses [just](https://github.com/casey/just) as a task runner. Run `just --list` for the full set of recipes.

```bash
<docker-section>
```

## Quality checks

All checks run inside Docker.<local-checks-preamble>

```bash
# Linting
<lint-fmt-section>

# Type checking
<typecheck-section>

# Testing
<test-section>

# Combined
<combined-section><local-section>
```

## Project layout

```
src/<package_name>/   # library source
tests/                # test suite
docker-compose.yml
Dockerfile
justfile
pyproject.toml
```

## License

<license-block>
