---
name: review-angles
description: A recall-biased correctness checklist for the review pass that runs after the tests are green — the robustness angles unit scenarios never exercise (stale stored references, check-then-read races, unfamiliar filesystem layouts, ordering-sensitive state, durability load paths, derived-edge invalidation). Use when the user says "review-angles", "recall review", "correctness review", "robustness review", "what could break", runs a post-green review pass, or finishes a phase and wants the finder angles before calling it done.
---

# review-angles

## When to use
- A feature is **green** and you want the review pass that finds what tests
  don't — run after `/bdd`, before calling a phase done.
- A `/diagnose` post-mortem, or `/code-review`, wants concrete finder angles.
- **Why this exists (rule 13):** TDD green is *necessary, not sufficient*.
  Findings live in code with 100% passing, scenario-driven tests, because
  unit scenarios don't exercise thread death, lock contention, caller
  ordering, hostile filesystem layouts, or stale stored data. Run each angle
  as a separate finder; verify adversarially; fix red-test-first.

## The angles

Each is a question to interrogate the change with. One real finding per
angle is worth more than a green suite.

1. **Ordering-sensitive state — derive, don't relay (rule 6).** A return flag
   ("rebuilt") reported only by the call that rebuilds is lost the moment a
   second caller runs first. When consistency matters, cross-check the
   *artifacts themselves* (sidecar claims a build + graph has zero nodes →
   sidecar is stale) so no calling order can desync them.

2. **EAFP over check-then-read — TOCTOU (rule 10).** `is_file()` then
   `read_bytes()` is a crash window against git gc, branch deletes, log
   rotation. Read and catch the exception; the check just reopens the race.
   Applies *everywhere another process writes* the same path.

3. **"Is it a directory" is not "is it absent" (rule 11).** `.git` can be a
   *file* (worktrees, submodules: a `gitdir:` pointer). Treating an
   unfamiliar layout as "feature not present" silently selects the degraded
   path. Resolve the pointer, *then* fall back — and keep the fallback cheap
   (stat fingerprints, not content hashes).

4. **Write-time validation is a point-in-time fact, not an invariant
   (rule 15).** Validating a reference when written says nothing about the
   world when it is read — anything deletable out from under stored data
   eventually will be. Every reader of a long-lived reference must own the
   stale case explicitly: skip, mark, or resolve — never index unguarded.

5. **A file's load path is half its durability contract (rule 16).** Atomic
   saves aren't enough. Load must default keys absent from *older* files,
   raise loudly on corruption (a silent empty-default is worse than a crash —
   the next save persists the loss), and save must create its directory. Test
   load against files your current save never writes; the disk remembers
   every version you shipped.

6. **A stored derived edge is signing up to invalidate it (rule 19).** Moving
   a cross-entity fact from a read-time join to a stored edge looks like
   cleanup, but a `DETACH DELETE` of a changed entity severs edges pointing
   *into* it from neighbours that didn't change — staling them silently.
   Before caching a cross-entity fact *in* the entity, ask what invalidates
   it and whether the thing that changes can reach back to refresh it. If it
   can't, keep the derivation cheap and the source durable.

## How to run it
- One finder per angle, in parallel where you can — recall over precision.
- **Refute each candidate before emitting it** — the elenchus protocol in
  [refute.md](refute.md): default to refuted, attack from independent angles,
  accept only what survives.
- Fix each survivor red-test-first, like any other feature.

## See also
- [`../bdd/SKILL.md`](../bdd/SKILL.md) — the green pass these angles
  sit *after*; fixes land as new red-first scenarios here.
- [`../background-work/SKILL.md`](../background-work/SKILL.md) — the threading
  / lock / readiness angles, split out because they share a setup.
- [`../winnow/SKILL.md`](../winnow/SKILL.md) — the *structural* axis (what to
  delete) review-angles deliberately leaves alone; opposite concern.
