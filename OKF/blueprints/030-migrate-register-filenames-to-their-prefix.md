---
type: Blueprint
status: locked
traces-to: ROADMAP.md phase 15
sounded: 2026-09-23
cites:
  - OKF/decisions/024-register-filenames-carry-their-prefix.md
  - OKF/decisions/022-prose-cites-carry-a-register-prefix.md
  - OKF/ROADMAP.md
  - skills/loop/write-OKF/scripts/okf-check
  - skills/loop/blueprint/SKILL.md
  - skills/loop/blueprint/blueprint-format.md
  - skills/engineering/model-domain/decision-format.md
  - skills/loop/write-OKF/scripts/link-check
muster: true
review-base: yqylvwxr
---

# 030 — migrate decision and blueprint filenames to their R-/B- prefix

## Justification
[024](../decisions/024-register-filenames-carry-their-prefix.md) rules
that decision and blueprint filenames carry their `R-`/`B-` prefix,
rejecting a forward-only retrofit as leaving two dialects on disk. Its
own Consequences name the two callers that read the old bare-`NNN`
filename shape and would silently misbehave once files are renamed
without them: `skills/loop/blueprint/SKILL.md`'s numbering step and
`okf-check`'s `register_numbers()`. [029](029-prefix-register-filenames-and-validate-okf-structure.md)
(implemented) deliberately left the actual rename out of scope — this
blueprint is that second, later piece of
[ROADMAP.md phase 15](../ROADMAP.md).

## Contract
- Every `OKF/decisions/NNN-<slug>.md` is renamed to
  `OKF/decisions/R-NNN-<slug>.md` — 24 files, `001`–`024`. Content,
  frontmatter (other than the filename itself) and body text are
  byte-identical; the number is not renumbered.
- Every `OKF/blueprints/NNN-<slug>.md` is renamed to
  `OKF/blueprints/B-NNN-<slug>.md` — the 29 existing files (`001`–`029`)
  plus this blueprint itself, which becomes
  `OKF/blueprints/B-030-migrate-register-filenames-to-their-prefix.md`
  once implemented. A locked blueprint's Contract/Verify prose is not
  touched — only its filename — so [blueprint-format.md](../../skills/loop/blueprint/blueprint-format.md)'s
  immutability rule is not in tension with this rename.
- Every reference to a renamed file — a markdown link target, or a
  `cites:` frontmatter entry — is repointed to the new filename,
  repo-wide. A bare, unlinked prose number in `OKF/LEARNINGS.md` /
  `OKF/learnings/` is not retrofitted, per
  [022](../decisions/022-prose-cites-carry-a-register-prefix.md)'s
  precedent, carried forward by 024.
- `skills/loop/blueprint/SKILL.md`'s numbering step computes the next
  blueprint number correctly against `B-NNN-<slug>.md` filenames.
- `okf-check`'s `register_numbers()` recognizes `R-NNN-<slug>.md` and
  `B-NNN-<slug>.md` as naming numbers `NNN`, so
  `prose_cites`'s unprefixed-cite check keeps working against the
  renamed files.
- `skills/loop/blueprint/blueprint-format.md`,
  `skills/engineering/model-domain/decision-format.md`, and
  `OKF/CONTEXT.md`'s **Blueprint** / **why-register entry** terms
  document the `B-NNN-`/`R-NNN-` filename pattern, not the old bare one.

## Seams touched
- `OKF/decisions/*.md`, `OKF/blueprints/*.md` — renamed.
- `OKF/index.md`, `OKF/decisions/index.md`, `OKF/blueprints/index.md`,
  `OKF/ferries/index.md`, `OKF/learnings/*.md` — link targets updated.
- `skills/loop/write-OKF/scripts/okf-check` — `register_numbers()`.
- `skills/loop/blueprint/SKILL.md` — numbering step.
- `skills/loop/blueprint/blueprint-format.md`,
  `skills/engineering/model-domain/decision-format.md`,
  `OKF/CONTEXT.md` — documented filename pattern.

## Verify
```
skills/loop/write-OKF/scripts/render-check .
skills/loop/write-OKF/scripts/okf-check OKF/
skills/loop/write-OKF/scripts/link-check .
skills/productivity/conjure-a-skill/scripts/skill-ref-check skills/
ls OKF/decisions/ | grep -c '^R-[0-9]\{3\}-'   # 24
ls OKF/blueprints/ | grep -c '^B-[0-9]\{3\}-'  # 30
grep -rE '\]\([^)]*(decisions|blueprints)/[0-9]{3}-' --include='*.md' . \
  | grep -v OKF/LEARNINGS.md   # empty
```
All four lints `0 error(s)`; the two counts match; the final grep for a
surviving bare-filename link outside `LEARNINGS.md` prose returns
nothing.

## Out of scope
- Ferry `D-n` files or their numbering — untouched; they already carry
  the prefix that R-022/024 exist to keep distinct.
- Any change to `skills/`'s own file-naming or entry-point convention.
- Retrofitting bare, unlinked prose numbers in `OKF/LEARNINGS.md` /
  `OKF/learnings/`.
- Renumbering any decision or blueprint — the number stays permanent;
  only the prefix is added.
- New doctrine beyond what
  [024](../decisions/024-register-filenames-carry-their-prefix.md)
  already settled — this blueprint is mechanical rename + link repair.
