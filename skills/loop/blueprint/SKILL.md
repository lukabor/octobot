---
name: blueprint
description: Synthesize the current conversation or a roadmap phase into a justified, verifiable blueprint at OKF/blueprints/NNN-<slug>.md — the unit that rig executes. No interview, pure synthesis.
disable-model-invocation: true
---

# blueprint

Matt Pocock's to-blueprint, file-based. Turns *already-discussed* work into a
blueprint with justification. The interview happened upstream
(`/grill-me` /
`/chart`); blueprint only crystallises.

## When to use
- User says "blueprint", "/blueprint", "write the blueprint", "blueprint this out".
- A `/chart` roadmap phase is ready to
  decompose into implementable units.
- A `/ferry` decision resolved and needs its blueprint(s).

## Process
1. **Locate the source** — the conversation, a named roadmap phase, or a
   resolved ferry decision. No source → stop; run grill-me/chart
   first. Never invent requirements.
2. **Number it** — `NNN` = highest existing in `OKF/blueprints/` + 1
   (`grep -ho '^[0-9]\{3\}' <(ls OKF/blueprints/) | sort -n | tail -1`);
   directory empty or absent → start at `001`.
3. **Write `OKF/blueprints/NNN-<slug>.md`** per
   [blueprint-format.md](blueprint-format.md). Status starts `draft`.
   - *Justification* traces to a roadmap phase, ferry decision, or a
     stated user need — by reference, not restatement.
   - *Seams touched* lists the interfaces tests will run against —
     `/bdd` consumes this as its
     pre-agreed seam list.
   - *Verify* is a runnable command or observable check — rig's
     done-gate runs exactly this.
   - *Muster* — rule the gate, never leave it silent: `muster: true` when
     the Verify proves form but not meaning (prose, doctrine, renames),
     else `muster: false  # <what the Verify does observe>`.
4. **Sound it** — call `/sound` by name on the draft:
   it verifies what the blueprint rests on and stamps `sounded: <date>`.
   Unsounded, there is nothing to lock against.
5. **Show the blueprint**; iterate. State the muster ruling in one line so
   an unwanted gate is overruled before the lock. On explicit user yes →
   flip status to `locked`. No yes, no lock.
6. **Index it** — add `NNN — <title> — <status>` to `OKF/index.md`
   Blueprints section.
7. **Seal** via `/commit-atomic-jj`:
   `docs(blueprint): add NNN <slug>`.

## Status discipline
`draft → locked → implemented`, or `→ superseded-by-NNN` from any state.
Never backwards; never edit a locked blueprint's Contract section — supersede
with a new number instead. **A lock has a precondition: a `sounded:`
stamp** — `okf-check` warns on a `locked` blueprint without one. The
"tracker" is `grep -r "^status:" OKF/blueprints/`.

## Output / done criteria
- Blueprint exists, matches blueprint-format.md, indexed in index.md.
- Justification traces to a real source; Verify is runnable.
- Locked only on explicit user approval.

## Guardrails
- **Never** interview here — synthesis only.
- **Never** lock without a user yes.
- **Never** write implementation code or tests — that's
  `/rig`.
- **Never** restate OKF content in the blueprint — reference pages by path.
- One blueprint = one implementable unit; too big to verify in one
  rig run → split, or send to `/ferry`.

## See also
- [blueprint-format.md](blueprint-format.md) — the format contract.
- `/review-blueprint`
  — reviews a diff *against* a blueprint.
- `/chart` — phases feed blueprints;
  implemented blueprints tick phases.
