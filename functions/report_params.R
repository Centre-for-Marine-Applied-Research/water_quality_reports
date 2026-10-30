# October 28, 2026
# March 25, 2024

# Parameters to source for Water Quality reports
# Moved to here to reduce length of report script

# all water quality variables ---------------------------------------------
# variables that could be included in the report

vars <- c(
  "dissolved_oxygen_percent_saturation",
  "dissolved_oxygen_uncorrected_mg_per_l",
  "dissolved_oxygen_mg_per_l",
  "salinity_psu",
  "sensor_depth_measured_m",
  "temperature_degree_c"
)

# custom DO y limits ------------------------------------------------------
# stations that have DO below the default range of ss_plot_variables
custom_do_ylims <- c(
  "0814x E",
  "0814x W",
  "Aberdeen",
  "Deep Basin",
  "Tickle Island 1"
)

# keep low salinity -------------------------------------------------------
# stations where salinity flagged 3 is kept (typically low salinity areas where
# salinity gets flagged by the grossrange user threshold)
keep_sus_sal <- c("Monks Head", "Pictou Landing", "1443")

# custom SAL y limits ------------------------------------------------------
# stations that have salinity below the default range of ss_plot_variables
# (includes all keep_sus_sal stations, so their kept low values are shown)
custom_sal_ylims <- c("0814x E", "0814x W", keep_sus_sal)

# x-lims for maps ---------------------------------------------------------

x_lims_list <- list(Digby =  c(-66.7, -65.4), Yarmouth = c(-66.5, -65.4))

# county specific params --------------------------------------------------

county_map_params <- tibble::tribble(
  ~county,        ~xmin,  ~xmax,  ~ymin, ~ymax, ~force_fact, ~text_size,
  "Annapolis",    -66,    -65.4,  44.5,  44.8,  50,            3.5,
  "Antigonish",   -62.1,  -61.4,  45.55, 45.9,  50,            3.5,
  "Cape Breton",  -60.7,  -59.8,  45.95, 46.4,  50,            3.5,
  "Colchester",   -63.45, -63,    45.7,  45.9,  50,            3.5,
  "Digby",        -66.7,  -65.4,  44.1,  44.7,  50,            3.5,
  "Guysborough",  -62.7,  -60,    44.8,  45.7,  50,            3,
  "Halifax",      -64.1,  -62.2,  44.1,  45.15, 40,            3.5,
  "Inverness",    -61.6,  -60.56, 45.55, 46.2,  27,            3.5,
  "Lunenburg",    -64.8,  -63.5,  44.13, 44.8,  50,            3.5,
  "Pictou",       -62.92, -62.2,  45.5,  45.9,  35,            3.5,
  "Queens",       -65.4,  -64,    43.77, 44.3,  50,            3.5,
  "Richmond",     -61.5,  -60.4,  45.35, 45.75, 23,            3.5,
  "Shelburne",    -66,    -64.7,  42.8,  44,    50,            3.5,
  "Victoria",     -62,    -58,    45.6,  47.1,  50,            3.5,
  "Yarmouth",     -67,    -65.4,  43.6,  44,    50,            3.5
)



