function factors = ChooseTopSimilarityFactors (allFactors, F)
% This function chooses the similarity factors with the highest similarity
% out of all the possibilities.
%
% Input:
%   allFactors: An array of all the similarity factors.
%   F: The number of factors to select.
%
% Output:
%   factors: The F factors out of allFactors for which the similarity score
%     is highest.
%
% Hint: Recall that the similarity score for two images will be in every
%   factor table entry (for those two images' factor) where they are
%   assigned the same character value.
%
% Copyright (C) Daphne Koller, Stanford University, 2012

% If there are fewer than F factors total, just return all of them.
if (length(allFactors) <= F)
    factors = allFactors;
    return;
end

% Your code here:
sizeAllFactors = size(allFactors, 1);
factorsVal = ones(sizeAllFactors, 1);       % to store all the allFactors.val(1)
factors = repmat(struct('var', [], 'card', [], 'val', []), F, 1);

for i = 1:sizeAllFactors
    factorsVal(i) = allFactors(i).val(1);
end

for i = 1:F
    [Y I] = max(factorsVal, [], 1);
    factors(i) = allFactors(I);
    factorsVal(I) = 1;
end

end

