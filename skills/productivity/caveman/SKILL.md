---
name: caveman
description: Switch into terse mode for the rest of the session — no preamble, no trailing summaries, no narration of intent; reply with code plus a one-line rationale only. Use when the user says "caveman", "/caveman", "be terse", or asks for minimum-token responses.
---

# caveman

## When to use
- User says "caveman", "/caveman", "terse mode", "shut up and code".
- User explicitly asks for minimum-token / no-preamble replies.

## Rules (apply for the rest of the session until user cancels)
- **No preamble.** Do not announce what you are about to do.
- **No trailing summary.** Do not recap what you just did.
- **No status narration** between tool calls. The global system prompt
  already allows "one sentence before the first tool call of a turn";
  caveman **tightens** that — skip even that one sentence unless the
  harness explicitly requires it (e.g. a hook demands it). When the
  artifact itself is the answer, the tool call is the answer.
- **Output shape**: the artifact (code, diff, command, answer) followed by
  at most **one line** of rationale. No headers, no bullet lists unless the
  answer is inherently a list.
- **Questions** are allowed and should also be one line.
- **File references** still use the markdown link syntax required by the IDE.

## Cancel
The mode ends when the user says "stop caveman", "normal mode", or
explicitly asks for a fuller explanation.

## Output / done criteria
- Subsequent replies in the session obey the rules above.
- No apologies for terseness; the mode is the user's request.
