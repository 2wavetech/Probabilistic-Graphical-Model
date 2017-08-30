function Ctree = creatCliqueTree (F, E)
%**************************************************************************
% Create a clique tree from a list of factors F. Each factor is assigned to
% a node of the clique tree (a node is loosely called a clique)and the 
% factors assigned to the same clique must do Factor Product and take into 
% account the evidence E for the product. Edges must be addedd between the 
% associated cliques, which is part of the created clique tree Ctree. Clique 
% tree is composed of a list of cliques and the edges between them. Edge is
% a matrix with cliques as its components and 1 for edge and 0 for no edge.
%**************************************************************************

Ctree = struct('node', struct([]), 'edge', [], 'factorList', struct([]));

varList = unique([F(:).var]);   % a list of variables
% C.card = zeros(1, length(varList));
factorList = {};           % a cell array of factor struct('var', [], 'card', [], 'val', []) for the tao list
newFactor = struct('var', [], 'card', [], 'val', []);
cliqueList = {};            % a cell array of factor struct('var', [], 'card', [], 'val', []);

scopeList = repmat(struct('var', []), length(F));
taoList = repmat(struct('var', []), length(varList));

for i=1:length(F)
   scopeList(i).var = F(i).var;
end
    
for i = 1:length(varList)
    v = varList(i);         % the variable to be "eliminated"
    %**********************************************************************
    % Find the scopes that cover v, indexed by scopeIndex to scopeList
    %**********************************************************************
    scopeIndex = [];
    indx = 1;
    for j = 1:length(scopeList)     % find the factors whose scope includes v
        if ~isempty(find(scopeList(j).var == v, 1))
            scopeIndex (indx) = j;  % the jth factor has the scope that includes v
            indx = indx+1;
        end
    end
    
    %**********************************************************************
    % the variables of the scopes for v are "unioned" to form the node of a
    % clique - remember that tao is to be "unioned" later on
    %**********************************************************************
    varUnion = [];
    if ~isempty(scopeIndex)
        for k = 1:length(scopeIndex)    % the scope of a node/clique
            [varUnion, iadump, ibdump] = union(varUnion, scopeList(scopeIndex(k)).var, 'stable');
            if size(varUnion, 1) ~= 1
                varUnion = varUnion';
            end
            scopeList(scopeIndex(k)).var = [];      % remove the factor so that it won't be considered by the next round
        end
        Ctree.node{i} = varUnion;
        if size(Ctree.node{i}, 1) ~= 1
            Ctree.node{i} = (Ctree.node{i})';
        end
    else
        Ctree.node{i} = [];
        if size(Ctree.node{i}, 1) ~= 1
            Ctree.node{i} = (Ctree.node{i})';
        end
    end
    %**********************************************************************
    % now we do the same on taoList, which is also a good time to add edge 
    %**********************************************************************
    if ~isempty(Ctree.node{i})
        taoList(i).var = setdiff(Ctree.node{i}, v);
    else
        taoList(i).var = [];
    end
    %**********************************************************************
    % Find the scopes of tao that cover v, indexed by taoIndex to taoList
    %**********************************************************************
    taoIndex = [];
    indx = 1;
    for j = 1:length(taoList)     % find the factors whose scope includes v
        if ~isempty(find(taoList(j).var == v, 1))
            taoIndex (indx) = j;  % the jth factor has the scope that includes v
            indx = indx+1;
        end
    end
    
    %**********************************************************************
    % the variables of the scopes for v are "unioned" to form the node of a
    % clique - remember that tao is to be "unioned" in next round
    %**********************************************************************
    varUnion = Ctree.node{i};
    if ~isempty(taoIndex)
        for k = 1:length(taoIndex)    % the scope of a node/clique
            [varUnion, iadump, ibdump] = union(varUnion, taoList(taoIndex(k)).var, 'stable');
            if size(varUnion, 1) ~= 1
                varUnion = varUnion';
            end
            Ctree.edge(i, taoIndex(k)) = 1;     % add an edge
            Ctree.edge(taoIndex(k), i) = 1;     % the edge must be symmetric diagonally
            taoList(taoIndex(k)).var = [];      % remove the factor so that it won't be considered by the next round
        end
        
        if size(varUnion, 1) ~= 1
           varUnion = varUnion';
        end
        Ctree.node{i} = varUnion;               % the new clique node
        if size(Ctree.node{i}, 1) ~= 1
           Ctree.node{i} = (Ctree.node{i})';
        end
        taoList(i).var = setdiff(Ctree.node{i}, v); % and a new tao is created for the next round
    end
    
end

end
