# October 30, 2026
# March 25, 2024

# functions for Water Quality Reports
# moved to here to decrease length of report script

# apply salinity correction factor to DO data -----------------------------

correct_do_data <- function(dat, sal = 30.6) {

  if(!("salinity_psu" %in% colnames(dat))) {
    dat$salinity_psu <- NA

    rm_sal <- TRUE
  } else rm_sal <- FALSE

  dat <- dat %>%
    mutate(
      sal_na = if_else(is.na(salinity_psu), TRUE, FALSE),
      salinity_psu = if_else(sal_na == TRUE, sal, salinity_psu),
    ) %>%
    do_salinity_correction() %>%
    mutate(
      dissolved_oxygen_mg_per_l = dissolved_oxygen_uncorrected_mg_per_l * F_s,
      salinity_psu = if_else(sal_na == TRUE, NA, salinity_psu)
    ) %>%
    select(-c(sal_na, dissolved_oxygen_uncorrected_mg_per_l, F_s))

  if(rm_sal == TRUE) {
    dat <- dat %>% select(-salinity_psu)
  }

  dat
}

# figure height -----------------------------------------------------------
# calculate the height of figure based on the number of measured variables

# calc_fig_height <- function(dat, h1) {
#
#   n_vars <- dat %>%
#     ss_pivot_longer() %>%
#     distinct(variable) %>%
#     nrow()
#
#   if(n_vars == 1) h = h1
#   if(n_vars == 2) h = 2 * h1
#   if(n_vars == 3) h = 3 * h1
#   if(n_vars == 4) h = 4 * h1
#   if(n_vars > 4) h = 10.9
#
#   h
# }

calc_fig_height <- function(dat, h1, h_max = 10.9, var_cols) {

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

get_county_extent <- function(county, crs = 4326) {
  ext <- county_extents[county_extents$county == county, ]
  if (nrow(ext) == 0) stop("No map extent for county: ", county, call. = FALSE)
  sf::st_bbox(unlist(ext[, c("xmin", "ymin", "xmax", "ymax")]), crs = sf::st_crs(crs))
}
