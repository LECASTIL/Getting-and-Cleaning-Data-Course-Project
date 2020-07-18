setwd("C:/coursera/")

#-------------------------------------------------------------------------------
# 1. Merge  and the test  to create one data set

if(!file.exists("./data")) dir.create("./data")
file <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(file, destfile = "./data/projectData_getCleanData.zip")

listZip <- unzip("./data/projectData_getCleanData.zip", exdir = "./data")

trainx <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
trainy <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
trainsubject <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
testx <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
testy <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
testsubject <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

trainData <- cbind(trainsubject, trainy, trainx)
testData <- cbind(testsubject, testy, testx)
fData <- rbind(trainData, testData)


# 2. Extract the measurements on the mean and standard deviation 

featureName <- read.table("./data/UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)[,2]

featureIndex <- grep(("mean\\(\\)|std\\(\\)"), featureName)
fData <- fullData[, c(1, 2, featureIndex+2)]
colnames(fData) <- c("subject", "activity", featureName[featureIndex])


# 3. Uses descriptive activity names 

activityName <- read.table("./data/UCI HAR Dataset/activity_labels.txt")

fData$activity <- factor(fData$activity, levels = activityName[,1], labels = activityName[,2])


# 4. labels the data set 

names(fData) <- gsub("\\()", "", names(fData))
names(fData) <- gsub("^t", "time", names(fData))
names(fData) <- gsub("^f", "frequence", names(fData))
names(fData) <- gsub("-mean", "Mean", names(fData))
names(fData) <- gsub("-std", "Std", names(fData))

# 5. From the data set in step 4, creates a second, independent tidy data set 

library(dplyr)
gData <- fData %>%
  group_by(subject, activity) %>%
  summarise_each(funs(mean))

write.table(gData, "./Getting_and_Cleaning_data_Project/MeanData.txt", row.names = FALSE)
