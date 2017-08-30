function accuracy = ClassifyDataset(dataset, labels, P, G)
% returns the accuracy of the model P and graph G on the dataset 
%
% Inputs:
% dataset: N x 10 x 3, N test instances represented by 10 parts
% labels:  N x 2 true class labels for the instances.
%          labels(i,j)=1 if the ith instance belongs to class j 
% P: struct array model parameters (explained in PA description)
% G: graph structure and parameterization (explained in PA description) 
%
% Outputs:
% accuracy: fraction of correctly classified instances (scalar)
%
% Copyright (C) Daphne Koller, Stanford Univerity, 2012

M = size(dataset, 1);
accuracy = 0.0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N = length(P.clg);               % number of body parts (poses, i.e., variables)
K = length(P.c);                 % number of classes (human and alien, e.g.)
dim = size(dataset, 3);          % dimension of each variable (pose)
logProbParts = zeros(N, dim);    % log probability of each body part (i.e., each variable)
jointProb = zeros(M, K);         % joint probability of a data point belonging to a certain class
 
for i = 1:M                                % running through every data point
    X = reshape(dataset(i,:,:), N, dim);   % take an example from dataset, 10x3
    for k = 1:K                            % for each class type (human and alien)
        if size(G,3) > 1                   % if G is of size 10x2x2, i.e., different graph structure for each class
            U = reshape(G(:,:,k), N, K);   % take the graph for the kth class
        else                               % if G is of size 10x2
            U = G;  
        end
        for j = 1:N                        % for each variable, calculate log probability
            if U(j,1) == 0                 % if the jth variable has no parents, go with Bayes Model
                mu_x = P.clg(j).mu_x(k);
                mu_y = P.clg(j).mu_y(k);
                mu_angle = P.clg(j).mu_angle(k);
            else                           % else, go with Combinational Linear Gaussian Model
                Opi = X(U(j, 2), :)';      % the jth variable's parent variable Opi, 3x1
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
        
         jointProb(i, k) = P.c(k) .* exp(sum(double(sum(logProbParts))));    % log_prob of classe type k
%         jointProb(i, k) = exp(sum(double(sum(logProbParts)))); 
        % inner sum results in [log_prob(y), log_prob(x), log_prob(angle)] over all the variables
        % outer sum results in the sum of the log_prob of all the dimensions of variables
        % which is done because dimensions' log_prob are independent given their parent
    end
end

classifications = floor(jointProb ./ max(jointProb,[], 2)); % MxK
right_class = (classifications == labels);
accuracy = sum(right_class(:,1))/M;
fprintf('Accuracy: %.2f\n', accuracy);

end