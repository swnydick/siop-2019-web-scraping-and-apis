###################################
# SOURCE FILE FOR KFRA REPORT APP #
#                                 #
# Steven W. Nydick                #
# 2018-07-17                      #
###################################

# USER: TO ACCESS THE HELP PAGE, UNCOMMENT AND RUN THE FOLLOWING LINE
# vignette("readme", package = "app.kfra.group.report")

# set working directory to where this source file is
# - if rstudio is running, use that to determine path
# - otherwise, assume you are sourcing the file
src_dir <- tryCatch(dirname(rstudioapi::getSourceEditorContext()$path),
                    error = function(x){
                      getSrcDirectory(function(x) {x})
                    })

# - if there is no path, you need to set the path manually
if(src_dir == ""){
  src_dir <- "~/Documents/kfra_group_report/"
} # END if STATEMENT

# run the application
kfinstall::launch_application(app_pkg         = "app.kfra.group.report",
                              app_dir         = src_dir,
                              force_install   = FALSE,
                              launch_function = "launch_application")
