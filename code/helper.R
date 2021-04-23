# File Info ====================================================================
# helper.R
# Convenient functions to use in RXX- series

# Print session info at beginning of file ======================================
sessionInfo()

# Functions  ===================================================================

# Check for NAs
any_NAs <- function(x) {
  # Description: check if variable has NA values
  # Input:
  # x - a vector of values
  # Output: a scaler (TRUE or FALSE)
  return(any(is.na(x)))
}

# Sum NAs
sum_NAs <- function(x) {
  # Description: count the number of NA values
  # Input:
  # x - a vector of values
  # Output: a numeric scalar
  return(sum(is.na(x)))
}

# Sum NAs
ds_screener_all <- function(data, var) {
  # Description: utilize descriptr to show summary stats by variables
  # Input:
  # data - a tibble or data.frame
  # var - a column name in data that summary info will be produced for
  # g_var - the grouping variable representing the grouping variable in data
  # Output: summary statistics and plots from the descriptr package


  # We utilize the descriptr package to produce summary statistics
  # we can change what columns we want to produce summary stats
  ds_summary_stats(
    data,
    var
  )

  # Frequency table - set bins - produce histogram
  baseline_outcome <- ds_freq_table(data,
    var,
    bins = 7
  )
  plot(baseline_outcome)
}

# Print session info at end of file ============================================
sessionInfo()
