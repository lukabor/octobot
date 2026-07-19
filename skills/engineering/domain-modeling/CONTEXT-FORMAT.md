# CONTEXT.md format

## Structure

```md
# {Context Name}

{One or two sentences: what this context is and why it exists.}

## Language

**Order**:
A customer's request for fulfillment. Persisted from acceptance through
delivery.
_Avoid_: Purchase, transaction.

**Invoice**:
A request for payment sent to a customer after delivery.
_Avoid_: Bill, payment request.

**Customer**:
A person or organization that places orders.
_Avoid_: Client, buyer, account.
```

## Rules

- **Be opinionated.** When multiple words exist for the same concept,
  pick one and list the rest under `_Avoid_`.
- **Keep definitions tight.** One or two sentences. Define what it *is*,
  not what it does.
- **Only terms specific to this context.** General programming concepts
  (timeouts, error types, utility patterns, language idioms like
  `box::use`) don't belong even if used heavily. Before adding a term,
  ask: is this a concept unique to this project, or general programming?
  Only the former.
- **Group under subheadings** when natural clusters emerge. Flat list is
  fine for single-cluster contexts.
- **No implementation details.** `CONTEXT.md` is a glossary, not a spec,
  not a scratchpad, not a decision log.

## Single vs multi-context repos

**Single context (most repos):** one `OKF/CONTEXT.md`.

**Multi-context:** glossaries split into `OKF/context/<subroot>.md` —
one per bounded context — with a Contexts section in `OKF/INDEX.md`
listing them and how they relate:

```md
## Contexts

- [Ordering](context/ordering.md) — receives and tracks customer orders
- [Billing](context/billing.md) — generates invoices and processes payments
- [Fulfillment](context/fulfillment.md) — warehouse picking and shipping

### Relationships

- **Ordering → Fulfillment**: Ordering emits `OrderPlaced` events;
  Fulfillment consumes them to start picking.
- **Fulfillment → Billing**: Fulfillment emits `ShipmentDispatched`
  events; Billing consumes them to generate invoices.
- **Ordering ↔ Billing**: Shared types for `CustomerId` and `Money`.
```

Decision rule:
- If `OKF/context/` exists → multi-context. Read INDEX.md to find contexts.
- Else if `OKF/CONTEXT.md` exists → single-context.
- Else (neither) → create `OKF/CONTEXT.md` lazily when the first term
  is resolved. Switch to multi-context only on observing ≥ 2 obvious
  sub-roots *and* a second term that clearly belongs to one of them.
- Split by bounded context only — never per issue; issue-local terms
  stay in their `OKF/specs/` entry until they recur.

When multiple contexts exist, infer which one the current topic relates
to. If unclear, ask.

---

_Format adapted from
<https://github.com/mattpocock/skills/blob/main/skills/engineering/domain-modeling/CONTEXT-FORMAT.md>._
