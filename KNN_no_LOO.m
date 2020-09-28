clear all

score = [];
sens=[];
spec=[];
err=[];
dif=[];
dip=[];
for i = 1:100
        testingandtrainingdata;
    
        %x=[training_set(:,1) training_set(:,2) training_set(:,3) training_set(:,4) training_set(:,5) training_set(:,6) training_set(:,7) training_set(:,8)];
        %x=[training_set(:,1) training_set(:,2)];
        %x=[training_set(:,3) training_set(:,4) training_set(:,5)];
       x=[training_set(:,1:8)];
        Mdl = fitcknn(x,training_label, 'NumNeighbors',5);

        %resubstitution loss, which, by default, is the fraction of misclassifications from the predictions of Mdl.
        rloss = resubLoss(Mdl);

        %Construct a cross-validated classifier from the model.
        CVMdl = crossval(Mdl);

%Examine the cross-validation loss, which is the average loss of each cross-validation 
%model when predicting on data that is not used for training.
        kloss = kfoldLoss(CVMdl);

        %z=[testing_set(:,1) testing_set(:,2) testing_set(:,3) testing_set(:,4) testing_set(:,5) testing_set(:,6) testing_set(:,7) testing_set(:,8)];
        %z=[testing_set(:,2) testing_set(:,3) testing_set(:,4)];
        %z=[testing_set(:,1) testing_set(:,2)];
        %z=[testing_set(:,3) testing_set(:,4) testing_set(:,5)];
        z=[testing_set(:,1:8)];
        
        label = predict(Mdl,z);
        test_label = cellstr(testing_label);
        label= cellstr(label);

        CP = classperf(test_label, label);
      
        sc = [i; CP.CorrectRate*100];
        display(sc(2,:));     
        score=[score sc];
        
        sensitivity=[i; CP.Specificity*100];
        display(sensitivity(2,:)); 
        specificity=[i; CP.Sensitivity*100];
        display(specificity(2,:)); 
        error_rate=[i; CP.ErrorRate*100];
        display(error_rate(2,:));
        digfp=[CP.DiagnosticTable];
        digfn=[CP.DiagnosticTable];
        digfn=digfn(2,1);
        digfp=digfp(1,1);
        display(digfn());
        display(digfp());
        
        
        
        sens=[sens sensitivity];
        spec=[spec specificity];
        err=[err error_rate];
        dif=[dif (digfn/22)*100];
        dip=[dip (digfp/22)*100];
        
       
        
end

score';
mean(score(2,:));

sens';
mean(sens(2,:));
spec';
mean(spec(2,:));
err';
mean(err(2,:));
dif';
mean(dif(1,:));
dip'; 
mean(dip(1,:));


x=[mean(score(2,:)) mean(sens(2,:)) mean(spec(2,:)) mean(err(2,:)) mean(dif(1,:)) mean(dip(1,:))] 


   


