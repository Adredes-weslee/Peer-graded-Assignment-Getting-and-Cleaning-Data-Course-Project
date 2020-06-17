Getting and Cleaning Data
Course Project

You should create one R script called run_analysis.R that does the following.

    Merges the training and the test sets to create one data set.
    Extracts only the measurements on the mean and standard deviation for each measurement.
    Uses descriptive activity names to name the activities in the data set
    Appropriately labels the data set with descriptive activity names.
    Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Steps to work on this course project

    Run source("run_analysis.R"), then it will generate a new file tiny_data.txt in your working directory.

How run_analysis.R implements the above steps:
    
    Loads the dplyr package
    Downloads the file to 'data' directory and unzips it
    Load both test and train data for activity, subject and features
    Binds the test and train data together by rows for activity, subject and features
    Renames the columns for activity, subject and features
    Binds activity, subject and features tables by columns to get complete data set
    Extracts the mean and standard deviation columns
    Uses a for loop to rename the activities column with descriptive activity names
    Relabels the column names with descriptive column names
    Creates a second, independent tidy data set with the average of each variable for each activity and each subject
