# chart — greenfield loop

For a project with no real roadmap yet. Formerly `plan-project`.

## Process

1. **Survey the repo.** `ls` it. Existing substantial code → this is not
   greenfield; stress-test the plan with
   [grill-with-docs](../../engineering/grill-with-docs/SKILL.md) instead.
2. **Research before asking.** Every tool, product, or codename in the
   pitch you don't recognize with certainty: WebSearch it *first*, report
   findings with sources, then ask what role it plays. Never guess; never
   quiz the user on facts the web answers.
3. **Prior-art scan.** Search for existing tools covering the stated aim.
   Build a gap table (tool | has | lacks). If an exact match exists, say
   so plainly — the honest outcome may be "use that instead". The gap the
   project fills becomes its pitch.
4. **Grill, one question at a time** (wait for each answer). Default
   order — skip what's already answered:
   1. Deliverable shape (library vs service vs CLI — surface
      contradictions in the user's own wording immediately).
   2. Core novelty — pin exact semantics of the differentiating feature;
      offer 2–3 concrete interpretations to pick from.
   3. Interaction surface (API/MCP/UI/CLI) — recommend the cheapest that
      satisfies the aim when asked.
   4. Key tech picks — recommend with reasons, note reversibility;
      challenge claims that don't hold (benchmarks, scope).
   5. Persistence/storage and lifecycle (updates, triggers).
   6. v1 scope boundary (languages, platforms, integrations).
5. **Pin vocabulary as you go** — one resolved term → one inline
   `OKF/CONTEXT.md` edit (confirm the first write).
6. **Write `OKF/ROADMAP.md`** when answers stop moving decisions, using
   the skeleton in [SKILL.md](SKILL.md). If `OKF/` is missing, run
   [write-OKF](../write-OKF/SKILL.md) scaffold first.
7. **Hand forward**: name the Phase-0 items ready for
   [blueprint](../blueprint/SKILL.md), and the scaffold skill
   ([build-py-project](../../scaffold/build-py-project/SKILL.md) /
   [build-r-package](../../scaffold/build-r-package/SKILL.md) /
   [build-r-analysis](../../scaffold/build-r-analysis/SKILL.md)) that
   fits the locked stack.

## Done
- Roadmap complete per SKILL.md criteria; no code written; user saw and
  approved every locked decision.
