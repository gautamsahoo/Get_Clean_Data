# Get_Clean_Data

### Data source

This dataset is derived from the "Human Activity Recognition Using Smartphones Data Set" which was originally made avaiable here. http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

###Description

Additional information about the variables, data and transformations used in the course project for the Johns Hopkins Getting and Cleaning Data course.


* Merge the training and the test sets to create one data set
	read the source files data into data frames 

* Get only mean and standard deviation related columns into a dataset
	create a data set with only mean and std deveiation columns using a logical vector

* Use descriptive activity names in the data set
	Merge data subset with the activityType table to cinlude the descriptive activity names

* Appropriately label the data set with descriptive activity names.


* Create a second, independent tidy data set with the average of each variable for each activity and each subject.
	Create a data set without header using write.table function

####Units and Features: No unit of measures is reported as all features were normalized and bounded within [-1,1].



