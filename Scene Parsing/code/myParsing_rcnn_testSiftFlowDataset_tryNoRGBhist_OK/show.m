function [ perPixel_accuracy ] = show(qrSet , resultL, qImgName, path)

%resultImg = label2rgb(reshape(resultL,[256,256]));

figure, imshow(imread(fullfile(path.imagePath, [qImgName '.jpg'])));
title('Query');
gtL = load(fullfile(path.labelImgPath, [qImgName '.mat']));
gtLabelName = gtL.names;
gtLabelImg = gtL.S;

cLN = size(qrSet.candidateLInd, 1);
%labelColors = rand([cLN ,3]);
rng(150); % ?????
labelColors = rand([33, 3]);
%gtLabelName = ['unlabel' , gtLabelName];

figure 
hold on
for i = 1:33
    plot([0 0], 'LineWidth', 8, 'Color', labelColors(i,:))
end
%legend([gtL.names(qrSet.candidateLInd)]);
legend(gtL.names, 'Location', 'eastoutside');
RGB = label2rgb(gtLabelImg, labelColors, [0,0,0]);
imshow(RGB), title('Groundtruth');
hold off

figure
hold on
for i = 1:length(qrSet.candidateLInd)
    plot([0 0], 'LineWidth', 8, 'Color', labelColors(qrSet.candidateLInd(i), :));
end
legend([gtL.names(qrSet.candidateLInd)], 'Location', 'eastoutside');
%legend(gtL.names);
%RGB = label2rgb(resultL, labelColors(qrSet.candidateLInd,:), [0,0,0]);
RGB = label2rgb(resultL+1, labelColors, [0,0,0]);
imshow(RGB), title('Result');
hold off

perPixel_accuracy = length(find(gtLabelImg == (resultL+1))) / length(find(gtLabelImg ~= 0));

% figure
% legend(gtL.names(qrSet.candidateLInd));
% imshow(resultImg), title('scene parsing result');

end

