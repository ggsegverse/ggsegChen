describe("chenAr atlas", {
  it("is a ggseg_atlas", {
    expect_s3_class(chenAr(), "ggseg_atlas")
    expect_s3_class(chenAr(), "cortical_atlas")
  })

  it("is valid", {
    expect_true(ggseg.formats::is_ggseg_atlas(chenAr()))
  })

  it("renders with ggseg", {
    vdiffr::expect_doppelganger(
      "chenar-2d",
      ggseg::brain_test_plot(chenAr())
    )
  })
})
