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

  dat <- dat %>%
    filter(
      (variable == "dissolved_oxygen_percent_saturation" &
         grossrange_flag_value %in% c(1, 3, NA) &
         climatology_flag_value %in% c(1, 3, NA) &
         spike_flag_value %in% c(1, 3, NA) &
         rolling_sd_flag_value %in% c(1, NA)
      ) |

        (variable == "dissolved_oxygen_uncorrected_mg_per_l" &
           grossrange_flag_value %in% c(1, 3, NA) &
           climatology_flag_value %in% c(1, 3, NA) &
           spike_flag_value %in% c(1, 3, NA) &
           rolling_sd_flag_value %in% c(1, NA)
        ) |

        (variable == "sensor_depth_measured_m" &
           qc_flag_value %in% keep_sensor_depth_measured_m) |

        (variable == "salinity_psu" &
           (qc_flag_value %in% c(1, NA) |
              (qc_flag_value %in% 3 & station %in% keep_sus_sal))) |

        (variable == "temperature_degree_c" &
           qc_flag_value %in% keep_temperature_degree_c)
    )

  # why is human in loop here?
  # # because human_in_loop flags not pivoted
  # if("human_in_loop_flag_dissolved_oxygen_percent_saturation" %in% colnames(dat)) {
  #
  #   dat <- dat %>%
  #     filter(
  #       human_in_loop_flag_dissolved_oxygen_percent_saturation %in% c(1, NA))
  # }

  dat
}


