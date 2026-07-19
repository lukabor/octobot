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
├── adr/              # 0001-<slug>.md — three-of-three rule (model-domain)
├── blueprints/       # NNN-<slug>.md only — flat, grep-able namespace
├── ferries/          # <topic>/ — MAP.md + D-<n>-<slug>.md decision files
└── LEARNINGS.md      # debunked claims, gotchas — append-only, sourced
```

## Conformance (OKF v0.1)

- Every page except `index.md` opens with YAML frontmatter carrying a
  non-empty `type` (extra fields like `status` follow it).
- `index.md` carries **only** `okf_version: "0.1"` in its frontmatter —
  the one field the spec permits there. Reserved name, lowercase.
- Page types: `Summary`, `Architecture`, `Glossary` (CONTEXT and
  `context/*`), `Roadmap`, `Learnings`, `ADR`, `Blueprint`, `Decision`,
  `Ferry Map`. New page kinds coin a new type — types are producer-defined.
- Conformance check: `grep -rL "^type:" OKF/ --include='*.md'` returns
  only `index.md`.

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
- **blueprints/** — blueprint output; status lives in frontmatter, so the
  "tracker" is `grep -r "^status:" OKF/blueprints/`. index.md lists one
  line per blueprint: `NNN — title — status`.
- **ferries/** — one directory per ferry; MAP.md is the per-ferry index.
  index.md lists one line per ferry: `<topic> — n/m resolved → MAP.md`;
  decisions are never listed in index.md (single source: MAP.md).
- **LEARNINGS.md** — what was believed / what is true / source. Never
  edited retroactively, only appended or superseded.

## Rules

- Durable knowledge only — no session state, no high-frequency logs
  (that's [write-handoff](../../productivity/write-handoff/SKILL.md) territory).
- One fact, one home; cross-link with relative paths.
- Every page ≤110 lines; grow by splitting + indexing, not by scrolling.
- Blueprints may grow from `NNN-<slug>.md` into `NNN-<slug>/` directories
  (blueprint.md + notes) — the glossary never moves in there.
