---
name: write-handoff
description: Structured handoff for a fresh session or a subagent brief; references artifacts, redacts secrets.
disable-model-invocation: true
---

# write-handoff

One format, two exits: a **file** (`./HANDOFF.md`, or the OS temp dir on
request) for the next session or a human; a **prompt payload** for a
subagent spawn (the handoff-gate brief —
`/spawn-cavecrew`).

## When to use
- User says "write handoff", "/write-handoff", "wrap up", "prep a handoff doc".
- Session ending / context near full on unfinished work.
- A mutating subagent needs a brief and no locked blueprint covers the work
  (a locked `OKF/blueprints/NNN` **is** the brief — don't duplicate it;
  see `/rig`).

## Rules (both exits)
- **Reference, don't duplicate.** Anything already captured in an
  artifact — OKF pages, `OKF/blueprints/NNN`, a ferry `MAP.md`, register
  decisions, jj change-ids, diffs — is cited by path/id, never restated. Ferried work:
  point at `OKF/ferries/<topic>/MAP.md` and stop.
- **Redact secrets.** No API keys, tokens, passwords, or PII — name
  where a credential lives (`.env`, secret store), never its value.
- **Concrete or nothing.** Paths with line numbers; one unambiguous
  next action; a verify command that proves the work landed.
- If the user passed arguments, treat them as what the next session
  will focus on and tailor the doc.

## Process
1. Skim the task list, recent edits, `OKF/index.md`, any active ferry.
2. Write the doc (template below). File exit: `./HANDOFF.md` unless the
   user names a path or asks for the temp dir. Subagent exit: same
   sections as the spawn prompt, plus the gate's verify command.
3. Show it; ask what's missing before the user clears.

## Template
```markdown
# Handoff — <YYYY-MM-DD> — <one-line topic>

## Goal
<what we are ultimately trying to achieve>

## Status
<done / in progress / blocked — cite jj change-ids and blueprint numbers>

## Decisions made this session
- <decision> — <one-line reason> (or: see OKF/decisions/NNN, ferry D-n)

## Open questions
- <question> — <who/what would answer it>

## Next concrete step
<the very first action the next session should take>

## Key references
- `OKF/blueprints/NNN` — <why it matters>
- `path/to/file.ext:42` — <why>

## Suggested skills
- /<skill> — <why the next session should invoke it>

## How to verify when done
<command or check that proves the work landed>
```

## Output / done criteria
- Every section filled or explicitly `n/a`; no artifact content
  restated; no secret values; "Next concrete step" is one action.

## See also
- `/ferry` — multi-session
  *design* work rides the ferry, not the handoff.
- `/spawn-cavecrew` — the
  handoff gate this format serves.
