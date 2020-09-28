load('hemo.mat')
initial_hbf=hemo(:,10);
final_hbf=hemo(:,24);

percent_difference=final_hbf - initial_hbf;
indices = find(percent_difference<15.0);
responder(indices,1) = 'N';
indices = find(percent_difference>=15.0);
responder(indices,1) = 'Y';

Yes=hemo(responder(:,1) == 'Y', :);
No=hemo(responder(:,1) == 'N', :);


%loop through all 24 parameters
for i = 1:24 
 
    knn1 = fitcknn(hemo(:,i),responder,'NumNeighbors',1);
    
    cvknn1=crossval(knn1)
    
    class_error1=kfoldLoss(cvknn1)

    %create a random test data set the covers the entire range based on the
    %training data
    minValue = min(hemo(:,i));
    maxValue = max(hemo(:,i));
    X= minValue + (maxValue - minValue)*rand(1000,1);
    results = predict(knn1, X );

    predictYes=X(results(:,1) == 'Y', :);
    predictNo=X(results(:,1) == 'N', :);

    if ((size(predictYes,1) == 0) || (size(predictNo,1) == 0))
        disp(sprintf('Parameter %d, predicted all Yes or all No - cannot use', i));
        AccuracyArray(i,:) = { i 0 0 };
        continue
    end

    
    TP = length(find(results(:,1) == 'Y' & responder(:,1)=='Y'));
    FP = length(find(results(:,1) == 'Y' & responder(:,1)=='N'));
    FN = length(find(results(:,1) == 'N' & responder(:,1)=='Y'));
    TN = length(find(results(:,1) == 'N' & responder(:,1)=='N'));

    Accuracy = (TP + TN) / (TP + TN + FP + FN);
    ErrorRate = (FP + FN) / (TP + TN + FP + FN);
    knn1_AccuracyArray(i,:) = {i Accuracy ErrorRate};

    
end

knn1AccuracyArray = sortrows(AccuracyArray,-2);
knn1AccuracyArray
