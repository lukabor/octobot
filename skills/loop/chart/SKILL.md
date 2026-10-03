---
name: chart
description: "Plan a project or revise its plan — one mode-routed skill replacing plan-project and update-project. Greenfield: research-backed Socratic interview producing OKF/ROADMAP.md. Revision: fold reality back into the roadmap with supersede-never-delete discipline."
disable-model-invocation: true
---

# chart

Owns `OKF/ROADMAP.md`. Planning only, never implementation.

## When to use
- User says "chart", "/chart", "plan project", "plan this with
  me", "update the roadmap", "mark phase done", "we learned something —
  revise the plan".
- A verify step, `/diagnose` post-mortem, or prior-art change produced
  facts the roadmap doesn't reflect.

## Mode detection
| State | Mode |
|---|---|
| no `./OKF/` | run `/write-okf` scaffold first |
| `OKF/ROADMAP.md` absent or all-TODO | **Greenfield** → [greenfield.md](greenfield.md) |
| `OKF/ROADMAP.md` has real content | **Revision** → [revise.md](revise.md) |
| code exists but user wants plan-vs-code stress-test only | hand to `/grill-with-docs` |

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
  edit, per `/model-domain`.
  Roadmap and glossary must use identical canonical terms.
- **Decision files** only by the warrant test — the decision answers a
  question no other page answers, and you can name the `cites:` it binds
  (`/model-domain`'s `decision-format.md`). Default no.
- Roadmap phases feed `/blueprint` — write phases
  concrete enough that a blueprint can trace to them.
- **A phase whose arc spans more than one blueprint or session** hands to
  `/ferry` — chart plans it, ferry carries it.
- **A lone request opens no phase.** It traces to `user request <date>` and
  goes straight to blueprint; `OKF/ROADMAP.md` §Phases holds arcs, not
  errands. The missing phase is the design, not a gap.

## Output / done criteria
- `OKF/ROADMAP.md` matches the skeleton; every *open* phase has a verify
  step and every discharged one is pruned to `✅ verified <date>, NNN`;
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
- `/write-okf` — scaffolds the OKF
  this skill writes into.
- `/blueprint` — decomposes roadmap
  phases into blueprints.
- `/ferry` — carries a phase too big for one
  blueprint or one sitting.
- `/grill-me`
  — the interview engine.
