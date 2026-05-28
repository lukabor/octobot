# Deep modules in R

Adapted from John Ousterhout, *A Philosophy of Software Design*. A **deep
module** has a small interface and a large implementation. A **shallow
module** has a large interface and almost no implementation — every helper
becomes part of the public contract, which makes the code hard to reason
about *and* hard to test.

In R you control the interface with `box::use` (or NAMESPACE/`@export` in a
package). The interface is whatever a caller writes after `box::use(...)`.

## Shallow — bad

```r
# R/modb/client.R — exports eight thin helpers
box::export(
  build_url, build_headers, parse_token, refresh_token,
  page_request, paged_collect, validate_dataset_id, query_dataset
)
```

A caller writes:

```r
box::use(R/modb/client[
  build_url, build_headers, parse_token, refresh_token,
  page_request, paged_collect, validate_dataset_id, query_dataset
])

tok <- refresh_token(parse_token(Sys.getenv("MODB_TOKEN")))
url <- build_url("DS001")
hdr <- build_headers(tok)
rows <- paged_collect(page_request(url, hdr))
```

Every refactor that splits, renames, or merges a helper breaks every caller
and every test. The tests reach into internals because the internals *are*
the interface.

## Deep — good

```r
# R/modb/client.R — one exported entry point, everything else internal
box::export(query_dataset)
```

A caller writes:

```r
box::use(R/modb/client[query_dataset])
rows <- query_dataset("DS001")
```

`query_dataset()` handles tokens, paging, retries, and validation
internally. Tests target the contract ("returns a tibble of expected rows
for DS001"; "raises `modb_auth_error` on bad token"). Internal helpers can
be renamed or replaced freely.

## Design questions before exporting

For every name you are about to `box::export()` or `@export`:

1. **Does a caller need this?** If only other internals call it, keep it
   unexported.
2. **Could two of these collapse?** `build_url` + `build_headers` may want
   to become an internal `prepare_request()`.
3. **Could a parameter swallow a helper?** A `paginate = TRUE` argument on
   `query_dataset()` can remove `page_request` + `paged_collect` from the
   surface.
4. **Is this a leaky abstraction?** Returning a `httr2::request` object
   forces every caller (and test) to know `httr2`. Return a tibble or a
   typed result instead.

## Heuristic

If the count of exports from a module changes every PR, the module is
shallow. Deep modules export one or two names and stay stable for months.
