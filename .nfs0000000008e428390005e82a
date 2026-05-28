# Repo conventions — octobot

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
- This is a `jj` repo (colocated git). Commit with `jj describe -m "..."`.

## Concepts

Reference material — not loaded automatically, drop into a project's
`CLAUDE.md` or paste into a session when relevant:

- [karpathy-behavioral-guidelines](concepts/karpathy-behavioral-guidelines.md)
  — think-before-coding, simplicity-first, surgical changes, goal-driven loops.
