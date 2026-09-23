---
type: Blueprint
status: implemented
traces-to: ROADMAP.md phase 7 (decisions 12, 13, 16)
---

# 002 — extract the why-register from ROADMAP

## Justification

ROADMAP.md carries two forever-growing sections against a 110-line page
cap, and sits at 184. Decisions 12, 13 and 16 settle the response; this
blueprint implements them and adds nothing they do not already state.
The validator follows the doctrine in
[project-validator.md](../../skills/engineering/add-copilot-project-skill/project-validator.md).

## Contract

**`OKF/decisions/` exists**, holding one file per settled decision plus
an index.

- `NNN-<slug>.md` per decision, zero-padded to three digits. Decisions
  1–16 keep their numbers — they are cited from CONTEXT.md and commit
  messages, so renumbering breaks references. The register starts
  populated at 001–016.
- Decision bodies move **verbatim**. Migration adds frontmatter; it does
  not reword, merge, split, or re-argue any decision.
- Frontmatter: `type: Decision`, the warrant (`purpose`, `answers[]`,
  `cites[]`) per decision 8, then `status: live | superseded-by-NNN` and
  `reversible:` — both lifted from the clause each decision already states.
- `decisions/index.md` lines are **question-shaped**, one per decision:
  `NNN — <question it settles> — <verdict> — <status>`. That is a
  requirement, not a style note — it is what makes the index answer a
  query instead of listing titles. The question is **derived** from the
  file's first `answers:` entry, never written twice; `okf-check` errors
  when a line and its source disagree.

**ROADMAP sheds both registers.**

- §Locked decisions becomes a pointer to `decisions/index.md` with a live
  count. The section header stays — architect's skeleton is unchanged.
- §Risks & gotchas keeps only forward-looking risk. Believed/true/source
  entries move to `LEARNINGS.md`, which carries that schema already and
  which ROADMAP already instructs mirroring into.
- ROADMAP ends ≤110 lines; the over-cap note goes with the breach.

**`adr/` is retired, and every reference with it.** The directory is
empty, so removal — but ten skill and doc files still point at it, and a
register that leaves dangling pointers has not landed. The set is defined
by `grep -rln 'OKF/adr' skills/ README.md`, which must return nothing
afterwards. `model-domain` owns the directory: its three-of-three rule is
replaced by the warrant per decision 12, and `ADR-FORMAT.md` becomes the
decision-file format rather than a separate one. `OKF/index.md`
§Decisions points at `decisions/index.md`.

**`okf-check` exists** at `skills/loop/write-OKF/scripts/`, exiting 1 on
any error and 0 otherwise, listing every finding with its page path.

- Errors: page missing `type:`; page missing `purpose:` or `answers:`; an
  `answers:` entry appearing on two pages; an unresolvable `cites:` path;
  a page present in the tree but absent from `index.md`.
- Warnings, exit 0: page over 110 lines; page with zero `cites:`.
- It must exit 0 on octobot's OKF the moment this lands — per the
  doctrine, an invariant that fails on a clean tree trains people to
  ignore the validator, so what octobot cannot satisfy today is a warning
  or is absent.
- Stdlib only; frontmatter parsing handles multi-line `answers:` lists.
- Script, not a skill — no SKILL.md, no invocation surface. Callers reach
  it **from the skill's own base directory**, never a repo-relative path,
  since `skills/loop/...` resolves only inside octobot and write-OKF's
  purpose is running elsewhere. The target OKF is an argument.

**write-OKF gates on it** — done-criteria require running `okf-check` and
pasting output; a claim of conformance is not a gate. `okf-layout.md`
documents the register and the warrant contract.

## Seams touched

- `skills/loop/write-OKF/scripts/okf-check` — CLI: `okf-check <okf-dir>`,
  findings on stdout, exit 0/1. The interface tests run against.
- `OKF/decisions/index.md` — question-shaped index format.
- `OKF/decisions/NNN-<slug>.md` — warrant frontmatter contract.
- `OKF/ROADMAP.md` §Locked decisions, §Risks & gotchas — pointer shape.
- `OKF/index.md` §Decisions — register link replacing `adr/`.
- `skills/loop/write-OKF/SKILL.md` done-criteria + `okf-layout.md`.
- `model-domain/ADR-FORMAT.md` — decision-file format, renamed and
  re-pointed. The rest of the sweep is reference edits, not seams.

## Verify

```sh
skills/loop/write-OKF/scripts/okf-check OKF/ \
  && test "$(wc -l < OKF/ROADMAP.md)" -le 110 \
  && test "$(ls OKF/decisions/[0-9][0-9][0-9]-*.md | wc -l)" -eq 16 \
  && test ! -d OKF/adr \
  && test -z "$(grep -rln 'OKF/adr' skills/ README.md)" \
  && grep -c '^- ' OKF/decisions/index.md \
  && echo PASS
```

## Out of scope

- Ferry graduation, directory collapse, and the `sealed:` pin, plus the
  `okf-check` rule that resolves pins — blueprint 003.
- Taxonomy scan, `modules/`, `analyses/`, `okf:derived` two-zone fences —
  ROADMAP phase 6.
- Rewording, merging, re-arguing, or renumbering any migrated decision.
- Making `moor` gate on `okf-check` — 003, once it has a ferry rule.
- Raising or exempting the 110-line cap.
