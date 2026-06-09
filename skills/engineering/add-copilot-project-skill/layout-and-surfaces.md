# Layout, surfaces, and the handoff rule

How the dual-surface, single-source skill set is arranged in a target repo.

## File layout

```
docs/                              canonical procedures (the body — extend, don't duplicate)
AGENTS.md                          always-on house conventions
skills/<name>/SKILL.md             canonical skill, Claude Code SKILLS structure
.github/
  copilot-instructions.md          always-on conventions, Copilot-wide
  prompts/<name>.prompt.md          Copilot front door (/name in Copilot Chat)
scripts/validate_extension.*       the mechanical checkpoint (just validate)
```

The real procedure stays in `docs/`. `SKILL.md` and `.prompt.md` are **stubs**:
a trigger line, a short decision tree, the checklist, and links into `docs/`
plus the live example files. One canonical body, two front doors.

## Claude Code SKILLS structure → Copilot mapping

| SKILLS convention | Copilot surface |
|---|---|
| `skills/<name>/SKILL.md` (`/name`) | `.github/prompts/<name>.prompt.md` (`/name`) |
| project memory / conventions | `.github/copilot-instructions.md` (always on) |
| auto-trigger by `description` | `.github/instructions/*.instructions.md` with `applyTo:` globs |
| supporting topic files | shared `docs/*.md` referenced by both |

The canonical skill is authored in the SKILLS structure (frontmatter, "Use
when" trigger, ≤100-line body); the `.prompt.md` mirror points back to it so the
two cannot drift. (If the team also runs Claude Code, symlink or copy
`skills/<name>` into `.claude/skills/<name>` to make it `/`-invocable there too.)

## Two axes of skills

- **Leaf skills** — one per *artifact* a contributor edits (a config, a module,
  a pipeline node, a report section). Standalone-invocable.
- **Parent skills** — one per *composite* task, sliced by the dimension the
  contributor actually thinks in (e.g. data modality: single-cell / bulk /
  spatial). A parent interviews, then walks the leaves.

## The handoff rule (why no auto-chaining)

A Copilot `.prompt.md` **cannot programmatically invoke another prompt** — the
user types `/next-skill` themselves. So parents must use **guided handoff**:
complete one stage, run the validator, then name the exact next skill and
**pause**. Author Claude `SKILL.md` parents the same way, for parity and so the
contributor stays in the loop and learns the sequence. Never bury the chain.

## Skill anatomy (leaf or parent)

1. **Interview first** — gather the few facts that decide the rest before
   generating anything.
2. **Point at a live example** — "copy the shape of `<real/file/in/repo>`".
   Live references never drift; frozen snippets do.
3. **Do the edits** — the minimal set, in the repo's house style.
4. **Validate** — end at `just validate --changed`; interpret its errors.
5. **Hand off** — name the next skill (or declare done) and stop.
