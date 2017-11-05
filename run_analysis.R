if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")

# Unzip dataSet to /data directory
unzip(zipfile="./data/Dataset.zip",exdir="./data")

#names(subject_train)

# Reading trainings tables:
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

# Reading testing tables:
x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

# Reading feature vector:
features <- read.table('./data/UCI HAR Dataset/features.txt')

# Reading activity labels: head(activityLabels)
activityLabels = read.table('./data/UCI HAR Dataset/activity_labels.txt')


##-- 1.  Merging all dataset into 1 ## nrow(x_test)
mrg_train <- cbind(y_train, subject_train, x_train)
mrg_test <- cbind(y_test, subject_test, x_test)

## Merging all rows into 1 
setAllInOne <- rbind(mrg_train, mrg_test)
##-- 1. Done

##-- 4. Appropriately labels the data set with descriptive variable names
names(setAllInOne) <- c("activityId","subjectId",  as.character(features[,2] ))
##-- 4. Done


##-- 2. Extracting only the measurements on the mean and standard deviation for each measurement
# Reading column names:
colNames <- colnames(setAllInOne)

## Create vector for defining ID, mean and standard deviation:
mean_and_std <- sum(grepl("activityId" , colNames) | 
                     grepl("subjectId" , colNames) | 
                     grepl("mean" , colNames) | 
                     grepl("std" , colNames) 
  )
  
## Making nessesary subset from setAllInOne:
setForMeanAndStd <- setAllInOne[ , mean_and_std == TRUE]
##-- 2. Done

##-- 3. Using descriptive activity names to name the activities in the data set: head(setWithActivityNames)
setWithActivityNames <- merge(setForMeanAndStd, activityLabels,
                                    by='activityId',
                                    all.x=TRUE)
      
##-- 3. Done  

##-- 5. Tidy set
secTidySet <- aggregate(. ~subjectId + activityId, setWithActivityNames, mean)
secTidySet <- secTidySet[order(secTidySet$subjectId, secTidySet$activityId),]
      
##   Writing second tidy data set in txt file
write.table(secTidySet, "secTidySet.txt", row.name=FALSE)