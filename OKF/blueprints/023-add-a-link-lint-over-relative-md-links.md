---
type: Blueprint
status: superseded-by-026
traces-to: ROADMAP.md phase 12
sounded: 2026-07-31
cites:
  - OKF/ROADMAP.md
  - OKF/ARCHITECTURE.md:Cross-links
  - OKF/blueprints/002-extract-why-register.md:ADR-FORMAT.md
  - skills/loop/write-OKF/scripts/_pages.py:dot-directories and blueprints out
  - OKF/blueprints/019-add-a-render-lint-over-the-loop-shape.md:Why a third script
  - OKF/blueprints/017-add-a-line-cap-lint-over-skills.md:Why a sibling script
  - OKF/decisions/016-one-okf-check-validator.md:One `okf-check` validator
  - skills/productivity/conjure-a-skill/scripts/skill-check:usage: skill-check
  - skills/loop/write-OKF/SKILL.md:run and output pasted
---

# 023 — add a link lint over relative markdown links

## Justification

[ROADMAP.md](../ROADMAP.md) phase 12 names this as its **Precondition**: the
rename moves 26 of the 421 non-external link targets in `skills/`, across 14
files, and nothing validates any of them. Phase 12's own grep proves the old
names are *absent* — it cannot prove the new paths *resolve*, so a typo'd
replacement passes it silently.

**The links are load-bearing, and silent when broken.** A skill installs as a
symlink into `~/.claude/skills/<name>/`; `..` traverses it physically, so a
link written for the repo layout resolves identically from the installed base
directory (verified for `../../engineering/…` and `../../../OKF/…`). But
nothing follows a link automatically — the agent reads it, and a dangling one
surfaces as a failed read, not an error. No runtime signal: hence a static one.

**The obligation exists; only its enforcement is missing.**
[ARCHITECTURE.md](../ARCHITECTURE.md) §Seams states it as prose — *"category
moves are renames across these links (grep before moving)"*. This repo has
mechanised that same shape three times, each after prose failed to hold:
[017](017-add-a-line-cap-lint-over-skills.md) the line cap,
[019](019-add-a-render-lint-over-the-loop-shape.md) the loop diagram,
[020](020-enforce-the-prune-and-validate-every-cite.md) the prune.

**What sounding found.** A naive walk reports **28** unresolvable links; two
principled exclusions account for 26. **17 sit inside fenced code blocks** —
templates and worked examples, where a link is illustration, not navigation.
**9 sit in `OKF/blueprints/`** — sealed history, some genuinely stale (one
cites `DECISION-FORMAT.md`, renamed by [002](002-extract-why-register.md));
linting it would force a rename to edit a sealed record, which append-only
forbids, and `render-check` excludes `blueprints/` for the same reason. That
leaves **2** real defects, both ellipsis placeholders in the very skill this
phase renames — `architect/SKILL.md:55` `[NNN](…)` and `revise.md:16`
`[NNN](blueprints/…)`: links to nothing, pretending to be links. Repaired
here, since a lint that cannot go green is no precondition at all.

**Why a fourth script.** `okf-check` validates frontmatter `cites:`, not prose
links; `skill-check` counts lines; `render-check` compares fenced blocks. None
resolves a link target, and widening one changes the argv contract
[019](019-add-a-render-lint-over-the-loop-shape.md) §*Why a third script* set
for this case. [016](../decisions/016-one-okf-check-validator.md) is not
crossed: it settles how *OKF conformance* is enforced, and 017 already shipped
a second validator under it.

## Contract

**A script at `skills/loop/write-OKF/scripts/link-check`, taking a repo root:
`link-check <repo-root>`.** It mirrors its three siblings — same argv shape,
`WARN `/`ERROR ` prefixes, closing `N error(s), M warning(s)` tally, exit
codes (1 on any error, 0 otherwise, 2 on usage), and `python3` shebang.

**What it walks.** Every `*.md` from the repo root, **dot-directories and
`OKF/blueprints/` skipped** — `render-check`'s walk, exactly. The root is the
repo, not either subtree, because the loop's links cross `skills/`↔`OKF/` both
ways. `decisions/`, `learnings/` and `ferries/` stay linted: they hold no path
into a renameable skill directory. **Fenced blocks are skipped** — a line
opening or closing a ``` fence toggles the skip, and links between them are
not read.

**What counts as a link, and how it resolves.** The target inside `](...)`,
excluding any beginning `http://`, `https://`, `mailto:` or `#`. Split the
fragment off at `#`, resolve the remaining path against the **containing
file's directory**; it resolves if that path exists — existence only, so a
directory target resolves as a directory.

**What it reports.** One `ERROR` line per unresolvable link — repo-relative
file, 1-indexed line, raw target: `ERROR skills/loop/moor/SKILL.md:41:
unresolvable link: ../architect/SKILL.md`. Errors only; an unresolvable link
is always a defect, so there is no warning band, though the tally still prints
both counts — `render-check` hardcodes `0 warning(s)` for the same reason.

**Where it lives, and registration.** Under `write-OKF/scripts/` beside
`okf-check` and `render-check`, per
[019](019-add-a-render-lint-over-the-loop-shape.md)'s placement rule.
`write-OKF/SKILL.md`'s *run and output pasted* line grows to name it.

**The two repairs.** `architect/SKILL.md:55` and `architect/revise.md:16` stop
being links: `[NNN](…)` becomes `` `NNN` ``, `[NNN](blueprints/…)` becomes
`` `blueprints/NNN-<slug>.md` ``. Same information, no dangling target.

## Seams touched

- `skills/loop/write-OKF/scripts/link-check` — the CLI (argv arity, exit codes
  0/1/2, `ERROR ` format, tally) and target classification (skipped: external,
  fragment-only, fenced, under `OKF/blueprints/`).
- `skills/loop/write-OKF/SKILL.md` — the run-and-paste obligation.
- `skills/loop/architect/SKILL.md`, `skills/loop/architect/revise.md` — the
  two ellipsis placeholders, as prose not links.

## Verify

```sh
cd <repo-root>; LINT=skills/loop/write-OKF/scripts/link-check
B=skills/loop/moor/SKILL.md; L='[x](../nonexistent-abc/SKILL.md)'
F=$(printf '\140\140\140')   # a fence, without closing this one

$LINT . && echo "OK clean" || echo "FAIL clean"   # two repairs make this reachable
printf '\n%s\n' "$L" >> $B                        # the check can fail
$LINT . | grep -q "ERROR $B:[0-9]*: .*nonexistent-abc" && echo "OK caught" || echo "FAIL caught"
$LINT . >/dev/null; [ $? -eq 1 ] && echo "OK exit1" || echo "FAIL exit1"
jj restore $B                                     # git: git checkout -- $B
printf '\n%s\n%s\n%s\n' "$F" "$L" "$F" >> $B      # a fenced break is illustration
$LINT . >/dev/null && echo "OK fenced" || echo "FAIL fenced"
jj restore $B
$LINT . | grep -q 'OKF/blueprints/' && echo "FAIL bp" || echo "OK bp"
$LINT >/dev/null 2>&1; [ $? -eq 2 ] && echo "OK usage" || echo "FAIL usage"
$LINT /nonexistent >/dev/null 2>&1; [ $? -eq 2 ] && echo "OK root" || echo "FAIL root"
$LINT . | grep -qE 'https?://|mailto:' && echo "FAIL ext" || echo "OK ext"
```

Every check prints `OK`, no `FAIL` appears, and the clean-tree tally reads
`0 error(s), 0 warning(s)`.

## Out of scope

- **Moving the 26 links phase 12 breaks** — phase 12's work; this builds the
  net. Only the two ellipsis placeholders are repaired here, without which the
  lint cannot reach green and the precondition is unsatisfiable.
- **Repairing the 9 stale links inside `OKF/blueprints/`** (`003:21`,
  `010:19-21,66`) — sealed history; the exclusion is the ruling, not an
  oversight.
- **Inline-code spans.** A link inside backticks in prose is still read. No
  live page does that outside a fence, so a rule would fail
  [sieve](../../skills/engineering/sieve/SKILL.md)'s Real test.
- **Anchor validation, external URL liveness, reference-style links, HTML
  `<a href>`, non-`.md` files.** Different failure modes; a rename breaks the
  path of an inline markdown link, which is the whole surface the loop uses.
- **Wiring beyond the run-and-paste line** — no justfile, hook or CI; the
  three existing lints are obliged by prose alone.
- **Absorbing any sibling into one validator** — four scripts sharing one argv
  contract is [019](019-add-a-render-lint-over-the-loop-shape.md)'s settled
  shape.
