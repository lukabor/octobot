# octobot Roadmap

Octobot becomes a loop-engineering metaharness: the loop
(scribe-OKF → architect → blueprint → ferry → implement) over an OKF
substrate, alongside the existing practice/scaffold skills. Vocabulary:
[CONTEXT.md](CONTEXT.md).

## Why (gap vs prior art)

| repo | has | lacks |
|---|---|---|
| mattpocock/skills | spec/ticket pipeline, tracker-backed | file-based substrate, jj, R/Py ecosystem, debloat/review axes |
| obra/superpowers | subagent execution, verification gate | persistent wiki memory, ecosystem scaffolds |
| octobot pre-2026-07 | review axes, scaffolds, jj discipline | plan→spec→implement spine, knowledge substrate |

Octobot's slot: file-based loop over OKF (open-knowledge-format), jj-native.

## Locked decisions

1. OKF = open-knowledge-format at target project's `./OKF/` — reversible
   (it's files). Karpathy-LLM-wiki style; OpenWiki-inspired, dependency-free.
2. architect replaces plan-project + update-project (mode-routed) —
   reversible by re-splitting.
3. Specs are files with status frontmatter, not tracker issues — the
   "tracker" is grep. Reversible via export.
4. One canonical glossary per bounded context, never per issue.
5. Handoff gate: no mutating subagent without a brief (goal, OKF/spec
   refs, verify command); read-only lookups exempt.
6. New skill names: imperative-verb-first; legacy names grandfathered.

## Architecture

See [ARCHITECTURE.md](ARCHITECTURE.md); loop diagram in `README.md`.

## Phases

1. **OKF foundation** — scribe-OKF, architect, path retargets, octobot's
   own OKF. **Verify:** scaffold produces layout-conformant tree in an
   empty dir; refresh on octobot yields sane OKF/; zero stale
   plan-project/update-project refs. ✅ verified 2026-07-19 (scratch-dir
   scaffold + this OKF + grep).
2. **blueprint + review-blueprint** — spec skill with spec-format.md;
   fourth review axis (diff vs spec). **Verify:** blueprint a real
   roadmap item into a well-formed spec; review-blueprint flags an
   injected scope-creep diff.
3. **ferry + implement** — decision maps; spec-driven execution with the
   verify gate and handoff-gated subagent dispatch. **Verify:** ferry a
   multi-session feature into ≥3 edged decisions; implement one locked
   spec end-to-end with pasted Verify output.
4. **Upstream pulls** — tautological-test + pre-agreed seams into bdd;
   handoff redaction/reference rules; resolve-conflicts (jj port).
   **Verify:** resolve-conflicts replayed on a synthetic two-sided
   conflict; house caps hold.
5. **Invocation audit + steer** — disable-model-invocation on
   orchestrators/rituals; steer router; conjure imperative-verb
   enforcement; README regen. **Verify:** fresh session lists only the 8
   model-invoked descriptions; steer names every skill; conjure rejects
   a noun-first name.

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

## Out of scope

- Issue-tracker backends (GitHub/GitLab) for specs — files only.
- OpenWiki CLI dependency — import-compat at most.
- Renaming grandfathered non-verb skills.
- Matt's writing-* / teach / wizard / obsidian skill families.
