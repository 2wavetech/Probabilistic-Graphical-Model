% Copyright (C) Daphne Koller, Stanford University, 2012

function [MEU OptimalDecisionRule] = OptimizeLinearExpectations( I )
  % Inputs: An influence diagram I with a single decision node and one or more utility nodes.
  %         I.RandomFactors = list of factors for each random variable.  These are CPDs, with
  %              the child variable = D.var(1)
  %         I.DecisionFactors = factor for the decision node.
  %         I.UtilityFactors = list of factors representing conditional utilities.
  % Return value: the maximum expected utility of I and an optimal decision rule 
  % (represented again as a factor) that yields that expected utility.
  % You may assume that there is a unique optimal decision.
  %
  % This is similar to OptimizeMEU except that we will have to account for
  % multiple utility factors.  We will do this by calculating the expected
  % utility factors and combining them, then optimizing with respect to that
  % combined expected utility factor.  
  MEU = [];
  OptimalDecisionRule = [];

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %
  % YOUR CODE HERE
  %
  % A decision rule for D assigns, for each joint assignment to D's parents, 
  % probability 1 to the best option from the EUF for that joint assignment 
  % to D's parents, and 0 otherwise.  Note that when D has no parents, it is
  % a degenerate case we can handle separately for convenience.
  %
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  D = I.DecisionFactors(1);
  sumEUF = struct('var', [], 'card', [], 'val', []);
  for i = 1:length(I.UtilityFactors)
      I1U = I;
      I1U.UtilityFactors = I.UtilityFactors(i);      % take each individual utility ...
      EUF = CalculateExpectedUtilityFactor( I1U );   % and calculate its EUF
      sumEUF = FactorCombination (sumEUF, EUF);
  end
  
  EUF = sumEUF;
  OptimalDecisionRule = EUF;
  
  % parentsVar = setdiff(EUF.var, D.var(1));     % suppose that the 1st variable in D.var is the decision node
  indexD = find(EUF.var == D.var(1));            % where is D variable in var[]
  
  % assignments = ones(length(EUF.val), length(EUF.var));
  
  % for i = 1:length(EUF.val)                      % build the assignments for EUF
  %     assignments (i,:) = IndexToAssignment(i, EUF.card);
  % end
  assignments = IndexToAssignment(1:length(EUF.val), EUF.card);
  
  % assignments(:, indexD) = 0;       % make D's assignments insignificant so that only D's parents are compared
  [B, IB]  = setdiff(EUF.var, D.var(1), 'stable');     % B contains the variables in EUF except D
  [Dummy, mapB] = ismember(B, EUF.var);             % mapB is the list of indices of B in EUF.var
  indxB = AssignmentToIndex(assignments(:, mapB), EUF.card(:, mapB));
  
  % maxEUF = EUF.val(1);                            % initialize maxEUF
  EUF.val(:) = 0;                                   % initialize Decision Rules
  lengthEUF = length(EUF.val);
  indxRec = zeros(lengthEUF,1);                     % used to record the assignments that have already been gone though
  i = 1;
  while i <= lengthEUF                              % go through EUF val tables to decide D's values for MEU
      if ~isempty(find(indxRec == i))                          % if an assignment has been covered, ignore it.
          i = i+1;
          continue; 
      end
      
      idx = find(indxB == indxB(i));                % find the same assignments among D's parents
      if ~isempty(idx)
        indxRec = [indxRec; idx];                     % keep the record of the assignments already been found
      
        assig = ones (1, length(idx));                % this is used in order to call "max" to get the max EUF val
        for j = 1:length(idx)
            assig (j) = OptimalDecisionRule.val(idx(j));
        end
      
        [maxEUF, indexA] = max(assig);
        indxMaxEUF = idx(indexA);
        EUF.val(indxMaxEUF) = 1;                      % set the decision rule: D = 1 if it has the max EUF
      end
      i = i+1;
  end
  
  MEU = sum(EUF.val .* OptimalDecisionRule.val);
  OptimalDecisionRule = EUF;
  
end
