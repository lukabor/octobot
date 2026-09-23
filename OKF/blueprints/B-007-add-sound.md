---
type: Blueprint
status: implemented
traces-to: ROADMAP.md phase 9; decision 019
sounded: 2026-07-22
---

# 007 — add sound, the recon that precedes a lock

## Justification

A blueprint locks on a human's yes, and that yes rests on knowledge
nothing checked. `README.md:74` already claims something this repo is
about to stop doing — the kind of drift a lock cannot see. Phase 9 in
[ROADMAP.md](../ROADMAP.md) buys the check;
[019](../decisions/R-019-recon-may-self-fire.md) says who may run it
unasked.

This blueprint is itself the first sounding — hence the stamp, and
hence `README.md:74` in the seams. Ports mattpocock's `research`,
re-founded on the OKF.

## Contract

**The spine.** Three steps, in order, every run:

1. **OKF** — read the pages the question touches. No `./OKF/` → say so
   in one line, name `/write-OKF`, stop. Nothing else runs — which is
   also what keeps a wrong self-fire costing two lines, not a recon.
2. **nostos** — query the nostos MCP server when one is configured, via
   its `find` / `provenance_of` tools. Presence comes from the agent's
   MCP configuration, never from a filesystem path. Absent → one line
   naming `nostos install`, run from the repo to be indexed, then
   continue.
3. **Live code** — confirm what steps 1 and 2 claimed against the files
   themselves. Either can be stale; this step is what makes the run
   worth its context. A claim with no internal owner — a third-party
   API, a spec — is followed to its primary source and cited. Nothing
   else leaves the repo.

**Two mouths.** Reached **by name** — by the user or by `blueprint` —
sound refines the blueprint it sounded and stamps `sounded: <date>`.
**Self-fired it reports and writes nothing**, per 019: the stamp is what
a lock leans on, so a run nobody asked for may not make it.

**Idempotence.** Already stamped and no cited file changed since →
report `sounded <date>, unchanged` and stop.

**Triggers are states, not topics.** The description routes on
*blueprint*, *OKF*, *lock*, *cite* — nouns absent from repos where sound
does not belong. "Researching how code works" is the failure shape.

**Runs inline**, never in a subagent: the findings are the deliverable
and belong in the calling context.

**The mark.** `sounded: YYYY-MM-DD`, fourth field in a blueprint's
frontmatter after `traces-to`. Sounding is a precondition of lock.
`okf-check` gains one warning — `<path>: locked without sounded:` —
raised only at `status: locked`. Never at `draft` (not-yet-sounded is
correct there) nor at `implemented` (noise, and it would retro-flag
002–006). Warning, not error: exit status stays 0.

## Seams touched

- `skills/loop/sound/SKILL.md` — new; the router. Plus its
  `~/.claude/skills/sound` symlink, since discovery is one level deep.
- `skills/loop/blueprint/SKILL.md` — a sound step between Process 3 and
  4; the precondition in *Status discipline* (`:43-47`).
- `skills/loop/blueprint/blueprint-format.md` — `sounded:` in the
  frontmatter template.
- `skills/loop/write-OKF/scripts/okf-check` — the gate, above the
  blueprint escape at `:213`.
- `skills/loop/steer/SKILL.md` — one row in the loop table.
- `README.md:74` — "All loop skills are user-invoked" is now false.
- `OKF/ARCHITECTURE.md` — invocation seam bullet gains the rule, so
  019's cite lands on it.

## Verify

```sh
tmp=$(mktemp -d) && cp -r OKF "$tmp/OKF"
f="$tmp/OKF/blueprints/B-006-rescan-the-page-plan-on-refresh.md"
for s in draft locked implemented; do
  sed -i "s/^status: .*/status: $s/" "$f"
  printf '%s: %s\n' "$s" \
    "$(skills/loop/write-OKF/scripts/okf-check "$tmp/OKF" \
       | grep -c 'locked without sounded')"
done
skills/loop/write-OKF/scripts/okf-check OKF/
```

Expect `draft: 0` `locked: 1` `implemented: 0`, then `0 error(s)` live.

Four session checks the script cannot make, run once each:

1. A repo with no `OKF/` — sound stops and names `/write-OKF`.
   ✅ 2026-07-22 (no-OKF fixture — one line naming `/write-OKF` after a
   single directory listing, nothing else run)
2. A repo with no nostos MCP — one line naming `nostos install`, then
   the run continues.
   ✅ 2026-07-22 (the 001 sounding — one line, the run continued)
3. A self-fired run leaves its blueprint byte-identical (`jj diff`).
   ⏳ pending
4. Fresh session, repo with no `OKF/`, ten ordinary code questions —
   sound fires zero times.
   ✅ 2026-07-22 (no-OKF fixture, fresh session — zero self-fires over ten
   ordinary code questions)

## Out of scope

- A new OKF page type — sound writes only into the blueprint it sounded.
- Writing on a self-fire, in any form, however small.
- Subagents, background or otherwise.
- Web research past the no-internal-owner gap — upstream `research`.
- Retro-sounding 001–006, and any change to `write-OKF`.
- Wiring nostos into octobot; the live-nostos leg is tested elsewhere.
