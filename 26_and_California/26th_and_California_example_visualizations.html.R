stop()

##==============================================================================
## INITIALIZATION
##==============================================================================

source('00 Initialize.R')

##==============================================================================
## Read CSV
##==============================================================================

rawdat = read.table(
	file = 'Database 2013-01-21 (8zQ4cW7T).csv', sep=',', quote='"', 
	flush=FALSE, header=TRUE, nrows=-1, fill=FALSE, stringsAsFactors=FALSE,
	na.strings=c('None', ''))
str(rawdat)
dat = as.data.table(rawdat)
str(dat)

## Convert booking and discharge dates to date time objects
## EXAMPLE FORMAT: 2012-12-30T20:57:19.616186
dat$booking_date = ExtractIsoTime(dat$booking_date)
dat$discharge_date_earliest = ExtractIsoTime(dat$discharge_date_earliest)


table(dat$race, useNA='ifany')

## I'm going to guess that W and WH are both "White"
dat$race = sub('^W$', 'WH', dat$race)
## I'm going to guess that B and BK are both "White"
dat$race = sub('^B$', 'BK', dat$race)

table(dat$race, useNA='ifany')

##==============================================================================
## Some Tables
##==============================================================================

## Summary of how many unique values and missing values exist in the data
NAsummary(dat)


table(dat$gender, useNA='ifany')
table(dat$charges_citation, useNA='ifany')
table(dat$charges, useNA='ifany')

table(is.na(dat$charges))
table(is.na(dat$charges_citation))

## Write Temp File (what did you think it would do?)
# wtf(dat)

##==============================================================================
## Some plots
##==============================================================================

## Checking to see if the dates imported correctly
plot(dat$discharge_date_earliest , 1:nrow(dat))
plot(dat$booking_date , 1:nrow(dat))  ## Usually organzied by booking date?

range(dat$booking_date, na.rm=TRUE)


plot(dat$booking_date, dat$discharge_date_earliest)


hist(dat$bail_amount, 100)
hist(pmin(dat$bail_amount, 1000000), 100)
hist(dat$age_at_booking, 100)


plot(dat$age_at_booking, dat$bail_amount)
plot(log(bail_amount)~age_at_booking, dat)


boxplot(bail_amount~age_at_booking, dat)
boxplot(pmin(bail_amount, 5e5)~age_at_booking, dat)
boxplot(log(bail_amount)~age_at_booking, dat)


library(mgcv)
bailbyage.gam = gam(bail_amount ~ s(age_at_booking), data=dat)
plot(bailbyage.gam)

plot(dat$age_at_booking, dat$bail_amount)
lines(predict(bailbyage.gam), col='red')





ggplot(dat, aes(x=age_at_booking, fill=factor(race))) +
	geom_density() + 
	facet_grid(race ~ .)+
	xlab("Age at booking") + 
	ylab("Density by race") +
	theme(plot.title = element_text(size = 20)) +
	labs(title='Age at booking summary\n')

ggplot(dat, aes(x=bail_amount, fill=factor(race))) +
	geom_density() + 
	facet_grid(race ~ .)+
	xlab("Age at booking") + 
	ylab("bail amount by race") +
	theme(plot.title = element_text(size = 20)) +
	labs(title='Bond by race summary\n')



ggplot(dat, aes(x=age_at_booking, fill=factor(gender))) +
	geom_density(alpha=.7) + 
	facet_grid(gender ~ .)+
	xlab("Age at booking") + 
	ylab("Density by race") +
	theme(plot.title = element_text(size = 20)) +
	labs(title='Age at booking summary\nby gender\n')
ggplot(dat, aes(x=age_at_booking, fill=factor(gender))) +
	geom_density(alpha=.7) + 
	facet_grid(race ~ .)+
	xlab("Age at booking") + 
	ylab("Density by race") +
	theme(plot.title = element_text(size = 20)) +
	labs(title='Age at booking summary\nby gender and race\n')

ggplot(dat, aes(x=bail_amount, fill=factor(gender))) +
	geom_density() + 
	facet_grid(gender ~ .)+
	xlab("Age at booking") + 
	ylab("bail amount by race") +
	theme(plot.title = element_text(size = 20)) +
	labs(title='Bond by race summary\n')


mycolors = c(
	'red','red','darkred','darkred','darkred','red','red',
	'goldenrod','yellow','goldenrod',
	'green','green','darkgreen','darkgreen','darkgreen','green','green')
geom_density
ggplot(dat, 
	   aes(x=as.numeric(eventlength), y=logweightchange, size=energy, 
	   	colour=logweightchange)) +     
	geom_point()  + 
	xlab("Length of Event (in seconds) LOG SCALED") + 
	ylab("Change in Weight LOG SCALED") +
	theme(plot.title = element_text(size = 20)) +
	labs(title='Change in weight by duration of event for site 1212\n') +
	scale_colour_gradientn(colours = mycolors) +
	scale_x_log10() + 
	theme(panel.background = element_rect(fill = "gray60", colour = "black")) +
	theme(panel.grid.major = element_line(colour = "gray40")) +
	theme(panel.grid.minor = element_line(colour = "gray70", linetype = "dotted"))







