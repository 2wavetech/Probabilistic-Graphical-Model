% Copyright (C) Daphne Koller, Stanford University, 2012

function EUF = CalculateExpectedUtilityFactor( I )

  % Inputs: An influence diagram I with a single decision node and a single utility node.
  %         I.RandomFactors = list of factors for each random variable.  These are CPDs, with
  %              the child variable = D.var(1)
  %         I.DecisionFactors = factor for the decision node.
  %         I.UtilityFactors = list of factors representing conditional utilities.
  % Return value: A factor over the scope of the decision rule D from I that
  % gives the conditional utility given each assignment for D.var
  %
  % Note - We assume I has a single decision node and utility node.
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %
  % YOUR CODE HERE...
  %
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  

% In this function, we assume there is only one utility node.
  EUF = struct('var', [], 'card', [], 'val', []);

  F = [I.RandomFactors I.UtilityFactors];     % don't forget to add utility as VE is over random factors times utility factors
%  F = I.RandomFactors;
  U = I.UtilityFactors(1);
    
  % allVar = unique([I.RandomFactors(:).var]);
  allVar = unique([F(:).var]);
  [Z,Z1]  = setdiff(allVar, I.DecisionFactors.var); 
  Fnew = VariableElimination(F, Z);
  parentsU = struct('var', [], 'card', [], 'val', []);    % used to build the final joint distribution over U's parents
  for numFactors = 1:length(Fnew)
      parentsU = FactorProduct(parentsU, Fnew(numFactors));
  end
  % if (length (parentsU.val) == length (U.val)) 
  %  EUF = times(parentsU.val, U.val);
  % end
  EUF = parentsU;
end  
