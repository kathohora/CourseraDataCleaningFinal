###load in data tables
pathdata<- file.path("~/Documents/Data Cleaning", "UCI HAR Dataset")
files<- list.files(pathdata, recursive=T)
xtrain<- read.table(file.path(pathdata, "train", "X_train.txt"), header = FALSE)
ytrain<- read.table(file.path(pathdata, "train", "Y_train.txt"), header = FALSE)
subtrain<- read.table(file.path(pathdata, "train", "subject_train.txt"), header = FALSE)
features<- read.table(file.path(pathdata, 'features.txt'), header = FALSE)
activity<- read.table(file.path(pathdata, "activity_labels.txt"), header = FALSE)
#read in test data
xtest<- read.table(file.path(pathdata, "test", "X_test.txt"), header = FALSE)
ytest<- read.table(file.path(pathdata, "test", "Y_test.txt"), header = FALSE)
subtest<- read.table(file.path(pathdata, "test", "subject_test.txt"), header = FALSE)
#set column names for test data
colnames(xtest)<- features[,2]
colnames(ytest) <- 'activityId'
colnames(subtest) <- 'subjectId'
#set column names for training data
colnames(xtrain)<- features[,2]
colnames(ytrain) <- 'activityId'
colnames(subtrain) <- 'subjectId'
colnames(activity) <- c('activityId', 'activityType')
#merge training datasets
mergetrain<- cbind(xtrain, subtrain, ytrain)
#merge test dataset
mergetest<- cbind(xtest, subtest, ytest)
#####make combined test and trainging dataset 
mergeall<- bind_rows(mergetrain, mergetest)
###
###
###find mean/standard deviation columns 
colnames<- colnames(mergeall)
mean_sd <- (grepl("activityId" , colnames) | grepl("subjectId" , colnames) | 
                     grepl("mean.." , colnames) | grepl("std.." , colnames))
setmean_sd <- mergeall[,mean_sd==T]
#merge activity ids and names with new dataset 
activityNames <- merge(setmean_sd, activity, by='activityId', all.x=T)
#create dataset with variable names 
tidy<- aggregate(. ~subjectId + activityId, activityNames, mean)
tidy <- tidy[order(tidy$subjectId, tidy$activityId),]
#write table of tidy dataset
write.table(tidy, "TidySet.txt", row.name=FALSE)