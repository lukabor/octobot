---
type: Learnings
purpose: Keep what the OKF format's page contracts, warrants and prior art turned out to be.
answers:
  - "What did we get wrong about the OKF format itself?"
cites:
  - skills/loop/write-OKF/okf-layout.md
  - skills/loop/write-OKF/page-warrant.md
status: live
---

# octobot — learnings: the OKF format

<!-- Append-only. Format: believed / true / source. Supersede, never
     rewrite. -->

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
- Believed: the cite/pin split earns its own register entry, since 004
  states it as prose only. True: the warrant is a duplicate —
  `page-warrant.md:36` already answers who owns cite drift, and
  [017](../decisions/R-017-pin-drift-splits-by-visibility.md) supplies the
  visibility principle it follows from. A decision that *extends* a live
  one without changing it is that one applied, not a new one. Source:
  warrant test, session 2026-07-22; 020 stays unspent.
- Believed: a Verify step that pads a file and then restores it is safe
  once the padding is described in prose. True: `jj restore` (and `git
  restore` / `git checkout --`) restores from the **parent** revision,
  and `describe` does not move the working-copy edits there — they stay
  on `@` until the next `jj new`. A Verify that pads and restores a path
  the *same blueprint* also edits throws that edit away, silently,
  possibly more than once, while every step still prints `OK`. A Verify
  may only pad-and-restore paths outside its own blueprint's edits; a
  path inside them needs a different check shape (diff against a named
  commit, not restore-and-compare). Source: a prior unmerged exploration
  of B-031's own cap-raise, discovered while sounding it.
