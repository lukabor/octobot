---
name: write-OKF
description: Scaffold or refresh a project's OKF (open-knowledge-format) wiki — the agent-first knowledge folder at ./OKF/ that AGENTS.md points every agent at before it touches code.
disable-model-invocation: true
---

# write-OKF

The OKF is a Karpathy-LLM-wiki-style knowledge substrate: dense synthesis,
not raw dumps; agents read it *before* code; every page inspectable,
versioned, agent-maintained. Layout and Google-OKF-v0.1 conformance
contract: [okf-layout.md](okf-layout.md).

## When to use
- User says "scribe OKF", "/write-OKF", "set up the knowledge folder",
  "refresh the wiki".
- Another loop skill ([architect](../architect/SKILL.md),
  [weave](../weave/SKILL.md)) requires an `OKF/` that is absent
  or stale.

## Mode detection
| State | Mode |
|---|---|
| no `./OKF/` | **Scaffold** |
| `./OKF/` exists | **Refresh** |

## Scaffold mode
1. **Confirm the first write** — creating `OKF/` in a repo is a new
   convention; get a yes before writing anything.
2. Materialise the skeleton from [templates/](templates/) — headers,
   `type` frontmatter, and `TODO(scribe)` markers only. **Never invent
   facts**: an empty section with a TODO beats a fabricated architecture
   claim.
3. Fill only what is *derivable from disk right now*: SUMMARY from an
   existing README, ARCHITECTURE bones from the directory tree and
   manifests, ROADMAP/CONTEXT stay TODO until
   [architect](../architect/SKILL.md) / model-domain produce them.
4. Wire `AGENTS.md`: insert the block from
   [agents-md-hook.md](agents-md-hook.md) (create the file if absent;
   append if it exists — never overwrite prose).
5. Migrate legacy artifacts *with consent*: root `CONTEXT.md` →
   `OKF/CONTEXT.md`, `docs/Roadmap.md` → `OKF/ROADMAP.md`,
   `docs/adr/` → `OKF/adr/`. Offer, show the move, wait for yes.

## Refresh mode
1. **Diff wiki against reality**: code and manifests on disk, `jj log`
   (or `git log`) since the last scribe commit, session learnings.
2. **Smallest edit per delta** — never rewrite a page wholesale.
3. **Supersede, don't delete**: outdated claims get struck with a
   pointer to the replacement, mirroring
   [architect/revise.md](../architect/revise.md) discipline.
4. Every ARCHITECTURE.md claim must be **traceable to a file** — cite
   `path` (or `path:line`) inline. A claim you can't cite doesn't go in.
5. Keep `index.md` complete: every page and every `blueprints/` entry
   listed, one line each (`NNN — title — status`); every ferry one line
   (`<topic> — n/m resolved → MAP.md`) — decisions stay in MAP.md only.

## Output / done criteria
- `OKF/` matches [okf-layout.md](okf-layout.md) including its
  conformance block; `index.md` links every page that exists.
- `AGENTS.md` carries the hook block.
- Scaffold: no fabricated content — unfillable sections carry
  `TODO(scribe)`.
- Refresh: every edit traces to a named delta (commit, file, or session
  fact); superseded claims remain visible.
- Nothing committed — hand to
  [commit-atomic-jj](../../productivity/commit-atomic-jj/SKILL.md)
  (`docs(okf): ...`).

## Guardrails
- **Never** fabricate architecture, dependencies, or domain terms.
- **Never** duplicate content between pages — one fact, one home,
  cross-link the rest.
- **Never** write raw logs, transcripts, or scratch into OKF — durable
  synthesis only.
- **Never** exceed 110 lines per page — split and index instead.
- **Never** move legacy files without explicit consent.

## See also
- [../architect/SKILL.md](../architect/SKILL.md) — writes ROADMAP.md.
- [../blueprint/SKILL.md](../blueprint/SKILL.md) — writes blueprints/.
- [../../engineering/model-domain/SKILL.md](../../engineering/model-domain/SKILL.md)
  — owns CONTEXT.md content; scribe only places it.
