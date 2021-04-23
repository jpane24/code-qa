# File Info ====================================================================
# synth-creation.R
# Code one can use to create a synthetic dataset
# data input: imputed-gain-data.csv
# data output: synthetic_dataset.csv

# Load packages ================================================================
library(tidyverse)
library(synthpop)
library(readr)

# Load dataset(s)  =============================================================
# load in imputed dataset and add in session information:
# Note for user: Data in this file is sensitive and doesn't exist in the code
# repository. This is simply example code that was used to create a synthetic
# dataset that is very similar to the synthetic dataset that is loaded into
# the workspace on line 13 of R00-Data-Cleaning.R

# Sensitive files include:
# imputed-gain-data.csv

ds <- read_csv("data/imputed-gain-data.csv",
  col_types = cols(
    gender = col_factor(),
    race = col_factor(),
    codis4 = col_factor()
  )
) %>%
  mutate(codis4 = case_when(
    codis4_n == 1 ~ "Neither",
    codis4_n == 2 ~ "Both",
    codis4_n == 3 ~ "Externalizing Only",
    codis4_n == 4 ~ "Internalizing Only",
    TRUE ~ NA_character_
  )) %>%
  mutate(codis4 = factor(codis4, levels = c(
    "Neither", "Internalizing Only",
    "Externalizing Only", "Both"
  ))) %>%
  # only using one imputation for convenience.
  filter(imputation == "imp1")

# Create synthetic dataset =====================================================
# Please see https://cran.r-project.org/web/packages/synthpop/index.html
# for documentation on the synthpop package.

# Run synthpop::syn()
ds_1_syn <- syn(ds_1, proper = F, seed = 24)
saveRDS(ds_1_syn, "~/Desktop/TWANG/ACRA project/data/ds_syn.rds")

# Use the compare function to compare data  ====================================
# Substitute differe
synthpop::compare(ds_1_syn, ds, vars = "eps7p_3")

# Setup Sensitive and Synthetic data for data checks  ==========================
ds_syn <- ds_1_syn$syn %>%
  select(
    acra_derived, tss_0, tss_3, tss_6, sfs8p_0, sfs8p_3, sfs8p_6,
    eps7p_0, eps7p_3, eps7p_6, ias5p_0, dss9_0, mhtrt_0,
    sati_0, sp_sm_0, sp_sm_3, sp_sm_6, gvs, ers21_0, aes_c,
    ada_0, ada_3, ada_6, recov_0, recov_3, recov_6, subsgrps_n,
    sncnt, engage
  ) %>%
  rename(
    treat = acra_derived,
    nproc = aes_c
  ) %>%
  mutate(treat = case_when(
    treat == 1 ~ "A",
    treat == 0 ~ "B",
    TRUE ~ NA_character_
  ))
ds_1 <- ds_1 %>%
  select(
    acra_derived, tss_0, tss_3, tss_6, sfs8p_0, sfs8p_3, sfs8p_6,
    eps7p_0, eps7p_3, eps7p_6, ias5p_0, dss9_0, mhtrt_0,
    sati_0, sp_sm_0, sp_sm_3, sp_sm_6, gvs, ers21_0, aes_c,
    ada_0, ada_3, ada_6, recov_0, recov_3, recov_6, subsgrps_n,
    sncnt, engage
  ) %>%
  rename(
    treat = acra_derived,
    nproc = aes_c
  ) %>%
  mutate(treat = case_when(
    treat == 1 ~ "A",
    treat == 0 ~ "B",
    TRUE ~ NA_character_
  ))

# Data checks: Make no observation is repeated  ================================
data_all <- bind_rows(ds_1, ds_syn)
nrow(data_all) == nrow(unique(data_all))

# Shuffle rows + create final file to be outputted  ===========================
set.seed(2020)
# Shuffle rows
ds_syn_final <- ds_syn[sample(nrow(ds_syn)), ]

# Sample within treatment
ds_syn_final <- ds_syn_final %>%
  group_by(treat) %>%
  sample_n(size = 2000) %>%
  ungroup() %>%
  data.frame()

write_csv(ds_syn_final, "data/synthetic_dataset.csv")
