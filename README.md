# getdata-013-proj
## Getting and Cleaning Data Course Project

### This README explains each block of the script run_analysis.R
*****
Load of libraries which will be used in this script:
```{r}
library(dplyr)
library(tidyr)
```

Check if data set is already downloaded or not. If it's downloaded then unzip it:
```{r}
if(!file.exists("./UCI HAR Dataset.zip")) {
        stop("Please download Sumsung dataset into your working directory! Do not unzip it!")
} else {
        unzip("./UCI HAR Dataset.zip")
```
        
Load of test data in the separate data frames.  
So far we have:  
* `test_df_sub` - Test subjects. Variable name changed to discreptive name `Subject`  
* `test_df_act` - Activities. Variable name changed to discreptive name `Activity`  
* `test_df_set` - Test data set  
Script also lables test data set with descriptive variable names taken from `features.txt`.  
Script removes not needed variables at the end of each section.  

```{r}
        test_df_sub <- read.table("./UCI HAR Dataset/test/subject_test.txt", col.names = "Subject")
        test_df_act <- read.table("./UCI HAR Dataset/test/y_test.txt", col.names = "Activity")
        features <- read.table("./UCI HAR Dataset/features.txt")
        features_vect <- features$V2
        test_df_set <- read.table("./UCI HAR Dataset/test/X_test.txt")
        colnames(test_df_set) <- features_vect
        rm("features")
```

Load of training data in the separate data frames.  
So far we have:  
* `train_df_sub` - Training subjects. Variable name changed to discreptive name `Subject`  
* `train_df_act` - Activities. Variable name changed to discreptive name `Activity`  
* `train_df_set` - Training data set  
Script also lables trainign data set with descriptive variable names taken from `features.txt`.  

```{r}
        train_df_sub <- read.table("./UCI HAR Dataset/train/subject_train.txt", col.names = "Subject")
        train_df_act <- read.table("./UCI HAR Dataset/train/y_train.txt", col.names = "Activity")
        train_df_set <- read.table("./UCI HAR Dataset/train/X_train.txt")
        colnames(train_df_set) <- features_vect
        rm("features_vect")
```
        
In next section script merges `test_df_sub`, `test_df_act` and `test_df_set` data frames in one test data set `test_df`.  
As well as `train_df_sub`, `train_df_act` and `train_df_set` data frames in one train data set `train_df`.  
Not needed data frames are removed.  
```{r}
        test_df <- bind_cols(test_df_sub, test_df_act, test_df_set)
        train_df <- bind_cols(train_df_sub, train_df_act, train_df_set)
        rm("test_df_sub", "test_df_act", "test_df_set", "train_df_sub", "train_df_act", "train_df_set")
```
                
In the section below script merges training and test data frames:  
```{r}
        train_test_df <- bind_rows(train_df, test_df)
        rm("train_df", "test_df")
```
        
In this section script extract mean and standard deviation variables for each measurement:  
```{r}
        mean_std <- select(train_test_df, Subject, Activity, contains("mean"), contains("Mean"), contains("std"))
        rm("train_test_df")
```
        
The next step is to add descriptive activity names. Activity names are taken from `activity_labels.txt` which comes with the original data set.  
```{r}
        act_df <- read.table("./UCI HAR Dataset/activity_labels.txt")
        act_vect <- as.vector(act_df$V2)
        
        for(i in 1:6) {
                mean_std$Activity <- gsub(i, act_vect[i], mean_std$Activity)
        }
        rm("act_df", "act_vect", "i")
```
        
In the next section script creates independent data set grouped by Subject and Activity:  
```{r}
        mean_std_gr <- group_by(mean_std, Subject, Activity)
```
        
In the last section script creates final data set with the average of each variable for each activity and each subject:  
```{r}
        mean_std_gr_sum <- summarise_each(mean_std_gr, funs(mean))
        rm("mean_std_gr", "mean_std")        
        
}
```