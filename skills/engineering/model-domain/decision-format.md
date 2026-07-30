# Decision format

Settled decisions live in the why-register: `OKF/decisions/NNN-<slug>.md`,
zero-padded to three digits, indexed by `OKF/decisions/index.md`. Numbers
are permanent — they are cited from `CONTEXT.md` and commit messages, so
superseding adds a file, never renumbers one. Create `OKF/decisions/`
lazily — only when the first decision is settled.

## Template

```md
---
type: Decision
purpose: {why this page exists, one line}
answers:
  - "{the question this decision settles}"
cites:
  - {path the decision binds}
status: live
reversible: {how to undo it, or the cost of undoing it}
---

# {NNN} — {short title of the decision}

{1–3 sentences: context, what was decided, and why.}
```

The body can be a single paragraph. The value is recording *that* a
decision was made and *why* — not in filling out sections. Add
**Considered options** or **Consequences** only when rejected
alternatives or non-obvious downstream effects are worth remembering.

`status:` is `live` or `superseded-by-NNN`. Superseding never edits the
old file's body.

## Index lines

`index.md` carries one **question-shaped** line per decision:

```
- [NNN](NNN-<slug>.md) — {question it settles} — {verdict} — {status}
```

The question is *derived* from the file's first `answers:` entry, never
written twice; `okf-check` errors when a line and its source disagree.
` — ` is the field delimiter, so a question may not contain one — use a
colon (`Where do blueprints live: files or a tracker?`).
Question-shaped is a requirement, not a style note — it is what makes the
index answer a query instead of listing titles.

## When to open a decision file — the warrant test

The warrant is the gate. Open a file when the decision **answers a
question no other page already answers**, and you can name the `cites:`
it binds. No question, or a question the glossary or architecture page
already owns → no file. Default is *no*.

### What typically warrants one

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

### What does not

- Easy to reverse and unsurprising: a function rename, a config tweak.
- A question another page already answers — the warrant is duplicate, so
  the page is inadmissible.

---

_Format adapted from
<https://github.com/mattpocock/skills/blob/main/skills/engineering/model-domain/ADR-FORMAT.md>._
