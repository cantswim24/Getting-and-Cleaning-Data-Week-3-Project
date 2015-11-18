#1
filesPath <- "/Users/pmitchell/Documents/R_Project/dataCLEANING/UCI HAR Dataset"
# Read subject files
subjectTrain <- tbl_df(read.table(file.path(filesPath, "train", "subject_train.txt")))
subjectTest  <- tbl_df(read.table(file.path(filesPath, "test" , "subject_test.txt" )))
# subjects are the id' of indiviuals


# Read activity files
activityTrain <- tbl_df(read.table(file.path(filesPath, "train", "y_train.txt")))
activityTest  <- tbl_df(read.table(file.path(filesPath, "test" , "y_test.txt" )))

#activityTest contains all the activity types like walking etc =1

#Read data files.
dataTrain <- tbl_df(read.table(file.path(filesPath, "train", "X_train.txt" )))
dataTest  <- tbl_df(read.table(file.path(filesPath, "test" , "X_test.txt" )))

allSubjectData <- rbind(subjectTrain, subjectTest)
setNames(allSubjectData, "subject")
allActivityData<- rbind(activityTrain, activityTest)
setNames(allActivityData, "Activity")

#combine the DATA training and test files
allData <- rbind(dataTrain, dataTest)

# name variables according to feature e.g.(V1 = "tBodyAcc-mean()-X")
Features <- tbl_df(read.table(file.path(filesPath, "features.txt")))
setNames(Features, c("featureNum", "featureName"))



colnames(allData) <- Features$V2

#column names for activity labels
activityLabels<- tbl_df(read.table(file.path(filesPath, "activity_labels.txt")))
setNames(activityLabels, names(activityLabels))

# Merge columns
alldataSubjAct<- cbind(allSubjectData, allActivityData)
allData <- cbind(alldataSubjAct, allData)

colnames(allData)[1]<-"subject" 
colnames(allData)[2]<-"activityNum" 



#2

Features_MeanStd <- grep("mean\\(\\)|std\\(\\)",Features$V2,value=TRUE) #var name

# Taking only measurements for the mean and standard deviation and add "subject","activityNum"


Features_MeanStd <- union(c("subject","activityNum"), Features_MeanStd)
#allData<- subset(allData,select=Features_MeanStd) 

allData<- subset(allData,select=Features_MeanStd,)

#3.

colnames(activityLabels)[1]<-"activityNum" 
colnames(activityLabels)[2]<-"activity" 

allData <- merge(activityLabels, allData , by="activityNum", all.x=TRUE)
allData$activityName <- as.character(allData$activity)

#4.

names(allData)<-gsub("std()", "SD", names(allData))
names(allData)<-gsub("mean()", "MEAN", names(allData))
names(allData)<-gsub("^t", "time", names(allData))
names(allData)<-gsub("^f", "frequency", names(allData))
names(allData)<-gsub("Acc", "Accelerometer", names(allData))
names(allData)<-gsub("Gyro", "Gyroscope", names(allData))
names(allData)<-gsub("Mag", "Magnitude", names(allData))
names(allData)<-gsub("BodyBody", "Body", names(allData))
names(allData)<-gsub("ÒGravity", "Body", names(allData))

#5
finalData_NoActivityType =  allData[,names(allData) != 'activity']
  
tidyData = aggregate(finalData_NoActivityType[,names(finalData_NoActivityType) != c('activityNum','subject')],by=list(activity=finalData_NoActivityType$activityNum,subject = finalData_NoActivityType$subject),mean)
write.table(tidyData, "TidyData.txt", row.name=FALSE)
