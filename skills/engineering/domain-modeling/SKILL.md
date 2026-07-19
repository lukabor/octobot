---
name: domain-modeling
description: Actively build and sharpen a project's domain model — challenge fuzzy terms, propose canonical names, update CONTEXT.md inline as terms resolve, and offer ADRs only on the three-of-three rule. Use when the user says "domain model", "/domain-modeling", "pin down vocabulary", "canonical name for X", "is my language right", "what should this term be", "record this as an ADR", or another skill needs to maintain the domain model.
---

# domain-modeling

## When to use
- User says "domain model", "/domain-modeling", "pin down vocabulary",
  "canonical name", "is my language right", "what should this term be",
  "record an ADR".
- A non-trivial design conversation is *changing* the model — proposing
  new terms, retiring old ones, recording a hard-to-reverse decision.
- A sibling skill (`diagnose` hypothesis names, `bdd` Given/When/Then
  language) needs to consume the canonical glossary actively.

## Active vs reading
This skill is for when you're **changing** the model — challenging
terms, inventing scenarios, writing the glossary as it crystallises.
Merely *reading* `CONTEXT.md` for canonical vocabulary is a one-line
habit any skill can do; that's not this skill.

## Protocol

1. **Codebase first.** If the answer is on disk — `box::use` imports,
   `tar_meta()`, function signatures, an existing `CONTEXT.md` — read
   instead of asking.
2. **Challenge against the glossary.** When the user's term contradicts
   `CONTEXT.md`, surface it: *"Your glossary defines 'target' as a
   `tar_target`; you seem to mean a therapeutic target. Which?"*
3. **Sharpen fuzzy language.** Propose a canonical term and record losers
   under `_Avoid_`. *"You're saying 'account' — do you mean Customer or
   User? Different things."*
4. **Stress-test with concrete scenarios.** Invent edge cases that force
   the user to pin down boundaries. *"What does the target return when
   no tissue passes the threshold?"*
5. **Cross-reference with code.** If a stated mechanism contradicts the
   code, name file and line. *"`_targets.R:14` sets `format = 'qs2'` —
   that contradicts the parquet write you just described."*
6. **Update `CONTEXT.md` inline.** One term resolved → one edit. Never
   batched. Format: see [CONTEXT-FORMAT.md](CONTEXT-FORMAT.md).
7. **Offer ADRs sparingly** (three-of-three rule, see
   [ADR-FORMAT.md](ADR-FORMAT.md)). Default is *no*.

## File layout the skill expects

```
OKF/                       # open-knowledge-format wiki (see scribe-OKF)
├── CONTEXT.md             # single-context default — THE canonical glossary
├── context/               # multi-context mode: one <subroot>.md per
│   └── <subroot>.md       #   bounded context, indexed from OKF/INDEX.md
└── adr/
    └── 0001-<slug>.md
```

Create files **lazily** — only when there's a real first thing to write.
No `OKF/CONTEXT.md` yet? Create it when the first term is resolved (run
[scribe-OKF](../../loop/scribe-OKF/SKILL.md) scaffold if `OKF/` itself is
missing). No `OKF/adr/`? Create it when the first ADR is needed. Confirm
the *first* write to any new file in the repo before proceeding. A legacy
root `CONTEXT.md` or `docs/adr/` → offer to migrate into `OKF/`.

Default is single-context. Switch to **multi-context mode** only on
observing **≥ 2 obvious sub-roots** (e.g. `R/ingest/`, `R/analysis/`;
`src/ordering/`, `src/billing/`) *and* a second resolved term clearly
belonging to one of them — then propose `OKF/context/<subroot>.md` files
indexed from `OKF/INDEX.md`. **The split axis is the bounded context
(stable), never the issue (transient)** — issue-local terms live in their
`OKF/specs/` entry until they recur, then get promoted here.

## Language references — R

- [examples-r.md](examples-r.md) — full worked transcript in a
  targets-pipeline style repo (the "what is a target?" conflict), plus
  the resulting `CONTEXT.md` skeleton and what does *not* belong in it.

## Guardrails
- **Never** record general programming concepts in `CONTEXT.md` (timeouts,
  utility patterns, language idioms). Only domain-specific terms.
- **Never** write implementation details into `CONTEXT.md`. It's a
  glossary, not a spec.
- **Never** open an ADR unless all three of {hard to reverse, surprising
  without context, real trade-off} are true. When in doubt, don't.
- **Never** create an `OKF/CONTEXT.md` / `OKF/adr/` in the repo without
  confirming the first such write.
- **Never** create a per-issue glossary — one canonical glossary per
  bounded context, full stop.

## See also
- [../codebase-design/SKILL.md](../codebase-design/SKILL.md) — sibling
  vocabulary skill. **domain-modeling** pins terms for the *problem domain*
  (CONTEXT.md, glossary); **codebase-design** pins terms for the *solution
  structure* (module, interface, seam, adapter).
- [../grill-with-docs/SKILL.md](../grill-with-docs/SKILL.md) — the
  user-invoked router that pairs this skill with a Socratic interview.
- [../bdd/SKILL.md](../bdd/SKILL.md) — once vocabulary is pinned, the
  Given/When/Then scenarios should use the canonical terms.
- [../diagnose/SKILL.md](../diagnose/SKILL.md) — hypothesis names in
  diagnose post-mortems should match `CONTEXT.md` terminology.
- [../../productivity/grill-me/SKILL.md](../../productivity/grill-me/SKILL.md)
  — plan-only Socratic interview, no docs. The interview engine the
  router uses.
