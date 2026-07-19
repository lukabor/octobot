---
type: Learnings
---

# octobot — learnings

<!-- Append-only. Format: believed / true / source. Supersede, never
     rewrite. -->

- Believed: `jj squash`/`describe` can run like any shell command.
  True: without `-m` / `--use-destination-message` they open an editor
  and hang headless sessions; backgrounded jj mutations race the
  working-copy snapshot. Source:
  `skills/productivity/commit-atomic-jj/anti-patterns.md`, session 2026-07-19.
- Believed: Claude Code scans `~/.claude/skills/` recursively.
  True: one level deep only — hence per-skill symlinks, not one repo
  symlink. Source: `README.md` §Install.
- Believed: a conflicted jj chain must be resolved where it stands.
  True: check topology first — a chain rebased onto the wrong root
  produces phantom conflicts; rebasing onto the true destination shrank
  a 2-file conflict to 1 file before any hand-resolution. Source:
  session 2026-07-19 (write-readme-py conflict).
