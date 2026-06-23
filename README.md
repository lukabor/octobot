# octobot

<table>
<tr>
<td width="40%" align="center">
  <img src="assets/octobot.png" alt="octobot logo" width="200"/>
  <h3>octobot</h3>
  <p>Personal, reusable Claude Code skills — language-agnostic productivity workflows that travel with you across every project.</p>
</td>
<td width="60%">

## Table of Contents
- [Install](#install)
- [Skills](#skills)
- [Workflows](#workflows)
- [Adding a skill](#adding-a-skill)
- [Roadmap](#roadmap)
- [License](#license)

</td>
</tr>
</table>

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
- **conjure-a-skill** — meta-skill that scaffolds new skills consistently.
- **handoff** — produce a structured handoff doc for a fresh session.
- **grill-me** — Socratic loop to remove ambiguity before implementing.
- **plan-project** — research-backed Socratic interview that kicks off a
  greenfield project; writes `docs/Roadmap.md` with phased, verifiable plan.
  Pairs with `update-project`.
- **update-project** — revise `docs/Roadmap.md` as the project teaches you
  things; mark phases verified, supersede locked decisions, keep `CONTEXT.md`
  in sync. Pairs with `plan-project`.
- **caveman** — terse-mode: no preamble, no summaries, code + one-line why.
- **cavecrew-octobot** — how to invoke the plugin `caveman:cavecrew-*` agents
  (investigator / builder / reviewer) without the agent-type error; octobot
  defaults (`jj diff` review, `jj-atomic` commit).
- **jj-atomic** — atomic-commit discipline: `jj diff` → split → semantic
  message; docs / docstrings / READMEs ship in the same change.

### engineering
- **sieve** — Socratic Real / Good / Minimal gate; burden on *keeping*, not
  cutting. Fires at the seal boundary (build, prune, analysis). Pairs with
  `winnow`.
- **winnow** — blunt after-the-fact debloat audit; `delete/stdlib/native/
  yagni/shrink` tags, `net: -N lines`. Only ever removes. Pairs with `sieve`.
- **background-work** — rules for daemon threads, trigger loops, shared
  locks, readiness surfaces — the failures a green unit suite misses.
- **review-angles** — recall-biased correctness checklist for the post-green
  review pass (stale refs, TOCTOU, ordering state, durability, invalidation).
- **nuke-review** — exceptionally strict structural-quality review for code
  judo moves; ported from cursor/plugins thermo-nuclear-code-quality-review.
  Pairs with `review-angles` (correctness) and `winnow` (debloat) as the
  three post-green review axes. User-invoked.
- **bdd** — strict red-green-refactor loop with BDD Given/When/Then
  scenarios as the unit of work.
- **diagnose** — six-phase bug hunt: feedback loop → reproduce →
  hypothesise → instrument → fix with regression test → cleanup.
- **grill-with-docs** — user-invoked router that runs `grill-me` using
  `domain-modeling` on an existing codebase.
- **domain-modeling** — actively build / sharpen a project's domain
  model — challenge terms, update `CONTEXT.md` inline, offer ADRs only
  on the three-of-three rule.
- **codebase-design** — shared vocabulary for designing deep modules
  (module, interface, seam, adapter, depth, leverage, locality);
  `DEEPENING.md` for dependency-aware seam strategy, `DESIGN-IT-TWICE.md`
  for parallel-sub-agent interface exploration.
- **r-style** — Tidyverse + `box::use` + `dtplyr` standards with
  paired good/bad sibling docs (`box.md`, `tidyverse.md`, `dtplyr.md`).
- **dev-python** — orchestrate the full Python workflow (implement →
  lint → typecheck → test → commit). Explicit trigger only.
- **dev-r** — orchestrate the full R workflow; auto-detects package
  (`DESCRIPTION`) vs analysis (`_targets.R`).
- **write-readme-py** — generate `README.md` from `pyproject.toml` +
  `justfile`.
- **add-copilot-project-skill** — scaffold a project-specific skill set for
  GitHub Copilot in the Claude Code SKILLS structure; single-sourced from the
  repo's own docs, backed by a mechanical validator. Tuned for config-driven
  pipelines (e.g. R `{targets}` projects).

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

## Workflows

Common ways the skills chain together. Each recipe is a *sequence*, not a
script — read the relevant SKILL.md as you enter each step.

### Project lifecycle
- **Greenfield project** — `/plan-project` (Socratic kickoff → `docs/Roadmap.md`)
  → `/build-py-project` | `/build-r-package` | `/build-r-analysis` (scaffold)
  → feature loops below → `/update-project` (revise Roadmap as you learn).
- **Feature on an existing codebase** — `/grill-with-docs` if the design needs
  pinning → `/bdd` (red-green-refactor) → post-green review (next recipe)
  → `/jj-atomic` (seal).
- **Bug hunt** — `/diagnose` (six phases; hands to `/bdd` at phase 5 for the
  regression test) → post-green review → `/jj-atomic`.

### Post-green review (the three axes)
- `/review-angles` — correctness / robustness (stale refs, TOCTOU, ordering,
  durability). Run *first* — these are the silent killers.
- `/nuke-review` — structural quality / code judo. Pushes for code that
  *deletes* moving pieces, not rearranges them. User-invoked.
- `/winnow` — mechanical debloat with a `net: −N lines` scoreboard.
- Spawn any of the three as a sub-agent via `/cavecrew-octobot`
  (the `caveman:cavecrew-reviewer` invocation cheatsheet).

### Architecture & vocabulary
- **Design conversation** — `/codebase-design` (solution-structure vocab:
  module / interface / seam / adapter / depth) + `/domain-modeling`
  (problem-domain vocab: `CONTEXT.md`, ADRs on the three-of-three rule).
- **Stress-test a plan against the codebase** — `/grill-with-docs`
  (Socratic interview against `CONTEXT.md` and `docs/adr/`).

### Meta
- **Author a new skill in this repo** — `/conjure-a-skill` → `/jj-atomic`.
- **End of session, fresh context next time** — `/handoff`.

### Orthogonal modes
These overlay any workflow above:
- **Language harnesses** — `/dev-r` or `/dev-python` orchestrate the full
  per-language loop (implement → lint → test → commit). Explicit trigger
  only; don't auto-invoke for individual tasks.
- **Intensity** — `/caveman` switches the session into terse mode
  (no preamble, no summaries). `sieve` and others document `lite / full / ultra`.
- **Agent dispatch** — `/cavecrew-octobot` is the "how to call
  `caveman:cavecrew-{investigator,builder,reviewer}` in this repo without
  the agent-type error" cheatsheet.

## Adding a skill

Run `/conjure-a-skill` in any project. It will ask for name, trigger, and
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
  one-paragraph statement, mirroring `domain-modeling/examples-r.md`.
  Makes the plan-only vs docs-anchored distinction obvious at a glance.
- **Python siblings for `bdd` / `diagnose`.** R has `tests-r.md`,
  `mocking-r.md`, `feedback-loops-r.md`, etc. Python equivalents
  (`tests-py.md`, `mocking-py.md`, `feedback-loops-py.md`) are
  acknowledged as missing in [`dev-python/SKILL.md`](skills/engineering/dev-python/SKILL.md).
- **`write-readme-r`.** The R counterpart to `write-readme-py` (read
  `DESCRIPTION` for packages and `_targets.R` + `index.qmd` for
  analyses) is noted as out of scope in
  [`write-readme-py/SKILL.md`](skills/engineering/write-readme-py/SKILL.md).

### Socratic spine (toward a harness)

The library is being organized around a Socratic lifecycle —
**Question** (grill-me, grill-with-docs, plan-project) → **Gate** (sieve) →
**Build** (bdd) → **Refute** (review-angles, winnow, refute.md) →
**Seal** (jj-atomic). Done so far: the three-sieve spine in `CLAUDE.md §2`
and the shared `refute.md` elenchus doctrine. Remaining, **in order — don't
build the harness before the leaves are proven by real use**:

- **Generalize `dev-python` / `dev-r` into one Socratic harness.** Both are
  already proto-harnesses (implement → lint → test → commit). Extract one
  language-agnostic loop — *grill → plan → per-slice(bdd red/green → sieve at
  seal → jj-atomic) → review-angles + winnow → handoff* — with `dev-python` /
  `dev-r` as the language-flavored leaves. This is the harness target.
- **Shared `## Intensity` convention.** `caveman` and `sieve` both have
  lite/full/ultra; standardize a one-line intensity block so the harness can
  run the whole spine at one setting (ultra = aggressive end-to-end).
- **Recategorize skills by lifecycle phase** (`question/gate/build/refute/
  seal/`) — *only if* the harness reads categories to sequence. Claude Code
  doesn't scan category dirs, so until the harness consumes them this is
  motion, not progress. Defer until the harness exists.

## License

octobot is licensed under the Apache License 2.0.

You are free to:
- Use octobot for any purpose (commercial or non-commercial)
- Modify and distribute the code
- Use it in proprietary software
- Patent protection included

### Requirements:
- Include the LICENSE file
- Preserve copyright notices
- State any changes you made

### Attribution
When using octobot, attribution such as the following is appreciated:

In your project:
> Powered by octobot by Lukasz Boryn

In academic papers:
```bibtex
@software{octobot,
  author = {Boryn, Lukasz},
  title = {octobot: personal, reusable Claude Code skills},
  year = {2026},
  url = {https://github.com/lukabor/octobot}
}
```

Full license: See [LICENSE](LICENSE).
