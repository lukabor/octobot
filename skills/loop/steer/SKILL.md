---
name: steer
description: Router over every octobot skill — which to reach for, when. The cure for user-invoked skills you forgot exist.
disable-model-invocation: true
---

# steer

Most octobot skills are user-invoked (zero context load) — this router
is the index you'd otherwise have to be. Ask "/steer <situation>" or
just read the table.

## The loop (the metaharness spine)

```
write-OKF → architect → blueprint → ferry → weave → review+verify → commit-atomic-jj → moor
```

| Situation | Skill |
|---|---|
| project has no `OKF/` knowledge folder, or wiki is stale | `/write-OKF` |
| starting a project / roadmap needs creating or revising | `/architect` |
| discussed work needs a justified, verifiable blueprint | `/blueprint` |
| feature too big for one session — map decisions | `/ferry` |
| a locked blueprint is ready to execute | `/weave` |
| ferry's blueprints locked — agent-orchestrated crossing | `/call-charon` |
| ferry delivered — close it out, consolidate the wiki | `/moor` |

## By situation

| Situation | Skill |
|---|---|
| task vague, no codebase to anchor on | `/grill-me` |
| plan needs stress-testing against the codebase | `/grill-with-docs` |
| build test-first (fires on "tdd"/"bdd" too) | `/bdd` |
| non-obvious bug, flake, regression, perf issue | `/diagnose` |
| jj conflict markers on screen | `/resolve-conflicts` |
| committing; splitting mixed changes | `/commit-atomic-jj` |
| post-green review — correctness angles | `/review-angles` |
| post-green review — diff vs its blueprint | `/review-blueprint` |
| harsh structural review, code-judo | `/nuke-review` |
| what can we delete (scoreboard) | `/winnow` |
| should this exist at all (Real/Good/Minimal) | `/sieve` |
| daemon threads, watchers, locks, readiness | `/harden-background-work` |
| module/interface/seam design vocabulary | `/design-codebase` |
| domain terms fuzzy; glossary/ADR work | `/model-domain` |
| spawning cavecrew subagents; builder needs a brief | `/spawn-cavecrew` |
| session ending on unfinished work | `/write-handoff` |
| new Python / R package / R analysis project | `/build-py-project` `/build-r-package` `/build-r-analysis` |
| add Docker to an existing project | `/containerize-project` |
| credentials into a container safely | `/add-docker-secrets` |
| full-loop language workflows (explicit ask only) | `/develop-python` `/develop-r` |
| README generation | `/write-readme` (`-py` variant for Python) |
| R style/idiom questions | `/style-r` |
| Copilot skills for another repo | `/add-copilot-project-skill` |
| terse replies for the session | `/talk-caveman` |
| author a new octobot skill | `/conjure-a-skill` |

## Rules of thumb
- Knowledge before plan, plan before blueprint, blueprint before code — enter the
  loop as far upstream as the situation allows.
- One skill at a time; each names its own hand-offs.
- New skill added to octobot → add its row here
  ([conjure-a-skill](../../productivity/conjure-a-skill/SKILL.md) step).
