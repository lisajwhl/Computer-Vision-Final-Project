function [ unary ] = unaryEnergy3( qrSet, allLabelNum, qImgSize, path, qImg )
    
% INPUT
% qrSet:       structure, information of query image and retrieval images
%              with fields 'fileName', 'imagePath', 'labelImg', 'candidateLHist',
%                          'candidateLInd', 'qSet', 'rSet', 'qSPnum'
%              'fileName':  k cells, name of each retrieval image
%              'imagePath': k cells, path for each retrieval image
%              'labelImg':  k cells, information for each retrieval image
%                           each cell has a structure with fields 'names', 'S'
%                           where 'names' is lables exist in this retrieval image, 'S' is pixels values of the retrieval image
% allLabelNum: scalar, amount of all labels that may appear
% qImgSize:    1 by 3 vector, size and color channel num of query image
% path:        structure, path for different data,
%              with fields 'HOMECODE', 'MainFolder', 'imagePath', 'labelImgPath', 'spPath'
% qImg:        n by m matrix, query image pixels values (RGB),
%              where n is image hight, m is image width (not used so far)
% OUTPUT
% unary:       allLabelNum by (n*m) matrix, unary term for each pixel in query image
%              with respect to each label,
%              where allLabelNum is # rows, (n*m) is # pixels in query image
    % total pixel number
    N = qImgSize(1)*qImgSize(2);
    
    % label(1st dim) vs all pixels(2nd dim) unary term initialize
    unary = zeros(allLabelNum, N);
    
    %%% ma's part
    unary_ma = zeros(allLabelNum, N);
    
    for i = 1:qrSet.qSPnum % for each query region
        for j = 1:size(qrSet.qSet.retInd, 1) % for each retrieval region
            
            %% Query Region Pixel Index  &  Retrieval Region Labels
            % index of ith query region's jth nearest neighbor retrieval region
            spRInd = qrSet.qSet.retInd(j, i);
            
            % img that this retrieval region is from
            imgInd = qrSet.rSet.imgInd(spRInd);
            
            % location of this retrieval region in retrieval img
            location = qrSet.rSet.location(:, spRInd); % [uppest row idx, lowest row idx, leftest col idx, rightest col idx]
            % load the retrieval img that this retrieval region locates at
            similarImg_label = importdata(fullfile(path.labelImgPath, [qrSet.fileName{imgInd} '.mat']));
            %figure, imshow(label2rgb(similarImg_label.S));
            
            % mask of the query region's location, where entris in the region is equal to 1, otherwise 0
            mask = zeros(size(similarImg_label.S));
            mask(qrSet.qSet.location(1,i):qrSet.qSet.location(2,i), qrSet.qSet.location(3,i):qrSet.qSet.location(4,i)) = 1;
            
            % pixel index of query region 
            query_index = find(mask == 1);
            
            %%% ma's part
            % mask of not region's location
            point = find(mask'==1);
            
            % get the retrieval region pixels from retrieval img which it locates at
            similarImg_label = similarImg_label.S(location(1):location(2), location(3):location(4));
            
            % resize this region to be the same size as query region
            similarImg_label = imresize(similarImg_label, [qrSet.qSet.location(2,i)-qrSet.qSet.location(1,i)+1, qrSet.qSet.location(4,i)-qrSet.qSet.location(3,i)+1], 'nearest');
            
            %%% ma's part
            similarImg = reshape(similarImg_label',[1, numel(similarImg_label)]);
            
            % reshape this region to be a row vector
            similarImg_label = reshape(similarImg_label,[1, numel(similarImg_label)]);
            
            %%% ma's part
            % ignore the part that img pixel value = 0
            point(similarImg'==0)=[];
            similarImg(similarImg'==0)=[];
            point=point';
            similarImg=double(similarImg);
            
            
            % ignore the part that retrieval label value = 0
            query_index(similarImg_label == 0) = [];
            query_index = query_index';
            similarImg_label(similarImg_label == 0) = [];
            similarImg_label = double(similarImg_label);
            
            %% Window Similarity
            
            % get features of query and neighbor region
            feat1 = qrSet.qSet.feature(:,i);
            feat2 = qrSet.rSet.feature(:,spRInd);
            
            % rgb Hist features of query and neighbor region
            rgbHist1 = qrSet.qSet.rgbHist(:,i);
            rgbHist2 = qrSet.rSet.rgbHist(:,spRInd);
            
            % similarity between query region and neighbor region
            windowSim = colorDis(feat1, feat2);
        
            %% Unary Term Update
            
            % parameter
            r1 = 0.38;
            r2 = 10000;
           
            % update unary term for location in region
            update_unary_idx = (query_index-1)*allLabelNum + similarImg_label;
            unary(update_unary_idx) = unary(update_unary_idx) - windowSim* (1./(qrSet.candidateLHist(similarImg_label)'.^r1)) * r2/numel(similarImg_label);
        
            %%% ma's part
            unary_ma((point-1)*33+similarImg) = unary_ma((point-1)*33+similarImg) - windowSim* (1./(qrSet.candidateLHist(similarImg)'.^r1)) * r2/numel(similarImg);
        
            
           

        end
    end
      
    % normalize unary to [-1,0]
	maxU = max(max(unary));
    minU = min(min(unary));
    diffU = maxU - minU;
    unary = (unary/diffU) - (minU/diffU) - 1;
    
end
function [dis] = colorDis( x , y )
    alpha = 0.1;
%     x=double(squeeze(x));
%     y=double(squeeze(y));
    dis = exp(-(norm(x-y,2))*alpha);
    %dis = exp(-sum((x-y).^2)/10000);
end