function loglikelihood = ComputeLogLikelihood(P, G, dataset)
% returns the (natural) log-likelihood of data given the model and graph structure
%
% Inputs:
% P: struct array parameters (explained in PA description)
% G: graph structure and parameterization (explained in PA description)
%
%    NOTICE that G could be either 10x2 (same graph shared by all classes)
%    or 10x2x2 (each class has its own graph). your code should compute
%    the log-likelihood using the right graph.
%

% dataset: N x 10 x 3, N poses represented by 10 parts in (y, x, alpha)
% 
% Output:
% loglikelihood: log-likelihood of the data (scalar)
%
% Copyright (C) Daphne Koller, Stanford Univerity, 2012

M = size(dataset,1); % number of examples
N = length(P.clg);   % number of body parts (pose), representing their poses
K = length(P.c);     % number of classes
dim = size(dataset, 3); % dimension of each variable (pose)

loglikelihood = 0;
% You should compute the log likelihood of data as in eq. (12) and (13)
% in the PA description
% Hint: Use lognormpdf instead of log(normpdf) to prevent underflow.
%       You may use log(sum(exp(logProb))) to do addition in the original
%       space, sum(Prob).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
logProbParts = zeros(N, dim);    % log probability of each body part (variable)
logProb = zeros(K, 1);

for i = 1:M                      % running through every data point
    X = reshape(dataset(i,:,:), N, dim);    % take an example from dataset, 10x3
    for k = 1:K                        % for each class type (human and alien)
        if size(G,3) > 1                   % if G is of size 10x2x2, i.e., different graph structure for each class
            U = reshape(G(:,:,k), N, K);   % take the graph for the kth class
        else                               % if G is of size 10x2
            U = G;  
        end
        for j = 1:N                    % for each variable, calculate log probability
            if U(j,1) == 0             % if the jth variable has no parents, go with Bayes Model
                mu_x = P.clg(j).mu_x(k);
                mu_y = P.clg(j).mu_y(k);
                mu_angle = P.clg(j).mu_angle(k);
            else                       % else, go with Combinational Linear Gaussian Model
                Opi = X(U(j, 2), :)';  % the jth variable's parent variable Opi, 3x1
                mu_y = P.clg(j).theta(k, 1:4)*[1; Opi];
                mu_x = P.clg(j).theta(k, 5:8)*[1; Opi];
                mu_angle = P.clg(j).theta(k, 9:12)*[1; Opi];
                % pay attention to the order of the dimensions - y comes before x
            end
            
            % calculate log probability of the pose of each body part
            logProbParts(j, 1) = lognormpdf(X(j,1), mu_y, P.clg(j).sigma_y(k));
            logProbParts(j, 2) = lognormpdf(X(j,2), mu_x, P.clg(j).sigma_x(k));
            logProbParts(j, 3) = lognormpdf(X(j,3), mu_angle, P.clg(j).sigma_angle(k));
        end
        
        logProb(k) = P.c(k) .* exp(sum(double(sum(logProbParts))));    % log_prob of classe type k
        % inner sum results in [log_prob(y), log_prob(x), log_prob(angle)] over all the variables
        % outer sum results in the sum of the log_prob of all the dimensions of variables
        % which is done because dimensions' log_prob are independent given their parent
    end
    
    loglikelihood = loglikelihood + log(sum(logProb));  % sum up likelihood over classes 

end

end