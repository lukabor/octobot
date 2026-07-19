# develop-r — R-package loop

Detected by the presence of `DESCRIPTION` at the repo root. Apply
[`../style-r/SKILL.md`](../style-r/SKILL.md) at every implementation step.

## 1. Implement

- Code in `R/`, following [`/style-r`](../style-r/SKILL.md) (box, native
  pipe, `\(x)`, snake_case).
- Add/update roxygen2 docs on every exported function.

## 2. Document

```bash
just document       # devtools::document()
```

Fix all roxygen2 warnings.

## 3. Lint & style

```bash
just lint           # lintr
just style-check    # styler dry run
# if style-check fails:
just style
```

## 4. Test (TDD-BDD)

Hand to [`/bdd`](../bdd/SKILL.md), which loops red→green→refactor
**one scenario at a time** — never write all the tests upfront (see
[`../bdd/anti-patterns.md`](../bdd/anti-patterns.md)). Test
prologue follows [`../bdd/tests-r.md`](../bdd/tests-r.md). Run:

```bash
just test           # devtools::test()
```

## 5. Full check

```bash
just check          # devtools::check()
```

All notes, warnings, and errors resolved before commit.

## 6. Commit

Hand to [`/commit-atomic-jj`](../../productivity/commit-atomic-jj/SKILL.md).
