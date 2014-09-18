
##==============================================================================
## INITIALIZE
##==============================================================================

## Clear global environment
rm(list=ls())
gc(reset=TRUE)

## Check for dependencies
if(!"geneorama" %in% rownames(installed.packages())){
	if(!"devtools" %in% rownames(installed.packages())){
		install.packages('devtools')
	}
	devtools::install_github('geneorama/geneorama')
}

## Load libraries
geneorama::detach_nonstandard_packages()
required_packages <- c("geneorama", "knitr", "data.table", "rpart")
geneorama::loadinstall_libraries(required_packages)


##==============================================================================
## LOAD DATA
## SOURCE: https://datacatalog.cookcountyil.gov/Finance-Administration/Cook-County-Check-Register/gywr-fjeh
##==============================================================================

url <- "https://datacatalog.cookcountyil.gov/api/views/gywr-fjeh/rows.csv?accessType=DOWNLOAD"
localfile <- 'data/Cook_County_Check_Register.csv'

if(!file.exists('data')) dir.create('data')

if(!file.exists(localfile)) download.file(url, localfile)

fp <- 'C:/Users/375492/Downloads/Cook_County_Check_Register.csv'

dat <- data.table(read.table(file=fp,
							 header = TRUE, 
							 sep = ",", 
							 comment = "", 
							 quote = "\"",  
							 nrows = -1,
							 stringsAsFactors = FALSE))
dat

str(dat)
dat[,PAYMENT_AMOUNT := as.numeric(gsub("\\$", "", PAYMENT_AMOUNT))]
dat[ , CHECK_DATE := as.IDate(CHECK_DATE, "%m/%d/%Y")]

##==============================================================================
## ANALYSIS
##==============================================================================
dat[i = TRUE,
	j = list(.N, pmts=sum(PAYMENT_AMOUNT)),
	by = list(SERVICE_TYPE_DESC)][order(N), 
								  list(SERVICE_TYPE_DESC, 
								  	 N,
								  	 comma(pmts, nDigits = 0))]
dat[i = TRUE,
	j = list(N = comma(.N,0), 
			 pmts=comma(sum(PAYMENT_AMOUNT), 0)),
	keyby = list(year = year(CHECK_DATE))]

# hist(dat[,.N, SERVICE_TYPE_DESC]$N)
# pie(dat[,.N,SERVICE_TYPE_DESC]$N, 
# 	labels = dat[,.N,SERVICE_TYPE_DESC]$SERVICE_TYPE_DESC)

NAsummary(dat)

# dat
# 
# clipper()
# 
# wtf(dat)


