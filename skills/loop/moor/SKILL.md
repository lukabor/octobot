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
3. **CONSOLIDATE** — promote durable knowledge out of the ferry into its
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
4. **PRUNE + INDEX** — sweep the arrived ferry for unextracted
   follow-ups; every open thread gets a home + backlink:
   - small and implementable → new blueprint `NNN-<slug>.md` with
     `traces-to` citing the source decision;
   - big or multi-session → a new ferry, or a `ROADMAP.md` entry;
   - neither → a `LEARNINGS.md` note, so it stays findable.
   Then rebuild the touched `index.md` lines (`<topic> — arrived →
   MAP.md`; blueprint status lines) and run the conformance check:
   `grep -rL "^type:" OKF/ --include='*.md'` returns only `index.md`.

## Output / done criteria
- The arrived ferry contains no forward-looking work — every follow-up
  has a new home with a backlink.
- `index.md` matches reality: ferry marked arrived, blueprint statuses
  current, no dangling links.
- Ferry directory and blueprints intact — status flipped, zero deletions.

## Guardrails
- **Never delete** a ferry directory, decision file, or blueprint — they
  are the why-record. Supersede, don't delete.
- **OKF files only** — moor never touches source code, configs, or
  skills.
- **Never auto-promote a decision** — an architecturally load-bearing
  decision is only *flagged* as a candidate; model-domain's warrant test
  gates `OKF/decisions/`.
- **Never moor a ferry with open decisions** — that's resolving by
  neglect. Go back to the ferry skill.

## See also
- [../ferry/SKILL.md](../ferry/SKILL.md) — upstream; its "Arrive" step
  hands off here.
- [../weave/SKILL.md](../weave/SKILL.md) — moor runs after its
  done-gate on the ferry's last blueprint.
- [../write-OKF/okf-layout.md](../write-OKF/okf-layout.md) — the page
  contracts moor reconciles against.
