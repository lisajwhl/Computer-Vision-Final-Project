function [ perPixelAccuracy,cofusionMatrix,resultL, gtLabelImg ] = parsingFunc(qImgIndex,testSet,trainSet,path,allLabelNum,segmentName)

% INPUT
% qImgIndex:        scalar, query img index in dataset
% testSet/trainSet: structure, test/train img info,
%                   with field 'name' and 'imgFeature'(cnn)
% path:             structure, path for different data,
%                   with field 'HOMECODE', 'MainFolder', 'imagePath','labelImgPath', 'spPath'
% allLabelNum:      scalar, amount of all labels that may appear
% segmentName:      string, folder name that segments of imgs locate in

% OUTPUT
% perPixelAccuracy: scalar, per pixel accuracy of an img
% cofusionMatrix:   n*n matrix, confusion matrix, actual labels(1st dim) vs predicted labels(2nd dim)
%                   where n is allLabelNum
% resultL:          n by m matrix, estimated labels of testing img
%                   where n is number of pixels in 1st dim, m is number of pixels in 2nd dim  
% gtLabelImg:       1*m vector, ground truth label (excludes label '0')
%                   m is # of pixels in an img - # of pixels with ground truth label '0' 



%% Retrieval of Image

% load query img
qImgName = testSet(qImgIndex).name;
qImg = imread(fullfile(path.imagePath,[qImgName '.jpg']));

% retrieval img num
imgK = 40;

% retrieve imgs
tic
[ qrSet ] = retrieval(qImgIndex,testSet,trainSet,path,imgK);
toc


%% Retrieval of Region

% get query and retrieval img's region info
tic
[ qrSet ] = getSeg(qrSet, path, segmentName, qImgName);
toc


% for every region of query, retrieve spK most similar regions
spK = 30;
tic
[ qrSet] = spRetrieval(qrSet , spK);
toc



%% Propagate Labels

%unary
tic
[unary ] = unaryEnergy3( qrSet, allLabelNum,size(qImg),path, qImg); 
toc


%label cost
tic
[labelCost ] = labelCostFunc();
toc


% graph cut
lamda = 0.01;%0.01;

tic
[ resultL E Eafter ] = EFunc( qImg  ,unary ,labelCost*lamda);
resultL = resultL + 1;
toc


% smooth label
tic
[ resultL ] = alignLabel( resultL, path, qImgName );
toc


% performance of prediction
[ perPixelAccuracy,cofusionMatrix,resultL, gtLabelImg] = performance(qrSet,resultL-1, qImgName, path,allLabelNum);



% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% %retrieval
% fprintf('second...\n');
% tic
% [ qrSet2 ] = semRetrieval(resultL,trainSet,path,imgK);
% toc
% 
% 
% %get segmentation
% tic
% [ qrSet2 ] = getSeg(qrSet2, path, segmentName, qImgName);
% toc
% 
% 
% %sp retrieval
% tic
% [ qrSet2] = spRetrieval(qrSet2 , spK);
% toc
% 
% %fprintf('x');
% 
% %unary
% tic
% [unary ] = unaryEnergy3( qrSet2, allLabelNum,size(qImg),path, qImg); 
% toc
% 
% % p=fullfile('unary',sprintf('%d',qImgIndex));
% % save(p,'unary');
% 
% %label cost
% tic
% [labelCost ] = labelCostFunc();
% toc
% % unary = unary(qrSet.candidateLInd,:);%C by N
% % labelCost = labelCost(qrSet.candidateLInd,qrSet.candidateLInd);%C by C
% lamda = 0.01;%0.01;
% tic
% [ resultL E Eafter ] = EFunc( qImg  ,unary ,labelCost*lamda);
% resultL=resultL'+1;
% toc
% 
% %perform = show(qrSet,resultL, qImgName, path)
% 
% tic
% [ resultL ] = alignLabel( resultL, path, qImgName );
% toc
% 
% fprintf('tmpPA = %f\n',tmpPA);

% perform = show(qrSet,resultL-1, qImgName, path)


end

