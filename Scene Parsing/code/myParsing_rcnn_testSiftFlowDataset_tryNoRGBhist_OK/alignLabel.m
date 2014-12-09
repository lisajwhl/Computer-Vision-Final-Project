function [ resultL ] = alignLabel( resultL, path, qImgName )
    
% INPUT
% resultL:  H by W matrix, labels of all pixels in query image
% path:     structure, path for different data,
%           with fields 'HOMECODE', 'MainFolder', 'imagePath', 'labelImgPath', 'spPath'
% qImgName: string, query image name
%
% OUTPUT
% resultL:  H by W matrix, smoothed labels of all pixels in query image

    % load query image
    img = imread(fullfile(path.imagePath, [qImgName '.jpg']));
    
    % change color channel to gray image
    I_gray = rgb2gray(img);
    
    % smooth the image by coherence filter
    filted_I = CoherenceFilter(I_gray, struct('T', 5, 'rho', 2, 'Scheme', 'I', 'sigma', 1));
    
    % adjacent neighborhood  model
    seg = graphSeg(filted_I, 0.5, 200, 2, 0);
    
    % k-nearest neighborhood model
    %Lnn = graphSeg(filted_I, 0.5/sqrt(3), 50, 10, 1);
    
    %figure, imshow(label2rgb(seg));
    
    % num if segments (max index of segments)
    segNum = max(max(seg));
    
    for i = 1:segNum % for each segment
        
        % get index of pixel belongs to the segment
        p = find(seg == i);
        
        % assign label of pixel which belongs to the segment as the most frequent label in the segment
        if (~isempty(p))
            resultL(p) = mode(resultL(p));
        end
    end

end

