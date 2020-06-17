# Loading the required packages
library(dplyr)

# Downloading the file
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./data/Dataset.zip", method="curl")

# Unzipping the file
unzip(zipfile = "./data/Dataset.zip",exdir = "./data")

# Getting the list of files
path_rf <- file.path("./data", "UCI HAR Dataset")
files <- list.files(path_rf, recursive=TRUE)
files

# Reading data from the files into variables
data.activity.test  <- read.table(file.path(path_rf, "test" , "Y_test.txt" ),header = FALSE)
data.activity.train <- read.table(file.path(path_rf, "train", "Y_train.txt"),header = FALSE)

data.subject.test  <- read.table(file.path(path_rf, "test" , "subject_test.txt"),header = FALSE)
data.subject.train <- read.table(file.path(path_rf, "train", "subject_train.txt"),header = FALSE)

data.features.test  <- read.table(file.path(path_rf, "test" , "X_test.txt" ),header = FALSE)
data.features.train <- read.table(file.path(path_rf, "train", "X_train.txt"),header = FALSE)

# Binding test and training dataframes for activity, subject and features by row
data.activity <- rbind(data.activity.train, data.activity.test)
data.subject <- rbind(data.subject.train, data.subject.test)
data.features <- rbind(data.features.train, data.features.test)

# Renaming the columns for the activity, subject and features dataframes
names(data.activity) <- 'activity'
names(data.subject) <- 'subject'
features.names <- read.table(file.path(path_rf, "features.txt"),header = FALSE)
names(data.features) <- features.names$V2

# Binding by columns to get dataframe with all features and observations
data.combine <- cbind(data.subject, data.activity)
data <- cbind(data.features, data.combine)

# Selecting by features that are either the mean or the standard deviation
subset.features.names <- features.names$V2[grep("mean\\(\\)|std\\(\\)", features.names$V2)]
selected.names <- c(as.character(subset.features.names), "subject", "activity" )
data <- select(data, all_of(selected.names))

# Reading activity labels from activity_labels.txt
activity.labels <- read.table(file.path(path_rf, "activity_labels.txt"),header = FALSE)

# Using a for loop to replace data$activity values with descriptive activity names
for (i in 1:nrow(data)) {
    activity.index <- as.integer(data$activity[i])
    activity.type <- as.character(activity.labels[activity.labels$V1[activity.index], 'V2'])
    data$activity[i] <- activity.type
}
head(data$activity, 30)

# Relabelling the column names with descriptive variable names
names(data) <- gsub("^t", "time", names(data))
names(data) <- gsub("^f", "frequency", names(data))
names(data) <- gsub("Acc", "Accelerometer", names(data))
names(data) <- gsub("Gyro", "Gyroscope", names(data))
names(data) <- gsub("Mag", "Magnitude", names(data))
names(data) <- gsub("BodyBody", "Body", names(data))

# Creating a second, independent tidy data set with the average of each variable for each activity and each subject 
data2 <- data
data2 <- group_by(data, subject, activity)
data2 <- summarize_all(data2, mean)
data2 <- arrange(data2, activity, subject)
data2
write.table(data2, file = "tidydata.txt",row.name=FALSE)
