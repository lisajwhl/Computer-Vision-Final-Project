close all;
%clear;
clc;

%% Set path
% current folder
path.HOMECODE = pwd;


% current ªº¤W¤@¼h folder
path.MainFolder = fullfile(path.HOMECODE,'..');


% raw images path 
path.imagePath = fullfile(path.MainFolder,'SiftFlowDataset','Images');


% ground truth label path
path.labelImgPath = fullfile(path.MainFolder,'SiftFlowDataset','SemanticLabels');


% images 'RCNN location & feature' path
path.spPath = fullfile(path.MainFolder,'segmentDesc');
% spDescName = {'allDesc_k50','allDesc_k100','allDesc_k200','allDesc_k400'};
%superPixelName = {'superPixel_k50','superPixel_k100','superPixel_k200','superPixel_k400'};
segmentName= {'SiftFlowRegion_singleType'};


% graph cut path
GCMex = fullfile(path.MainFolder,'GCMex');
addpath(GCMex);
addpath(genpath(fullfile(path.MainFolder,'GraphSeg')));

%% Load testing and training 

% all class number which may appear
allLabelNum = 33;

% load all img name and cnn features
fileName = importdata( fullfile(path.MainFolder,'fileNameList.mat') );
N = length(fileName);
imgFeature = num2cell( importdata(fullfile(path.MainFolder,'allImgFeature.mat')) , 1); %[dim,N]


% get testing image ID 
testName = (importdata('TestSet1.txt'))';
testId = find(ismember(fileName,testName));

% for later step, extract the name part of fileName ex. mountain.jpg -> mountain
for i=1:N 
    [~,fileName{i},~] = fileparts(fileName{i}); 
end


% separate train and test set 

% testSet
dataSet=struct('name',fileName,'imgFeature',imgFeature);
testSet  = dataSet(testId);

% trainSet
trainInd = 1:N;
trainInd(testId)=[];
trainSet = dataSet(trainInd);

%% Parsing

% parse every testing img

cofusionMatrix=zeros(allLabelNum,allLabelNum);
pixelAccuracy=zeros(length(testName),1);
for i=1:1 %length(testName)
        
    qImgIndex = i;
    
    
    tic
    [ pixelAccuracy(i),cM,resultL, gtL ] = parsingFunc(qImgIndex,testSet,trainSet,path,allLabelNum,segmentName);
	cofusionMatrix=cofusionMatrix+cM;
    fprintf('qImgIndex= %d, per-pixel accuracy = %f\n',qImgIndex,pixelAccuracy(i));
    toc
    
end
cAll=sum(cofusionMatrix,2);
correctNum = diag(cofusionMatrix);
correctNum (find(cAll==0))=[];
cAll(find(cAll==0))=[];
perClassAccuracy=sum(correctNum./cAll)/length(cAll)
perPixelAccuracy=mean(pixelAccuracy)



% 
% qImgIndex = 82;
% %14 good    0.8269/ 0.7833 /0.7832
% %154 bad    0.5220/ 0.5589 /0.5299
% 
% i=1;
% tic
% [perform(i)] = parsingFunc(qImgIndex,testSet,trainSet,path,allLabelNum,segmentName);
% fprintf('test image %d, qImgIndex= %d, per-pixel accuracy = %f  ',i,qImgIndex,perform(i));
% toc
