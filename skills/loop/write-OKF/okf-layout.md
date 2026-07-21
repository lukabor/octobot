# OKF layout contract

OKF = **open-knowledge-format**: a file-based, agent-first project wiki at
the repo root. Conforms to Google's [OKF v0.1
spec](https://github.com/GoogleCloudPlatform/knowledge-catalog/blob/main/okf/SPEC.md)
(a bundle of markdown concept files with typed frontmatter). Page set and
loop wiring follow Karpathy's LLM-wiki pattern (precomputed synthesis
agents read before code) as implemented by LangChain's OpenWiki —
dependency-free in practice.

```
OKF/
├── index.md          # map of the wiki — the ONE file AGENTS.md points at
├── SUMMARY.md        # what the project is, for an agent landing cold
├── ARCHITECTURE.md   # modules, seams, main flows — design-codebase vocab
├── CONTEXT.md        # canonical domain glossary (model-domain owns content)
├── context/          # only in multi-context repos: <subroot>.md per
│                     #   bounded context, indexed from index.md
├── ROADMAP.md        # phased plan — architect owns content
├── decisions/        # the why-register — index.md + NNN-<slug>.md
├── blueprints/       # NNN-<slug>.md only — flat, grep-able namespace
├── ferries/          # open: <topic>/ — MAP.md + D-<n>-<slug>.md files
│                     #   moored: <topic>.md, pinned with sealed:
└── LEARNINGS.md      # debunked claims, gotchas — append-only, sourced
```

## Conformance (OKF v0.1)

- Every page except `index.md` opens with YAML frontmatter carrying a
  non-empty `type` (extra fields like `status` follow it).
- `index.md` carries **only** `okf_version: "0.1"` in its frontmatter —
  the one field the spec permits there. Reserved name, lowercase.
- Page types: `Summary`, `Architecture`, `Glossary` (CONTEXT and
  `context/*`), `Roadmap`, `Learnings`, `Decision`, `Index`, `Blueprint`,
  `Ferry Map`. New page kinds coin a new type — types are producer-defined.
- **Warrant and pins** — `purpose`, `answers[]`, `cites[]`, their scope,
  and the moored-ferry `sealed:` block: [page-warrant.md](page-warrant.md).
- **Cite grammar** — a `cites:` entry is `path`, `path:line`, or
  `path:symbol`; all three resolve only if the path exists. `path:symbol`
  additionally needs the symbol as a literal substring of the file — that
  is the shape that breaks when the thing it cites moves. A `path:line`
  number is a reading aid, never validated.
- **Derived zone** — a page carries at most one region delimited by
  `<!-- okf:derived begin -->` and `<!-- okf:derived end -->`, each marker
  alone on its line. Refresh regenerates the inside wholesale and may not
  touch a byte outside it; outside is the judgement zone, append/supersede
  only. `okf-check` validates the fence's *shape* — balanced, `begin`
  first, at most one pair — never its content.
- Conformance check: `scripts/okf-check <okf-dir>` — reach for it from
  this skill's own base directory, never a repo-relative path. Exit 1 on
  any error; over-cap pages and pages with no `cites` are warnings.

## Page contracts (one line each in index.md)

- **index.md** — every existing page + blueprint, one line + hook each. No
  content of its own beyond the map.
- **SUMMARY.md** — ≤1 screen: what it is, who for, how run, where to start
  reading. The cold-start page.
- **ARCHITECTURE.md** — module map with seams; every claim cites a file
  path. Uses design-codebase vocabulary (module, interface, seam, adapter).
- **CONTEXT.md** — glossary per model-domain's CONTEXT-FORMAT.md.
  **One canonical glossary per bounded context — never per issue.**
  Issue-local terms live in their blueprint until they recur.
- **ROADMAP.md** — architect's skeleton (locked decisions, phases with
  verify steps, risks, out-of-scope).
- **decisions/** — the why-register: one file per settled decision,
  permanent numbers, format in
  [model-domain/DECISION-FORMAT.md](../../engineering/model-domain/DECISION-FORMAT.md).
  `decisions/index.md` carries one **question-shaped** line per decision,
  the question derived from the file's first `answers:` entry — index.md
  lists the register, not its members.
- **blueprints/** — blueprint output; status lives in frontmatter, so the
  "tracker" is `grep -r "^status:" OKF/blueprints/`. index.md lists one
  line per blueprint: `NNN — title — status`.
- **ferries/** — **directory means open, file means moored.** An open
  ferry is `<topic>/` with MAP.md as its per-ferry index; index.md lists
  `<topic> — n/m resolved → MAP.md` and never its decisions (single
  source: MAP.md). [moor](../moor/SKILL.md) graduates the resolved
  decisions into `decisions/` and collapses the directory into
  `<topic>.md` — problem shape, rejected alternatives, graduated
  numbers — indexed `<topic> — moored <date> → <topic>.md`. The two
  shapes may never coexist. A moored page carries `sealed:` after its
  `type`, pinning the deliberation it dropped to the commit *before* the
  collapse — fields and drift rule in
  [page-warrant.md](page-warrant.md).
- **LEARNINGS.md** — what was believed / what is true / source. Never
  edited retroactively, only appended or superseded.

## Rules

- Durable knowledge only — no session state, no high-frequency logs
  (that's [write-handoff](../../productivity/write-handoff/SKILL.md) territory).
- One fact, one home; cross-link with relative paths.
- Every page ≤110 lines; grow by splitting + indexing, not by scrolling.
- Blueprints may grow from `NNN-<slug>.md` into `NNN-<slug>/` directories
  (blueprint.md + notes) — the glossary never moves in there.
