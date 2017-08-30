function [A W] = LearnGraphStructure(dataset)

% Input:
% dataset: M x 10 x 3, M poses represented by 10 parts in (y, x, alpha)
% 
% Output:
% A: maximum spanning tree computed from the weight matrix W
% W: 10 x 10 weight matrix, where W(i,j) is the mutual information between
%    node i and j. 
%
% Copyright (C) Daphne Koller, Stanford Univerity, 2012

M = size(dataset,1);         % number of samples
N = size(dataset, 2);        % number of variables
D = size(dataset,3);         % number of dimensions

W = zeros(N, N);
% Compute weight matrix W
% set the weights following Eq. (14) in PA description
% you don't have to include M since all entries are scaled by the same M
%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE        
%%%%%%%%%%%%%%%%%%%%%%%%%%%
% in MI(Oi, Oj), size(Oi)= MxD, size(Oj)= MxD
for i = 1:N
    Oi = squeeze(dataset(:, i, :));      % dataset for the ith variable
    for j = 1:N
        Oj = squeeze(dataset(:, j, :));  % dataset for the jth variable
        W(i, j) =  GaussianMutualInformation(Oi, Oj);
    end
end

% Compute maximum spanning tree
A = MaxSpanningTree(W);

end