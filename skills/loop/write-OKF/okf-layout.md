# OKF layout contract

OKF = **open-knowledge-format**: a file-based, agent-first project wiki at
the repo root. Inspired by Karpathy's LLM-wiki pattern (precomputed
synthesis agents read before code) as implemented by LangChain's OpenWiki —
format-compatible in spirit, dependency-free in practice.

```
OKF/
├── INDEX.md          # map of the wiki — the ONE file AGENTS.md points at
├── SUMMARY.md        # what the project is, for an agent landing cold
├── ARCHITECTURE.md   # modules, seams, main flows — design-codebase vocab
├── CONTEXT.md        # canonical domain glossary (model-domain owns content)
├── context/          # only in multi-context repos: <subroot>.md per
│                     #   bounded context, indexed from INDEX.md
├── ROADMAP.md        # phased plan — architect owns content
├── adr/              # 0001-<slug>.md — three-of-three rule (model-domain)
├── blueprints/       # NNN-<slug>.md only — flat, grep-able namespace
├── ferries/          # <topic>/ — MAP.md + D-<n>-<slug>.md decision files
└── LEARNINGS.md      # debunked claims, gotchas — append-only, sourced
```

## Page contracts (one line each in INDEX.md)

- **INDEX.md** — every existing page + blueprint, one line + hook each. No
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
  "tracker" is `grep -r "^status:" OKF/blueprints/`. INDEX lists one line
  per blueprint: `NNN — title — status`.
- **ferries/** — one directory per ferry; MAP.md is the per-ferry index.
  INDEX lists one line per ferry: `<topic> — n/m resolved → MAP.md`;
  decisions are never listed in INDEX (single source: MAP.md).
- **LEARNINGS.md** — what was believed / what is true / source. Never
  edited retroactively, only appended or superseded.

## Rules

- Durable knowledge only — no session state, no high-frequency logs
  (that's [write-handoff](../../productivity/write-handoff/SKILL.md) territory).
- One fact, one home; cross-link with relative paths.
- Every page ≤110 lines; grow by splitting + indexing, not by scrolling.
- Blueprints may grow from `NNN-<slug>.md` into `NNN-<slug>/` directories
  (blueprint.md + notes) — the glossary never moves in there.
