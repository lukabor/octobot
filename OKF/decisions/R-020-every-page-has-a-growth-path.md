---
type: Decision
purpose: Make the line cap enforceable by naming one legal move per page kind.
answers:
  - "What happens to a page at cap+1?"
cites:
  - OKF/blueprints/B-009-give-every-page-a-growth-path.md
  - skills/loop/write-OKF/okf-layout.md
  - skills/loop/write-OKF/split-page.md
  - skills/loop/write-OKF/scripts/okf-check
status: live
reversible: demote the cap to a warning in okf-check; splits already made stand
---

# 020 — every page kind has one named growth path

A cap with no legal move at cap+1 decays into prose: measured in a repo
running this skill, twelve pages sat over the ≤110-line cap while the one
*mechanical* rule was obeyed without exception. So each kind gets exactly
one move — `blueprints/` over 150 is a **scope** signal (split in two, or
`ferry`), `ARCHITECTURE.md` **sheds** per-module prose into
`modules/`/`analyses/`, `ROADMAP.md` **prunes** a discharged phase to one
line, `CONTEXT.md` opens `context/<subroot>.md` only when the repo is
genuinely multi-context, and `LEARNINGS.md` alone **splits**, into
`learnings/<theme>.md` — and over-cap becomes an `okf-check` error.
Directories are created lazily, never scaffolded at init.

## Considered options

A uniform `<page>/<theme>.md` rule for every kind was rejected: it invents
`architecture/` and `roadmap/` duplicating the `modules/`/`analyses/` and
`blueprints/` pages that already hold that content, where the per-kind
rule adds one directory in total. The asymmetry is the point — only
`LEARNINGS.md` has an append-only contract, so only it grows without
bound, and only it needs somewhere to go.
