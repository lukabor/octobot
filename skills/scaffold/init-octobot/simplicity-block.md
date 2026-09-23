# AGENTS.md simplicity block

Insert verbatim into the target `AGENTS.md`, after the Knowledge and
Behavioral guardrails sections from
[write-OKF's `agents-md-hook.md`](../../loop/write-OKF/agents-md-hook.md).
Distills CLAUDE.md sections 1–4 to the same terse, always-loaded register
as the guardrails block above it — the full essay stays in CLAUDE.md for
projects that opt into it.

```markdown
## Simplicity & rigor

- **Think before coding** — state assumptions, name the simpler approach
  you're rejecting, ask when unclear rather than guessing.
- **Three sieves before a line stays**: real (not speculative), good
  (nameably better for the next reader), minimal (leanest form —
  stdlib/existing code before new). Burden is on keeping, not cutting.
- **Surgical changes** — touch only what the task requires; don't
  refactor, reformat, or "improve" adjacent code; match existing style.
- **Goal-driven execution** — turn the task into a verifiable check
  before starting, then loop against that check instead of "looks done".
```

## Rules

- Keep this block verbatim across scaffolded projects — same source
  (`CLAUDE.md` §1–4, adapted from
  <https://github.com/multica-ai/andrej-karpathy-skills>) every time.
- If the target repo already has an AGENTS.md with an equivalent section,
  merge by hand and show the diff; never duplicate.
