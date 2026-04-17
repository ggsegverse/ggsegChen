describe("chenTh atlas", {
  it("is a ggseg_atlas", {
    expect_s3_class(chenTh(), "ggseg_atlas")
    expect_s3_class(chenTh(), "cortical_atlas")
  })

  it("is valid", {
    expect_true(ggseg.formats::is_ggseg_atlas(chenTh()))
  })

  it("renders with ggseg", {
    skip_if_not_installed("ggseg")
    skip_if_not_installed("ggplot2")
    skip_if_not_installed("vdiffr")
    p <- ggplot2::ggplot() +
      ggseg::geom_brain(
        atlas = chenTh(),
        mapping = ggplot2::aes(fill = label),
        position = ggseg::position_brain(hemi ~ view),
        show.legend = FALSE
      ) +
      ggplot2::scale_fill_manual(values = chenTh()$palette, na.value = "grey") +
      ggplot2::theme_void()
    vdiffr::expect_doppelganger("chenTh-2d", p)
  })
})
