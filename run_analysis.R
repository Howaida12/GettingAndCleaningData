# loading packages and download data
library(data.table)
library(reshape2)
path <- getwd()
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, file.path(path, "DataFiles.zip"))
unzip(zipfile = "DataFiles.zip")

# loading activity labels and features
activity_labels <- fread(file.path(path, "UCI HAR Dataset/activity_labels.txt"), col.names = c("ClassLabels", "ActivityName"))
features <- fread(file.path(path, "UCI HAR Dataset/features.txt"), col.names = c("index","FeatureNames"))
wanted_features <- grep("(mean|std)\\(\\)", features[, FeatureNames])
measurements <- features[wanted_features, FeatureNames]
measurements <- gsub("[()]", "", measurements)

# Loading Train data

train <- fread(file.path(path, "UCI HAR Dataset/train/X_train.txt"))[, wanted_features, with = FALSE]
data.table::setnames(train, colnames(train), measurements)
train_activities <- fread(file.path(path, "UCI HAR Dataset/train/y_train.txt"), col.names = c("Activity"))
subject_num_train <- fread(file.path(path, "UCI HAR Dataset/train/subject_train.txt"), col.names = c("SubjectNum"))

train <- cbind(subject_num_train, train_activities, train)

# Loading Test data
test <- fread(file.path(path, "UCI HAR Dataset/test/X_test.txt"))[, wanted_features, with = FALSE]
data.table::setnames(test, colnames(test), measurements)
test_activities <- fread(file.path(path, "UCI HAR Dataset/test/y_test.txt"), col.names = c("Activity"))
subject_num_test <- fread(file.path(path, "UCI HAR Dataset/test/subject_test.txt"), col.names = c("SubjectNum"))

test <- cbind(subject_num_test, test_activities, test)

# Combining Train and Test data
combined <- rbind(train, test)

# Turning ClassLabels into ActivityNames
combined[["Activity"]] <- factor(combined[, Activity], levels = activity_labels[["ClassLabels"]], labels = activity_labels[["ActivityName"]])

combined[["SubjectNum"]] <- as.factor(combined[, SubjectNum])
combined <- reshape2::melt(data = combined, id.vars = c("SubjectNum", "Activity"))
combined <- reshape2::dcast(data = combined, SubjectNum + Activity ~ variable, fun.aggregate = mean)

data.table::fwrite(x = combined, file = "TidyData.txt", quote = FALSE)