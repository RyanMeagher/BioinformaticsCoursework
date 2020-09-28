clear all;
clc;
load ('hemo.mat')


%omitting sex, and doing log(1+x transformation)  
% this is make data represent more of a normal distribution 

hemo=[log1p(hemo(:,1)) hemo(:,3:8) log1p(hemo(:,9:23))]
%hemo=[log1p(hemo(:,1)) hemo(:,3:8) hemo(:,9:23)]
%hemo=[log1p(hemo(:,1)) hemo(:,2:7) log1p(hemo(:,8:22))]
hemo=log1p(hemo)


label=[label(1,:);label(3:8,:);label(9:23,:)]
[n m]=size(hemo); 


data=(hemo-min(hemo))./(max(hemo)-min(hemo));
%y=[x(:,1) hemo(:,2:7) x(:,8:21) hemo(:,22)]
%data = (data - repmat(mean(data), [n,1]))./repmat(std(data),[n,1]);
%data = (hemo - repmat(mean(hemo), [n,1]))./repmat(std(hemo),[n,1]);
%data=[log(hemo(:,1)) hemo(:,2:15) log(hemo(:,16:17)) hemo(:,18:20) log(hemo(:,21)) hemo(:,22:23)]
%data(isinf(data))=0
eigen_threshold = 0.05;
contribution_threshold = 0.70;
[feature_score, feature_values, eigenvectors, eigenvalues ,variable_contribution] = KLExpand(data, eigen_threshold, contribution_threshold);

%indexing labels 
desired_label=label(variable_contribution(:,2),1)


variable_contribution





