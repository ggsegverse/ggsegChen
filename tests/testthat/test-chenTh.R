# ggseg ----

context("test-chenTh-palettes")
test_that("check new palettes work", {
  expect_equal(
    length(brain_pal("chenTh", package = "ggsegChen")), 12
  )

  expect_error(brain_pal("chenTh"), "not a valid")

  expect_true(all(
    names(brain_pal("chenTh", package = "ggsegChen")) %in%
      brain_regions(chenTh)
  ))
})

context("test-chenTh-ggseg-atlas")
test_that("atlases are true ggseg atlases", {
  expect_true(is_brain_atlas(chenTh))
  expect_true(is_ggseg_atlas(as_ggseg_atlas(chenTh)))

})

context("test-chenTh-ggseg")
test_that("Check that polygon atlases are working", {
  expect_is(ggseg(atlas = chenTh), c("gg", "ggplot"))

  expect_is(ggseg(atlas = chenTh,
                  mapping = aes(fill = region)),
            c("gg", "ggplot"))

  expect_is(ggseg(atlas = chenTh,
                  mapping = aes(fill = region)) +
              scale_fill_brain("chenTh",
                               package = "ggsegChen"),
            c("gg", "ggplot"))

  expect_is(ggseg(atlas = chenTh,
                  mapping = aes(fill = region)) +
              scale_fill_brain("chenTh",
                               package = "ggsegChen"),
            c("gg", "ggplot"))

  expect_is(ggseg(atlas = chenTh,
                  mapping = aes(fill = label),
                  position = "stacked"),
            c("gg", "ggplot"))

  expect_is(ggseg(atlas = chenTh,
                  mapping = aes(fill = label),
                  adapt_scales = FALSE),
            c("gg", "ggplot"))

})


# ggseg3d ----
