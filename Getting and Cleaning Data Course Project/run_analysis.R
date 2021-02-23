#Here are the data for the project:
#https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip  

#You should create one R script called run_analysis.R that does the following. 

#Merges the training and the test sets to create one data set.
#Extracts only the measurements on the mean and standard deviation for each measurement. 
#Uses descriptive activity names to name the activities in the data set
#Appropriately labels the data set with descriptive variable names. 
#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# setup environment
library(dplyr)
library(tidyr)

fileDataZipUrl <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip  '
fileDataZipDest <- './data/getdata_projectfiles_UCI HAR Dataset.zip'
data_dir <- "./data/UCI HAR Dataset"

## download data if not already present
if(!file.exists(fileDataZipDest)) {
  url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(url = url, destfile = "Dataset.zip", method = "curl")
}

## extract the dataset if it is not already extracted
if(!dir.exists(data_dir)) {
  unzip(fileDataZipDest, exdir = './data')
}

# Step 1: Merges the training and the test sets to create one data set.
## Grab column names
features <- read.table(file.path(data_dir, "features.txt"), stringsAsFactors = FALSE)

## Read train data
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt", col.names = features$V2)
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt", col.names = "activity_number")

##Read test data
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt", col.names = features$V2)
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt", col.names = "activity_number")

## Merge into one dataset
training <- cbind(subject_train, y_train, x_train)
test <- cbind(subject_test, y_test, x_test)
dataset <- rbind(training, test)

# Extracts only the measurements on the mean and standard deviation for each measurement. 
## We use select combined with contains, in contains we postfix with a . to ensure we only get "mean" and not "meanFreq"
dataset <- dataset %>% select(subject, activity_number, contains("mean."), contains("std."))

#Uses descriptive activity names to name the activities in the data set
activity_labels <- read.table(file.path(data_dir, "activity_labels.txt"), 
                              stringsAsFactors = FALSE, 
                              col.names = c('activity_number', 'activity_label'))
dataset <- merge(activity_labels, dataset)

#Appropriately labels the data set with descriptive variable names. 
## Already done during import

#From the data set in step 4, creates a second, independent tidy data set
#with the average of each variable for each activity and each subject.
result <- dataset %>% 
  select(-activity_label) %>% 
  group_by(activity_number, subject) %>% 
  summarize_all(mean)

write.table(result, "tidy_data.txt")
