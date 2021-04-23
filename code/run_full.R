# File Info ====================================================================
# run_full.R
# Runs entire analysis
# data input: None
# data output: None

# Print session info at beginning of file ======================================
sessionInfo()

# Run all ======================================================================
source("code/R00-Data-Cleaning.R")
source("code/R01-EDA.R")
source("code/R02-Analysis.R")

# Print session info at end of file ============================================
sessionInfo()

# Appendix =====================================================================
# Can use the following to run all:
# source("code/run_full.R")
# Go to directory where the repository sits
# cd code
# R CMD BATCH run_full.R run_full_output.Rout
