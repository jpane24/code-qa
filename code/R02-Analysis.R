# File Info ====================================================================
# R02-Analysis.R
# File looks at descriptive data from R00-Data-Cleaning.R by producing summary
# statistics and basic data visualizations
# data input: output/sud-forR01.rda
# data output: None

# Print session info at beginning of file ======================================
sessionInfo()

# Load relevant R packages/files ===============================================
library(tidyverse)
library(twang)
library(OVtool)
library(survey)
source("code/helper.R")

# Load data ====================================================================
load("output/sud-forR02.rda")

# Propensity score model =======================================================

# Create Formula
fmla_ps <- as.formula(treat ~ sfs8p_0 + eps7p_0 + sfs8p_0 + sati_0 + ada_0 +
  recov_0 + tss_0 + dss9_0 + subsgrps_n)

# Run ps model
# estimand is ATE
# using default settings in twang
ps_twang <- twang::ps(fmla_ps,
  data = sud,
  estimand = "ATE",
  booster = "xgboost",
  stop.method = "ks.max",
  verbose = F
)

# Check Balance
twang::bal.table(ps_twang)
plot(ps_twang, 1)
plot(ps_twang, 2)
plot(ps_twang, 3)
plot(ps_twang, 4)

# Balance looks good

# Get weights
sud$weights <- ps_twang$w$ks.max.ATE

# Outcome model ================================================================
# specify the complex survey design using the weights generated from the ps
# model
design_mod <- survey::svydesign(
  ids = ~1,
  weights = ~weights,
  data = sud
)

# run outcome model using svyglm. We didn't have any issues with balance but
# we still are running a doubly robust model to account for any lingering
# imbalance.
mod_results <- survey::svyglm(sfs8p_6 ~ treat + sfs8p_0 + eps7p_0 + sfs8p_0 + sati_0 +
  ada_0 + recov_0 + tss_0 + dss9_0 + subsgrps_n,
design = design_mod
)

# print results
summary(mod_results)

# Note: we have a significant treatment effect.
# From the results, we observe that the estimated treatment effect is
# significantly negative, whereby youth receiving treatment A have slightly
# higher lower problems at the 3-month follow-up than youth in treatment
# program B.

# Sensitivity analysis =========================================================
# We utilize OVtool to check to see how robust our findings are to omitted
# variables when estimating causal effects using propensity score (PS) weighting.

# First let's replicate the outcome model that we ran above
ov_results <- OVtool::outcome_model(
  data = sud,
  weights = "weights",
  treatment = "treat",
  outcome = "sfs8p_6",
  model_covariates = c(
    "eps7p_0", "sfs8p_0",
    "sati_0", "ada_0",
    "recov_0", "tss_0",
    "dss9_0", "subsgrps_n"
  ),
  estimand = "ATE"
)

summary(ov_results$mod_results) # Yay, looks good

# Second we can run the ov analysis
ovtool_results_twang <- OVtool::ov_sim(
  model_results = ov_results,
  plot_covariates = c(
    "eps7p_0", "sfs8p_0",
    "sati_0", "ada_0",
    "recov_0", "tss_0",
    "dss9_0", "subsgrps_n"
  ),
  n_reps = 50,
  progress = TRUE
)

# Get summary graphics - Figure th
OVtool::plot.ov(ovtool_results_twang, print_graphic = "3", col = "color")

# Get summary text
OVtool::summary.ov(ovtool_results_twang, model_results = ov_results)

# Print session info at end of file ============================================
sessionInfo()
