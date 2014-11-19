library(plyr)

#step merging the data

x_train<- read.table("UCI HAR Dataset/train/X_train.txt")
y_train<- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <-read.table("UCI HAR Dataset/train/subject_train.txt")

x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

#create x data set

x_data <- rbind(x_train,x_test)

# create y data set

y_data<- rbind(y_train,y_test)

# create subject data set

subject_data <- rbind(subject_train,subject_test)

#step 2 extract only the measurements on the mean and standrad deviation for each meausrement

features <- read.table("UCI HAR Dataset/features.txt")

# get only columns with mean and st dev in their names

mean_std_features <- grep("-(mean|std)\\(\\)",features[,2])

# subset the desired coumns

x_data<- x_data[,mean_std_features]

#correct the column names

names(x_data)<- features [mean_std_features,2]

#use descriptive activity names to name the activites in the data set

activities<- read.table("UCI HAR Dataset/activity_labels.txt")

#update values with correct activity names

y_data[,1] <- activities[y_data[,1],2]

#correct column name

names(y_data)<- "activity"

# label the data set with descriptive variable names

# correct column name

names(subject_data)<- "subject"

#bind all the data in single set

all_data<- cbind(x_data,y_data,subject_data)

# step 5 create a second,independent tidy data set with the average of each variable for each activity and each subject

averages_data <- ddply(all_data, .(subject, activity), function(x) colMeans(x[, 1:66]))

write.table(averages_data,"average.data.txt",row.name=FALSE)

