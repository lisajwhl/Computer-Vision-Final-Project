function [qrSet] = semRetrieval(resultL,trainSet,path,imgK)


    %para
    %k=4;


    %imagePath = 'SiftFlowDataset\Images\spatial_envelope_256x256_static_8outdoorcategories\';

    
    
    qImgFeature = resultL;
%figure,imshow(fullfile(imagePath,qImgName));

%retrieval
    
    sim = zeros(1,length(trainSet));
    for i=1:length(trainSet)
        tmp=load(fullfile(path.labelImgPath,trainSet(i).name));
        rImgFeature = double(tmp.S);
        sim(i) = length(find(rImgFeature~=qImgFeature));
    end

    [~,id] = sort(sim);
    for i=1:imgK
        rImgName = trainSet(id(i)).name;
        qrSet.fileName{i} = rImgName;
        %qrSet.id(i) = id(i);
        qrSet.imagePath{i} = fullfile(path.imagePath,[rImgName '.jpg']);
        qrSet.labelImg{i} = load(fullfile(path.labelImgPath,[rImgName '.mat']));
    end
    % id = retrival image index
    qLimg = qrSet.labelImg{1};
    allLnum = size(qLimg.names,2);
    
    candidateLHist=zeros(allLnum,1);
    for i=1:imgK
        %candidateL
        qLimg = qrSet.labelImg{i}.S;
        [H,W]=size(qLimg);
        pNum =H*W;
        candidateLHist = candidateLHist + histc(reshape(qLimg,[pNum,1]),[1:allLnum]);
    end
    qrSet.candidateLHist =candidateLHist;
    qrSet.candidateLInd = find(candidateLHist~=0);
    
    
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


end

