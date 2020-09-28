% Ryan Meagher
% BIOMI 600

% for my function I have an the three outputs desired from the homework,
% and also a variable contribution. This variable contribution is the
% desired variables and their associated index of the variables that
% account for most of the variance of all the feature space. Basically
% this means that it finds the variables that are uncorrelated with
% eachother. To find this I have inputs of the data representitive of a 
% n X m matrix, as well as the eigen_threshold which is a threshold that
% picks only those features that have a percentage contribution above the
% threshold, and finally a percent_contribution which tells the algorithem
% which variables to pick based on how representitive of the data they are.
% For example, say I wanted to get the variables that account for 90% of
% the variance of the data.

% the eig_threshold should be a value under 1 as it represents a percentage



function [feature_score, feature_values, eigenvectors, eigenvalues, variable_contribution] = KLExpand(data, eigen_threshold, contribution_threshold)

%n represents row m represents column
[n m]=size(data); 

%Scale/normalize the elements in each column by subtracting the mean. then normalize
%by dividing by standard deviation
%to do this could also use repmat or bsxfun

%scaled_data = (data - repmat(mean(data), [n,1]))./repmat(std(data),[n,1]);

%used to test between just using normalization and scaling
%data1=(data1-min(data1))./(max(data1)-min(data1));
scaled_data=data

%creating covarience matrix of the scaled data
cov_matrix=cov(scaled_data);
 
 %[V,D] = eig(A) returns matrices V and D. The columns of V present eigenvectors of A. 
 %The diagonal matrix D contains eigenvalues. If the resulting V has the same size as A, 
 %the matrix A has a full set of linearly independent eigenvectors that satisfy A*V = V*D.

[eigenvectors, eigenvalues] = eig(cov_matrix);
 
eigenvalues=diag(eigenvalues);
 
%sort the eigenvalues in decreasing order so that the most important
%eigenvalues are first, also indexed the eigenvectors so that the first
%eigenvalue after being sorted correlates with the first column of
%eigenvectors
 
[eigenvalues,feature_index]=sort(eigenvalues,'descend');
eigenvectors = eigenvectors(:,feature_index);


% finding The feature values the y, the feature values are not needed when
% reducing dimensionality, these represent individual measurement vectors 
% The larger the feature value the more important the feature is with
% respect to the respective variable data being analyzed 

feature_values = scaled_data * inv(eigenvectors);

% now we are trying to do feature selection by the equation
% ui=eigenvalues/sum(eigenvalues) from 1:n 

feature_score = ((eigenvalues / sum(eigenvalues)));

% this is where we set our eigen_threshold which only takes feature scores
% that has a percentage contribution above the threshold 
%the numeigvectors will be used to give a size for our new m dimensionality
% which we will use to calculate the percentage contribution of each
% variable


num_eigenvectors = find(feature_score < eigen_threshold,1);
if (isempty(num_eigenvectors))
    num_eigenvectors = size(feature_score,1);
end
    
%calculate the percentage contribution of each variable, based on the
%formulas given in lecture 15.


for i = 1:size(feature_score,1)
    variable_contribution(i) = abs(sum(eigenvectors(i,1:num_eigenvectors) * feature_score(1:num_eigenvectors, 1)));
end
variable_contribution = variable_contribution / sum(variable_contribution);

% ranks the variables
[variable_contribution,variable_index] = sort(variable_contribution,'descend');

runningsum = 0;
index = 1;


% This is where we input our contribution_threshold to allow us to choose the top variables
%that when added together make up this contribution_threshold

for i=1:size(variable_contribution,2)
    runningsum = runningsum + variable_contribution(i);
    if (runningsum < contribution_threshold)
        index = i;
    end
end

variable_contribution = [variable_contribution(1:index); variable_index(1:index)]';
end



 

    

    
    
 
    
    

