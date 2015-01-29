

##------------------------------------------------------------------------------
## INITIALIZATION
##------------------------------------------------------------------------------
rm(list=ls())
gc()
library(geneorama)
detach_nonstandard_packages()
library(geneorama)
loadinstall_libraries(c("geneorama", "data.table", "ggplot2", "caret", 
						"reshape2", "corrplot", "rpart", "party", "e1071",
						"AppliedPredictiveModeling", "partykit", "MASS"))
sourceDir("functions/")

##------------------------------------------------------------------------------
## LOAD DATA
##------------------------------------------------------------------------------

## LOAD RDS FILES
dat <- readRDS("data/VacantBuildingData.Rds")
setnames(dat, "Vacant_Address", "Vacant")

# dat[ ,Vacant := ifelse(Vacant, 1, 0)]
dat[ ,Vacant := as.factor(Vacant)]
str(dat)

xmat <- dat[i = TRUE , 
			j = -which(colnames(dat) %in% c("Property_Address", "Vacant")), 
			with = FALSE]
ymat <- dat[i = TRUE , 
			j = list(Vacant = as.numeric(Vacant))]
xmat <- as.matrix(xmat)
row.names(xmat) <- dat[ , Property_Address]

ymat <- as.matrix(ymat)
row.names(ymat) <- dat[ , Property_Address]

str(xmat)
str(ymat)

##------------------------------------------------------------------------------
## CORRELATION PLOT
##------------------------------------------------------------------------------
library(corrplot)

corrplot(corr = cor(xmat), 
		 col = colorRampPalette(c("#7F0000", "red", "#FF7F00", "yellow", "#7FFF7F", 
		 						 "cyan", "#007FFF", "blue", "#00007F"))(100))

findCorrelation(cor(xmat), cutoff=.75, verbose=F)
findCorrelation(cor(xmat), cutoff=.95, verbose=F)

xmat_filtered <- xmat[ , -findCorrelation(cor(xmat), cutoff=.95, verbose=F)]
str(xmat)
str(xmat_filtered)

##------------------------------------------------------------------------------
## SPLIT INTO TEST TRAIN
##------------------------------------------------------------------------------
set.seed(10)
Partitions <- createDataPartition(ymat, times=15, p=.25)
str(Partitions)


## xmat + y
rpartData <- as.data.table(cbind(xmat[Partitions[[1]], ],
								 y = as.factor(ymat[Partitions[[1]], ])))
## xmat_filtered + y
rpartData <- as.data.table(cbind(xmat_filtered[Partitions[[1]], ],
								 y = as.factor(ymat[Partitions[[1]], ])))
table(rpartData$y)

rpartData
rpartModel <- rpart(y~., rpartData)
rpartModel
plotcp(rpartModel)
summary(rpartModel)


rpartModelHuge = rpart(
	y ~ ., 
	control = rpart.control(cp = 0.001, minsplit=2, xval=10),
	data = rpartData)
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

table(rpm$y)
table(rpartData$y)
table(round(predict(rpm)))
table(predict(rpm))
table(rpm$where)

sort(table(predict(rpm)))
confusionMatrix(reference=rpm$y, 
				data=ifelse(predict(rpm)>1.1, 2, 1))
confusionMatrix(reference=rpm$y, 
				data=ifelse(predict(rpm)>1.1, 2, 1))
confusionMatrix(reference=rpm$y, 
				data=ifelse(predict(rpm)>1.05, 2, 1))












