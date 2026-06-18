---
name: winnow
description: A blunt after-the-fact debloat audit that scans existing code for what can be deleted — reinvented stdlib, needless dependencies, speculative abstractions, dead flexibility — and reports a line-count delta. One-directional: it only ever removes. Use when the user says "winnow", "/winnow", "debloat", "what can we delete", "is this over-engineered", "simplify review", "find what to cut", "over-engineering review", or wants a mechanical pass over a diff or file for removable complexity.
---

# winnow

## When to use
- User says "winnow", "/winnow", "debloat", "what can we delete", "is this
  over-engineered", "find what to cut", "simplify review".
- A diff or file is written and working; you want a separate pass that hunts
  *only* for removable mass.
- **Not** a judgment gate — that is [`../sieve/SKILL.md`](../sieve/SKILL.md).
  Winnow runs *after* the fact and argues *only* for deletion. It blows the
  chaff off the grain; it never adds.

## Core principle
**Only removes, and proves it with a number.** Every finding names something
to cut and its replacement; the audit ends with a line-count delta. A pass
that can't show a negative number found nothing — it's just talk. The
scoreboard is what makes minimalism rationalization-proof.

## Tags

One finding per line:

```
<file>:<line>: <tag> <what>. <replacement>.
```

| tag | finds |
|---|---|
| `delete` | dead code, unused flexibility — no replacement needed |
| `stdlib` | hand-rolled logic the standard library already provides |
| `native` | code/dependency duplicating a platform-native feature |
| `yagni`  | abstraction with one implementation, single-caller layer |
| `shrink` | logic reducible to fewer lines with a cleaner pattern |

Close with: `net: -<N> lines possible.`

## Over-engineering signals
- A 27-line validator class where a guard clause suffices.
- A framework dependency solving one trivial problem.
- An ABC / Protocol / interface with exactly one concrete implementation.
- A configuration layer nobody configures.
- A retry wrapper around an idempotent local operation.
- A manual loop where a built-in (`map`, `sum`, comprehension) applies.

## The brake — prove redundant before you cut

A "redundant" idiom may be **load-bearing**. Every `delete`/`shrink` is the
claim *"this is redundant"* — refute it before you act
([`../review-angles/refute.md`](../review-angles/refute.md)); the type-checker
is one skeptic. A real review flagged a
repeated `tuple(r) for r in conn.execute(...)` wrapper and a
`cast(int | None, line)` as noise. Both were genuine no-ops at *runtime* —
but deleting the wrapper **broke the type-checker**: the raw cursor row
isn't positionally subscriptable, and the wrapper was normalising it.

So, before emitting any `delete`/`shrink`:
- **Run the type-checker, not just the tests.** Tests stay green when you
  remove a type-only crutch; the checker is the one that bites.
- When an idiom turns out load-bearing, **centralise it** (one helper that
  normalises once) — don't scatter it back, and don't just revert. The cut
  becomes a *consolidation*, still net-negative, still honest.
- A finding whose only payoff is "fewer lines" but which a reader needs for
  clarity, or the checker needs for soundness, fails the audit — it was
  never chaff.

## Scope
Winnow ignores **correctness bugs, security, and performance** — those are
[`../review-angles/SKILL.md`](../review-angles/SKILL.md) and `/code-review`.
This pass is *only* structural complexity. Staying single-axis is what keeps
it sharp.

## See also
- [`../sieve/SKILL.md`](../sieve/SKILL.md) — the judgment gate. Sieve decides
  what earns its place; winnow mechanically clears what doesn't.
- [`../nuke-review/SKILL.md`](../nuke-review/SKILL.md) — *structural-quality* review (code-judo). Pairs naturally — nuke-review judges shape; winnow clears chaff.
- [`../codebase-design/SKILL.md`](../codebase-design/SKILL.md) — the
  **deletion test** formalised: if removing a module makes complexity
  vanish, it was a pass-through; if it reappears across N callers, it earned
  its keep. The `delete` and `yagni` tags are this test mechanised.
- [`../bdd/refactoring-r.md`](../bdd/refactoring-r.md) — file the
  architectural follow-ups a winnow surfaces; don't auto-cut them mid-pass.
- [`../review-angles/SKILL.md`](../review-angles/SKILL.md) — the *correctness*
  axis winnow deliberately does not touch.
