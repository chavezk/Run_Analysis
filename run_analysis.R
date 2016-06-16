#Download File
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")

# Unzip dataset to data directory
unzip(zipfile="./data/Dataset.zip",exdir="./data")

# Read training tables
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

# Read testing tables
x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

# Read features
features <- read.table("./data/UCI HAR Dataset/features.txt")

# Reading activity labels
activityLabels = read.table("./data/UCI HAR Dataset/activity_labels.txt")

#Asign column names
colnames(x_train) <- features[,2] 
colnames(y_train) <-"activityId"
colnames(subject_train) <- "subjectId"

colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"

colnames(activityLabels) <- c("activityId","activityType")

#Merge data
merge_train <- cbind(y_train, subject_train, x_train)
merge_test <- cbind(y_test, subject_test, x_test)
combine_train_test <- rbind(merge_train, merge_test)

#Read column names
colNames <- colnames(combine_train_test)

#Vector to identify activity, subject, mean, and std
mean_and_std <- (grepl("activityId" , colNames) | grepl("subjectId" , colNames) | 
                   grepl("mean.." , colNames) | grepl("std.." , colNames) )

#Creating subset
combine_mean_std <- combine_train_test[ , mean_and_std == TRUE]

#Setting descriptive activity names
set_activy_names <- merge(combine_mean_std, activityLabels, by='activityId', all.x=TRUE)

#Create tidy data set
tidy_set <- aggregate(. ~subjectId + activityId, set_activy_names, mean)
tidy_set <- tidy_set[order(tidy_set$subjectId, tidy_set$activityId),]

#Create tidy data set text file
write.table(tidy_set, "tidy_data_set.txt", row.name=FALSE)
