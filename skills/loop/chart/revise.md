# chart — revision loop

For a roadmap that exists and reality that moved. Formerly
`update-project`.

## Process

1. **Read first.** `OKF/ROADMAP.md` and `OKF/CONTEXT.md` in full. Diff
   reality against them: repo state, test results, session learnings.
2. **Collect the deltas.** From the user and the session: phases
   verified or failed, decisions contradicted by new facts, fresh
   gotchas, scope changes. Ambiguous delta → grill, one question at a
   time.
3. **Apply, smallest edit per delta:**
   - Phase done → *replace* its verify line with `✅ verified <date>,
     blueprints/NNN-<slug>.md`, R-020's prune — never a tick beside a
     live step.
   - Verify failed → record what failed under the phase; do not delete
     the phase. Re-plan it only if the user agrees.
   - New gotcha/learning → append to *Risks & gotchas* (and mirror to
     `OKF/LEARNINGS.md` if project-wide): what was believed, what is
     true, source.
   - Decision overturned → strike nothing silently. Mark the old one
     `~~…~~ superseded by N` and add the new decision with rationale.
     Decisions are append-only history, not a wiki page.
   - Scope change → move items between *Phases* and *Out of scope*
     explicitly, never delete.
   - Blueprint implemented (`/rig` hand-back) →
     tick the phase item citing the blueprint number.
4. **Sync vocabulary.** New or shifted terms → one inline
   `OKF/CONTEXT.md` edit each. Roadmap and glossary keep matching
   exactly.
5. **Re-check prior art only when asked**, or when a delta names a new
   competing tool — then refresh the gap table with sources.
6. **Show the diff.** Summarize what changed and why; structure must
   still match the skeleton in [SKILL.md](SKILL.md) — sections stable,
   contents evolve.

## Done
- Every applied delta traces to a stated fact (verify result, user
  answer, or source); superseded decisions visible; user saw a summary
  of every section touched.
