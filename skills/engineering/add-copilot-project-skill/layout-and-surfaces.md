# Layout, surfaces, and the handoff rule

How the GitHub-native skill set is arranged in a target repo.

## File layout

```
docs/                              canonical procedures (the body — extend, don't duplicate)
AGENTS.md                          always-on house conventions (the single source)
.github/
  copilot-instructions.md          thin redirect to AGENTS.md + skills menu
  skills/<name>/SKILL.md           canonical skill — autodiscovered by GitHub cloud agent
  instructions/<name>.instructions.md  path-scoped auto-apply rules (applyTo glob)
scripts/validate_extension.*       the mechanical checkpoint (just validate)
```

The real procedure stays in `docs/`. Each `SKILL.md` is a **stub**: a trigger
description, a short decision tree, the checklist, and links into `docs/` plus
the live example files. One canonical body per topic, no mirrors.

## Why this layout

The GitHub Copilot cloud coding agent autodiscovers any `SKILL.md` under
`.github/skills/` and decides which to load based on description matching
against the user's prompt. Recognised alternates: `.claude/skills/` and
`.agents/skills/` (same semantics, different consumer expectations).

`AGENTS.md` is the cross-tool always-on standard (also read by Cursor, Codex,
Cline, and Claude Code). `.github/copilot-instructions.md` exists as a
Copilot-documented path; in this layout it's a thin redirect to `AGENTS.md`
with a discoverability menu of the skills — content lives in one place.

`.github/instructions/*.instructions.md` is a separate mechanism: each file
auto-applies when an editor file matches its `applyTo:` glob. They reference
the matching skill by name, so a contributor editing a config file gets the
relevant skill surfaced without having to ask.

## Two axes of skills

- **Leaf skills** — one per *artifact* a contributor edits (a config, a module,
  a pipeline node, a report section). Each is independently triggerable by its
  own description phrases.
- **Parent skills** — one per *composite* task, sliced by the dimension the
  contributor actually thinks in (e.g. data modality: single-cell / bulk /
  spatial). A parent interviews, then walks the leaves.

## The handoff rule (why no auto-chaining)

The cloud agent loads skills **per turn**, not in a chain. A parent skill that
silently runs five children produces one wall of output the contributor can't
intervene in. So parents use **guided handoff**: complete one stage, run the
validator, then name the exact next skill and **pause**. The agent's next turn
re-routes via description matching — explicit, observable, debuggable.

## Skill anatomy (leaf or parent)

1. **Interview first** — gather the few facts that decide the rest before
   generating anything.
2. **Point at a live example** — "copy the shape of `<real/file/in/repo>`".
   Live references never drift; frozen snippets do.
3. **Do the edits** — the minimal set, in the repo's house style.
4. **Validate** — end at `just validate --changed`; interpret its errors.
5. **Hand off** — name the next skill (or declare done) and stop.

## Frontmatter spec (matches GitHub's docs)

| Field | Requirement | Notes |
|---|---|---|
| `name:` | required | Lowercase, hyphen-separated; matches the directory name |
| `description:` | required | What it does AND when to use it (trigger phrases) — drives the cloud agent's matching |
| `license:` | optional | If the skill is shareable across repos |
| `allowed-tools:` | optional | Pre-approves named tools (`bash`, `shell`) — security risk; use only on read-only skills like `validate-*` |

Companion files in the same skill directory (R scripts, JSON templates,
reference snippets) are autodiscovered alongside the SKILL.md.
