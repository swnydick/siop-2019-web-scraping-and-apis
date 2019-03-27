###############################
# Template Source/Config File #
#                             #
# Steven W. Nydick            #
# 2019-03-20                  #
###############################

# EXAMPLE OVERRIDES #

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
bic_prc_override <- c(`NA`     = 0.57,
                      `BALA`   = 0.78,
                      `MENTAL` = 5.5)

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
labels_override              <- list()
labels_override$competencies <- list(`Mission Critical` = c("BST", "DWO", "COL", "COM", "DTA", "SDV", "SVI"),
                                     `Critical`         = c("ACO", "CFO", "DQU", "GPE", "NLE"),
                                     `Less Critical`    = c("MAB", "CIN", "NNE", "EIN"))

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
names_override               <- c(`BALA` = "Rebekah")

#################
# general plots #
#################

# OVERALL #

# Do you want a distribution plot with initials per candidate?
# - if yes, set per_cand to TRUE; otherwise FALSE
per_cand_plots    <- FALSE

# Do you want to suppress all BICs in the graphics?
kill_bic          <- FALSE

# COMPETENCIES #

# Do you want to sort the competencies by BIC (for group) or mean score (for individual)?
# - if yes, TRUE; otherwise FALSE
sort_competencies <- FALSE