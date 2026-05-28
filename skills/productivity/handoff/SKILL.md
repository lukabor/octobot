---
name: handoff
description: Produce a structured handoff document so a fresh Claude Code session (or a teammate) can pick up where this one left off without re-deriving context. Use when the user says "handoff", "wrap up", "summarize for next session", or is about to /clear or end the session on unfinished work.
---

# handoff

## When to use
- User says "handoff", "/handoff", "wrap up", or "prep a handoff doc".
- User is about to end a session on unfinished work.
- Context window is near full and work must continue in a fresh session.

## Process
1. Skim the current todo list, recent edits, and any active plan file.
2. Write a handoff document to `./HANDOFF.md` (or the path the user names)
   containing the sections below. Be concrete — paths with line numbers, not
   vague references.
3. Show the doc to the user and ask if anything is missing before they
   `/clear`.

## Handoff template
```markdown
# Handoff — <YYYY-MM-DD> — <one-line topic>

## Goal
<what we are ultimately trying to achieve>

## Status
<what is done; what is in progress; what is blocked>

## Decisions made this session
- <decision> — <one-line reason>

## Open questions
- <question> — <who/what would answer it>

## Next concrete step
<the very first action the next session should take>

## Key files
- `path/to/file.ext:42` — <why it matters>
- `path/to/other.ext:10-25` — <why>

## How to verify when done
<command or check that proves the work landed>
```

## Output / done criteria
- `HANDOFF.md` exists and every section is filled.
- File paths include line numbers where relevant.
- "Next concrete step" is a single, unambiguous action.
