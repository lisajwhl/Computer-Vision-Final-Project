function [unary ] = unaryEnergy( qrSet, allLabelNum, qImgSize, path )
    
    %qImgSeg = qrSet.seg{1};
    
    N = qImgSize(1)*qImgSize(2);
    %C = length(qrSet.candidateLInd);
    C = allLabelNum;
    
    unary = zeros(C,N);
    
    for i=1:qrSet.qSPnum %for each queue sp
        spRInd = qrSet.qSet.retInd(i);
        imgInd = qrSet.rSet.imgInd(spRInd);
        location = qrSet.rSet.location(:,spRInd);
        
        similarImg = importdata(fullfile(path.labelImgPath, [qrSet.fileName{imgInd} '.mat']));
        
        mask = zeros(size(similarImg));
        mask(location(1):location(2),location(3):location(4))=1;
        point = find(mask==1);
        
        similarImg = similarImg.S(location(1):location(2),location(3):location(4));
        similarImg = reshape(similarImg,[numel(similarImg),1]);
        %%%%%%%%%%%%%%%%%%%
        feat1 = qrSet.qSet.feature(:,i);
        feat2 = qrSet.rSet.feature(:,spRInd);
        
        rgbHist1 = qrSet.qSet.rgbHist(:,i);
        rgbHist2 = qrSet.rSet.rgbHist(:,spRInd);
        
        windowSim = colorDis(feat1,feat2)*intersectionK(rgbHist1,rgbHist2);
        
        for j=1:length(point)
            if(similarImg(j)~=0)
                unary(similarImg(j),point(j)) = unary(similarImg(j),point(j))-windowSim;
            end
        end
%         fprintf('pause\n');
        
    end
    


end

function [dis] = colorDis( x , y )
alpha=0.1;
%     x=double(squeeze(x));
%     y=double(squeeze(y));
    dis = exp(-(norm(x-y,2))*alpha);
    %dis = exp(-sum((x-y).^2)/10000);
end

