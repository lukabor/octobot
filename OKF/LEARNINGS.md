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
- Believed: a marker-shape check can match its markers anywhere in the
  page. True: octobot's own blueprint 004 *documents* the `okf:derived`
  markers, so an unanchored match read them as a third fence and failed
  the repo's own OKF. A delimiter must be anchored to its whole line, or
  the page that specifies it becomes invalid. Source: weave of blueprint
  004.
- Believed: a model-invoked skill's zero-fire test can run in whatever
  order the checks are listed. True: naming the skill loads its
  description, so every question after that measures a primed router,
  not a cold one — 007's check 4 (ten ordinary questions, zero fires)
  had to precede check 1 (`/sound` by name), and the session running it
  could not be the session that built it. A self-fire test is spoiled by
  the very context that motivates it. Source: weave of blueprint 007.
- Believed: shedding both registers would bring ROADMAP under the 110-line
  cap. True: the warrant `okf-check` requires costs ~7 frontmatter lines a
  page, which the blueprint's arithmetic (184 − 58 − 16 = 110) did not
  budget — §Why had to be compressed as well. A page-cap plan must price
  the frontmatter it also mandates. Source: weave of blueprint 002.
- Believed: the cite/pin split earns its own register entry, since 004
  states it as prose only. True: the warrant is a duplicate —
  `page-warrant.md:36` already answers who owns cite drift, and
  [017](decisions/017-pin-drift-splits-by-visibility.md) supplies the
  visibility principle it follows from. A decision that *extends* a live
  one without changing it is that one applied, not a new one. Source:
  warrant test, session 2026-07-22; 020 stays unspent.
- Believed: a confirm-against-the-code step is what catches a stale
  index, so it must run for every claim. True: an index that returns
  **source** rather than metadata makes that step a re-read of bytes
  already in hand — its value survives only at the gaps where the index
  cannot answer (nothing indexed, and the working copy). A verification
  step earns its cost only where the step before it is blind. Source:
  weave of blueprint 008.
- Believed: `okf-check` can read a new nested frontmatter block (like
  `tally:`) through its generic `frontmatter()` parser. True: that parser
  flattens a nested block to an empty list — its indented `key: value` lines
  match neither its list nor its scalar branch — so a block check needs a
  dedicated regex grab, the way `pin()` handles `sealed:`. Source: weave of
  blueprint 011.
- Believed: a mandated new process step drops into a skill's leftover
  headroom under the ≤110-line cap. True: `moor` sat at 106 (4 spare), but
  the ferry-muster step is irreducibly ~10 lines — two VCS command examples
  carry it — so 012 lands `moor` at 115; the step cannot be absorbed without
  a SKILL/REFERENCE split, which exceeds the blueprint's two declared seams.
  A blueprint adding a step to a near-cap skill must price the split into its
  scope. Source: weave of blueprint 012.
- Believed: a Verify that greps for the old names is a sound gate for a
  rename sweep. True: it collides with the sweep's own doctrine — a rule
  banning a filename has to be able to *say* that filename, so prose listing
  the banned names trips the very grep meant to prove the sweep finished.
  014's locked Verify forced both the doctrine and this note to state the rule
  positively, naming no offender. A bare-filename grep cannot separate a
  *reference* from a *prohibition*; scope it to link syntax, or exempt the
  files that carry the rule. Source: weave of blueprint 014.
- Believed: grepping a file for the stale form is a sound gate for "every
  cross-reference resolves". True: grep is line-based and a gate only sees
  the files it names, so 016's locked Verify reported one stale back-ref
  where two existed — the second had wrapped between `*"Workflow"*` and
  `step 5` — and was blind to the identical off-by-one in `examples.md`,
  a sibling its Seams list did not name. A reference gate must assert the
  **target** exists (does `### 6` resolve?), not pattern-match the citing
  text, and must range over every file that cites, not only the ones being
  edited. Source: weave of blueprint 016.
- Believed: a blueprint whose Contract fixes a byte-exact artifact keeps
  room for its own defects. True: 018 crossed the 150-line cap five times
  in drafting — every fix prose, never the artifact — and then had no room
  to absorb the false-green in its own Verify; 019 carries it. Price the
  cap before writing the artifact in. Source: weave of blueprint 019.
