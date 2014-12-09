function [ labels, E, Eafter ] = EFunc( data, unary, labelcost)

% INPUT
% data:      H by W matrix, query image pixels values (RGB)
%            where H is image hight, W is image width
% unary:     allLabelNum by (n*m) matrix, unary term for each pixel in query image
%            with respect to each label,
%            where allLabelNum is # labels (# row), (n*m) is # pixels in query image (# column)
% labelcost: C by C matrix, the weight of two labels being neighbor
%
% OUTPUT
% labels:    H by W matrix, labels of all pixels in query image
% E:         The energy of the initial labeling contained in CLASS
% Eafter:    The energy of the final labels LABELS
%
% ----------------------------------------------------------------------------------------------------------------------------
% GCMex: An efficient graph-cut based energy minimization
% [LABELS ENERGY ENERGYAFTER] = GCMex(CLASS, UNARY, PAIRWISE, LABELCOST,EXPANSION)
%   Parameters:
%     CLASS:       A 1xN vector which specifies the initial labels of each of the N nodes in the graph
%     UNARY:       A CxN matrix specifying the potentials (data term) for each of the C possible classes at each of the N nodes.
%     PAIRWISE:    An NxN sparse matrix specifying the graph structure and cost for each link between nodes in the graph.
%     LABELCOST:   A CxC matrix specifying the fixed label cost for the labels of each adjacent node in the graph.
%     EXPANSION:   A 0-1 flag which determines if the swap or expansion method is used to solve the minimization. 0 == swap, 
%                  1 == expansion. If ommitted, defaults to swap.
%  
%   Outputs:
%     LABELS:      A 1xN vector of the final labels.
%     ENERGY:      The energy of the initial labeling contained in CLASS
%     ENERGYAFTER: The energy of the final labels LABELS
% ----------------------------------------------------------------------------------------------------------------------------

    % size of query img
    [H, W, ~] = size( data );
    N = H * W;
    
    % labels num
    C = size(labelcost, 2);
    
    % initial labels of each node
    segclass = zeros(1, N);
    
    % initial pairwise cost between nodes
    pairwise = sparse(N, N);
    
%     unary = zeros(C, N);
%     [X, Y] = meshgrid(1:C, 1:C);
%     labelcost = min(4, (X - Y).*(X - Y));
% 
%     for row = 0:H-1
%         for col = 0:W-1
%             pixel = 1 + row*W + col;
%             if row + 1 < H
%                 pairwise(pixel, 1+col+(row+1)*W) = 1; 
%             end
%             if row - 1 >= 0
%                 pairwise(pixel, 1+col+(row-1)*W) = 1; 
%             end 
%             if col + 1 < W
%                 pairwise(pixel, 1+(col+1)+row*W) = 1; 
%             end
%             if col - 1 >= 0
%                 pairwise(pixel, 1+(col-1)+row*W) = 1; 
%             end 
%         end
%     end
    
    load('pairwise.mat');
    
    % assign labels to pixels of query img by GCMex
    [labels, E, Eafter] = GCMex(segclass, single(unary), pairwise, single(labelcost), 0);
    
    % reshape labels as the size of query img
    labels = reshape(labels, [H, W]);
    
%     fprintf('E: %d (should be 260), Eafter: %d (should be 44)\n', E, Eafter);
%     fprintf('unique(labels) should be [0 4] and is: [');
%     fprintf('%d ', unique(labels));
%     fprintf(']\n');

end

function [dis] = colorDis( x , y )
    x = double(squeeze(x));
    y = double(squeeze(y));
    dis = exp(-(norm(x-y,2))/10000);
end
