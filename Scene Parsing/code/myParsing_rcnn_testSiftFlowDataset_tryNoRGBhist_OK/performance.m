function [ perPixelAccuracy,cofusionMatrix,resultL, gtL] = performance( qrSet , resultL, rImgName, path,allLabelNum)


%resultImg = label2rgb(reshape(resultL,[256,256]));

gtLdata = load(fullfile(path.labelImgPath,[rImgName '.mat']));
gtLName = gtLdata.names;
gtL = gtLdata.S;


resultL = resultL+1;
perPixelAccuracy = length(find(gtL == (resultL))) / length(find(gtL~=0));

%%%perClass accuracy
resultL(find(gtL==0))=[];
gtL(find(gtL==0))=[];
gtL=double(gtL);

cofusionMatrix = zeros(allLabelNum,allLabelNum);
for i=1:length(gtL)
    cofusionMatrix(gtL(i),resultL(i)) = cofusionMatrix(gtL(i),resultL(i))+1;
end


% 
% correctPixelLocation = find(gtL==resultL);
% correctHist = hist(gtL(correctPixelLocation),[1:allLabelNum]);
% allHist = hist(gtL,[1:allLabelNum]);
% % 
% correctHist(find(allHist==0)) = [];
% allHist(find(allHist==0)) = [];
% 
% perClassAccuracy = sum(correctHist./allHist)/allLabelNum;



% figure
% legend(gtL.names(qrSet.candidateLInd));
% imshow(resultImg), title('scene parsing result');

end
