---
name: implement
description: Execute one locked spec from OKF/specs — bdd loop at the spec's seams, four-axis review, run the spec's Verify with pasted output, seal citing the spec, flip its status. The loop closer.
disable-model-invocation: true
---

# implement

Executes exactly **one `locked` spec**. Matt Pocock's implement ×
superpowers' subagent-driven-development, jj-native.

## When to use
- User says "implement", "/implement", "implement spec NNN", "execute
  the spec".
- A [blueprint](../blueprint/SKILL.md) spec just locked and the user
  says go.

## Preconditions (check, don't assume)
- The spec exists and `status: locked` — `draft` → back to blueprint for
  the user's lock; none named → list locked specs, ask which.
- `OKF/INDEX.md` read; the OKF pages the spec references read.

## Process
1. **Frame** — restate the spec's Spec section in one sentence; list its
   Seams touched as the pre-agreed test surfaces. Mismatch with what you
   find on disk → stop, surface it (spec may need superseding).
2. **Build** — hand to [bdd](../../engineering/bdd/SKILL.md): scenarios
   from the Spec section, tests only at the listed seams, red→green one
   scenario at a time.
3. **Review** — the four axes as warranted:
   [review-angles](../../engineering/review-angles/SKILL.md) always;
   [nuke-review](../../engineering/nuke-review/SKILL.md) /
   [winnow](../../engineering/winnow/SKILL.md) for non-trivial diffs;
   [review-blueprint](../../engineering/review-blueprint/SKILL.md)
   **always** — it is the done-gate.
4. **Done-gate** — run the spec's Verify command; **paste the output**.
   Red or missing output → not done; keep working or report blocked.
   "Should pass" never passes.
5. **Seal** — [jj-atomic](../../productivity/jj-atomic/SKILL.md); the
   message body cites `spec NNN`. Fix + regression test in the same
   change.
6. **Close the loop** — flip spec status to `implemented`; update its
   INDEX.md line; tick the roadmap item via
   [architect](../architect/SKILL.md) revise mode; wiki-worthy learnings
   → `OKF/LEARNINGS.md` ([scribe-OKF](../scribe-OKF/SKILL.md) refresh if
   pages went stale).

## Subagent dispatch — the handoff gate
Mutating subagents (`caveman:cavecrew-builder`, any implementer) spawn
**only with a brief**: goal, spec/OKF references (by path, not
restated), constraints, and the verify command for *their* slice. The
locked spec is the default brief. Read-only lookups
(`cavecrew-investigator`) are exempt. See
[cavecrew-octobot](../../productivity/cavecrew-octobot/SKILL.md).

## Output / done criteria
- Spec's Verify output pasted and green; four-axis findings resolved or
  explicitly waived by the user.
- Change sealed citing the spec; status flipped; roadmap ticked.

## Guardrails
- **Never** implement a draft or superseded spec.
- **Never** exceed the spec — an improvement idea goes through
  blueprint (supersede) first; review-blueprint will flag it anyway.
- **Never** flip status without the pasted Verify output.
- **Never** spawn a mutating subagent without a brief.
- One spec per run — the next spec is a fresh implement.

## See also
- [../blueprint/SKILL.md](../blueprint/SKILL.md) — upstream; owns spec
  status semantics.
- [../../engineering/review-blueprint/SKILL.md](../../engineering/review-blueprint/SKILL.md)
  — the done-gate axis.
- [../../engineering/diagnose/SKILL.md](../../engineering/diagnose/SKILL.md)
  — a bug found mid-implement that isn't this spec's scope gets its own
  loop.
