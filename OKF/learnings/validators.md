---
type: Learnings
purpose: Keep what the check scripts turned out to see, and what their parsers are blind to.
answers:
  - "What did we get wrong about the OKF check scripts?"
cites:
  - skills/loop/write-OKF/scripts/okf-check
status: live
---

# octobot — learnings: the validators

<!-- Append-only. Format: believed / true / source. Supersede, never
     rewrite. -->

- Believed: a marker-shape check can match its markers anywhere in the
  page. True: octobot's own blueprint 004 *documents* the `okf:derived`
  markers, so an unanchored match read them as a third fence and failed
  the repo's own OKF. A delimiter must be anchored to its whole line, or
  the page that specifies it becomes invalid. Source: weave of blueprint
  004.
- Believed: `okf-check` can read a new nested frontmatter block (like
  `tally:`) through its generic `frontmatter()` parser. True: that parser
  flattens a nested block to an empty list — its indented `key: value` lines
  match neither its list nor its scalar branch — so a block check needs a
  dedicated regex grab, the way `pin()` handles `sealed:`. Source: weave of
  blueprint 011.
- Believed: a lint that proves three renders byte-identical protects the
  rendered shape. True: it proves identity only. A rename inside the
  box-drawing block shifts every copy the same way, so a name that shortens
  by two columns leaves the right-hand column and its arrows misaligned in
  all three at once and the check still passes. Re-pad the trailing columns
  by hand. Source: rig of B-024.
- Believed: superseding a blueprint costs one status word, so extracting
  shared code cannot touch the page it supersedes. True: a `cites:` symbol
  is a substring of *a named file*, so moving the cited lines into a new
  helper breaks the cite — `okf-check` went red on B-023 for a docstring
  that had moved to `_pages.py`, after the diff was already sealed. Per
  B-022 a cite is a working pointer at every status, so the pointer
  follows the symbol. Repointing has a trap of its own: the phrase wrapped
  across two lines in its new home, and a wrapped symbol never resolves,
  so the obvious repoint stays red. Source: rig of B-026.
- Believed: gating `implemented` on a `tally:` block's presence gates the
  muster verdict. True: `not tally(text)` only tests that the block exists
  — a `tally: matches: no` block is non-empty, so it passed the same check
  a missing block failed. A presence check is not a verdict check; the
  field inside still has to be read. Source: rig of B-027.
