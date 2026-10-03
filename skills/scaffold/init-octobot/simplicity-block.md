# AGENTS.md simplicity block

Insert verbatim into the target `AGENTS.md`, after the Knowledge and
Behavioral guardrails sections from
[write-okf's `agents-md-hook.md`](../../loop/write-okf/agents-md-hook.md).
Each bullet below carries only what that hook block does **not** already
say — CLAUDE.md §1–4 in full still holds every claim; this is the
union minus the overlap, not a restatement, so nothing is lost even for
a repo that never opts into CLAUDE.md.

```markdown
## Simplicity & rigor

- **Think before coding** — when multiple interpretations exist, present
  them; don't pick silently.
- **Three sieves before a line stays**: real (not speculative — no error
  handling for impossible scenarios, no unrequested flexibility or
  configurability), good (nameably better for the next reader), minimal
  (leanest form — stdlib/existing code before new). Burden is on keeping,
  not cutting. Exceptions that always pass *good*: input validation,
  error handling that prevents data loss, security, accessibility,
  explicitly requested behaviour.
- **Surgical changes** — match existing style; notice unrelated dead code
  and mention it, don't delete it; clean up only your own mess (remove
  orphans your change created, not pre-existing dead code); every changed
  line should trace to the request.
- **Goal-driven execution** — turn the task into a verifiable check
  before starting: "add validation" → "write tests for invalid inputs,
  then make them pass"; "fix the bug" → "write a test that reproduces
  it, then make it pass". For multi-step work, state a brief plan, each
  step naming its own verify. Strong success criteria let you loop
  independently; weak ones ("make it work") need constant clarification.
```

## Rules

- Keep this block verbatim across scaffolded projects — same source
  (`CLAUDE.md` §1–4, adapted from
  <https://github.com/multica-ai/andrej-karpathy-skills>) every time.
- If the target repo already has an AGENTS.md with an equivalent section,
  merge by hand and show the diff; never duplicate.
