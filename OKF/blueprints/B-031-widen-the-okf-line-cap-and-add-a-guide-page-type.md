---
type: Blueprint
status: implemented
traces-to: user request 2026-10-01
sounded: 2026-10-01
cites:
  - skills/loop/write-OKF/scripts/okf-check
  - skills/loop/write-OKF/okf-layout.md
  - skills/loop/write-OKF/split-page.md
  - OKF/learnings/okf-format.md
muster: false  # Verify runs okf-check against real + synthetic fixtures and checks exit codes — observes the cap/type logic directly, not just "tests pass"
---

# 031 — widen the OKF line cap and add a Guide page type

## Justification

A downstream consumer (`gcbds-ta-tgt-report`) wants `OKF/` to be a repo's
single source of truth, with nothing durable left in `docs/` for a human
to read and silently drift out of sync with what an agent sees. Two
gaps block that: (1) `ROADMAP.md` and `CONTEXT.md` have no split
mechanism — `ROADMAP.md` prunes, never splits; `CONTEXT.md` is "one
canonical glossary... never splits" — so the current 110-line cap is the
only ceiling they have, with nowhere to go at cap+1 besides losing
content; (2) worked-example/howto docs (dataset-config walkthroughs,
external-notebook provenance writeups) have no spine page at all to live
on — `modules/`/`analyses/` are warrant-exempt but still capped at 110,
too tight for a tutorial with inline code.

This traces to a user request in conversation, reconciled against prior
art already in this repo's history: an unmerged branch
(commit `e84fdf486ae6`, blueprints then-numbered 027/028, both now stale
— collide with `main`'s current B-030 numbering and predate the
`R-`/`B-` filename-prefix convention B-030 introduced) had independently
raised `ROADMAP.md`+blueprint+`CONTEXT.md` caps to 250 using a
`type:`-frontmatter-based selection. That design is reused here; the
branch itself is not merged or rebased — redone fresh against `main`.

## Contract

- `scripts/okf-check`'s line-cap check changes from two tiers
  (`CAP = 110`, `BLUEPRINT_CAP = 150`) to two tiers at different
  thresholds: `CAP = 110` stays the default; a new `WIDE_CAP = 250`
  applies when either `"blueprints" in rel.parts` (unchanged path rule)
  **or** the page's frontmatter `type:` is `"Roadmap"`, `"Glossary"`, or
  `"Guide"` (new — type-based, not path-based, so it follows `ROADMAP.md`
  / `CONTEXT.md` by declared kind rather than filename).
- A new page type `Guide` is added to the OKF spine: pages live at
  `OKF/guides/<name>.md`, carry `type: Guide`, and are warrant-exempt the
  same way `modules/`/`analyses/` are (not root-scoped per
  `page-warrant.md`'s "root pages and `decisions/`" scope line).
  `OKF/guides/` is proposed nowhere by `taxonomy-scan.md` — a guide is
  always authored, never scan-proposed, so it carries no `okf:derived`
  fence.
- A guide over the 250-line cap grows from `<name>.md` into `<name>/`
  (`guide.md` + sibling files) the same directory-growth shape
  blueprints already use at their own cap — except a guide's sibling
  files are typically extracted runnable code (the inline R/Python block
  pulled out of the prose into a real script the guide then cites),
  not blueprint-style notes.
- `okf-layout.md`'s page-set diagram, Conformance page-type list, Page
  contracts section (a new `Guide` bullet), and Rules section's cap
  sentence are updated to state the above.
- `split-page.md`'s opening cap sentence and a new "When the page is a
  guide" section (parallel to the existing "When the page is a
  blueprint" one) are added, naming code-extraction as the move.
- `OKF/learnings/okf-format.md` gains one new believed/true/source entry
  recording a real footgun found while rigging the stale branch's B-028:
  a blueprint's Verify step that pads and then restores (`jj restore` /
  `git restore`) a file the *same blueprint* edits silently loses the
  edit, because restore pulls from the parent and `describe` does not
  move the change there until `jj new` — so the file reverts to
  pre-edit state while the Verify still prints `OK`.

## Seams touched

- `skills/loop/write-OKF/scripts/okf-check` — the `CAP`/`BLUEPRINT_CAP`
  constants and the cap-selection branch inside the per-page loop.
- `skills/loop/write-OKF/okf-layout.md` — spine diagram, Conformance
  page-type enum, Page contracts section, Rules section.
- `skills/loop/write-OKF/split-page.md` — opening sentence, new Guide
  section.
- `OKF/learnings/okf-format.md` — one new append-only entry.
- `OKF/CONTEXT.md` — **Line cap** / **House cap** glossary entries, which
  state the current 110/150 numbers and must track the new ones.

## Verify

```bash
cd skills/loop/write-OKF
# 1. No regression: this repo's own OKF still validates.
python3 scripts/okf-check ../../../OKF
# 2. The new cap/type logic actually fires, both directions.
python3 - <<'PY'
import pathlib, subprocess, sys, tempfile
root = pathlib.Path(tempfile.mkdtemp()) / "OKF"
root.mkdir()
(root / "index.md").write_text(
    '---\nokf_version: "0.1"\n---\n# t\n- [a](a.md)\n- [b](b.md)\n'
)
filler = "\n" * 200
(root / "a.md").write_text(f'---\ntype: Roadmap\n---\n# a\n{filler}')
(root / "b.md").write_text(f'---\ntype: Architecture\n---\n# b\n{filler}')
r = subprocess.run([sys.executable, "scripts/okf-check", str(root)],
                    capture_output=True, text=True)
out = r.stdout + r.stderr
assert "a.md: over the" not in out, "Roadmap page wrongly capped at 110"
assert "b.md: over the 110-line cap" in out, "Architecture page should still cap at 110"
print("OK — Roadmap exempt, Architecture still capped")
PY
```

Both must exit/print clean — the real-repo check exits 0, the synthetic
check prints `OK`.

## Out of scope

- Merging or rebasing the stale `e84fdf486ae6` branch — its design is
  reused, its history is not.
- Applying this to `gcbds-ta-tgt-report`'s `docs/` — a separate
  follow-up once this blueprint ships, not part of this Verify.
- Raising any cap beyond the two tiers stated (`decisions/`,
  `modules/`, `analyses/`, `LEARNINGS.md`/`learnings/` stay at 110).
- A second guardrail blueprint for the Verify-restore footgun (the
  stale branch's B-029) — recorded as a `LEARNINGS.md` entry only,
  prose, not tooling, unless a future `/rig` run hits it again.
