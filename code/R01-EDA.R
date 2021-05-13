# File Info ====================================================================
# R01-EDA.R
# File looks at descriptive data from R00-Data-Cleaning.R by producing summary
# statistics and basic data visualizations
# data input: output/sud-forR01.rda
# data output: None

# Print session info at beginning of file ======================================
sessionInfo()

# Load relevant R packages/files ===============================================
library(tidyverse)
library(descriptr)
source("code/helper.R")

# Load data ====================================================================
load("output/sud-forR01.rda")

# Screen the data ==============================================================
# We utilize the descriptr package to get the column/variables, the data type,
# if the variable is category, the levels, # of observations,
# and the number % of missing observations

descriptr::ds_screener(sud)

# with one function we get a lot of information.

# Produce summary stats ========================================================
# We utilize the descriptr package to produce summary statistics
# we can change what columns we want to produce summary stats for by specifying
# those after the data argument:

# Baseline version of our outcome
descriptr::ds_summary_stats(sud, sfs8p_0)

# Frequency table - set bins - produce histogram
baseline_outcome <- descriptr::ds_freq_table(sud, sfs8p_0, bins = 7)
plot(baseline_outcome)

# Compare distributions
# baseline version of outcome
grouped_sfs8p_0 <- descriptr::ds_group_summary(
  data = sud,
  gvar = treat,
  cvar = sfs8p_0
)
plot(grouped_sfs8p_0)

# baseline version of outcome
grouped_sfs8p_0 <- descriptr::ds_group_summary(
  data = sud,
  gvar = treat,
  cvar = sfs8p_0
)
plot(grouped_sfs8p_0)

# The following will replicate what we did in lines 30 through 47 but
# all in line and this function can be used to do this for all variables.
ds_screener_all(data = sud, var = "sfs8p_0")

# Prepare data for R02-Analysis.R ==============================================

# Make sud a data.frame
sud <- data.frame(sud)

# Make treatment a a binary indicator of 0’s and 1’s.
# A function in R02-Analysis.R requires we specify the treatment indicator as a
# binary indicator where 1 indicates the target treatment group and 0 is the
# other group.
sud$treat <- ifelse(sud$treat == "A", 1, 0)

# Only keep the relevant variables in this analysis from our EDA results 

sud <- sud %>%
  dplyr::select(
    treat, sfs8p_6, sfs8p_0, eps7p_0, sati_0, ada_0,
    recov_0, tss_0, dss9_0, subsgrps_n
  )

# Write file  ==================================================================
save(sud, file = "output/sud-forR02.rda")

# Print session info at end of file ============================================
sessionInfo()
