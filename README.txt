This is the code implemented for BIOMI 600  Advanced Bio Data Analysis at San Diego State University 

The goal of this project was to develop a model to predict weather a leukemia patient would respond to hydroxyurea or not. This drug does have some bad side effects but for patient who respond it is extremly effective in battling leukemia therefore I choose to focus on a model that favored a higher sensitivity vs specificity.


KLExpand - KLExpand function used for feature selection and dimentionality reduction (PCA)
ANN - Code for ANN, different numbers of layers and nodes (see comments)
KNN_1set_LOO - KNN with the first set of variables (8 vars) using the leave one out method
KNN_second_set - KNN with second set of variables (5 vars) using leave one out method
testingtrainingdata.m - method used to divide data to testing and training data for the non leave one out code
KNN_no_LOO - same as above but using training and testing data shuffling and averaging accuracies
variable selection - apply thresholds to select variables
+ Hemo data set of leukemia patients who have been given hydroxyurea -> hemp.mat 


Hw1item4 - implement naive bayes estimator using leave one out cross validation method to determine which features were most significant in being able to predict responders vs non-responders

Hw1item5 - implement K-nearest neighbor estimator using 1 neighbor and leave one out cross validation to determine which features had most predictive power when determining responder vs non responder 



