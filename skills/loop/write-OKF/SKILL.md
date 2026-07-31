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
2. **Propose the page plan, don't assume one** — run
   `scripts/okf-scan <repo-root>`, show the candidate lines, and let the
   user cut, rename, and add the spine pages no tree walk can see. What
   survives becomes `index.md`, from [templates/](templates/). Contract:
   [taxonomy-scan.md](taxonomy-scan.md).
3. **Materialise what the plan lists *and* a producer can fill.** A page
   is listed when planned, written when its producer has something to
   say: SUMMARY from an existing README, ARCHITECTURE bones from the
   directory tree and manifests, while ROADMAP and CONTEXT stay
   listed-not-written until [architect](../architect/SKILL.md) /
   model-domain produce them. **Never invent facts** — an empty section
   with a TODO beats a fabricated architecture claim, and an unwritten
   page beats an empty one.
4. Wire `AGENTS.md`: insert the block from
   [agents-md-hook.md](agents-md-hook.md) (create the file if absent;
   append if it exists — never overwrite prose).
5. Migrate legacy artifacts *with consent*: root `CONTEXT.md` →
   `OKF/CONTEXT.md`, `docs/Roadmap.md` → `OKF/ROADMAP.md`,
   `docs/adr/` → `OKF/decisions/`. Offer, show the move, wait for yes.

## Refresh mode
1. **Diff wiki against reality**: code and manifests on disk, `jj log`
   (or `git log`) since the last scribe commit, session learnings.
   **Rescan the page plan** — `scripts/okf-scan <repo-root>`, sorted
   against `index.md`'s `modules/`/`analyses/` lines into new / standing
   / unwarranted, and locked by the user as at scaffold; nothing is added
   or removed unasked. An unwarranted page is deleted only when wholly
   derived, else superseded per step 3. Contract:
   [taxonomy-scan.md](taxonomy-scan.md).
2. **Smallest edit per delta** — never rewrite a page wholesale; a page
   over its cap splits per [split-page.md](split-page.md), alone.
3. **Supersede, don't delete**: outdated claims get struck with a
   pointer to the replacement, mirroring
   [architect/revise.md](../architect/revise.md) discipline.
4. Every ARCHITECTURE.md claim must be **traceable to a file** — cite
   `path:symbol` when a symbol carries the claim, `path` or `path:line`
   otherwise; grammar in [okf-layout.md](okf-layout.md). A claim you
   can't cite doesn't go in.
5. Keep `index.md` complete: every page and every `blueprints/` entry
   listed, one line each (`NNN — title — status`); every ferry one line,
   in the shape its state calls for per
   [okf-layout.md](okf-layout.md).
6. **Resolve the pins**: for each moored `ferries/<topic>.md`, check its
   `sealed:` change id against the repo and report DRIFT if it is gone.
   `okf-check` validates the pin's shape; only refresh can resolve it.
   DRIFT stops at pins — a cite needs no repo, so `okf-check` owns cite
   drift whole.
7. **Regenerate inside the fences only**: a page's `okf:derived` region
   is rewritten wholesale, and every byte outside it is judgement zone —
   append or supersede, never scan-edit. An unfenced page is all
   judgement.

## Output / done criteria
- **`scripts/okf-check <okf-dir>`, `render-check <repo-root>` and
  `link-check <repo-root>` run and output pasted**, exiting 0 — invoke
  from this skill's own base dir, octobot-only. Claims are not gates.
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
- **Never** exceed a page's cap — split per [split-page.md](split-page.md).
- **Never** move legacy files without explicit consent.

## See also
- [../architect/SKILL.md](../architect/SKILL.md) — writes ROADMAP.md.
- [../blueprint/SKILL.md](../blueprint/SKILL.md) — writes blueprints/.
- [../../engineering/model-domain/SKILL.md](../../engineering/model-domain/SKILL.md)
  — owns CONTEXT.md content; scribe only places it.
