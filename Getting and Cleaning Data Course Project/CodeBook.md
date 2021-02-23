# The original request was to execute the following actions:
##Merges the training and the test sets to create one data set.
##Extracts only the measurements on the mean and standard deviation for each measurement. 
##Uses descriptive activity names to name the activities in the data set
##Appropriately labels the data set with descriptive variable names. 
##From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


#Actions taken:
## Step 0
We setup the environment with  dplyr and tidyr to assist in cleaning the data.
The we download the zip file (if needed) and extract it (if needed)

##Merges the training and the test sets to create one data set.
We read each all subject, x and y files from both train and test data.
We also read features.txt because it contains the column names for the x_ files.

##Extracts only the measurements on the mean and standard deviation for each measurement. 
We select the relevant column names, discarding the rest

##Uses descriptive activity names to name the activities in the data set
We grab the activity_labels.txt files and merge it with our dataset.
This results in a dataset that includes the descriptive names

##Appropriately labels the data set with descriptive variable names. 
This step was done during the import of each file.

##From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
We group the dataset on activity and subject, then summarize with mean on each group, then write the result.
