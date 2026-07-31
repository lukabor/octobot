---
type: Blueprint
status: implemented
traces-to: ROADMAP.md phase 11
sounded: 2026-07-30
cites:
  - OKF/ROADMAP.md:the loop's shape stops being a hand-copied string
  - OKF/ARCHITECTURE.md:1. **The loop**
  - OKF/CONTEXT.md:**The loop**:
  - README.md:### loop — the metaharness spine
  - CLAUDE.md:**The loop.**
  - skills/loop/steer/SKILL.md:## The loop (the metaharness spine)
  - skills/loop/ferry/SKILL.md:more than one agent
  - skills/loop/call-charon/SKILL.md:implementation spans multiple blueprints
  - skills/loop/moor/SKILL.md:a ferry-traced chain
  - skills/loop/weave/SKILL.md:Close the loop
  - skills/loop/blueprint/blueprint-format.md:traces-to:
  - skills/loop/architect/SKILL.md:Owns `OKF/ROADMAP.md`
---

# 018 — own the loop's shape in ARCHITECTURE flow 1

## Justification

[ROADMAP.md](../ROADMAP.md) phase 11 states the defect: the spine is
written out in six sites (§Seams touched) in three divergent forms, and a
flat arrow string cannot state cadence. Three end at `commit-atomic-jj`,
three continue to `moor` — what hand-copying produces, not a decision.

The cost is not cosmetic. The string asserts a straight line; four cited
facts contradict it. `write-OKF` fires on scaffold or staleness, not per
request. `ferry` is for work more than one agent session can hold, so it
*branches* off blueprint rather than following it. `call-charon` is the
multi-blueprint form of weave, not a tier above it. `moor` closes only a
ferry-traced chain — a lone blueprint ends at weave's close-the-loop step.

**Why ARCHITECTURE.md owns it.** The shape is a flow — where control goes
and under what condition — which is that page's stated `purpose:`, and
`index.md` already bills it as carrying "the loop". A glossary that also
fixes an ordering is what let six sites drift.

## Contract

**The canonical rendering** — this exact block, fenced, no other content
inside the fence:

```
substrate (rare)  write-OKF — scaffold, or refresh when stale
                      ↓
per request       architect — a phase only for an arc over >1 blueprint
                      ↓
                 know what to do?
        ┌──── yes ────┴──── no ────┐
  blueprint → sound          ferry — decisions + blocking edges,
    → weave                  resolve one per sitting
    (weave closes it)                ↓
                             blueprint per cleared decision → sound
                                     ↓
                             1 left → weave
                             N left → call-charon (agent per blueprint)
                                     ↓
                                   moor

weave = bdd → 4-axis review → Verify → commit-atomic-jj → close (OKF refresh)
```

The legend is part of the block, not commentary: it carries the OKF-refresh
edge `README.md` draws as a return arrow — the shape's only cycle.

**One owner.** `OKF/ARCHITECTURE.md` §Main flows item 1 carries it, keeping
its `1. **The loop**` label and its `skills/loop/` pointer; the item's
present three-line prose spine is replaced by the block.

**Two copies, byte-for-byte.** `README.md` §loop and `steer` §The loop each
carry the block verbatim — entry surfaces a reader hits before `OKF/`,
where a pointer costs a hop for the one thing they came for. `steer`'s loop
*table* stays; the block replaces only its one-line spine.

**Four pointers.** `OKF/CONTEXT.md`'s *The loop* entry, `OKF/ROADMAP.md`'s
opening paragraph and `CLAUDE.md`'s loop paragraph stop restating the
stages and reference flow 1 instead; `CONTEXT.md` keeps the canonical name
and its `_Avoid_` line, a glossary's job. That also settles the interim
`→ moor` that entry was owed — a pointer cannot be stale about an ordering
it does not carry. `ROADMAP.md:33` is already a pointer but aimed at a copy
(*loop diagram in `README.md`*); it is re-aimed at flow 1.

**Crossing architect's file, deliberately.** `architect/SKILL.md:9` owns
`OKF/ROADMAP.md` — meaning the *plan*: phases, locked decisions, verify
steps, supersede-never-delete. Both lines touched are prose about the
loop's shape, and weave step 7 already routes a blueprint back into that
file. No phase, decision or verify step moves.

**One adjacent claim, same file, same defect.** `steer/SKILL.md:8` glosses
user-invoked as *"zero context load"*. It is not — naming a skill loads its
body. The flag buys routing control: a skill fires when named, not when a
description matches. The parenthetical is replaced with that.

**After the change no file outside this blueprint renders the flat spine**
— the state the lint will later hold, checked today by grep.

## Seams touched

- `OKF/ARCHITECTURE.md` — §Main flows item 1; the sole owner.
- `README.md` — §loop, the fenced diagram block.
- `skills/loop/steer/SKILL.md` — §The loop, the fenced spine block; and
  the intro's `zero context load` parenthetical.
- `OKF/CONTEXT.md` — the *The loop* entry body.
- `OKF/ROADMAP.md` — the opening paragraph's parenthetical spine, and
  §Architecture's `loop diagram in README.md` pointer.
- `CLAUDE.md` — the loop paragraph's backticked spine.

## Verify

```sh
CANON=$(sed -n '/^substrate (rare)/,/^weave = bdd/p' OKF/ARCHITECTURE.md)
[ -n "$CANON" ] && echo "owner: $(printf '%s\n' "$CANON" | wc -l) lines"
for f in README.md skills/loop/steer/SKILL.md; do
  [ "$(sed -n '/^substrate (rare)/,/^weave = bdd/p' "$f")" = "$CANON" ] \
    && echo "match  $f" || echo "DIFFER $f"
done
grep -rln 'architect → blueprint' --include='*.md' --exclude='018-*' .
echo "strays exit: $?"
grep -rn 'zero context load\|loop diagram in' --include='*.md' --exclude='018-*' .
skills/loop/write-OKF/scripts/okf-check OKF/
skills/productivity/conjure-a-skill/scripts/skill-check skills/ | tail -1
wc -l OKF/ARCHITECTURE.md OKF/CONTEXT.md skills/loop/steer/SKILL.md
```

Expect, in order: `owner: 17 lines`; `match` for both copies, no `DIFFER`;
nothing from either grep and `strays exit: 1`, retiring the flat form and
both folded-in claims; `0 error(s), 0 warning(s)`; then
`0 error(s), 9 warning(s)` — today's nine, `steer` not among them.

## Out of scope

- **The lint.** Phase 11 pairs this with a script so the copies cannot
  diverge again; that is blueprint 019, and phase 11 does not verify until
  it lands. Its three open questions are in the 2026-07-30 handoff.
- **Phase 10.** F5's ownership question is what this blueprint answers; the
  `steer:8` line is F6-shaped, taken because the file is already open. F6
  proper, F7 and F8 stay phase 10, untouched.
- **Any change to the loop itself.** No skill's triggers, process or
  frontmatter changes — including `disable-model-invocation`, weighed and
  kept this session. Every branch drawn traces to its owning skill.
- **`OKF/ARCHITECTURE.md`'s module-map line** — found stale while sounding:
  blueprint, ferry, weave and steer *land per* `ROADMAP.md`; all four
  shipped. Different section. Untriaged; folds into the next module-map edit.
