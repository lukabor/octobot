# Worked example — splitting a mixed change

A real shape: the working copy contains both a style refactor (replacing
`source()` with `box::use`) **and** a bug fix (adding a defensive
`data.table::copy()` at a boundary). They must not share a commit.

## Before — `jj diff` (mixed)

```
M R/base/dw_base_data.R
- source("R/base/dw_hippie.R", local = TRUE)
+ box::use(./dw_hippie[load_hippie])
+ load_hippie()

M R/indication/assemble_expr.R
+ dt_in <- data.table::copy(dt_in)
  dt_in[, log_expr := log1p(expr)]
  dt_in
```

Two concerns, one working copy. Splitting before describing.

## The split

```bash
jj diff                                                 # confirm what's there
jj split R/indication/assemble_expr.R                   # interactive — keep only the fix
# leaves the box::use change in the new child commit
jj describe -r @- -m "<message for first change>"
jj describe       -m "<message for second change>"
```

(`jj split <paths>` puts the named paths in the *parent* of the new
commit; the remaining paths stay in `@`. Adjust per `jj` version.)

## After — two atomic commits

### Commit A — the bug fix (lands first; ticket starts here)

```
fix(assemble_expr): defensive copy of input data.table; starts DRAKE-42

* fix(assemble_expr): copy at boundary, stop in-place mutation; extends DRAKE-42
* test(assemble_expr): add idempotence test; extends DRAKE-42
* docs(assemble_expr): note reference-semantics contract; extends DRAKE-42
```

Why this works:
- Subject is one concern (the fix) and reads naturally after "this
  change will…".
- Body bullets are each one concern, each `type(scope): imperative`.
- The test ships with the fix (see
  `/bdd`).
- The docstring update ships with the fix (see
  [SKILL.md §4](SKILL.md)).

### Commit B — the style refactor

```
refactor(base): replace source() with box::use for dw_hippie; ends DRAKE-43

* refactor(base): swap source() for ./dw_hippie box import; ends DRAKE-43
```

Why this works:
- A style refactor is **never** part of a logic change.
- One-bullet body is fine when the subject already says everything.
- Different ticket because it's a different concern.

## Anti-pattern — what NOT to do

```
fix: refactor and fix assemble_expr            ← two concerns
* added defensive copy                          ← past tense
* swapped source() for box::use                 ← past tense, mixed concern
* updated README                                ← what changed in it?
```

Every line is wrong:
- Subject claims two concerns (`refactor and fix`).
- No scope (`fix:` not `fix(indication/assemble_expr):`).
- Past tense (`added`, `swapped`, `updated`).
- Vague body (`updated README` — for what?).

## Verifying after describe

```bash
jj log -r '::@' --no-graph -T 'change_id.shortest() ++ " " ++ description.first_line() ++ "\n"' | head -5
jj diff -r @-               # the bug fix
jj diff                      # the refactor
```
Each commit's diff matches its message. If it doesn't, `jj split` again
or `jj describe` with a corrected message.
