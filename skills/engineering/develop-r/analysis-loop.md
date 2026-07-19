# develop-r — R-analysis loop

Detected by the presence of `_targets.R` at the repo root. Apply
[`../style-r/SKILL.md`](../style-r/SKILL.md) at every implementation step.

## 1. Implement

- Functions in `R/functions/` as box modules.
- Pipeline steps in `R/pipeline/` as box modules.
- All code under [`/style-r`](../style-r/SKILL.md).

## 2. Lint & style

```bash
just lint
just style-check    # fix with: just style
```

## 3. Test (TDD-BDD)

Hand to [`/bdd`](../bdd/SKILL.md), which loops red→green→refactor
**one scenario at a time** — never write all the tests upfront (see
[`../bdd/anti-patterns.md`](../bdd/anti-patterns.md)). Target
`R/functions/`. Then:

```bash
just test
```

## 4. Pipeline

```bash
just run            # targets::tar_make()
```

Verify outputs in `data/processed/`.

## 5. Render (if applicable)

```bash
just render         # quarto render reports/
```

## 6. Commit

Hand to [`/commit-atomic-jj`](../../productivity/commit-atomic-jj/SKILL.md).
