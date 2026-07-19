# AGENTS.md hook block

Insert verbatim (create `AGENTS.md` if absent; append if it exists —
never overwrite existing prose). `<project>` substituted from SUMMARY.md.

```markdown
## Knowledge — read before you code

This project keeps an agent-first wiki at [`OKF/`](OKF/INDEX.md)
(open-knowledge-format). Before extending or modifying <project>:

1. Read [`OKF/INDEX.md`](OKF/INDEX.md), then the pages it flags for your
   task — at minimum `SUMMARY.md`; `ARCHITECTURE.md` before structural
   work.
2. Use the canonical vocabulary from [`OKF/CONTEXT.md`](OKF/CONTEXT.md)
   in code, tests, and commit messages. Don't coin synonyms.
3. Non-trivial changes start from a blueprint in `OKF/blueprints/` — write one
   (blueprint skill) before implementing; cite its number in the commit.
4. Learned something that contradicts the wiki? Update the wiki in the
   same change (supersede, don't delete) or append to
   `OKF/LEARNINGS.md`.

## Behavioral guardrails

- State assumptions explicitly; name the simpler approach you are
  rejecting; surface tradeoffs. Push back when warranted — if something
  is unclear, stop and ask rather than guess.
- Do exactly what the task requires, nothing more. No speculative
  abstractions, no drive-by refactors.
- A green test suite is a claim, not a proof — verify against the
  blueprint's stated check before calling work done.
```

## Rules

- The guardrails section is the octobot-house Karpathy distillation —
  keep it verbatim so every scaffolded project carries the same contract.
- If the target repo already has an AGENTS.md knowledge section, merge
  by hand and show the diff; never duplicate the block.
- `CLAUDE.md`-only repos: offer a one-line `CLAUDE.md` pointer to
  AGENTS.md instead of duplicating the block there.
