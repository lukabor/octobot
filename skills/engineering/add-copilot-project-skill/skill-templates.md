# Stub templates

Copy-paste starting points. Keep them thin — the procedure lives in `docs/`.

## Canonical leaf skill — `skills/<name>/SKILL.md`

```markdown
---
name: <verb-noun>
description: <one line on what it does>. Use when the user says "<trigger>", "/<verb-noun>", or <situation>.
---

# <verb-noun>

<One sentence on the artifact this edits and where it sits in the sequence.>
Full procedure: **`docs/<relevant-doc>.md`**. Live example to copy:
**`<real/file/in/repo>`**.

## Interview first
1. <fact that decides the rest>
2. ...

## Steps
1. <edit 1 — house-style rule that matters here>
2. <edit 2 — the registration/wiring step that is easy to forget>

## Finish
- Run **`just validate --changed`**; interpret <relevant error codes>.
- Hand off: "Next, run `/<next-skill>`." Then stop.
```

## Parent (composite) skill

```markdown
---
name: <add-X-thing>
description: End-to-end guide to <composite task>. Use when ... Orchestrates the leaf skills by guided handoff.
---

# <add-X-thing> (orchestrator)

Conversation with **guided handoffs**: finish a stage, validate, name the next
leaf skill, and **pause** — do not auto-run the chain. Canonical example:
**`<real/files/in/repo>`**.

## Stage 0 — interview
<the few facts to establish before any stage>

## Stage sequence (hand off one at a time)
1. `/leaf-a`
2. `/leaf-b`
3. ...

## Checkpoints
Run `just validate --changed` after stages <n>; resolve errors before continuing.
```

## Copilot mirror — `.github/prompts/<name>.prompt.md`

```markdown
---
mode: agent
description: <same one-liner as the SKILL.md>.
---

Follow the canonical procedure in [`skills/<name>/SKILL.md`](../../skills/<name>/SKILL.md) — read it now — applying [`copilot-instructions.md`](../copilot-instructions.md).

<2–4 line compressed recap of the steps + the live example path.>

Finish with `just validate --changed`, then <next skill or done>.
```

Relative paths from `.github/prompts/`: `../../skills/...`, `../../docs/...`,
`../copilot-instructions.md`.

## Always-on conventions — `AGENTS.md` and `.github/copilot-instructions.md`

Same content, two files. Cover: the language style rules (imports, extraction,
iteration), the directory/naming layout, the one-token-everywhere convention
(prefix = cache group = log tag, or your repo's equivalent), the most common
pipeline mistakes, the "run `just validate --changed` before finishing" rule,
and commit conventions. Keep `copilot-instructions.md` self-contained enough to
stand alone; have it link to `AGENTS.md` and `docs/` for depth.
