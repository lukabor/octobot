---
type: Summary
purpose: Orient an agent landing cold — what octobot is, how it runs, what to read next.
answers:
  - "What is octobot and how do I run it?"
cites:
  - README.md
  - skills
status: live
---

# octobot — summary

**What**: Personal, reusable Claude Code skills — a loop-engineering
metaharness plus language-agnostic productivity workflows that travel
across projects. Skills live here; per-skill symlinks under
`~/.claude/skills/` make Claude Code discover them.

**Stack**: Markdown skills (SKILL.md + progressive-disclosure siblings),
jujutsu (jj) for VCS, no build step.

**Run it**: nothing to run — install via the symlink loop in
[README.md](../README.md#install); verify a skill appears in a fresh
Claude Code session.

**Read next**: [ARCHITECTURE.md](ARCHITECTURE.md) for the category map
and the loop, [CONTEXT.md](CONTEXT.md) for vocabulary,
[ROADMAP.md](ROADMAP.md) for the metaharness build-out.
