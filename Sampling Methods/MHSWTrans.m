% MHSWTRANS
%
%  MCMC Metropolis-Hastings transition function that
%  utilizes the Swendsen-Wang proposal distribution.
%  A - The current joint assignment.  This should be
%      updated to be the next assignment
%  G - The network
%  F - List of all factors
%  variant - a number (1 or 2) indicating the variant of Swendsen-Wang to use.  In variant 1,
%            all the q_{i,j}'s are equal
%
% Copyright (C) Daphne Koller, Stanford University, 2012

function A = MHSWTrans(A, G, F, variant)

%%%%%%%%%%%%%% Get Proposal %%%%%%%%%%%%%%
% Prune edges from q_list if the nodes don't have the same current value
q_list = G.q_list;
q_keep_indx = find(A(q_list(:, 1)) == A(q_list(:, 2))); % whether the two nodes on an edge have the same assignment
q_list = q_list(q_keep_indx, :);    % the edges left
% Select edges at random based on q_list
selected_edges_q_list_indx = find(q_list(:, 3) > rand(size(q_list,1), 1)); % activate randomly (prob.= qij) some edges left
selected_edges = q_list(selected_edges_q_list_indx, 1:2); % the pairs of nodes on each activated edge 
% Compute connected components over selected edges
SelEdgeMat = sparse([selected_edges(:,1)'; selected_edges(:,2)'],...   
                    [selected_edges(:,2)'; selected_edges(:,1)'],...
                    1, length(G.names), length(G.names));
%  S = sparse (i, j, v) => S(i(k),j(k)) = v(k), in which i is the row, and
%  j is the column. In the case above, i and j each has two rows, and
%  spare() puts 1 at (i(k), j(k)) of S twice, i.e., for the first row of i
%  and j, and for the 2nd row of i and j. This is the way to get, say,
%  S(1, 5) =1 and symmetrically S(5, 1) = 1

[var2comp, cc_sizes] = scomponents(SelEdgeMat); 
% var2comp is a list of components that each variables belongs to. 
% E.g., var2comp(1) = 1 means that variable X1 belongs to the 1st component.
%       var2comp(5) = 1 means that variable X5 belongs to the 1st component.
%       Apparently, X1 and X5 are in the same component.
% cc_sizes is a list of the numbers of variables that belong to the same
% component. E.g., cc_sizes = [2 10 1 1 1 1]', which means that the 2nd
% component has 10 variables in it, and the 1st component has 2, etc. The
% length of cc_sizes is the overall number of components.
num_cc = length(cc_sizes);  % the number of components

% Select a connected component (the book calls this Y)
selected_cc = ceil(rand() * num_cc);           % pick up one of the connected components randomly
selected_vars = find(var2comp == selected_cc); % the variables that belong to the selected component
% Check that the dimensions are all the same and they have the same current assignment
assert(length(unique(G.card(selected_vars))) == 1);   % if the variables in the selected components have the same cardinality
assert(length(unique(A(selected_vars))) == 1);    % if the variables in the selected components have the same assignment 

% Pick a new label via sampling
old_value = A(selected_vars(1));
d = G.card(selected_vars(1));
LogR = zeros(1, d);
if variant == 1
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % YOUR CODE HERE Specify the log of the distribution (LogR) from which
    % a new label for Y is selected for the 1st variant of Swendsen-Wang
    % Algorithm
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    LogR(:) = -length(selected_vars)* log(d);      
    % raw uniform distribution is 1/power(d, length(selected_vars))

%**************************************************************************
% I was  trying to calculate log_QY-ratio myself but just realized that
% I was only asked to provide LogG here.
%**************************************************************************
%    Xl = find(A==old_value);
%    Xl_Y = (setdiff(Xl, selected_vars));
%    OtherVarsConnected = Xl_Y(find(G.edges(selected_vars, Xl_Y)));
%    EdgesNotActivated = zeros(length(selected_vars) * length(OtherVarsConnected), 2);
%    for i = 1:length(selected_vars)
%        for j = 1:length(OtherVarsConnected)
%            EdgesNotActivated(i*j, :) = [selected_vars(i), OtherVarsConnected(j)];
%        end
%    end
%    EdgesNotActivated = sort(EdgesNotActivated, 'descend');
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif variant == 2
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % YOUR CODE HERE
    % Specify the log of the distribution (LogR) from 
    % which a new label for Y is selected for variant 2
    %
    % We suggest you read through the preceding code
    % before implementing this, one of the generated
    % data structures may be useful in implementing this section
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    LogR = BlockLogDistribution(selected_vars, G, F, A);
%     LogR = BlockLogDistributionOld(selected_vars, G, F, A);
%    assign = IndexToAssignment(1:length(selected_vars), G.card(selected_vars));
%    LogR = LogR(find(assign(:,1) == assign(:,2)))/sum(LogR);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
else
    disp('WARNING: Unrecognized Swendsen-Wang Variant');
end

% Sample the new value from the distribution R using function
% randsample(V,n,true,distribution) that returns a set of n values sampled
% at random from the integers 1 through V with replacement using
% distribution 'distribution'
new_value = randsample(d, 1, true, exp(LogR));
% if new_value ~= old_value
%    disp ('New Value Proposed')
% end
% new_value = randsample(d, length(selected_vars), true, exp(LogR));
A_prop = A;
A_prop(selected_vars) = new_value;      % the whole x' is set by  updating only Y

% Get the log-ratio of the probability of picking the connected component Y given A_prop over A
log_QY_ratio = 0.0;
for i = 1:size(G.q_list, 1)  % Iterate through *all* edges, not just the ones we selected earlier
    u = G.q_list(i, 1);
    v = G.q_list(i, 2);
    if length(intersect([u, v], selected_vars)) == 1  % the edge is from Y to outside-Y
        if A(u) == old_value && A(v) == old_value
            log_QY_ratio = log_QY_ratio - log(1 - G.q_list(i, 3));
        end
        if A_prop(u) == new_value && A_prop(v) == new_value
            log_QY_ratio = log_QY_ratio + log(1 - G.q_list(i, 3));
        end
    end
end

p_acceptance = 0.0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
% Compute acceptance probability
%
% Read through the preceding code to understand
% how to find the previous and proposed assignments
% of variables, as well as some ratios used in computing
% the acceptance probabilitiy.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% log_R_ratio = BlockLogDistribution(selected_vars, G, F, A_prop) - BlockLogDistribution(selected_vars, G, F, A);
log_R_ratio = LogR(old_value) - LogR(new_value);
log_Pi_ratio = LogProbOfJointAssignment(F, A_prop) - LogProbOfJointAssignment(F, A);
log_acceptance = log_QY_ratio + log_R_ratio + log_Pi_ratio;
% log_acceptance = log_QY_ratio;
p_acceptance = min(1, exp(log_acceptance));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Accept or reject proposal
if rand() < p_acceptance
%    disp('Accepted');
    A = A_prop;
% else
%    disp('Rejected');
end



