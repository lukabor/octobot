---
name: add-copilot-project-skill
description: Scaffold a project-specific skill set that guides contributors through a repo's repeatable, error-prone extension tasks — consumed by GitHub Copilot, authored in the Claude Code SKILLS structure, single-sourced from the repo's own docs, and backed by a mechanical validator. Tuned for config-driven pipelines (e.g. R `{targets}` projects). Use when the user says "add copilot project skills", "turn our onboarding/extension workflow into skills", "guide contributors to add datasets/modules/targets/chapters", "make a Copilot skill set for this repo", "/add-copilot-project-skill".
---

# add-copilot-project-skill

Build a set of *project* skills that live in the repo and lower the error rate
on its recurring extension tasks (add a data source, a module, a pipeline node,
a report section). The skills are authored once in the **Claude Code SKILLS
structure** and surfaced to **GitHub Copilot** via prompt files — one body, two
front doors, no drift.

## When to use
- A repo has a repeatable, multi-step extension task with silent failure modes
  (something declared but not registered; a name that must match in two places).
- The team uses GitHub Copilot and wants guided, in-repo workflows.
- The user wants Claude Code SKILLS conventions but Copilot as the consumer.

## Process
1. **Interview the repo, not just the user.** Read the existing contributor
   docs, the task runner (`justfile`/`make`), and the directories a contributor
   edits. Identify, with the user:
   - the 3–6 **extension tasks** worth a skill each (the *artifacts*);
   - which tasks compose into a larger one (the *modalities/parents*);
   - the **silent failure modes** — invariants that, if violated, fail late or
     never (these become the validator). See [project-validator.md](project-validator.md).
2. **Build the validator first** — everything else leans on it. A standalone
   script (`scripts/validate_extension.*`, wired as `just validate`) that checks
   the invariants, scoped to changed files, tuned to pass clean on the main
   branch. Details + the AST-parsing and severity rules in
   [project-validator.md](project-validator.md).
3. **Write the always-on conventions** — `AGENTS.md` and
   `.github/copilot-instructions.md` carry the house style so every suggestion
   inherits it without a skill being invoked. Templates in
   [skill-templates.md](skill-templates.md).
4. **Author the leaf skills** (one per artifact task) and **parent skills** (one
   per composite/modality). Each is a thin, conversation-style stub: interview
   first, point at **live repo files** as the example (zero drift), end at the
   validator, then **hand off to the next skill by name and pause** — Copilot
   cannot auto-invoke a sub-prompt, so never auto-chain. Layout, the
   Claude↔Copilot mapping, and the handoff rule are in
   [layout-and-surfaces.md](layout-and-surfaces.md).
5. **Mirror each skill to `.github/prompts/<name>.prompt.md`** — a stub that
   points back to its canonical `SKILL.md` so the two cannot drift.
6. **Verify**: run `just validate` on a clean tree (expect zero errors); confirm
   every path a skill cites actually exists; deliberately break one invariant
   and confirm the validator catches it, then revert.

## Output / done criteria
- `skills/<name>/SKILL.md` (canonical) + `.github/prompts/<name>.prompt.md`
  (mirror) for each task; `AGENTS.md` + `.github/copilot-instructions.md`;
  a working `scripts/validate_extension.*` wired as `just validate`.
- Validator passes clean on the main branch and fires on an injected break.
- Skills reference live files, interview first, and hand off explicitly.

## Guardrails
- **Single-source.** The procedure lives in the repo's `docs/`; `SKILL.md` and
  `.prompt.md` are stubs that link to it. Never copy a procedure into both.
- **No auto-chaining.** Parents guide; they don't silently run children.
- **Validator must pass clean first.** Tune severities to the existing tree, or
  contributors learn to ignore it. Don't invent invariants the repo doesn't hold.
- This skill produces *another repo's* skills — keep its own SKILL.md generic;
  the worked specifics belong in the target repo's docs and live examples.
