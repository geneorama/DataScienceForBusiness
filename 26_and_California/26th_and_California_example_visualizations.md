

# Example Visualizations for meetup 
### by Gene Leynes

http://www.meetup.com/The-Chicago-Data-Visualization-Group/events/97690792/
## Workshop: Develop a Data App using <br>Raphael, D3, HTML and Backbone <br>(Week 3)
Date: January 28
Location: 1871

These are some example visualizations and data handling methods for discussion at the meetup.


## INITIALIZATION


```r
opts_chunk$set(tidy = FALSE)
```



```r
source('00 Initialize.R')
```




## READ CSV AND CONVERT SOME VALUES


```r
rawdat = read.table(
	file = 'Database 2013-01-21 (8zQ4cW7T).csv', sep=',', quote='"', 
	flush=FALSE, header=TRUE, nrows=-1, fill=FALSE, stringsAsFactors=FALSE,
	na.strings=c('None', ''))
str(rawdat)
```

```
## 'data.frame':	19207 obs. of  11 variables:
##  $ charges_citation       : chr  "720 ILCS 5 12-3.4(a)(2) [16145" "625 ILCS 5 6-101 [12935]" "720 ILCS 5 12-3(a)(1) [10529]" "720 ILCS 550 5(c) [5020200]" ...
##  $ race                   : chr  "WH" "LW" "BK" "BK" ...
##  $ age_at_booking         : int  26 37 18 32 49 26 41 56 40 20 ...
##  $ gender                 : chr  "M" "M" "M" "F" ...
##  $ booking_date           : chr  "2013-01-20T00:00:00" "2013-01-20T00:00:00" "2013-01-20T00:00:00" "2013-01-20T00:00:00" ...
##  $ jail_id                : chr  "2013-0120171" "2013-0120170" "2013-0120169" "2013-0120167" ...
##  $ bail_status            : chr  NA NA NA NA ...
##  $ housing_location       : chr  "05-" "05-" "05-L-2-2-1" "17-WR-N-A-2" ...
##  $ charges                : chr  NA NA NA NA ...
##  $ bail_amount            : int  5000 10000 5000 50000 5000 5000 25000 5000 25000 10000 ...
##  $ discharge_date_earliest: chr  NA NA NA NA ...
```

```r
dat = as.data.table(rawdat)
str(dat)
```

```
## Classes 'data.table' and 'data.frame':	19207 obs. of  11 variables:
##  $ charges_citation       : chr  "720 ILCS 5 12-3.4(a)(2) [16145" "625 ILCS 5 6-101 [12935]" "720 ILCS 5 12-3(a)(1) [10529]" "720 ILCS 550 5(c) [5020200]" ...
##  $ race                   : chr  "WH" "LW" "BK" "BK" ...
##  $ age_at_booking         : int  26 37 18 32 49 26 41 56 40 20 ...
##  $ gender                 : chr  "M" "M" "M" "F" ...
##  $ booking_date           : chr  "2013-01-20T00:00:00" "2013-01-20T00:00:00" "2013-01-20T00:00:00" "2013-01-20T00:00:00" ...
##  $ jail_id                : chr  "2013-0120171" "2013-0120170" "2013-0120169" "2013-0120167" ...
##  $ bail_status            : chr  NA NA NA NA ...
##  $ housing_location       : chr  "05-" "05-" "05-L-2-2-1" "17-WR-N-A-2" ...
##  $ charges                : chr  NA NA NA NA ...
##  $ bail_amount            : int  5000 10000 5000 50000 5000 5000 25000 5000 25000 10000 ...
##  $ discharge_date_earliest: chr  NA NA NA NA ...
##  - attr(*, ".internal.selfref")=<externalptr>
```

```r

## Convert booking and discharge dates to date time objects
## EXAMPLE FORMAT: 2012-12-30T20:57:19.616186
dat$booking_date = ExtractIsoTime(dat$booking_date)
dat$discharge_date_earliest = ExtractIsoTime(dat$discharge_date_earliest)

table(dat$race, useNA='ifany')
```

```
## 
##    AS     B    BK    IN    LB    LT    LW     W    WH 
##   117    29 13879    13    68  1803  1239    44  2015
```

```r

## I'm going to guess that W and WH are both "White"
dat$race = sub('^W$', 'WH', dat$race)
## I'm going to guess that B and BK are both "White"
dat$race = sub('^B$', 'BK', dat$race)

table(dat$race, useNA='ifany')
```

```
## 
##    AS    BK    IN    LB    LT    LW    WH 
##   117 13908    13    68  1803  1239  2059
```


## VIEW SOME TABLES


```r
## Summary of how many unique values and missing values exist in the data
NAsummary(dat)
```

```
##                         col Count   nNA    rNA nUnique rUnique
## charges_citation          1 19207   315 0.0164    1435  0.0747
## race                      2 19207     0 0.0000       7  0.0003
## age_at_booking            3 19207     0 0.0000      67  0.0034
## gender                    4 19207     0 0.0000       2  0.0001
## booking_date              5 19207   151 0.0078    4160  0.2165
## jail_id                   6 19207     0 0.0000   19207  1.0000
## bail_status               7 19207 10318 0.5371       5  0.0002
## housing_location          8 19207     5 0.0002    6115  0.3183
## charges                   9 19207  3052 0.1589    1075  0.0559
## bail_amount              10 19207  6415 0.3339     119  0.0061
## discharge_date_earliest  11 19207 10627 0.5532    8581  0.4467
```

```r

## More simple summaries
table(dat$gender, useNA='ifany')
```

```
## 
##     F     M 
##  1742 17465
```

```r

## Chargs and Charges_citation are too big to print:
# table(dat$charges_citation, useNA='ifany')
# table(dat$charges, useNA='ifany')
 
## Just the top 100 charges_citation
sort(table(dat$charges_citation, useNA='ifany'), T)[1:10]
```

```
## 
##  720 ILCS 570 402(c) [5101110] 720 ILCS 5 12-3.2(a)(1) [10416 
##                           1531                            623 
##           720 ILCS 5/9-1(a)(1)    625 ILCS 5 6-303(a) [13526] 
##                            559                            513 
##            720 ILCS 570/402(c)   720 ILCS 5 19-1(a) [1110000] 
##                            470                            390 
##                           <NA> 720 ILCS 5 12-3.2(a)(2) [10418 
##                            315                            306 
##   720 ILCS 5 19-3(a) [1120000]  720 ILCS 5 16A-3(a) [1060000] 
##                            302                            272
```

```r
sort(table(dat$charges, useNA='ifany'), T)[1:10]
```

```
## 
##                                         <NA> 
##                                         3052 
##               POSS AMT CON SUB EXCEPT(A)/(D) 
##                                         1839 
## FIRST DEGREE MURDER:INTENDS DEATH/GREAT HARM 
##                                          619 
##                        RET THEFT/DISP MERCH/ 
##                                          466 
##                 DOMESTIC BATTERY/BODILY HARM 
##                                          463 
##                                     BURGLARY 
##                                          461 
##                         RESIDENTIAL BURGLARY 
##                                          461 
##             ARMED ROBBERY ARMED WITH FIREARM 
##                                          308 
##                                      ROBBERY 
##                                          283 
##                       VIOLATION OF PROBATION 
##                                          265
```

```r

## Are the NA values really NA?
table(is.na(dat$charges))
```

```
## 
## FALSE  TRUE 
## 16155  3052
```

```r
table(is.na(dat$charges_citation))
```

```
## 
## FALSE  TRUE 
## 18892   315
```

```r

## Write Temp File (what did you think it would do?)
# wtf(dat)
```



## SOME INITIAL PLOTS


```r

range(dat$booking_date, na.rm=TRUE)
```

```
## [1] "1993-01-16 CST" "2013-01-20 CST"
```

```r

## Checking to see if the dates imported correctly
plot(dat$discharge_date_earliest , 1:nrow(dat))
```

![plot of chunk unnamed-chunk-5](figure/unnamed-chunk-51.png) 

```r
plot(dat$booking_date , 1:nrow(dat))  ## Usually organzied by booking date?
```

![plot of chunk unnamed-chunk-5](figure/unnamed-chunk-52.png) 

```r

## Not very informative, but it would let me know if the data wasn't right
plot(dat$booking_date, dat$discharge_date_earliest)
```

![plot of chunk unnamed-chunk-5](figure/unnamed-chunk-53.png) 

```r


hist(dat$bail_amount, 100)
```

![plot of chunk unnamed-chunk-5](figure/unnamed-chunk-54.png) 

```r
hist(pmin(dat$bail_amount, 1000000), 100)
```

![plot of chunk unnamed-chunk-5](figure/unnamed-chunk-55.png) 

```r
hist(dat$age_at_booking, 100)
```

![plot of chunk unnamed-chunk-5](figure/unnamed-chunk-56.png) 

```r


plot(dat$age_at_booking, dat$bail_amount, main='age by bail amount')
```

![plot of chunk unnamed-chunk-5](figure/unnamed-chunk-57.png) 

```r
plot(log(bail_amount)~age_at_booking, dat, main='age by log(bail amount)')
```

![plot of chunk unnamed-chunk-5](figure/unnamed-chunk-58.png) 

```r


boxplot(bail_amount~age_at_booking, dat, main='age by bail amount (much better)')
```

![plot of chunk unnamed-chunk-5](figure/unnamed-chunk-59.png) 

```r
boxplot(pmin(bail_amount, 5e5)~age_at_booking, dat,
		main='age by bail amount\n(changing the limits)')
```

![plot of chunk unnamed-chunk-5](figure/unnamed-chunk-510.png) 

```r
boxplot(log(bail_amount)~age_at_booking, dat, main='age by log(bail amount)')
```

![plot of chunk unnamed-chunk-5](figure/unnamed-chunk-511.png) 

```r


library(mgcv)
```

```
## Loading required package: nlme
## This is mgcv 1.7-29. For overview type 'help("mgcv-package")'.
```

```r
bailbyage.gam = gam(bail_amount ~ s(age_at_booking), data=dat)
plot(bailbyage.gam, main='fitted age by bail amount')
```

![plot of chunk unnamed-chunk-5](figure/unnamed-chunk-512.png) 

```r

plot(dat$age_at_booking, dat$bail_amount, 
	 main='fitted age by bail amount\n(another way)')
lines(predict(bailbyage.gam), col='red')
```

![plot of chunk unnamed-chunk-5](figure/unnamed-chunk-513.png) 


## SOME GGPLOTS


```r
ggplot(dat, aes(x=age_at_booking, fill=factor(race))) +
	geom_density(alpha=.5) + 
	facet_grid(race ~ .)+
	xlab("Age at booking") + 
	ylab("Density by race") +
	theme(plot.title = element_text(size = 20)) +
	labs(title='Age at booking summary\nby race\n')
```

![plot of chunk unnamed-chunk-6](figure/unnamed-chunk-61.png) 

```r

ggplot(dat, aes(x=bail_amount, fill=factor(race))) +
	geom_density(alpha=.5) + 
	facet_grid(race ~ .) +
	xlab("Age at booking") + 
	ylab("bail amount by race") +
	theme(plot.title = element_text(size = 20)) +
	labs(title='Bond by race summary\n')
```

```
## Warning: Removed 48 rows containing non-finite values (stat_density).
## Warning: Removed 4503 rows containing non-finite values (stat_density).
## Warning: Removed 3 rows containing non-finite values (stat_density).
## Warning: Removed 24 rows containing non-finite values (stat_density).
## Warning: Removed 678 rows containing non-finite values (stat_density).
## Warning: Removed 415 rows containing non-finite values (stat_density).
## Warning: Removed 744 rows containing non-finite values (stat_density).
```

![plot of chunk unnamed-chunk-6](figure/unnamed-chunk-62.png) 

```r

ggplot(dat, aes(x=age_at_booking, fill=factor(gender))) +
	geom_density(alpha=.7) + 
	facet_grid(gender ~ .)+
	xlab("Age at booking") + 
	ylab("Density by race") +
	theme(plot.title = element_text(size = 20)) +
	labs(title='Age at booking summary\nby gender\n')
```

![plot of chunk unnamed-chunk-6](figure/unnamed-chunk-63.png) 

```r

ggplot(dat, aes(x=age_at_booking, fill=factor(gender))) +
	geom_density(alpha=.7) + 
	facet_grid(race ~ .)+
	xlab("Age at booking") + 
	ylab("Density by race") +
	theme(plot.title = element_text(size = 20)) +
	labs(title='Age at booking summary\nby gender and race\n')
```

![plot of chunk unnamed-chunk-6](figure/unnamed-chunk-64.png) 

```r

ggplot(dat, aes(x=bail_amount, fill=factor(gender))) +
	geom_density() + 
	facet_grid(gender ~ .)+
	xlab("Age at booking") + 
	ylab("bail amount by race") +
	theme(plot.title = element_text(size = 20)) +
	labs(title='Bond by race summary\n')
```

```
## Warning: Removed 581 rows containing non-finite values (stat_density).
## Warning: Removed 5834 rows containing non-finite values (stat_density).
```

![plot of chunk unnamed-chunk-6](figure/unnamed-chunk-65.png) 







