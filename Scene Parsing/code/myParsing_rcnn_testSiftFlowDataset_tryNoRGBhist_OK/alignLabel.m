function [ resultL ] = alignLabel( resultL, path, qImgName )
    
    img=imread(fullfile(path.imagePath,[qImgName '.jpg']));
    I_gray=rgb2gray(img);
    %smooth the image by coherence filter:
    filted_I = CoherenceFilter(I_gray,struct('T',5,'rho',2,'Scheme','I', 'sigma', 1));
    %adjacent neighborhood  model:
    seg = graphSeg(filted_I, 0.5, 200, 2, 0);
    %k-nearest neighborhood model:
    %Lnn = graphSeg(filted_I, 0.5/sqrt(3), 50, 10, 1);
    
    %figure,imshow(label2rgb(seg));
    segNum = max(max(seg));
    
    for i=1:segNum
        p=find(seg==i);
        resultL(p) = mode(resultL(p));
    end

end

