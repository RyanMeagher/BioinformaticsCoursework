% Parse the Data
file='hemo.mat'; 
hemo_file=matfile(file);
varlist=who(hemo_file);
data=hemo_file.(varlist{1});
labels= hemo_file.(varlist{2});
Y = data(:, 24) > 15;
labels([25])=[];            
data(:, [24:25])=[];
%second set of variables:
X=data(:,[ 5:6 10 14 20]);
%first set of variables:
%X=data(:,[4 6 1 7 23 10 3 11]);
%use all variables:
%X=data
%combination of both sets:
%X=data(:,[4:7 1 23 10 14 11 20])

%Train a KNN model
k=2;
%for k=1:15
Mdl = fitcknn(X,Y,'NumNeighbors',k,'Leaveout','on','IncludeTies',true,'BreakTies','nearest');
error_rate=kfoldLoss(Mdl);
accuracy=1-error_rate;
disp('K is: ')
disp(k)
disp('The accuracy is: ')
disp(accuracy)
disp('--------')
%end
