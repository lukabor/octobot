---
name: review-blueprint
description: Review a diff against its originating spec (OKF/specs/NNN) — everything asked implemented, nothing beyond scope, Verify actually run with pasted output. The fourth review axis and implement's done-gate. Use when the user says "review against the spec", "review-blueprint", "does this match the spec", or implement reaches its done-gate.
---

# review-blueprint

The **spec axis** — the other three axes
([review-angles](../review-angles/SKILL.md) correctness,
[nuke-review](../nuke-review/SKILL.md) structure,
[winnow](../winnow/SKILL.md) debloat) judge the code on its own terms;
this one judges it against *what was asked*. Adapted from Matt Pocock's
code-review Spec axis + obra/superpowers' verification-before-completion.

## When to use
- [implement](../../loop/implement/SKILL.md) reaches its done-gate.
- User says "review against the spec", "does this match the spec".
- Any post-green review pass where an `OKF/specs/NNN` exists for the diff.

## Inputs
- The diff (`jj diff`, or `jj diff -r <rev>` for a sealed change).
- The spec: commit message citation (`spec NNN`), user-named, or the
  only `locked` spec touching these files. **Ambiguous → ask; none →
  report "no spec available" and stop. Never review against an imagined
  spec.**

## The three questions
1. **Complete?** Every behaviour in *Spec* present in the diff. Missing
   → finding per omission, citing the spec line.
2. **Contained?** Nothing in the diff beyond *Spec* + necessary
   plumbing. Anything matching *Out of scope* → finding. Changes past
   the *Seams touched* list → finding (scope leak, even if benign).
3. **Verified?** Run the spec's *Verify* command yourself — **paste the
   output**. No output, no pass: "it should pass" is the exact failure
   this axis exists to catch. Verify red → blocking finding.

## Output
```
spec NNN — <title>
COMPLETE:  ✓ | ✗ <missing behaviours, spec-line cites>
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
- **Never** fabricate a spec for spec-less work — say so and hand to
  the other three axes.
- **Never** widen review into correctness/structure here — single axis,
  like winnow. Point findings at the right sibling instead.
- A diff that *improves* on the spec still fails **Contained** — the
  spec gets superseded first ([blueprint](../../loop/blueprint/SKILL.md)),
  then the diff lands.

## See also
- [../review-angles/SKILL.md](../review-angles/SKILL.md),
  [../nuke-review/SKILL.md](../nuke-review/SKILL.md),
  [../winnow/SKILL.md](../winnow/SKILL.md) — the other three axes.
- [../../loop/implement/SKILL.md](../../loop/implement/SKILL.md) — runs
  this axis as its done-gate.
- [../../productivity/cavecrew-octobot/SKILL.md](../../productivity/cavecrew-octobot/SKILL.md)
  — spawn it as a subagent pass.
