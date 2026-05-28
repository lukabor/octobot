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

**Single context (most repos):** one `CONTEXT.md` at the repo root.

**Multi-context:** a `CONTEXT-MAP.md` at the repo root lists the contexts,
where they live, and how they relate:

```md
# Context Map

## Contexts

- [Ordering](./src/ordering/CONTEXT.md) — receives and tracks customer orders
- [Billing](./src/billing/CONTEXT.md) — generates invoices and processes payments
- [Fulfillment](./src/fulfillment/CONTEXT.md) — warehouse picking and shipping

## Relationships

- **Ordering → Fulfillment**: Ordering emits `OrderPlaced` events;
  Fulfillment consumes them to start picking.
- **Fulfillment → Billing**: Fulfillment emits `ShipmentDispatched`
  events; Billing consumes them to generate invoices.
- **Ordering ↔ Billing**: Shared types for `CustomerId` and `Money`.
```

Decision rule:
- If `CONTEXT-MAP.md` exists → multi-context. Read it to find contexts.
- Else if a single root `CONTEXT.md` exists → single-context.
- Else (neither) → create a root `CONTEXT.md` lazily when the first term
  is resolved. Switch to multi-context only on observing ≥ 2 obvious
  sub-roots *and* a second term that clearly belongs to one of them.

When multiple contexts exist, infer which one the current topic relates
to. If unclear, ask.

---

_Format adapted from
<https://github.com/mattpocock/skills/blob/main/skills/engineering/grill-with-docs/CONTEXT-FORMAT.md>._
