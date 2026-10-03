---
name: init-octobot
description: Bootstrap octobot's framework files (AGENTS.md, optional CLAUDE.md, a bare OKF/, README.md) into any repo — greenfield or ongoing — that never ran octobot before.
disable-model-invocation: true
---

# init-octobot

Fixes the "octobot dropped into a repo with no ROADMAP, no OKF, no
AGENTS.md, no CLAUDE.md" gap. Writes everything itself — never chains to
another user-invoked skill mid-run, since write-okf, `/chart`, and
write-readme each gate their own writes on explicit user confirmation
that a silent sub-step would bypass.

## When to use
- User says "init octobot", "/init-octobot", "bootstrap octobot here",
  "set up octobot in this repo".
- A repo has none of `AGENTS.md`, `OKF/`, `OKF/ROADMAP.md` and the user
  wants octobot's framework in place.

## Process
1. **Scan** — run `scripts/repo-scan <repo-root>`. Two line kinds:
   - `LEGACY <path>` — `CONTEXT.md`, `docs/Roadmap.md`, or `docs/adr`
     exists at root.
   - `CONVENTION <bullet> — <path>` — a language/lint/test signal.
2. **OKF/ROADMAP.md**:
   - Any `LEGACY` line → **skip** `OKF/` and `ROADMAP.md` entirely. Tell
     the user to run `/write-okf` (offers the migration these files need)
     then `/chart` (produces a real roadmap). Do not scaffold in this
     branch — write-okf's Scaffold-only migration step never fires once
     `OKF/` already exists, so pre-creating it here would forfeit that
     path.
   - No `LEGACY` line → materialize `OKF/index.md` and `OKF/ROADMAP.md`
     from write-okf's own
     [`templates/index.md.tpl`](../../loop/write-okf/templates/index.md.tpl)
     and
     [`templates/ROADMAP.md.tpl`](../../loop/write-okf/templates/ROADMAP.md.tpl)
     verbatim (`<project>` substituted) — reuse, don't reinvent. Both stay
     all-`TODO`, so `/chart`'s "absent or all-TODO → Greenfield" mode
     detection still fires correctly later. `OKF/` now exists, so a
     future `/write-okf` run takes Refresh mode — its rescan step (page
     plan via `okf-scan`, sorted against the still-empty `index.md`) is
     built to reconcile exactly this bare state; only the Scaffold-only
     migration/hook-wiring steps are permanently skipped, not full
     population.
3. **AGENTS.md** — create, assembling in order (never duplicate the
   source prose into this repo's copy — insert each block verbatim,
   substituting `<project>` with the repo's directory name in every
   block, not just the OKF templates):
   1. Knowledge + Behavioral guardrails, from write-okf's
      [`agents-md-hook.md`](../../loop/write-okf/agents-md-hook.md).
   2. Simplicity & rigor, from
      [`simplicity-block.md`](simplicity-block.md) — CLAUDE.md §1–4's
      union-minus-overlap with the hook block above; no information
      lost, nothing restated.
   3. `## Repo conventions — <dir-name>`, from
      [`AGENTS.md.tpl`](AGENTS.md.tpl) — empty repo: leave the
      fill-in-later placeholder. Non-empty: turn each confirmed
      `CONVENTION` line into one short bullet; anything needing more than
      one line goes to `OKF/decisions/` instead, linked from the bullet
      (skip if step 2 skipped `OKF/`).
   - **Confirm** every `CONVENTION` bullet with the user before writing —
     the scan proposes, it doesn't decide.
4. **CLAUDE.md** — ask first; only write it if the user opts in, from
   [`CLAUDE.md.tpl`](CLAUDE.md.tpl) (a pointer to AGENTS.md, never a
   duplicate of its content).
5. **README.md** — absent → write
   [`README.md.tpl`](README.md.tpl)'s minimal placeholder. Present →
   skip untouched; a stub over real content is a regression, not a
   convenience.
6. **.gitignore** — `write-handoff` defaults to `./HANDOFF.md` in any
   octobot repo; ensure it's ignored. No `.gitignore` → create one with
   just `HANDOFF.md`. Existing `.gitignore` missing the line → append
   it. Already present → skip untouched.
7. **Existing AGENTS.md/CLAUDE.md** in the target repo — propose a merge
   reshaping the existing prose into the step-3/4 structure; show the
   diff; write only after the user confirms.
8. **Close out** — list what was written and skipped, and suggest next
   steps: `/write-okf`, `/chart`, `/write-readme` — whichever apply.

## Output / done criteria
- Every file in Process is either written (diff shown) or explicitly
  skipped with a stated reason.
- No `CONVENTION` bullet lands unconfirmed; no existing file is
  overwritten without a shown diff and a yes.
- Nothing committed — hand to `/commit-atomic-jj`
  (`feat(init): bootstrap octobot framework files`, or `chore(init):` if
  the repo takes chore-scoped infra commits).

## Guardrails
- **Never** invoke write-okf, `/chart`, or write-readme as a sub-step —
  point the user at them instead.
- **Never** fabricate a `CONVENTION` bullet without a `repo-scan` line
  behind it.
- **Never** overwrite an existing README.md, AGENTS.md, or CLAUDE.md
  without a shown diff and explicit confirmation.
- **Never** scaffold `OKF/` or `ROADMAP.md` when a `LEGACY` line fired.

## See also
- `/write-okf` — full OKF scaffold/refresh, legacy migration, AGENTS.md
  hook-wiring on a repo with no prior `OKF/`.
- `/chart` — writes real `OKF/ROADMAP.md` content.
- `/write-readme` — full README generation by ecosystem detection.
- `/commit-atomic-jj` — the commit step this skill hands off to.
