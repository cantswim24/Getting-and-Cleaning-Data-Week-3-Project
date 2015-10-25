in_dataset_dir<-'UCI HAR Dataset/train/X_train.txt’
X_test_dataset_dir<-'UCI HAR Dataset/test/X_test.txt’
filesPath<-'UCI HAR Dataset'

X_train_dataset <- read.table(file.path(filesPath, "train", "X_train.txt"))
X_test_dataset <- read.table(file.path(filesPath, "test", "X_test.txt"))


#MERGE TRAIN AND TEST DATA INTO SINGLE DATA SET
X_data <- rbind(X_train_dataset, X_test_dataset)

#GET THE FEATURES, I.E. LIST OF ATTRIBUTES FOR EACH ROW IN TH ETABLE

Features <- read.table(file.path(filesPath, "features.txt”))
#set the feature num and name in the table
setnames(Features, names(Features), c("featureNum", "featureName”))
#use the feature list as the column headings in the data table

colnames(X_data) <- Features$featureName

#$$$$$$$$$$$$$$$$$$$
NOW GET THE SUBJECT FOR TRAIN AND TEST I.E. THE ID OF THE PEOPLE DOING THE STUDY
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt”)
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")


#AND MERGE ALL THE SUBJECTS IDs so we have a list of all the subjects or users in the study
subject_data <- rbind(subject_train, subject_test)
setnames(subject_data,"V1", "subject")

#NOW GET THE ACTIVITY LABELS I.E. WHAT THE SUBJECT WAS DOING set the column names to activity number and name
setnames(activities, names(activities), c("activityNum","activityName"))
#Column BIND ALL THE SUBJECT ID’S AND ACTIVITIES INTO ONE DATA SET , show which user did what activity
ACTIVITY_train <- read.table("./UCI HAR Dataset/train/y_train.txt”)

ACTIVITY_test <- read.table("./UCI HAR Dataset/test/y_test.txt”)

ALL_ACTIVITY  <- rbind(ACTIVITY_train, ACTIVITY_test )
setnames(ALL_ACTIVITY, "V1", "activityNum")

colnames(X_data) <- Features$featureName

activityLabels<- read.table(file.path(filesPath, "activity_labels.txt"))
setnames(activityLabels, names(activityLabels), c("activityNum","activityName"))

subject_and_activities <- cbind(subject_data, ALL_ACTIVITY )
#NOW combine the SUBJECT OR USERS AND THEIR ACTIVITY AND THE DATA ASSOCIATED WITH EACH USER
ALL_DATA <- cbind(subject_and_activities, X_data)
#2
#EXTRACT THE COLUMN NAMES WITH MEAN OR STD IN THE TITLE LISTS A SINGLE COLUMN OF FEATURES WITH MEAN OR STD IN THE NAMES
mean_and_stand_dev_features <- grep("mean\\(\\)|std\\(\\)",dataFeatures$featureName,value=TRUE)
mean_and_stand_dev_features <- union(c("subject","activityNum"), mean_and_stand_dev_features)
ALL_DATA<- subset(ALL_DATA,select=mean_and_stand_dev_features)

#SELECTS A SUBSET OF THE whole data based on the contents of mean_and_stand_dev_features2
ALL_DATA<- subset(ALL_DATA,select= mean_and_stand_dev_features) 


#3

#CHANGES THE ACTIVITYNAME COLUMN TO A MORE SPECIFIC NAME SUCH AS 'WALKING'
ALL_DATA <- merge(activityLabels, ALL_DATA , by="activityNum", all.x=TRUE)


4
#SUBSTITUTE 
names(dataTable)<-gsub("std()", "SD", names(dataTable))
names(dataTable)<-gsub("mean()", "MEAN", names(dataTable))
names(dataTable)<-gsub("^t", "time", names(dataTable))
names(dataTable)<-gsub("^f", "frequency", names(dataTable))
names(dataTable)<-gsub("Acc", "Accelerometer", names(dataTable))
names(dataTable)<-gsub("Gyro", "Gyroscope", names(dataTable))
names(dataTable)<-gsub("Mag", "Magnitude", names(dataTable))
names(dataTable)<-gsub("BodyBody", "Body", names(dataTable))
names(dataTable)<-gsub(“Gravity", "Body", names(dataTable))
#5
finalData_NoActivityType =  dataTable[,names(dataTable) != 'activityName’]
tidyData = aggregate(finalData_NoActivityType[,names(finalData_NoActivityType) != c('activityNum','subject')],by=list(activityId=finalData_NoActivityType$activityNum,subject = finalDataNoActivityType$subject),mean)
