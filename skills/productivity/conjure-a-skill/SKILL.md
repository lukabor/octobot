---
name: conjure-a-skill
description: Author a new octobot skill: verb-first name, Use-when description, 110-line cap, symlink install.
disable-model-invocation: true
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

Full vocabulary: [glossary.md](glossary.md). Design playbook: [principles.md](principles.md).

## Process
1. **Gather** — ask the user (one message, grouped):
   - kebab-case name and which category (`loop`, `productivity`,
     `engineering`, `scaffold`)
   - name **must** open with an imperative verb (`build-py-project`,
     `steer`). Test: prefix with "please" — still a command? No → reject.
     No new-skill exceptions; `bdd` is the single grandfathered non-verb
     name (initialism, trigger muscle memory), not precedent.
   - **invocation**: default `disable-model-invocation: true` + a
     [`steer`](../../loop/steer/SKILL.md) row; model-invoked only when
     the agent must fire it from natural mid-work phrasing (then the
     description carries "Use when" triggers).
   - one-line purpose
   - concrete trigger phrases ("Use when ...")
   - **completion criteria** — checkable, exhaustive (see principles.md)
   - any deterministic helpers needed (scripts? reference docs?)
2. **Check for overlap** — `ls ~/code/octobot/skills/*/` and grep
   descriptions; a near-match is **duplication** — propose extending the
   existing skill instead.
3. **Draft** `~/code/octobot/skills/<category>/<name>/SKILL.md` using the
   template below.
4. **Review** — show the draft to the user; iterate until approved. Verify:
   - `name:` matches the folder name **and opens with an imperative
     verb** — a noun-first name fails review outright
   - `description:` ≤ 1024 chars; "Use when" triggers only if
     model-invoked (user-invoked descriptions are one human-facing line)
   - **headings** — pipeline-stage skills keep the procedural set; spine and
     router skills may name a section for what it is (`The spine`, `The
     brake`) when that says more than the generic word
   - **`SKILL.md` ≤ 110 lines** — octobot's house cap on **sprawl**. If it
     grows past that, use **progressive disclosure**: push **reference**
     into **topic-named siblings** (`tests-r.md`, `mocking-r.md`,
     `feedback-loops-r.md`, `anti-patterns.md`, `examples.md`). One topic
     per file, named for the topic, in **lowercase-kebab** — a generic
     catch-all name or an uppercase one fails review; `SKILL.md` is the only
     uppercase file in the directory. Siblings carry no hard cap — they load
     on demand — but keep one topic per file.
   - no time-sensitive content
   - every line passes the **no-op** test (principles.md §pruning)
5. **Link** — Claude Code only scans one level deep under
   `~/.claude/skills/`, so create a per-skill symlink:
   `ln -s ~/code/octobot/skills/<category>/<name> ~/.claude/skills/<name>`
6. **Commit** — from the octobot repo, following the `type(scope):
   imperative` format from [`../commit-atomic-jj/SKILL.md`](../commit-atomic-jj/SKILL.md):
   `jj describe -m "feat(skills): add <name> skill"`
   (and `jj git push` if a remote exists).

## Template
```markdown
---
name: <kebab-name>
description: <what it does>. Use when <concrete trigger>.
---

# <kebab-name>

## When to use / Process / Output-done criteria
(as in any sibling SKILL.md)
```

## Output / done criteria
- New `SKILL.md` exists at the right path, passes the checks in step 4.
- **`scripts/skill-check skills/` run and its output pasted**, exiting 0.
- User has been told the exact `jj describe` command to run.
- Skill appears in the skill list on next Claude Code session start.

## Guardrails
- Never invent a category — ask if unsure.
- Never accept a name that doesn't open with an imperative verb.
- Never write a model-invoked skill whose description lacks "Use when".
- Never finish without adding the skill's row to
  [`steer`](../../loop/steer/SKILL.md).
- **Never let `SKILL.md` exceed 110 lines.** Split into topic-named
  siblings before committing.
- Reject any line that fails the **no-op** test (principles.md §pruning).

## See also
- [principles.md](principles.md) — the design playbook this skill applies.
- [glossary.md](glossary.md) — definitions for every bold term above.
- [`../commit-atomic-jj/SKILL.md`](../commit-atomic-jj/SKILL.md) — commit format.
