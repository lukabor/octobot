---
type: Blueprint
status: implemented
traces-to: user request 2026-07-24
---

# 009 — give every page a growth path so the line cap can be enforced

## Justification

The ≤110-line cap is prose-only in effect: `okf-check` emits it as a
warning, and a warning is what a rule decays into when breaching it has no
consequence. Measured, in a repo running this skill (nostos, 2026-07-22):
twelve pages over cap, the worst at 201 lines, while the one *mechanical*
rule — frontmatter `type:` — is obeyed without exception. In octobot,
seven of eight blueprints sit at exactly 110: the cap is not being obeyed
there either, it is deforming the prose to fit.

The cap cannot be promoted to an error while pages exist that have no
legal move at cap+1. `blueprints/`, `ferries/`, `context/` and
`decisions/` each have a named growth path; `LEARNINGS.md`,
`ARCHITECTURE.md` and `ROADMAP.md` have none. `LEARNINGS.md` is the acute
case — its contract is append-only, so unbounded growth is *mandatory* and
breach is only a matter of time.

Sieve — Real: measured breach, not speculation. Good: the cap becomes
enforceable, and ARCHITECTURE stops being a page that grows with the
codebase. Minimal: one new directory (`learnings/`), one companion file,
one constant; the other three growth paths reuse `modules/`/`analyses/`,
`context/` and `blueprints/`, which already exist.

## Contract

**Caps.** `blueprints/` pages ≤150 lines; every other page ≤110. Over-cap
is an `okf-check` **error**, not a warning.

**Growth path, per page kind.** Every kind has exactly one legal move at
cap+1:

| page | move |
|---|---|
| `blueprints/NNN-<slug>.md` | over 150 is a **scope** signal, not a length one: one session and compound → split into two blueprints; more than one session → `ferry`. The `NNN-<slug>/` directory form stays available for notes. |
| `ARCHITECTURE.md` | sheds per-module prose into the `modules/`/`analyses/` pages that repo's taxonomy scan proposed, keeping the module map, seams and flows. Shed prose lands **outside** any `okf:derived` fence. |
| `ROADMAP.md` | does not split — **prunes**. A discharged phase collapses to one line naming what shipped and its blueprint numbers. |
| `CONTEXT.md` | `context/<subroot>.md` when the repo is genuinely multi-context. Otherwise over-cap is a breach of its existing contract — issue-local terms that belong in a blueprint. |
| `LEARNINGS.md` | splits into `learnings/<theme>.md`; the parent becomes an index. |

**Splitting is a pure move.** Entries move verbatim; nothing is reworded,
merged or dropped; the split lands in its own commit, verified by an entry
count that is equal before and after. New content lands in a later commit.

**Split axis is the layer that must change.** An entry belongs to the
theme of the layer that has to change because of it. Theme *names* are per
repo — the skill prescribes the routing rule and never the names.

**Split-outs are indexed from their own parent.** `index.md` carries one
line to the parent page; the parent alone lists its subpages. Generalises
the `ferries/` and `decisions/` precedent over the `context/` one, and
keeps `index.md` from growing every time a theme is added.

**Supersession is cross-page.** A superseded entry keeps its original text
verbatim wherever it lives and gains a dated note; the note records **what
survives**, not only what was wrong. The superseding entry lives in its own
theme and back-references.

**Directories are created lazily.** No growth-path directory is scaffolded
at init. `learnings/` appears when the cap forces it, never before.

## Seams touched

- `skills/loop/write-OKF/okf-layout.md` — layout tree, page contracts,
  Rules: per-kind caps, growth paths, indexing rule, supersession.
- `skills/loop/write-OKF/split-page.md` — **new**: the split procedure.
- `skills/loop/write-OKF/SKILL.md` — refresh gains the trigger that routes
  an over-cap error to `split-page.md`; the ≤110 guardrail restates.
- `skills/loop/write-OKF/scripts/okf-check` — per-kind cap, warning → error.

## Verify

```sh
cd skills/loop/write-OKF && d=$(mktemp -d) && mkdir -p "$d/blueprints" &&
printf -- '---\nokf_version: "0.1"\n---\n- [a](a.md)\n- [b](blueprints/b.md)\n- [c](blueprints/c.md)\n' > "$d/index.md" &&
for f in "a:120:Learnings" "blueprints/b:140:Blueprint" "blueprints/c:160:Blueprint"; do
  p=${f%%:*}; r=${f#*:}; n=${r%%:*}; t=${r##*:}
  { printf -- '---\ntype: %s\npurpose: p\nanswers:\n  - "q %s"\ncites:\n  - index.md\n---\n' "$t" "$p"
    seq "$n"; } > "$d/$p.md"
done
scripts/okf-check "$d"; scripts/okf-check ../../../OKF
```

Expect: `a.md` errors over the 110-line cap, `blueprints/b.md` (140) does
not, `blueprints/c.md` errors over the 150-line cap, and octobot's own
`OKF/` still reports 0 errors.

## Out of scope

- Migrating any other repo's OKF — this ships the contract and the
  procedure, not a sweep of nostos.
- A `roadmap/done.md` history page; discharged detail stays in
  `blueprints/` and in history.
- Recursion — whether a `learnings/<theme>.md` may itself split, or that
  signals a theme too broad. Untested, no page is near cap.
- Prescribed theme names.
- Renaming `ARCHITECTURE.md` for analysis repos; design-codebase
  vocabulary already maps to pipeline stages.
