---
type: Learnings
purpose: Keep what jj turned out to do under a headless agent, against what was assumed.
answers:
  - "What did we get wrong about jj under a headless agent?"
cites:
  - skills/productivity/commit-atomic-jj/anti-patterns.md
  - skills/productivity/resolve-conflicts-jj/SKILL.md
status: live
---

# octobot — learnings: version control

<!-- Append-only. Format: believed / true / source. Supersede, never
     rewrite. -->

- Believed: `jj squash`/`describe` can run like any shell command.
  True: without `-m` / `--use-destination-message` they open an editor
  and hang headless sessions; backgrounded jj mutations race the
  working-copy snapshot. Source:
  `skills/productivity/commit-atomic-jj/anti-patterns.md`, session 2026-07-19.
- Believed: a conflicted jj chain must be resolved where it stands.
  True: check topology first — a chain rebased onto the wrong root
  produces phantom conflicts; rebasing onto the true destination shrank
  a 2-file conflict to 1 file before any hand-resolution. Source:
  session 2026-07-19 (write-readme-py conflict).
- Believed: `jj restore <path>` undoes "what I just appended to this
  file." True: with no `--from`, it reverts to the parent commit's
  snapshot — discarding every uncommitted edit on that path, not just
  the last append. A Verify script that plants a probe line and cleans
  up with `jj restore` wipes real Build work sitting uncommitted on the
  same file. Fix: undo exactly the planted lines (`head -n -N`), never
  a blanket restore, when other uncommitted edits may be present. Source:
  [028](../blueprints/028-convert-cross-skill-links-to-skill-names.md),
  session 2026-09-23.
