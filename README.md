# octobot

Personal, reusable Claude Code skills — language-agnostic productivity
workflows that travel with you across every project.

Modeled on [mattpocock/skills](https://github.com/mattpocock/skills).

## Install

Claude Code discovers skills at `~/.claude/skills/<name>/SKILL.md` (flat,
one level deep — category subfolders are not scanned). Symlink each skill
individually; the `_concepts/` doc folder lives inside `skills/` and is
not symlinked separately (skills reach it via relative paths):

```bash
mkdir -p ~/.claude/skills
for s in ~/code/octobot/skills/*/*/; do
  ln -s "${s%/}" "$HOME/.claude/skills/$(basename "$s")"
done
```

Open any project, start Claude Code, and the skills below appear in the
skill list.

## Skills

### productivity
- **write-a-skill** — meta-skill that scaffolds new skills consistently.
- **handoff** — produce a structured handoff doc for a fresh session.
- **grill-me** — Socratic loop to remove ambiguity before implementing.
- **caveman** — terse-mode: no preamble, no summaries, code + one-line why.
- **jj-atomic** — atomic-commit discipline: `jj diff` → split → semantic
  message; docs / docstrings / READMEs ship in the same change.

### engineering
- **tdd-bdd** — strict red-green-refactor loop with BDD Given/When/Then
  scenarios as the unit of work.
- **diagnose** — six-phase bug hunt: feedback loop → reproduce →
  hypothesise → instrument → fix with regression test → cleanup.
- **grill-with-docs** — docs-anchored Socratic interview; updates
  `CONTEXT.md` inline, offers ADRs only on the three-of-three rule.
- **r-style** — Tidyverse + `box::use` + `dtplyr` standards with
  paired good/bad sibling docs (`box.md`, `tidyverse.md`, `dtplyr.md`).
- **dev-python** — orchestrate the full Python workflow (implement →
  lint → typecheck → test → commit). Explicit trigger only.
- **dev-r** — orchestrate the full R workflow; auto-detects package
  (`DESCRIPTION`) vs analysis (`_targets.R`).
- **write-readme-py** — generate `README.md` from `pyproject.toml` +
  `justfile`.

### scaffold
- **build-py-project** — uv + Docker (3-stage) + justfile + pyproject.
- **build-r-package** — renv + rocker/r-ver + DESCRIPTION + testthat.
- **build-r-analysis** — renv + rocker/verse + `_targets.R` + Quarto.

### _concepts
Shared reference docs under `skills/_concepts/` — not skills (no
`SKILL.md`), loaded on demand by skills that link them. The leading
underscore is the "not a skill" marker; the install loop above skips it
because it sits one level shallower than `skills/<category>/<name>/`.

- [`skills/_concepts/three-stage-dockerfile.md`](skills/_concepts/three-stage-dockerfile.md)
  — base / production / development Docker pattern used by every
  `scaffold/build-*` skill.

## Adding a skill

Run `/write-a-skill` in any project. It will ask for name, trigger, and
success criteria, then scaffold `skills/<category>/<name>/SKILL.md` in this
repo.

## Roadmap

Known gaps tracked here. Pick one off the list when you have a quiet
afternoon.

- **`handoff` needs a filled example.** The SKILL.md ships a template but
  no worked instance. Add `handoff/example.md` — a one-page fictional but
  realistic filled handoff doc — so a reader sees the format in motion
  (matches the strength of `jj-atomic/examples.md`).
- **`grill-me` needs a filled dialogue.** Add `grill-me/example.md` —
  a short Q-by-Q transcript on a vague task that resolves into a
  one-paragraph statement, mirroring `grill-with-docs/examples-r.md`.
  Makes the plan-only vs docs-anchored distinction obvious at a glance.
- **Python siblings for `tdd-bdd` / `diagnose`.** R has `tests-r.md`,
  `mocking-r.md`, `feedback-loops-r.md`, etc. Python equivalents
  (`tests-py.md`, `mocking-py.md`, `feedback-loops-py.md`) are
  acknowledged as missing in [`dev-python/SKILL.md`](skills/engineering/dev-python/SKILL.md).
- **`write-readme-r`.** The R counterpart to `write-readme-py` (read
  `DESCRIPTION` for packages and `_targets.R` + `index.qmd` for
  analyses) is noted as out of scope in
  [`write-readme-py/SKILL.md`](skills/engineering/write-readme-py/SKILL.md).
