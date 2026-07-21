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

17 live, in the why-register: [decisions/index.md](decisions/index.md).
Each line is the question its decision settles. Cite by number.

## Architecture

See [ARCHITECTURE.md](ARCHITECTURE.md); loop diagram in `README.md`.

## Phases

1. **OKF foundation** — write-OKF, architect, path retargets, octobot's
   own OKF. **Verify:** scaffold produces layout-conformant tree in an
   empty dir; refresh on octobot yields sane OKF/; zero stale
   plan-project/update-project refs. ✅ verified 2026-07-19 (scratch-dir
   scaffold + this OKF + grep).
2. **blueprint + review-blueprint** — blueprint skill with blueprint-format.md;
   fourth review axis (diff vs blueprint). **Verify:** blueprint a real
   roadmap item into a well-formed blueprint; review-blueprint flags an
   injected scope-creep diff. ✅ verified 2026-07-19 (blueprint 001 drafted;
   scratch fixture: CONTAINED ✗ on planted logging + stray function).
3. **ferry + weave** — decision maps; blueprint-driven execution with the
   verify gate and handoff-gated subagent dispatch. **Verify:** ferry a
   multi-session feature into ≥3 edged decisions; implement one locked
   blueprint end-to-end with pasted Verify output. ✅ verified 2026-07-19
   (ferries/python-siblings D-1..D-3; scratch weave run, Verify "OK").
4. **Upstream pulls** — tautological-test + pre-agreed seams into bdd;
   handoff redaction/reference rules; resolve-conflicts-jj (jj port).
   **Verify:** resolve-conflicts-jj replayed on a synthetic two-sided
   conflict; house caps hold. ✅ verified 2026-07-19 (rc-test replay,
   both intents merged, chain clean; bdd at 110).
5. **Invocation audit + steer** — disable-model-invocation on
   orchestrators/rituals; steer router; conjure imperative-verb
   enforcement; README regen. **Verify:** fresh session lists only the
   ~~8~~ 11 model-invoked descriptions (superseded: spawn-cavecrew,
   review-blueprint, resolve-conflicts-jj must fire from natural phrasing);
   steer names every skill; conjure rejects a noun-first name.
   ✅ verified 2026-07-19 (16 flagged / 11 model-invoked by grep; steer
   table covers all 34; conjure gather+review reject noun-first).
6. **Adaptive taxonomy + page warrants** — write-OKF gains a taxonomy
   scan (scan → propose page plan → user locks it into `index.md`), the
   warrant frontmatter contract, `okf:derived` two-zone fences, and drift
   reporting on refresh. New siblings `taxonomy-scan.md` and
   `page-warrant.md`; `okf-layout.md` gains `modules/` and `analyses/` as
   *proposable*, never mandatory, directories. **Verify:** scaffold
   against two fixtures — an analysis repo (`analysis/` dirs, no plotting
   module) and a plain library repo — yields two different non-empty page
   plans with zero empty ceremonial pages; `grep -rL "^purpose:"` over
   the warranted scope — `OKF/*.md` plus `decisions/` — returns only
   `index.md`; after moving a cited symbol, `okf-check` reports the
   broken cite and refresh leaves every judgement zone byte-identical.
   Ships as 004 (cites + fences) then 005 (taxonomy scan).
7. **Why-register + ferry collapse** — `OKF/decisions/` indexed by
   question with warrant frontmatter; moor gains the graduation and
   collapse steps with the `sealed:` pin. **Verify:** every decision
   reachable from `decisions/index.md`; moor a fixture ferry → directory
   becomes one pinned page, decisions numbered, `jj show <change>`
   resolves, a shape-broken pin fails `okf-check`. ✅ verified 2026-07-21
   (blueprint 002) and 2026-07-22 (003; fixture moored by hand, okf-check
   clean there and on OKF/, caps hold). Refresh's DRIFT rule is prose —
   no runner, per 003's out-of-scope.

**Execution order: 7 → 6.** Phase 7 is small, closes the cap breach now,
and makes octobot's own OKF *run* the register before phase 6 freezes it
into a contract for other repos. Numbers stay as issued — append-only.

## Risks & gotchas

- Open, for phase 6's blueprint: `cites:` pinned at `path:line` churns on
  every refactor — the staleness detector is also the maintenance bill.
  Candidate mitigation `path:symbol` where the language allows.

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
