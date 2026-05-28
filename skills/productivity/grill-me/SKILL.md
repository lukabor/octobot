---
name: grill-me
description: Run a Socratic loop that removes ambiguity from a task before any implementation begins. Ask one focused question at a time about intent, edge cases, constraints, and success criteria until the agent can restate the task unambiguously. Use when the user says "grill me", "/grill-me", "ask me questions first", or when the task as stated is too vague to implement safely.
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
