# Filter data to keep observations of acceptable quality

## dissolved oxygen (percent saturation and mg/L)
### keep flags of 1 and 3 for all tests EXCEPT rolling sd
### for rolling sd, only keep flags of 1

## for salinity
### only keep flags of 1 for now, except for stations in keep_sus_sal.

## all other variables
### keep flags of 1 and 3

report_filter_flags <- function(
    dat,
    keep_sus_sal = NULL,
    keep_sensor_depth_measured_m = c(1, 3, NA),
    keep_temperature_degree_c = c(1, 3, NA)
) {

  if (nrow(dat) == 0) {stop("No rows in dat to filter")}

  # DO is filtered on each test, not on qc_flag, so its human in the loop
  # flags must be checked here (qc_flag already includes them for the other
  # variables). Add the columns as NA if a county has no DO hil flags.
  hil_do_cols <- c(
    "human_in_loop_flag_dissolved_oxygen_percent_saturation",
    "human_in_loop_flag_dissolved_oxygen_uncorrected_mg_per_l"
  )
  dat[setdiff(hil_do_cols, colnames(dat))] <- NA


  dat <- dat %>%
    filter(
      (variable %in% c(
        "dissolved_oxygen_percent_saturation",
        "dissolved_oxygen_uncorrected_mg_per_l"
      ) &
        grossrange_flag_value %in% c(1, 3, NA) &
        climatology_flag_value %in% c(1, 3, NA) &
        spike_flag_value %in% c(1, 3, NA) &
        rolling_sd_flag_value %in% c(1, NA) &
        ((variable == "dissolved_oxygen_percent_saturation" &
            human_in_loop_flag_dissolved_oxygen_percent_saturation %in% c(1, NA)) |
           (variable == "dissolved_oxygen_uncorrected_mg_per_l" &
              human_in_loop_flag_dissolved_oxygen_uncorrected_mg_per_l %in% c(1, NA)))
      ) |

        (variable == "sensor_depth_measured_m" &
           qc_flag_value %in% keep_sensor_depth_measured_m) |

        (variable == "salinity_psu" &
           (qc_flag_value %in% c(1, NA) |
              (qc_flag_value %in% 3 & station %in% keep_sus_sal))) |

        (variable == "temperature_degree_c" &
           qc_flag_value %in% keep_temperature_degree_c)
    )

  dat
}


