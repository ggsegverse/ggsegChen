library(Rvcg)
library(freesurferformats)

Sys.setenv(FREESURFER_HOME = "/Applications/freesurfer/7.4.1")
fs_home <- Sys.getenv("FREESURFER_HOME")

output_dir <- here::here("data-raw", "fsaverage5")
dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)

annot_path <- function(output_dir, atlas_type, hemi) {
  file.path(output_dir, sprintf("%s.gclust_%s.annot", hemi, atlas_type))
}

match_roi_vertices <- function(gclust_verts, roi_ply_path) {
  roi <- vcgPlyRead(roi_ply_path)
  roi_verts <- t(roi$vb[1:3, ])
  matched <- integer(0)
  for (v in seq_len(nrow(roi_verts))) {
    d <- colSums((t(gclust_verts) - roi_verts[v, ])^2)
    idx <- which.min(d)
    if (d[idx] < 1e-6) matched <- c(matched, idx)
  }
  matched
}

validate_annot_map <- function(annot_map, rgb_df, atlas_type) {
  ids <- annot_map$annot[!is.na(annot_map$annot)]
  unmapped <- setdiff(ids, rgb_df$ID)
  duplicated_ids <- unique(ids[duplicated(ids)])
  unused <- setdiff(rgb_df$ID[!is.na(rgb_df$ID)], ids)
  if (length(unmapped) == 0 && length(duplicated_ids) == 0) {
    return(invisible(TRUE))
  }
  cli::cli_abort(c(
    "{.file annot2filename.csv} for {atlas_type} does not map onto its colour table.",
    x = "Region ids with no colour-table entry: {.val {unmapped}}.",
    x = "Region ids used by more than one cluster: {.val {duplicated_ids}}.",
    i = "Colour-table ids never used: {.val {unused}}.",
    i = "Each cluster must name exactly one id present in the colour table."
  ))
}

build_annot <- function(atlas_type, hemi) {
  cli::cli_h2("Building {hemi} {atlas_type} annotation")

  gclust_file <- sprintf(
    "data-raw/chen_%s/white/%s/%s.gclust_%s.annot.ply",
    atlas_type,
    hemi,
    hemi,
    atlas_type
  )
  gclust <- vcgPlyRead(gclust_file)
  gclust_verts <- t(gclust$vb[1:3, ])
  n_verts <- nrow(gclust_verts)

  rgb_file <- sprintf(
    "data-raw/chen3d/Chen%s2RGB.csv",
    if (atlas_type == "thickness") "Cth" else "Area"
  )
  rgb_df <- read.csv(rgb_file, sep = ";", stringsAsFactors = FALSE)
  rgb_df$Region <- trimws(gsub('"', '', rgb_df$Region))

  annot_map <- read.csv(
    sprintf("data-raw/chen_%s/annot2filename.csv", atlas_type),
    stringsAsFactors = FALSE
  )
  validate_annot_map(annot_map, rgb_df, atlas_type)

  region_names <- c("unknown")
  region_colors <- matrix(0L, nrow = 1, ncol = 5)
  colnames(region_colors) <- c("R", "G", "B", "A", "code")
  region_colors[1, "code"] <- 0L

  for (i in seq_len(nrow(annot_map))) {
    annot_id <- annot_map$annot[i]
    if (is.na(annot_id) || is.nan(annot_id)) {
      region_names <- c(region_names, "medial_wall")
      code <- 1L
      region_colors <- rbind(region_colors, c(1L, 1L, 1L, 0L, code))
    } else {
      row <- rgb_df[rgb_df$ID == annot_id & !is.na(rgb_df$ID), ]
      region_names <- c(region_names, row$Region)
      r <- as.integer(row$R)
      g <- as.integer(row$G)
      b <- as.integer(row$B)
      code <- r + g * 256L + b * 65536L
      region_colors <- rbind(region_colors, c(r, g, b, 0L, code))
    }
  }

  vertex_labels <- rep(0L, n_verts)
  for (i in seq_len(nrow(annot_map))) {
    roi_file <- sprintf(
      "data-raw/chen_%s/white/%s/%s.white_roi.%04d.ply",
      atlas_type,
      hemi,
      hemi,
      i
    )
    matched <- match_roi_vertices(gclust_verts, roi_file)
    vertex_labels[matched] <- as.integer(region_colors[i + 1, "code"])
    cli::cli_alert_success(
      "ROI {i} ({annot_map$cluster[i]}): {length(matched)} vertices"
    )
  }

  colortable <- data.frame(
    struct_name = region_names,
    r = as.integer(region_colors[, "R"]),
    g = as.integer(region_colors[, "G"]),
    b = as.integer(region_colors[, "B"]),
    a = as.integer(region_colors[, "A"]),
    code = as.integer(region_colors[, "code"]),
    stringsAsFactors = FALSE
  )

  out_file <- annot_path(output_dir, atlas_type, hemi)
  write.fs.annot(
    out_file,
    num_vertices = n_verts,
    colortable = colortable,
    labels_as_colorcodes = vertex_labels
  )
  cli::cli_alert_info("Written: {out_file}")
  cli::cli_alert_info("Unlabeled vertices: {sum(vertex_labels == 0L)}")
}

atlas_types <- c("area", "thickness")
failures <- character(0)

for (atlas_type in atlas_types) {
  outcome <- tryCatch(
    {
      for (hemi in c("lh", "rh")) {
        build_annot(atlas_type, hemi)
      }
      NULL
    },
    error = function(e) conditionMessage(e)
  )
  if (!is.null(outcome)) {
    failures <- c(failures, atlas_type)
    cli::cli_alert_danger("{atlas_type}: {outcome}")
  }
}

built <- setdiff(atlas_types, failures)

cli::cli_h1("Verifying annotations")
for (atlas_type in built) {
  for (hemi in c("lh", "rh")) {
    annot_file <- annot_path(output_dir, atlas_type, hemi)
    annot <- read.fs.annot(annot_file)
    cli::cli_alert_info(
      "{atlas_type} {hemi}: {length(annot$vertices)} vertices, {length(annot$colortable$struct_names)} regions"
    )
    print(table(annot$label_names))
  }
}

if (length(failures) > 0) {
  cli::cli_abort("Could not build {.val {failures}}; see the errors above.")
}
