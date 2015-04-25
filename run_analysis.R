##run_analysis.R is intended to download the data set at the 
##link below and modify the data to return a tidy data set
##https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

###Load the required libraries
library(plyr)
library(dplyr)

#run_analysis is called to execute the code that downloads, cleans and subsets the data
run_analysis <- function(){
  #download the data 
  data = dlData()
  #merge the test and train data sets
  data = join_sets(data)
  #Clean the column headers
  colnames(data) = clean_names(colnames(data))
  #create a subset of the data set that is a 
  data = subset(data)
  #write the data to a table
  write.table(data, "TIdy_Average.txt", row.names = FALSE)
  data
}

###Load the subject, X and Y .txt files for both the test and train 
###directories as well as the features.txt file and the activity_labels.txt file
###all of these txt files are added to a single list.  The list is later formatted 
###into a data frame.
dlData <- function(){
  download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "data.zip", method = "curl")
  
  main_dir = "UCI HAR Dataset/"
  sec_dir = c("test", "train") 
  files = c("subject_", "X_", "y_")

  data = list()

  for (i in sec_dir){
    for (j in files){
      data = c(data,list(read.table(unz("data.zip",paste0(main_dir,i,"/",j,i,".txt",sep = "")))))
    }
  }

  data = c(data,list(read.table(unz("data.zip",paste0(main_dir,"features.txt")))))
  data = c(data,list(read.table(unz("data.zip",paste0(main_dir,"activity_labels.txt")))))
}

###Merge the testing and training sets
join_sets <- function(allData_list){
  ####Create the temporary test and train data frames from the subject (one variable named subject), Y(one variable named activity) and X(561 variables) txt files for the respective test and train data sets.  Test has 2947 observations of 563 variables and Train has 7352 observations of 563 variables. 
  test = data.frame(allData_list[[1]], allData_list[[3]], allData_list[[2]])  
  train = data.frame(allData_list[[4]], allData_list[[6]], allData_list[[5]])  
  ####Combine Test and Train into a single data frame with 10299 observations of 563 variables
  combined = rbind(test,train)
  
  temp = c("subject", "activity", tolower(as.character(allData_list[[7]][[2]])))
  ####Create a new data frame "combined" that takes subject, activity and the mean and standard deviation variables.  combined has 10299 observations of 68 variables.
  combined = select(combined,grep("subject|activity|mean\\(\\)|std\\(\\)",temp))
  colnames(combined) = grep("subject|activity|mean\\(\\)|std\\(\\)",temp, value = TRUE)
  ####Convert the activity numbers into their respective activity factors as defined in the activity_labels.txt
  combined = mutate(combined, activity = cut(activity, breaks = c(0:6), labels = as.character(allData_list[[8]][[2]]), na.rm = TRUE ))
  ####Order the data based on the subject and activity
  combined = arrange(combined, subject,activity)
  
}

###Clean the variable names of the original data and align them with tidy data principles.  Although all lower case is ideal, upper case used to separate major words of the title to improve readability.
clean_names <- function(names){
  ####Remove parentheses
  names = gsub("\\(\\)", "",names)
  #### Replace x, y and z with xaxis, yaxis, zaxis
  names = sub("(\\-x$|\\-y$|\\-z$)","\\1axis" ,names)
  #### Replace t with time and f with frequencyand move to end of name
  names = sub("(^t)([a-z]+\\-[a-z]+-[a-z]+)", "\\2Time" ,names)
  names = sub("(^t)([a-z]+\\-[a-z]+)","\\2Time",names)
  names = sub("(^f)([a-z]+\\-[a-z]+-[a-z]+)","\\2Frequency" ,names)
  names = sub("(^f)([a-z]+\\-[a-z]+)","\\2Frequency" ,names)
  #### Swap acceleration with mean|std 
  names = sub("([a-z]+)\\-(mean|std)", "\\2\\1", names)
  #### Remove repeated "body" 
  names = sub("(body)\\1", "\\1",names)
  #### Lengthen acc, mag and std to full words
  names = sub("acc", "Acceleration", names)
  names = sub("mag", "Magnitude", names)
  names = sub("std", "Standarddeviation", names)
  names = sub("mean", "Mean", names)
  names = sub("body", "Body", names)
  names = sub("gravity", "Gravity", names)
  names = sub("-", "", names)
  
}

#Create a subset of the data that is an average of each activity performed by each subject for each variable in  the original dataset
subset <- function(data){
  ####Split the data by subject
  sp_sub = lapply(split(data,data$subject),subset_helper) 
  #### Split the data further by activity
  #### Calculate the average for each variable measured in each activity for each subject
  new_data = mutate(sp_sub[[1]], subject = rep.int(factor(1),6))
  
  for (i in c(2:30)){
    new_data = rbind(new_data,mutate(sp_sub[[i]], subject = rep.int(factor(i),6)))
  }
  ####The resulting data set has 180 observations (6 average values for each of 30 subjects), of 66 variables.  Including the subject and activity variables there is a total 68 variables in the data set.
  new_data = data.frame(c(select(new_data,subject),select(new_data, activity:StandarddeviationBodygyrojerkMagnitudeFrequency)))

}

#split each subject by activity and apply column means activity
#this is called by the subset function in the lapply
subset_helper <- function(sub){
    a = ddply(sub,"activity",function(x){colMeans(x[,3:68])} )
}
