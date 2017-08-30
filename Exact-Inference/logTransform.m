
function F = logTransform(F)
%*******************************************************
% Tranform .val to log(.val) for the list of factors F
%*******************************************************
for i = 1:length(F)
    F(i).val = log(F(i).val); 
end
end