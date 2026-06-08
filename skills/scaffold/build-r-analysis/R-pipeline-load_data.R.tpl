box::use(
  fs[dir_ls],
  purrr[map, list_rbind],
  readr[read_csv],
)

#' @export
load_raw_data <- function(path) {
  dir_ls(path, glob = "*.csv") |>
    map(read_csv) |>
    list_rbind()
}
