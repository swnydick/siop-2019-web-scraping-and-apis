###############################
# Template Source/Config File #
#                             #
# Steven W. Nydick            #
# 2019-03-20                  #
###############################

# MODIFY WITH YOUR OWN CONFIGURATIONS #

###########
# OVERALL #
###########

# save name
save_name      <- "KF4D Report"

# client name for the aggregate plots
client_name    <- "KF4D Client"

# bench name for UCP lines on the aggregate plots
bench_name     <- "Unique Client Profile"

# include final plots in a plots folder
include_plots  <- FALSE

# include an excel workbook
include_tables <- TRUE

###################
# plot breakdowns #
###################

# BIC Plot Percentage Transform Override
# - If the the aggregate graphics look funny in the BIC (grey splotches), you
#   can override the plot transform percentages here.
# - Note that the score ranges from 0 to 1 (for all but learning agilities, where
#   the score ranges from 1 to 10). You need to supply a named vector for
#   override.
# - Example: If you wanted to override the Need For Achievement and Balance BIC
#   plot transforms bic_prc_override <- c(`NA` = 0.57, `BALA` = 0.78)
bic_prc_override <- NULL

# Sub Grouping
# - Change this to the vector/names of your subgroups.
# - Example: If you want to group data by "Gender", set sub_group <- "Gender"
sub_group        <- NULL

##########
# labels #
##########

# - If you want to use the default labels, set this to NULL
# - If you want to group or arrange labels differently for plotting purposes,
#   indicate HOW you want to arrange the labels, including additional super-factors,
#   etc.
# - If an element of labels_override is a list of vectors, the names of the list
#   are treated as superfactors.
# - If an element of labels_override is a character vector, then it's assumed
#   that the list HAS no superfactors.

# Example Override:
# labels_override              <- list()
# labels_override$traits       <- list(Blah = c("HU", "TR", "OP", "SS"),
#                                      EEk  = c("CP", "AGR", "IN"))
# labels_override$competencies <- list(`Mission Critical` = c(),
#                                      `Critical`         = c(),
#                                      `Less Critical`    = c())
labels_override <- NULL

# - If you want to use default names, set this to NULL
# - If you want to change the names of a competency/trait/driver (or add a
#   name if one doesn't exist), create a vector assigned to the construct
#   with the names of the vector equal to the abreviation and the value equal
#   to the rename

# Example Override:
# names_override              <- list()
# names_override$drivers      <- c(`SS`  = "Silly Willies")
# names_override$traits       <- c(`HU`  = "Alternative Excessiveness",
#                                  `TR`  = "Blah Bleeee Blummness")
# names_override$competencies <- c(`BST` = "Beagles for Sale",
#                                  `CP`  = "Crapp")
names_override  <- NULL

#################
# general plots #
#################

# PLOT FLAGS #

# Do you want the plots?
plot_learning_agilities <- FALSE
plot_risk_factors       <- FALSE

# OVERALL #

# Do you want fancy group plots or just bar plots?
fancy_group_plots <- TRUE

# Set initials_yes to TRUE to show initials on the individual distribution plot
# Set initials_yes to FALSE to not show initials ...
# - if yes, the data in the candidate tab must contain a column called 'initials'
use_initials      <- TRUE

# Do you want a distribution plot with initials per candidate?
# - if yes, set per_cand to TRUE; otherwise FALSE
per_cand_plots    <- FALSE

# Do you want to suppress all BICs in the graphics?
kill_bic          <- FALSE

# COMPETENCIES #

# Do you want to sort the competencies by BIC (for group) or mean score (for individual)?
# - if yes, TRUE; otherwise FALSE
sort_competencies <- TRUE

##############
# GRID PLOTS #
##############

# CREATE GRID #

# Want talent grid? set create_grid to TRUE; FALSE otherwise (see README USER)
create_grid     <- FALSE
create_grid_bar <- FALSE

# GRID COMPONENTS #

# Grid Component:
# - If used_cons is NULL, the grid picks the top 8 competencies, top 6 traits,
#   top 2 drivers based on BIC score (by default)
# - If used_cons is TRUE or "all", the grid plots all of the competencies,
#   traits, and drivers
# - If used_cons is a numeric vector of length 3, the grid plots to the top
#   competencies/traits/drivers based on the first, second, and third element
#   (if you want to NOT plot one, set its element to 0)
# - If used_cons is a list of character vectors of competency/traits/driver
#   abbreviations, the grid plots the competencies/traits/drivers listed.
#   (if you want to NOT plot one, set its element to NULL in the list, e.g.,
#    used_cons$traits <- NULL will result in traits not being plotted)

# Example Override:
# used_cons <- list()
# used_cons$competencies <- c('AEX', 'PER')
# used_cons$traits       <- c('AD', 'IN', 'AS')
# used_cons$drivers      <- c('BALA', 'CHAL')
used_cons     <- TRUE

# The grid_bar uses the grid specification by default, but picks the top 8
# competencies, top 6 traits, and top 2 drivers based on BIC score if
# used_cons_bar <- NULL.

# If you want to override the above behavior, do exactly the same thing as in
# used_cons

# Example Override:
# use_cons_bar <- list()
# use_cons_bar$competencies <- c('AEX', 'PER')
# use_cons_bar$traits       <- c('AD', 'IN', 'AS')
# use_cons_bar$drivers      <- c('BALA', 'CHAL')
used_cons_bar <- used_cons

# OVERALL FIT #

# This next argument adjusts the fit behavior. By default all competencies,
# traits, and drivers are used to created the overall fit score, regardless of
# what shows up in the grid. Set this next argument to FALSE if you only want to
# use what is contained in the use_cons argument. This argument exists for when
# we use this app for KFAS driven by success profiles from the Talent Hub
all_cons       <- TRUE

# REVERSE SCORED #

# This argument determines which competencies are reverse scored.
# - balance is ALWAYS reverse scored and this is unchangeable
# - other vars can be reverse scored by adding them to rev_cons
# Example Override:
# rev_cons <- c("FO", "SS")
rev_cons      <- NULL

# ROW/COLUMN ORDER AND MARGIN #

# Set to TRUE if you want overall/traits/drivers/competencies to be on separate
# pages otherwise set to FALSE (for both grid and grid_bar)
split_grid_by_construct     <- TRUE
split_grid_bar_by_construct <- TRUE

# Set to one of the following three:
# - "natural" will have the column ordering of the grid be based on use_cons
# - "bic" will have the column ordering of the grid be based on the "bic"
# - "group" will have the column ordering of the grid be based on the mean
#   score for this particular group on each variable (for both grid and grid_bar)
# either "natural", "bic", or "group"
grid_column_order           <- "group"
grid_bar_column_order       <- "group"

# Set to one of the following three:
# - "natural" will have the row order the same as the data
# - "construct" will have the row order (ONLY if split_grit_by_construct)
#   based on the construct (trait/driver/competency/overall)
# - "overall" will have the row order based ALWAYS on the overall fit score
grid_row_order              <- "construct"

# This argument determines if the marginal traits/drivers/competencies are
# included in the grid plot.
# - If include_marginal_fit = TRUE, OVERALL traits/driver/competencies are include,
# - If include_marginal_fit = FALSE, they are left out of the final plot.
include_marginal_fit        <- TRUE

# This argument determines if the overall grid scores are included in the grid
# plot.
# - If include_overall_fit = TRUE, OVERALL fit scores are included,
# - If include_overall_fit = FALSE, OVERALL fit scores are not included
include_overall_fit         <- TRUE
