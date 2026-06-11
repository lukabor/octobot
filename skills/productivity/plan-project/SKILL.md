---
name: plan-project
description: Kick off a greenfield project with a research-backed Socratic interview — research every tool/name the user mentions, scan prior art for the stated aim, grill one question at a time until decisions lock, then write docs/Roadmap.md with a phased, verifiable plan. Planning only, never implementation. Use when the user says "plan project", "/plan-project", "new project idea", "plan this project with me", or pitches a project that has no code and no roadmap yet.
---

# plan-project

## When to use
- User says "plan project", "/plan-project", "new project idea",
  "plan this project with me".
- A repo exists but is empty (or nearly) and the user is pitching what
  it should become.
- Skip when `docs/Roadmap.md` already exists — use
  [`update-project`](../update-project/SKILL.md) to revise it.
- Skip when code already exists and the question is about aligning a
  plan with it — use [`grill-with-docs`](../../engineering/grill-with-docs/SKILL.md)
  directly.

## Process
1. **Survey the repo.** `ls` it. Empty confirms greenfield; existing
   code means switch to grill-with-docs.
2. **Research before asking.** Every tool, product, or codename in the
   pitch that you don't recognize with certainty: WebSearch it *first*,
   report findings with sources, then ask what role it plays. Never
   guess; never quiz the user on facts the web answers.
3. **Prior-art scan.** Search for existing tools covering the stated
   aim. Build a gap table (tool | has | lacks). If an exact match
   exists, say so plainly — the honest outcome may be "use that
   instead". The gap the project fills becomes its pitch.
4. **Grill, one question at a time** (wait for each answer). Default
   order — skip what's already answered:
   1. Deliverable shape (library vs service vs CLI — surface
      contradictions in the user's own wording immediately).
   2. Core novelty — pin exact semantics of the differentiating
      feature; offer 2–3 concrete interpretations to pick from.
   3. Interaction surface (API/MCP/UI/CLI) — recommend cheapest that
      satisfies the aim when asked.
   4. Key tech picks — recommend with reasons, note reversibility;
      challenge claims that don't hold (benchmarks, scope).
   5. Persistence/storage and lifecycle (updates, triggers).
   6. v1 scope boundary (languages, platforms, integrations).
5. **Pin vocabulary as you go** via the
   [`grill-with-docs`](../../engineering/grill-with-docs/SKILL.md)
   protocol: one resolved term → one inline `CONTEXT.md` edit
   (confirm the first write). Roadmap and glossary must use the same
   canonical terms.
6. **Write `docs/Roadmap.md`** when answers stop moving decisions —
   skeleton below. Confirm before writing if it's the first file in
   `docs/`.
7. **ADRs** only by the three-of-three rule from grill-with-docs
   (hard to reverse ∧ surprising ∧ real trade-off). Default no.

## Roadmap.md skeleton
```markdown
# <Project> Roadmap
<Vision: 2–3 sentences, links to ../CONTEXT.md for vocabulary.>
## Why <project> (gap vs prior art)   ← the gap table from step 3
## Locked decisions                   ← numbered; rationale + reversibility each
## Architecture                       ← one ASCII sketch + main flow in words
## Phases                             ← each ends with "**Verify:** <observable check>"
## Risks & gotchas                    ← cost centers, maturity bets, debunked claims
## Out of scope                       ← explicit non-goals
```

## Output / done criteria
- `docs/Roadmap.md` exists; every phase has a verify step; every locked
  decision traces to a user answer or a research finding with source.
- `CONTEXT.md` terms and Roadmap vocabulary match exactly.
- No implementation has been started.

## Guardrails
- **Never** monologue — one question per message, then wait.
- **Never** write the roadmap before the prior-art scan.
- **Never** pick silently between interpretations of the user's idea.
- **Never** put time-sensitive claims in the skill's outputs without a
  source fetched this run.

## See also
- [update-project](../update-project/SKILL.md) — agile sibling: revises
  the roadmap this skill produced as the project teaches you things.
- [grill-with-docs](../../engineering/grill-with-docs/SKILL.md) — vocabulary
  protocol this skill delegates to.
- [grill-me](../grill-me/SKILL.md) — lighter sibling: ambiguity removal
  without docs output.
- [build-py-project](../../scaffold/build-py-project/SKILL.md) /
  [build-r-package](../../scaffold/build-r-package/SKILL.md) — natural
  next step once the roadmap's Phase 0 begins.
