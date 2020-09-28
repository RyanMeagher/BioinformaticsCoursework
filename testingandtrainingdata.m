load('hemo')

% scale age date
data= log1p(hemo());
data1=log1p(data());


final_hbf = hemo(:,24);
data1=(data1-min(data1))./(max(data1)-min(data1));
data1(:,24) = final_hbf;

%selected_params = [19 17 1 15 7 12 10 11 4 8 24];  % hw1item4
%selected_params = [3 6 8 1 5 13 15 11 12 19 10 23 4 24]; % hw1item5
%selected_params = [4 3 6 8 5 1 13 15 11 12 19 10 23 24];
%selected_params = [5 4 8 6 3 1 13 15 11 12 19 10 23 24];
selected_params = [4 6 1 7 23 10 3 11 24];
%selected_params = [1 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24];
%selected_params=[1 16 24];
%selected_params=[4 6 1 24];




final_hbf_index = size(selected_params, 2);

% reduce the data set to important parameters
hemo = data1(:, selected_params);

%finding index of patients >=15 and making a new array responder
index_responder=find(hemo(:,final_hbf_index)>=15.0);
responder(index_responder,1) = 'Y';
length(index_responder);

%finding index of patients < 15 HBF%and making a new array responder
index_nonresponder=find(hemo(:,final_hbf_index)<15.0);
responder(index_nonresponder,1) = 'N';
length(index_nonresponder);
length(responder);

Yes=hemo(responder(:,1) == 'Y', :);
length(Yes);
No=hemo(responder(:,1) == 'N', :);
length(No);

%shuffling rows so that we randomly select for testing and training
%patients

shuffledYes = Yes(randperm(size(Yes,1)),:);
shuffledNo = No(randperm(size(No,1)),:);

%42 patients that are responders use 25 for train 17 for test. If we use
%responders and 25 nonresponders in our training data. we will have 70% of
%the data allocated to the training data and 30% to test data. this leaves
%us with a training set with 50 patients with  equal rations of responders and non-responders
%and  a test set with 22, 5 of the 22 being non-responders. This leaves us with a training set containing 
% a ratio of 22% non-responders to 78% responders 

sizeYes_train=shuffledYes(1:25,:);
sizeYes_test=shuffledYes(26:42,:);
sizeNo_train=shuffledNo(1:25,:);
sizeNo_test=shuffledNo(26:30,:);

training_set=[sizeYes_train;sizeNo_train];
testing_set=[sizeYes_test;sizeNo_test];

%creating training label for knn
index=find(training_set(:,final_hbf_index)>=15.0);
training_label(index,1) = 'Y';
index=find(training_set(:,final_hbf_index)<15.0);
training_label(index,1) = 'N';

index=find(testing_set(:,final_hbf_index)>=15.0);
testing_label(index,1) = 'Y';
index=find(testing_set(:,final_hbf_index)<15.0);
testing_label(index,1) = 'N';

[n m]=size(training_set); 
[n1 m1]=size(testing_set); 

%normtrain=(training_set-min(training_set))./(max(training_set)-min(training_set));
%normtest=(testing_set-min(testing_set))./(max(testing_set)-min(testing_set));

knnleaveoneout_data=[training_set;testing_set]
knnleaveoneout_label=[training_label;testing_label]



