function [ labels E Eafter ] = EFunc( data ,unary ,labelcost)

    [H,W,~] = size( data );
    N=H*W;
    C=size(labelcost,2);
    segclass = zeros(N,1);
    pairwise = sparse(N,N);
%     unary = zeros(C,N);
%     [X Y] = meshgrid(1:C, 1:C);%%%
%     labelcost = min(4, (X - Y).*(X - Y));%%% C by C
% 
%     for row = 0:H-1
%       for col = 0:W-1
%         pixel = 1+ row*W + col;
% %         if row+1 < H, pairwise(pixel, 1+col+(row+1)*W) = colorDis(data(row+1,col+1,:), data(row+2,col+1,:)); end
% %         if row-1 >= 0, pairwise(pixel, 1+col+(row-1)*W) = colorDis(data(row+1,col+1,:), data(row,col+1,:)); end 
% %         if col+1 < W, pairwise(pixel, 1+(col+1)+row*W) = colorDis(data(row+1,col+1,:), data(row+1,col+2,:)); end
% %         if col-1 >= 0, pairwise(pixel, 1+(col-1)+row*W) = colorDis(data(row+1,col+1,:), data(row+1,col,:)); end
%     if row+1 < H, pairwise(pixel, 1+col+(row+1)*W) = 1; end
%     if row-1 >= 0, pairwise(pixel, 1+col+(row-1)*W) = 1; end 
%     if col+1 < W, pairwise(pixel, 1+(col+1)+row*W) = 1; end
%     if col-1 >= 0, pairwise(pixel, 1+(col-1)+row*W) = 1; end 
%       end
%     end
    
    % segclass is all pixel*1 zeroes: initial label
    % unary is label*all pixel : cost for every pixel of being certain label
    % pairwaise is all pixel*all pixel: specify graph relation and cost between link
    % label_cost is labe*label: specify cost of adjacent label
    load('pairwise.mat');
    
    [labels E Eafter] = GCMex(segclass, single(unary), pairwise, single(labelcost),0);
    
    labels = reshape(labels,[W,H]);
    
%     fprintf('E: %d (should be 260), Eafter: %d (should be 44)\n', E, Eafter);
%     fprintf('unique(labels) should be [0 4] and is: [');
%     fprintf('%d ', unique(labels));
%     fprintf(']\n');



end

function [dis] = colorDis( x , y )
%     x=squeeze(x);
%     y=squeeze(y);
    x=double(squeeze(x));
    y=double(squeeze(y));
    dis = exp(-(norm(x-y,2))/10000);
    %dis = exp(-sum((x-y).^2)/10000);
end
