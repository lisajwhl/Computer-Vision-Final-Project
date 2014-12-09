function [ perPixel_accuracy ] = show(qrSet, resultL, qImgName, path)

% INPUT
% qrSet:             structure, information of query image and retrieval images
%                    with fields 'fileName', 'imagePath', 'labelImg', 'candidateLHist',
%                                'candidateLInd', 'qSet', 'rSet', 'qSPnum'
%                    'fileName':  k cells, name of each retrieval image
%                    'imagePath': k cells, path for each retrieval image
%                    'labelImg':  k cells, information for each retrieval image
%                                 each cell has a structure with fields 'names', 'S'
%                                 where 'names' is lables exist in this retrieval image,
%                                       'S' is pixels values of the retrieval image
% resultL:           H by W matrix, predicted labels of all pixels in query image
% qImgName:          string, query image name
% path:              structure, path for different data,
%                    with fields 'HOMECODE', 'MainFolder', 'imagePath', 'labelImgPath', 'spPath'             
%
% OUTPUT
% perPixel_accuracy: scalar, per-pixel accuracy of the query image


% show query image
figure, imshow(imread(fullfile(path.imagePath, [qImgName '.jpg'])));
title('Query');
gtL = load(fullfile(path.labelImgPath, [qImgName '.mat']));
gtLabelName = gtL.names;
gtLabelImg = gtL.S;

labelNum = length(qrSet.labelImg{1}.names);
rng(150);
labelColors = rand([labelNum, 3]);


% show groundtruth labels of query image
figure 
hold on
for i = 1:labelNum
    plot([0 0], 'LineWidth', 8, 'Color', labelColors(i,:))
end
legend(gtL.names, 'Location', 'eastoutside');
RGB = label2rgb(gtLabelImg, labelColors, [0,0,0]);
imshow(RGB), title('Groundtruth');
hold off


% show predicted labels of query image
figure
hold on
for i = 1:length(qrSet.candidateLInd)
    plot([0 0], 'LineWidth', 8, 'Color', labelColors(qrSet.candidateLInd(i), :));
end
legend([gtL.names(qrSet.candidateLInd)], 'Location', 'eastoutside');
RGB = label2rgb(resultL+1, labelColors, [0,0,0]);
imshow(RGB), title('Result');
hold off


% per-pixel accuracy of the query image
perPixel_accuracy = length(find(gtLabelImg == (resultL+1))) / length(find(gtLabelImg ~= 0));

end

