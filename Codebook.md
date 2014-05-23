# H1 Getting and Cleaning Data Course Project Codebook

This file lists the variables used in Glenn Dunmire's run_analysis.R script. 

1. xTrain = the data frame resulting from reading the X_train text file

   xTest = the data frame resulting from reading the X_test text file

   yTrain = the data frame resulting from reading the y_train text file

   yTest = the data frame resulting from reading the y_Test text file

   subjectTrain = the data frame resulting from reading the subjectTrain text file

   subjectTest = the data frame resulting from reading the subjectTest text file


2. dataX = a 10,299 x 561 data frame created from the rbind of xTrain and xTest. This all the X values from the beginning of the script, which is the same as all the observation values

   yLabel = a 10,299 x 1data frame created from the rbind of yTrain and yTest. This is all the y or activity data from the beginning of the script

   subjects = a 10,299 x 1 data frame created from the rbind of subjectTrain and subjectTest. This is all the subject data at the beginning of the script 

3. features = a 561 x 2 data frame containing the names of the features for the X values. 

   meanAndStd = a vector of length 79 created by subsetting the features data frame where the feature in questin (column 2) contains the word "mean()" or "std()". Note the use of the lowercase "m" and "s" and the paratheses. These can be different and will yield different results for meanAndStd

   Update dataX = now subset the dataX vector containing all the X data with only the features we are interested in. That is, take the subset of the original dataX (from 1 above) where the rows are equal to the values in meanAndStd. This new dataX is a 10,299 x 79 data frame containing only features including "mean()" and "std()". Also update the names of the columns in dataX by getting the names from the second column of the meanAndStd data frame, replacing the column headers from V1 to something human readable. 

   Now: clean the names on dataX, removing punctuation and capitalizing "mean()" and "std()" resulting in variable names that are readable and properly formatted

4. activity = a 6x2 data frame containing the code for each activity and its corresponding character (eg 1 = walking). Result of reading the table activity_labels.txt

   Transform activity, making all letters lowercase and then uppercasing where appropriate and removing punctuation. 

   Update yLabel = add a column of NAs to yLabel. Then for example, for every 1 in yLabel[x,1], replace the NA in yLabel[x,2] with the string "walking" (pulled from activity). Do this for all x in 1:nrow(yLabel). Then replace the column names for yLabel with "activity_ID" and "activity"

   Update subjects = replace V1 column name in subjects with "subject"

5. cleanResult = a 10,299 x 82 data frame that is the result of cbinding the subjects, yLabel, and dataX data frames. This combines the columns resulting in one data frame holding all avaialable information with labels in a human readable format. 

   molten = a long-format 823,920 x 4 data frame which is the result of the melt() function on cleanResult, using "subject", "activity_ID", and "activity" as id variables

   finalTidy = a wide-format 180x82 data frame that is the result of the dcast() function on molten, using "subject", "activity_ID", and "activity" as id variables and mean as the aggregating function. 

   Write the finalTidy data frame as a text file called "final_Tidy_Means.txt" in the working directory  


