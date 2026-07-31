---
type: Architecture
purpose: Map the skill categories, the seams between them, and the flows that cross them.
answers:
  - "Which module owns a given skill, and where are the seams?"
cites:
  - skills/loop
  - skills/engineering/bdd/SKILL.md
  - skills/productivity/conjure-a-skill/principles.md
status: live
---

# octobot — architecture

## Module map

One module per skill category; the interface of each skill is its
frontmatter `description` (routing) plus its SKILL.md body (procedure).

- **loop** (`skills/loop/`) — the metaharness spine: write-OKF
  (knowledge), chart (plan), blueprint, ferry, rig, steer.
- **engineering** (`skills/engineering/`) — practice skills: bdd,
  diagnose, review axes (review-angles, nuke-review, winnow), sieve,
  vocabulary (design-codebase, model-domain), style-r, dev-* runners,
  write-readme*.
- **productivity** (`skills/productivity/`) — session mechanics:
  commit-atomic-jj, handoff, grill-me, caveman, spawn-cavecrew,
  conjure-a-skill.
- **scaffold** (`skills/scaffold/`) — project generators: build-py-project,
  build-r-package, build-r-analysis, containerize-project,
  add-docker-secrets.

## Main flows

1. **The loop** — the metaharness spine, canonically rendered here
   (`skills/loop/`). Two byte-copies: `README.md` §loop, `steer`
   §The loop.

```
substrate (rare)  write-OKF — scaffold, or refresh when stale
                      ↓
per request       chart — a phase only for an arc over >1 blueprint
                      ↓
                 know what to do?
        ┌──── yes ────┴──── no ────┐
  blueprint → sound          ferry — decisions + blocking edges,
    → rig                    resolve one per sitting
    (rig closes it)                  ↓
                             blueprint per cleared decision → sound
                                     ↓
                             1 left → rig
                             N left → call-charon (agent per blueprint)
                                     ↓
                                   moor

rig = bdd → 4-axis review → Verify → commit-atomic-jj → close (OKF refresh)
```

2. **Skill discovery** — Claude Code scans `~/.claude/skills/` one level
   deep; per-skill symlinks point into `skills/<category>/<name>/`
   (`README.md` §Install).
3. **Post-green review** — bdd "After green" hands to the review axes,
   fixes land red-test-first (`skills/engineering/bdd/SKILL.md`).

## Seams

- **Skill frontmatter** — `disable-model-invocation` flips a skill
  between description-routed and name-only invocation. Orchestrators and
  rituals carry it; a read-only recon whose trigger is a detectable state
  may go without ([decisions/019](decisions/019-recon-may-self-fire.md)).
- **Progressive disclosure** — SKILL.md bodies point to topic-named
  sibling files; swapping a sibling changes behaviour without touching
  the router (`skills/productivity/conjure-a-skill/principles.md`).
- **Cross-links** — skills reference each other by relative path;
  category moves are renames across these links (grep before moving).
