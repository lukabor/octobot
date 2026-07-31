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
