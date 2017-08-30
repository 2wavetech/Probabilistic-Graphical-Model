%CLIQUETREECALIBRATE Performs sum-product or max-product algorithm for 
%clique tree calibration.

%   P = CLIQUETREECALIBRATE(P, isMax) calibrates a given clique tree, P 
%   according to the value of isMax flag. If isMax is 1, it uses max-sum
%   message passing, otherwise uses sum-product. This function 
%   returns the clique tree where the .val for each clique in .cliqueList
%   is set to the final calibrated potentials.
%
% Copyright (C) Daphne Koller, Stanford University, 2012

function P = CliqueTreeCalibrate(Ctree, isMax)

% Number of cliques in the tree.
N = length(Ctree.cliqueList);

if N == 0 || (isMax ~=1 && isMax ~= 0)
    error ( 'Wrong input parameters');
end

% Setting up the messages that will be passed.
% MESSAGES(i,j) represents the message going from clique i to clique j. 
MESSAGES = repmat(struct('var', [], 'card', [], 'val', []), N, N);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% We have split the coding part for this function in two chunks with
% specific comments. This will make implementation much easier.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% YOUR CODE HERE
% While there are ready cliques to pass messages between, keep passing
% messages. Use GetNextCliques to find cliques to pass messages between.
% Once you have clique i that is ready to send message to clique
% j, compute the message and put it in MESSAGES(i,j).
% Remember that you only need an upward pass and a downward pass.
%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
 %*************************************************************************
 % The first part of this program implements sum-product (when isMax = 0)
 % and max-sum (when isMax = 1) message calculation between every pair of
 % adjacent cliques => MESSAGES (i, j).
 %*************************************************************************
 i = inf;
 j = inf;
 Evidence = [];
[idxCol, idxRow] = find(Ctree.edges == 1);   % all of (idxRow, idxCol) of edges in P

%*************************************************************************
% in case Ctree.cliqueList has variables lined up in a column, turn them
% into a row for the sake of consistency
%*************************************************************************
for i = 1:length(Ctree.cliqueList)
    if size(Ctree.cliqueList(i).var, 1) ~= 1
        Ctree.cliqueList(i).var = Ctree.cliqueList(i).var';
    end
end

%*************************************************************************
% for max-sum message propagation, log-transform the clique factors first
%*************************************************************************
if isMax == 1
    Ctree.cliqueList = logTransform(Ctree.cliqueList);
end

P = Ctree;

while not(i ==0 && j ==0)
    [i, j] = GetNextCliques(Ctree, MESSAGES);
    if not (i==0 && j ==0)
        Ni = idxCol(find(idxRow == i)); % Ni: all the adjacent cliques of the ith clique, lined up in a column in Ni
        K = setdiff(Ni, j);             % K: all the other adjacent cliques than j, lined up in a column in K
        
        %******************************************************************
        % calculate the messages from cliques in K (messages from all other
        % neighbors than j)
        %******************************************************************
        for k = 1:length(K)
            if isMax == 0
                MESSAGES(i, j) = FactorProduct(MESSAGES(i, j), MESSAGES(K(k), i));
            else % isMax == 1
                MESSAGES(i, j) = FactorSum(MESSAGES(i, j), MESSAGES(K(k), i));
            end
        end
        
        %******************************************************************
        % calculate the final message from clique i to j
        %******************************************************************
        [Sij, idxPi, idxPj] = intersect(Ctree.cliqueList(i).var, Ctree.cliqueList(j).var, 'stable');   % Sij = common variables 1xn
        if isMax == 0
            MESSAGES(i, j) = ComputeMarginal(Sij, FactorProduct(Ctree.cliqueList(i), MESSAGES(i, j)), Evidence);
        else
            varMaxOut = setdiff(Ctree.cliqueList(i).var, Sij);
            MESSAGES(i, j) = FactorMaxMarginalization(FactorSum(Ctree.cliqueList(i), MESSAGES(i, j)), varMaxOut);
        end
    end
end
   

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%
% Now the clique tree has been calibrated. 
% Compute the final potentials for the cliques and place them in P.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%**************************************************************************
% The second part of this program calculates the belief of each clique
%**************************************************************************

for i = 1:length(Ctree.cliqueList)      % for every clique
    Ni = idxCol(find(idxRow == i));     % Ni: all the adjacent cliques of the ith clique
    for k = 1:length(Ni)
        if isMax == 0
            P.cliqueList(i) = FactorProduct(P.cliqueList(i), MESSAGES(Ni(k), i));
        else
            P.cliqueList(i) = FactorSum(P.cliqueList(i), MESSAGES(Ni(k), i));
        end
    end
end

% return
end
