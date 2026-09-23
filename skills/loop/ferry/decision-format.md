# Ferry decision format

## MAP.md — `OKF/ferries/<topic>/MAP.md`

```markdown
---
type: Ferry Map
---

# ferry — <topic>

Destination: <one sentence — what "the way is clear" means>.

| id | decision | status | blocked-by | blueprint |
|---|---|---|---|---|
| D-1 | <title> | open | — | |
| D-2 | <title> | open | D-1 | |
| D-3 | <title> | resolved | — | 004 |
```

## Decision file — `D-<n>-<slug>.md`

```markdown
---
type: Decision
status: open | resolved | superseded-by-D-<m>
blocked-by: [D-1, D-2]   # empty list if unblocked
---

# D-<n> — <the decision as a question>

## Why it must be decided
<what downstream work it blocks; one paragraph>

## Options
- **A — <name>**: <one-line description, chief trade-off>
- **B — <name>**: ...

## Recommendation
<the agent's pick + reason — written BEFORE asking, grilling-style>

## Resolution
<empty until resolved: the choice, the user's rationale, date.
Append-only — a changed mind is a new decision superseding this one.>
```

## Rules

- One genuine decision per file; a compound question splits.
- `type:` frontmatter (`Ferry Map` / `Decision`) is the OKF-v0.1
  conformance field — always first.
- `blocked-by` edges must be acyclic — check when adding, not when stuck.
- Status flips only with a filled Resolution; Resolution never edited
  after — supersede with a new decision instead.
- The `blueprint` column in MAP.md fills as `/blueprint`
  crystallises resolutions into `OKF/blueprints/NNN`.
