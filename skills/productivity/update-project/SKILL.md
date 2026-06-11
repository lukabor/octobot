---
name: update-project
description: Revise an existing docs/Roadmap.md as the project teaches you things — mark phases verified, append learnings to risks/gotchas, supersede (never silently rewrite) locked decisions that new facts touched, and keep CONTEXT.md vocabulary in sync. Use when the user says "update project", "/update-project", "update the roadmap", "mark phase done", "we learned something — revise the plan", or a verify step / post-mortem produced facts the roadmap doesn't reflect yet.
---

# update-project

## When to use
- User says "update project", "/update-project", "update the roadmap",
  "mark phase done", "we learned something — revise the plan".
- A phase's verify step just passed (or failed in an instructive way).
- A `/diagnose` post-mortem, dependency surprise, or prior-art change
  invalidates something the roadmap states.
- Skip when no `docs/Roadmap.md` exists — use
  [`plan-project`](../plan-project/SKILL.md) to create one.

## Process
1. **Read first.** `docs/Roadmap.md` and `CONTEXT.md` in full. Diff
   reality against them: repo state, test results, session learnings.
2. **Collect the deltas.** From the user and the session: phases
   verified or failed, decisions contradicted by new facts, fresh
   gotchas, scope changes. If a delta is ambiguous, grill — one
   question at a time, grill-with-docs style.
3. **Apply, smallest edit per delta:**
   - Phase done → mark `✅ verified <how>` on its verify line.
   - Verify failed → record what failed under the phase; do not delete
     the phase. Re-plan it only if the user agrees.
   - New gotcha/learning → append to *Risks & gotchas*. Keep the
     debunked-claim style: what was believed, what is true, source.
   - Decision overturned → strike nothing silently. Mark the old one
     `~~…~~ superseded by N` and add the new decision with rationale.
     Decisions are append-only history, not a wiki page.
   - Scope change → move items between *Phases* and *Out of scope*
     explicitly, never delete.
4. **Sync vocabulary.** New or shifted terms → one inline `CONTEXT.md`
   edit each, per [`grill-with-docs`](../../engineering/grill-with-docs/SKILL.md).
   Roadmap and glossary must keep matching exactly.
5. **Re-check prior art only when asked** or when a delta names a new
   competing tool — then refresh the gap table with sources.
6. **Show the diff.** Summarize what changed in the roadmap and why;
   the structure must still match the skeleton in
   [`plan-project`](../plan-project/SKILL.md) — sections are stable,
   contents evolve.

## Output / done criteria
- `docs/Roadmap.md` reflects current reality; every applied delta
  traces to a stated fact (verify result, user answer, or source).
- Superseded decisions remain visible with their replacement noted.
- `CONTEXT.md` and roadmap vocabulary still match exactly.
- User saw a summary of every section touched.

## Guardrails
- **Never** create `docs/Roadmap.md` here — that is plan-project's job.
- **Never** delete a phase, decision, or out-of-scope entry; supersede
  or move, keeping history readable.
- **Never** mark a phase verified without naming the observable check
  that passed.
- **Never** rewrite sections wholesale — smallest edit per delta.

## See also
- [plan-project](../plan-project/SKILL.md) — creates the roadmap and
  owns the section skeleton.
- [grill-with-docs](../../engineering/grill-with-docs/SKILL.md) —
  vocabulary sync protocol.
- [handoff](../handoff/SKILL.md) — session wrap-up; an update-project
  pass right before a handoff keeps the roadmap honest.
