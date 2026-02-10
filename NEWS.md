# ggsegChen 2.0.0

## Breaking changes

* `chenAr` and `chenTh` are now `ggseg_atlas` objects (from ggseg.formats)
  containing 2D polygon data. No 3D data was available for this atlas.

* Use `ggplot() + ggseg::geom_brain(atlas = chenAr)` for 2D plots --
  the old `plot()` / `ggseg()` methods are no longer available.

* `ggseg.formats` is now a hard dependency (in Depends).

* Package URLs updated from `LCBC-UiO` to `ggseg` GitHub organisation.

# ggsegChen 1.0.01

* adapted atlases to ggseg <= 1.6.0
* Added a `NEWS.md` file to track changes to the package.
