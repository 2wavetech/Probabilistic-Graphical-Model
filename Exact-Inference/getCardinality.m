function cardList = getCardinality (F)
%**************************************************************************
% This function lines up all the variables of a factor uniquely and
% associates them with their corresponding cardinality. 
% F: a list of factors 
% cardList: a list of variables and their corresponding cardinality
%**************************************************************************
N = length(F);
cardList = struct('var', [], 'card', []);
cardList.var = unique([F(:).var]);
for i = 1:length(cardList.var)
    v = cardList.var(i);
    for j = 1:N
        idx = find(F(j).var == v, 1);
        if ~isempty(idx)
            cardList.card(i) = F(j).card(idx);
            break;
        end
    end
end
end