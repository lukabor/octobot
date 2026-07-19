---
name: handoff
description: Structured handoff for a fresh session or a subagent brief; references artifacts, redacts secrets.
disable-model-invocation: true
---

# handoff

One format, two exits: a **file** (`./HANDOFF.md`, or the OS temp dir on
request) for the next session or a human; a **prompt payload** for a
subagent spawn (the handoff-gate brief —
[cavecrew-octobot](../cavecrew-octobot/SKILL.md)).

## When to use
- User says "handoff", "/handoff", "wrap up", "prep a handoff doc".
- Session ending / context near full on unfinished work.
- A mutating subagent needs a brief and no locked spec covers the work
  (a locked `OKF/specs/NNN` **is** the brief — don't duplicate it;
  see [implement](../../loop/implement/SKILL.md)).

## Rules (both exits)
- **Reference, don't duplicate.** Anything already captured in an
  artifact — OKF pages, `OKF/specs/NNN`, a ferry `MAP.md`, ADRs, jj
  change-ids, diffs — is cited by path/id, never restated. Ferried work:
  point at `OKF/specs/ferry-<topic>/MAP.md` and stop.
- **Redact secrets.** No API keys, tokens, passwords, or PII — name
  where a credential lives (`.env`, secret store), never its value.
- **Concrete or nothing.** Paths with line numbers; one unambiguous
  next action; a verify command that proves the work landed.
- If the user passed arguments, treat them as what the next session
  will focus on and tailor the doc.

## Process
1. Skim the task list, recent edits, `OKF/INDEX.md`, any active ferry.
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
<done / in progress / blocked — cite jj change-ids and spec numbers>

## Decisions made this session
- <decision> — <one-line reason> (or: see OKF/adr/NNNN, ferry D-n)

## Open questions
- <question> — <who/what would answer it>

## Next concrete step
<the very first action the next session should take>

## Key references
- `OKF/specs/NNN` — <why it matters>
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
- [../../loop/ferry/SKILL.md](../../loop/ferry/SKILL.md) — multi-session
  *design* work rides the ferry, not the handoff.
- [../cavecrew-octobot/SKILL.md](../cavecrew-octobot/SKILL.md) — the
  handoff gate this format serves.
