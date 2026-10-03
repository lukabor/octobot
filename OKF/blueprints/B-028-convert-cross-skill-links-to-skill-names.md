---
type: Blueprint
status: implemented
traces-to: ROADMAP.md phase 14
sounded: 2026-09-23
cites:
  - OKF/ROADMAP.md
  - OKF/decisions/R-023-cross-skill-references-are-unchecked-skill-names.md
  - skills/loop/write-okf/scripts/link-check
  - skills/productivity/conjure-a-skill/scripts/skill-check
  - README.md
muster: true
review-base: myplnols
tally:
  intent: convert 290 cross-skill links to unchecked /skill-name prose
    so skill content resolves under any install depth, and stand up the
    replacement lint plus install tooling
  matches: yes
---

# 028 — convert cross-skill links to unchecked skill names

## Justification

[ROADMAP.md phase 14](../ROADMAP.md) — the skills tree must resolve under
any install (symlink, flat copy, whole-tree). [023](../decisions/R-023-cross-skill-references-are-unchecked-skill-names.md)
already locked the mechanism: a cross-skill reference becomes a
backtick-wrapped `` `/skill-name` ``, never a path — mattpocock/skills'
own convention, verified upstream. This blueprint is the mechanical
conversion 023 left undone.

## Contract

Every markdown link in `skills/` whose target is a *different skill*
(`](../<name>/...)`, same category, or `](../../<category>/<name>/...)`,
cross category) is rewritten to plain prose: `` `/skill-name` `` —
backtick-wrapped, leading slash, kebab-case, the skill folder's own
name, no brackets, no path. 290 such links across 59 files. The
surrounding sentence is edited only as much as the changed reference
requires — no unrelated rewording.

**Untouched, explicitly:**
- The 7 links from a skill file to something repo-root-only — 5 into
  `OKF/decisions/`, 2 into `../../../CLAUDE.md` — stay real relative
  paths, `link-check` keeps validating them.
- A skill's link to its own sibling file (never names another skill) —
  stays a real relative path.
- `skills/engineering/add-copilot-project-skill/skill-templates.md:104`
  — a `](../AGENTS.md)` example inside a fenced block, template output
  for a *consumer* project's own `AGENTS.md`, not an octobot link.
  `link-check` already skips fenced blocks for this reason; the
  conversion does too.

**New lint**, `skill-ref-check` (new script,
`skills/productivity/conjure-a-skill/scripts/skill-ref-check`, sibling to
`skill-check`, same single-purpose-validator convention): scans `skills/`
for `` `/skill-name` `` mentions, errors on any that don't match an
existing `skills/*/<name>/` folder. Same CLI contract as `skill-check`
(`skill-ref-check <skills-dir>`, exit 1 on any error).

**New script**, `scripts/link-skills.sh` (repo root — first file in a
`scripts/` directory at that level): symlinks every `skills/*/*/`
directory into both `~/.claude/skills/<name>` and
`~/.agents/skills/<name>`, mirroring mattpocock/skills'
`scripts/link-skills.sh` (existing symlink or non-symlink file at the
target path is removed and relinked; a destination that is itself a
symlink into this repo aborts with an error instead of self-linking).

**README.md** `## Install` section: the manual `for s in skills/*/*/`
loop is replaced with a pointer to running `scripts/link-skills.sh`. A
new paragraph documents `npx skills@latest add <owner/repo>` as the
install path for non-Claude-Code harnesses — the command is documented,
not live-verified here, since `lukabor/octobot` is private and unpushed
(user's call, tracked separately, not this blueprint's scope).

## Seams touched

- `skills/**/*.md` — every file carrying one of the 290 links (59 files).
- `skills/productivity/conjure-a-skill/scripts/skill-ref-check` (new) —
  entry point `skill-ref-check <skills-dir>`.
- `scripts/link-skills.sh` (new) — entry point `scripts/link-skills.sh`,
  no arguments.
- `README.md` — `## Install` section.

## Verify

```sh
cd <repo-root>

# 1. every cross-skill link is gone; the 7 escapes, sibling links, and
#    the one fenced-block template example remain
grep -rEn '\]\(\.\./' skills/ | grep -vE '\.\./\.\./\.\./' \
  | grep -v 'skill-templates.md:104' \
  && echo "FAIL leftover cross-skill links" || echo "OK links converted"

# 2. link-check still passes — OKF escapes + sibling links still resolve
skills/loop/write-okf/scripts/link-check . && echo "OK link-check" || echo "FAIL link-check"

# 3. new lint passes clean, and catches a planted typo
skills/productivity/conjure-a-skill/scripts/skill-ref-check skills/ \
  && echo "OK skill-ref-check clean" || echo "FAIL skill-ref-check clean"
B=skills/loop/chart/SKILL.md
printf '\nSee `/skill-that-does-not-exist`.\n' >> $B
skills/productivity/conjure-a-skill/scripts/skill-ref-check skills/ | grep -q 'skill-that-does-not-exist' \
  && echo "OK typo caught" || echo "FAIL typo caught"
head -n -2 $B > $B.tmp && mv $B.tmp $B   # undo exactly the 2 appended lines —
                                          # `jj restore`/`git checkout --` would
                                          # discard any other uncommitted work on $B too

# 4. link-skills.sh symlinks resolve into this repo
scripts/link-skills.sh
for d in ~/.claude/skills ~/.agents/skills; do
  for s in skills/*/*/; do
    n=$(basename "${s%/}")
    [ "$(readlink -f "$d/$n")" = "$(readlink -f "$s")" ] \
      && echo "OK $d/$n" || echo "FAIL $d/$n"
  done
done

# 5. tree still green
skills/loop/write-okf/scripts/render-check .
skills/loop/write-okf/scripts/okf-check OKF/
skills/productivity/conjure-a-skill/scripts/skill-check skills/
```

Every check prints `OK`, no `FAIL` appears; all three tallies read
`0 error(s), 0 warning(s)` (skill-check's pre-existing 9 warnings are a
different, unrelated baseline — unchanged by this blueprint). `npx
skills@latest add <owner/repo>` is documented in README.md but not run
here — it needs the repo public, a separate decision.

## Out of scope

- Flattening `skills/<category>/<name>/` itself — 023 rejected this.
- An install-time link-rewrite script — 023 rejected this.
- Making `lukabor/octobot` public, or pushing `main` — separate,
  user-gated decisions (see `HANDOFF.md`).
- The 7 links from skill files into `OKF/decisions/` (5) and
  `../../../CLAUDE.md` (2) — untouched, real paths.
- `~/.agents/skills` actually being scanned by any installed harness —
  `link-skills.sh` populates it to mirror mattpocock's convention;
  whether an agent reads from there is that harness's concern.
