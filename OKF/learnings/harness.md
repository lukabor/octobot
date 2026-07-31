---
type: Learnings
purpose: Keep what Claude Code turned out to do when it loads, links and routes skills.
answers:
  - "What did we get wrong about how Claude Code loads and routes skills?"
cites:
  - README.md
  - skills/loop/sound/SKILL.md
status: live
---

# octobot — learnings: the harness

<!-- Append-only. Format: believed / true / source. Supersede, never
     rewrite. -->

- Believed: Claude Code scans `~/.claude/skills/` recursively.
  True: one level deep only — hence per-skill symlinks, not one repo
  symlink. Source: `README.md` §Install.
- Believed: skills can cross-invoke via description matching. True:
  cross-links are file paths, so disable-model-invocation is safe for
  linked skills; only description routing dies. Source: Claude Code
  skill mechanics, README §Install.
- Believed: a model-invoked skill's zero-fire test can run in whatever
  order the checks are listed. True: naming the skill loads its
  description, so every question after that measures a primed router,
  not a cold one — 007's check 4 (ten ordinary questions, zero fires)
  had to precede check 1 (`/sound` by name), and the session running it
  could not be the session that built it. A self-fire test is spoiled by
  the very context that motivates it. Source: weave of blueprint 007.
- Believed: reviewing a muster range needs the piped form,
  `jj diff --from <review-base> --to @ --git | hunk patch -`. True: in a
  colocated repo git `HEAD` tracks `@-`, so while the rig is one commit deep
  `HEAD` *is* the review-base and plain `hunk diff` shows exactly the muster
  range with full TUI navigation. The pipe stays the general answer — the
  moment the range spans two commits, `hunk diff` shows only the last slice.
  Source: rig of B-025.
