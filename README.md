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
- **build-py-project** — uv + justfile + pyproject; Docker via
  `containerize-project`.
- **build-r-package** — renv + DESCRIPTION + testthat; Docker via
  `containerize-project`.
- **build-r-analysis** — renv + `_targets.R` + Quarto; Docker via
  `containerize-project`.
- **containerize-project** — three-stage Docker (base/production/
  development) for uv and renv projects: Dockerfile, compose,
  `.dockerignore`, justfile recipes. Hardened defaults (non-root
  production user, pinned uv, no source mount in prod). The `build-*`
  skills delegate their Docker step here; also works standalone on an
  existing repo.
- **add-docker-secrets** — build-time (BuildKit secret mounts) and
  runtime (`env_file` / compose secrets) credentials without leaking
  into image layers.

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
