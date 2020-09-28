
index2=find(knnleaveoneout_label=='Y');
knn_label(index2,1)=1;
index2=find(knnleaveoneout_label=='N');
knn_label(index2,1)=0;

knn=knnleaveoneout_data(:,1:8);


acc=[];
err=[];
for i=1:15

Mdl = fitcknn(knn,knn_label,'NumNeighbors',i,'Leaveout','on','BreakTies','nearest');


error_rate=kfoldLoss(Mdl);
accuracy=1-error_rate;
acc=[acc accuracy];
err=[err error_rate];



end







