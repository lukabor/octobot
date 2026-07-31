# crossing-format

File and message contracts for [call-charon](SKILL.md). One topic per
section; the orchestrator copies these verbatim, filling `<>` slots.

## Passage line (in the ferry's MAP.md)

```markdown
## Passage
mode: jj
- 014 — <title> — implemented — blocked-by: — axes: bp,ang,nuke,win — rounds: 1 — commit: <id> — <ISO date>
- 015 — <title> — locked — blocked-by: 014 — axes: — rounds: — commit: —
- 016 — <title> — blocked — blocked-by: 015 — why: <one line>
```

- `mode:` is `jj` or `git`, detected once at ORIENT (`[ -d .jj ]`);
  it selects §isolation and §integration below.
- Status vocabulary is blueprint's (`locked`, `implemented`,
  `superseded-by-NNN`) plus `blocked` with a `why:`.
- `axes:` abbreviations: `bp` review-blueprint, `ang` review-angles,
  `nuke` nuke-review, `win` winnow. Record only axes actually run.
- Dates ISO 8601. Append, update in place; never delete a line.

## Isolation (per mode, orchestrator sets up before dispatch)

- **jj**: `jj workspace add ../charon-NNN`, then spawn the builder
  with NO isolation flag — its brief names the workspace dir. The
  Agent tool's `isolation: worktree` makes a *git* worktree, where jj
  cannot run; never combine it with jj mode. Builder edits
  auto-snapshot into `charon-NNN@` — no commit discipline needed.
- **git**: spawn the builder with `isolation: worktree`. The brief
  MUST end with "commit your work on this branch" — uncommitted
  worktree changes cannot be integrated.

## Builder brief (Agent prompt; isolation per mode above)

```
Goal: implement blueprint NNN exactly — no more, no less.
Work in: <jj: ../charon-NNN | git: your worktree (already isolated)>.
Read first: OKF/blueprints/NNN-<slug>.md, OKF/index.md,
  <OKF pages the blueprint references, by path>.
Process: follow ~/.claude/skills/rig/SKILL.md steps 1–2 (Frame,
  Build via ~/.claude/skills/bdd/SKILL.md) for this one blueprint.
  Stop after green — review, seal, and status flips belong to the
  orchestrator.
Constraints: <blueprint constraints; repo conventions from CLAUDE.md>.
Verify: run `<blueprint's Verify command>`; paste its output in your
  report.
<git mode only: When done, `git add -A && git commit` on your
  worktree's branch — uncommitted work is lost.>
Report: files touched, scenarios covered, Verify output, anything that
  contradicts the blueprint (stop and report instead of improvising).
```

## Reviewer brief (one per axis, read-only, parallel)

```
Role: <axis> reviewer for blueprint NNN. Read-only — change nothing.
Your criteria, verbatim from the <axis> skill — apply these and
nothing else:
=== CRITERIA START ===
<axis SKILL.md body: frontmatter, "When to use", and "See also"
 stripped; everything else verbatim>
=== CRITERIA END ===
Read: OKF/blueprints/NNN-<slug>.md, then the diff:
  <jj: `jj diff -r charon-NNN@` from the main repo
   | git: `git -C <worktree> add -A -N && git -C <worktree> diff HEAD`
     (plain `git diff` misses untracked files)>.
Report findings only, one line each:
  <file>:<line> — <severity: blocker|major|minor> — <problem> — <fix>.
No praise, no scope creep. Empty list = pass.
```

- The orchestrator Reads each axis SKILL.md once per sitting and
  inlines it — briefs must be self-contained. Subagent-side skill
  paths are fragile (worktrees and remote runners may not see
  `~/.claude/skills/`; `disable-model-invocation` axes are invisible
  to a subagent's Skill tool).
- Strip only frontmatter, `## When to use`, `## See also`. Everything
  else goes in **verbatim — never summarize**: the axes are
  recall-biased checklists; paraphrase destroys their recall.
- Builder briefs still reference rig/bdd by path — process skills
  are too long to inline, and the builder always runs on the
  orchestrator's machine.

## Finding merge (orchestrator → builder fix message)

```
Fix round <n> of 2 for blueprint NNN. Consolidated findings:
1. <file>:<line> — <axis> — <problem> — <required fix>
...
Skipped (arbitrated out): <finding> — <why: e.g. sieve always-pass>.
Re-run `<Verify command>` after fixes; paste output.
```

- Dedupe identical findings across axes; keep the highest severity.

## Integration (per mode, orchestrator only, after reviews clean)

- **jj**: work is already a commit in the shared store —
  `jj squash --from charon-NNN@ --into <dest>` (or `jj rebase`), then
  `jj workspace forget charon-NNN` and remove the dir. Parallel
  builders → run `jj workspace update-stale` in the main workspace
  first. Conflicts → resolve-conflicts-jj skill.
- **git**: merge the builder's worktree branch into the mainline, then
  `git worktree remove` it. Conflicts → resolve-conflicts-git skill.
- Either mode: run the blueprint's Verify in the **main workspace
  after integrating** — pre-integration green does not count.
- Conflicts (winnow "delete" vs angles "keep"): sieve's always-pass
  exceptions win — validation, error handling preventing data loss,
  security, accessibility, explicitly requested behaviour.
- Blockers and majors are required; minors at Charon's discretion —
  list what was skipped and why, so the builder doesn't re-add it.
