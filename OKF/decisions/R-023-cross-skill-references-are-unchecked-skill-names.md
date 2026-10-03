---
type: Decision
purpose: Stop cross-skill links from breaking whenever the skills tree
  installs somewhere its category depth does not survive.
answers:
  - "How does one skill's prose reference another skill?"
cites:
  - OKF/ROADMAP.md
  - skills/loop/write-okf/scripts/link-check
status: live
reversible: yes — costly (290 links, 59 files), but nothing else depends
  on the prose form
---

# 023 — a cross-skill reference is an unchecked `/skill-name`, not a path

`skills/<category>/<name>/SKILL.md` files reference each other with
`../<name>/` (same category) or `../../<category>/<name>/` (cross
category) links — 290 of them across 59 files. Every harness that
installs a skill outside this repo drops the category level: Copilot's
`.github/skills/<name>/`, and `npx skills add <owner/repo>` (skills.sh),
both copy or symlink one skill directory to a flat `<name>/`. A relative
link written for a source at some depth breaks the moment its target
sits at a different one, on either end of the link — one level deep
breaks exactly as fast as two.

**Decision: a cross-skill reference in prose is a backtick-wrapped,
leading-slash, kebab-case skill name — `` `/skill-name` `` — never a
markdown link, never a path.** This is mattpocock/skills' own
convention (verified against `skills/engineering/ask-matt/SKILL.md`
upstream, which routes to a dozen sibling skills by name only, zero
path links between skill directories) and it survives every install
shape by construction: a name has no depth to break.

Two link kinds are explicitly **not** touched by this decision:
- **Same-skill sibling files** (a bare filename link to a skill's own
  supporting doc) never cross a category boundary and stay real
  relative links.
- **A skill citing something else repo-root-only** — `OKF/decisions/`
  (5) or `../../../CLAUDE.md` (2), 7 such escapes today — stays a real,
  `link-check`-validated path. No installer copies either out of this
  repo, so those citations only ever need to resolve here.

## Considered options

**Flatten the repo itself to `skills/<name>/`**, matching the installed
shape 1:1, was rejected — the user wants the repo organized by category
for browsing; category becomes frontmatter loses that.

**An install-time transform script**, rewriting `../../category/x` to
`../x` per install target, was rejected as machinery to build and
maintain per harness, solving a problem the name-based convention
sidesteps for free.

## Consequences

- `link-check` stops validating these 290 references as resolvable
  paths — it never could validate a bare name as a path anyway. A
  typo'd `` `/skill-nmae` `` now fails silently unless a separate
  checker exists.
- A new lint is required: scan `skills/` for `` `/skill-name` ``
  mentions, confirm a matching skill folder exists. This is the
  replacement coverage, not `link-check` extended — it checks name
  existence, not path resolution.
- `scripts/link-skills.sh` (new, mirrors mattpocock's own dev script)
  and `README.md`'s pointer to `npx skills@latest add <owner/repo>` are
  the two install paths this decision makes safe; neither existed
  before.
