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
scribe-OKF → architect → blueprint → ferry → implement → review+verify → jj-atomic
```

| Situation | Skill |
|---|---|
| project has no `OKF/` knowledge folder, or wiki is stale | `/scribe-OKF` |
| starting a project / roadmap needs creating or revising | `/architect` |
| discussed work needs a justified, verifiable spec | `/blueprint` |
| feature too big for one session — map decisions | `/ferry` |
| a locked spec is ready to execute | `/implement` |

## By situation

| Situation | Skill |
|---|---|
| task vague, no codebase to anchor on | `/grill-me` |
| plan needs stress-testing against the codebase | `/grill-with-docs` |
| build test-first (fires on "tdd"/"bdd" too) | `/bdd` |
| non-obvious bug, flake, regression, perf issue | `/diagnose` |
| jj conflict markers on screen | `/resolve-conflicts` |
| committing; splitting mixed changes | `/jj-atomic` |
| post-green review — correctness angles | `/review-angles` |
| post-green review — diff vs its spec | `/review-blueprint` |
| harsh structural review, code-judo | `/nuke-review` |
| what can we delete (scoreboard) | `/winnow` |
| should this exist at all (Real/Good/Minimal) | `/sieve` |
| daemon threads, watchers, locks, readiness | `/background-work` |
| module/interface/seam design vocabulary | `/codebase-design` |
| domain terms fuzzy; glossary/ADR work | `/domain-modeling` |
| spawning cavecrew subagents; builder needs a brief | `/cavecrew-octobot` |
| session ending on unfinished work | `/handoff` |
| new Python / R package / R analysis project | `/build-py-project` `/build-r-package` `/build-r-analysis` |
| add Docker to an existing project | `/containerize-project` |
| credentials into a container safely | `/add-docker-secrets` |
| full-loop language workflows (explicit ask only) | `/dev-python` `/dev-r` |
| README generation | `/write-readme` (`-py` variant for Python) |
| R style/idiom questions | `/r-style` |
| Copilot skills for another repo | `/add-copilot-project-skill` |
| terse replies for the session | `/caveman` |
| author a new octobot skill | `/conjure-a-skill` |

## Rules of thumb
- Knowledge before plan, plan before spec, spec before code — enter the
  loop as far upstream as the situation allows.
- One skill at a time; each names its own hand-offs.
- New skill added to octobot → add its row here
  ([conjure-a-skill](../../productivity/conjure-a-skill/SKILL.md) step).
