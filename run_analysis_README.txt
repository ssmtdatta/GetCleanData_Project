This explains the run_analysis.R script and the dataset provided for the analysis.

ABOUT THE DATASET
The dataset was obtained from
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
30 volunteers (subjects) took part in the experiments. Each subject performed six activities: 1. WALKING
   2. WALKING_UPSTAIRS
   3. WALKING_DOWNSTAIRS
   4. SITTING
   5. STANDING
   6. LAYING
Subjects wore a Samsung Galaxy S II smartphone on the waist. Using its embedded accelerometer and gyroscope, signals were collected from subjects doing different activities. Signals were filtered using various filter windows. 128 reading were obtained from each window. 561 features were obtained for a subject involed in ceetain activities from the raw readings.

The data were devided into two groups: training (70% of the data; 7352 examples), and test (30% of the data; 2946 examples).


ABOUT THE SCRIPT: run_analysis.R
This script reads the test and training data files, extracts and combines desired features and data information and combine them. 
There are two final outputs:

The script executes the following steps.
#Step 0. Download script and place in a particular directory. Unless the user provides a directory name, the script by default creates a directory called ProjectDirectory under the current working directory and downloads data in ProjectDirectory.
****unzipping and user promt***

#Step 1. There are 561 features associated with each test and training case (see the dataset description above). We are interested in only the features that measures mean and standard deviation values. They are suppossedly thet features with 'mean' and 'std' in their names in the "feature.txt" file. Look for those and find out their column ID's (for example, 1st, 21st or 222nd columns?).
          The "feature.txt" file is read using the read.table() command and they are read as characters. Later the grep() command is used to determine with entries macth the strings 'mean' or 'std'. These entries are stored in a vector called 'tidyCols'.

#Step 2. Gather the desired information for the test and the training datasets. The steps for test and the training files are the same. For both test and the trainig sets, consider three files: 1) subject_*.txt, which contains the IDs of 30 volunteers with integers ranging from 1 to 30, 2) y_*.txt, which labels the six activities with numbers 1 through 6, and 3) X_*.txt, which contains the 561 features associeted with each individual at each each activity. These files are read as tables using read.table().
          From X_*.txt, extract the columns with corresponding to mean/std features according to 'tidyCols' obtained in the previous step.
          Additionally, we define two vectors called 'cases' for the test and the training data. 'cases' has the same length as the number of test/train cases or examples, and each entry is a string of characters 'test' or 'train'. 'cases' for the training set, for example, has 7352 entries - all 'train'. This would be useful to keep track of which features are from training and which are from test when the test and training datasets are combined.
          Next, the test and training sets are combined column-wise using the R command cbind(). The columns are cases, subject ID, activity lables, and mean and std features.  
          Finally, combine the test and the training data row-wise using rbind().

Note: The final dataset in this step - outputData - has 10,299 rows (2,947 test cases and 7,352 training cases) and 82 columns (case, subject, 79 mean/std features and activity). The data/vector dimentions can be checked with rnow(), ncol() and/or dim() commands. They are useful for analysis and data trimming, but excluded or commented out in the current script to save a little memory.

#Step 3. Tidy up the combined data by inserting/changing variable/feature names in outputData. A column with the activity names is added to outputData. 
         Tidy data stored as tidyData, where Column 1:'Case' denotes test/train cases. Column 2: Subject ID ranging from 1 to 30 representing 30 volunteers or experiment subjects. Column 3 - column 81: features (naming convention according to feature.txt), Column 82: activity labels ranging from 1 to 6, and Column 83: names of individual activities.

#Step4. Create a dataset with the average of each variable for each activity and each subject. 
         Break the tidy dataset from the previous step - tidyData - into six activity groups by means of the 'subset' operation. Six datasets are abtained: activity_1, activity_2 etc. They have the same columns as tidyData.
         Work with individual activity_* datasets. Use the 'by' function to compute column mean of the features, that is columns 3 to 81, according to subjects. The output of the 'by' funtion is a list. 
         Do a bit of work to get a data frame. Unlist to convert list to vector. Form a matrix from the vector with each row representing one subject and the mean features. Append subject ID, activity labels and names. Convert the matrix to data frame and add column names. Call the data frames act1, act2 ... ... act6.
         Combine the act* row-wise to get tidyAverage, the final dataset with avarage values for each subject and activity. Here, Coloumn 1: Subject ID, Columns 2 to 80: mean values of the subject for a given activity, Column 81: Activity label, Column 82: Activiy type.
         There are 180 rows total, each block of 30 for one activity.

         


           