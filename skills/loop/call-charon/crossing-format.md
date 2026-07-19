# crossing-format

File and message contracts for [call-charon](SKILL.md). One topic per
section; the orchestrator copies these verbatim, filling `<>` slots.

## Passage line (in the ferry's MAP.md)

```markdown
## Passage
- 014 — <title> — implemented — blocked-by: — axes: bp,ang,nuke,win — rounds: 1 — commit: <id> — <ISO date>
- 015 — <title> — locked — blocked-by: 014 — axes: — rounds: — commit: —
- 016 — <title> — blocked — blocked-by: 015 — why: <one line>
```

- Status vocabulary is blueprint's (`locked`, `implemented`,
  `superseded-by-NNN`) plus `blocked` with a `why:`.
- `axes:` abbreviations: `bp` review-blueprint, `ang` review-angles,
  `nuke` nuke-review, `win` winnow. Record only axes actually run.
- Dates ISO 8601. Append, update in place; never delete a line.

## Builder brief (Agent prompt, worktree isolation)

```
Goal: implement blueprint NNN exactly — no more, no less.
Read first: OKF/blueprints/NNN-<slug>.md, OKF/index.md,
  <OKF pages the blueprint references, by path>.
Process: follow skills/loop/weave/SKILL.md steps 1–2 (Frame, Build via
  skills/engineering/bdd/SKILL.md) for this one blueprint. Stop after
  green — review, seal, and status flips belong to the orchestrator.
Constraints: <blueprint constraints; repo conventions from CLAUDE.md>.
Verify: run `<blueprint's Verify command>`; paste its output in your
  report.
Report: files touched, scenarios covered, Verify output, anything that
  contradicts the blueprint (stop and report instead of improvising).
```

## Reviewer brief (one per axis, read-only, parallel)

```
Role: <axis> reviewer for blueprint NNN. Read-only — change nothing.
Read first: skills/<category>/<axis>/SKILL.md (your criteria),
  OKF/blueprints/NNN-<slug>.md, then the diff: `jj diff` in <worktree>.
Report findings only, one line each:
  <file>:<line> — <severity: blocker|major|minor> — <problem> — <fix>.
No praise, no scope creep. Empty list = pass.
```

## Finding merge (orchestrator → builder fix message)

```
Fix round <n> of 2 for blueprint NNN. Consolidated findings:
1. <file>:<line> — <axis> — <problem> — <required fix>
...
Skipped (arbitrated out): <finding> — <why: e.g. sieve always-pass>.
Re-run `<Verify command>` after fixes; paste output.
```

- Dedupe identical findings across axes; keep the highest severity.
- Conflicts (winnow "delete" vs angles "keep"): sieve's always-pass
  exceptions win — validation, error handling preventing data loss,
  security, accessibility, explicitly requested behaviour.
- Blockers and majors are required; minors at Charon's discretion —
  list what was skipped and why, so the builder doesn't re-add it.
