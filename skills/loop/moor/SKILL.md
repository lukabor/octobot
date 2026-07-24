---
name: moor
description: Close out a delivered ferry — reconcile the OKF wiki with what shipped, promote durable knowledge to its one home, extract loose ends into new blueprints/ferries, and shrink index.md; status flips, nothing deleted.
disable-model-invocation: true
---

# moor

What you do when the [ferry](../ferry/SKILL.md) has arrived: tie it up.
Runs **after** weave + review-blueprint + commit-atomic-jj, once every
decision is resolved and the spawned blueprints are done. Consolidates
the wiki so the next cold-start agent reads reality, not history.

## When to use
- User says "moor", "/moor", "close out the ferry", "the ferry is done".
- [weave](../weave/SKILL.md)'s done-gate passes on the last blueprint of
  a ferry-traced chain.

## Process
1. **ORIENT** — read `OKF/index.md`, the ferry's `MAP.md`, and
   `grep -r "^status:" OKF/blueprints/`. Map claimed state before
   touching anything. If any decision is open or a spawned blueprint is
   not done, stop — this is a ferry sitting, not a mooring.
2. **GATHER SIGNAL** — collect delivery evidence, targeted only: `jj log`
   since the ferry started, each blueprint's Verify section (must have
   pasted output), review-blueprint verdicts. No full-transcript rereads.
3. **MUSTER** — only if the ferry's `MAP.md` carries `muster: true`; absent
   → skip, moor runs unchanged. The human gate on arrival → moor: halts
   after GATHER SIGNAL, before every mutation below. Derive `review-base` =
   parent of the earliest commit citing one of the ferry's blueprints
   (weave seals cite `blueprint NNN`); pipe the `review-base..@` diff to
   hunk (`jj diff --from <review-base> --to @ --git | hunk patch -`; git:
   `git diff <review-base>..HEAD | hunk patch -`; no hunk → raw). The human
   records a `tally:` block; `matches: no` stays halted for a fix, never
   mutates on a known miss. COLLAPSE persists `review-base:`; 1-blueprint
   ferry → use blueprint muster (011), not this.
4. **CONSOLIDATE** — promote durable knowledge out of the ferry into its
   one home, cross-linked back:
   - spawned blueprints → `status: done` (or `superseded`);
   - `MAP.md` → mark arrived, record the blueprint numbers produced;
   - shipped architecture changes → `ARCHITECTURE.md` reconciled with
     reality, every claim citing a file path (the ferry keeps the *why*,
     ARCHITECTURE.md holds the current *what*);
   - generalizable rationale from resolved decisions → `LEARNINGS.md`
     (append, never edit);
   - terms that recurred beyond the ferry → `CONTEXT.md` per
     model-domain; the delivered phase → checked off in `ROADMAP.md`;
   - relative dates → ISO 8601; dead cross-links fixed.
5. **GRADUATE** — every resolved `D-<n>` that passes model-domain's
   warrant test becomes `decisions/NNN-<slug>.md` at the next free
   number, carrying the frontmatter of
   [DECISION-FORMAT.md](../../engineering/model-domain/DECISION-FORMAT.md)
   plus a question-shaped `decisions/index.md` line. The `Resolution`
   body moves **verbatim** — one home, never two copies; `Options` and
   `Why it must be decided` stay behind for step 6. `blocked-by` edges
   drop; the register is not a dependency graph. A resolution that
   fails the warrant test graduates nowhere and stays in the collapsed
   page — graduation is the default, not an obligation.
6. **COLLAPSE** — `ferries/<topic>/` becomes `ferries/<topic>.md`:
   problem shape, rejected alternatives, pointers to the numbers that
   graduated. The page opens `type: Ferry Map`, then the pin — read off
   `@-`, because the sealing commit cannot name itself and the parent is
   where the `D-<n>` files still exist
   (`jj log -r @- --no-graph -T 'change_id ++ " " ++ commit_id'`):
   ```yaml
   sealed:
     change: <jj change id>
     commit: <git hash>
     date: <ISO date>
   ```
   A ferry that mustered (step 3) also carries `review-base: <changeid>`
   here. Then remove the directory — history is the archive, the pin the
   way back in.
7. **PRUNE + INDEX** — sweep the arrived ferry for unextracted
   follow-ups; every open thread gets a home + backlink:
   - small and implementable → new blueprint `NNN-<slug>.md` with
     `traces-to` citing the source decision;
   - big or multi-session → a new ferry, or a `ROADMAP.md` entry;
   - neither → a `LEARNINGS.md` note, so it stays findable.
   Then rebuild the touched `index.md` lines — the ferry's changes shape
   with its state, `<topic> — moored <date> → <topic>.md`, which is what
   keeps the collapsed page reachable once its `MAP.md` is gone; the
   register gains its new lines; blueprint statuses go current.

## Output / done criteria
- **`write-OKF/scripts/okf-check OKF/` run and its output pasted**,
  exiting 0. A claim of conformance is not a gate.
- The arrived ferry contains no forward-looking work — every follow-up
  has a new home with a backlink.
- `index.md` matches reality: the ferry line moored and pointing at the
  collapsed page, blueprint statuses current, no dangling links.
- `ferries/<topic>/` is gone, `ferries/<topic>.md` carries the pin, and
  every graduated number is reachable from `decisions/index.md`.

## Guardrails
- **Never collapse without a resolvable pin** — `jj show <change>` must
  resolve *before* the directory goes. The pin is what makes the removal
  recoverable; without it the deliberation is simply deleted.
- **Never delete** a blueprint or a graduated decision file — they are
  the why-record. Supersede, don't delete.
- **OKF files only** — moor never touches source code, configs, or
  skills.
- **Never graduate a decision that fails the warrant test** — a
  resolution answering no question another page lacks stays in the
  collapsed page; model-domain's test gates `OKF/decisions/`.
- **Never moor a ferry with open decisions** — that's resolving by
  neglect. Go back to the ferry skill.

## See also
- [../ferry/SKILL.md](../ferry/SKILL.md) — upstream; its "Arrive" step
  hands off here.
- [../weave/SKILL.md](../weave/SKILL.md) — moor runs after its
  done-gate on the ferry's last blueprint.
- [../write-OKF/okf-layout.md](../write-OKF/okf-layout.md) — the page
  contracts moor reconciles against.
