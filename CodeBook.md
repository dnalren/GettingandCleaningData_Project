---
title: "codeBook"
---
####run_analysis.R is intended to download the data set at the link below and modify the data to return a tidy data set
####https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

####Data
The data provided in the text file 'Tidy_Average.txt' represent data collected from a samsung smart phone by the accelerometer and gyroscope and that data has been transformed twice.  Information on the first transformations can be found in the Readme.txt file in the original data directory.  

The scope of this project covers the second transformation.  This involved taking the data from the first transformation and extracting only the variables on mean and standard deviation for each measurement.  There were 33 variables, so the data set provided includes values for 33 mean variables and 33 standard deviation variables, a total of 66 measurement variables, although you will find 68 total variables in the data set, the additional two variables represent the subject and activity each measurements correspond to. 

The next step involved taking the average of all the measurements associated with each variable for each subject and each activity.  Given the six activities and 30 subjects, the resulting 'Tidy_Average.txt' dataset has 180 observations for each of the 66 variables.  Each of the observations represents an overage of the mean or standard deviation measurements of the original dataset for a given subject and activity.   

####Variables
1.  The variables originate from the study in which the data was gathered.  Details on the original variables can be found in the featuresinfo.txt file in teh original data.
2.  The variables found in the tidy data set provided are as follows:

    + subject -  factor identifying the subject (1-30)
    + activity - factor identifying activity (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING ) 
    + The following variables represent the average of all the mean observations for their respective acceleration or gyroscope reading
        + MeanBodyAccelerationxaxisTime
        + MeanBodyAccelerationyaxisTime                          
        + MeanBodyAccelerationzaxisTime
        + MeanGravityAccelerationxaxisTime
        + MeanGravityAccelerationyaxisTime                       
        + MeanGravityAccelerationzaxisTime        
        + MeanBodyAccelerationjerkxaxisTime
        + MeanBodyAccelerationjerkyaxisTime                      
        + MeanBodyAccelerationjerkzaxisTime       
        + MeanBodygyroxaxisTime
        + MeanBodygyroyaxisTime                                  
        + MeanBodygyrozaxisTime                  
        + MeanBodygyrojerkxaxisTime
        + MeanBodygyrojerkyaxisTime                              
        + MeanBodygyrojerkzaxisTime             
        + MeanBodyAccelerationMagnitudeTime
        + MeanGravityAccelerationMagnitudeTime
        + MeanBodyAccelerationjerkMagnitudeTime
        + MeanBodygyroMagnitudeTime
        + MeanBodygyrojerkMagnitudeTime
        + MeanBodyAccelerationxaxisFrequency
        + MeanBodyAccelerationyaxisFrequency                     
        + MeanBodyAccelerationzaxisFrequency
        + MeanBodyAccelerationjerkxaxisFrequency
        + MeanBodyAccelerationjerkyaxisFrequency                 
        + MeanBodyAccelerationjerkzaxisFrequency
        + MeanBodygyroxaxisFrequency
        + MeanBodygyroyaxisFrequency                             
        + MeanBodygyrozaxisFrequency
        + MeanBodyAccelerationMagnitudeFrequency
        + MeanBodyAccelerationjerkMagnitudeFrequency
        + MeanBodygyroMagnitudeFrequency
        + MeanBodygyrojerkMagnitudeFrequency
    + The following variables represent the average of all the standard deviation observations for their respective acceleration or gyroscope reading
        + StandarddeviationBodyAccelerationxaxisTime             
        + StandarddeviationBodyAccelerationyaxisTime
        + StandarddeviationBodyAccelerationzaxisTime
        + StandarddeviationGravityAccelerationxaxisTime          
        + StandarddeviationGravityAccelerationyaxisTime
        + StandarddeviationGravityAccelerationzaxisTime 
        + StandarddeviationBodyAccelerationjerkxaxisTime         
        + StandarddeviationBodyAccelerationjerkyaxisTime
        + StandarddeviationBodyAccelerationjerkzaxisTime
        + StandarddeviationBodygyroxaxisTime                     
        + StandarddeviationBodygyroyaxisTime
        + StandarddeviationBodygyrozaxisTime 
        + StandarddeviationBodygyrojerkxaxisTime                 
        + StandarddeviationBodygyrojerkyaxisTime
        + StandarddeviationBodygyrojerkzaxisTime 
        + StandarddeviationBodyAccelerationMagnitudeTime         
        + StandarddeviationGravityAccelerationMagnitudeTime
        + StandarddeviationBodyAccelerationjerkMagnitudeTime
        + StandarddeviationBodygyroMagnitudeTime                 
        + StandarddeviationBodygyrojerkMagnitudeTime
        + StandarddeviationBodyAccelerationxaxisFrequency        
        + StandarddeviationBodyAccelerationyaxisFrequency
        + StandarddeviationBodyAccelerationzaxisFrequency
        + StandarddeviationBodyAccelerationjerkxaxisFrequency    
        + StandarddeviationBodyAccelerationjerkyaxisFrequency
        + StandarddeviationBodyAccelerationjerkzaxisFrequency   
        + StandarddeviationBodygyroxaxisFrequency                
        + StandarddeviationBodygyroyaxisFrequency
        + StandarddeviationBodygyrozaxisFrequency
        + StandarddeviationBodyAccelerationMagnitudeFrequency    
        + StandarddeviationBodyAccelerationjerkMagnitudeFrequency
        + StandarddeviationBodygyroMagnitudeFrequency            
        + StandarddeviationBodygyrojerkMagnitudeFrequency

####Transformations Applied
1.  Load the libraries

2.  Load the data into R
    + Load the subject, X and Y .txt files for both the test and train directories 
    + Load features.txt file and the activity_labels.txt file
    + All of the data from the .txt files are added to a single list to be formatted.

3.  Merge the testing and training sets
    + Create the temporary test and train data frames from the subject, Y and txt files for the respective test and train data sets.
        + Test has 2947 observations of 563 variables (561 variables plus subject and activity)
        + Train has 7352 observations of 563 variables (561 variables plus subject and activity)
    + Combine Test and Train into a single data frame 
        + The result is 10299 observations of 563 variables
    + Create a new data frame that takes subject, activity and the mean and standard deviation variables
        + The result is a data frame with variables for subject, activity and 66 mean/standard deviation variables
        + The data frame has 10299 observations of 68 variables
    + Convert the activity numbers into their respective activity factors as defined in the activity_labels.txt
    + Order the data based on the subject and activity

4.  Clean the variable names of the original data and align them with tidy data principles.  
    + Although all lower case is ideal, upper case letters were used to separate major words of the title to improve readability.
    + Remove parentheses
    + Replace x, y and z with xaxis, yaxis, zaxis
    + Replace t with time and f with frequencyand move to end of name
    + Swap acceleration with mean|std 
    + Remove repeated "body" 
    + Lengthen acc, mag and std to full words

5.  Create a subset of the data that is an average of each activity performed by each subject for each variable in  the original dataset
    + Split the data by subject
    + Split the data further by activity
    + Calculate the average for each variable measured in each activity for each subject
    + The resulting data set has 180 observations of 66 variables.  Including the subject and activity variables there is a total 68 variables in the data set.
        + The 180 observations come from 6 average values for each of 30 subjects



