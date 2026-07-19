---
name: add-copilot-project-skill
description: Scaffold a .github/skills set (Copilot cloud agent format) for a repo's extension tasks, with validator.
disable-model-invocation: true
---

# add-copilot-project-skill

Build a set of *project* skills that live in the repo and lower the error rate
on its recurring extension tasks (add a data source, a module, a pipeline node,
a report section). The skills follow the **GitHub Copilot cloud coding agent
skill format** ([docs](https://docs.github.com/en/copilot/how-tos/copilot-on-github/customize-copilot/customize-cloud-agent/add-skills)):
`.github/skills/<name>/SKILL.md`, autodiscovered, routed by description
matching — no slash-invocation step required.

## When to use
- A repo has a repeatable, multi-step extension task with silent failure modes
  (something declared but not registered; a name that must match in two places).
- The team uses GitHub Copilot's cloud agent (issue assignment / `@copilot` in
  PR comments) and wants guided, in-repo workflows.
- The user wants the SKILLS authoring conventions (frontmatter, "Use when"
  trigger, ≤100-line progressive-disclosure body) targeting Copilot.

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
3. **Write the always-on conventions** — `AGENTS.md` carries the house style.
   `.github/copilot-instructions.md` is a thin redirect to `AGENTS.md` plus a
   **skills menu** that names each skill with its trigger phrases (improves
   discoverability beyond description matching alone). Templates in
   [skill-templates.md](skill-templates.md).
4. **Author the leaf skills** (one per artifact task) and **parent skills** (one
   per composite/modality) at `.github/skills/<name>/SKILL.md`. Each is a thin,
   conversation-style stub: interview first, point at **live repo files** as
   the example (zero drift), end at the validator, then **hand off to the next
   skill by name and pause** — the cloud agent decides per turn whether to load
   a sibling skill, so never auto-chain. Layout and the handoff rule are in
   [layout-and-surfaces.md](layout-and-surfaces.md).
5. **Add path-scoped instructions** at `.github/instructions/<name>.instructions.md`
   with `applyTo:` globs. These auto-load when a contributor opens a matching
   file, surfacing the relevant skill's name and the project-specific gotchas
   without requiring an explicit prompt.
6. **Verify**: run `just validate` on a clean tree (expect zero errors); confirm
   every path a skill cites actually exists; deliberately break one invariant
   and confirm the validator catches it, then revert. Assign a test issue to
   Copilot that should match one skill's `description:` and confirm the
   agent's plan paraphrases lines from that `SKILL.md`.

## Output / done criteria
- `.github/skills/<name>/SKILL.md` for each task (canonical, autodiscovered);
  `.github/instructions/<name>.instructions.md` for each editable surface;
  `AGENTS.md` (canonical house style); `.github/copilot-instructions.md` (thin
  redirect + skills menu); a working `scripts/validate_extension.*` wired as
  `just validate`.
- Validator passes clean on the main branch and fires on an injected break.
- Skills reference live files, interview first, and hand off explicitly.
- The cloud agent loads the matching skill when given a trigger-phrase prompt.

## Guardrails
- **Single-source.** The procedure lives in the repo's `docs/`; `SKILL.md`
  bodies are stubs that link to it. `AGENTS.md` is the single source of style;
  never duplicate its content into `copilot-instructions.md`.
- **No auto-chaining.** Parents guide; they don't silently run children. The
  cloud agent's description matcher routes per turn — name the next skill and
  let the user (or the agent's own next decision) re-enter.
- **Validator must pass clean first.** Tune severities to the existing tree, or
  contributors learn to ignore it. Don't invent invariants the repo doesn't hold.
- **Description matching is the discovery surface.** Lead each `description:`
  with "Use when the user says ..." trigger phrases. Two skills sharing a
  trigger collide; sharpen the differentiators.
- This skill produces *another repo's* skills — keep its own SKILL.md generic;
  the worked specifics belong in the target repo's docs and live examples.
