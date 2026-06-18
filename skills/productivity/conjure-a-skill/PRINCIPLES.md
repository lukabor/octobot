# Principles — what makes a conjured skill predictable

The design playbook [`conjure-a-skill`](SKILL.md) applies. **Bold terms** are
defined in [`GLOSSARY.md`](GLOSSARY.md).

A skill wrangles determinism out of a stochastic system. **Predictability** —
same *process* every run, not same output — is the root virtue.

## Invocation

Two choices, trading different costs:

- A **model-invoked** skill keeps a **description**, so the agent can fire
  it autonomously *and* other skills can reach it. It contributes to
  **context load** — the description sits in the window every turn.
  Mechanics: omit `disable-model-invocation`; write a description with rich
  trigger phrasing.
- A **user-invoked** skill strips the description from the agent's reach:
  only the user can invoke it, no other skill can. Zero context load, but
  spends **cognitive load** — the user is the index. Mechanics: set
  `disable-model-invocation: true`.

Pick model-invocation only when the agent or another skill must reach the
skill. When user-invoked skills multiply past memory, a **router skill**
names the others and cures the cognitive load.

## Writing the description

A model-invoked description does two jobs — state what the skill is, and list
the **branches** that should trigger it. Every word increases context load:

- **Front-load the skill's leading word.**
- **One trigger per branch.** Synonyms that rename a single branch are
  **duplication**.
- **Cut identity already in the body.**

## Information hierarchy

A skill is built from **steps** and **reference**, mixed freely. The core
decision is where each sits on the **information hierarchy**:

1. **In-skill step** — `SKILL.md`. Each step ends on a **completion
   criterion** — *checkable* and (where it matters) *exhaustive*. Vague
   criteria invite **premature completion**.
2. **In-skill reference** — `SKILL.md`, on demand.
3. **External reference** — separate file, reached by a **context pointer**.

**Progressive disclosure** is the move down the ladder so the top stays
legible. Branching is the cleanest disclosure test: inline what every branch
needs, push behind a pointer what only some branches reach. A pointer's
*wording*, not its target, decides when and how reliably the agent reaches.

**Co-location** decides what sits beside each piece once placed — keep a
concept's definition, rules, and caveats under one heading.

## When to split

**Granularity** spends one of the two loads. Three cuts:

- **By invocation** — split when a distinct **leading word** earns it, or
  another skill must reach it.
- **By sequence** — split a run of **steps** when **post-completion steps**
  tempt the agent to rush the current one (**premature completion**).
- **By the octobot 100-line cap** — when a file exceeds 100 lines, split.
  House enforcement of **sprawl**. `GLOSSARY.md` is the documented exception.

## Pruning

Keep each meaning in a **single source of truth**. Check every line for
**relevance**. Then hunt **no-ops** sentence by sentence: when one fails the
test (*does it change behaviour versus the default?*), delete the whole
sentence rather than trim words from it.

## Leading words

A **leading word** is a compact concept already in the model's pretraining
(*lesson*, *fog of war*, *tracer bullets*). Repeated, never restated, it
anchors a region of behaviour in the fewest tokens. Twice predictable: in
the body it anchors *execution*; in the description it anchors *invocation*
— shared language across prompts, docs, and code fires the skill reliably.

Refactor: "fast, deterministic, low-overhead" → *tight*; "a loop you
believe in" → *red* (the loop goes *red*, or it doesn't).

## Failure modes

- **Premature completion** — ending a step before it's genuinely done.
  Sharpen the criterion first; hide post-completion steps only if it remains
  fuzzy *and* you observe the rush.
- **Duplication** — same meaning in more than one place.
- **Sediment** — stale layers settled because adding feels safe and
  removing feels risky.
- **Sprawl** — too long, even when every line is live. Cure: ladder +
  splitting.
- **No-op** — a line the model already obeys by default. Pay load to say
  nothing.

---

*Adapted from [mattpocock/skills `writing-great-skills`](https://github.com/mattpocock/skills/tree/main/skills/productivity/writing-great-skills).*
