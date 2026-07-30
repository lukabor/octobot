---
name: call-charon
description: Carry an arrived ferry's blueprints across via agents — one worktree builder per blueprint, a four-axis review flotilla, an orchestrator-run Verify gate, passage logged in MAP.md, moor at the far shore.
disable-model-invocation: true
---

# call-charon

The execution counterpart of [ferry](../ferry/SKILL.md): ferry resolves
one *decision* per sitting; Charon delivers *blueprints* — each built
by its own agent, reviewed by a fresh-context flotilla, sealed only by
the orchestrator. The main session never implements. The ferry's
`MAP.md` is the passage log that crosses the session boundary — Charon
holds no state in his head.

## When to use
- User says "call charon", "/call-charon", "implement the ferry",
  "drive the ferry home", "next blueprint".
- A [ferry](../ferry/SKILL.md) has arrived (decisions resolved,
  blueprints locked) and implementation spans multiple blueprints.
- One blueprint, no orchestration worth the cost → plain
  [weave](../weave/SKILL.md).

## Preconditions (check, don't assume)
- `OKF/ferries/<topic>/MAP.md` exists; every decision resolved. Open
  decisions → back to ferry; this is a crossing, not a mapping.
- The spawned blueprints are `locked` or beyond
  (`grep -r "^status:" OKF/blueprints/`); a needed one still `draft` →
  back to [blueprint](../blueprint/SKILL.md) for the user's lock.

## Process
1. **ORIENT** — read `MAP.md` + the statuses of every blueprint it
   names. Detect the VCS mode once: `[ -d .jj ]` → jj, else git;
   record it in the Passage header. First run: add a `## Passage`
   section to `MAP.md`, one line per blueprint
   ([crossing-format.md](crossing-format.md)). Edges come
   from the decisions' `blocked-by` and the blueprints' `traces-to`;
   no edge, no ordering claim (ferry's rule).
2. **PICK** — the next `locked` blueprint whose blocked-by set is all
   implemented. None unblocked → record why in Passage, report
   blocked, stop.
3. **DISPATCH** — isolation and builder brief per crossing-format.md
   §isolation and §builder-brief; both branch on the mode recorded at
   ORIENT. `cavecrew-builder` refuses this scope — wrong tool. Serial
   by default; parallel builders only when blocked-by frontiers are
   clear AND Seams-touched are disjoint.
4. **REVIEW FLOTILLA** — builder done → spawn read-only
   general-purpose reviewers in parallel, one per axis:
   review-blueprint + review-angles **always**; nuke-review + winnow
   when the diff is non-trivial (Charon's call — record it). Briefs
   per crossing-format.md §reviewer-brief. The builder never
   self-reviews; the orchestrator never reviews inline.
5. **MERGE + FIX** — Charon dedupes findings, arbitrates conflicts
   (sieve's always-pass exceptions win: validation, data-loss
   handling, security), and sends **one** consolidated brief via
   SendMessage to the *same* builder — context intact, no cold
   restart. Max 2 fix rounds, re-running failed axes only
   (review-blueprint always re-runs last); still red → escalate to
   the user.
6. **GATE** — reviews clean → integrate first
   (crossing-format.md §integration: jj `jj squash --from charon-NNN@`,
   git merge the builder's branch), then the orchestrator runs the
   blueprint's Verify *itself* in the main workspace and pastes the
   output — post-integration, so what's verified is what ships. A
   builder's "tests pass" is never trusted. Seal via
   [commit-atomic-jj](../../productivity/commit-atomic-jj/SKILL.md)
   (git mode:
   [commit-atomic-git](../../productivity/commit-atomic-git/SKILL.md))
   citing the blueprint, flip its status.
7. **LOG** — update the Passage line: status, axes run, rounds,
   commit, ISO date. Blocked mid-crossing → log that instead; the
   reason is the handoff.
8. **REPEAT or END SITTING** — context healthy → step 2. Otherwise
   stop; Passage *is* the handoff — no HANDOFF.md duplication
   ([write-handoff](../../productivity/write-handoff/SKILL.md) rule).
9. **ARRIVE** — last blueprint `implemented` → hand to
   [moor](../moor/SKILL.md). Charon delivers; moor consolidates.

## Output / done criteria
- Each sitting: ≥1 blueprint gated green, or the blocker named in
  Passage.
- Passage matches `grep -r "^status:"` reality at sitting end.
- Every seal preceded by orchestrator-run Verify output, pasted.
- Ferry fully delivered → moor explicitly handed the tiller.

## Guardrails
- **Never** implement or test in the orchestrator session — dispatch
  only.
- **Never** spawn a builder without a brief (weave's gate).
- **Never** let a builder self-review; never drop the
  review-blueprint + review-angles floor.
- **Never** seal on agent claims — orchestrator-run Verify output only.
- **Never** exceed 2 fix rounds — escalate.
- **Never** dispatch past a blocked-by edge.
- **Never** edit decision or blueprint *content* mid-crossing —
  supersede via ferry/blueprint. Status frontmatter flips are the
  crossing's job, not an edit.
- **Never** moor from here.

## See also
- [crossing-format.md](crossing-format.md) — Passage line, builder
  brief, reviewer brief, finding-merge contract.
- [../ferry/SKILL.md](../ferry/SKILL.md) — upstream; owns MAP.md.
- [../weave/SKILL.md](../weave/SKILL.md) — the process each builder
  brief encodes for one blueprint.
- [../moor/SKILL.md](../moor/SKILL.md) — downstream close-out.
