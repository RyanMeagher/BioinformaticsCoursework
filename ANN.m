clc
clear all
load('hemo.mat')

%transformation of data and scale/normalization
data=log1p(hemo);
data2=log1p(data);
data3=(data2-min(data2))./(max(data2)-min(data2));

%testing = 4,6,1,7,23,10,3,11 = 8 variables from KLExpansion
%testing = 5:6 10 14 20 = 5 variables from exhausted search
testing_data = (data3(:, [4,6,1,7,23,10,3,11]))';

%classify the responder and non-responder
FHBF_index = find(strcmp('FHbF', label)); %Find the index of FHBF

% Create targets parameter from training data for ANN - 15% critaria
for i = 1:length(hemo) 
    if hemo(i, FHBF_index)>=15
        target(1, i) = 1;
    else
        target(1, i) =0;
    end
end

% Create ANN 
%Delta rule is patternnet with [] and net.numLayers =1
%We change the neurons and layers according to test
net = patternnet(10);
net.numLayers = 5
%set training, validation and testing ratio
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 10/100;
net.divideParam.testRatio = 20/100;

%Train
[Net, TR] = train(net, testing_data, target);


y = Net(testing_data);
%Calculate performance
performance = perform(Net, target, y)
classes = vec2ind(y);
