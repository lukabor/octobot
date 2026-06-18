---
name: conjure-a-skill
description: Conjure a new Claude Code skill that earns its place — verb-first name, sharp completion criteria, progressive-disclosure layout, no-op-free body, every file ≤110 lines. Use when the user says "conjure a skill", "/conjure-a-skill", "write a skill", "create a skill", "add a skill", or describes a recurring workflow worth capturing.
---

# conjure-a-skill

## When to use
- User says "conjure a skill", "/conjure-a-skill", "write a skill",
  "create a skill", "add a skill".
- User describes a recurring workflow and asks to make it reusable.
- You notice the same multi-step process being requested across sessions and
  suggest capturing it as a skill.

## Design principles
A skill exists to wrangle **predictability** out of a stochastic system —
the agent taking the same *process* every run. Leading words to think with:
**context load** (cost a model-invoked skill pays each turn), **leading
word** (the *Leitwort* that anchors a region of behaviour in one token),
**progressive disclosure** (pushing **reference** behind a **context
pointer** so the top of the **information hierarchy** stays legible),
**sprawl** (a SKILL.md too long, even when every line is live).
Failure modes to hunt: **premature completion**, **duplication**,
**sediment**, **no-op**.

Full vocabulary: [GLOSSARY.md](GLOSSARY.md). Design playbook: [PRINCIPLES.md](PRINCIPLES.md).

## Process
1. **Gather** — ask the user (one message, grouped):
   - kebab-case name and which category (`productivity`, `engineering`,
     `misc`)
   - name is a **verb-first action phrase** (`build-py-project`,
     `conjure-a-skill`) — the **leading word** that anchors invocation;
     never a vague noun (`helper`, `utils`)
   - one-line purpose
   - concrete trigger phrases ("Use when ...")
   - **completion criteria** — checkable, exhaustive (see PRINCIPLES.md)
   - any deterministic helpers needed (scripts? reference docs?)
2. **Check for overlap** — `ls ~/code/octobot/skills/*/` and grep
   descriptions; a near-match is **duplication** — propose extending the
   existing skill instead.
3. **Draft** `~/code/octobot/skills/<category>/<name>/SKILL.md` using the
   template below.
4. **Review** — show the draft to the user; iterate until approved. Verify:
   - `name:` matches the folder name
   - `description:` contains "Use when" and is ≤ 1024 chars
   - **every file ≤ 110 lines** — octobot's house cap on **sprawl**. If
     SKILL.md is too long, use **progressive disclosure**: push
     **reference** into **topic-named siblings** (`tests-r.md`,
     `mocking-r.md`, `feedback-loops-r.md`, `anti-patterns.md`,
     `examples.md`). One topic per file, named for the topic. `GLOSSARY.md`
     is the documented exception (flat dictionary; splitting breaks lookup).
   - no time-sensitive content
   - every line passes the **no-op** test (PRINCIPLES.md §pruning)
5. **Link** — Claude Code only scans one level deep under
   `~/.claude/skills/`, so create a per-skill symlink:
   `ln -s ~/code/octobot/skills/<category>/<name> ~/.claude/skills/<name>`
6. **Commit** — from the octobot repo, following the `type(scope):
   imperative` format from [`../jj-atomic/SKILL.md`](../jj-atomic/SKILL.md):
   `jj describe -m "feat(skills): add <name> skill"`
   (and `jj git push` if a remote exists).

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
- Every file in the skill folder is ≤ 110 lines (GLOSSARY.md excepted).
- User has been told the exact `jj describe` command to run.
- Skill appears in the skill list on next Claude Code session start.

## Guardrails
- Never invent a category — ask if unsure.
- Never write a skill whose description lacks "Use when".
- **Never let a file in the skill folder exceed 110 lines** (GLOSSARY.md
  excepted). Split before committing.
- Reject any line that fails the **no-op** test (PRINCIPLES.md §pruning).

## See also
- [PRINCIPLES.md](PRINCIPLES.md) — the design playbook this skill applies.
- [GLOSSARY.md](GLOSSARY.md) — definitions for every bold term above.
- [`../jj-atomic/SKILL.md`](../jj-atomic/SKILL.md) — commit format.
