function [labelCost ] = labelCostFunc()

    
    labelCo = cell2mat(struct2cell(load('LabelCoOccur_t1.mat')));
    %labelCo = load('LabelCoOccur.mat','LabelCoOccur');
    
labelCost = labelCo;   
%labelCost = labelCo(qrSet.candidateLInd,qrSet.candidateLInd);
    
end



