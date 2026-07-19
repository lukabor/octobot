---
name: blueprint
description: Synthesize the current conversation or a roadmap phase into a justified, verifiable spec at OKF/specs/NNN-<slug>.md — the unit that implement executes. No interview, pure synthesis.
disable-model-invocation: true
---

# blueprint

Matt Pocock's to-spec, file-based. Turns *already-discussed* work into a
spec with justification. The interview happened upstream
([grill-me](../../productivity/grill-me/SKILL.md) /
[architect](../architect/SKILL.md)); blueprint only crystallises.

## When to use
- User says "blueprint", "/blueprint", "write the spec", "spec this out".
- An [architect](../architect/SKILL.md) roadmap phase is ready to
  decompose into implementable units.
- A [ferry](../ferry/SKILL.md) decision resolved and needs its spec(s).

## Process
1. **Locate the source** — the conversation, a named roadmap phase, or a
   resolved ferry decision. No source → stop; run grill-me/architect
   first. Never invent requirements.
2. **Number it** — `NNN` = highest existing in `OKF/specs/` + 1
   (`grep -ho '^[0-9]\{3\}' <(ls OKF/specs/) | sort -n | tail -1`).
3. **Write `OKF/specs/NNN-<slug>.md`** per
   [spec-format.md](spec-format.md). Status starts `draft`.
   - *Justification* traces to a roadmap phase, ferry decision, or a
     stated user need — by reference, not restatement.
   - *Seams touched* lists the interfaces tests will run against —
     [bdd](../../engineering/bdd/SKILL.md) consumes this as its
     pre-agreed seam list.
   - *Verify* is a runnable command or observable check — implement's
     done-gate runs exactly this.
4. **Show the spec**; iterate. On explicit user yes → flip status to
   `locked`. No yes, no lock.
5. **Index it** — add `NNN — <title> — <status>` to `OKF/INDEX.md`
   Specs section.
6. **Seal** via [jj-atomic](../../productivity/jj-atomic/SKILL.md):
   `docs(spec): add NNN <slug>`.

## Status discipline
`draft → locked → implemented`, or `→ superseded-by-NNN` from any state.
Never backwards; never edit a locked spec's Spec section — supersede
with a new number instead. The "tracker" is
`grep -r "^status:" OKF/specs/`.

## Output / done criteria
- Spec exists, matches spec-format.md, indexed in INDEX.md.
- Justification traces to a real source; Verify is runnable.
- Locked only on explicit user approval.

## Guardrails
- **Never** interview here — synthesis only.
- **Never** lock without a user yes.
- **Never** write implementation code or tests — that's
  [implement](../implement/SKILL.md).
- **Never** restate OKF content in the spec — reference pages by path.
- One spec = one implementable unit; too big to verify in one
  implement run → split, or send to [ferry](../ferry/SKILL.md).

## See also
- [spec-format.md](spec-format.md) — the format contract.
- [../../engineering/review-blueprint/SKILL.md](../../engineering/review-blueprint/SKILL.md)
  — reviews a diff *against* a spec.
- [../architect/SKILL.md](../architect/SKILL.md) — phases feed specs;
  implemented specs tick phases.
