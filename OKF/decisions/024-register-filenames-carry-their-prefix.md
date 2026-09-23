---
type: Decision
purpose: Make a decision or blueprint findable by filename alone, not just by prose convention.
answers:
  - "Does a register entry's filename carry its prefix, or only its prose citation?"
cites:
  - OKF/decisions/022-prose-cites-carry-a-register-prefix.md
  - OKF/CONTEXT.md
  - skills/loop/blueprint/blueprint-format.md
  - skills/engineering/model-domain/decision-format.md
status: live
reversible: rename back; every link this change touches was mechanically
  rewritten, so the reverse rewrite is the same mechanism run backward
---

# 024 — register filenames carry the R-/B- prefix

**Supersedes [022](022-prose-cites-carry-a-register-prefix.md)'s filename
ruling.** R-022 kept `OKF/decisions/NNN-<slug>.md` and
`OKF/blueprints/NNN-<slug>.md` bare on disk — "a reading aid, not an
identity" — on the reasoning that renaming breaks every link for no
gain over the prose prefix. That trade flips once filename search is
itself a workflow: `ls OKF/decisions/ | grep R-024`, a fuzzy-finder
match on `B-` or `R-`, or a shell glob all need the prefix *in the
filename*, not just in prose that quotes it. Effective now:
`OKF/decisions/NNN-<slug>.md` → `R-NNN-<slug>.md`,
`OKF/blueprints/NNN-<slug>.md` → `B-NNN-<slug>.md`. Ferry `D-n` files
(`OKF/ferries/<topic>/D-<n>-<slug>.md`) are untouched — they already
carry their prefix, which is the collision R-022 exists to avoid.

The **number stays permanent and un-renumbered** — only the prefix is
added; `R-024` and the historical `024` are the same decision. `status:
superseded-by-NNN` values, `cites:` entries that name a bare number in
prose, and `traces-to` fields keep R-022's prose form (`R-NNN`) since
those are citations, not filenames.

## Considered options

**Retrofit forward-only** (new files get the prefix, existing ones
don't) was rejected for the reason R-022 already gave for the same
choice: two dialects on disk is the defect, not a saving. A migration
retroactively renames every existing decision and blueprint file and
repairs every real link that resolves to one; a bare, unlinked prose
number in `LEARNINGS.md` is not retrofitted, matching R-022's append-only
exemption for that page specifically.

**Editing R-022 in place** instead of superseding it was rejected — R-022
remains an accurate record of the reasoning at the time it was written;
rewriting it would erase the trail future readers need to see why the
bare-filename choice was made before being reversed.

## Consequences

- `OKF/blueprints/` and `OKF/ferries/` gain their own `index.md`,
  delegating from `OKF/index.md` the way `decisions/` and `learnings/`
  already do — the direct per-directory listing this decision's
  filename search assumes did not exist for those two before.
- `skills/loop/blueprint/SKILL.md`'s numbering step and `okf-check`'s
  number-extraction both read `[0-9]{3}` today; both need the `R-`/`B-`
  prefix accounted for. Not fixed by this decision — the migration
  blueprint that performs the rename owns that.
