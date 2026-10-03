---
type: Blueprint
status: implemented
traces-to: user request 2026-07-30
sounded: 2026-07-30
cites:
  - skills/productivity/conjure-a-skill/SKILL.md:topic-named siblings
  - skills/loop/write-okf/scripts/okf-check:cite_resolves
---

# 014 — unify skill sibling-file naming on lowercase-kebab topic names

## Justification

Two findings from the 2026-07-24 skills consistency review (F2, F3): sibling
offload files split between UPPERCASE (8 files) and lowercase-kebab (41), and
two skills offload to a generic `REFERENCE.md` while
[conjure-a-skill](../../skills/productivity/conjure-a-skill/SKILL.md) step 4
mandates **topic-named siblings**, "one topic per file, named for the topic".

The review framed F2 as the newest work violating the house rule. It is not —
`CLAUDE.md` §5 says *"Split into `REFERENCE.md` / `EXAMPLES.md` if it grows"*,
so `moor/REFERENCE.md` obeyed CLAUDE.md and broke conjure-a-skill. **The
defect is a contradiction between the two authorities, and renaming files
without resolving it leaves the next skill author to recreate the violation.**
This blueprint fixes the doctrine first, then the files.

Ordering: this precedes the line-cap fixes (F1, `call-charon` and
`commit-atomic-jj` both at 117) because those splits create new sibling files.
Settle the naming rule, then split under it, or the same files get touched
twice.

## Contract

**One naming rule, stated once.** A skill's offload files are named for their
topic in lowercase-kebab (`deepening.md`, `anti-patterns.md`). `REFERENCE.md`,
`EXAMPLES.md`, and any generic or UPPERCASE sibling name are non-conforming.
`SKILL.md` keeps its uppercase name — it is the entry point, not an offload.

Two authorities state it, without conflict:
- `CLAUDE.md` §5 — the `≤ 110 lines` bullet stops prescribing
  `REFERENCE.md` / `EXAMPLES.md` and points at topic-named siblings instead.
- `conjure-a-skill` step 4 — its existing topic-named-siblings sentence gains
  the casing rule it currently omits.

**Eight files renamed**, content unchanged except where a link inside them
points at a renamed sibling:

| current | becomes |
|---|---|
| `engineering/design-codebase/DEEPENING.md` | `deepening.md` |
| `engineering/design-codebase/DESIGN-IT-TWICE.md` | `design-it-twice.md` |
| `engineering/model-domain/CONTEXT-FORMAT.md` | `context-format.md` |
| `engineering/model-domain/DECISION-FORMAT.md` | `decision-format.md` |
| `engineering/write-readme/REFERENCE.md` | `ecosystems.md` |
| `loop/moor/REFERENCE.md` | `graduate.md` + `collapse.md` |
| `productivity/conjure-a-skill/GLOSSARY.md` | `glossary.md` |
| `productivity/conjure-a-skill/PRINCIPLES.md` | `principles.md` |

`moor/REFERENCE.md` splits in two because it holds two topics (`#graduate`,
`#collapse`) and the rule is one topic per file; moor's two links lose their
anchors and address the files directly. Every other rename is one file to one
file, moved with `jj`-visible `mv` so history follows.

**Every inbound reference updated** — 33 references across 21 files: `skills/`,
`README.md`, `CLAUDE.md`, and four OKF `cites:` blocks (`OKF/CONTEXT.md`,
`OKF/ARCHITECTURE.md`, `OKF/decisions/004`, `OKF/decisions/012`). The `cites:`
updates are mandatory, not cosmetic:
`okf-check:cite_resolves` feeds `errors`, not `warnings`, so a stale cite fails
the run outright. `AGENTS.md` and every `scripts/` helper reference none of
these files — checked, not assumed.

**Historical blueprints are left alone.** Three name the old paths inside
`Contract` sections: `001` (`dropped`), `003` and `013` (both `implemented`).
Their Contracts are immutable per
[blueprint-format.md](../../skills/loop/blueprint/blueprint-format.md) — they
record what was true when sealed, and a record edited to match the present is
no longer a record. They keep their text, as does `OKF/index.md`'s 013 title.

**One upstream URL keeps its uppercase.**
`model-domain/context-format.md` closes with an attribution link to
`mattpocock/skills/.../CONTEXT-FORMAT.md`. That is a real path in another
repository, not a local reference, and is not rewritten.

## Seams touched

- `CLAUDE.md` §5 — the sibling-naming bullet.
- `skills/productivity/conjure-a-skill/SKILL.md` step 4 — the
  progressive-disclosure bullet.
- The 8 renamed files and their 33 referring sites across 21 files.
- `OKF/` frontmatter `cites:` — 4 pages, read by
  `skills/loop/write-okf/scripts/okf-check`.

## Verify

```bash
old='REFERENCE\.md|GLOSSARY\.md|PRINCIPLES\.md|CONTEXT-FORMAT\.md|DECISION-FORMAT\.md|DEEPENING\.md|DESIGN-IT-TWICE\.md'
stale=$(grep -rnE "$old" --include='*.md' skills README.md CLAUDE.md OKF \
  | grep -vE '^OKF/(blueprints/(001|003|013|014)|index\.md)' | grep -v 'https\?://')
upper=$(find skills -type f -name '*.md' ! -name 'SKILL.md' | grep -E '/[A-Z][A-Z0-9-]*\.md$')
[ -z "$stale" ] && [ -z "$upper" ] && python3 skills/loop/write-okf/scripts/okf-check OKF
```

Green when no old name survives outside the four exempted OKF files and the
upstream URL, no UPPERCASE sibling remains, and `okf-check OKF` exits 0 —
which also proves the four `cites:` still resolve. Run against the tree at
draft time it reports 33 stale references and 8 UPPERCASE siblings, so it is
red before the sweep and can only go green by completing it.

A bare dangling-link sweep is deliberately *not* the gate: `skills/` already
carries 8 illustrative link targets that do not resolve (`context/billing.md`,
`NNN-<slug>.md`, and similar template placeholders), so that check has a
non-zero baseline and cannot express pass/fail.

## Out of scope

- **F1** — the `call-charon` / `commit-atomic-jj` 117-line breaches. Separate
  blueprint, deliberately after this one.
- **F9** — whether `model-domain/decision-format.md` and
  `ferry/decision-format.md` are a genuine concept collision. Both are
  `type: Decision` at different lifecycle stages: ferry's is the in-flight
  `D-<n>` form, model-domain's the graduated `decisions/NNN` register form.
  **The present casing accidentally disambiguates them, and this blueprint
  removes that accident** — after the sweep the two basenames are identical
  and only the directory separates them. That is accepted deliberately:
  renaming either one for *meaning* is a vocabulary decision needing
  model-domain's warrant test, and burying it in a 33-site mechanical diff
  would defeat `review-blueprint`'s scope check. F9 inherits the coincidence.
- `write-okf/` — the folder's uppercase `OKF` is a skill name, not a sibling
  file. Untouched.
- `*.template.md` files — already lowercase, and their `.template.` infix is
  deliberate.
- Rewriting `OKF/blueprints/001`, `003`, or `013`, or `OKF/index.md`'s 013 title.
