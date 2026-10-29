# ggsegChen (development version)

- Both parcellations are built from source again. `data-raw/create_annots.R`
  looped over thickness only, and both types wrote to the same
  `{hemi}.gclust.annot`, so area could not be produced.
- Corrected the area parcellation's cluster-to-region mapping. `cluster12`
  named occipital, already claimed by `cluster3`, and `cluster13` named an id
  absent from the colour table, leaving dorsolateral prefrontal and pars
  opercularis,subcentral unassigned.
- `create_annots.R` now validates the mapping against the colour table instead
  of producing a silently truncated colortable.
- Both atlases carry `display` and are projected to four views.

# ggsegChen 1.0.2

- Atlas 2D geometry migrated to the sf-optional `brain_polygons` format
  (`ggseg.formats` 0.0.3). The atlases now render without `sf` and its
  GDAL/GEOS/PROJ system libraries, enabling wasm and air-gapped installs.
  Plots are unchanged.

# ggsegChen 1.0.01

* adapted atlases to ggseg <= 1.6.0
* Added a `NEWS.md` file to track changes to the package.
