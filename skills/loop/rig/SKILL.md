---
name: rig
description: Execute one locked blueprint from OKF/blueprints — bdd loop at the blueprint's seams, four-axis review, run the blueprint's Verify with pasted output, seal citing the blueprint, flip its status. The loop closer.
disable-model-invocation: true
---

# rig

Executes exactly **one `locked` blueprint**. Matt Pocock's implement ×
superpowers' subagent-driven-development, jj-native.

## When to use
- User says "rig", "/rig", "implement blueprint NNN", "execute
  the blueprint".
- A [blueprint](../blueprint/SKILL.md) blueprint just locked and the user
  says go.

## Preconditions (check, don't assume)
- The blueprint exists and `status: locked` — `draft` → back to blueprint for
  the user's lock; none named → list locked blueprints, ask which.
- `OKF/index.md` read; the OKF pages the blueprint references read.

## Process
1. **Frame** — restate the blueprint's Contract section in one sentence; list its
   Seams touched as the pre-agreed test surfaces. Mismatch with what you
   find on disk → stop, surface it (blueprint may need superseding). If the
   blueprint carries `muster: true`, record `review-base:` on it now — `@-`
   (jj) or `git rev-parse HEAD` (git), the parent of where Build begins.
2. **Build** — hand to [bdd](../../engineering/bdd/SKILL.md): scenarios
   from the Contract section, tests only at the listed seams, red→green one
   scenario at a time.
3. **Review** — the four axes as warranted:
   [review-angles](../../engineering/review-angles/SKILL.md) always;
   [nuke-review](../../engineering/nuke-review/SKILL.md) /
   [winnow](../../engineering/winnow/SKILL.md) for non-trivial diffs;
   [review-blueprint](../../engineering/review-blueprint/SKILL.md)
   **always** — it is the done-gate.
4. **Done-gate** — run the blueprint's Verify command; **paste the output**.
   Red or missing output → not done; keep working or report blocked.
   "Should pass" never passes.
5. **Seal** — [commit-atomic-jj](../../productivity/commit-atomic-jj/SKILL.md); the
   message body cites `blueprint NNN`. Fix + regression test in the same
   change.
6. **Muster (only if `muster: true`)** — halt before closing: pipe the whole
   change to hunk — `jj diff --from <review-base> --to @ --git | hunk patch -`
   (git: `git diff <review-base>..HEAD | hunk patch -`; no hunk → show the
   range raw). Record the `tally:` block on the blueprint
   ([blueprint-format.md](../blueprint/blueprint-format.md)). `matches: no` →
   stay halted for a fix + re-muster; never flip on a known miss. No
   `muster:` field → skip entirely.
7. **Close the loop** — flip blueprint status to `implemented`; update its
   index.md line; tick the roadmap item via
   [chart](../chart/SKILL.md) revise mode; wiki-worthy learnings
   → `OKF/LEARNINGS.md` ([write-OKF](../write-OKF/SKILL.md) refresh if
   pages went stale).

## Subagent dispatch — the handoff gate
Mutating subagents (`caveman:cavecrew-builder`, any implementer) spawn
**only with a brief**: goal, blueprint/OKF references (by path, not
restated), constraints, and the verify command for *their* slice. The
locked blueprint is the default brief. Read-only lookups
(`cavecrew-investigator`) are exempt. See
[spawn-cavecrew](../../productivity/spawn-cavecrew/SKILL.md).

## Output / done criteria
- Blueprint's Verify output pasted and green; four-axis findings resolved or
  explicitly waived by the user.
- Change sealed citing the blueprint; status flipped; roadmap ticked.

## Guardrails
- **Never** implement a draft or superseded blueprint.
- **Never** exceed the blueprint — an improvement idea goes through
  blueprint (supersede) first; review-blueprint will flag it anyway.
- **Never** flip status without the pasted Verify output.
- **Never** spawn a mutating subagent without a brief.
- One blueprint per run — the next blueprint is a fresh rig.

## See also
- [../blueprint/SKILL.md](../blueprint/SKILL.md) — upstream; owns blueprint
  status semantics.
- [../../engineering/review-blueprint/SKILL.md](../../engineering/review-blueprint/SKILL.md)
  — the done-gate axis.
- [../../engineering/diagnose/SKILL.md](../../engineering/diagnose/SKILL.md)
  — a bug found during a rig that isn't this blueprint's scope gets its own
  loop.
