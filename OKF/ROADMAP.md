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
(write-OKF → architect → blueprint → ferry → weave) over an OKF
substrate, alongside the existing practice/scaffold skills. Vocabulary:
[CONTEXT.md](CONTEXT.md).

## Why (gap vs prior art)

Octobot's slot: a file-based loop over OKF (open-knowledge-format),
jj-native. mattpocock/skills has the blueprint pipeline but no substrate;
obra/superpowers has subagent execution but no persistent wiki; neither
carries the R/Py scaffolds or the debloat/review axes. The prior-art scan
behind that claim, and what it debunked: [LEARNINGS.md](LEARNINGS.md).

## Locked decisions

19 live, in the why-register: [decisions/index.md](decisions/index.md).
Each line is the question its decision settles. Cite by number.

## Architecture

See [ARCHITECTURE.md](ARCHITECTURE.md); loop diagram in `README.md`.

## Phases

Phases 1–8 closed between 2026-07-19 and 2026-07-22 and left this page
per [013](decisions/013-roadmap-is-a-plan.md): what they shipped is in
[blueprints/](blueprints/) and [decisions/index.md](decisions/index.md),
how each verified is in jj history. Numbers stay as issued —
append-only.

9. **sound — verified recon before lock** — new `skills/loop/sound/`: a
   recon spine that reads the OKF, then the nostos MCP server when one is
   configured, then confirms both against live code, because either can
   have gone stale. A claim with no internal owner is followed to its
   primary source; nothing else leaves the repo. Runs inline, never in a
   subagent. **Reached by name** — by the user or by `blueprint` — it
   refines the blueprint it sounds and stamps `sounded: <date>` in its
   frontmatter; **self-fired it reports and writes nothing**, per 019.
   Sounding becomes a precondition of lock, enforced by an `okf-check`
   warning on a `locked` blueprint carrying no `sounded:`. The loop's
   only model-invoked skill, per
   [019](decisions/019-recon-may-self-fire.md). **Verify:** on a fixture
   blueprint, `status: locked` without `sounded:` yields exactly one new
   `okf-check` warning where `draft` and `implemented` yield none;
   `okf-check OKF/` still reports 0 errors; a sound run in a repo with no
   `OKF/` stops and names write-OKF, and one with no nostos MCP says so
   once and continues; a self-fired run leaves the blueprint
   byte-identical; and in a fresh session on a repo with no `OKF/`, ten
   ordinary code questions fire sound zero times; caps hold.

## Risks & gotchas

- **A self-firing skill fires when nobody asked.** Believed: every loop
  skill must be user-invoked. True: that holds for orchestrators and
  rituals, which interrupt a person mid-ritual; recon only reads, so
  [019](decisions/019-recon-may-self-fire.md) carves it out. The risk
  moves to sound's triggers — vague ones make it fire on every question.

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
