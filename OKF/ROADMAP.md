---
type: Roadmap
purpose: Carry only what is still ahead — phases, their verify steps, and live risk.
answers:
  - "What is octobot building next, and how is each phase verified?"
cites:
  - OKF/decisions/index.md
status: live
---

# octobot Roadmap

Octobot becomes a loop-engineering metaharness: the loop
([ARCHITECTURE.md](ARCHITECTURE.md) flow 1) over an OKF substrate,
alongside the existing practice/scaffold skills. Vocabulary:
[CONTEXT.md](CONTEXT.md).

## Why (gap vs prior art)

Octobot's slot: a file-based loop over OKF (open-knowledge-format), jj-native.
mattpocock/skills has the blueprint pipeline but no substrate;
obra/superpowers has subagent execution but no persistent wiki; neither
carries the R/Py scaffolds or the debloat/review axes. The prior-art scan
behind that claim: [learnings/index.md](learnings/index.md).

## Locked decisions

23 live, in the why-register: [decisions/index.md](decisions/index.md).
Each line is the question its decision settles. Cite by number.

## Architecture

See [ARCHITECTURE.md](ARCHITECTURE.md); the loop is its flow 1.

## Phases

Numbers stay as issued — append-only. Phases 1–8 closed 2026-07-19/22 and left
this page per [013](decisions/R-013-roadmap-is-a-plan.md); what they shipped is
in [blueprints/](blueprints/) and [decisions/index.md](decisions/index.md). A
phase is opened for an arc spanning more than one blueprint or session; a
single request traces to `user request <date>` instead, as B-008–B-017 did.

9. **sound — verified recon before lock** — ✅ 2026-07-22, [007](blueprints/B-007-add-sound.md).
10. **skills-consistency hardening** — ✅ 2026-07-31, closed inline; F8's ruling in `conjure-a-skill`.
11. **the loop's shape stops being a hand-copied string** — ✅ 2026-07-30, [019](blueprints/B-019-add-a-render-lint-over-the-loop-shape.md).
12. **the spine gets nautical names and one honest fork** — ✅ 2026-07-31, [024](blueprints/B-024-rename-the-spine-and-give-chart-its-ferry-edge.md).

13. **the loop learns to carry an analysis** — an analysis blueprint's Contract
    is a pre-registered estimand and its Verify is reproducibility (clean
    re-run from a pinned snapshot yielding the named artifact), never the
    result, which cannot be written before it is known. Findings get the
    register they lack: `OKF/findings/`, append-only, with provenance enough
    to re-check. A `survey` skill for exploratory sittings waits until a real
    analysis has one with nowhere to land. **Verify:** `OKF/findings/` holds
    one finding `okf-check OKF/` validates 0/0; `blueprint` states the rule.

14. **the skills tree installs into any harness** — ✅ 2026-09-23, [028](blueprints/B-028-convert-cross-skill-links-to-skill-names.md).

15. **decision and blueprint files carry a searchable prefix** — ✅
    2026-09-23, [029](blueprints/B-029-prefix-register-filenames-and-validate-okf-structure.md),
    [030](blueprints/B-030-migrate-register-filenames-to-their-prefix.md).

## Risks & gotchas

- **A self-firing skill fires when nobody asked.** Believed: every loop skill
  must be user-invoked. True: that holds for orchestrators and rituals, which
  interrupt a person mid-ritual; recon only reads, so
  [019](decisions/R-019-recon-may-self-fire.md) carves it out. The risk moves to
  sound's triggers — vague ones make it fire on every question.
- **A rule bound to pressure that never arrives is not enforced** — the prune
  triggered at cap+1, never reached. Moved onto `✅ verified` and mechanised
  ([020](blueprints/B-020-enforce-the-prune-and-validate-every-cite.md)).
- **A live decision can be contradicted by the skill that owns the file, and
  by the validator that checks it** — `chart` and `okf-check` both
  contradicted R-020 for months, with nothing to catch either. Closed by
  [021](blueprints/B-021-align-validator-and-doctrine.md) and
  [022](blueprints/B-022-validate-every-cite-at-every-status.md).
- **A ruling recorded only in a roadmap phase does not outlive the phase.**
  Believed: settling a question where it was raised is enough. True: R-020
  prunes a discharged phase to one line, so the *reason* evaporates and the
  question reopens as drift. A convention must land where its next reader
  looks — F8's ruling went to `conjure-a-skill`. Source: phase 10, 2026-07-31.
- **A lint that walks the filesystem gates on files the repo does not own.**
  Believed: a repo-wide walk's scope is the repo. True: it is the working
  directory, so one gitignored page can red a repo-wide gate — it already cost
  [024](blueprints/B-024-rename-the-spine-and-give-chart-its-ferry-edge.md) a run
  condition, and two of the four lints carry that walk byte for byte. Ruled by
  [026](blueprints/B-026-walk-only-what-git-does-not-ignore.md). Source:
  2026-07-31.

## Out of scope

- Issue-tracker backends (GitHub/GitLab) for blueprints — files only.
- OpenWiki CLI dependency — import-compat at most.
- Full auto-generated API reference (every symbol) — the derived zone carries
  the public seam a caller needs, nothing more.
- Diagram generation and mermaid validation — deepwiki-skill territory.
- Scheduled/CI wiki regeneration (OpenWiki's Action) — refresh stays human.
- Renaming grandfathered non-verb skills.
- Matt's writing-* / teach / wizard / obsidian skill families.
