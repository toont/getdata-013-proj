library(dplyr)
library(tidyr)

#Check if data set is already downloaded or not. If it's downloaded then unzip it
if(!file.exists("./UCI HAR Dataset.zip")) {
        stop("Please download Sumsung dataset into your working directory! Do not unzip it!")
} else {
        unzip("./UCI HAR Dataset.zip")
        
        #Load of test data
        test_df_sub <- read.table("./UCI HAR Dataset/test/subject_test.txt", col.names = "Subject")
        test_df_act <- read.table("./UCI HAR Dataset/test/y_test.txt", col.names = "Activity")
        features <- read.table("./UCI HAR Dataset/features.txt")
        features_vect <- features$V2
        test_df_set <- read.table("./UCI HAR Dataset/test/X_test.txt")
        colnames(test_df_set) <- features_vect
        rm("features")
        
        #Load of training data
        train_df_sub <- read.table("./UCI HAR Dataset/train/subject_train.txt", col.names = "Subject")
        train_df_act <- read.table("./UCI HAR Dataset/train/y_train.txt", col.names = "Activity")
        train_df_set <- read.table("./UCI HAR Dataset/train/X_train.txt")
        colnames(train_df_set) <- features_vect
        rm("features_vect")
        
        #Merge Subject, Activity and Set data frames
        test_df <- bind_cols(test_df_sub, test_df_act, test_df_set)
        train_df <- bind_cols(train_df_sub, train_df_act, train_df_set)
        rm("test_df_sub", "test_df_act", "test_df_set", "train_df_sub", "train_df_act", "train_df_set")
                
        #Merge training and test data frames
        train_test_df <- bind_rows(train_df, test_df)
        rm("train_df", "test_df")
        
        #Extract mean and standard deviation for each measurement
        mean_std <- select(train_test_df, Subject, Activity, contains("mean"), contains("Mean"), contains("std"))
        rm("train_test_df")
        
        #Add descriptive activity names
        act_df <- read.table("./UCI HAR Dataset/activity_labels.txt")
        act_vect <- as.vector(act_df$V2)
        
        for(i in 1:6) {
                mean_std$Activity <- gsub(i, act_vect[i], mean_std$Activity)
        }
        rm("act_df", "act_vect", "i")
        
        #Independent data set grouped by Subject and Activity
        mean_std_gr <- group_by(mean_std, Subject, Activity)
        
        #Data set with the average of each variable for each activity and each subject
        mean_std_gr_sum <- summarise_each(mean_std_gr, funs(mean))
        rm("mean_std_gr", "mean_std")        
        
}
