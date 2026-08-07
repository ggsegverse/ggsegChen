describe("chenTh atlas", {
  it("is a ggseg_atlas", {
    expect_s3_class(chenTh(), "ggseg_atlas")
    expect_s3_class(chenTh(), "cortical_atlas")
  })

  it("is valid", {
    expect_true(ggseg.formats::is_ggseg_atlas(chenTh()))
  })

  it("renders with ggseg", {
    vdiffr::expect_doppelganger(
      "chenth-2d",
      ggseg::brain_test_plot(chenTh())
    )
  })
})
