# Stub templates

Copy-paste starting points. Keep them thin — the procedure lives in `docs/`.

## Canonical leaf skill — `.github/skills/<name>/SKILL.md`

```markdown
---
name: <verb-noun>
description: <one line on what it does>. Use when the user says "<trigger phrase>", "<alternate phrasing>", "<situation cue>", or <situation>.
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
- Hand off: "Next, ask for `<next-skill>`." Then stop.
```

Frontmatter notes: lowercase-hyphenated `name:` must match the directory name.
The `description:` is the *only* discovery surface — lead with action-verb
trigger phrases ("Use when the user says...") so the cloud agent's matcher
fires reliably.

## Parent (composite) skill

```markdown
---
name: <add-X-thing>
description: End-to-end guide to <composite task>. Use when the user says "<trigger>", "<alternate>", or <situation>. Orchestrates the leaf skills by guided handoff.
---

# <add-X-thing> (orchestrator)

Conversation with **guided handoffs**: finish a stage, validate, name the next
leaf skill, and **pause** — do not auto-run the chain. Canonical example:
**`<real/files/in/repo>`**.

## Stage 0 — interview
<the few facts to establish before any stage>

## Stage sequence (hand off one at a time)
1. `<leaf-a>` — <what it produces>
2. `<leaf-b>` — <what it produces>
3. ...

## Checkpoints
Run `just validate --changed` after stages <n>; resolve errors before continuing.
```

## Path-scoped instructions — `.github/instructions/<surface>.instructions.md`

```markdown
---
applyTo: "<directory>/**/*.<ext>"
description: <one-line surface summary>
---

When editing files under `<directory>/`, you're touching <artifact>.

- **Adding <X>?** Use the `<skill-name>` skill ("<trigger phrase>",
  "<alternate>").
- <one specific gotcha unique to this surface, naming the validator code
  that catches it>
- <one house-style rule that matters here>
- Run `just validate --changed` before committing.
```

These don't replace `AGENTS.md` (always-on house style) — they surface
**surface-specific** reminders that name the relevant skill.

## Always-on conventions — `AGENTS.md`

`AGENTS.md` is the single source of style. Cover: language style rules
(imports, extraction, iteration), directory/naming layout, the one-token-
everywhere convention (prefix = cache group = log tag, or your repo's
equivalent), the most common pipeline mistakes, the "run `just validate
--changed` before finishing" rule, and commit conventions.

End AGENTS.md with a small table pointing at `.github/skills/` and
`.github/instructions/` so any agent reading AGENTS.md learns where the
operational skills live.

## Copilot redirect + skills menu — `.github/copilot-instructions.md`

This file exists for Copilot-tier surfaces that prefer the documented path.
Body: one sentence redirecting to `AGENTS.md`, then a discoverability table:

```markdown
# GitHub Copilot instructions — <project name>

House style and conventions: **[`AGENTS.md`](../AGENTS.md)**.

## Skills (auto-triggered by description matching)

| Skill | Triggers on prompts like |
|---|---|
| [`add-X`](skills/add-X/SKILL.md) | "<trigger>", "<alternate>" |
| ... | ... |
```

Belt-and-braces: even if description matching misses, the menu surfaces the
skill names always-on.
