# moor — mechanical detail

Blocks the [SKILL.md](SKILL.md) steps invoke but need not inline. Each
section is linked from the step that uses it. Nothing here changes moor's
behaviour — it is the same instructions, moved off the spine.

## GRADUATE {#graduate}

The graduated `decisions/NNN-<slug>.md` carries the frontmatter of
[DECISION-FORMAT.md](../../engineering/model-domain/DECISION-FORMAT.md)
plus a question-shaped `decisions/index.md` line. The `Resolution` body
moves **verbatim** — one home, never two copies; `Options` and `Why it
must be decided` stay behind for COLLAPSE. `blocked-by` edges drop; the
register is not a dependency graph. A resolution that fails the warrant
test graduates nowhere and stays in the collapsed page — graduation is
the default, not an obligation.

## COLLAPSE {#collapse}

The pin is read off `@-`, because the sealing commit cannot name itself
and the parent is where the `D-<n>` files still exist:

```
jj log -r @- --no-graph -T 'change_id ++ " " ++ commit_id'
```

The page opens `type: Ferry Map`, then the pin:

```yaml
sealed:
  change: <jj change id>
  commit: <git hash>
  date: <ISO date>
```

A ferry that mustered (step 3) also carries `review-base: <changeid>`
in this block.
