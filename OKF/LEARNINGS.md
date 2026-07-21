---
type: Learnings
purpose: Keep what was believed, what turned out true, and the source that settled it.
answers:
  - "What did we get wrong here, and what is actually true?"
cites:
  - README.md
  - skills/productivity/commit-atomic-jj/anti-patterns.md
status: live
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
- Believed: skills can cross-invoke via description matching. True:
  cross-links are file paths, so disable-model-invocation is safe for
  linked skills; only description routing dies. Source: Claude Code
  skill mechanics, README §Install.
- Believed: OKF was an octobot coinage. True: OKF v0.1 is also what
  OpenWiki emits, so import-compat is nearly free — but its output model
  (hundreds of generated files, CI-refreshed) is opposite pressure to
  OKF's ≤110-line durable synthesis. Source: langchain-ai/openwiki
  (scanned 2026-07-21).
- Believed: declared page plans were an octobot invention. True: they are
  convergent prior art — DeepWiki `pages[]{title, purpose, parent}` and
  deepwiki-skill's `toc.yaml`; decision 9 is the same move minus a config
  format. Source: <https://docs.devin.ai/work-with-devin/deepwiki>,
  <https://github.com/natsu1211/deepwiki-skill> (scanned 2026-07-21).
- Believed: shedding both registers would bring ROADMAP under the 110-line
  cap. True: the warrant `okf-check` requires costs ~7 frontmatter lines a
  page, which the blueprint's arithmetic (184 − 58 − 16 = 110) did not
  budget — §Why had to be compressed as well. A page-cap plan must price
  the frontmatter it also mandates. Source: weave of blueprint 002.
