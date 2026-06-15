---
name: grill-with-docs
description: Interview the user about a plan, cross-checking every term against the repo's CONTEXT.md / glossary and the code itself; update CONTEXT.md inline as terms resolve; offer ADRs only when the decision is hard to reverse, surprising, and the result of a real trade-off. Use when the user says "grill with docs", "/grill-with-docs", "stress-test this plan", "challenge my plan against the codebase", "is my language right", or wants to align a design with the project's domain vocabulary before implementation.
---

# grill-with-docs

## When to use
- User says "grill with docs", "/grill-with-docs", "stress-test this plan",
  "challenge against the codebase", "align my language".
- A non-trivial plan is on the table and the repo has (or should have)
  domain vocabulary worth pinning down.
- Skip when no codebase exists yet — use [`/grill-me`](../../productivity/grill-me/SKILL.md)
  instead (plan-only ambiguity removal).

## Protocol

1. **One question at a time.** Wait for the answer before the next.
2. **Codebase first.** If the answer is on disk — `box::use` imports,
   `tar_meta()`, function signatures, an existing `CONTEXT.md` — read
   instead of asking.
3. **Challenge against the glossary.** When the user's term contradicts
   `CONTEXT.md`, surface it: *"Your glossary defines 'target' as a
   `tar_target`; you seem to mean a therapeutic target. Which?"*
4. **Sharpen fuzzy language.** Propose a canonical term and record losers
   under `_Avoid_`. *"You're saying 'account' — do you mean Customer or
   User? Different things."*
5. **Stress-test with concrete scenarios.** Invent edge cases that force
   the user to pin down boundaries. *"What does the target return when
   no tissue passes the threshold?"*
6. **Cross-reference with code.** If a stated mechanism contradicts the
   code, name file and line. *"`_targets.R:14` sets `format = 'qs2'` —
   that contradicts the parquet write you just described."*
7. **Update `CONTEXT.md` inline.** One term resolved → one edit. Never
   batched. Format: see [CONTEXT-FORMAT.md](CONTEXT-FORMAT.md).
8. **Offer ADRs sparingly** (three-of-three rule, see
   [ADR-FORMAT.md](ADR-FORMAT.md)). Default is *no*.

## File layout the skill expects

```
/
├── CONTEXT.md             # single-context default
├── CONTEXT-MAP.md         # only when ≥2 obvious sub-roots exist
├── docs/adr/
│   └── 0001-<slug>.md
└── src/   (or R/, app/, ...)
```

Create files **lazily** — only when there's a real first thing to write.
No `CONTEXT.md` yet? Create it when the first term is resolved. No
`docs/adr/`? Create it when the first ADR is needed. Confirm the *first*
write to any new file in the repo before proceeding.

### Single vs multi-context
- **Default: single.** One `CONTEXT.md` at the root.
- **Switch to multi** only when you observe **≥ 2 obvious sub-roots** in
  the repo (e.g. `R/plot/`, `R/inf/`, `R/ibd/`; or `src/ordering/`,
  `src/billing/`). On the second resolved term that clearly belongs to
  one of them, propose `CONTEXT-MAP.md` at the root + per-context
  `CONTEXT.md` under each sub-root.

## Language references — R

- [examples-r.md](examples-r.md) — full worked transcript in a
  targets-pipeline style repo (the "what is a target?" conflict), plus
  the resulting `CONTEXT.md` skeleton and what does *not* belong in it.

## Guardrails
- **Never** monologue. One question, wait, then the next.
- **Never** record general programming concepts in `CONTEXT.md` (timeouts,
  utility patterns, language idioms). Only domain-specific terms.
- **Never** write implementation details into `CONTEXT.md`. It's a
  glossary, not a spec.
- **Never** open an ADR unless all three of {hard to reverse, surprising
  without context, real trade-off} are true. When in doubt, don't.
- **Never** create a `CONTEXT.md` / `docs/adr/` in the repo without
  confirming the first such write.

## See also
- [../bdd/SKILL.md](../bdd/SKILL.md) — once vocabulary is pinned,
  the Given/When/Then scenarios should use the canonical terms.
- [../diagnose/SKILL.md](../diagnose/SKILL.md) — hypothesis names in
  diagnose post-mortems should match `CONTEXT.md` terminology.
- [../../productivity/grill-me/SKILL.md](../../productivity/grill-me/SKILL.md)
  — plan-only sibling. No codebase needed; no docs updated. Use that one
  for greenfield, this one for established repos.
