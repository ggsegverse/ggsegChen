# Create Chen Cortical Atlas
#
# The Chen atlas uses LCBC internal cortical thickness and area
# parcellations. Source .annot files need to be generated from
# the original gclust data.
#
# Reference: Chen CH, et al. (2012). Genetic topography of brain
#   morphology. PNAS, 109(44):18010-18015.
#   doi:10.1073/pnas.1210903109 # nolint: commented_code_linter.
#
# TODO: Obtain or regenerate .annot files from published data
#
# Run with: Rscript data-raw/make_atlas.R

library(ggseg.extra)
library(ggseg.formats)

Sys.setenv(FREESURFER_HOME = "/Applications/freesurfer/7.4.1")

annot_files <- file.path(
  here::here("data-raw", "fsaverage5"),
  c("lh.gclust.annot", "rh.gclust.annot")
)

chen <- create_cortical_from_annotation(
  input_annot = annot_files,
  atlas_name = "chen",
  output_dir = "data-raw",
  skip_existing = TRUE,
  cleanup = FALSE
) |>
  atlas_region_contextual("unknown|Unknown", "label")

print(chen)
plot(chen)

.chen <- chen
usethis::use_data(.chen, overwrite = TRUE, compress = "xz", internal = TRUE)
