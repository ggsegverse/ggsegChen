# ggsegChen (development version)

* `chenAr()` and `chenTh()` both ship again; the preceding build replaced them
  with a single undocumented `chen` object that no accessor could reach.
* Corrected the area parcellation's cluster-to-region mapping: `cluster12` named
  occipital and `cluster13` named a region id absent from the colour table,
  leaving dorsolateral prefrontal and pars opercularis,subcentral unassigned.
* `data-raw/create_annots.R` builds both parcellations and writes them to
  type-specific filenames; it previously built thickness only, and both
  hemispheres' output collided on one name.
* Both atlases carry `display` and are projected to four views.

# ggsegChen 1.0.01

* adapted atlases to ggseg <= 1.6.0
* Added a `NEWS.md` file to track changes to the package.
