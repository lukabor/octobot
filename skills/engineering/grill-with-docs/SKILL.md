---
name: grill-with-docs
description: Stress-test a plan against the codebase in a relentless interview, recording canonical terms and decisions as they crystallise.
disable-model-invocation: true
---

# grill-with-docs

User-invoked router. Run `/grill-me`
(the Socratic interview) **using** `/model-domain`
(the active glossary / decision discipline) — interview the user about the
plan, and update `OKF/CONTEXT.md` and `OKF/decisions/` as terms and decisions
crystallise.

## When to use
- User says "grill with docs", "/grill-with-docs", "stress-test this plan",
  "challenge this against the codebase".
- A design needs aligning with the project's vocabulary before it is built.
- Skip when no codebase exists yet — use
  `/grill-me` alone (plan-only).

## Output / done criteria
- The plan restates unambiguously (grill-me's bar), and every term or
  decision it settled landed in `OKF/CONTEXT.md` or `OKF/decisions/`.
- No roadmap written — that is `/chart`'s.

## See also
- `/grill-me`
  — the interview engine this composes.
- `/model-domain` — owns the glossary
  and the warrant test this records against.
- `/chart` — delegates
  the plan-vs-code stress-test here.
