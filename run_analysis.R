#reading test data
testX <- read.table(file = "./all/UCI HAR Dataset/test/X_test.txt")
testY <- read.table(file = "./all/UCI HAR Dataset/test/Y_test.txt")
testsubject <- read.table(file = "./all/UCI HAR Dataset/test/subject_test.txt")

#reading train data
trainX <- read.table(file = "./all/UCI HAR Dataset/train/X_train.txt")
trainY <- read.table(file = "./all/UCI HAR Dataset/train/Y_train.txt")
trainsubject <- read.table(file = "./all/UCI HAR Dataset/train/subject_train.txt")

#reading activity lables and features data
activity <- read.table(file = "./all/UCI HAR Dataset/activity_labels.txt")
features <- read.table(file = "./all/UCI HAR Dataset/features.txt")[,2]

#substituting activity number with activity name for test data
testYlabels <- sapply(testY[,1],function(x) {as.character(activity[activity$V1==x,2])})
testdata <- cbind(testsubject,testYlabels,testX)
colnames(testdata)<-c("subject","activity",as.character(features))

#substituting activity number with activity name for train data
trainYlabels <- sapply(trainY[,1],function(x) {as.character(activity[activity$V1==x,2])})
traindata <- cbind(trainsubject,trainYlabels,trainX)
colnames(traindata)<-c("subject","activity",as.character(features))

#merging test and train data
alldata <- rbind(testdata,traindata)

#finding columns for mean and std
newdata <- alldata[,c(1,2,grep("mean\\(|std\\(",colnames(alldata)))]

#creating tidy dataset with mean of variables for each subjec and activity
tidydata <- aggregate(.~subject+activity, newdata, FUN = mean)
tidydata <- tidydata[order(tidydata$subject,tidydata$activity),]
         
#writing the tidy data set             
write.table(tidydata,"tidydata.txt", row.names = FALSE)

