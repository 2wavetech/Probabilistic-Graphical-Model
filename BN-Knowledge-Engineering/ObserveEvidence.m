% ObserveEvidence Modify a vector of factors given some evidence.
%   F = ObserveEvidence(F, E) sets all entries in the vector of factors, F,
%   that are not consistent with the evidence, E, to zero. F is a vector of
%   factors, each a data structure with the following fields:
%     .var    Vector of variables in the factor, e.g. [1 2 3]
%     .card   Vector of cardinalities corresponding to .var, e.g. [2 2 2]
%     .val    Value table of size prod(.card)
%   E is an N-by-2 matrix, where each row consists of a variable/value pair. 
%     Variables are in the first column and values are in the second column.

function F = ObserveEvidence(F, E)

% Iterate through all evidence

for i = 1:size(E, 1)
    v = E(i, 1); % variable
    x = E(i, 2); % value

    % Check validity of evidence
    if (x == 0)
        warning(['Evidence not set for variable ', int2str(v)]);
        continue;
    end;

    for j = 1:length(F)     % F may contain multiple factors, everyone of which must be processed individually
		  % Does factor contain variable?
        indx = find(F(j).var == v);  % F(j) is the jth factor, and F(j).var is the list of variables of it, indx contains the indices array of the found elements
        
        if (~isempty(indx))          % if a variable is found
        
		  	   % Check validity of evidence
            if (x > F(j).card(indx) || x < 0 )      % the maximum value of the subscript of a varaible is determined by the variable's cardinality
                error(['Invalid evidence, X_', int2str(v), ' = ', int2str(x)]);
            end;

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % YOUR CODE HERE
            % Adjust the factor F(j) to account for observed evidence
            % Hint: You might find it helpful to use IndexToAssignment
            %       and SetValueOfAssignment
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            for k = 1:length(F(j).val)
                assignments = IndexToAssignment (k, F(j).card);
                if assignments(indx(1)) ~= x      % note that indx is not an integer but a list
                   F(j).val(k) = 0;
                end
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

				% Check validity of evidence / resulting factor
            if (all(F(j).val == 0))
                warning(['Factor ', int2str(j), ' makes variable assignment impossible']);
            end;

        end;
    end;
end;

end
