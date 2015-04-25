###ReadMe

This readme file describes the data available and how to effectively load the data into R.

####Contents
1.  OriginalData - Directory containing raw data and supporting documentation for this porject
2.  run_analysis.R - R script used to clean and export teh original data into the Tidy_Average.txt file
3.  CodeBook.md - CodeBook for this project describing the data, variables, and transformations applied to the original data
4.  Tidy_Average.txt - The tidy dataset

####How To Load Tidy_Average.txt into R
1.  To load the data in the R console ensure that the working directory is set to the folder containing the data set
2.  execute  data = read.table("Tidy_Average.txt", header = TRUE)

####How To Use the run_analysis.R code in R
1.  Set the working directory to the directory containing the run_analysis.R file
2.  Execute source("run_analysis.R") in the R console
3.  Execute data = run_analysis() in the R console 
    + This step will download the zip file to the working directory and open the files so it takes some time