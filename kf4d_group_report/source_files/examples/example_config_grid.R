###############################
# Template Source/Config File #
#                             #
# Steven W. Nydick            #
# 2019-03-20                  #
###############################

# EXAMPLE GRID #

##############
# GRID PLOTS #
##############

# CREATE GRID #

# Want talent grid? set create_grid to TRUE; FALSE otherwise (see README USER)
create_grid     <- TRUE
create_grid_bar <- TRUE

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
used_cons              <- list()
used_cons$competencies <- c("BST", "ACO", "BET", "BRE", "CIN", "DWO", "NNE")
used_cons$traits       <- c("FO", "OP", "SS", "CF", "NA", "PE")
used_cons$drivers      <- c("BALA", "COLL", "POWR", "CHAL")

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
used_cons_bar <- TRUE

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
rev_cons      <- c("FO")

# ROW/COLUMN ORDER AND MARGIN #

# Set to TRUE if you want overall/traits/drivers/competencies to be on separate
# pages otherwise set to FALSE (for both grid and grid_bar)
split_grid_by_construct     <- FALSE
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
