function [unary ] = unaryEnergy2( qrSet, allLabelNum, qImgSize, path ,qImg)
    
    %qImgSeg = qrSet.seg{1};
    
    N = qImgSize(1)*qImgSize(2);
    %C = length(qrSet.candidateLInd);
    C = allLabelNum;
    
    unary = zeros(C,N);
    
    for i=1:qrSet.qSPnum%50 %for each queue sp

        spRInd = qrSet.qSet.retInd(i);
        imgInd = qrSet.rSet.imgInd(spRInd);
        location = qrSet.rSet.location(:,spRInd);
        
        similarImg = importdata(fullfile(path.labelImgPath, [qrSet.fileName{imgInd} '.mat']));
        
        mask = zeros(size(similarImg));
        mask(qrSet.qSet.location(1,i):qrSet.qSet.location(2,i),qrSet.qSet.location(3,i):qrSet.qSet.location(4,i))=1;
        point = find(mask'==1);
        
        similarImg = similarImg.S(location(1):location(2),location(3):location(4));
        similarImg = imresize(similarImg, [qrSet.qSet.location(2,i)-qrSet.qSet.location(1,i)+1, qrSet.qSet.location(4,i)-qrSet.qSet.location(3,i)+1],'nearest');
        similarImg = reshape(similarImg',[1,numel(similarImg)]);
        %%%%%%%%%%%%%%%%%%%
        feat1 = qrSet.qSet.feature(:,i);
        feat2 = qrSet.rSet.feature(:,spRInd);
        
        rgbHist1 = qrSet.qSet.rgbHist(:,i);
        rgbHist2 = qrSet.rSet.rgbHist(:,spRInd);

%         %%%
%         close all;
% rImg = imread(fullfile(path.imagePath, [qrSet.fileName{imgInd} '.jpg']));
% x=qrSet.qSet.location(3,i);
% y=qrSet.qSet.location(1,i);
% w=qrSet.qSet.location(4,i)-x;
% h=qrSet.qSet.location(2,i)-y;
% hold on
% imshow(qImg);
% rectangle('Position',[x,y,w,h],'LineWidth',2);
% hold off
% 
% x=location(3);
% y=location(1);
% w=location(4)-x;
% h=location(2)-y;
% hold on
% figure,imshow(rImg);
% rectangle('Position',[x,y,w,h],'LineWidth',2);
% hold off
% % 
% % 
% %         %%%

        windowSim = colorDis(feat1,feat2)*intersectionK(rgbHist1,rgbHist2);
        %windowSim = colorDis(feat1,feat2);
        %[colorDis(feat1,feat2),intersectionK(rgbHist1,rgbHist2),windowSim]%%
        
        point(find(similarImg==0))=[];
        similarImg(find(similarImg==0))=[];
        
        for j=1:length(point)
            c=similarImg(j);
            p=point(j);
            unary(c,p) = unary(similarImg(j),point(j))-windowSim* (1/(qrSet.candidateLHist(c)^0.38));
        end
        
%         fprintf('pause\n');
        
    end
    
	maxU = max(max(unary));
    minU = min(min(unary));
    diffU = maxU-minU;
    unary = (unary/diffU) - minU/diffU -1;

end

function [dis] = colorDis( x , y )
alpha=0.1;
%     x=double(squeeze(x));
%     y=double(squeeze(y));
    dis = exp(-(norm(x-y,2))*alpha);
    %dis = exp(-sum((x-y).^2)/10000);
end

