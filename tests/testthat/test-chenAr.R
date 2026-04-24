describe("chenAr atlas", {
  it("is a ggseg_atlas", {
    expect_s3_class(chenAr(), "ggseg_atlas")
    expect_s3_class(chenAr(), "cortical_atlas")
  })

  it("is valid", {
    expect_true(ggseg.formats::is_ggseg_atlas(chenAr()))
  })

  it("renders with ggseg", {
    p <- ggplot2::ggplot() +
      ggseg::geom_brain(
        atlas = chenAr(),
        mapping = ggplot2::aes(fill = label),
        position = ggseg::position_brain(hemi ~ view),
        show.legend = FALSE
      ) +
      ggplot2::scale_fill_manual(
        values = chenAr()$palette,
        na.value = "grey"
      ) +
      ggplot2::theme_void()
    vdiffr::expect_doppelganger("chenar-2d", p)
  })
})
