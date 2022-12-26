clear
close all
clc
rootFolder=fullfile('Database2');
categories={'Proliferate_DR','No_DR'};
imds=imageDatastore(fullfile(rootFolder,categories),'labelSource','foldernames');
 tbl=countEachLabel(imds);
[trainingSet,testSet]=splitEachLabel(imds,0.75,'randomize');
 
layer = [imageInputLayer([224 224 ]);
          convolution2dLayer(7,20,'Name','conv1');
          reluLayer('Name','relu1');
          convolution2dLayer(5,10,'Name','conv2');
          reluLayer('Name','relu2');
          maxPooling2dLayer(2,'Stride',2,'Name','maxpoo2');
          fullyConnectedLayer(2,'Name','fc1001');
          softmaxLayer('Name','soft1');
          classificationLayer()];
      Functions = {@plotTrainingAccuracy, ...
%     @(info) stopTrainingAtThreshold(info,90)
};
options = trainingOptions('sgdm','MaxEpochs',5,...
	'InitialLearnRate',0.0001,'OutputFcn', Functions);

net = trainNetwork(trainingSet,layer,options);

featureLayer=layer(6).Name;
trainingFeature=activations(net,trainingSet,featureLayer,'miniBatchSize',32,'outputAs','columns');

traininglabel=trainingSet.Labels;
Tran=dummyvar(double(traininglabel));
Tran=Tran';

classifier=fitcecoc(trainingFeature,traininglabel,...
    'learner','linear','coding','onevsall','observationsIn','columns');
predictlabel2=predict(classifier,trainingFeature,'observationsIn','columns');
pred=dummyvar(double(predictlabel2));
pred=pred';
figure
 plotconfusion(Tran,pred)
title('Training');

testFeature=activations(net,testSet,featureLayer,'miniBatchSize',32,'outputAs','columns');
predictlabel=predict(classifier,testFeature,'observationsIn','columns');
testlabel=testSet.Labels;
Ttest=dummyvar(double(testlabel));
Ttest=Ttest';
Tpredictlabel=dummyvar(double(predictlabel));
Tpredictlabel=Tpredictlabel';
figure
 plotconfusion(Ttest,Tpredictlabel)
 title('Testing')
accuracy=mean(predictlabel==testlabel);

% newimage=imread('Proliferate_DR-img87.png');
% imgfeature=activations(net,newimage,featureLayer,'miniBatchSize',32,'outputAs','columns');
% label=predict(classifier,imgfeature,'observationsIn','columns');
% sprintf('the loaded image beloge to %s class',label)
