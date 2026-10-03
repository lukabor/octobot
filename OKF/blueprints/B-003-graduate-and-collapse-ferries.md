---
type: Blueprint
status: implemented
traces-to: ROADMAP.md phase 7 (decisions 14, 15)
---

# 003 — graduate ferry decisions and collapse the moored ferry

## Justification

Phase 7's second half. Decisions 14 and 15 settle the behaviour;
[002](B-002-extract-why-register.md) built the register they graduate into
and left this in its Out-of-scope block. `ls OKF/ferries/` cannot answer
what deliberation is in flight — the Real need, and decision 15's purpose.

## Contract

**Resolved ferry decisions graduate.** At moor, each `D-<n>` whose
`Resolution` is filled becomes `OKF/decisions/NNN-<slug>.md` at the next
free number, carrying the warrant frontmatter of
[DECISION-FORMAT.md](../../skills/engineering/model-domain/DECISION-FORMAT.md)
and a `decisions/index.md` line. The resolution body moves verbatim; the
ferry's `Options` and `Why it must be decided` stay behind in the
collapsed page. One home, never two copies.

The **warrant test still gates**: a resolved `D-<n>` answering no question
another page lacks gets no register file — its resolution stays in the
collapsed page. Graduation is the default, not an obligation. `blocked-by`
edges drop; the register is not a dependency graph.

**Moor collapses the directory.** `ferries/<topic>/` becomes
`ferries/<topic>.md` — problem shape, rejected alternatives, pointers to
graduated numbers. Directory means open, file means moored.

- Frontmatter: `type: Ferry Map`, then `sealed:` carrying the jj change
  id, the git commit hash, and the ISO date — pinned to `@-` at moor,
  because the sealing commit cannot name itself and the parent is where
  the `D-<n>` files still exist.
- `OKF/index.md`'s ferry line changes shape with the state:
  `<topic> — n/m resolved → <topic>/MAP.md` while open,
  `<topic> — moored <date> → <topic>.md` after. This is what keeps the
  collapsed page reachable once its `MAP.md` is gone.

**moor's guardrails are rewritten, not appended to.** "Never delete a
ferry directory" and "never auto-promote a decision" both now contradict
decisions 14 and 15 as written. They narrow: never collapse without a
resolvable pin — the pin is what makes removal recoverable — and never
graduate a decision that fails the warrant test.

**Drift ownership splits by what each tool can see.**

- `okf-check` validates pin **shape** — a page directly under `ferries/`
  must carry `sealed:` with all three fields, a hex hash and an ISO date;
  a `<topic>/` and a `<topic>.md` may not coexist. Both errors. Shape
  only, because `okf-check` runs against OKF trees that need not sit in a
  jj repo, and per 002's doctrine a validator that cannot exit 0 outside
  its home repo trains people to ignore it.
- **refresh** validates pin **resolution**, reporting DRIFT when the
  change id does not resolve — it has the repo in hand. The split is
  itself a decision: register 017 if warranted, in `okf-layout.md`
  either way.

**moor gates on `okf-check`** — deferred from 002 pending this ferry
rule. Done-criteria require running it and pasting output.

## Seams touched

- `skills/loop/moor/SKILL.md` — the graduation and collapse steps, the
  two narrowed guardrails, the `okf-check` gate in done-criteria.
- `skills/loop/write-okf/scripts/okf-check` — the ferry shape rule. CLI
  unchanged: `okf-check <okf-dir>`, findings on stdout, exit 0/1.
- `skills/loop/write-okf/okf-layout.md` — `ferries/` contract gains the
  moored shape, `sealed:`, and the refresh DRIFT rule.
- `OKF/index.md` — the two ferry line shapes.
- `OKF/ROADMAP.md` phase 7 — both halves tick as one net-shedding line.

## Verify

Weave builds a throwaway fixture in the session scratchpad — a jj repo
holding a minimal OKF with one ferry, one resolved `D-1` — moors it by
hand per the rewritten `SKILL.md`, then runs this against it:

```sh
F=$SCRATCH/fixture-okf \
  && test -f $F/ferries/fx-topic.md && test ! -d $F/ferries/fx-topic \
  && grep -q '^sealed:' $F/ferries/fx-topic.md \
  && ls $F/decisions/[0-9][0-9][0-9]-*.md \
  && (cd $F && jj show "$(sed -n 's/.*change: *//p' ferries/fx-topic.md)" >/dev/null) \
  && skills/loop/write-okf/scripts/okf-check $F \
  && mkdir $F/ferries/fx-topic && ! skills/loop/write-okf/scripts/okf-check $F \
  && rmdir $F/ferries/fx-topic \
  && skills/loop/write-okf/scripts/okf-check OKF/ \
  && test "$(wc -l < OKF/ROADMAP.md)" -le 110 \
  && test "$(wc -l < skills/loop/moor/SKILL.md)" -le 110 \
  && echo PASS
```

## Out of scope

- Resolving `ferries/python-siblings/` D-1..D-3. They stay `open`; that
  is a real design sitting for `/ferry`, not this blueprint's fixture.
- Landing a test runner or a `prove-*.sh` harness — moor is prose, so no
  script can execute its steps, and a fixture builder that cannot run the
  thing under test does not earn a file.
- Backfilling `sealed:` — nothing in the tree is moored yet.
- Splitting `moor/SKILL.md` — it would let Verify's line check pass while
  the skill grew. Overflow means moor wants a decision, not relief.
- Phase 6's scope: taxonomy scan, `modules/`, `analyses/`, and `cites:`
  `path:symbol` pinning (ROADMAP §Risks).
- Raising or exempting the 110-line cap.
