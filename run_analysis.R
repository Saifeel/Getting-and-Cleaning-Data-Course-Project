library(dplyr)
library(data.table)
library(reshape2)

setwd("~/Desktop/datasciencecoursera/HARdata")

##MAIN VARIABLES

  ##test
xtest <- read.table("~/Desktop/datasciencecoursera/HARdata/test/X_test.txt")
testAct <- read.table("~/Desktop/datasciencecoursera/HARdata/test/y_test.txt")
testSub <- read.table("~/Desktop/datasciencecoursera/HARdata/test/subject_test.txt")

  ##train
xtrain <- read.table("~/Desktop/datasciencecoursera/HARdata/train/X_train.txt")
trainAct <- read.table("~/Desktop/datasciencecoursera/HARdata/train/y_train.txt")
trainSub <- read.table("~/Desktop/datasciencecoursera/HARdata/train/subject_train.txt")

##VARIABLES2
features <- read.table("~/Desktop/datasciencecoursera/HARdata/features.txt")
features$V2 <- as.character(features$V2)
labels <- read.table("~/Desktop/datasciencecoursera/HARdata/activity_labels.txt")
labels$V2 <- as.character(labels$V2)


##step 2 - extracting only mean and std 

Mfeatures <- grep(".*mean.*|.*std.*", features$V2)
Mfeaturesnames <- features[Mfeatures, 2]
Mfeaturesnames <- gsub('-mean', 'mean', Mfeaturesnames)
Mfeaturesnames <- gsub('-std', 'std', Mfeaturesnames)
Mfeaturesnames <- gsub('[-()]', '', Mfeaturesnames)

##test
xtest <- xtest[featuresWanted]
test <- cbind(testSub, testAct, xtest)

##train
xtrain <- xtrain[featuresWanted]
train <- cbind(trainSub, trainAct, xtrain)

##step 1 
##Main Data Set 
Main <- rbind(train, test)


##step 3 & 4
colnames(Main) <- c("subject", "activity", Mfeaturesnames)
Main$activity <- factor(Main$activity, levels = labels[,1], labels = labels[,2])
Main$subject <- as.factor(Main$subject)

##step 5
##set sub and act as ids 
Main <- melt(Main, id = c("subject", "activity"))
##mean of each variable w/ respect to ids 
Main <- dcast(Main, subject + activity ~ variable, mean)

##create tidy.txt file with tidy data 
write.table(Main, "tidy.txt", row.names = FALSE)
