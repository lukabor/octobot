# CLAUDE.md — octobot

Behavioral guidelines to reduce common LLM coding mistakes, plus repo-local
conventions for editing octobot itself. Merge with project-specific
instructions as needed.

**Tradeoff:** These guidelines bias toward caution over speed. For trivial
tasks, use judgment.

## 1. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

Before implementing:
- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them - don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

## 2. Simplicity First — the three sieves

**Admit nothing by default. Every line must earn its place — to enter, or to
stay.** Pass each through three sieves:

- **Real** — Is the need true, or speculative? No feature beyond what was
  asked; no abstraction for single-use code; no "flexibility" nobody
  requested; no error handling for impossible scenarios.
- **Good** — Does it leave the code better for the next reader — not merely
  shorter? Betterment must be nameable, not cosmetic.
- **Minimal** — Is this the leanest form? stdlib before custom code; a native
  feature before a dependency; one line before fifty.

The burden is on **keeping**, not cutting: "it's clearer this way" must
*justify* survival, never merely *excuse* it. If you write 200 lines and it
could be 50, rewrite it.

Run the sieves at the **seal boundary** (the commit), not per keystroke — the
[`sieve`](skills/engineering/sieve/SKILL.md) skill is the full gate, and
[`winnow`](skills/engineering/winnow/SKILL.md) the after-the-fact debloat
pass. Exceptions that always pass Good: input validation, error handling that
prevents data loss, security, accessibility, explicitly requested behaviour.

## 3. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code:
- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it - don't delete it.

When your changes create orphans:
- Remove imports/variables/functions that YOUR changes made unused.
- Don't remove pre-existing dead code unless asked.

The test: Every changed line should trace directly to the user's request.

## 4. Goal-Driven Execution

**Define success criteria. Loop until verified.**

Transform tasks into verifiable goals:
- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Refactor X" → "Ensure tests pass before and after"

For multi-step tasks, state a brief plan:
```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

Strong success criteria let you loop independently. Weak criteria ("make it
work") require constant clarification.

---

**These guidelines are working if:** fewer unnecessary changes in diffs,
fewer rewrites due to overcomplication, and clarifying questions come before
implementation rather than after mistakes.

_Sections 1–4 adapted from
<https://github.com/multica-ai/andrej-karpathy-skills/blob/main/CLAUDE.md>._

---

## 5. Repo conventions — octobot

This repo holds Claude Code skills. When editing here:

- Every skill lives at `skills/<category>/<kebab-name>/SKILL.md`.
- `name:` in frontmatter must match the folder name exactly.
- `description:` must contain an explicit "Use when ..." trigger and stay
  under 1024 characters. The description is the *only* thing the agent sees
  when deciding to load the skill — make triggers concrete.
- Keep `SKILL.md` ≤ 100 lines. Split into `REFERENCE.md` / `EXAMPLES.md` if
  it grows.
- No time-sensitive content (dates, "current" model names).
- `scripts/` is only for deterministic helpers, not prose.
- Claude Code only scans one level deep under `~/.claude/skills/`; new
  skills need their own symlink (see README).
- This is a `jj` repo (colocated git). Commit with `jj describe -m "..."`.
