function [qrSet] = retrieval(qImgIndex,testSet,trainSet,path,imgK)

% INPUT
% qImgIndex:        scalar,query img's index in dataset
% testSet/trainSet: structure, test/train img info,
%                   with field 'name' and 'imgFeature'(cnn)
% path:             structure, path for different data,
%                   with field 'HOMECODE', 'MainFolder', 'imagePath','labelImgPath', 'spPath'
% imgK:             scalar, number of retrieval imgs 


% OUTPUT
% qrSet:            structure, for a query img, this records retrival imgs' info
%                   with fields 'fileName', 'imagePath', 'labelImg','candidateLHist', 'candidateLInd',
% 
%                   'fileName':       file names of retrieval imgs
%                   'imagePath':      path of retrieval imgs
%                   'labelImg':       label version of retrieval img
%                   'candidateLHist': label histogram of all retrieval imgs(labels with 0 frequency also appear)
%                   'candidateLInd':  index of labels which do appear in retrievals


   

    %% Rank Imgs by Similarity
    
    % load query img feature
    qImgFeature = testSet(qImgIndex).imgFeature;
	%figure,imshow(fullfile(imagePath,qImgName));
    
    
	% sim: similarity between query and all training imgs(euclidean dist)
    sim = zeros(1,length(trainSet));
    for i=1:length(trainSet)
        diff = trainSet(i).imgFeature-qImgFeature;
        sim(i) = norm(diff,2);
    end

	% rank training img according to similarity and record their info
    [~,id] = sort(sim);
    for i=1:imgK
	
		% name of img
        rImgName = trainSet(id(i)).name;
        qrSet.fileName{i} = rImgName;
        %qrSet.id(i) = id(i);
		
		% raw image
        qrSet.imagePath{i} = fullfile(path.imagePath,[rImgName '.jpg']);
		
		% ground truth label
        qrSet.labelImg{i} = load(fullfile(path.labelImgPath,[rImgName '.mat']));
    end
	
    
    
    %% Label Histogram of top Retrievals
    
	% all label amount
    qLimg = qrSet.labelImg{1};
    allLnum = size(qLimg.names,2);
    
    
    candidateLHist=zeros(allLnum,1);
    for i=1:imgK
        
        % retrieval's label img
        qLimg = qrSet.labelImg{i}.S;
                
        % pixel number of a retrieval
        [H,W]=size(qLimg);
        pNum =H*W;
        
        % add label histogram of retrieval
        candidateLHist = candidateLHist + histc(reshape(qLimg,[pNum,1]),[1:allLnum]);
    end
	
	% assign label histogram
    qrSet.candidateLHist =candidateLHist;
	
	% extract label index that do appear
    qrSet.candidateLInd = find(candidateLHist~=0);
    
    
    
    
    
    
%%%%%%%%%%%%%%%%%    
%     figure
%     for i=1:k
%         subplot(round(sqrt(k))+1,round(sqrt(k)),i), subimage(imread(qrSet.imagePath{i}));
%     end
    
    
%     figure
%     for i=2:k
%         rImgName = fileNameList{1,1}{id(i)};
%         rImg = imread([imagePath,rImgName]);
%         subplot(round(sqrt(k))+1,round(sqrt(k)),i), subimage(rImg);
%     end
%%%%%%%%%%%%%%%%% 

end

