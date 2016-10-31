setwd("~/Documents/coursera/data-cleaning/peer/")

library(dplyr)

# Create dir, download files and unzip
if(!file.exists("./data")){dir.create("./data")}
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if(!file.exists("data/data.zip")) { download.file(url, "data/data.zip", method = "curl") 
  unzip("data/data.zip", exdir = "data/") 
  }


# 1. Merges the training and the test sets to create one data set.
XTrain <- read.table("data/UCI HAR Dataset/train/X_train.txt")
XTest  <- read.table("data/UCI HAR Dataset/test/X_test.txt")
data <- rbind(XTrain, XTest)
names <- read.table("data/UCI HAR Dataset/features.txt")[, 2]
names(data) <- names

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
data <- data[, grep("(mean\\(\\)|std\\(\\))", names(data))]

# 3. Uses descriptive activity names to name the activities in the data set
activities <-read.table("data/UCI HAR Dataset/activity_labels.txt")
YTrain <- read.table("data/UCI HAR Dataset/train/y_train.txt")
YTest  <- read.table("data/UCI HAR Dataset/test/y_test.txt")
Y <- rbind(YTrain, YTest)
Y <- right_join(activities,Y)

# 4. Uses descriptive activity names to name the activities in the data set
names(data) <- gsub("^t", "Time", names(data))
names(data) <- gsub("Acc", "Acceleration", names(data))
names(data) <- gsub("^f", "Frequency", names(data))
names(data) <- gsub("mean\\(\\)", "Mean", names(data))
names(data) <- gsub("std\\(\\)", "StandardDeviation", names(data))
names(data) <- gsub("-", "", names(data))


#5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
subjectTrain <- read.table("data/UCI HAR Dataset/train/subject_train.txt")
subjectTest  <- read.table("data/UCI HAR Dataset/test/subject_test.txt")
subject <- rbind(subjectTrain, subjectTest)

tidy <- cbind(Subject = subject$V1, Activity = Y$V2, data)
tidyMeans <- tidy %>% group_by(Subject,Activity) %>% summarise_each(funs(mean))
