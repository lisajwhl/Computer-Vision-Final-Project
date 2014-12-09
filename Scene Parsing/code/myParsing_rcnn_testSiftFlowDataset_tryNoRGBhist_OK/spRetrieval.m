function [ qrSet ] = spRetrieval(qrSet,knn)

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
% knn:              scalar, number of retrival regions


% OUTPUT
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
%                             with fields 'imgName', 'location','feature'(cnn), 'rgbHist','retInd'
%                             'retInd': k*n vector, record index of most similar regions for each query region 
%                                       k is knn, n is number of query regions
%                   'rSet':   structure, record retrieval region info, 
%                             with fields 'imgInd', 'location','feature'(cnn), 'rgbHist'
%                             'imgInd': n*1 vector, specify indices of img that a retrieval region is from
%                                       n is number of all retrieval regions
%                   'qSPnum': scalar, query region number


    
     %% Rank Regions from Retrieval Imgs
     
    % dist between query region & retrieval imgs' regions
    
    % spDist: query region(1st dim), retrieval imgs' regions(2nd dim)
    spDist = zeros(qrSet.qSPnum,size(qrSet.rSet.feature,2));
    for i=1:qrSet.qSPnum
        for j=1:size(qrSet.rSet.feature,2)
            spDist(i,j) = norm(qrSet.qSet.feature(:,i) - qrSet.rSet.feature(:,j),2);
        end
    end
    
 
    % get top k similar regions
    [~,ind]=sort(spDist,2);
    ind = ind(:,1:knn);% [ query region num, knn]
    
    
    % index of most similar regions for each query region 
    qrSet.qSet.retInd = ind';% [ knn, query region num]

    
 
    
%%%%%%%%%%%
%     spN = size(qrSet.sp,2);
%     
%     spDist = inf(qrSet.qSPnum,spN-qrSet.qSPnum);
%     for i=1:qrSet.qSPnum
%         for j=qrSet.qSPnum+1:spN
%             spDist(i,j) = norm(qrSet.sp(i).feature - qrSet.sp(j).feature,2);
%         end
%     end
%     
%     
%     qImgSP = size(spDist,1);
%     for i=1:qImgSP
%         [~,ind]=sort(spDist(i,:));
%         ind = ind(1:knn);
%         qrSet.sp(i).retInd = ind; 
%     end
%%%%%%%%%%%




end