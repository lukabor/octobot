# ADR format

ADRs live in `docs/adr/` with sequential numbering: `0001-<slug>.md`,
`0002-<slug>.md`, etc. Create `docs/adr/` lazily — only when the first
ADR is needed.

## Template

```md
# {Short title of the decision}

{1–3 sentences: context, what was decided, and why.}
```

That's it. An ADR can be a single paragraph. The value is recording
*that* a decision was made and *why* — not in filling out sections.

## Optional sections

Add only when they add genuine value. Most ADRs won't need them.

- **Status** frontmatter (`proposed | accepted | deprecated | superseded
  by ADR-NNNN`) — when decisions are revisited.
- **Considered Options** — when rejected alternatives are worth
  remembering.
- **Consequences** — when non-obvious downstream effects need calling
  out.

## Numbering

Scan `docs/adr/` for the highest existing number and increment by one.

## When to offer an ADR — three-of-three test

All three must hold. If any one is missing, skip the ADR.

1. **Hard to reverse.** The cost of changing your mind later is
   meaningful.
2. **Surprising without context.** A future reader will look at the code
   and wonder *"why on earth did they do it this way?"*
3. **The result of a real trade-off.** There were genuine alternatives
   and you picked one for specific reasons.

### What qualifies

- **Architectural shape.** "Monorepo." "Write model is event-sourced,
  read model is projected into Postgres." "Bookdown chapters are knit
  per-chapter to bound render time."
- **Integration patterns between contexts.** "Ordering and Billing
  communicate via domain events, not synchronous HTTP."
- **Technology choices that carry lock-in.** Database, message bus, auth
  provider, deployment target, pipeline framework (`targets` vs
  `drake`). Not every library — only the ones that would take a quarter
  to swap.
- **Boundary and scope decisions.** "Customer data is owned by the
  Customer context; others reference by ID only." The *no*-s are as
  valuable as the *yes*-s.
- **Deliberate deviations from the obvious path.** "Manual SQL instead
  of an ORM because X." "`data.table` instead of `dplyr` in `R/inf/`
  because of memory." Stops the next engineer from "fixing" something
  deliberate.
- **Constraints not visible in the code.** "Can't use cloud X because of
  compliance." "Response times must be < 200 ms because of partner
  contract."
- **Rejected alternatives when the rejection is non-obvious.** If you
  considered GraphQL and picked REST for subtle reasons, record it —
  otherwise someone will suggest GraphQL again in six months.

### What does NOT qualify

- Easy to reverse: a function rename, a config tweak. You'll just
  reverse it.
- Not surprising: the obvious choice nobody would question.
- No real alternative: there was nothing to weigh.

---

_Format adapted from
<https://github.com/mattpocock/skills/blob/main/skills/engineering/domain-modeling/ADR-FORMAT.md>._
