---
name: architect
description: Plan a project or revise its plan — one mode-routed skill replacing plan-project and update-project. Greenfield: research-backed Socratic interview producing OKF/ROADMAP.md. Revision: fold reality back into the roadmap with supersede-never-delete discipline.
disable-model-invocation: true
---

# architect

Owns `OKF/ROADMAP.md`. Planning only, never implementation.

## When to use
- User says "architect", "/architect", "plan project", "plan this with
  me", "update the roadmap", "mark phase done", "we learned something —
  revise the plan".
- A verify step, `/diagnose` post-mortem, or prior-art change produced
  facts the roadmap doesn't reflect.

## Mode detection
| State | Mode |
|---|---|
| no `./OKF/` | run [write-OKF](../write-OKF/SKILL.md) scaffold first |
| `OKF/ROADMAP.md` absent or all-TODO | **Greenfield** → [greenfield.md](greenfield.md) |
| `OKF/ROADMAP.md` has real content | **Revision** → [revise.md](revise.md) |
| code exists but user wants plan-vs-code stress-test only | hand to [grill-with-docs](../../engineering/grill-with-docs/SKILL.md) |

Half-states (roadmap exists but skeleton-incomplete) are revision mode —
fill the missing sections as deltas, don't restart.

## Roadmap skeleton (both modes keep this shape)
```markdown
# <Project> Roadmap
<Vision: 2–3 sentences, links to CONTEXT.md for vocabulary.>
## Why <project> (gap vs prior art)   ← gap table with sources
## Locked decisions                   ← numbered; rationale + reversibility
## Architecture                       ← one ASCII sketch + main flow in words
## Phases                             ← each open one ends "**Verify:** <check>"
## Risks & gotchas                    ← debunked claims: believed / true / source
## Out of scope                       ← explicit non-goals
```

## Shared rules (both modes)
- **One question per message** during any grilling; wait for the answer.
- **Vocabulary sync**: one resolved term → one inline `OKF/CONTEXT.md`
  edit, per [model-domain](../../engineering/model-domain/SKILL.md).
  Roadmap and glossary must use identical canonical terms.
- **Decision files** only by the warrant test — the decision answers a
  question no other page answers, and you can name the `cites:` it binds
  ([decision-format.md](../../engineering/model-domain/decision-format.md)).
  Default no.
- Roadmap phases feed [blueprint](../blueprint/SKILL.md) — write phases
  concrete enough that a blueprint can trace to them.

## Output / done criteria
- `OKF/ROADMAP.md` matches the skeleton; every *open* phase has a verify
  step and every discharged one is pruned to `✅ verified <date>, [NNN](…)`;
  every locked decision traces to a user answer or sourced finding.
- Revision: superseded decisions remain visible; every edit traces to a
  named delta.
- No implementation started.

## Guardrails
- **Never** write the roadmap before the prior-art scan (greenfield).
- **Never** delete a phase, decision, or out-of-scope entry — supersede
  or move (revision).
- **Never** monologue, never batch questions, never pick silently
  between interpretations of the user's idea.

## See also
- [greenfield.md](greenfield.md) / [revise.md](revise.md) — the loops.
- [../write-OKF/SKILL.md](../write-OKF/SKILL.md) — scaffolds the OKF
  this skill writes into.
- [../blueprint/SKILL.md](../blueprint/SKILL.md) — decomposes roadmap
  phases into blueprints.
- [../../productivity/grill-me/SKILL.md](../../productivity/grill-me/SKILL.md)
  — the interview engine.
