box::use(targets[tar_option_set, tar_target])
box::use(
  ./R/pipeline/load_data[load_raw_data],
)

tar_option_set(packages = character(0))

list(
  tar_target(raw,       load_raw_data("data/raw/")),
  tar_target(processed, raw)
)
