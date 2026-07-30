---
name: design-codebase
description: Shared vocabulary for designing deep modules. Use when the user wants to design or improve a module's interface, find deepening opportunities, decide where a seam goes, make code more testable or AI-navigable, or when another skill needs the deep-module vocabulary.
---

# design-codebase

Design **deep modules**: a lot of behaviour behind a small interface, placed
at a clean seam, testable through that interface. The aim is leverage for
callers, locality for maintainers, and testability for everyone.

## Glossary

Use these exactly; don't substitute "component", "service", "API", "boundary".

**Module** — anything with an interface and an implementation. Scale-agnostic:
function, class, package, tier-spanning slice. _Avoid_: unit, component, service.

**Interface** — everything a caller must know to use the module correctly:
type signature, invariants, ordering, error modes, configuration, performance.
_Avoid_: API, signature (type-level only).

**Implementation** — what's inside a module. Distinct from **Adapter**: a small
adapter can wrap a large implementation (a Postgres repo), or vice versa.

**Depth** — leverage at the interface: behaviour a caller exercises per unit
of interface learned. **Deep** = much behaviour behind a small interface;
**shallow** = interface nearly as complex as impl.

**Seam** _(Michael Feathers)_ — a place where you can alter behaviour without
editing in that place; the *location* at which a module's interface lives.
_Avoid_: boundary (overloaded with DDD's bounded context).

**Adapter** — a concrete thing that satisfies an interface at a seam. *Role*,
not substance.

**Leverage** — what callers get from depth: more capability per unit of
interface learned. One impl pays back across N call sites, M tests.

**Locality** — what maintainers get from depth: change, bugs, knowledge,
verification concentrate in one place. Fix once, fixed everywhere.

## Deep vs shallow

A **deep** module = small interface (few methods, simple params) over large
implementation (complex logic hidden). **Shallow** = the inverse, mostly
pass-through. Avoid shallow: reduce methods, simplify params, hide more inside.

## Principles

- **Depth is a property of the interface, not the implementation.** A deep
  module can be composed of small mockable parts internally; **internal
  seams** (private, used by its own tests) coexist with the **external seam**.
- **The deletion test.** Imagine deleting the module. If complexity vanishes,
  it was a pass-through. If complexity reappears across N callers, it was
  earning its keep.
- **The interface is the test surface.** Callers and tests cross the same
  seam. To test *past* the interface is to find the module is the wrong shape.
- **One adapter = hypothetical seam; two = real one.** Don't introduce a seam
  unless something actually varies across it.

## Designing for testability

**Accept dependencies, don't create them.**

```r
# R: pass the client; default keeps callers ergonomic
fetch_orders <- function(order_id, client = modb_client()) client$get(order_id)
```

```python
# Python: optional parameter, same shape
def fetch_orders(order_id: str, client: ModbClient | None = None) -> Order:
    return (client or ModbClient()).get(order_id)
```

Constructing the client inside buries the dependency past the interface.

**Return results, don't produce side effects.**

```r
# R: return the new value
calculate_discount <- function(cart) cart$total - discount(cart)
```

```python
# Python: return the new value
def calculate_discount(cart: Cart) -> Decimal:
    return cart.total - discount(cart)
```

Mutating in place hides the effect and couples every test to caller state.

## Rejected framings

- **Depth as impl-lines ÷ interface-lines** (Ousterhout): rewards padding. Use depth-as-leverage instead.
- **"Interface" = the TypeScript `interface` keyword or a class's public methods**: too narrow — interface here is every fact a caller must know.
- **"Boundary"**: overloaded with DDD's bounded context. Say **seam** or **interface**.

[deepening.md](deepening.md) — dependency categories, seam discipline, replace-don't-layer testing. [design-it-twice.md](design-it-twice.md) — parallel sub-agents to design the interface several radically different ways; compare on depth, locality, seam placement.
