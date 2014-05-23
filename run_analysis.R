# This is the course project for Coursera's Getting and Cleaning Data class, completed by 
# Glenn Dunmire. The goal of this script is to take the data provided by 
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
# from http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones. This project
# from UCI has two samples, a test data and a train data. Each of these folders has a file of 
# observations, a file of activities, and the subject for each. We will combine these files to create
# one table and create human readable labels for the variables. 

# Part 1: Merge training and test data. Note I am taking a "lego approach" by keeping the 
# activities, subject, and data files separate (that is, rbinding data from test and train but no
# combining activites and subject) to make the data easier to use for later. 
# NB: the script assumes you have created a directory "Getting and Cleaning Data Peer Assessment"
# to store all the files and have not modified any file names or paths. 




##may need to change to navigate to correct directory
##setwd("./Getting-and-Cleaning-Data-Course-Project")
##use of the reshape2 package is necessary for Part 5 below



## Step 1:
##read the X (data) values for train and test samples, then combine to dataX 
xTrain <- read.table("./Original_Data/train/X_train.txt")
xTest <- read.table("./Original_Data/test/X_test.txt")
dataX <- rbind(xTrain, xTest)

##read the y (label) values for train and test samples, then combine to yLabel
yTrain <- read.table("./Original_Data/train/y_train.txt")
yTest <- read.table("./Original_Data/test/y_test.txt")
yLabel <- rbind(yTrain, yTest)

##read the subject train and test data then combine to subjects
subjectTrain <- read.table("./Original_Data/train/subject_train.txt")
subjectTest <- read.table("./Original_Data/test/subject_test.txt")
subjects <- rbind(subjectTrain, subjectTest)

##can check dimensions of dataX, yLabel, and subjects to verify
print("dimension for dataX should be 10299 by 561")
print(dim(dataX))


print("dimension for yLabel should be 10299 by 1")
print(dim(yLabel))

print("dimensions for subjects should be 10299 by 1")
print(dim(subjects))



## Step 2:Extract the measurements on mean and standard deviation from
## the features.txt file. Then use this to subset the dataX frame
## from above to provide a data frame with only mean and std. Then format
## the names to remove punctuation and capitalize appropriate names
features <- read.table("./Original_Data/features.txt")

##Note the use of mean() and std(), using both lowercase letter and ()
##number of columns is 79, this will vary depending on regular expression used in grep
meanAndStd <- grep("mean()|std()", features[,2]) 

##subset dataX based on mean and std
dataX <- dataX[,meanAndStd]

##change names to be human readable
names(dataX) <- features[meanAndStd, 2]

##reformat names to remove punctuation (particularly () and -) and capitalize mean and std
names(dataX) <- gsub("[[:punct:]]", "", names(dataX))
names(dataX) <- gsub("mean", "Mean", names(dataX))
names(dataX) <- gsub("std", "Std", names(dataX))



# Step 3: Use descrptive names from activity_labels.txt to replace the numeric values
# in yLabel (thus making it human readable). For example a 1 in yLabel is replaced with "walking".
  
activity <- read.table("./Original_Data/activity_labels.txt")

##reformate the names from activity_labels.txt
##lowercase letters
activity[,2] <- tolower(activity[,2])

##re-uppercase where appropriate
substr(activity[2,2], 8, 8) <- toupper(substr(activity[2,2], 8, 8))
substr(activity[3,2], 8, 8) <- toupper(substr(activity[3,2], 8, 8))

#remove "-"
activity[,2] <- gsub("_", "", activity[,2])

##add a column of NAs to yLabel
yLabel[,2] <- character() 

##use a for loop to go through each value in the column V2 in yLabel, access the numeric value stored
##in V1, and based on cascading if statements match the correct string from activity_labels.txt. This
##can also be done using the join() function from the plyr package but I wrote this to avoid requiring
##a package. 
for (i in 1:nrow(yLabel)) {
  if(yLabel[i,1] == 1) {
    yLabel[i,2] <- activity[1,2]
  }
  else if (yLabel[i,1] == 2) {
    yLabel[i,2] <- activity[2,2]
  }
  else if (yLabel[i,1] == 3) {
    yLabel[i,2] <- activity[3,2]
  }
  else if (yLabel[i,1] == 4) {
    yLabel[i,2] <- activity[4,2]
  }
  else if (yLabel[i,1] == 5) {
    yLabel[i,2] <- activity[5,2]
  }
  else {
    yLabel[i,2] <- activity[6,2]
  }
}


##replace V1 with "activity_ID" and "activity"
names(yLabel) <- c("activity_ID", "activity")



## Step 4: replace column name with "subject" in subjects data, more human readable
names(subjects) <- "subject"

##column bind subjects, yLabel, and dataX to produce a dataset. 
##Should be 10299 x 81 (depending on regex in grep in Step2 above) with human
##readable and properly formatted column names
cleanResult <- cbind(subjects, yLabel, dataX)

## Step 5: Create an independent data set that is "tidy" with the average of 
## each variable for each activity and subject. This requires the plyr package

##check if plyr is already installed
if(require("reshape2")){
  library(reshape2)
  print("reshape2 has been loaded correctly")
  
} else { ##if it is not install and load 
  print("trying to install reshape2")
  install.packages("reshape2")
  library("reshape2")
  if(require(reshape2)){
    print("reshape2 installed and loaded")
  } else {
    stop("could not install reshape2")
  }
}

#use melt to produce a long-format dataset organized with subject, activity_ID, and activity as id variables
molten <- melt(cleanResult, id = c("subject","activity_ID", "activity"))

##cast the long-format dataset to a wide-format dataset using subject, activity_ID, and activity
##as id variables and using the mean function to aggregate the data
finalTidy <- dcast(molten, subject + activity_ID + activity ~ variable, fun.aggregate = mean)

##write the final wide dataset to the working directory as a text file
print("writing final output to working directory")
write.table(finalTidy, "final_Tidy_Means.txt")