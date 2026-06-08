# octobot

Personal, reusable Claude Code skills — language-agnostic productivity
workflows that travel with you across every project.

Modeled on [mattpocock/skills](https://github.com/mattpocock/skills).

## Install

Claude Code discovers skills at `~/.claude/skills/<name>/SKILL.md` (flat,
one level deep — category subfolders are not scanned). Symlink each skill
individually:

```bash
mkdir -p ~/.claude/skills
for s in ~/code/octobot/skills/*/*/; do
  ln -s "${s%/}" "$HOME/.claude/skills/$(basename "$s")"
done
# shared concept docs (referenced by skills via ../_concepts/...)
ln -s ~/code/octobot/concepts ~/.claude/skills/_concepts
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

### concepts
Shared reference docs (not skills; loaded on demand by SKILLs that link them):
- [`concepts/three-stage-dockerfile.md`](concepts/three-stage-dockerfile.md)
  — base / production / development Docker pattern used by every
  `scaffold/build-*` skill.

## Adding a skill

Run `/write-a-skill` in any project. It will ask for name, trigger, and
success criteria, then scaffold `skills/<category>/<name>/SKILL.md` in this
repo.
