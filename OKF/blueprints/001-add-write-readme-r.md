---
type: Blueprint
status: draft
traces-to: README.md §Roadmap ("write-readme-r" gap); write-readme-py/SKILL.md §Out of scope
sounded: 2026-07-22
---

# 001 — add write-readme-r skill

## Justification
Named gap in `README.md:231-234` §Roadmap and declared out of scope in
`skills/engineering/write-readme-py/SKILL.md:72-74`, with its interface
already sketched there: "reading `DESCRIPTION` for packages and
`_targets.R` + `index.qmd` for analyses is the planned interface".

The gap is **depth, not coverage**: generic `write-readme` already
detects both R types (`write-readme/SKILL.md:23-24`) and extracts their
fields (`write-readme/REFERENCE.md:22-40`). What R lacks is what
`write-readme-py` gives Python — a template, the Saduko license block,
and justfile-derived usage. A dedicated skill must earn its place
against that generic path, or fold into it.

## Contract
A skill `skills/engineering/write-readme-r/` that:
- Detects project type: `DESCRIPTION` → r-package (fields: Package,
  Title, Description, License, Authors@R); `_targets.R` → r-analysis
  (sources: `reports/index.qmd` title/description + `justfile`).
- Materialises `README.md` from a template following write-readme-py's
  Saduko-style layout (logo block, install block, justfile-derived usage
  sections, license block — Apache-aware rich block, one-liner
  otherwise).
- **Derives the install block from the project, never from a default.**
  Both R scaffolds run every recipe through `docker compose run --rm
  dev` and ship no `renv.lock`, so `renv::restore()` is wrong for them;
  `write-readme/REFERENCE.md:38` prescribing it is drift this blueprint
  corrects rather than copies. Read the justfile and the presence of a
  lockfile; no evidence → omit the section and say so.
- Refuses to invent: empty Description → ask; no fabricated deps,
  recipes, authors, or URLs. Omits sections lacking source data.
- Guards an existing README.md (diff + explicit confirmation).
- Stops on `jj diff` for review; never commits.

## Seams touched
- New skill folder: `skills/engineering/write-readme-r/{SKILL.md,
  readme-r.template.md}`, plus its `~/.claude/skills/write-readme-r`
  symlink — discovery is one level deep.
- `write-readme-py/SKILL.md:72` — the "not yet written" note, the only
  live instance of that string.
- `write-readme/SKILL.md` §See also — one line; and `REFERENCE.md:38`,
  whose `renv::restore()` default is wrong for scaffolded analyses.
- `build-r-package/SKILL.md:42-43` — its suggestion fires "once it
  exists", and its pointer to README *Out of scope* is already broken;
  README has no such heading.
- `build-r-analysis/SKILL.md` — mentions no README at all today; gains
  the suggestion its sibling already has.
- `skills/loop/steer/SKILL.md` — one row, per its own closing rule.
- `README.md` §Skills engineering list, §Roadmap (the item is spent).

## Verify
From a fixture r-package (`DESCRIPTION.tpl` + `justfile.tpl` copied out
of `skills/scaffold/build-r-package/`), run the skill, then:

```sh
comm -23 <(grep -o 'just [a-z-]*' README.md | sed 's/just //' | sort -u) \
         <(grep -oE '^[a-z-]+:' justfile | tr -d ':' | sort -u)
grep -c 'renv::restore' README.md
```

Expect empty output from `comm` — every recipe the README documents
exists in the justfile — and `0` from the grep, since the fixture has no
lockfile. Then read the README once: the License block must match
`DESCRIPTION`'s License field, and nothing may appear that no source
file carries.

## Out of scope
- Quarto rendering, pkgdown sites, badges.
- Changes to write-readme-py, and to generic write-readme beyond the
  See-also line and the `REFERENCE.md:38` install correction.
- R README generation for non-scaffolded (arbitrary) R repos — generic
  `write-readme` keeps those.
