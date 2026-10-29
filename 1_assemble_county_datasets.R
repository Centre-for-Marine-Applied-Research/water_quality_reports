# October 28, 2026 - update with input from Claude Opus 5.5
# November 10, 2025

# Assemble county datasets

## For CMAR use:
### rds file exported to R:\data_branches\water_quality\processed_data\assembled_data
### includes all flag columns
### includes VR2AR data from deployments with a hobo sensor at the same depth

## For Open Data Portal:
### csv file exported to R:\data_branches\water_quality\open_data
### only includes summary qc flags
### does not include any VR2 data from deployments that have a hobo sensor at the same depth

library(data.table)
library(dplyr)
library(qaqcmar)
library(sensorstrings)
library(stringr)

# SECTION 1: Update County------------------------------------------------------

county <- "richmond"

# SECTION 2: Import and Check Data ----------------------------------------

dat_all <- qc_assemble_county_data(folder = county) %>%
  mutate(
    lease = if_else(lease == "NA" | lease == "na", NA_character_, lease),
    lease = if_else(
      grepl("^\\d{1,3}$", lease), formatC(as.integer(lease), width = 4, flag = "0"), lease
    )
  )

# review waterbody, station, and lease for spelling and location errors
unique(dat_all$waterbody)
unique(dat_all$station)
unique(dat_all$lease)

# check for duplicate rows
dat_dups <- dat_all %>%
  data.table() %>%
  duplicated()
if(any(dat_dups == TRUE)) warning("duplicated rows detected in dat")

# SECTION 3: Open Data Portal -------------------------------------------

flag_cols <- grep("_flag_", colnames(dat_all), value = TRUE)
rm_cols <- c(
  setdiff(flag_cols, grep("^qc_flag_", flag_cols, value = TRUE)),
  "ph_ph", "qc_flag_ph_ph"
)

keep_cols <- colnames(dat_all)[which(!(colnames(dat_all) %in% rm_cols))]


# remove vr2 data with HIL 4 (paired with a hobo for temperature)
# %in% returns FALSE when sensor_type or the flag is NA. == would return NA
dat <- dat_all %>%
  mutate(
    vr2_paired = sensor_type %in% "vr2ar" &
      human_in_loop_flag_temperature_degree_c %in% 4 &
     # turns a missing comment into an empty string, so str_detect() returns FALSE rather than NA
      str_detect(
        coalesce(hil_comment, ""),
        fixed("vr2ar unit paired with hobo sensor for more accurate temperature data")
      )
  )

message(sum(dat$vr2_paired), " vr2ar observations removed")

dat <- dat %>%
  filter(!vr2_paired) %>%
  select(-vr2_paired)

# remove the qc_test_variable columns (leaving only the max flag col)
dat %>%
  select(-county, -any_of(rm_cols)) %>%
  qc_assign_flag_labels() %>%
  ss_export_county_files(county = county, export_rds = FALSE)

# SECTION 4: CMAR data --------------------------------------------

# remove columns that are all NA
dat %>%
  select(where(~ !all(is.na(.x)))) %>%
  ss_export_county_files(county = county, export_csv = FALSE)

# pivot longer to check number of rows
var_cols <- dat %>%
  select(starts_with("qc_flag_")) %>%
  colnames() %>%
  str_remove("^qc_flag_") %>%
  intersect(colnames(dat))

# number of observations (same as nrow(ss_pivot_longer(dat)))
n_obs <- dat %>%
  summarise(across(all_of(var_cols), ~ sum(!is.na(.x)))) %>%
  sum()
n_obs



