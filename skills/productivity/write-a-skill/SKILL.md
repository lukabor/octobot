---
name: write-a-skill
description: Scaffold a new Claude Code skill with the octobot conventions — frontmatter, "Use when" trigger, ≤100-line SKILL.md, optional REFERENCE/EXAMPLES. Use when the user asks to create, write, add, or draft a new skill, or wants to convert a repeated workflow into a reusable skill.
---

# write-a-skill

## When to use
- User says "write a skill", "create a skill", "add a skill", "/write-a-skill".
- User describes a recurring workflow and asks to make it reusable.
- You notice the same multi-step process being requested across sessions and
  suggest capturing it as a skill.

## Process
1. **Gather** — ask the user (one message, grouped):
   - kebab-case name and which category (`productivity`, `engineering`, `misc`)
   - one-line purpose
   - concrete trigger phrases ("Use when ...")
   - success / done criteria
   - any deterministic helpers needed (scripts? reference docs?)
2. **Check for overlap** — `ls ~/code/octobot/skills/*/` and grep
   descriptions; if a near-match exists, propose extending it instead of
   creating a duplicate.
3. **Draft** `~/code/octobot/skills/<category>/<name>/SKILL.md` using the
   template in REFERENCE.md (or the inline template below if you have it
   memorized).
4. **Review** — show the draft to the user; iterate until approved. Verify:
   - `name:` matches the folder name
   - `description:` contains "Use when" and is < 1024 chars
   - file is ≤ 100 lines (split into REFERENCE.md / EXAMPLES.md otherwise)
   - no time-sensitive content
5. **Link** — Claude Code only scans one level deep under `~/.claude/skills/`,
   so create a per-skill symlink:
   `ln -s ~/code/octobot/skills/<category>/<name> ~/.claude/skills/<name>`
6. **Commit** — from the octobot repo:
   `jj describe -m "add skill: <name>"` (and `jj git push` if a remote exists).

## Template
```markdown
---
name: <kebab-name>
description: <what it does>. Use when <concrete trigger>.
---

# <kebab-name>

## When to use
- <trigger 1>
- <trigger 2>

## Process
1. ...
2. ...

## Output / done criteria
- ...
```

## Output / done criteria
- New `SKILL.md` exists at the right path, passes the checks in step 4.
- User has been told the exact `jj describe` command to run.
- Skill appears in the skill list on next Claude Code session start.

## Guardrails
- Never invent a category — ask if unsure.
- Never write a skill whose description lacks "Use when".
- If the skill needs > 100 lines of prose, split before committing.
