##==============================================================================
## INITIALIZE
##==============================================================================
## Remove all objects; perform garbage collection
rm(list=ls())
gc(reset=TRUE)
## Check for dependencies
if(!"geneorama" %in% rownames(installed.packages())){
    if(!"devtools" %in% rownames(installed.packages())){install.packages('devtools')}
    devtools::install_github('geneorama/geneorama')
}
## Load libraries
geneorama::detach_nonstandard_packages()
geneorama::loadinstall_libraries(c("geneorama"))
geneorama::sourceDir("Lec4//functions/")

##==============================================================================
## DEFINE GLOBAL VARIABLES
##==============================================================================

## Application Tokens for Socrata API:
## Obtain tokens by registering on socrata.com
## Note: only the first line is used 
## Note: whitespace and comments will be stripped
token_path <- "Lec4/socrata_token.txt"
if(!file.exists(token_path)){
    stop(paste0("You need to register for an API token on socrata.com, and ",
                "put it into a file called 'socrata_token.txt' in order to ",
                "download the files from the data portal"))
} else{
    mytoken <- gsub(" |\\#.+", "", readLines(token_path, n=1))
}

## Set "multi" to true to use parallel processor to download
## Check your platform for compatibility!  (best on Linux based systems)
# multi <- FALSE
multi <- TRUE
if(multi){
    geneorama::loadinstall_libraries(c("doMC", "parallel", "iterators"))
}

multi <- FALSE

##==============================================================================
## DOWNLOAD FILES FROM DATA PORTAL AS CSV
##==============================================================================
chi_dp_downloader(db="ijzp-q8t2",
                  outdir = "Lec4/data/crime", 
                  multicore = multi, 
                  apptoken = mytoken, 
                  useaskey = "id",
                  where_query = "primary_type='BURGLARY'")
chi_dp_downloader(db="9ksk-na4q", 
                  outdir = "Lec4/data/garbage_carts", 
                  multicore = multi, 
                  apptoken = mytoken, 
                  useaskey = "service_request_number")
chi_dp_downloader(db="me59-5fac", 
                  outdir = "Lec4/data/sanitation_code", 
                  multicore = multi, 
                  apptoken = mytoken, 
                  useaskey = "service_request_number")


##==============================================================================
## CONSOLODATE MULTIPLE CSV FILES IN FOLDERS INTO ONE RDS FILE PER FOLDER
## (ALSO CHECK FOR DATES AND CONVERT THOSE)
##==============================================================================
chi_dp_csv2rds(indir = "Lec4/data/crime")
chi_dp_csv2rds(indir = "Lec4/data/garbage_carts")
chi_dp_csv2rds(indir = "Lec4/data/sanitation_code")

## Delete the files and the directories that held the temporary downloaded parts
unlink("Lec4/data/crime/*")
unlink("Lec4/data/crime", recursive = T, force=T)
unlink("Lec4/data/garbage_carts/*")
unlink("Lec4/data/garbage_carts", recursive = T, force=T)
unlink("Lec4/data/sanitation_code/*")
unlink("Lec4/data/sanitation_code", recursive = T, force=T)

#==============================================================================
## SMALL FIXES TO RDS FILES
##==============================================================================

## read in data that has been downloaded
crime <-  readRDS("Lec4/data/crime.Rds")
garbageCarts <- readRDS("Lec4/data/garbage_carts.Rds")
sanitationComplaints <- readRDS("Lec4/data/sanitation_code.Rds")

## Convert any integer columns to numeric
## Although numeric takes up more space and is slightly slower, keeping these
## fields as numeric avoids problems with integer overflow and models that
## can't handle integers.  
geneorama::convert_datatable_IntNum(crime)
geneorama::convert_datatable_IntNum(garbageCarts)
geneorama::convert_datatable_IntNum(sanitationComplaints)

## Ensure that Arrest and Domestic are Logical values
crime[ , Arrest := as.logical(Arrest)]
crime[ , Domestic := as.logical(Domestic)]

## If you are inclined, uncomment and view the structures of your downloaded 
## data before saving to see if it makes sense.
# str(crime)
# str(garbageCarts)
# str(sanitationComplaints)

## Remove one row where the header is (somewhat) repeated
sanitationComplaints <- sanitationComplaints[Service_Request_Number!="SERVICE REQUEST NUMBER"]

saveRDS(crime , "Lec4/data/crime.Rds")
saveRDS(garbageCarts , "Lec4/data/garbage_carts.Rds")
saveRDS(sanitationComplaints , "Lec4/data/sanitation_code.Rds")
