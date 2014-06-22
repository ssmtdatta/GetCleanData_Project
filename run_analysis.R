###==============================================================================
# Script: run_analysis.R
# Code tested on Mac OS 10.6.8
# Appropriate packages and libraries may need to be installed/configured
#-----------------------------------
# The code assumes that the data are downloaded and unzipped. The parent folder is 
# "UCI HAR Dataset" by default, and run_analysis.R should be in this directory.
# Then the code can access the sub directories test, train etc.
#----------------------------------
#Outputs: tidyData and tidyAverage.
#         tidyData combines mean/std features from tets and training sets.
#         tidyAverage summarizes the average values of mean and std feature for each
#         subject for a given activity.
###==============================================================================


#CODE BEGINS

#======================================
#Total number of volunteers (subjects) taken part in the experiment
numSubject = 30 

#======================================
#Step 1 
#Read in the feature names and identify which features are medians and standard deviations.
features561 <- read.table("features.txt")
featureName <- as.character(features561[, 2])
tidyCols <- grep("(mean|std)", featureName)

#--------------------------------------
#clear variables not needed in rest of the code and save a little memory
remove(features561)
#--------------------------------------


#======================================
#Step 2
#Trim and combine the test data
testSubjects <- read.table("test/subject_test.txt")
testActivityLabels <- read.table("test/y_test.txt")
testFeaturesAll <- read.table("test/X_test.txt")
testFeaturesTidy <- cbind(testFeaturesAll[tidyCols])
cases <- rep("test", nrow(testFeaturesTidy))
testData <- cbind(cases, testSubjects, testFeaturesTidy, testActivityLabels)
#----------------------------------
#Trim and combine the training data
trainSubjects <- read.table("train/subject_train.txt")
trainActivityLabels <- read.table("train/y_train.txt")
trainFeaturesAll <- read.table("train/X_train.txt")
trainFeaturesTidy <- cbind(trainFeaturesAll[tidyCols])
cases <- rep("train", nrow(trainFeaturesTidy))
trainData <- cbind(cases, trainSubjects, trainFeaturesTidy, trainActivityLabels)
#----------------------------------
#combine training and test datasets
outputData <- rbind(trainData, testData)
#----------------------------------
#sanity check
#print(nrow(trainSubjects))
#dim(testFeaturesTidy)
#dim(outputData)

#----------------------------------
#clear variables not needed in rest of the code and save a little memory
remove(testSubjects, testActivityLabels, testFeaturesAll, testFeaturesTidy, testData)
remove(trainSubjects, trainActivityLabels, trainFeaturesAll, trainFeaturesTidy, trainData)
#----------------------------------


#======================================
#Step 3
#Tidy up the combined test and training data.
#Activity name
activity <- outputData[, ncol(outputData)] ;
activity[activity ==1] <- "walk"
activity[activity ==2] <- "walk up"
activity[activity ==3] <- "walk dwn"
activity[activity ==4] <- "sit"
activity[activity ==5] <- "stand"
activity[activity ==6] <- "lay"
#---------------------------------------
tidyData <- cbind(outputData, activity)
names(tidyData) <- c("Case", "SubjectID", featureName[tidyCols], "ActivityLabel", "ActivityName")


#======================================
#Step 4
#Creates a dataset with the average of each variable for each activity and each subject.
#--------------------------------------
#Subset tidyData according to the six activities.
activity_1 <- subset(tidyData, tidyData$ActivityLabel==1)
activity_2 <- subset(tidyData, tidyData$ActivityLabel==2)
activity_3 <- subset(tidyData, tidyData$ActivityLabel==3)
activity_4 <- subset(tidyData, tidyData$ActivityLabel==4)
activity_5 <- subset(tidyData, tidyData$ActivityLabel==5)
activity_6 <- subset(tidyData, tidyData$ActivityLabel==6)
#--------------------------------------
#Feature variables of tidyData are in columns 3 to 81
v = 3    #first col of features
vv = 81  #last col of features
#--------------------------------------
act1 <- unlist(by(activity_1[, v:vv], activity_1$SubjectID, colMeans), use.names = FALSE)
act1 <- as.data.frame(cbind(1:numSubject,t(matrix(act1, length(v:vv), numSubject)), rep(1,numSubject), rep("walk", numSubject)))
#--------------------------------------
act2 <- unlist(by(activity_2[, v:vv], activity_2$SubjectID, colMeans), use.names = FALSE)
act2 <- as.data.frame(cbind(1:numSubject,t(matrix(act2, length(v:vv), numSubject)), rep(1,numSubject), rep("walk", numSubject)))
#--------------------------------------
act3 <- unlist(by(activity_3[, v:vv], activity_3$SubjectID, colMeans), use.names = FALSE)
act3 <- as.data.frame(cbind(1:numSubject,t(matrix(act3, length(v:vv), numSubject)), rep(1,numSubject), rep("walk", numSubject)))
#--------------------------------------
act4 <- unlist(by(activity_4[, v:vv], activity_4$SubjectID, colMeans), use.names = FALSE)
act4 <- as.data.frame(cbind(1:numSubject,t(matrix(act4, length(v:vv), numSubject)), rep(1,numSubject), rep("walk", numSubject)))
#--------------------------------------
act5 <- unlist(by(activity_5[, v:vv], activity_5$SubjectID, colMeans), use.names = FALSE)
act5 <- as.data.frame(cbind(1:numSubject,t(matrix(act5, length(v:vv), numSubject)), rep(1,numSubject), rep("walk", numSubject)))
#--------------------------------------
act6 <- unlist(by(activity_6[, v:vv], activity_6$SubjectID, colMeans), use.names = FALSE)
act6 <- as.data.frame(cbind(1:numSubject,t(matrix(act6, length(v:vv), numSubject)), rep(1,numSubject), rep("walk", numSubject)))

#--------------------------------
#clear variables not needed in rest of the code and save a little memory
remove(activity_1, activity_2, activity_3, activity_4, activity_5, activity_6) 
#--------------------------------


#Stack all six activity groups (combine row-wise)
tidyAverage <- rbind(act1, act2, act3, act4, act5, act6)
names(tidyAverage) <- c("SubjectID", featureName[tidyCols], "ActivityLabel", "ActivityName")

#--------------------------------
#clear variables not needed in rest of the code and save a little memory
remove(act1, act2, act3, act4, act5, act6) 
#--------------------------------


#==================================
#Optional: Uncomment to save data
#
# if (!file.exists("OUTPUT")) {
#    dir.create("OUTPUT")
# }
# write.csv(tidyData, file = "OUTPUT/tidyData.txt", row.names=FALSE)
# write.csv(tidyAverage, file = "OUTPUT/tidyAverage.txt", row.names=FALSE)
#==================================


#CODE ENDS