load('hemo.mat')
initial_hbf=hemo(:,10);
final_hbf=hemo(:,24);

% find the percent difference to use as an index to find wether the patient
% responded to hydroxyurea or did not 
percent_difference=final_hbf - initial_hbf;

% use this to create a matrix of Y/N which will be used to make 2 matrix
% from the hemo data corresponding to responders and non-responders  
indices = find(percent_difference<15.0);
responder(indices,1) = 'N';
indices = find(percent_difference>=15.0);
responder(indices,1) = 'Y';

% model priori distribution patterns of positive and negative 
Yes=hemo(responder(:,1) == 'Y', :);
No=hemo(responder(:,1) == 'N', :);
priori_yes=size(Yes,1)/size(hemo,1);
priori_no=size(No,1)/size(hemo,1);

%loop through all 24 parameters to find out which have the best predictive
%power when trying to determine wether a patient will repond. This is done
% via modeling the distribution patterns and using a naive bayes estimator 
for i = 1:24 
 
    Mdl = fitcnb(hemo(:,i),responder);
    estimateNo = Mdl.DistributionParameters{1,1};
    estimateYes = Mdl.DistributionParameters{2,1};

    %create a random test data set the covers the entire range based on the
    %training data
    minValue = min(hemo(:,i));
    maxValue = max(hemo(:,i));
    X= minValue + (maxValue - minValue)*rand(1000,1);
    results = predict(Mdl , X );

    predictYes=X(results(:,1) == 'Y', :);
    predictNo=X(results(:,1) == 'N', :);

    if ((size(predictYes,1) == 0) || (size(predictNo,1) == 0))
        disp(sprintf('Parameter %d, predicted all Yes or all No - cannot use', i));
        AccuracyArray(i,:) = { i 0 0 };
        continue
    end

    %estimateYes & estimateNo hold mean and std dev.  use std dev to set
    %window.  dividing by 6 seemed to provide reasonable windows
    [pdfyes,xi] = ksdensity(predictYes,'kernel','normal','width', estimateYes(2,1)/6);
    [pdfno,yi] = ksdensity(predictNo,'kernel','normal','width', estimateNo(2,1)/6);

    pdfyes=priori_yes.*pdfyes;
    pdfno=priori_no.*pdfyes;
    figure();
    plot(xi,pdfyes);
    hold on;
    plot(yi,pdfno);
    title(sprintf('Parameter = %d', i));

    L1 = [xi;pdfyes];
    L2 = [yi;pdfno];
    P = InterX(L1,L2);
    threshold=P(1,1);
    
    % Confusion box metrics 
    TP = length(find(results(:,1) == 'Y' & X(:,1)<=threshold));
    FP = length(find(results(:,1) == 'Y' & X(:,1)>threshold));
    FN = length(find(results(:,1) == 'N' & X(:,1)<=threshold));
    TN = length(find(results(:,1) == 'N' & X(:,1)>threshold));

    Accuracy = (TP + TN) / (TP + TN + FP + FN);
    ErrorRate = (FP + FN) / (TP + TN + FP + FN);
    AccuracyArray(i,:) = {i Accuracy ErrorRate};
   
    disp(sprintf('Parameter %d, Accuracy = %2.2f%%, Error rate = %2.2f%%', i, Accuracy * 100, ErrorRate * 100));
end

AccuracyArray = sortrows(AccuracyArray,-2);
AccuracyArray
