---
type: Roadmap
---

# octobot Roadmap

Octobot becomes a loop-engineering metaharness: the loop
(write-OKF → architect → blueprint → ferry → weave) over an OKF
substrate, alongside the existing practice/scaffold skills. Vocabulary:
[CONTEXT.md](CONTEXT.md).

## Why (gap vs prior art)

| repo | has | lacks |
|---|---|---|
| mattpocock/skills | blueprint/ticket pipeline, tracker-backed | file-based substrate, jj, R/Py ecosystem, debloat/review axes |
| obra/superpowers | subagent execution, verification gate | persistent wiki memory, ecosystem scaffolds |
| octobot pre-2026-07 | review axes, scaffolds, jj discipline | plan→blueprint→weave spine, knowledge substrate |
| langchain-ai/openwiki | OKF v0.1 emitter, CI auto-refresh, doc Q&A | durable-synthesis caps, human-locked page plan, loop wiring |
| Cognition DeepWiki | declared page plan (`.devin/wiki.json`), page hierarchy | local/file-based, OKF conformance, warrant checks |
| natsu1211/deepwiki-skill | TOC-first generation, line-level cites, `--update` | taxonomy adapted per repo shape, judgement/derived split |

Sources: <https://github.com/langchain-ai/openwiki>,
<https://docs.devin.ai/work-with-devin/deepwiki>,
<https://github.com/natsu1211/deepwiki-skill> (scanned 2026-07-21).

Octobot's slot: file-based loop over OKF (open-knowledge-format), jj-native.

## Locked decisions

1. OKF = open-knowledge-format at target project's `./OKF/` — reversible
   (it's files). Karpathy-LLM-wiki style; OpenWiki-inspired, dependency-free.
2. architect replaces plan-project + update-project (mode-routed) —
   reversible by re-splitting.
3. Blueprints are files with status frontmatter, not tracker issues — the
   "tracker" is grep. Reversible via export.
4. One canonical glossary per bounded context, never per issue.
5. Handoff gate: no mutating subagent without a brief (goal, OKF/blueprint
   refs, verify command); read-only lookups exempt.
6. New skill names: imperative-verb-first; legacy names grandfathered.
7. Page taxonomy is **derived per repo, never fixed** — write-OKF scans
   disk, proposes a page plan, user locks it. A fixed layout yields empty
   ceremonial pages: analysis repos keep analyses in directories and may
   have no plotting module; libraries have neither. Reversible — collapse
   to a fixed list in okf-layout.md.
8. Every page carries a **warrant** after `type`: `purpose`, `answers[]`,
   `cites[]`. Zero `answers`, or answers another page owns → inadmissible;
   unresolved `cites` → drift. Doubles as routing index
   (`grep -r "answers:" OKF/`). Reversible — OKF v0.1 permits
   producer-defined fields after `type`.
9. `index.md` **is** the locked page plan; no TOC file, which would
   duplicate index.md's job. Absent from index.md → inadmissible.
   Reversible by extracting TOC.md.
10. Module and analysis pages are **two-zone**: `<!-- okf:derived -->`
    fences the scan-regenerated seam, everything outside is judgement —
    append/supersede only, never scan-edited. Reversible — drop fences,
    fall back to the existing whole-page supersede rule.
11. Code-reference layer stays **inside write-OKF** as siblings
    (`taxonomy-scan.md`, `page-warrant.md`), not a new skill — one
    trigger, one mental model. Reversible by extraction if the router
    breaches the house cap.
12. **One why-register**: `OKF/decisions/NNN-<slug>.md`, indexed by the
    question each settles. Absorbs this section and `adr/` (empty at
    absorption — zero migration cost, and evidence three-of-three was
    unusable); the warrant replaces the three-of-three rule. Reversible
    by re-splitting.
13. ROADMAP is a **plan, not an archive** — decisions move to the
    register, debunked claims to LEARNINGS.md (which already duplicates
    them by instruction), §Risks keeps only forward-looking risk.
14. Ferry decisions **graduate at moor** into the register; MAP.md keeps
    a pointer, never a copy.
15. Moor **collapses** `ferries/<topic>/` into `ferries/<topic>.md` —
    problem shape, rejected alternatives, decision pointers. Directory
    means open, file means moored, so `ls` answers what's in flight.
    Deliberation stays recoverable via `sealed:` (jj change id + git
    hash + date) pinned to the **parent** (`@-` at moor) — the sealing
    commit cannot name itself, and the parent is where the D-n files
    still exist. Unresolvable pin = drift. Reversible: OKF is not the
    archive of record, history is.
16. **One `okf-check` validator** at `write-OKF/scripts/`, built to the
    existing doctrine in
    [add-copilot-project-skill/project-validator.md](../skills/engineering/add-copilot-project-skill/project-validator.md);
    write-OKF and moor both gate on its pasted output, so the done-gate
    is a run, not a claim. Per that doctrine it must pass clean on
    octobot today — over-cap pages are a **warning** until phase 7, never
    an error. Reversible by inlining the checks as prose.

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
   `OKF/**.md` returns only `index.md`; after moving a cited symbol,
   refresh reports DRIFT and leaves every judgement zone byte-identical.
7. **Why-register + ferry collapse** — create `OKF/decisions/` (indexed
   by question, warrant frontmatter); migrate decisions 1–15 in, retire
   empty `adr/`, shed debunked claims to LEARNINGS.md. moor gains the
   graduation and collapse steps with the `sealed:` pin; refresh resolves
   pins. **Verify:** ROADMAP ≤110 lines and every decision reachable from
   `decisions/index.md`; `grep -rL "^type:" OKF/` still returns only
   `index.md`; moor a fixture ferry → directory becomes one page,
   decisions numbered, `jj show <change>` resolves; corrupt the pin →
   refresh reports DRIFT. Ships in two blueprints — register first, ferry
   collapse second (graduation needs the register to exist). Both close
   on `okf-check` exiting 0 with output pasted.

**Execution order: 7 → 6.** Phase 7 is small, closes the cap breach now,
and makes octobot's own OKF *run* the register before phase 6 freezes it
into a contract for other repos. Numbers stay as issued — append-only.

> ROADMAP is over the 110-line cap until phase 7 lands. Tracked, not
> ignored — closing it is that phase's first verify clause.

## Risks & gotchas

- Believed: skills can cross-invoke via description matching. True:
  cross-links are file paths, so disable-model-invocation is safe for
  linked skills; only description routing dies. Source: Claude Code
  skill mechanics, README §Install.
- Trigger collisions with co-installed plugins (superpowers, caveman)
  — the invocation audit (phase 5) is the mitigation.
- `jj` mutations backgrounded hang on the headless editor — always
  foreground, use `-m`/`--use-destination-message`
  ([LEARNINGS.md](LEARNINGS.md)).
- Believed: OKF was an octobot coinage. True: OKF v0.1 is also what
  OpenWiki emits, so import-compat is nearly free — but its output model
  (hundreds of generated files, CI-refreshed) is opposite pressure to
  OKF's ≤110-line durable synthesis. Source: langchain-ai/openwiki.
- Declared page plans are convergent prior art, not invention — DeepWiki
  `pages[]{title, purpose, parent}` and deepwiki-skill's `toc.yaml`.
  Decision 9 is the same move minus a config format.
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
