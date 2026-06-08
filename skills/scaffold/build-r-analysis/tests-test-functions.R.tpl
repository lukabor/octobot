project_root <- normalizePath(file.path(
  testthat::test_path(), "..", ".."
))
options(box.path = project_root)

box::use(
  testthat[describe, it, expect_true]
)

describe("placeholder", {
  it("passes", {
    expect_true(TRUE)
  })
})
