%COMPUTEINITIALPOTENTIALS Sets up the cliques in the clique tree that is
%passed in as a parameter.
%
%   P = COMPUTEINITIALPOTENTIALS(C) Takes the clique tree skeleton C which is a
%   struct with three fields:
%   - nodes: cell array representing the cliques in the tree.
%   - edges: represents the adjacency matrix of the tree.
%   - factorList: represents the list of factors that were used to build
%   the tree. 
%   
%   It returns the standard form of a clique tree P that we will use through 
%   the rest of the assigment. P is struct with two fields:
%   - cliqueList: represents an array of cliques with appropriate factors 
%   from factorList assigned to each clique. Where the .val of each clique
%   is initialized to the initial potential of that clique.
%   - edges: represents the adjacency matrix of the tree. 
%
% Copyright (C) Daphne Koller, Stanford University, 2012


function P = ComputeInitialPotentials(C)

% number of cliques
N = length(C.nodes);

% initialize cluster potentials 
P.cliqueList = repmat(struct('var', [], 'card', [], 'val', []), N, 1);
P.edges = zeros(N);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%
% First, compute an assignment of factors from factorList to cliques. 
% Then use that assignment to initialize the cliques in cliqueList to 
% their initial potentials. 

% C.nodes is a list of cliques.
% So in your code, you should start with: P.cliqueList(i).var = C.nodes{i};
% Print out C to get a better understanding of its structure.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1:N       
    P.cliqueList(i, 1).var = C.nodes{i};    % copy clique scope from C
end

P.edges = C.edges;                          % copy edges from C

%**********************************************************************
% Assign each factor to a clique node
%**********************************************************************
factorAssignments = zeros(1, length(C.factorList));
for j = 1:length(C.factorList)      % j = index to factorList
    i = 1;
    while i<=N                      % i = index to nodes
        if all(ismember(C.factorList(j).var, C.nodes{i}))   % find a node whose scope fully covers factor's variables
            factorAssignments(j) = i;                       % assign the jth factor to the ith node
            break;                                          % go to next factor
        else 
            i = i+1;
        end
    end
end

% factorAssignments = [ 1  8  3  7  9  6  1  2  3  4  5  6]

%**********************************************************************
% Calculate the initial potential of each clique node indexed by i
%**********************************************************************
for i = 1:N
    F = struct('var', [], 'card', [], 'val', []);
    
    indexFactorsOnClique = find(factorAssignments == i);    % get a list of factors assigned to clique i
    
    for j = 1:length(indexFactorsOnClique)                  % product of the factors on clique i
        %*************************************************************
        % align the order of variables of factor to that of clique i
        %*************************************************************
        [dummy, mapB] = ismember(C.nodes{i}, C.factorList(indexFactorsOnClique(j)).var);
        idx = find(mapB>0);
        varFactorInCliqueScope = C.nodes{i}(idx);
        factorC = transposeFactor(C.factorList(indexFactorsOnClique(j)), varFactorInCliqueScope);
                
        %*************************************************************
        % calculate factor product
        %*************************************************************
        F = FactorProduct(F, factorC);
            
    end

    P.cliqueList(i).val = F.val;        % store the result (value of initial potential of clique i) in P
  
end

%**********************************************************************
% Assign cardinality to the variables of each clique in P.cliqueList
%**********************************************************************
cardList = getCardinality(C.factorList);
for i=1:length(P.cliqueList)
    P.cliqueList(i).card = cardList.card(P.cliqueList(i).var);
end

end         % end of function