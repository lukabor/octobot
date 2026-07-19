# octobot — agent directions

## Knowledge — read before you code

This project keeps an agent-first wiki at [`OKF/`](OKF/INDEX.md)
(open-knowledge-format). Before extending or modifying octobot:

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

## House rules

- Skill authoring: [conjure-a-skill](skills/productivity/conjure-a-skill/SKILL.md);
  `SKILL.md` ≤110 lines (reference siblings load on demand, no hard cap).
- Commits: [commit-atomic-jj](skills/productivity/commit-atomic-jj/SKILL.md) —
  `type(scope): imperative`, one concern per change, foreground jj only.
- Fuller behavioral contract: [CLAUDE.md](CLAUDE.md).
