---
type: Blueprint
status: implemented
traces-to: user request 2026-07-23
sounded: 2026-07-23
---

# 008 — make nostos primary and file reads the fallback

## Justification

[007](B-007-add-sound.md) made the live-code read step 3 of every sounding,
on the warrant that the OKF and the index can both go stale
(`../CONTEXT.md:85-89`). That warrant predates nostos being on the
machine. Nostos serves codegraph over MCP, and codegraph's `node` and
`explore` return **source**, not metadata — so querying it is a change of
retrieval path, not a loss of ground truth, and step 3 as written re-reads
bytes step 2 already returned.

Two things the index cannot answer survive, and only those justify a
file read: what its parsers do not cover, and what no commit has seen yet.

## Contract

**The spine.** Three steps, step 3 now conditional:

1. **OKF** — unchanged from 007.
2. **nostos** — query the nostos MCP server. Primary source for what the
   code says, not a hint feeding a later read. Absent or unconfigured →
   every query returns empty, routing every claim to step 3; say so once
   and continue.
3. **File read — fallback only.** A file is opened for a claim in
   exactly two cases:
   - **Empty result.** Nostos returned nothing. Empty means *not
     indexed*, never *not there* — an unindexed repo and a file type
     codegraph's parsers do not own are indistinguishable here, and both
     are answered the same way.
   - **Dirty path.** The claim touches a path with uncommitted changes,
     per one `jj st` per run.

   Neither condition → the nostos answer stands, unread.

**One rule, both triggers.** The dirty-path fallback is correct under
either nostos `--trigger` mode: under `poll` the dirty set is exactly the
index's blind spot; under `watch` the re-reads are redundant but few,
since a sounding's dirty set is small. Sound therefore **never detects or
depends on the configured trigger**, and nothing states a trigger as a
precondition.

**MCP only.** Sound talks to the nostos MCP server and never shells out
to `codegraph`. Freshness is nostos's job by construction. Sound's
disjoint knowledge is the working copy — which is why `jj st` is sound's
call and `codegraph status` is not.

**No coverage sweep.** `codegraph files` is never called; its output is
the repo's file list. Coverage is answered lazily by the empty-result
rule, at zero cost.

**Cites prefer `path:symbol`.** Sound's cites adopt the rule
`okf-layout.md:46-51` already sets for page frontmatter — symbol where a
symbol carries the claim, since that is the shape that breaks when the
thing it cites moves, while a line suffix is a reading aid that nothing
validates. Extending it to sound's prose cites, which `okf-check` does
not reach, is the whole of this clause.

## Seams touched

- `skills/loop/sound/SKILL.md` — *The spine* (`:14-29`), step 3 becomes
  conditional; the cite rule (`:26`). The `Never` at `:67-68` stands
  unchanged — skipping step 1 is still the failure shape.
- `OKF/CONTEXT.md:85-89` — the **Sounding** entry states the old order.
- `README.md:61-62` — the same claim, one line.

`OKF/ARCHITECTURE.md` is **not** a seam: it names the invocation seam
(`:47-50`) and 019, never the spine. `OKF/ROADMAP.md` phase 9 is **not**
a seam: `:62-67` records what was verified on 2026-07-22 and is
append-only per [013](../decisions/R-013-roadmap-is-a-plan.md). Neither is
touched. `blueprint`, `blueprint-format.md`, `okf-check` and the
`sounded:` gate are untouched — see *Out of scope*.

## Verify

```sh
skills/loop/write-OKF/scripts/okf-check OKF/
awk 'END{print NR}' skills/loop/sound/SKILL.md
grep -rni 'live code' README.md OKF/CONTEXT.md skills/loop/sound/SKILL.md
```

Expect `0 error(s)`, a count ≤ 110, and the grep matching nothing.

Two session checks the script cannot make, run once each:

1. A sounding in a repo with no `.codegraph` — every query empty, sound
   falls back to file reads for every claim and completes as today.
2. A sounding where a cited file has uncommitted changes — that file is
   read, and the nostos answer for it is not taken on trust.

## Out of scope

- **Sounding marks in code** (`TODO(bp-NNN)` or any form), and any
  `okf-check` rule enforcing their removal. Cut during grilling: sound
  stamps at draft, `Seams touched` is not fixed until lock, so no point
  in the lifecycle gives a mark a stable owner — and it duplicates
  `Seams touched` besides.
- Shelling out to `codegraph` for any purpose, `codegraph status`
  included.
- Any change to the two-mouths discipline, the `sounded:` stamp, or the
  lock gate — 007's contract stands.
- Indexing octobot itself, and any `nostos` invocation from this repo.
- Retro-sounding 001–007.
