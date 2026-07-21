# Page warrant contract

Why a page is admitted, and how a moored ferry pins what it dropped. The
page set and the rest of conformance: [okf-layout.md](okf-layout.md).

## Warrant

Durable pages carry `purpose`, `answers[]`, `cites[]` after `type`. Zero
`answers`, or a question another page owns, makes the page inadmissible;
an unresolvable `cites` path is drift.

Scope: the root pages and `decisions/`. `blueprints/` and `ferries/`
carry their own frontmatter contracts and are exempt.

Cite grammar — the three shapes and what each one detects — lives with
the layout contract, in [okf-layout.md](okf-layout.md).

## `sealed:` — the moored-ferry pin

A moored page carries `sealed:` after its `type`, pinning the
deliberation it dropped to the commit *before* the collapse:

```yaml
sealed:
  change: <jj change id>
  commit: <git hash>
  date: <ISO date>
```

Pin drift splits by what each tool can see: `okf-check` validates the
**shape** (all three fields, hex hash, ISO date), because it must exit 0
on a tree copied outside its jj repo; **refresh** has the repo in hand
and validates **resolution**, reporting DRIFT when the change id no
longer resolves.

A cite needs no repo, so cite drift does not split the same way — it
belongs to `okf-check` whole.
