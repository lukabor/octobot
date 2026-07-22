---
name: sound
description: Verify what a blueprint is about to rest on, before it locks — read the OKF pages the question touches, query the nostos MCP server when one is configured, then confirm both against live code and stamp `sounded: <date>`. Use when the user says "sound", "/sound", "sound this blueprint", "verify this before I lock it"; when blueprint reaches its lock step; or when you are about to act on a claim taken from an OKF page, a blueprint's Justification, or a cite that nothing has checked against the code. Not open-ended "how does this work" research — the trigger is an unverified claim about *this* repo, not a topic.
---

# sound

The recon pass that precedes a lock. A blueprint locks on a human's yes,
and that yes rests on knowledge nothing checked — sounding is what checks
it. Ports mattpocock's `research`, re-founded on the OKF.

## The spine

Three steps, in order, every run. Each feeds the next.

1. **OKF** — read the pages the question touches, starting at
   `OKF/index.md`. No `./OKF/` → say so in one line, name
   [`/write-OKF`](../write-OKF/SKILL.md), **stop**. Nothing else runs.
2. **nostos** — query the nostos MCP server when one is configured, via
   its `find` / `provenance_of` tools. Presence comes from the agent's
   MCP configuration, never from a filesystem path — never guess at a
   checkout. Absent → one line naming `nostos install`, run from the
   repo to be indexed, then continue.
3. **Live code** — confirm what steps 1 and 2 claimed against the files
   themselves. Either can be stale; this step is what makes the run
   worth its context. Cite `path:line` or `path:symbol` for every claim
   that survives. A claim with no internal owner — a third-party API, a
   spec — is followed to its primary source and cited. **Nothing else
   leaves the repo.**

## Two mouths

The same skill, two modes, and which one is decided by *how the run
started* — see [019](../../../OKF/decisions/019-recon-may-self-fire.md).

| Reached | Behaviour |
|---|---|
| **By name** — user, or `blueprint` at its lock step | refine the blueprint sounded; stamp `sounded: <date>` |
| **Self-fired** — routed by description | **report only; write nothing** |

The stamp is what a lock leans on, so a run nobody asked for may not
make it. A stamp a self-fire cannot make is a stamp a lock can trust.
Self-fired and the findings matter → say so and name `/sound`; the user
decides whether it becomes a write.

## The mark

`sounded: YYYY-MM-DD`, fourth frontmatter field, after `traces-to` (see
[blueprint-format.md](../blueprint/blueprint-format.md)). Sounding is a
precondition of lock: `okf-check` warns `<path>: locked without
sounded:` on a `locked` blueprint carrying no stamp. Warning, not error
— exit status stays 0.

**Idempotence.** Already stamped and no cited file changed since →
report `sounded <date>, unchanged` and stop. Re-sound anyway only when
the user asks, or when a cite no longer resolves.

## Output / done criteria

- Findings in the calling context: what held, what drifted, what has no
  owner — each with its cite.
- Reached by name → the blueprint refined and stamped.
- Self-fired → the report, and the working copy byte-identical.

## Guardrails
- **Never** write on a self-fire, in any form, however small.
- **Never** skip step 1 to reach step 3 — an unread OKF is what makes a
  recon into research.
- **Never** run in a subagent, background or otherwise: the findings are
  the deliverable and belong in the calling context.
- **Never** leave the repo past the no-internal-owner gap — general web
  research is upstream `research`, not this.
- **Never** edit a locked blueprint's Contract or Verify — a sounding
  that contradicts them supersedes, per
  [blueprint](../blueprint/SKILL.md)'s status discipline.

## See also
- [../blueprint/SKILL.md](../blueprint/SKILL.md) — the caller; sounding
  gates its lock step.
- [../write-OKF/SKILL.md](../write-OKF/SKILL.md) — no `OKF/` → there
  first; `okf-check` owns the warning.
- [../weave/SKILL.md](../weave/SKILL.md) — executes what a sounded
  blueprint locked.
