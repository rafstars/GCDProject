setwd("C:/Users/User/Desktop/UCI HAR Dataset")
library(plyr)
library(data.table)

subTreino = read.table('./train/subject_train.txt',header=FALSE)
xTreino = read.table('./train/x_train.txt',header=FALSE)
yTreino = read.table('./train/y_train.txt',header=FALSE)

subTeste = read.table('./test/subject_test.txt',header=FALSE)
xTeste = read.table('./test/x_test.txt',header=FALSE)
yTeste = read.table('./test/y_test.txt',header=FALSE)


xDataSet <- rbind(xTreino, xTeste)
yDataSet <- rbind(yTreino, yTeste)
subDataSet <- rbind(subTreino, subTeste)


xDataSet_mean_std <- xDataSet[, grep("-(mean|std)\\(\\)", read.table("features.txt")[, 2])]
names(xDataSet_mean_std) <- read.table("features.txt")[grep("-(mean|std)\\(\\)", read.table("features.txt")[, 2]), 2]


yDataSet[, 1] <- read.table("activity_labels.txt")[yDataSet[, 1], 2]
names(yDataSet) <- "Activity"


names(subDataSet) <- "Subject"


singleDataSet <- cbind(xDataSet_mean_std, yDataSet, subDataSet)


names(singleDataSet) <- make.names(names(singleDataSet))
names(singleDataSet) <- gsub('Acc',"Acceleration",names(singleDataSet))
names(singleDataSet) <- gsub('GyroJerk',"AngularAcceleration",names(singleDataSet))
names(singleDataSet) <- gsub('Gyro',"AngularSpeed",names(singleDataSet))
names(singleDataSet) <- gsub('Mag',"Magnitude",names(singleDataSet))
names(singleDataSet) <- gsub('^t',"TimeDomain.",names(singleDataSet))
names(singleDataSet) <- gsub('^f',"FrequencyDomain.",names(singleDataSet))
names(singleDataSet) <- gsub('\\.mean',".Mean",names(singleDataSet))
names(singleDataSet) <- gsub('\\.std',".StandardDeviation",names(singleDataSet))
names(singleDataSet) <- gsub('Freq\\.',"Frequency.",names(singleDataSet))
names(singleDataSet) <- gsub('Freq$',"Frequency",names(singleDataSet))


Data2<-aggregate(. ~Subject + Activity, singleDataSet, mean)
Data2<-Data2[order(Data2$Subject,Data2$Activity),]
write.table(Data2, file = "tidydata.txt",row.name=FALSE)
