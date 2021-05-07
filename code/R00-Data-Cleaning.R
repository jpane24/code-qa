# File Info ====================================================================
# R00-Data-Cleaning.R
# File loads data and cleans data for R01-EDA.R, R02-Analysis.R
# data input: None
# data output: data_preImp.rda

# Print session info at beginning of file ======================================
sessionInfo()

# Load relevant R packages/files ===============================================
library(tidyverse)
library(OVtool) # We load our data from this package
source("code/helper.R")

# Load data ====================================================================
data(sud) # sud: Substance Use Disorder synthetic dataset

# Explore data  ================================================================
sud %>%
  dplyr::top_n(10) # Print first 10 rows

str(sud)

# What proportion of sample is in each treatment group?
sud %>%
  dplyr::group_by(treat) %>%
  dplyr::summarize(n = n()) %>%
  dplyr::mutate(pct = n / sum(n))

# Clean data  ==================================================================
# Convert any doubles that should be character
# Convert character to factor
sud <- sud %>%
  dplyr::mutate(subsgrps_n = case_when(
    subsgrps_n == 1 ~ "Alc-Marij-Disorder",
    subsgrps_n == 2 ~ "Other-Drugs",
    subsgrps_n == 3 ~ "Opirate-Disorder",
    TRUE ~ NA_character_
  )) %>%
  mutate_if(is.character, as.factor)

# Check for missing values
sud %>%
  dplyr::select_if(., any_NAs) -> var_NAs

# Count number of missing values in each variable that has >= 1 missing value
sud %>%
  dplyr::select(colnames(var_NAs)) %>%
  dplyr::summarize_all(sum_NAs)

# Check for certain missing patterns (within treatment)
sud %>%
  dplyr::select(colnames(var_NAs), treat) %>%
  dplyr::group_by(treat) %>%
  dplyr::summarize_all(sum_NAs)

# Note: sncnt and engage are missing in every 100% of observations in
# treatment B. Analytic decision: Do not impute missing for this analysis...
sud <- sud %>%
  dplyr::select(-colnames(var_NAs))

# Write file  ==================================================================
save(sud, file = "output/sud-forR01.rda")

# Print session info at end of file ======================================
sessionInfo()
