# Worked example — R / bookdown / targets

Transcript of a `/domain-modeling` session in a targets-pipeline repo; ends with the `CONTEXT.md` skeleton it produces.

## The conflict: "target"

User: *"I want to add a new target for the CR expression chapter — one
per tissue."*

Agent (one question at a time):

> **Q1.** When you say "target" — do you mean a `targets::tar_target()` in
> the pipeline, or a therapeutic target (a gene/protein of interest)?
> Both terms live in this repo: `_targets.R` uses the pipeline meaning,
> `Rmd/indication1_rmd/CR_genetics.Rmd` uses the biological meaning.
> Which?

User: *"The pipeline one."*

> **Q2.** Good — recording that as the canonical use in `CONTEXT.md` and
> demoting the biological sense to `_Avoid_: therapeutic target (use
> "gene of interest" instead)`. Confirm?

User: *"yes"*

> **Q3.** "One per tissue" — by tissue do you mean the `tissue` column in
> the MODB metadata (`R/indication/get_modb_bulk_config.R:42`) or the
> single-cell `cell.type` axis (`Rmd/indication2_rmd/expression_sc.Rmd`)?
> They are *different things* in this repo — six tissues vs 28 cell
> types. Which?

User: *"MODB tissue column."*

> **Q4.** Read the code: `R/indication/get_modb_bulk_config.R` shows
> tissues are `"lung"`, `"colon"`, `"liver"`, `"skin"`, `"kidney"`,
> `"heart"`. Confirm those six are the universe, or do you also want
> `"blood"` from the MSSM dataset?

…and so on. Each resolved term goes straight into `CONTEXT.md`.

## Stress-test scenario the agent should invent

> **Q5.** What should the target return when a tissue has zero significant
> genes? An empty tibble (so downstream `bind_rows` works), `NULL` (so
> downstream `purrr::compact` drops it), or an error?

Forces the user to commit to the contract before any test is written.
Hands cleanly to `/bdd` once locked.

## Cross-reference contradiction the agent surfaces

> User: *"…and the target writes a parquet file to `data_cache/`."*
>
> **Agent:** Stop — `_targets.R:14` sets `tar_option_set(format =
> "qs2")`. Targets in this repo are cached by `targets` itself, not as
> parquet. Writing to `data_cache/` would make the result invisible to
> `targets`' invalidation. Did you mean to bypass the cache, or use the
> default `qs2` format?

## Resulting `CONTEXT.md` skeleton

```md
# target-assessment-report

Bookdown + targets pipeline that assembles per-tissue gene-of-interest
evidence for the target-assessment programme.

## Language

**Target**:
A `targets::tar_target()` node in `_targets.R`. The unit of pipeline
caching and invalidation.
_Avoid_: therapeutic target (use "gene of interest"), milestone, goal.

**Gene of interest**:
A gene under evaluation in a target-assessment dossier. Identified by
Ensembl gene ID (`ENSG…`) plus an HGNC symbol.
_Avoid_: therapeutic target, candidate, hit.

**Tissue**:
One of six bulk tissues from MODB: lung, colon, liver, skin, kidney,
heart. Distinct from single-cell `cell.type`.
_Avoid_: organ, sample type.

**Dataset**:
A MODB bulk dataset identified by `DS<NNN>`, configured under
`data_config/indication_pf/`.
_Avoid_: cohort, study, sample set.
```

Note: zero implementation details; `CONTEXT.md` is a glossary, design notes belong in ADRs.

## What would *not* get written

- `box::use` for module imports — general R idiom, out.
- "knits in ~45s" — operational detail; ADR-worthy only if a deliberate
  trade-off drove it.
- "we cache targets with `qs2`" — ADR if there was a real choice (qs2 vs
  RDS vs parquet); glossary if the word "cache" needs disambiguating.
