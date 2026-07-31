---
okf_version: "0.1"
---

# octobot — OKF index

Open-knowledge-format wiki. Agents: read this page first, then the pages
your task needs. Humans welcome too.

## Pages

- [SUMMARY.md](SUMMARY.md) — what this project is; start here cold.
- [ARCHITECTURE.md](ARCHITECTURE.md) — skill categories, seams, the loop.
- [CONTEXT.md](CONTEXT.md) — canonical domain glossary.
- [ROADMAP.md](ROADMAP.md) — metaharness build-out, phased with verify steps.
- [learnings/index.md](learnings/index.md) — gotchas and debunked claims,
  by the layer each forces to change.

## Decisions

- [decisions/index.md](decisions/index.md) — the why-register, indexed by
  the question each decision settles. 20 live.

## Blueprints

- [001](blueprints/001-add-write-readme-r.md) — add write-readme-r skill — dropped
- [002](blueprints/002-extract-why-register.md) — extract the why-register from ROADMAP — implemented
- [003](blueprints/003-graduate-and-collapse-ferries.md) — graduate ferry decisions and collapse the moored ferry — implemented
- [004](blueprints/004-give-cites-teeth-and-fence-derived-zone.md) — give cites teeth and fence the derived zone — implemented
- [005](blueprints/005-propose-the-page-plan-from-a-repo-scan.md) — propose the page plan from a repo scan — implemented
- [006](blueprints/006-rescan-the-page-plan-on-refresh.md) — rescan the page plan on refresh — implemented
- [007](blueprints/007-add-sound.md) — add sound, the recon that precedes a lock — implemented
- [008](blueprints/008-make-nostos-primary-and-files-the-fallback.md) — make nostos primary and file reads the fallback — implemented
- [009](blueprints/009-give-every-page-a-growth-path.md) — give every page a growth path so the line cap can be enforced — implemented
- [010](blueprints/010-add-muster-the-human-review-gate.md) — add muster, the opt-in human review gate on the loop's close — superseded-by-011
- [011](blueprints/011-add-blueprint-level-muster.md) — add blueprint-level muster, the opt-in human review gate in weave — implemented
- [012](blueprints/012-add-ferry-level-muster.md) — add ferry-level muster, the human review gate at moor — implemented
- [013](blueprints/013-split-moor-into-skill-and-reference.md) — split moor into SKILL.md + REFERENCE.md to hold the line cap — implemented
- [014](blueprints/014-unify-skill-sibling-file-naming.md) — unify skill sibling-file naming on lowercase-kebab topic names — implemented
- [015](blueprints/015-record-session-check-discharges-on-the-blueprint.md) — record session-check discharges on the blueprint — implemented
- [016](blueprints/016-pull-two-skills-under-cap-and-level-commit-twins.md) — pull two skills under the line cap and level the commit twins — implemented
- [017](blueprints/017-add-a-line-cap-lint-over-skills.md) — add a line-cap lint over skills/ — implemented
- [018](blueprints/018-own-the-loop-shape-in-flow-1.md) — own the loop's shape in ARCHITECTURE flow 1 — implemented
- [019](blueprints/019-add-a-render-lint-over-the-loop-shape.md) — add a render lint over the loop's shape — implemented
- [020](blueprints/020-enforce-the-prune-and-validate-every-cite.md) — enforce the roadmap prune and validate every page's cites — superseded-by-022
- [021](blueprints/021-align-validator-and-doctrine.md) — align the validator and the doctrine on splits, prefixes and cites — implemented
- [022](blueprints/022-validate-every-cite-at-every-status.md) — enforce the roadmap prune and validate every cite at every status — implemented
- [023](blueprints/023-add-a-link-lint-over-relative-md-links.md) — add a link lint over relative markdown links — implemented
- [024](blueprints/024-rename-the-spine-and-give-chart-its-ferry-edge.md) — rename the spine to chart and rig, and give chart its ferry edge — implemented
- [025](blueprints/025-rule-muster-on-every-blueprint.md) — rule muster on every blueprint — locked

## Ferries

Open ferries link their `MAP.md`; moored ones link the collapsed page
that replaced it — `<topic> — moored <date> → <topic>.md`.

- [python-siblings](ferries/python-siblings/MAP.md) — Python siblings for bdd/diagnose — 0/3 resolved
