# octobot — architecture

## Module map

One module per skill category; the interface of each skill is its
frontmatter `description` (routing) plus its SKILL.md body (procedure).

- **loop** (`skills/loop/`) — the metaharness spine: scribe-OKF
  (knowledge), architect (plan). Blueprint, ferry, implement, steer land
  per [ROADMAP.md](ROADMAP.md).
- **engineering** (`skills/engineering/`) — practice skills: bdd,
  diagnose, review axes (review-angles, nuke-review, winnow), sieve,
  vocabulary (codebase-design, domain-modeling), r-style, dev-* runners,
  write-readme*.
- **productivity** (`skills/productivity/`) — session mechanics:
  jj-atomic, handoff, grill-me, caveman, cavecrew-octobot,
  conjure-a-skill.
- **scaffold** (`skills/scaffold/`) — project generators: build-py-project,
  build-r-package, build-r-analysis, containerize-project,
  add-docker-secrets.

## Main flows

1. **The loop** — scribe-OKF → architect → blueprint → ferry → implement
   → review+verify → jj-atomic; OKF refreshed after implement
   (`skills/loop/`, diagram in `README.md`).
2. **Skill discovery** — Claude Code scans `~/.claude/skills/` one level
   deep; per-skill symlinks point into `skills/<category>/<name>/`
   (`README.md` §Install).
3. **Post-green review** — bdd "After green" hands to the review axes,
   fixes land red-test-first (`skills/engineering/bdd/SKILL.md`).

## Seams

- **Skill frontmatter** — `disable-model-invocation` flips a skill
  between description-routed and name-only invocation.
- **Progressive disclosure** — SKILL.md bodies point to topic-named
  sibling files; swapping a sibling changes behaviour without touching
  the router (`skills/productivity/conjure-a-skill/PRINCIPLES.md`).
- **Cross-links** — skills reference each other by relative path;
  category moves are renames across these links (grep before moving).
