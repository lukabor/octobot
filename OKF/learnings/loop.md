---
type: Learnings
purpose: Keep what the loop's own steps taught — blueprint scoping, Verify design, the cap.
answers:
  - "What did we get wrong about the loop's own steps?"
cites:
  - skills/loop/blueprint/blueprint-format.md
  - skills/loop/weave/SKILL.md
status: live
---

# octobot — learnings: the loop

<!-- Append-only. Format: believed / true / source. Supersede, never
     rewrite. -->

- Believed: a confirm-against-the-code step is what catches a stale
  index, so it must run for every claim. True: an index that returns
  **source** rather than metadata makes that step a re-read of bytes
  already in hand — its value survives only at the gaps where the index
  cannot answer (nothing indexed, and the working copy). A verification
  step earns its cost only where the step before it is blind. Source:
  weave of blueprint 008.
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
