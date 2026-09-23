# Mocking in R

**Mock at system seams. Never mock your own code.**

> Snippets below show only the function bodies; the `box::use(...)`
> prologue is omitted for clarity. Real files start with one — see
> `/style-r`.

## Seams you may mock

- HTTP / REST APIs — `httptest2`, `webmockr`, or `httr2::with_mocked_responses()`.
- Databases — prefer a real test DB (`RSQLite::SQLite()` in-memory) over a
  mock. Mock only when the schema is irrelevant to the test.
- Time — `withr::local_envvar(TZ = "UTC")`, `lubridate::with_tz()`, or
  inject a `now = Sys.time` parameter.
- Randomness — `withr::local_seed(42)`, or inject `rng = runif`.
- File system — `withr::local_tempdir()`, `fs::path_temp()`. Real temp
  files are usually cheaper than mocks.

## Things you must NOT mock

- Your own `box` modules or package exports.
- Internal collaborators (functions called by the function under test).
- S3 / S4 methods you defined.
- Anything you control and could refactor.

If a test feels like it needs to stub an internal helper, that is a signal
your function under test is doing two things. Split it.

## Design for mockability at the seam

### Dependency injection over hardcoded constructors

```r
# Easy to mock — pass the client in
process_payment <- function(order, payment_client) {
  payment_client$charge(order$total)
}

# Hard to mock — constructs the client internally
process_payment <- function(order) {
  client <- StripeClient$new(Sys.getenv("STRIPE_KEY"))
  client$charge(order$total)
}
```

In tests:

```r
fake_client <- list(charge = function(amount) list(status = "ok", id = "tx_1"))
expect_equal(process_payment(order, fake_client)$status, "ok")
```

### SDK-style wrappers over a generic `do_request()`

```r
# GOOD — each function has one job and one mock shape
modb <- list(
  get_dataset = function(id) httr2::request(...) |> httr2::req_perform(),
  list_datasets = function() ...,
  query_expression = function(dataset_id, gene_ids) ...
)
```

```r
# BAD — every test mock needs conditional logic
modb <- list(
  call = function(endpoint, params) httr2::request(endpoint) |> ...
)
# tests now have to encode "if endpoint == '/datasets' return ..."
```

The SDK-style approach lets each test replace exactly one function with a
constant return value. No `switch()` inside the mock, no risk of one test's
expectations bleeding into another.

## R-specific tools, briefly

- `testthat::local_mocked_bindings(fn = function(...) ...)` — replaces a
  binding inside the package under test for the scope of one `test_that`.
  Use only at the *seam*: stub `httr2::req_perform`, not your own
  `parse_response`.
- `mockery::stub(target, "seam_fn", value)` — same idea, finer-grained.
  Same rule: only stub at the seam.
- `httptest2::with_mock_dir("fixtures/")` — replay recorded HTTP fixtures.
  Best option for integration-style tests against an HTTP service.

## The single-sentence test

*If I refactor the body of the function under test without changing its
public contract, do the mocks in this test still make sense?* If the mocks
target internal helpers, the answer is no, and the test is mis-scoped.
