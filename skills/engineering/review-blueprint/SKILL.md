---
name: review-blueprint
description: Review a diff against its originating blueprint (OKF/blueprints/NNN) — everything asked implemented, nothing beyond scope, Verify actually run with pasted output. The fourth review axis and weave's done-gate. Use when the user says "review against the blueprint", "review-blueprint", "does this match the blueprint", or weave reaches its done-gate.
---

# review-blueprint

The **blueprint axis** — the other three axes
([review-angles](../review-angles/SKILL.md) correctness,
[nuke-review](../nuke-review/SKILL.md) structure,
[winnow](../winnow/SKILL.md) debloat) judge the code on its own terms;
this one judges it against *what was asked*. Adapted from Matt Pocock's
code-review Spec axis + obra/superpowers' verification-before-completion.

## When to use
- [weave](../../loop/weave/SKILL.md) reaches its done-gate.
- User says "review against the blueprint", "does this match the blueprint".
- Any post-green review pass where an `OKF/blueprints/NNN` exists for the diff.

## Inputs
- The diff (`jj diff`, or `jj diff -r <rev>` for a sealed change).
- The blueprint: commit message citation (`blueprint NNN`), user-named, or the
  only `locked` blueprint touching these files. **Ambiguous → ask; none →
  report "no blueprint available" and stop. Never review against an imagined
  blueprint.**

## The three questions
1. **Complete?** Every behaviour in *Contract* present in the diff. Missing
   → finding per omission, citing the blueprint line.
2. **Contained?** Nothing in the diff beyond *Contract* + necessary
   plumbing. Anything matching *Out of scope* → finding. Changes past
   the *Seams touched* list → finding (scope leak, even if benign).
3. **Verified?** Run the blueprint's *Verify* command yourself — **paste the
   output**. No output, no pass: "it should pass" is the exact failure
   this axis exists to catch. Verify red → blocking finding.

## Output
```
blueprint NNN — <title>
COMPLETE:  ✓ | ✗ <missing behaviours, blueprint-line cites>
CONTAINED: ✓ | ✗ <scope leaks, out-of-scope hits>
VERIFIED:  ✓ | ✗ — <verify command>
<pasted output, trimmed to the verdict lines>
```
Verdict: pass only when all three are ✓. Findings are severity-tagged
like [review-angles](../review-angles/SKILL.md); refute each before
emitting ([refute.md](../review-angles/refute.md)).

## Guardrails
- **Never** pass on a prose claim of verification — output or it
  didn't happen.
- **Never** fabricate a blueprint for blueprint-less work — say so and hand to
  the other three axes.
- **Never** widen review into correctness/structure here — single axis,
  like winnow. Point findings at the right sibling instead.
- A diff that *improves* on the blueprint still fails **Contained** — the
  blueprint gets superseded first ([blueprint](../../loop/blueprint/SKILL.md)),
  then the diff lands.

## See also
- [../review-angles/SKILL.md](../review-angles/SKILL.md),
  [../nuke-review/SKILL.md](../nuke-review/SKILL.md),
  [../winnow/SKILL.md](../winnow/SKILL.md) — the other three axes.
- [../../loop/weave/SKILL.md](../../loop/weave/SKILL.md) — runs
  this axis as its done-gate.
- [../../productivity/spawn-cavecrew/SKILL.md](../../productivity/spawn-cavecrew/SKILL.md)
  — spawn it as a subagent pass.
