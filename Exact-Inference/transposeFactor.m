function C = transposeFactor (F, varList)
%*************************************************************************
% This function changes the order of F's variables according to varList but
% the cardinality and the value of the factor must be changed accordingly.
% *************************************************************************
assert(length(F.var) == length(varList), 'the input factor and the mandated variable ordering vector have different dimensions.\n');
a = F.var;
[dummy, mapF] = ismember(varList, a);   % mapF contains the columns of the varaibles in F in in order of varList 
C = F;                  % C means to copy the structure of factor F
C.var = varList;        % change to C.var to the intended order
C.card = F.card(mapF);  % C copies the cardinality of F in C's variable order

assignmentF = IndexToAssignment(1:prod(F.card), F.card);    % assignments of F
assignmentC = IndexToAssignment(1:prod(C.card), C.card);    % assignments of C
[dummy, indxF] = ismember (assignmentC, assignmentF(:, mapF), 'rows');      % the rows that are matched between C and F
C.val = F.val(indxF);   % indxF is the list of indices of assignments in F for C

end