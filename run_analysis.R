#if(!file.exists("./data")){dir.create("./data")}

#Download the source data

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip";
#download.file(fileUrl,"./Dataset.csv")
unzip("getdata-projectfiles-UCI HAR Dataset.zip");

#Read the files into data frames

features = read.table('./UCI HAR Dataset/features.txt',header=FALSE); 
activity = read.table('./UCI HAR Dataset/activity_labels.txt',header=FALSE);
subjectTrain = read.table('./UCI HAR Dataset/train/subject_train.txt',header=FALSE); 
xTrain = read.table('./UCI HAR Dataset/train/x_train.txt',header=FALSE); 
yTrain = read.table('./UCI HAR Dataset/train/y_train.txt',header=FALSE);

#Assignng column names for easy access of data
colnames(activity)  = c('actId','actType');
colnames(subjectTrain)  = "subjectId";
colnames(xTrain)        = features[,2]; 
colnames(yTrain)        = "actId";

# Create the training data by combining yTrain, subjectTrain, and xTrain

trainData <- cbind(yTrain,subjectTrain,xTrain);

# Read in the test data into data frames
subjectTest = read.table('./UCI HAR Dataset/test/subject_test.txt',header=FALSE); 
xTest       = read.table('./UCI HAR Dataset/test/x_test.txt',header=FALSE);
yTest       = read.table('./UCI HAR Dataset/test/y_test.txt',header=FALSE);

# Assign column names to the test data imported above
colnames(subjectTest) = "subjectId";
colnames(xTest)       = features[,2]; 
colnames(yTest)       = "actId";

# Create the test data by combining the xTest, yTest and subjectTest data
testData = cbind(yTest,subjectTest,xTest);

#Merging both the dataset
finalData = rbind(trainData,testData);

# Create a vector for the column names from the finalData, which will be used
# to select the desired mean() & stddev() columns
colNames  = colnames(finalData);

#Create a logical vector with TRUE value for the required columns
reqdColumns = grepl("mean()",colNames) | grepl("std()",colNames) | grepl("subject",colNames) | grepl("act",colNames);

#Create the required dataset with selected columns only
finalData = finalData[reqdColumns == TRUE];

#Merge the final dataset with activity dataset to get meaningful names
finalData = merge(finalData,activity,by.x = 'actId', by.y = 'actId',all.x = TRUE)

# Updating the colNames vector to include the new column names after merge
NewcolNames  = colnames(finalData); 

#Cleanup the names of the columns in the dataset
for (i in 1:length(NewcolNames)) {
  NewcolNames[i] = gsub("^t","time",NewcolNames[i])
  NewcolNames[i] = gsub("^f","frequency",NewcolNames[i])
  NewcolNames[i] = gsub("\\()","",NewcolNames[i])
  NewcolNames[i] = gsub("-mean","Mean",NewcolNames[i])
  NewcolNames[i] = gsub("-std","StdDev",NewcolNames[i])
  NewcolNames[i] = gsub("BodyBody","Body",NewcolNames[i])
};

#Assigning the new column naes to the final data set
colnames(finalData) = NewcolNames;

finalData1  = finalData[,names(finalData) != 'actType'];

#Calculating  the mean of each variable for each activity and each subject
submitData    = aggregate(finalData1[,names(finalData1) != c('actId','subjectId')],by=list(actId=finalData1$actId,subjectId = finalData1$subjectId),mean);

# Merging the tidyData with activity Type to include descriptive acitvity names
submitData    = merge(submitData,activity,by='actId',all.x=TRUE);

# Export the tidyData set 
write.table(submitData, './submitFinalData.txt',row.names=FALSE,sep='\t');
