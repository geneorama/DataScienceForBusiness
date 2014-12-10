
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
required_packages <- c("geneorama", "knitr", "data.table", "rpart",
					   "partykit", "coin")
geneorama::loadinstall_libraries(required_packages)


##==============================================================================
## LOAD DATA
## SOURCE: https://datacatalog.cookcountyil.gov/Finance-Administration/Cook-County-Check-Register/gywr-fjeh
##==============================================================================

url_address <- "https://datacatalog.cookcountyil.gov/api/views/gywr-fjeh/rows.csv?accessType=DOWNLOAD"
localfile <- 'data/Cook_County_Check_Register.csv'

if(!file.exists('data')) dir.create('data')

if(!file.exists(localfile)) {
	download.file(url = url_address, 
				  destfile = localfile)
}

dat <- data.table(read.table(file=localfile,
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
## TABLES (ANALYSIS)
##==============================================================================


payment_summary <- dat[i = TRUE,
					   j = list(.N, 
					   		 pmts = sum(PAYMENT_AMOUNT)),
					   by = list(SERVICE_TYPE_DESC)]


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

hist(dat[,.N, SERVICE_TYPE_DESC]$N, breaks = 150)
pie(dat[,.N,SERVICE_TYPE_DESC]$N, 
	labels = dat[,.N,SERVICE_TYPE_DESC]$SERVICE_TYPE_DESC)

NAsummary(dat)



##==============================================================================
## RPART MODEL
##==============================================================================

rpartModelHuge <- rpart(
	BUSINESS_UNIT_CODE ~ ., 
	control = rpart.control(cp = 0.001, minsplit=2, xval=10),
	data = dat[,list(pmt = PAYMENT_AMOUNT,
					 year = year(CHECK_DATE),
					 month = month(CHECK_DATE),
					 BUSINESS_UNIT_CODE = as.factor(BUSINESS_UNIT_CODE),
					 BUSINESS_UNIT_NAME = as.factor(BUSINESS_UNIT_NAME))])
rpartModelHuge

cptab = as.data.frame(rpartModelHuge$cptable)
cptab

plotcp(rpartModelHuge)

plot(as.party(prune(rpartModelHuge, cp=rpartModelHuge$cptable[2, "CP"])))
plot(as.party(prune(rpartModelHuge, cp=rpartModelHuge$cptable[3, "CP"])))
plot(as.party(prune(rpartModelHuge, cp=rpartModelHuge$cptable[4, "CP"])))
plot(as.party(prune(rpartModelHuge, cp=rpartModelHuge$cptable[5, "CP"])))
plot(as.party(prune(rpartModelHuge, cp=rpartModelHuge$cptable[6, "CP"])))
plot(as.party(prune(rpartModelHuge, cp=rpartModelHuge$cptable[7, "CP"])))
plot(as.party(prune(rpartModelHuge, cp=rpartModelHuge$cptable[8, "CP"])))
plot(as.party(prune(rpartModelHuge, cp=rpartModelHuge$cptable[9, "CP"])))
plot(as.party(prune(rpartModelHuge, cp=rpartModelHuge$cptable[10, "CP"])))
print(as.party(prune(rpartModelHuge, cp=rpartModelHuge$cptable[10, "CP"])))


rpm <- prune(rpartModelHuge, cp=rpartModelHuge$cptable[2, "CP"])
rpm <- prune(rpartModelHuge, cp=rpartModelHuge$cptable[3, "CP"])
rpm <- prune(rpartModelHuge, cp=rpartModelHuge$cptable[4, "CP"])
rpm <- prune(rpartModelHuge, cp=rpartModelHuge$cptable[6, "CP"])
rpm <- prune(rpartModelHuge, cp=rpartModelHuge$cptable[7, "CP"])
rpm <- prune(rpartModelHuge, cp=rpartModelHuge$cptable[8, "CP"])
rpm <- prune(rpartModelHuge, cp=rpartModelHuge$cptable[9, "CP"])
rpm <- prune(rpartModelHuge, cp=rpartModelHuge$cptable[10, "CP"])
plot(as.party(rpm))

str(rpm)











