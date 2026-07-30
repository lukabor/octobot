---
type: Decision
purpose: Stop a bare three-digit number meaning two different pages at once.
answers:
  - "How is a register entry cited in prose?"
cites:
  - OKF/CONTEXT.md
  - OKF/decisions/index.md
  - skills/loop/blueprint/blueprint-format.md
  - OKF/ferries/python-siblings/MAP.md
status: live
reversible: yes — drop the prefixes; numbers, filenames and links never moved
---

# 022 — a prose cite carries its register's prefix

Blueprints and the why-register number independently, so the same three
digits already name two unrelated pages three times over: 013, 017 and
019 each exist in both. A markdown link is safe — its path says which —
but a bare number in prose is not, and `B-019` (the render lint) against
`R-019` (recon may self-fire) is the kind of collision a reader resolves
wrongly without noticing. **In prose: `B-NNN` for a blueprint, `R-NNN`
for a why-register decision, `D-n` for a ferry decision.** Filenames,
link targets, `index.md` labels and `superseded-by-NNN` status values are
untouched — the prefix is a reading aid, not an identity.

## Considered options

**`D-` for the why-register** was the first proposal and is unavailable:
`D-<n>` already names a *ferry* decision, on disk at
`ferries/python-siblings/D-1..D-3` and canonical in `CONTEXT.md`. Reusing
it would fuse two namespaces that today collide only in `type:`. `R-` for
why-**R**egister keeps them apart.

**Renaming the files** (`B019-…md`, `D020-…md`) was rejected: it breaks
every link, the register index, `blueprint-format`'s `NNN-<slug>`
contract and `blueprint`'s numbering step, and contradicts *numbers are
permanent — supersede, never renumber*.

**Applying it only to new prose** was rejected as the cheaper half of the
same idea. A convention adopted forward-only leaves two dialects, which
is the defect phase 10 already exists to remove; the live pages were
retrofitted in the same change.

## Consequences

- `LEARNINGS.md` is **not** retrofitted — it is append-only by its own
  header, so its bare numbers stand as written and new entries carry the
  prefix.
- Nothing enforces this yet. A bare three-digit number outside a link and
  without a prefix is a lint the `okf-check` blueprint should carry, or
  the rule decays exactly as R-020's prune did.
