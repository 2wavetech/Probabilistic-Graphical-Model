%COMPUTEEXACTMARGINALSBP Runs exact inference and returns the marginals
%over all the variables (if isMax == 0) or the max-marginals (if isMax == 1). 
%
%   M = COMPUTEEXACTMARGINALSBP(F, E, isMax) takes a list of factors F,
%   evidence E, and a flag isMax, runs exact inference and returns the
%   final marginals for the variables in the network. If isMax is 1, then
%   it runs exact MAP inference, otherwise exact inference (sum-prod).
%   It returns an array of size equal to the number of variables in the 
%   network where M(i) represents the ith variable and M(i).val represents 
%   the marginals of the ith variable. 
%
% Copyright (C) Daphne Koller, Stanford University, 2012


function M = ComputeExactMarginalsBP(F, E, isMax)

% initialization
% you should set it to the correct value in your code
M = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%
% Implement Exact and MAP Inference.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Ctree = CreateCliqueTree(F, E);                    % create the clique tree using the factor list F
P = CliqueTreeCalibrate(Ctree, isMax);             % calibrate the tree
[idxCol, idxRow] = find(P.edges == 1);

varList = [];
% get all the variables
for i = 1:length(P.cliqueList)
    varList = union(varList, P.cliqueList(i).var); 
end

M = repmat(struct('var', [],'card', [], 'val', []), 1, length(varList));
%**************************************************************************
% for each variable, find its clique in the clique tree (i.e., the clique
% whose scope covers the variable). Anyone of such cliques will do, because
% they have the same marginal for the variable after convergence. Here the
% first such clique is used for marginalization and the result is in M.
%**************************************************************************
for i = 1:length(varList)
    for k = 1:length(P.cliqueList)
        if ~isempty(intersect(varList(i), P.cliqueList(k).var))
            break;
        end
    end
    if isMax == 0
        M(i) = FactorMarginalization(P.cliqueList(k), setdiff(P.cliqueList(k).var, varList(i)));
        %**********************************************************************
        % now perform normalization for every marginal in M
        %**********************************************************************
        for j =1:length(M)
            M(j).val = M(j).val / sum(M(j).val);
        end
    else
        M(i) = FactorMaxMarginalization(P.cliqueList(k), setdiff(P.cliqueList(k).var, varList(i)));
    end
end
end
