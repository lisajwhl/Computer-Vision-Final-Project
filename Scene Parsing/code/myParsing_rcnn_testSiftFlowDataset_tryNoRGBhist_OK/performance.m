function [ perPixelAccuracy,cofusionMatrix,resultL, gtL] = performance( qrSet , resultL, qImgName, path,allLabelNum)

% INPUT
% qrSet:            structure, records info of query-retrival img & query-retrival region 
%                   with fields for img, 'fileName', 'imagePath', 'labelImg', 'candidateLHist', 'candidateLInd'
%                   with fields for region, 'qSet' , 'rSet', 'qSPnum',
% 
%                   fields for img,
%                   'fileName':       file names of retrieval imgs
%                   'imagePath':      path of retrieval imgs
%                   'labelImg':       label version of retrieval img
%                   'candidateLHist': label histogram of all retrieval imgs(labels with 0 frequency also appear)
%                   'candidateLInd':  index of labels which do appear in retrievals
% 
%                   fields for region,
%                   'qSet':   structure, record query region info,
%                             with fields 'imgName', 'location','feature'(cnn), 'rgbHist'
%                   'rSet':   structure, record retrieval region info, 
%                             with fields 'imgInd', 'location','feature'(cnn), 'rgbHist'
%                   'qSPnum': scalar, query region number
% resultL:          n by m matrix, estimated labels of testing img
%                   where n is number of pixels in 1st dim, m is number of pixels in 2nd dim 
% qImgName:         string, query img name
% path:             structure, path for different data,
%                   with field 'HOMECODE', 'MainFolder', 'imagePath','labelImgPath', 'spPath'
% allLabelNum:      scalar, amount of all labels that may appear

% OUTPUT
% perPixelAccuracy: scalar, per pixel accuracy of an img
% cofusionMatrix:   n*n matrix, confusion matrix, actual labels(1st dim) vs predicted labels(2nd dim)
%                   where n is allLabelNum
% resultL:          n by m matrix, estimated labels of testing img
%                   where n is number of pixels in 1st dim, m is number of pixels in 2nd dim  
% gtL:              1*m vector, ground truth label (excludes label '0')
%                   m is # of pixels in an img - # of pixels with ground truth label '0' 



% load query img's ground truth labels
gtImg = load(fullfile(path.labelImgPath,[qImgName '.mat']));
gtLName = gtImg.names;
gtL = gtImg.S;
labelNum = length(qrSet.labelImg{1}.names);


%% Plot

%%% show query image
figure, imshow(imread(fullfile(path.imagePath, [qImgName '.jpg'])));
title('Query Image');

%%% show groundtruth labels of query image
figure ; hold on;

% random seeds
rng(150);

% random label color
labelColors = rand([labelNum, 3]);

% plot legend
for i = 1:labelNum
    plot([0 0], 'LineWidth', 8, 'Color', labelColors(i,:))
end
legend(gtLName, 'Location', 'eastoutside');

% ground truth label img
GtLabelImg = label2rgb(gtL, labelColors, [0,0,0]);
imshow(GtLabelImg), title('Ground Truth Image');
hold off


%%%  show predicted label img
figure; hold on;

% plot legend
for i = 1:length(qrSet.candidateLInd)
    plot([0 0], 'LineWidth', 8, 'Color', labelColors(qrSet.candidateLInd(i), :));
end
legend([gtLName(qrSet.candidateLInd)], 'Location', 'eastoutside');

% predicted label img
predictedLabelImg = label2rgb(resultL, labelColors, [0,0,0]);
imshow(predictedLabelImg), title('Result Image');
hold off

%% Accuracy

% perPixel accuracy
resultL = resultL+1;
perPixelAccuracy = length(find(gtL == (resultL))) / length(find(gtL~=0));

% perClass accuracy
resultL(find(gtL==0))=[];
gtL(find(gtL==0))=[];
gtL=double(gtL);

cofusionMatrix = zeros(allLabelNum,allLabelNum);
for i=1:length(gtL)
    cofusionMatrix(gtL(i),resultL(i)) = cofusionMatrix(gtL(i),resultL(i))+1;
end


% correctPixelLocation = find(gtL==resultL);
% correctHist = hist(gtL(correctPixelLocation),[1:allLabelNum]);
% allHist = hist(gtL,[1:allLabelNum]);
% % 
% correctHist(find(allHist==0)) = [];
% allHist(find(allHist==0)) = [];
% 
% perClassAccuracy = sum(correctHist./allHist)/allLabelNum;




end
