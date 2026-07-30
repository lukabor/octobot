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

Octobot's slot: a file-based loop over OKF (open-knowledge-format),
jj-native. mattpocock/skills has the blueprint pipeline but no substrate;
obra/superpowers has subagent execution but no persistent wiki; neither
carries the R/Py scaffolds or the debloat/review axes. The prior-art scan
behind that claim, and what it debunked: [LEARNINGS.md](LEARNINGS.md).

## Locked decisions

20 live, in the why-register: [decisions/index.md](decisions/index.md).
Each line is the question its decision settles. Cite by number.

## Architecture

See [ARCHITECTURE.md](ARCHITECTURE.md); the loop is its flow 1.

## Phases

Phases 1–8 closed between 2026-07-19 and 2026-07-22 and left this page
per [013](decisions/013-roadmap-is-a-plan.md): what they shipped is in
[blueprints/](blueprints/) and [decisions/index.md](decisions/index.md),
how each verified is in jj history. Numbers stay as issued —
append-only.

Blueprints 008–017 traced to `user request <date>`, a declared
`traces-to` value — a phase is opened for an arc spanning more than one
blueprint or session, not for a single request. What they shipped is
indexed in [index.md](index.md).

9. **sound — verified recon before lock** — ✅ verified 2026-07-22,
   [007](blueprints/007-add-sound.md).

10. **skills-consistency hardening — the review's remainder** — the
    2026-07-24 skills review (`~/skills-review-2026-07-24.md`, outside
    the repo) left F5 (the loop-spine string hand-copied), F6 (two
    user-invoked skills carrying model-invoked trigger lists), F7
    (`grill-with-docs`, no `## ` sections) and F8 (two heading dialects)
    untriaged, plus F11 ruled in `CONTEXT.md` but never swept.
    **Verify:** each of F5–F8 reaches a recorded ruling — a blueprint, a
    decision, or NO with its reason — and `grep -rn '\bADR\b' skills/
    OKF/` returns only the trigger-alias uses `CONTEXT.md` preserves.

11. **the loop's shape stops being a hand-copied string** — the spine is
    written out in six sites in three divergent forms, and a flat string
    cannot state cadence: write-OKF fires on drift, a request routes
    through architect, `moor` closes only a ferry-traced chain.
    [ARCHITECTURE.md](ARCHITECTURE.md) flow 1 becomes the single owner
    of the shape, `CONTEXT.md`'s entry points at it, and `steer` renders
    the routing fork instead of a list — paired with a lint so the
    copies cannot diverge again. **Verify:** every site rendering the
    spine either matches the declared rendering byte-for-byte or is a
    pointer to flow 1, checked by script; `okf-check OKF/` 0 errors;
    caps hold.

## Risks & gotchas

- **A self-firing skill fires when nobody asked.** Believed: every loop
  skill must be user-invoked. True: that holds for orchestrators and
  rituals, which interrupt a person mid-ritual; recon only reads, so
  [019](decisions/019-recon-may-self-fire.md) carves it out. The risk
  moves to sound's triggers — vague ones make it fire on every question.
- **A rule bound to pressure that never arrives is not enforced.**
  Believed: [020](decisions/020-every-page-has-a-growth-path.md)'s prune
  keeps this page a plan. True: the prune triggers at cap+1, and the page
  sat at 83 of 110 — so phase 9 kept a 20-line body while 013, 020 and
  021 each required one line. The trigger belongs on `✅ verified`, and
  nothing validates it yet (this session).

## Out of scope

- Issue-tracker backends (GitHub/GitLab) for blueprints — files only.
- OpenWiki CLI dependency — import-compat at most.
- Full auto-generated API reference (every symbol) — the derived zone
  carries the public seam a caller needs, nothing more.
- Diagram generation and mermaid validation — deepwiki-skill territory.
- Scheduled/CI wiki regeneration (OpenWiki's GitHub Action) — refresh
  stays human-invoked.
- Renaming grandfathered non-verb skills.
- Matt's writing-* / teach / wizard / obsidian skill families.
