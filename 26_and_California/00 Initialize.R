
##==============================================================================
## SET GLOBAL OPTIONS
##==============================================================================
options(stringsAsFactors=FALSE)
options(digits.secs=4)
options(warn=1)

##==============================================================================
## DETACH NON-STANDARD LIBRARIES
##==============================================================================
standard_packages = c('stats', 'graphics', 'grDevices', 'utils', 'datasets', 
                      'methods', 'base')

## DTW can only be loaded once per R session, so don't detach it
# special_packages = c('dtw', 'proxy')
special_packages = NA

attached_packages = .packages()

cat('\nDetaching non-standard libraries:\n')

for(pkg in attached_packages){
    if(! (pkg %in% standard_packages || pkg %in% special_packages) ){
        cat('Detaching:', pkg, '\n')
        detach(paste('package:', pkg, sep=''), character.only=TRUE)
    }
}

##==============================================================================
## Check if required libraries are installed
##==============================================================================

cat('\nInstalling missing libraries (if needed)\n')

## Packages needed for this project:
required_packages = c('geneorama', 'data.table', 'ggplot2', 'zoo')

## Packages installed on this computer
installed_pacakges =  .packages(all.available = TRUE)

## Try and install any missing packages
for(pkg in c(required_packages, na.omit(special_packages))){
    ## Check for missing packages
    if( ! pkg %in% installed_pacakges && ! pkg %in% attached_packages ){
        cat(rep('*', 80), '\n', sep='')
        cat('Attempting to install', pkg, '\n')
        cat(rep('*', 80), '\n', sep='')
        install.packages(pkg)
        
        ## Update the list of installed packages
        ## Some packages that were missing may get installed as dependencies
        installed_pacakges =  .packages(all.available = TRUE)
    }
}

## Try and install Geneorama, if missing
if( ! 'geneorama' %in% installed_pacakges ){
    cat(rep('*', 80), '\n', sep='')
    cat('Attempting to install Geneorama\n')
    cat(rep('*', 80), '\n', sep='')
    source('InstallGeneorama.R')
    # InstallGeneorama()
    ## Update the list of installed packages
    installed_pacakges =  .packages(all.available = TRUE)
}

##==============================================================================
## load libraries
##==============================================================================

cat('\nLoading required libraries:\n')

for(pkg in c(required_packages, na.omit(special_packages))){
    ## Check that the package is not missing, display a warning if it is
    if( pkg %in% installed_pacakges && ! pkg %in% .packages()){
        cat('Attaching:', pkg, '\n')
        library(pkg, character.only=TRUE, quietly=TRUE)
    } else {
        if( ! pkg %in% installed_pacakges){
            cat(rep('*', 80), '\n', sep='')
            cat('This package could not be loaded because it is not installed:',
                pkg, '!\n')
            cat(rep('*', 80), '\n', sep='')
        }
    }
}

##==============================================================================
## Clear the global workspace
##==============================================================================

rm(list=ls())

## Force garbage collection
gc(reset=TRUE)

##==============================================================================
## Load any project functions
##==============================================================================

if(require(geneorama)){
    sourceDir('functions')
} else {
    function_path = 'functions'
    for (nm in list.files(function_path, pattern = "\\.[Rr]$")) {
        cat('loading file:', nm, ":")
        source(file.path(function_path, nm))
        cat("\n")
    }
    rm(function_path, nm)
}

