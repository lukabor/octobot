---
name: sieve
description: Real / Good / Minimal gate on whether a change earns its place; fires at the seal.
disable-model-invocation: true
---

# sieve

## When to use
- User says "sieve", "/sieve", "should we build this at all", "is this
  worth it", "justify keeping this", "do we actually need this".
- About to **add** — a feature, file, dependency, abstraction, parameter.
- About to **prune** — and a deletion is being defended ("but it's clearer").
- A backlog item says "do X properly" — is the current way wrong, or just
  cheaper-to-improve?

## Core principle
**The burden is on keeping, not cutting.** A line does not get to exist by
default and survive review by inertia. To enter — or to stay — it must pass
all three sieves. Fail one, it goes. This is the inversion that keeps the
gate from becoming a rubber stamp: "Good" must *justify* survival, it cannot
merely *excuse* it.

## The three sieves

Each surviving line must pass **all three**:

1. **Real** — *Is the need true?* Does the requirement actually exist, or is
   it imagined / speculative / "might need it later"? A speculative
   abstraction, a config nobody configures, a flag with one value — fails
   Real. Before taking on a "do it properly" change, prove the current way
   is actually *wrong*, not merely improvable — that sets the bar the change
   must clear.

2. **Good** — *Does it leave the code better than you found it — clearer to
   the next reader, sounder in shape — not merely shorter?* This sieve faces
   **forward** (adds value), it does not crouch (guard against loss). But
   betterment must be **real, not cosmetic**: a change that only makes the
   code shorter, or only *looks* tidier, has not passed Good. Name the
   concrete thing it improves; if you can't name it, it hasn't.

3. **Minimal** — *Is this the leanest form that works?* stdlib before custom
   code; a native feature before a dependency; an installed dependency
   before a new one; one line before fifty. Only then, minimal hand-written
   code.

## Sieve at the boundary, never in the sandbox

The gate fires **where scratch becomes artifact** — a commit, a pipeline
target, a published report. Inside the sandbox (a REPL, a spike branch, a
`scratch.*` file) generation runs free; pruning exploration early throws
away its option value. Run the sieve at the **seal** step (your `jj
describe`), not per keystroke — otherwise it fights iteration.

## Modes

| Context | What the gate guards |
|---|---|
| **Build** | gates *adding*; Good leans forward — it is the sieve that lets *necessary robustness in* (validation, error handling), curing the under-build failure mode of pure YAGNI. |
| **Prune** | gates *keeping*; default-delete, Good must earn each survivor (see [`../winnow/SKILL.md`](../winnow/SKILL.md) for the mechanical cut). |
| **Analysis** | gates the *artifact* (`_targets.R`, the report), never the scratch. Minimal is sharp **and dangerous** here: no type-checker catches a cut that changes a conclusion. Good carries **epistemic** weight — *does removing this change what the analysis concludes?* A kept step names the inference it supports. |

## Intensity
- **Lite** — collapse to one sieve (*Real?*) for a one-liner; don't tax a
  trivial edit with the full ceremony.
- **Full** (default) — all three sieves, balanced.
- **Ultra** — **suspend Good.** Only Real + Minimal run, default-delete, no
  "but clarity" reprieve. The aggressive debloat pass when you want it.

## Guardrails
- **Never** let "Good" pass a change you can't name a concrete improvement
  for — that is the cowardice loophole, and it is how debloating dies.
- **Never** sieve the sandbox. Exploration is not bloat.
- **Never** apply Minimal to analysis without the epistemic check — a clean
  report is not a true one (the analysis form of "green is not correct").
- Exceptions that pass Good automatically: input validation, error handling
  that prevents data loss, security, accessibility, and explicitly
  requested behaviour. Don't simplify these away.

## See also
- [`../winnow/SKILL.md`](../winnow/SKILL.md) — the mechanical after-the-fact
  audit. The sieve judges entry; winnow clears the field.
- [`../codebase-design/SKILL.md`](../codebase-design/SKILL.md) — *Minimal*
  invokes **depth** intuition. The leanest form that works tends to be the
  deepest: small interface, large implementation hidden behind it.
- [`../../productivity/jj-atomic/SKILL.md`](../../productivity/jj-atomic/SKILL.md)
  — the seal where the sieve fires.
- [`../grill-with-docs/SKILL.md`](../grill-with-docs/SKILL.md)
  — Socratic siblings; grill the requirement, then sieve the code.
