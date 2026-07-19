# Blueprint format — OKF/blueprints/NNN-<slug>.md

```markdown
---
type: Blueprint
status: draft | locked | implemented | superseded-by-NNN
traces-to: ROADMAP.md phase N | ferries/<topic>/D-<n> | user request <date>
---

# NNN — <imperative title, completes "this change will…">

## Justification
<Why this exists. References (not restatements) of the roadmap phase,
ferry decision, or user need. If sieve-relevant: which Real need this
answers.>

## Contract
<Observable behaviour, exact semantics. What the change does — inputs,
outputs, states, error modes. Canonical vocabulary from OKF/CONTEXT.md
only. No implementation prescriptions unless they ARE the requirement.>

## Seams touched
<The interfaces tests will run against — module + entry point each.
bdd's pre-agreed seam list; review-blueprint checks nothing leaked past
them.>

## Verify
<ONE runnable command or observable check that proves the blueprint is met.
weave pastes its output before flipping status. "Tests pass" is not
a Verify; `just test` on a named suite is.>

## Out of scope
<Explicit non-goals — review-blueprint flags anything here that shows
up in the diff.>
```

## Rules

- Title is imperative — a blueprint names a change, not a state.
- `type: Blueprint` is the OKF-v0.1 conformance field (see
  [write-OKF/okf-layout.md](../write-OKF/okf-layout.md)) — always first.
- `traces-to` is mandatory; a blueprint that traces to nothing fails
  [sieve](../../engineering/sieve/SKILL.md)'s Real test by definition.
- Locked blueprint's Contract/Verify sections are immutable — supersede, don't
  edit. Justification may gain references; status may advance.
- A blueprint grows into `NNN-<slug>/` (blueprint.md + notes) when one file won't
  hold it — the format above moves to `blueprint.md` unchanged.
- Issue-local vocabulary lives here until it recurs; then promote to
  `OKF/CONTEXT.md` (model-domain's recurrence rule).
