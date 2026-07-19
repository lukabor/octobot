---
name: grill-me
description: Socratic interview, one question at a time, until the task restates unambiguously.
disable-model-invocation: true
---

# grill-me

## When to use
- User says "grill me", "/grill-me", or "interview me first".
- The request is ambiguous and proceeding would mean guessing.
- The task is non-trivial (multi-file, design tradeoffs, irreversible).

## Process
1. **One question at a time.** Never batch. Wait for each answer.
2. Cover, in roughly this order, skipping what is already clear:
   - **Intent** — what outcome makes this a success?
   - **Scope** — what is explicitly out of scope?
   - **Constraints** — perf, compat, deadline, dependencies you must not touch?
   - **Edge cases** — empty input, failure, concurrency, large size?
   - **Verification** — what test/command proves it works?
3. After every 2–3 answers, **mirror back** your current understanding in one
   short paragraph and ask "is this right?". Correct and continue.
4. **Stop** when you can write a one-paragraph task statement the user agrees
   with verbatim. Output that statement and offer to proceed.

## Output / done criteria
- A user-approved one-paragraph task statement.
- A clear list of out-of-scope items.
- A concrete verification step.

## Guardrails
- No implementation, no file edits during grilling.
- No leading questions ("you want X, right?"). Ask open questions.
- If the user gets impatient, offer to stop early with the current understanding.

## See also
- [../../engineering/grill-with-docs/SKILL.md](../../engineering/grill-with-docs/SKILL.md)
  — same energy, but anchored to the repo's `CONTEXT.md` and code. Use
  that one when a codebase exists to grill against.
