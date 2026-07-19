---
name: nuke-review
description: Exceptionally strict structural-quality review for code judo moves — restructurings that preserve behaviour while making implementation dramatically simpler. Push for whole branches / helpers / modes to disappear, not just be polished. Flag file-size sprawl past 1k lines, ad-hoc spaghetti conditionals in unrelated flows, type/boundary muddiness, canonical-layer drift, and avoidable sequential orchestration. Use when the user says "nuke-review", "/nuke-review", "thermo-nuclear review", "code judo", "harsh maintainability review", "deep quality audit", or wants the strict structural review that goes beyond review-angles' correctness axis.
disable-model-invocation: true
---

# nuke-review

Adapted from [thermo-nuclear-code-quality-review](https://github.com/cursor/plugins/blob/main/cursor-team-kit/skills/thermo-nuclear-code-quality-review/SKILL.md).
**Structural-quality review** — goal is to *delete* moving pieces, not rearrange them.
Pair with [`../review-angles/SKILL.md`](../review-angles/SKILL.md) (correctness)
and [`../winnow/SKILL.md`](../winnow/SKILL.md) (debloat).

## Core prompt

> Perform a deep code quality audit of the current branch's changes. Rethink
> how to structure / implement the changes to meaningfully improve code
> quality without impacting behaviour. Work to improve abstractions,
> modularity, reduce spaghetti, improve succinctness and legibility. Be
> ambitious — if there is a clear path to restructuring some of the codebase,
> go for it. Measure twice, cut once.

## Non-negotiable standards

0. **Be ambitious about structural simplification.** Hunt for code-judo
   moves where whole branches, helpers, modes, conditionals, or layers
   disappear. Prefer the solution that makes the code feel inevitable in hindsight.
1. **A PR pushing a file from <1k to >1k lines is a smell.** Prefer
   extraction; if the threshold is crossed, ask explicitly whether the code
   should be decomposed first.
2. **No random spaghetti growth.** Suspicious of new ad-hoc conditionals,
   scattered special cases, one-off branches in unrelated flows. Push the
   logic into a dedicated abstraction.
3. **Clean the design, don't accept working code.** If behaviour stays the
   same while structure becomes cleaner, push for the cleaner version.
   Prefer simplifications that *remove* pieces over refactors that spread complexity around.
4. **Direct, boring, maintainable over hacky or magical.** Skeptical of
   generic mechanisms that hide simple data-shape assumptions; thin
   abstractions and identity wrappers add indirection without buying clarity.
5. **Type and boundary cleanliness.** Question unnecessary optionality,
   `unknown`, `any`, cast-heavy code where a clearer boundary could exist.
   Silent fallback over an unclear invariant → make the boundary explicit.
6. **Logic in the canonical layer; reuse canonical helpers.** Flag feature
   logic leaking into shared paths, implementation leaking through APIs,
   bespoke one-offs where a canonical utility exists.
7. **Sequential orchestration and non-atomic updates are smells when a
   cleaner shape is obvious.** Independent work serialised → ask about
   parallel. Half-applied state → push for atomic.

## What to look for, what to push for

**Code judo & decomposition.** Refactors that move complexity around without
reducing concepts; large files crossing 1k lines. Push for the path that
*deletes* a layer, not the one that polishes it; split the file first.

**Spaghetti.** New ad-hoc conditionals, one-off booleans, nullable modes
inserted into unrelated paths. Push for a dedicated abstraction, state
machine, or policy object — not tangling an existing flow.

**Indirection.** Thin wrappers, identity abstractions, generic "magic" hiding
simple structure. Push to delete the wrapper.

**Type & boundary muddiness.** Unnecessary casts, `any`, `unknown`, optional
params, silent fallback over unclear invariants. Push to make the type
boundary explicit so control flow simplifies.

**Canonical placement.** Feature logic leaking into shared paths, bespoke
helpers duplicating canonical utilities, logic in the wrong layer. Push to
move it home and reuse the canonical helper.

**Atomicity & orchestration.** Sequential flow where independent work could
parallelize; related updates that can leave state half-applied. Push for
parallel or atomic shapes.

## How to phrase findings — direct, serious, demanding; not rude
- *"this pushes the file past 1k lines. can we decompose this first?"*
- *"this adds another special-case branch into an already busy flow. can we move this behind its own abstraction?"*
- *"this works, but it makes the surrounding code more spaghetti. let's keep the behaviour and restructure the implementation."*
- *"this feels like feature logic leaking into a shared path. can we isolate it?"*
- *"this abstraction seems unnecessary. can we just keep the direct flow?"*
- *"why does this need a cast / optional here? can we make the boundary more explicit instead?"*
- *"this looks like a bespoke helper for something we already have elsewhere. can we reuse the canonical one?"*
- *"i think there's a code-judo move here that makes this much simpler. can we reframe so these branches disappear?"*
- *"this refactor moves complexity around, but doesn't really delete it. is there a way to make the model itself simpler?"*

## Output

Prioritise (high → low): structural regressions, missed code-judo, spaghetti
growth, boundary / type-contract problems, file-size, modularity, legibility.
A small number of high-conviction comments beats a long list of cosmetic notes.

## Approval bar

Don't approve because behaviour is correct. Each is a presumptive blocker unless justified:
- preserves incidental complexity when a code-judo move would delete it
- pushes a file past 1000 lines
- adds ad-hoc branching that tangles an existing flow
- scatters feature checks across shared code
- adds an unnecessary abstraction, wrapper, or cast-heavy contract
- duplicates a canonical helper or puts logic in the wrong layer

## See also
- [`../review-angles/SKILL.md`](../review-angles/SKILL.md) — the *correctness* axis: stale refs, TOCTOU, ordering, durability.
- [`../winnow/SKILL.md`](../winnow/SKILL.md) — the *mechanical debloat* axis: single-tag findings, `net: -N lines` scoreboard. Pairs naturally — nuke-review judges shape; winnow clears chaff.
- [`../design-codebase/SKILL.md`](../design-codebase/SKILL.md) — the vocabulary nuke-review applies (deep modules, seams, leverage, locality).
- [`../../productivity/spawn-cavecrew/SKILL.md`](../../productivity/spawn-cavecrew/SKILL.md) — how to spawn `caveman:cavecrew-reviewer` to *execute* this axis on a diff.
- [`../review-blueprint/SKILL.md`](../review-blueprint/SKILL.md) — the *blueprint-fidelity* axis (diff vs OKF/blueprints/NNN).
