# October 30, 2026
# March 25, 2024

# functions for Water Quality Reports
# moved to here to decrease length of report script

# salinity correction for dissolved oxygen (mg/L) ---------------------------
# The correction factor depends on temperature. It is calculated before the
# data are filtered, using all temperature observations except those that
# failed QC (qc_flag = 4). Corrected DO is NA where the temperature failed.
# Salinity is fixed at sal, because no sensor measures DO and salinity
# together

add_do_salinity_factor <- function(dat, sal = 30.6) {
  if (!("dissolved_oxygen_uncorrected_mg_per_l" %in% colnames(dat))) {
    return(dat)
  }

  # do_salinity_correction() stops if dat has a salinity_psu column and sal
  # is set, so pass it temperature only
  f_s <- dat |>
    mutate(
      temperature_degree_c = if_else(
        qc_flag_temperature_degree_c %in% 4, NA_real_, temperature_degree_c
      ),
      .keep = "none"
    ) |>
    do_salinity_correction(sal = sal) |>
    pull(F_s)

  mutate(dat, do_salinity_factor = f_s)
}


correct_do_data <- function(dat) {
  dat |>
    mutate(
      dissolved_oxygen_mg_per_l =
        dissolved_oxygen_uncorrected_mg_per_l * do_salinity_factor
    ) |>
    select(-dissolved_oxygen_uncorrected_mg_per_l, -do_salinity_factor)
}


#
# correct_do_data <- function(dat, sal = 30.6) {
#
#   if(!("salinity_psu" %in% colnames(dat))) {
#     dat$salinity_psu <- NA
#
#     rm_sal <- TRUE
#   } else rm_sal <- FALSE
#
#   dat <- dat %>%
#     mutate(
#       sal_na = if_else(is.na(salinity_psu), TRUE, FALSE),
#       salinity_psu = if_else(sal_na == TRUE, sal, salinity_psu),
#     ) %>%
#     do_salinity_correction() %>%
#     mutate(
#       dissolved_oxygen_mg_per_l = dissolved_oxygen_uncorrected_mg_per_l * F_s,
#       salinity_psu = if_else(sal_na == TRUE, NA, salinity_psu)
#     ) %>%
#     select(-c(sal_na, dissolved_oxygen_uncorrected_mg_per_l, F_s))
#
#   if(rm_sal == TRUE) {
#     dat <- dat %>% select(-salinity_psu)
#   }
#
#   dat
# }

# figure height -----------------------------------------------------------
# calculate the height of figure based on the number of measured variables

calc_fig_height <- function(dat, h1, var_cols, h_max = 10.9) {

  dat <- select(dat, where(~ !all(is.na(.x))))

  n_vars <- sum(colnames(dat) %in% var_cols)

  if (n_vars == 0) stop("No variables to plot.", call. = FALSE)
  min(n_vars * h1, h_max)
}

# figure caption ----------------------------------------------------------

glue_sal_fig_caption <- function(fig_cap) {

  glue("{fig_cap} Salinity observations flagged \"Suspect/Of Interest\" were considered \"Of Interest\" for this deployment and included in the figure.")
}

# get coordinates for county map ------------------------------------------

get_county_extent <- function(extents, crs = 4326) {
  if (nrow(extents) == 0) stop("No map extent: ", call. = FALSE)
  sf::st_bbox(unlist(extents[, c("xmin", "ymin", "xmax", "ymax")]), crs = sf::st_crs(crs))
}
