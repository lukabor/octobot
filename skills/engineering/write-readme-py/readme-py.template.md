# <project.name>

<table>
<tr>
<td width="40%" align="center">
  <h3><project.name></h3>
  <p><project.description></p>
</td>
<td width="60%">

## Table of Contents
- [Installation](#installation)
- [Docker](#docker)
- [Quality checks](#quality-checks)
- [Project layout](#project-layout)
- [License](#license)

</td>
</tr>
</table>

## Installation

Requires Python ≥ 3.11. Install with [uv](https://docs.astral.sh/uv/):

```bash
uv pip install -e "."        # core: <core-deps-csv>
uv pip install -e ".[dev]"   # + dev tools: <dev-deps-csv>
```

## Docker

Uses [just](https://github.com/casey/just) as a task runner.
Run `just --list` for the full set of recipes.

```bash
<docker-section>
```

## Quality checks

All checks run inside Docker via `just`.

```bash
# Linting
<lint-fmt-section>

# Type checking
<typecheck-section>

# Testing
<test-section>

# Combined
<combined-section>
```

## Project layout

```
src/<package_name>/   # library source
  __init__.py
tests/
  fixtures/           # real data fixtures for tests
Dockerfile            # base / production / development stages
docker-compose.yml    # dev + production services
justfile              # task runner
pyproject.toml        # dependencies and tool config
```

## License

<project.name> is licensed under <project.license.text>.
