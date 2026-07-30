# moor — collapse a moored ferry

The block [SKILL.md](SKILL.md) step 6 invokes but need not inline. Nothing
here changes moor's behaviour — it is the same instructions, moved off the
spine.

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
