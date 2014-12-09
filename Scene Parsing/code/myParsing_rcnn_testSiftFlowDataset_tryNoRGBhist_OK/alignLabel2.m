function [ resultL ] = alignLabel2( resultL, path, qImgName )
    
    tmp=load(fullfile(path.spPath,'superPixel_k50',qImgName));
    seg=tmp.seg;
    %figure,imshow(label2rgb(seg));
    segNum = max(max(seg));
    
    for i=1:segNum
        p=find(seg==i);
        resultL(p) = mode(resultL(p));
    end

end

