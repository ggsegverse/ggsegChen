# Convert legacy Chen atlases to ggseg_atlas format
#
# Both chenAr and chenTh are 2D-only atlases (no 3D data).
# The legacy brain_atlas objects have a $data field with class "ggseg_atlas"
# that conflicts with sf methods, so we strip it before conversion.
#
# Run with: Rscript data-raw/convert_atlas.R

library(ggseg.formats)

for (nm in c("chenAr", "chenTh")) {
  load(here::here("data", paste0(nm, ".rda")))
  obj <- get(nm)

  class(obj$data) <- setdiff(
    class(obj$data),
    c("brain_data", "ggseg_atlas")
  )

  result <- convert_legacy_brain_atlas(atlas_2d = obj)
  stopifnot(is_ggseg_atlas(result))

  assign(nm, result)
  save(
    list = nm,
    file = here::here("data", paste0(nm, ".rda")),
    compress = "xz"
  )
}

brain_pals <- list()
for (nm in c("chenAr", "chenTh")) {
  obj <- get(nm)
  brain_pals[[obj$atlas]] <- obj$palette
}
save(brain_pals, file = here::here("R/sysdata.rda"), compress = "xz")
