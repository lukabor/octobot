---
type: Blueprint
status: draft
traces-to: README.md §Roadmap ("write-readme-r" gap); write-readme-py/SKILL.md §Out of scope
---

# 001 — add write-readme-r skill

## Justification
Named gap in `README.md` §Roadmap and declared out of scope in
`skills/engineering/write-readme-py/SKILL.md` with its interface already
sketched there: "reading `DESCRIPTION` for packages and `_targets.R` +
`index.qmd` for analyses is the planned interface". R scaffolds
(`build-r-package`, `build-r-analysis`) currently ship without a README
generator, unlike their Python sibling.

## Contract
A skill `skills/engineering/write-readme-r/` that:
- Detects project type: `DESCRIPTION` → r-package (fields: Package,
  Title, Description, License, Authors@R); `_targets.R` → r-analysis
  (sources: `reports/index.qmd` title/description + `justfile`).
- Materialises `README.md` from a template following write-readme-py's
  Saduko-style layout (logo block, install via `renv::restore()`,
  justfile-derived usage sections, license block — Apache-aware rich
  block, one-liner otherwise).
- Refuses to invent: empty Description → ask; no fabricated deps,
  recipes, authors, or URLs. Omits sections lacking source data.
- Guards an existing README.md (diff + explicit confirmation).
- Stops on `jj diff` for review; never commits.

## Seams touched
- New skill folder only: `skills/engineering/write-readme-r/{SKILL.md,
  readme-r.template.md}`.
- One-line "See also" additions in: `write-readme/SKILL.md`,
  `write-readme-py/SKILL.md`, `build-r-package/SKILL.md`,
  `build-r-analysis/SKILL.md` (replacing the "not yet written" notes).

## Verify
In a scratch dir scaffolded by `/build-r-package` (fixtures acceptable):
running the skill's process against its `DESCRIPTION` + `justfile`
produces a `README.md` whose every install/usage command exists verbatim
in the justfile, and whose license block matches the DESCRIPTION License
field. Check: `grep -c 'just ' README.md` equals the number of documented
recipes; no invented content on manual read-through.

## Out of scope
- Quarto rendering, pkgdown sites, badges.
- Changes to write-readme-py or the generic write-readme beyond the
  See-also lines.
- R README generation for non-scaffolded (arbitrary) R repos.
