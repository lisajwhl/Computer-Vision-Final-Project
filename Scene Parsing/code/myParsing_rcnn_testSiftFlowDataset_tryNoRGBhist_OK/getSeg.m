function [ qrSet ] = getSeg(qrSet, path, segmentName, qImgName)

% INPUT
% qrSet:            structure, for a query img, this records retrival imgs' info
%                   with fields 'fileName', 'imagePath', 'labelImg','candidateLHist', 'candidateLInd',
% 
%                   'fileName':       file names of retrieval imgs
%                   'imagePath':      path of retrieval imgs
%                   'labelImg':       label version of retrieval img
%                   'candidateLHist': label histogram of all retrieval imgs(labels with 0 frequency also appear)
%                   'candidateLInd':  index of labels which do appear in retrievals
% 
% path:             structure, path for different data,
%                   with field 'HOMECODE', 'MainFolder', 'imagePath','labelImgPath', 'spPath'
% segmentName:      string, folder name that segments of imgs locate in
% qImgName:         string, query img name


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
%                             with fields 'imgName', 'location','feature'(cnn), 'rgbHist'
%                   'rSet':   structure, record retrieval region info, 
%                             with fields 'imgInd', 'location','feature'(cnn), 'rgbHist'
%                   'qSPnum': scalar, query region number
                 


    
    %tmp = importdata(fullfile(path.spPath,segmentName{1},[qImgName '.mat']));

    
    % load query img's all regions info
    tmp = struct2cell(load(fullfile(path.spPath,segmentName{1},[qImgName '.mat'])));
    tmp = tmp{1};
    
    % store query info in 'qSet' field in  qrSet
    qrSet.qSet.imgName = qImgName;
    qrSet.qSet.location = tmp{1};
    qrSet.qSet.feature = tmp{2};
    qrSet.qSet.rgbHist = tmp{3}; 
    
    % concatenate all retrieval regions' info
    % store in 'rSet' field in  qrSet
    qrSet.rSet.imgInd = [];
    qrSet.rSet.location = [];
    qrSet.rSet.feature = [];
    qrSet.rSet.rgbHist = []; 
    count = 0;
    
    
    for i=1:length(qrSet.fileName) %for each retrieval image
               
        %tmp = importdata(fullfile(path.spPath,segmentName{1},[qrSet.fileName{i} '.mat']));
        tmp = struct2cell(load(fullfile(path.spPath,segmentName{1},[qrSet.fileName{i} '.mat'])));
        tmp = tmp{1};
        num = size(tmp{1},2);
        
        qrSet.rSet.imgInd(count+1:count+num) = i;
        qrSet.rSet.location = [ qrSet.rSet.location , tmp{1}];
        qrSet.rSet.feature = [qrSet.rSet.feature , tmp{2}];
        qrSet.rSet.rgbHist = [qrSet.rSet.rgbHist , tmp{3}];
        count = count+num;
    end 
    
    % query img region num
    qrSet.qSPnum = size(qrSet.qSet.feature,2);
    
    
    
    
    
    
%%%%%%%%%%%%%%%%%%%%%
%     tmp = importdata(fullfile(path.spPath,segmentName{1},[qImgName '.mat']));
%     qrSet.qSet{1}.imgName = qImgName;
%     qrSet.qSet{1}.location = tmp{1};
%     qrSet.qSet{1}.feature = tmp{2};
%     qrSet.qSet{1}.rgbHist = tmp{3}; 
%     
% 
%     for i=1:length(qrSet.fileName) %for each retrieval image
%             tmp = importdata(fullfile(path.spPath,segmentName{1},[qrSet.fileName{i} '.mat']));
%             qrSet.rSet{i}.imgName = qrSet.fileName{i};
%             qrSet.rSet{i}.location = tmp{1};
%             qrSet.rSet{i}.feature = tmp{2};
%             qrSet.rSet{i}.rgbHist = tmp{3}; 
%     end
%     %qrSet.qSPnum = size(qrSet.qSet{1}.feature{1},2);
%     %qrSet.qSPnum = size(qrSet.qSet{1}.feature,2);
%%%%%%%%%%%%%%%%%%%%%



end

