%GETNEXTCLIQUES Find a pair of cliques ready for message passing
%   [i, j] = GETNEXTCLIQUES(P, messages) finds ready cliques in a given
%   clique tree, P, and a matrix of current messages. Returns indices i and j
%   such that clique i is ready to transmit a message to clique j.
%
%   We are doing clique tree message passing, so
%   do not return (i,j) if clique i has already passed a message to clique j.
%
%	 messages is a n x n matrix of passed messages, where messages(i,j)
% 	 represents the message going from clique i to clique j. 
%   This matrix is initialized in CliqueTreeCalibrate as such:
%      MESSAGES = repmat(struct('var', [], 'card', [], 'val', []), N, N);
%
%   If more than one message is ready to be transmitted, return 
%   the pair (i,j) that is numerically smallest. If you use an outer
%   for loop over i and an inner for loop over j, breaking when you find a 
%   ready pair of cliques, you will get the right answer.
%
%   If no such cliques exist, returns i = j = 0.
%
%   See also CLIQUETREECALIBRATE
%
% Copyright (C) Daphne Koller, Stanford University, 2012


function [i, j] = GetNextCliques(P, messages)

% initialization
% you should set them to the correct values in your code
i = 0;
j = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N = size(P.edges, 1);
[idxCol, idxRow] = find(P.edges == 1);  % all of (idxRow, idxCol) of edges in P
for source = 1:length(idxRow)           % go through all the edges of each source clique
    i = idxRow(source);                 % i is the variable name of the source clique
    idxNeighbors = find(idxRow == i);   % all the edges with the same source variable
    idxNeighbors = idxCol(idxNeighbors);   % all the neighbors of the source clique
    j = idxCol(source);
    if isempty(messages(i,j).var)       % If source i has not already sent message to sink j
        % check whether all source's other neighbors than j have sent messages to i
        [Items, indxItems] = setdiff(idxNeighbors, j);
        if isempty(Items)               % if the source has only one neighbor, return (i, j)
            return;
        else
            allSent = 1;                % assume all other neighbors have sent messages to i
            for k = 1:length(Items)     % check if this assumption is true. Break for-loop if false.
                if isempty(messages(Items(k), i).var)
                    allSent = 0;
                    break;
                end
            end
            if allSent == 1
                return;                 % find next clique ready to send message from i to j, return (i, j)
            end
        end
    end
end
i = 0;
j = 0;
end

% for i = 1:N
%    for j = 1:N
%        if P.edges(i, j) == 1       % clique i is one of clique j's neighbors
%            if ~isempty(messages(i,j).var)  % If clique i has sent message to j
%                break;                      % go to next clique
%            end
            %**************************************************************
            % get the index of clique i's neighbors excluding j 
            %**************************************************************
 %           [dummy, idxNeighbors] = find (P.edges(i,:) == 1);
 %           [idxNeighbors, dummy] = setdiff(idxNeighbors, j);
 %          
 %           if isempty(idxNeighbors)    % if i has no other neighbors than j
 %               return;                 % return [i, j]
 %           else
                %*******************************************************************
                % check all the i's other neibors than j if they have sent messages to i
                %*******************************************************************
%              allMessages = 1;
%                 for k = 1:length(idxNeighbors)     
%                     if isempty(messages(idxNeighbors(k),i).var)
%                         allMessages = 0;
%                         break;
%                     end
%                 end
%                 if allMessages == 1
%                     return;
%                 end
%             end
%         end
%     end
% end
% i=0;
% j=0;
% end
