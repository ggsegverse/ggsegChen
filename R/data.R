#' Chen Areal Atlas
#'
#' Brain atlas for the genetic topography of cortical areal morphology
#' with 12 regions per hemisphere.
#' Contains 2D polygon geometry for [ggseg::geom_brain()].
#'
#' @family ggseg_atlases
#'
#' @references Chen et al. (2013) PNAS, 110 (42) 17089-17094;
#' \doi{10.1073/pnas.1308091110}
#'
#' @return A [ggseg.formats::ggseg_atlas] object (cortical).
#' @export
#' @examples
#' chenAr()
chenAr <- function() .chenAr
#' Chen Thickness Atlas
#'
#' Brain atlas for the genetic topography of cortical thickness morphology
#' with 12 regions per hemisphere.
#' Contains 2D polygon geometry for [ggseg::geom_brain()].
#'
#' @family ggseg_atlases
#'
#' @references Chen et al. (2013) PNAS, 110 (42) 17089-17094;
#' \doi{10.1073/pnas.1308091110}
#'
#' @return A [ggseg.formats::ggseg_atlas] object (cortical).
#' @export
#' @examples
#' chenTh()
chenTh <- function() .chenTh
